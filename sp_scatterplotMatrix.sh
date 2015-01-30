#!/bin/bash

#set -x

usage()
{
cat <<EOF
${txtcyn}

***CREATED BY Chen Tong (chentong_biology@163.com)***

Usage:

$0 options${txtrst}

${bldblu}Function${txtrst}:

This script is used to do scatter plot matrix using function 
package gclus. 

The parameters for logical variable are either TRUE or FALSE.

${txtbld}OPTIONS${txtrst}:
	-f	Data file (with header line, the first column is the
 		colname, tab seperated)${bldred}[NECESSARY]${txtrst}
	-k	If the names of your rows and columns startwith numeric value,
		this can be set to FALSE to avoid modifying these names to be
		illegal variable names. But duplicates can not be picked out.
		[${bldred}Default TRUE${txtrst}]
	-t	Title of picture[${txtred}Default empty title${txtrst}]
		[Scatter plot of horizontal and vertical variable]
	-c	The columns needed to be compared.${bldred}[0-based, ignore
		rowrname. Like "1,2,3" indicates the 2nd,3rd and 4th column in
		source data file. No blank.]${txtrst}
	-e	Execute or not[${bldred}Default TRUE${txtrst}]
	-i	Install the required packages[${bldred}Default FALSE${txtrst}]
EOF
}

file=''
title=''
comp=''
execute='TRUE'
ist='FALSE'
checkN='TRUE'

while getopts "hf:k:t:c:e:i:" OPTION
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
			checkN=$OPTARG
			;;
		t)
			title=$OPTARG
			;;
		c)
			comp=$OPTARG
			;;
		e)
			execute=$OPTARG
			;;
		i)
			ist=$OPTARG
			;;
		?)
			usage
			exit 1
			;;
	esac
done

mid=".scatterplotMatrix"
if [ -z $file ] || [ -z $comp ] ; then
	echo 1>&2 "Please give filename, compared columnumn number."
	usage
	exit 1
fi


cat <<END >${file}${mid}.r

if ($ist){
	install.packages("gclus", repo="http://cran.us.r-project.org")
}
library(gclus)
data <- read.table(file="$file", sep="\t", header=T, row.names=1,
check.names=${checkN})
data <- data[c($comp)] #get appointed data
data.r <- abs(cor(data)) #get correlation, default pearson
#get colors, the deepest, the large correlation coefficient
data.col <- dmat.color(data.r) 
#reorder variables so those with the highest correlation
# are closest to the diagonal
data.o <- order.single(data.r)

#postscript(file="${file}${mid}.eps", onefile=FALSE, horizontal=FALSE)
png(filename="${file}${mid}.png", width=1000, height=1000,res=150)
cpairs(data, data.o, panel.colors=data.col, gap=.1,
main="$title")
dev.off()
END

if [ "$execute" == "TRUE" ]; then
	Rscript ${file}${mid}.r
if [ "$?" == "0" ]; then /bin/rm -f ${file}${mid}.r; fi
	#convert -density 200 -flatten ${file}${mid}.eps \
	#	${file}${mid}.png
fi

