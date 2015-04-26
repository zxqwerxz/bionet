#!/usr/bin/bash

import sys, csv

# Parse Args
if len(sys.argv) != 5:
    sys.stderr.write("Usage: python " + sys.argv[0] + " <GCcontentfile> <CanonicalGeneList>\n")
    exit(2)
gc = sys.argv[1]
can = sys.argv[3]

# Read canonical list into memory
# If the gene is seen twice, set it to false
candict = {}
with open(can) as csvfile:
    r = csv.reader(csvfile, delimiter="\t")
    headers = r.next()
    for row in r:
        gene = row[1].upper()
        id = row[0]
        if gene in candict:
            candict[gene] = False
        else:
            candict[gene] = id

# Read GClist into memory
gcdict = []
with open(gc) as csvfile:
    r = csv.reader(csvfile, delimiter="\t")
    headers = r.next()
    for row in r:
        gene = row[1].upper()
        id = row[0]
        if gene in candict and candict[gene] is not False:
            
        list2.append(row[col2].upper())
