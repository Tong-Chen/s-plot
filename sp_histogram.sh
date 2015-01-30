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

This script is used to do clustring using heatmap.2.

data fromat
12
12
23
23
43

${txtbld}OPTIONS${txtrst}:
	-f	Data file (without header line) 
 		${bldred}[NECESSARY]${txtrst}
	-c	The column number represents data column. 
		${bldred}[1-based, default 1 (the first column)]${txtrst}
	-b	Parameters for breaks.
		${bldred}[Default Sturges (R default), accepts
		• a vector giving the breakpoints between histogram cells,
		• a single number givinging th number of cells for the
		histogram]${txtrst}
	-a	Parameter for breaks
		${bldred}A single number to represent the width of each
		column. -a and -b can not be given simutanously.${txtrst}
	-n	Add a normal distributation line.
		[${txtred}Default FALSE, accept TRUE${txtrst}]
	-t	Title of picture[${txtred}Default empty title${txtrst}]
	-x	xlab of picture[${txtred}Default empty xlab${txtrst}]
	-y	ylab of picture[${txtred}Default empty ylab${txtrst}]
	-z	Is there a header[${bldred}Default FALSE${txtrst}]
	-e	Execute or not[${bldred}Default TRUE${txtrst}]
EOF
}

file=
title=''
xlab=''
ylab=''
col=''
execute='TRUE'
header='FALSE'
break_p='Sturges'
col_width=0

while getopts "hf:c:t:b:a:x:y:n:z:e:" OPTION
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
			col=$OPTARG
			;;
		b)
			break_p=$OPTARG
			;;
		a)
			col_width=$OPTARG
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
		n)
			cols=$OPTARG
			;;
		z)
			header=$OPTARG
			;;
		e)
			execute=$OPTARG
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


cat <<END >${file}.hist.r
data1 <- read.table("${file}", header=FALSE, sep="\t")
data2 <- as.vector(data1\$V${col})
break_p <- "${break_p}"
if (${col_width} != 0){
	break_p=ceiling(max(data2)/${col_width})
}
png(file="${file}.hist.png", width=600, height=900,res=120)
hist(data2, breaks=break_p, xlab="${xlab}", main=NULL)
dev.off()
END

Rscript ${file}.hist.r
if [ "$?" == "0" ]; then /bin/rm -f ${file}${mid}.r; fi


