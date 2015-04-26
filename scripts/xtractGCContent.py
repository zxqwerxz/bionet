#!/usr/bin/python
"""
This script requires the following to be installed:
    Python 2.7
    BioPython
"""

from __future__ import division

import sys, csv

from Bio import SeqIO
from Bio.SeqUtils import GC
from Bio.Seq import Seq

# Parse Args
if len(sys.argv) != 4:
    sys.stderr.write("Usage: python " + sys.argv[0] + " <fasta> <Large Matrix File> <UCSC geneSymbol-geneID mapping>\n")
    exit(2)
fasta = sys.argv[1]
matrix = sys.argv[2]
names = sys.argv[3]

# Set dinucleotides
di = ["AA", "AC", "AG", "AT",
      "CA", "CC", "CG", "CT",
      "GA", "GC", "GG", "GT",
      "TA", "TC", "TG", "TT",
]

# Read gene symbols into memory
geneName = {}
with open(names) as csvfile:
     r = csv.reader(csvfile, delimiter="\t")
     headers = r.next()
     for row in r:
         geneName[row[0]] = row[1].upper()

# Read sample names into memory
samplelist = []
with open(matrix) as csvfile:
    r = csv.reader(csvfile, delimiter="\t")
    headers = r.next()
    for row in r:
        samplelist.append(row[0].upper())

print samplelist

# Read fasta
try:
    handle = open(fasta, "rU")
except:
    sys.stderr.write(fasta + " was not found.\n")
print "GeneID\tGeneName\tGCContent\tLength\t" + "\t".join(di)
for record in SeqIO.parse(handle, "fasta") :
    if geneName[record.id] in samplelist:
        seq = record.seq.upper()
        transcript = record.id + "\t" + geneName[record.id] + "\t" + str(GC(seq)) + "\t" + str(len(seq)) 
    
        # Count occurences of each dinucleotide
        counts = {}
        l = 0
        for i,c in enumerate(seq):
            if i+1 < len(seq):
                pair = c + seq[i+1]
                if pair in counts:
                    counts[pair] += 1
                else:
                    counts[pair] = 1
        for k in di:
            try: 
                transcript += "\t" + str(counts[k]/(len(seq)-1))
            except KeyError:
                transcript += "\t0"
        print transcript
handle.close()
