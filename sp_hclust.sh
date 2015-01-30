#!/bin/bash

usage()
{
cat <<EOF
${txtcyn}

***CREATED BY Chen Tong (chentong_biology@163.com)***

Usage:

$0 options${txtrst}

${bldblu}Function${txtrst}:

This script is used to do clustring using hclust, which is clustered
by row. So transpose your data when necessary.

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
	-b	Transpose data. [${bldred}Default FALSE${txtrst}]
		Default cluster by rows when -b is FALSE. Or cluster 
		by cols when -b is TRUE.
	-t	Title of picture[${txtred}Default empty title${txtrst}]
	-x	xlab of picture[${txtred}Default empty xlab${txtrst}. 
		If setted, using the words which represents the 
		meaning of your columns]
	-y	ylab of picture[${txtred}Default empty ylab${txtrst}. 
		If setted, using the words which represents the 
		meaning of your rows]
	-d	Dist method[${bldred}Default "euclidean"${txtrst}]
		Accept "euclidean", ‘maximum", ‘manhattan",
		    "canberra", ‘binary" or "minkowski"
	-c	hclust method[${txtred}Default "ward"${txtrst}]
		Accept "single", "complete", "average", "mcquitty", "median"
		or "centroid".
	-z	Is there a header[${bldred}Default TRUE${txtrst}]
		Accept FALSE.
	-e	Execute or not[${bldred}Default TRUE${txtrst}]
		Accept FALSE.
	-a	Number of final clusters[${txtred}Default 1${txtrst}, 
		choice an integer(>=2)]
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
transpose='FALSE'

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
	echo "This is decrepated, please use **s-plot hcluster**"
	exit 1
fi

mid='.hclust'

if [ "$scale" = 'TRUE' ]; then
	mid=${mid}'.scale'
fi


cat <<EOF >$file${mid}.r
library(graphics)
data1 = read.table("$file", header=$header,
sep="\t",row.names=1, comment.char="", check.names=${checkNames})
x <- as.matrix(data1)
if ($transpose){
	x <- t(x)
}
if ($scale){
	x <- scale(x)
}
d <- dist(x, method="$dm")
fit <- hclust(d, method="$hm")
#postscript(file="${file}${mid}.eps", onefile=FALSE,horizontal=FALSE)
png(file="${file}${mid}.png", width=600, height=900, res=100)
plot(fit, hang=-1, main="$title", xlab="$xlab", ylab="$ylab")
if ($num){
	rect.hclust(fit, k=$num, border="red")
}
dev.off()
EOF

if [ "${execute}" = 'TRUE' ]; then
	Rscript $file${mid}.r
if [ "$?" == "0" ]; then /bin/rm -f ${file}${mid}.r; fi
	#epstopdf ${file}${mid}.eps
	#if [ $? -eq 0 ]; then
		#convert -density 200 -flatten ${file}${mid}.eps ${file}${mid}.png
		#if [ $num -ne 0 ]; then
		#	convert -density 200 -flatten ${file}${mid}.${num}.eps ${file}${mid}.${num}.png
		#fi
	#fi
fi
