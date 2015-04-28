# set working directory
setwd("~/src/r/bionet/data")

# Load filtered matrix (containing only aligned data) in units ln(TPM+1)
# Comment this row and uncomment the later ones if no workspace image is present
load(".RData")
#ltpmf <- read.table("ltpmf.tsv", sep="\t", header=T, row.names=1)
#sample <- read.table("samples.tsv", sep="\t", header=T)

if (is.data.frame(ltpmf)) {
	ltpmf_df <- ltpmf
	ltpmf <- as.data.matrix(ltpmf)
}

plot_percentiles <- function(ltpmf,pngname="LTPM_density_percentile_gt_0.png",plotname="Density of Genes with ln(TPM+1)>0", ver=1) {

	# Calculate Percentiles (<1% in all genes is about equal to the 99th percentile of TPM for each gene)
	# Also perform the KDE on each one for graphing purposes
	d100 = density(apply(ltpmf, 1, max))
	d99 = density(apply(ltpmf, 1, quantile, 0.99))
	d98 = density(apply(ltpmf, 1, quantile, 0.98))
	d97 = density(apply(ltpmf, 1, quantile, 0.97))
	d96 = density(apply(ltpmf, 1, quantile, 0.96))
	d95 = density(apply(ltpmf, 1, quantile, 0.95))

	# Plot these KDE estimates
	# Uncomment first line to produce an image
	png(pngname, width=600, height=500)
	plot(d100, main=plotname, xaxt="n")
	lines(d99, col="purple")
	lines(d98, col="blue")
	lines(d97, col="green")
	lines(d96, col="orange")
	lines(d95, col="red")
	abline(v=ver, lwd=2)
	legend( x="topright", 
			legend=c("100th Percentile", "99th Percentile","98th Percentile","97th Percentile","96th Percentile","95th Percentile"),
			col=c("black", "purple", "blue", "green", "orange", "red"), lty=c(1,1,1,1,1) )
	axis(1, at = seq(0, 15, by = 1), las=1)
	dev.off()

}

###################################################################################
# This section plots all the genes (low expressing genes included)
if (FALSE) {
    plot_percentiles(ltpm)
}

###################################################################################
# This section filters out genes that are lowly expressed in <1% of all samples
# (Genes with expression ln(TPM+1)>1 in less than 1% of all samples)
if (FALSE) {

	if (!exists("ltpmf_df")) {
		ltpmf_df <- as.data.frame(ltpmf)
	}

	# Get a list of the 99th Percentile with cutoff > 1
	ltpmf_df$p99 <- apply(ltpmf, 1, quantile, 0.99)
	ltpmf_df <- ltpmf_df[ltpmf_df$p99 > 1,]
	ltpmf_df$p99 <- NULL
	ltpmf = as.matrix(ltpmf_df)

	plot_percentiles(ltpmf,"LTPM_density_percentile_gt_1.png","Density of Genes with ln(TPM+1)>1")

}

###################################################################################
# This section filters out genes that are lowly expressed in <1% of all samples
# (Genes with expression ln(TPM+1)>2 in less than 1% of all samples)
if (TRUE) {

	if (!exists("ltpmf_df")) {
		ltpmf_df <- as.data.frame(ltpmf)
	}

	# Get a list of the 99th Percentile with cutoff > 2	
	ltpmf_df$p99 <- apply(ltpmf, 1, quantile, 0.99)
	ltpmf_df <- ltpmf_df[ltpmf_df$p99 > 2,]
	ltpmf_df$p99 <- NULL
	ltpmf = as.matrix(ltpmf_df)

	plot_percentiles(ltpmf,"LTPM_density_percentile_gt_2.png","Density of Genes with ln(TPM+1)>2",2)

}