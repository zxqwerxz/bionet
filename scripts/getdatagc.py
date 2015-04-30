#!/usr/bin/python
"""
This script requires the following to be installed:
    Python 2.7
    BioPython
"""

import sys, csv, os, re, subprocess

#from Bio import SeqIO
#from Bio.SeqUtils import GC
#from Bio.Seq import Seq

import Queue  # or queue in Python 3
import threading, time
import numpy as np
import pandas as pd

class PrintThread(threading.Thread):
    def __init__(self, queue, outfile):
        threading.Thread.__init__(self)
        self.queue = queue
        self.outfile = outfile
	
    def run(self):
    	f = open(self.outfile, "w")
        while True:
            result = self.queue.get()
            f.write("\t".join(map(str, result)) + "\n")
            f.flush()
            self.queue.task_done()
        f.close()

class ProcessThread(threading.Thread):
    def __init__(self, in_queue, out_queue):
        threading.Thread.__init__(self)
        self.in_queue = in_queue
        self.out_queue = out_queue

    def run(self):
        while True:
            path = self.in_queue.get()
            result = self.process(path)
            self.out_queue.put(result)
            self.in_queue.task_done()

    def process(self, path):
        # Do the processing job here        
        sample = os.path.basename(path).split(".")[0]
        fname = sample + ".fasta"
        if not os.path.isfile(fname):
        	subprocess.call("fastq-dump --fasta " + path, shell=True)
        
        handle = open(fname, "rU")
        gclist = []
    	for line in handle:
            if not line.startswith(">"):
            	gcCount = 0
            	gcCount = len(re.findall("[GC]", line))
            	gcFraction = float(gcCount) / (len(line)-1)
            	gclist.append(gcFraction)
        handle.close()
        time.sleep(1)
        s = pd.Series(gclist)
        subprocess.call("rm -f " + fname, shell=True)
        return s.describe()

def main(argv):

    # Parse Args
    if len(sys.argv) != 4:
        sys.stderr.write("Usage: python " + sys.argv[0] + " <data_directory> <outfile> <num threads>\n")
        sys.exit(2)
     
    mypath = sys.argv[1]
    outfile = sys.argv[2]
    num_threads = sys.argv[3]

    filelist = []
    for file in os.listdir(mypath):
        if file.endswith(".sra"):
            filelist.append(os.path.join(mypath, file))

    print filelist
    
		
    pathqueue = Queue.Queue()
    resultqueue = Queue.Queue()
    paths = filelist

    # spawn threads to process
    for i in range(0, int(num_threads)):
        t = ProcessThread(pathqueue, resultqueue)
        t.setDaemon(True)
        t.start()

    # spawn threads to print
    t = PrintThread(resultqueue, outfile)
    t.setDaemon(True)
    t.start()

    # add paths to queue
    for path in paths:
        pathqueue.put(path)

    # wait for queue to get empty
    pathqueue.join()
    resultqueue.join()	


# Execute this module as a command line script
if __name__ == "__main__":
    main(sys.argv[1:])
