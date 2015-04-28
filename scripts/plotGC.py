#!/usr/bin/python

import sys, csv
#import matplotlib.pyplot as plt
#import numpy as np
import random

# Parse Args
if len(sys.argv) != 3:
    sys.stderr.write("Usage: python " + sys.argv[0] + " <Large Matrix> <allGenesGCcontent.tsv>\n")
    exit(2)
matrix = sys.argv[1]
gc = sys.argv[2]

# Read gc values into memory
gcdict = {}
with open(gc) as csvfile:
    r = csv.reader(csvfile, delimiter="\t")
    headers = r.next()
    for row in r:
        gene = row[1].upper()
        gc_content = float(row[2])/100
        gcdict[gene] = gc_content

# Begin reading large matrix
x = []
y = []
with open(matrix) as csvfile:
    r = csv.reader(csvfile, delimiter="\t")
    headers = r.next()
    for row in r:
        gene = row[0].upper()
        #x.append(gcdict[gene])
        c = 0
        for i in range(1, len(row)):
            print str(gcdict[gene]) + "\t" + str(row[i])
            #c += np.log(float(row[i]) + 1)
        #y.append(np.divide(c,len(row)-1))

"""
# Make Figure
fig = plt.figure(figsize=(8,6))
ax = fig.add_subplot(1,1,1)
ax.scatter(x,y, s=3, marker='.', c='000', alpha=0.3)
ax.set_title("GC Content vs. TPM")
ax.set_xlabel("GC Content")
ax.set_ylabel("Average ln(TPM+1) by Gene")
fig.savefig("gc_tpm.png")
"""
