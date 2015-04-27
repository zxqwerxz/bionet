#!/usr/bin/python

import sys, csv

# Parse Args
if len(sys.argv) != 3:
    sys.stderr.write("Usage: python " + sys.argv[0] + " <GCcontentfile> <CanonicalGeneList>\n")
    exit(2)
gc = sys.argv[1]
can = sys.argv[2]

# Read canonical list into memory
# If the gene is seen twice, set it to false
candict = {}
with open(can) as csvfile:
    r = csv.reader(csvfile, delimiter="\t")
    headers = r.next()
    for row in r:
        gene = row[1].upper()
        gid = row[0]
        if gene in candict:
            candict[gene] = False
        else:
            candict[gene] = gid

# Read GClist into memory
gcdict = {}
with open(gc) as csvfile:
    r = csv.reader(csvfile, delimiter="\t")
    headers = r.next()
    print "\t".join(headers)
    for row in r:
        gene = row[1].upper()
        gid = row[0]
        if gene not in gcdict:
            gcdict[gene] = []

        if gene in candict and candict[gene]==gid:
            # This gene has only 1 cannocal transcript
            gcdict[gene].append(row)
        elif gene in candict and candict[gene] is not False:
            # Do nothing for the rest of transcripts with 1 cannonical trans
            pass
        else:
            # This gene has multiple cannonical transcripts
            # Or this gene has no cannonical transcripts
            gcdict[gene].append(row)

# With list in memory
for key in gcdict:
    if len(gcdict[key]) < 1:
        raise ValueError("This gene has no associated value.")
    if len(gcdict[key]) == 1:
        print "\t".join(gcdict[key][0])
    else:
        # We need to find the median length transcript
        transcript_lengths = []
        for row in gcdict[key]:
            transcript_lengths.append((row[3], row))
        transcript_lengths.sort(key=lambda x: x[0])
        i = len(transcript_lengths) / 2
        median = transcript_lengths[i][1]

        # I'm using a lazy median, meaning I'm rounding up on even lists
        print "\t".join(median)
