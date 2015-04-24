if( file.exists('SRAmetadb.sqlite') ) {
    ## Not run: 
    library(SRAdb)
    sra_dbname <- 'SRAmetadb.sqlite'	
    
    sra_con <- dbConnect(dbDriver("SQLite"), sra_dbname)
    in_acc <- c("SRR000648","SRR000657")
    ascpCMD <- 'ascp -QT -l 300m -i /usr/local/aspera/connect/etc/asperaweb_id_dsa.putty'
    ## common ascpCMD for a system with Mac OS X:
    #ascpCMD <- "'/Applications/Aspera Connect.app/Contents/Resources/ascp' -QT -l 300m -i '/Applications/Aspera Connect.app/Contents/Resources/asperaweb_id_dsa.putty'"
    
    sraFiles <- ascpSRA( in_acc, sra_con, ascpCMD, fileType = 'litesra', destDir=getwd() )
    dbDisconnect(sra_con)
    
## End(Not run)
} else {
    print( "Use ascpSRAdbFile() to get a copy of the SRAmetadb.sqlite file  and then rerun the example" )
}