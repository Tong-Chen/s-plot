#!/bin/bash
#############
#CT##########
#############

#set -x
set -e
set -u
usage()
{
cat <<EOF
${txtcyn}
Usage:

$0 options${txtrst}

${bldblu}Function${txtrst}:

This script is used to plot heatmap.

First it will use kmeans to cluster rows and search for correct order.

Then the heatmap will be genrated on ordered data.

${txtred}Warning${txtrst}: This script can not deal well with one element cluster.
Please check it yourself.

${txtbld}OPTIONS${txtrst}:
	-f	Data file (with header line, the first column is the
 		rowname, tab seperated)${bldred}[NECESSARY]${txtrst}
	-c	The number of cluster wanted.${bldred}[NECESSARY]${txtrst}
	-P	The way to preprocess data before clustering.
		[${txtred} 
		0          : means no preprocess
		1          : means scale data
		2          : means using the difference value between current
		           : column and the one before
		3          : means values in each row are divided by the
		           : sqrt(sum(squares of values in this row))
		4 (default): means first scale data and then use the difference value between current
		           : column and the one before
		Both 2, 3, 4 are designed for clustering genes with same
		changing trend together. Only affect data order steps.
		${txtrst}]
	#-p	Select the optimum cluster number by elbow algorithm. 
	#	[${txtred}Default FALSE.${txtrst}]
	#	Accept TRUE. 
	#	When this is set to TRUE, a plot of within groups
	#	sum of squares is made. Acroread will open it, you choose the
	#	cluster number before which there is a sharp decline. Then
	#	close the opened pdf, you will be asked to input the chosed
	#	number. When this is TRUE, the number after -c is the expected
	#	maximum cluster number. All number of clusters ranges from 2
	#	to maximum cluster number will be calculated.
	-t	Give the maximum try number to run kmeans multiple times and
		choose the one with the least withinss.
		[${txtred}Default 10.${txtrst}]
	-i	Install needed packages.[default FALSE, given TRUE once if there is
		error like <there is no package>]
	-l	Parameters for s-plot heatmapS (-f is not needed). 
		One can add new parameters to override remaining one or set new attributes.
		[Default: '-A 90 -T 1.5 -V 0.5 -l top -v 22 -u 15 -F 9 
		           -j TRUE -M yellow -x green -y red -Z TRUE']
EOF
}

file=
center=
preprocess=4
plotwithinss='FALSE'
try=10
evaluation='FALSE'
xlab='Value'
ylab='Variable'
mainT=''
ly_default='-A 90 -T 1.5 -V 0.5 -l top -v 22 -u 15 -F 9 -j TRUE -M yellow -x green -y red -Z TRUE'
ly=''
ist='FALSE'

while getopts "hf:c:P:p:t:e:x:y:m:l:i:" OPTION
do
	case $OPTION in
		h)
			usage
			exit 1
			;;
		f)
			file=$OPTARG
			;;
		c)
			center=$OPTARG
			;;
		P)
			preprocess=$OPTARG
			;;
		p)
			plotwithinss=$OPTARG
			;;
		t)
			try=$OPTARG
			;;
		e)
			evaluation=$OPTARG
			;;
		x)
			xlab=$OPTARG
			;;
		y)
			ylab=$OPTARG
			;;
		m)
			mainT=$OPTARG
			;;
		i)
			ist=$OPTARG
			;;
		l)
			ly=$OPTARG
			;;
		?)
			usage
			exit 1
			;;
	esac
done
if [ -z $file ]; then
	usage
	exit 1
fi
mid=''

cat <<EOF >${file}${mid}.kmeans.r
if (${ist}){
	install.packages("cluster", repo="http://cran.us.r-project.org")
	install.packages("psych", repo="http://cran.us.r-project.org")
	install.packages("fpc", repo="http://cran.us.r-project.org")
}
library(cluster)
library(psych)
library(fpc)
data <- read.table(file="$file", sep='\t', header=T, row.names=1,
check.names=FALSE)
data <- as.matrix(data)
#Delete rows containing only zero
data <- data[rowSums(data==0)<ncol(data),]

if($preprocess == 0){
	kdata <- data
}else if(${preprocess} == 1){
	kdata <- t(apply(data,1,scale))
}else if(${preprocess} == 2){
	kdata <- t(apply(data,1,diff))
}else if(${preprocess} == 3){
	norm_factors_for_each_row <- sqrt(apply(data^2, 1, sum))
	kdata <- data / norm_factors_for_each_row
}else if(${preprocess} == 4){
	kdata <- t(apply(data,1,scale))
	kdata <- t(apply(kdata,1,diff))
}
#print("Try kmeans for the first time.")
fit <- kmeans(kdata, centers=$center, iter.max=100, nstart=25)
withinss <- sum(fit\$withinss)#
#print(paste("Get withinss for the first run", withinss))
for (i in 1:$try) {
	tmpfit <- kmeans(kdata, centers=$center, iter.max=100, nstart=25)
	tmpwithinss <- sum(tmpfit\$withinss)
	#print(paste(("The additional "), i, 'run, withinss', tmpwithinss))
	if (tmpwithinss < withinss){
		withins <- tmpwithinss
		fit <- tmpfit
	}
}

cluster <- fit\$cluster
cluster <- as.data.frame(cluster)

dataWithClu <- cbind(ID=rownames(data), data, cluster)
dataWithClu <- dataWithClu[order(dataWithClu\$cluster),]
write.table(as.data.frame(dataWithClu), 
	file="${file}${mid}.kmeans.xls", 
	sep="\t", row.names=F, col.names=T, quote=F)

EOF

Rscript ${file}${mid}.kmeans.r

parseHeatmapSoutput.2.py -i ${file}${mid}.kmeans.xls >${file}${mid}.kmeans.sort

s-plot heatmapS -f ${file}${mid}.kmeans.sort ${ly_default} ${ly}
	
/bin/rm -f ${file}${mid}.kmeans.sort ${file}${mid}.kmeans.r

#if [ "$plotwithinss" == 'TRUE' ]; then
#	cat <<EOF >${file}${mid}.$center.kmeans.chooseClusterNumber.r
#data <- read.table(file="$file", sep='\t', header=T, row.names=1,
#check.names=FALSE)
#data <- as.matrix(data)
##Delate rows containing only zero
#data <- data[rowSums(data==0)<ncol(data),]
#if($preprocess == 0){
#	kdata <- data
#}else if(${preprocess} == 1){
#	kdata <- t(apply(data,1,scale))
#}else if(${preprocess} == 2){
#	kdata <- t(apply(data,1,diff))
#}else if(${preprocess} == 3){
#	norm_factors_for_each_row <- sqrt(apply(data^2, 1, sum))
#	kdata <- data / norm_factors_for_each_row
#}
#
#wss <- (nrow(kdata)-1)*sum(apply(kdata,2,var))
#
#for (i in 2:$center) wss[i] <- sum(kmeans(kdata, centers=i,
#	iter.max=100, nstart=25)\$withinss)
#
#pdf("${file}${mid}.$center.kmeans.chooseClusterNumber.pdf")
#plot(1:$center, wss, type="b", xlab="Number of Clusters", ylab="Within
#groups sum of squares")
#dev.off()
#	
#EOF
#
#Rscript --save ${file}${mid}.$center.kmeans.chooseClusterNumber.r
#if [ $? == 0 ]; then
#acroread ${file}${mid}.$center.kmeans.chooseClusterNumber.pdf
#
#read -p ">>>Input the cluster number : " center
#else
#	echo "Wrong Rscript"
#fi
#fi

#print("Output the mean value of cluster")
#cluster.mean <- aggregate(data, by=list(fit\$cluster), FUN=mean)
#cluster.mean.colnames <- colnames(cluster.mean)
#cluster.mean.colnames[1] = paste('#',cluster.mean.colnames[1], sep='')
#colnames(cluster.mean) <- cluster.mean.colnames
#write.table(t(cluster.mean), file="${file}${mid}.$center.kmeans.cluster.mean.xls", sep='\t',col.names=F, row.names=T, quote=F)
#print("Output the total sorted cluster name")
#clust.out <- fit\$cluster
#kclust <- as.matrix(clust.out)
#kclust.out <- cbind(kclust, data)
#means of n points in each cluster
#mns <- sapply(split(data, fit\$cluster), function(x) mean(unlist(x)))
#order the data
#data.order <- data[order(order(mns)[fit\$cluster]),]
#write.table(data.order, file="${file}${mid}.$center.kmeans.result", 
#sep="\t", row.names=T, col.names=T, quote=F)
