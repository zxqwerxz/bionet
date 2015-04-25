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

| item count     | 31,863                 |
|----------------|------------------------|
| item bases     | 842,101,417 (32.80%)   |
| item total     | 1,559,241,077 (60.74%) |
| smallest item  | 217                    |
| average item   | 48,936                 |
| biggest item   | 2,311,117              |
| block count    | 314,628                |
| block bases    | 54,684,224 (2.13%)     |
| block total    | 83,159,087 (3.24%)     |
| smallest block | 4                      |
| average block  | 264                    |
| biggest block  | 17,497                 |

*Region and Timing Statistics*

| region           | genome        |
|------------------|---------------|
| bases in region  | 2,664,455,088 |
| bases in gaps    | 97,171,117    |
| load time        | 0.15          |
| calculation time | 0.84          |
| free memory time | 0.00          |
| filter           | off           |
| intersection     | off           |


### Step 2: Build Index ###

Using "knownGenes.fa" (downloaded from UCSC table generator)

Run:

    bowtie-build knownGenes.fa knownGenesMM9

It finishes in 10 minutes or so, since the fasta file is only about
50 MB or so.

### Step 3: Align data ###

Testing metrics onto bowtie align:

    time bowtie -q --phred33-quals -S -n 2 -e 99999999 -l 25 -I 1 -X 1000 -a -m 200 align/knownGeneMM9/knownGeneMM9 SRR936367.fastq SRR936367.sam

(Still running as of now)

I should be able to pipe the data out into a BAM format though, so I'm
installing samtools right now.
