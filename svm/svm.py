#!/usr/bin/env python

from sklearn import svm, cross_validation

train = "strainthis.tsv"

# These are the training values
X = []
Y = []

with open(train) as f:
    counter = 0
    for line in f:
        row = line.strip("\n").split("\t")
        if counter == 0:
            header = row
            print ",".join(header)
            for entry in header:
                print entry
                if entry == '"S12"' or entry=='"S13"' or entry=='"S16"':
                    Y.append(1)
                else:
                    Y.append(0)
                X.append([])
            print str(len(X))
        else:
            for i in range(1, len(row)):
                X[i-1].append(row[i])
        counter += 1

X = X[0:18]
Y = Y[0:18]

print ", ".join(map(str, Y))

clf = svm.SVC()
clf.fit(X, Y)

scores = cross_validation.cross_val_score(clf, X, Y, cv=3)
print ", ".join(map(str, scores))
