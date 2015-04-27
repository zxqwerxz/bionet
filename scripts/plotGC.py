#!/usr/bin/python

import sys, csv
import matplotlib, pylab

# Parse Args
if len(sys.argv) != 3:
    sys.stderr.write("Usage: python " + sys.argv[0] + " <Large Matrix> <allGenesGCcontent.tsv>\n")
    exit(2)
matrix = sys.argv[1]
gc = sys.argv[2]

# Read canonical list into memory
# If the gene is seen twice, set it to false
gcdict = {}
with open(gc) as csvfile:
    r = csv.reader(csvfile, delimiter="\t")
    headers = r.next()
    for row in r:
        gene = row[1].upper()
        gc_content = int(row[2])
        gcdict[gene] = gc_content
x = []
y = []
with open(matrix) as csvfile:
    r = csv.reader(csvfile, delimter="\t")
    headers = r.next()
    for row in r:
        
