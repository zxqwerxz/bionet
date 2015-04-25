#!/usr/bin/python

"""
This script obtains all the srr files as specified by ascp

You must run this script in the same directory as the data is output
"""

import os, sys, subprocess

def main(argv):

    # Arguments
    files = "explist1.txt"
    ext = ".sra"
    ftp_root = "anonftp@ftp.ncbi.nlm.nih.gov:/sra/sra-instant/reads/ByStudy/sra/SRP/SRP027/SRP027537/"
    ascp_key = "'/Users/jeffrey/Applications/Aspera Connect.app/Contents/Resources/asperaweb_id_dsa.putty'"
    dest_path = "data/"

    # Load list of files
    f = open(files, 'rb')
    string = ""
    for line in f:
        string += line
	filelist = string.split(',')

    # Begin downloading files
    count = 0
    for file in filelist:    
        if not os.path.isfile(dest_path + file + ext):
            # Only donwload file if it doesn't already exist
            cmd = [
                "ascp -i ",
                ascp_key,
                " -k 1 -T -l 300m ",
                ftp_root,
                file,
                "/",
                file,
                ext,
        	" ",
                dest_path,
                ]
            os.system("".join(cmd))

        count += 1
        print "Finished downloading file " + str(count) + " of " + str(len(filelist)) + "\n"

    f.close()
    sys.stderr.write("All done!\n")

# Execute this module as a command line script
if __name__ == "__main__":
    main(sys.argv[1:])
