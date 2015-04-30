setwd("~/src/r/bionet/data"

samples <- read.table("samples.tsv", sep="\t", header=T)
ltpmf <- read.table("ltpmf.tsv", sep="\t", header=T, row.names=1)

unstim = ltpmf_df[,intersect(samples[samples$group=="Unstimulated",]$name, names(ltpmf_df))]
lps1 = ltpmf_df[,intersect(samples[samples$group=="LPS_1h",]$name, names(ltpmf_df))]
lps2 = ltpmf_df[,intersect(samples[samples$group=="LPS_2h",]$name, names(ltpmf_df))]
lps4 = ltpmf_df[,intersect(samples[samples$group=="LPS_4h",]$name, names(ltpmf_df))]
lps6 = ltpmf_df[,intersect(samples[samples$group=="LPS_6h",]$name, names(ltpmf_df))]
pam1 = ltpmf_df[,intersect(samples[samples$group=="PAM_1h",]$name, names(ltpmf_df))]
pam2 = ltpmf_df[,intersect(samples[samples$group=="PAM_2h",]$name, names(ltpmf_df))]
pam4 = ltpmf_df[,intersect(samples[samples$group=="PAM_4h",]$name, names(ltpmf_df))]
pam6 = ltpmf_df[,intersect(samples[samples$group=="PAM_6h",]$name, names(ltpmf_df))]
pic1 = ltpmf_df[,intersect(samples[samples$group=="PIC_1h",]$name, names(ltpmf_df))]
pic2 = ltpmf_df[,intersect(samples[samples$group=="PIC_2h",]$name, names(ltpmf_df))]
pic4 = ltpmf_df[,intersect(samples[samples$group=="PIC_4h",]$name, names(ltpmf_df))]
pic6 = ltpmf_df[,intersect(samples[samples$group=="PIC_6h",]$name, names(ltpmf_df))]

samplelist = samples[
	samples$group=="LPS_1h" |
	samples$group=="LPS_2h" |
	samples$group=="LPS_4h" |
	samples$group=="LPS_6h"
	,]
	lps = ltpmf_df[,intersect(samplelist$name, names(ltpmf_df))]

tol <- c("CCL3", "IL6", "TNF", "MAP2K1", "TBK1", "RELA", "TLR1", "TLR2", "NFKBIA", "NFKB1", "CD40", "CCL5", "TLR6", "CCL4", "TLR7", "CD86", "CD80", "MAP3K8", "IL1B", "PIK3R5", "IL12B", "CD14")

a = lps[intersect(tol, rownames(lps)),]

violin_plot <- function(gene) {
	par(mfrow=c(1,3)) 
	x0 <- unlist(unstim[gene,])
	x1 <- unlist(lps1[gene,])
	x2 <- unlist(lps2[gene,])
	x4 <- unlist(lps4[gene,])
	x6 <- unlist(lps6[gene,])
	vioplot(x0, x1, x2, x4, x6, names=c("0h", "1h", "2h", "4h", "6h"), col="red")
	title("LPS")
	x0 <- unlist(unstim[gene,])
	x1 <- unlist(pic1[gene,])
	x2 <- unlist(pic2[gene,])
	x4 <- unlist(pic4[gene,])
	x6 <- unlist(pic6[gene,])
	vioplot(x0, x1, x2, x4, x6, names=c("0h", "1h", "2h", "4h", "6h"), col="blue")
	title("PIC")
	x0 <- unlist(unstim[gene,])
	x1 <- unlist(pam1[gene,])
	x2 <- unlist(pam2[gene,])
	x4 <- unlist(pam4[gene,])
	x6 <- unlist(pam6[gene,])
	vioplot(x0, x1, x2, x4, x6, names=c("0h", "1h", "2h", "4h", "6h"), col="green")	
	title("PAM")
}

plot_pic <- function(gene) {
plot(density(unlist(unstim[gene,])), lwd=2.5, main="", xaxt="n", xlab="", yaxt="n")
par(new=TRUE)
plot(density(unlist(pic1[gene,])), col='blue', main="", xaxt="n", xlab="", yaxt="n")
par(new=TRUE)
plot(density(unlist(pic2[gene,])), col='green', main="", xaxt="n", xlab="", yaxt="n")
par(new=TRUE)
plot(density(unlist(pic4[gene,])), col='orange', main="", xaxt="n", xlab="", yaxt="n")
par(new=TRUE)
plot(density(unlist(pic6[gene,])), col='red', main="", xaxt="n", xlab="", yaxt="n")
}
plot_pam <- function(gene) {
plot(density(unlist(unstim[gene,])), lwd=2.5, main="", xaxt="n", xlab="", yaxt="n")
par(new=TRUE)
plot(density(unlist(pic1[gene,])), col='blue', main="", xaxt="n", xlab="", yaxt="n")
par(new=TRUE)
plot(density(unlist(pic2[gene,])), col='green', main="", xaxt="n", xlab="", yaxt="n")
par(new=TRUE)
plot(density(unlist(pic4[gene,])), col='orange', main="", xaxt="n", xlab="", yaxt="n")
par(new=TRUE)
plot(density(unlist(pic6[gene,])), col='red', main="", xaxt="n", xlab="", yaxt="n")
}


if (FALSE) {

samplelist = samples[
	samples$group=="LPS_1h" |
	samples$group=="LPS_2h" |
	samples$group=="LPS_4h" |
	samples$group=="LPS_6h"
	,]
	lps = ltpmf_df[,intersect(samplelist$name, names(ltpmf_df))]

png("density.png", width=1000, height=800)
plot(s, main="Theoretical vs. Experimental GC Content KDE")
par(new=TRUE)
plot(x, col='blue', xlab="", yaxt="n")
abline(v=0.5, lwd=2.5, col='red')
axis(4)
legend("topright", c("Theoretical", "Experimental"), lty=c(1,1), lwd=c(2.5,2.5), col=c("black", "blue"))
dev.off()

png("GC_exp_vs_theor.png", width=800, height=600)
plot(s, main="")
par(new=TRUE)
plot(x, col='red', main="", xaxt="n", xlab="", yaxt="n")
abline(v=0.5, lwd=2.5, col="black")
axis(4)
axis(3)
abline(v=0.2, col='grey', lwd=1)
abline(v=0.3, col='grey', lwd=1)
abline(v=0.4, col='grey', lwd=1)
abline(v=0.6, col='grey', lwd=1)
abline(v=0.7, col='grey', lwd=1)
abline(v=0.8, col='grey', lwd=1)
par(new=TRUE)
plot(s, main="", xaxt="n", yaxt="n", xlab="", ylab="", lwd=2)
par(new=TRUE)
plot(x, main="", xaxt="n", yaxt="n", xlab="", ylab="", lwd=1, col='red')
legend("topright", c("Theoretical", "Experimental"), lty=c(1,1), lwd=c(2,1), col=c("black", "red"))
dev.off()

}
