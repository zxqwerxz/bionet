Biological Networks Project
===========================

Links
-----

* [new paper](http://www.nature.com/nature/journal/v510/n7505/full/nature13437.html)
* [dataset](http://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GSE48968)
* [comprehensive list of samples](http://www.ncbi.nlm.nih.gov/Traces/study/?acc=SRP027537)

Downloading Data
----------------

### Step 1: ascp ###

I downloaded ascp and added the command line tool to path (inside the application 
folder). I am currently using a mac so I do not know if this will be different
for other computers.

We are using ascp instead of ftp because we read that ascp connect is faster for
downloading large datasets than ftp.


### Step 2: Choosing the samples ###

My hard drive limitation is about 500GB. The full SRA dataset is about 1.2-1.8 TB,
so I will need to limit the number of samples to fit my computational resources. 
We decided to choose only the LPS timecourse dataset and controls. We will not be
analyzing the knockouts or the other treatment conditions (at least for now).

The list of the samples we chose to download are as follows:

    info/explist1.csv

Which in a text file form of only the SRR files is:

    info/explist.txt

### Step 3: Downloading Data ###

Downloading was done on a mac.

Edit the get_data.py script and change the arguments so that it directs
to the correct file list.

    python scripts/get_data.py

Commentary on this:

It took around 10-35 seconds to download each file, which I calculated
to take anywhere between 8-10 hours. However, realistically it took
closer to 16-ish hours because I later discovered that when a Mac goes
to sleep, the internet connection disconnects.

As a note, one should go to preferences to ensure that the computer
doesn't sleep or at least disconnect during the process of downloading
files.

### Step 4: Coverting SRR files into fastq ###

Install:
* sratoolkit

I am running this section on my linux vbox under windows, 5G RAM, 2 cores.

I did some quick checks on the metrics, and it looks like it'll take
around 35 seconds per conversion, which is about 2 days on the entire
2000 run set. Obviously just this set will entail cutting down on the
number of samples.

It seems to run in about 20 seconds if I don't run it on the shared
harddrive partition, and instead of the linux localdisk.

Another issue is that each fastq file is about 2GB, which on our entire
dataset is 4TB, which is way beyond our physical space limitations.
Assuming I have 500GB, I can really only do 250 runs.

In either case, the conversion at this step is very simple. It requires
downloading: sratoolkit, which I've added to path.

    fastqdump <name of SRR file>

I can write a simple bash script to do this once I choose my files.

Aligning Data
-------------

### Step 1: Getting the files necessary ###

Install:
* Bowtie (+add to path)
* rsem (+make +add to path)
* tophat (so far not needed)

Download:

* [UCSC KnowGenes transcriptome](http://genome.ucsc.edu/cgi-bin/hgTables)
    * Since it wasn't actually that clear how to obtain this data, what I
	ended up doing in the end was going to UCSC's table generator and
	grabbing the mRNA fasta sequences from the known gene generator.
	* Configuration can be seen on the following image:
	* ![KnownGenesConfig](https://github.com/zxqwerxz/bionet/blob/master/info/knownGenesConfig.png)

Don't Need:
* [UCSC mm9 anotations files - KnownGene.txt](http://hgdownload.cse.ucsc.edu/goldenPath/mm9/database/)

Metrics of KnownGene generation:

*Known Genes Summary Statistics*

| item count     | 55,419                 |
|----------------|------------------------|
| item bases     | 1,062,301,525 (40.54%) |
| item total     | 2,512,869,813 (95.90%) |
| smallest item  | 22                     |
| average item   | 45,343                 |
| biggest item   | 3,171,331              |
| block count    | 476,712                |
| block bases    | 75,683,175 (2.89%)     |
| block total    | 140,366,062 (5.36%)    |
| smallest block | 1                      |
| average block  | 294                    |
| biggest block  | 83,437                 |

*Region and Timing Statistics*

| region           | genome        |
|------------------|---------------|
| bases in region  | 2,725,765,481 |
| bases in gaps    | 105,419,354   |
| load time        | 0.27          |
| calculation time | 1.14          |
| free memory time | 0.00          |
| filter           | off           |
| intersection     | off           |


### Step 2: Build Index ###

Using "knownGenes.fa" (downloaded from UCSC table generator)

Run:

    bowtie-build knownGenes.fa knownGenesMM9

It finishes in 10 minutes or so, since the fasta file is only about
50 MB or so.

### Step 3: Align data (Attempt 1) ###

Note: I accidentally aligned MM8 transcriptome for this first trial, which is significantly smaller.

Testing metrics onto bowtie align:

    time bowtie -q --phred33-quals -S -n 2 -e 99999999 -l 25 -I 1 -X 1000 -a -m 200 align/knownGeneMM9/knownGeneMM9 SRR936367.fastq SRR936367.sam

stderr ouput:

    # reads processed: 3604331
	# reads with at least one reported alignment: 2116226 (58.71%)
	# reads that failed to align: 1442073 (40.01%)
	# reads with alignments suppressed due to -m: 46032 (1.28%)
	Reported 7202365 alignments to 1 output stream(s)

    real 39m14.116s
    user 37m35.789s
    sys 0m27.822s

Output samfile is 5.5 GB
Input fastq was 1.9 GB
Input sra was 483 MB

I should be able to pipe the data out into a BAM format though, so I'm
installing samtools right now.

I should also be able to parallelize the alignment as well. Will check
tomorrow.

### Step 3: Align Data (Attempt 2) ###

***Try running on shared windows folder and linux only vbox harddrive***

Linux Vbox expanding harddrive - 5GB RAM, 2 cores assigned, Intel i7 2 cores (4 hyperthreaded) (producing SAM)

    real 31m51.161s
    user 30m19.711s
    sys 2m16.106s

Linux (Vbox)/Windows Shared Folder - 5GB RAM, 2 cores assigned, Intel i7 2 cores (4 hyperthreaded) (producing SAM)

    real 31m43.432s
    user 30m23.852s
    sys 2m48.120
    
Mac OsX - 8GB RAM, Intel i7 2 cores (producing SAM)

    real 23m46.696s
    user 23m55.481s
    sys 0m16.523s

***Try building different size indexes:***

    # Default: offrate is 5
    bowtie-build knowGeneMM9.fa knownGeneMM9
    
    # Doubles the memory taken
    bowtie-build -o 4 knownGeneMM9.fa knownGeneMM9
       
    # Quadruples the memory taken
    bowtie-build -o 3 knownGeneMM9.fa knownGeneMM9

***Try using different number of threads:***

    # Default is 1 thread
    time bowtie -q --phred33-quals -S -n 2 -e 99999999 -l 25 -I 1 -X 1000 -a -m 200 offset5/knownGeneMM9 SRR936367.fastq | samtools view -bS - > SRR936367.bam
    
    # Try 2 threads
    time bowtie -p 2 -q --phred33-quals -S -n 2 -e 99999999 -l 25 -I 1 -X 1000 -a -m 200 offset5/knownGeneMM9 SRR936367.fastq | samtools view -bS - > SRR936367.bam

*** Results: ***
    
    # OSX o5p1
    
    
    # OSX o5p2
    real	15m51.925s
    user	35m41.549s
    sys	0m42.032s
    
    # OSX o4p1
    real	22m38.203s
    user	26m33.345s
    sys	0m11.606s
    
    # OSX o4p2
    real	14m42.690s
    user	33m41.568s
    sys	0m37.798s
    
    # OSX o3p1
    real	22m39.847s
    user	26m37.195s
    sys	0m13.957s
    
    # OSX o3p2
    real	14m20.069s
    user	33m7.839s
    sys	0m34.379s
    
    # LinuxShare o5p1
    real	31m46.544s
    user	33m46.215s
    sys	5m1.328s
    
    # LinuxShare o5p2
    real	19m42.821s
    user	33m46.215s
    sys	5m1.328s
    
    # LinuxShare o4p1
    real	30m33.725s
    user	32m58.089s
    sys	1m54.355s
    

