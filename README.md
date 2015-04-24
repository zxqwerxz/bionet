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