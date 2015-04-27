library(gdata)
library(pca3d)

# set working directory or enter in full path for TPMmat_large.txt
TPMmat_large=read.delim('TPMmat_large.txt',header=TRUE,row.names=1)
TPMmat_small=read.delim('TPMmat_small.txt',header=TRUE,row.names=1)
AlignStats=read.xls('Alignstats.xls',header=TRUE,row.names=1)

#need to first properly order cols of TPMmat_small and then rename them to have names that will match the experiment names in AlignStats
TPM_small_oldcolnames=read.delim('TPMmat_small_oldcolnames.txt',header=FALSE,row.names=1)
TPM_small_newcolnames=read.delim('TPMmat_small_newcolnames.txt',header=FALSE,row.names=1)
TPM_small<-TPM_small(rownames(TPM_small_oldcolnames))
colnames(TPM_small)<-rownames(TPM_small_newcolnames)

#keep only experiments that have >15% alignment
TPMmat_large_f=TPMmat_large[na.omit(match(rownames(AlignStats),colnames(TPMmat_large)))]
TPMmat_small_f=TPMmat_small[na.omit(match(rownames(AlignStats),colnames(TPMmat_small)))]

#merge TPMmat_small and TPMmat_large, keeping only genes that the two share
TPMmat_large_ff<-TPMmat_large_f[na.omit(match(rownames(TPMmat_small_f),rownames(TPMmat_large_f)))]
TPMmat_merged<-cbind(TPMmat_large_ff,TPMmat_small_f)

#convert to ln(TPM+1) and remove genes that have <1% ln(TPM+1)>1 
TPMmat_merged_log<-log(TPMmat_merged=1) 
TPMmat_merged_log_he<-TPMmat_merged_log[rowSums(TPMmat_merged_log>1)/ncol(TPMmat_merged_log)>0.01,]

#transpose for PCA analysis
TPMmat_merged_log_he_tp<-t(TPMmat_merged_log_he)

#label cluster-disrupted cells 
group<-rep(c('nd'),nrow(TPMmat_merged_log_he_tp))
group[TPMmat_merged_log_he_tp[,'LYZ1']<6 | TPMmat_merged_log_he_tp[,'SERPINB6B']>4]<-c('d')
group<-factor(group)
TPMmat_PCA<-cbind(group,TPMmat_merged_log_he_tp)

#perform PCA
pca <- prcomp(TPMmat_PCA[,-1],center=TRUE,scale.=TRUE)
pca2d(pca,group=TPMmat_PCA[1])