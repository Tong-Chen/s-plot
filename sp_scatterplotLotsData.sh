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
	-f	Data file (with header line, tab seperated)${bldred}[NECESSARY]${txtrst}
	-r	Treat the first colname as rownames${bldred}[Default 1, accept
		NULL treat every column as data colum.]${txtrst}
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
	-w	The width of output picture.[${txtred}Default 20${txtrst}]
	-u	The height of output picture.[${txtred}Default 12${txtrst}] 
	-E	The type of output figures.[${txtred}Default pdf, accept
		eps/ps, tex (pictex), png, jpeg, tiff, bmp, svg and wmf)${txtrst}]
	-r	The resolution of output picture.[${txtred}Default 300 ppi${txtrst}]
	-e	Execute or not[${bldred}Default TRUE${txtrst}]
	-i	Install the required packages[${bldred}Default FALSE${txtrst}]
EOF
}

file=''
row_names=1
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
uwid=20
vhig=12
ext="pdf"
res=300


while getopts "hf:t:x:y:o:v:s:e:l:i:w:u:E:r:" OPTION
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
		w)
			uwid=$OPTARG
			;;
		u)
			vhig=$OPTARG
			;;
		r)
			res=$OPTARG
			;;
		E)
			ext=$OPTARG
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

mid=".scatterplot.density"
if [ -z $file ] || [ -z $xval ] || [ -z $yval ]; then
	echo 1>&2 "Please give filename, xval and yval."
	usage
	exit 1
fi


#if [ "$log" == "TRUE" ]; then
#	log=", trans=\"log\""
#fi

cat <<END >${file}${mid}.r

if ($ist){
	install.packages("ggplot2", repo="http://cran.us.r-project.org")
	install.packages("hexbin", repo="http://cran.us.r-project.org")
}
library(ggplot2)
data <- read.table(file="$file", sep="\t", header=T, row.names=${row_names})

p <- ggplot(data,aes(x=${xval},y=${yval}))+stat_binhex(bins=${group})+ labs(x="$xlab",
y="$ylab") + ggtitle("$title")

if ("$log" == "log" || "$log" == "log2"){
	#log <- "trans=\"${log}\", "
	p <- p + scale_fill_gradient2(name="Log count", trans="${log}",
	low="green",high="red",mid="yellow")
}

if ("$smooth" == "geom_smooth"){
	p <- p + geom_smooth(method=loose)
} else 
if ("$smooth" == 'lm'){
	p <- p + geom_smooth(method=lm)
}


p <- p + theme_bw() + theme(legend.title=element_blank(),
	panel.grid.major = element_blank(), panel.grid.minor = element_blank())


ggsave(p, filename="${file}${mid}.${ext}", dpi=$res, width=$uwid,
height=$vhig, units=c("cm"))

#png(filename="${file}${mid}.png", width=1000, height=1000)
#p
#dev.off()
END

if [ "$execute" == "TRUE" ]; then
	Rscript ${file}${mid}.r
if [ "$?" == "0" ]; then /bin/rm -f ${file}${mid}.r; fi
fi

#convert -density 200 -flatten ${file}${mid}.eps ${first}${mid}.png
