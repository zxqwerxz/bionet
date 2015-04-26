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