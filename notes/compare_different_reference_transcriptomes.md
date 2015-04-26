I tried comparing different reference genomes
=============================================

Because my initial trial with aligning didn't have very comparable results
with the published data. Try was run with bash scripts overnight on April
26th.

I noticed at some point that I was actually aligning single end, because
I didn't split the fastq files properly when I extracted them from sra.
So basically this is a metric of the entire alignment process.

Bowtie: UCSC KnownGene mRNA fasta MM9 (Attempt 1)
-------------------------------------------------

Bash Script: (Failed)

    #!/usr/bin/bash

    # Bowtie index is already prepared

    # Run bowtie o3p2 is fastest
    time bowtie -p 2 -q --phred33-quals -S -n 2 -e 99999999 -l 25 -I 1 -X 1000 -a -m 200 offset3/knownGeneMM9 -1 SRR936367_1.fastq -2 SRR936367_2.fastq | samtools view -bS - > SRR936367.bam

    # Prepare rsem reference
    time rsem-prepare-reference knownGeneMM9.fa knownGeneMM9

    # Calculate Expression (w/Bowtie)
    # It looks like the rsem defaults match with their bowtie options
    time rsem-calculate-expression --paired-end --num-threads 2 SRR936367_1.fastq SRR936367_2.fastq knownGeneMM9 SRR936367

Bowtie Align (I think it worked)

RSEM build (I think it worked)

RSEM expression (Failed)

    Could not locate a Bowtie index corresponding to basename "knownGeneMM9"

RSEM: UCSC KnownGene(GTF) + KnownIsoforms (txt)
-----------------------------------------------

Bash Script:

RSEM build stderr: (Not tracked)

RSEM expression Stderr:

    real 88m12.134s
    user 63m49.503s
    time 26m18.204s

Bowtie: UCSC Transcriptome fasta MM9 (Attempt 1)
------------------------------------------------

Bash Script: (Failed)

Bowtie build stderr:

    No output file specified!
	
Bowtie align stderr:

    Could not locate a Bowtie index corresponding to basename "transcriptomeMM9"

RSEM build stderr: Interrupt (Fail)

Bowtie: UCSC KnownGene mRNA fasta MM9 (Attempt 2)
-------------------------------------------------

Bash Script:

RSEM Align:

    [bam_sort_core] merging from 6 files...
    real 43m16.445s
    user 28m52.561s
    sys 12m55.645s


Bowtie: UCSC Transcriptome fasta MM9 (Attempt 2)
------------------------------------------------

Bash Script:

Bowtie build stderr:

Bowtie align stderr:

RSEM build stderr: Interrupt (Fail)
