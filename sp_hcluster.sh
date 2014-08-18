#!/bin/bash

usage()
{
cat <<EOF
${txtcyn}

***CREATED BY Chen Tong (chentong_biology@163.com)***

Usage:

$0 options${txtrst}

${bldblu}Function${txtrst}:

This script is used to do column clustring using hcluster(in package amap).

${txtbld}OPTIONS${txtrst}:
	-f	Data file (with header line, the first column is the
 		colname, tab seperated)${bldred}[NECESSARY]${txtrst}
	-k	If the names of your rows and columns startwith numeric value,
		this can be set to FALSE to avoid modifying these names to be
		illegal variable names. But duplicates can not be picked out.
		[${bldred}Default TRUE${txtrst}]
		Accept FALSE.
	-s	Scale the data.[${bldred}Default FALSE${txtrst}]
		Accept TRUE.
	-b	Transpose data. [${bldred}Default TRUE${txtrst}]
		Default cluster by columns. If you want, cluster by rows, 
		FALSE should be given.
	-a	Number of final clusters[${txtred}Default 1${txtrst}, 
		choice an integer(>=2). Red lines will be displayed to label
		each cluster.]
	-t	Title of picture[${txtred}Default empty title${txtrst}]
	-x	xlab of picture[${txtred}Default empty xlab${txtrst}. 
		If setted, using the words which represents the 
		meaning of your columns]
	-y	ylab of picture[${txtred}Default empty ylab${txtrst}. 
		If setted, using the words which represents the 
		meaning of your rows]
	-d	Dist method[${bldred}Default "euclidean"${txtrst}]
		Accept "euclidean", ‘maximum", ‘manhattan",
		    "canberra", ‘binary,,"
			"pearson", "correlation", "spearman" or "kendall".
	-c	hclust method[${txtred}Default "ward"${txtrst}]
		Accept "single", "complete", "average", "mcquitty", "median"
		or "centroid".
	-z	Is there a header[${bldred}Default TRUE${txtrst}]
		Accept FALSE.
	-e	Execute or not[${bldred}Default TRUE${txtrst}]
		Accept FALSE.
EOF
}

file=
checkNames='TRUE'
scale='FALSE'
title=''
xlab=''
ylab=''
dm='euclidean'
hm='ward'
header='TRUE'
execute='TRUE'
num=0
transpose='TRUE'

while getopts "hf:k:s:t:x:y:d:c:z:e:a:b:" OPTION
do
	case $OPTION in
		h)
			usage
			exit 1
			;;
		f)
			file=$OPTARG
			;;
		k)
			checkNames=$OPTARG
			;;
		s)
			scale=$OPTARG
			;;
		t)
			title=$OPTARG
			;;
		x)
			xlab=$OPTARG
			;;
		y)
			ylab=$OPTARG
			;;
		d)
			dm=$OPTARG
			;;
		c)
			hm=$OPTARG
			;;
		z)
			header=$OPTARG
			;;
		e)
			execute=$OPTARG
			;;
		a)
			num=$OPTARG
			;;
		b)
			transpose=$OPTARG
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

midname=".hcluster.${dm}.${hm}"

if [ "$scale" = 'TRUE' ]; then
	midname=${midname}'.scale'
fi


cat <<EOF >$file${midname}.r
library(graphics)
library(amap)
data1 = read.table("$file", header=$header,
sep="\t",row.names=1, comment.char="", check.names=${checkNames})
x <- as.matrix(data1)
if ($transpose){
	x <- t(x)
}
if ($scale){
	x <- scale(x)
}
#d <- dist(x, method="$dm")
#fit <- hclust(d, method="$hm")
fit <- hcluster(x, method="$dm", link="$hm")
#postscript(file="${file}${midname}.eps", onefile=FALSE, horizontal=FALSE, 
#	paper="special", width=10, height = 12, pointsize=10)
png(file="${file}${midname}.png", width=600, height=900, res=100)
plot(fit, hang=-1, main="$title", xlab="$xlab", ylab="$ylab")
if ($num){
	rect.hclust(fit, k=$num, border="red")
}
dev.off()
EOF

if [ "${execute}" = 'TRUE' ]; then
	Rscript $file${midname}.r
	#epstopdf ${file}${midname}.eps
	#if [ $? -eq 0 ]; then
	#	convert -density 200 -flatten ${file}${midname}.eps ${file}${midname}.png
		#if [ $num -ne 0 ]; then
		#	convert -density 200 -flatten ${file}${midname}.${num}.eps ${file}${midname}.${num}.png
		#fi
	#fi
fi
