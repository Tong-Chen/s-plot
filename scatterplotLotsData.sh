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

This script is used to do scatter plot for very amount of data 
using function ggplot and stat_binhex from package ggplot2 and hexbin. 

The parameters for logical variable are either TRUE or FALSE.

${txtbld}OPTIONS${txtrst}:
	-f	Data file (with header line, the first column is the
 		colname, tab seperated)${bldred}[NECESSARY]${txtrst}
	-t	Title of picture[${txtred}Default empty title${txtrst}]
		[Scatter plot of horizontal and vertical variable]
	-x	xlab of picture[${txtred}Default empty xlab${txtrst}]
		[The description for horizontal variable]
	-y	ylab of picture[${txtred}Default empty ylab${txtrst}]
		[The description for vertical variable]
	-o	The variable for horizontal axis.${bldred}[NECESSARY]${txtrst}
	-v	The variable for vertical axis.${bldred}[NECESSARY]${txtrst}
	-s	smoothed fit curve with confidence region or not.
		${bldred}[Default loss smooth, one can give 'lm' to
		get linear smooth. FALSE for no smooth.
		lm menas add linear regression line and 95% confidence region.]${txtrst}
	-l	Log transference or not,${bldred}[Default FALSE,
		accept log or log2.]${txtrst}
	-e	Execute or not[${bldred}Default TRUE${txtrst}]
	-i	Install the required packages[${bldred}Default FALSE${txtrst}]
EOF
}

file=''
title=''
xlab=''
ylab=''
xval=''
yval=''
execute='TRUE'
ist='FALSE'
group=30
log=''
smooth='geom_smooth'
while getopts "hf:t:x:y:o:v:s:e:l:i:" OPTION
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
			xval=$OPTARG
			;;
		v)
			yval=$OPTARG
			;;
		s)
			smooth=$OPTARG
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

midname=".scatterplot.density"
if [ -z $file ] || [ -z $xval ] || [ -z $yval ]; then
	echo 1>&2 "Please give filename, xval and yval."
	usage
	exit 1
fi


#if [ "$log" == "TRUE" ]; then
#	log=", trans=\"log\""
#fi

cat <<END >${file}${midname}.r

if ($ist){
	install.packages("ggplot2", repo="http://cran.us.r-project.org")
	install.packages("hexbin", repo="http://cran.us.r-project.org")
}
library(ggplot2)
data <- read.table(file="$file", sep="\t", header=T, row.names=1)
#postscript(file="${file}${midname}.eps", onefile=FALSE,
#horizontal=FALSE,paper="special" , width=10, height = 12,pointsize=10)
p <- ggplot(data,aes(x=${xval},y=${yval}))+stat_binhex(bins=${group})+ labs(x="$xlab",
y="$ylab") + ggtitle("$title")

if ("$log" == "log" || "$log" == "log2"){
	#log <- "trans=\"${log}\", "
	p <- p + scale_fill_gradient2(name="Log count", trans="${log}",
	low="green",high="red",mid="yellow")
}

if ("$smooth" == "geom_smooth"){
	p <- p + geom_smooth()
} else 
if ("$smooth" == 'lm'){
	p <- p + geom_smooth(method=lm)
}


p <- p + theme_bw() + theme(legend.title=element_blank(),
	panel.grid.major = element_blank(), panel.grid.minor = element_blank())

png(filename="${file}${midname}.png", width=1000, height=1000)
p
dev.off()
END

if [ "$execute" == "TRUE" ]; then
	Rscript ${file}${midname}.r
fi

#convert -density 200 -flatten ${file}${midname}.eps ${first}${midname}.png
