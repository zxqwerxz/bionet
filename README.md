Biological Networks Project
===========================

Links
-----

* [new paper](http://www.nature.com/nature/journal/v510/n7505/full/nature13437.html)
* [dataset](http://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GSE48968)
* [comprehensive list of samples](http://www.ncbi.nlm.nih.gov/Traces/study/?acc=SRP027537)


Programs
--------

### Extracting GC Content for all genes ###

First program extracts GC content for all genes in UCSC, but the program runs too long
so don't even bother trying to use it.

    python get_gc.py <UCSC fasta file> <UCSC geneSymbol-geneID mapping>
    
Then I wrote a program that only calculates the GC content for genes that were in our
experiment.

    python xtractGCContent.py <fasta> <Large Matrix File> <UCSC geneSymbol-geneID mapping>
    
Then I realized that the output of this program had multiple entries for every gene,
which means the knownGenes mRNA table had multiple forms of every gene. This needs to be
condensed into a mean transcript list.

First thing I did was download the knownCanonical list and compare how well these two
mapped. I needed a mapping program, so I wrote one. Here is a test of it working:

    python compare2lists.py <file1> <file1column> <file2> <file2column>
    
    python compare2lists.py ../../GSE48968_allgenesTPM_GSM1189042_GSM1190902.txt 0 ../../knownGeneMM9id.tsv 1
    List1 - List2:	0
    List2 - List1:	2148

    python compare2lists.py ../../GSE48968_allgenesTPM_GSM1189042_GSM1190902.txt 0 ../../knownGeneMM9can.tsv 1
    List1 - List2:	436
    List2 - List1:	474
    
As you can tell, the mapping isn't perfect. At this point, I figured I might as well just
calculate the median (length) gene?



Experiments
-----------

###Step 4: Calculate Expression###

Install:
* rsem

Prepare rsem reference from fasta:

     rsem-prepare-reference knownGeneMM9.fa knownGeneMM9
     
     # Stderr output (very fast)
     rsem-synthesis-reference-transcripts knownGeneMM9 0 0 knownGeneMM9.fa
     Transcript Information File is generated!
     Group File is generated!
     Extracted Sequences File is generated!
     
     rsem-preref knownGeneMM9.transcripts.fa 1 knownGeneMM9 -l 125
     Refs.makeRefs finished!
     Refs.saveRefs finished!
     knownGeneMM9.idx.fa is generated!
     knownGeneMM9.n2g.idx.fa is generated!

Run rsem:

     time rsem-calculate-expression --bam o3p1.bam knownGeneMM9 sample1
     
     Bam output file is generated!
     Time Used for EM.cpp : 0 h 26 m 44 s
     
     samtools sort -@ 1 -m 1G sample1.transcript.bam sample1.transcript.sorted
     [bam_sort_core] merging from 10 files...
     
     samtools index sample1.transcript.sorted.bam
     rm -rf sample1.temp
     
     real 37m54.496s
     user 35m4.118s
     sys 0m57.585s

The problem is, the output files don't seem to match precisely.

