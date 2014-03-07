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

This script is used to do horizontal bar for files with counted data 
in the second column using function ggplot and geom_bar and
coord_flip() from package ggplot2. 

The parameters for logical variable are either TRUE or FALSE.

${txtbld}OPTIONS${txtrst}:
	-f	Data file (with header line, the first column is the
 		colname, tab seperated)${bldred}[NECESSARY]${txtrst}
	-t	Title of picture[${txtred}Default empty title${txtrst}]
		[Scatter plot of horizontal and vertical variable]
	-x	xlab of picture[${txtred}Default empty xlab${txtrst}]
		[The description for horizontal variable(rowname)]
	-y	ylab of picture[${txtred}Default empty ylab${txtrst}]
		[The description for vertical variable(count)]
	-o	The variable for counted data.${bldred}[NECESSARY]${txtrst}
	-v	Normal(vertical) bars or not.${bldred}[Default FALSE]${txtrst}
	-d  Dpi for picture.${bldred}[Default system default which is NA]${txtrst}
	-l	Log transference or not.${bldred}[Default FALSE]${txtrst}
	-e	Execute or not[${bldred}Default TRUE${txtrst}]
	-i	Install the required packages[${bldred}Default FALSE${txtrst}]
EOF
}

file=''
title=''
xlab=''
ylab=''
count=''
normal=FALSE
execute='TRUE'
ist='FALSE'
log=''
dpi='NA'

while getopts "hf:t:x:y:o:v:e:d:l:i:" OPTION
do
	case $OPTION in
		h)
			usage
			exit 1
			;;
		f)
			file=$OPTARG
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
		o)
			count=$OPTARG
			;;
		v)
			normal=$OPTARG
			;;
		d)
			dpi=$OPTARG
			;;
		l)
			log=$OPTARG
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

midname=".horizontalBar"
if [ -z $file ] || [ -z $count ] ; then
	echo 1>&2 "Please give filename and count."
	usage
	exit 1
fi


cat <<END >${file}${midname}.r

if ($ist){
	install.packages("ggplot2", repo="http://cran.us.r-project.org")
}
library(ggplot2)
data <- read.table(file="$file", sep="\t", header=T, row.names=1)
png(filename="${file}${midname}.png", width=1000, height=1000, res=${dpi})

p <- ggplot(data, aes(row.names(data),${count}))
p <- p + geom_bar(stat="identity", fill="deepskyblue") + labs(x="${xlab}", y="${ylab}") + opts(title="${title}") 

#p <- p + opts(axis.text.x=theme_text(size=10)) + opts(axis.text.y=theme_text(size=14))

if (! ${normal}){
	p <- p + coord_flip() 
}

if (${log}){
	p <- p + scale_y_continuous(trans="log")
}
p
#Summary of annotation for GC percentage(31%~40%) reads
dev.off()
END

if [ "$execute" == "TRUE" ]; then
	Rscript ${file}${midname}.r
fi

#convert -density 200 -flatten ${file}${midname}.eps ${first}${midname}.png
