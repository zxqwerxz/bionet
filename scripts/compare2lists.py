#1/usr/bin/bash
"""
This program assumes there is headers to both lists
"""

import sys, csv

# Parse Args
if len(sys.argv) != 5:
    sys.stderr.write("Note: This program assumes both files has headers\n")
    sys.stderr.write("Usage: python " + sys.argv[0] + " <file1> <file1column> <file2> <file2column>\n")
    exit(2)
file1 = sys.argv[1]
col1 = int(sys.argv[2])
file2 = sys.argv[3]
col2 = int(sys.argv[4])

# Read file1 into memory
list1 = []
with open(file1) as csvfile:
    r = csv.reader(csvfile, delimiter="\t")
    headers = r.next()
    for row in r:
        list1.append(row[col1].upper())

# Read file2 into memory
list2 = []
with open(file2) as csvfile:
    r = csv.reader(csvfile, delimiter="\t")
    headers = r.next()
    for row in r:
        list2.append(row[col2].upper())

#Print Differences
print "List1 - List2:\t" + str(len(list(set(list1)-set(list2))))
print "List2 - List1:\t" + str(len(list(set(list2)-set(list1))))
