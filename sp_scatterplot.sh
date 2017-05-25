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

This script is used to do scatter plot using function scatterplot from
package car. 

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
	-g	The variable for grouping.${bldred}[selective]${txtrst}
	-w	The width of output picture.
		${bldred}[Default R default value, selective]${txtrst}
	-a	The height of output picture.
		${bldred}[Default R default value, selective]${txtrst}
	-r	The resolution of pictures.
		${bldred}[Default R default value, selective]${txtrst}
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
group=''
legend='FALSE'
width=''
height=''
res=''

while getopts "hf:t:x:y:o:v:g:w:r:a:e:i:" OPTION
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
		g)
			group=$OPTARG
			;;
		w)
			width=$OPTARG
			;;
		a)
			height=$OPTARG
			;;
		r)
			res=$OPTARG
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

mid=".scatterplot"
if [ -z $file ] || [ -z $xval ] || [ -z $yval ]; then
	echo 1>&2 "Please give filename, xval and yval."
	usage
	exit 1
fi


if [ ! -z $group ]; then
	group='|'$group
	legend="TRUE"
fi

cat <<END >${file}${mid}.r

if ($ist){
	install.packages("car", repo="http://cran.us.r-project.org")
}
library(car)
data <- read.table(file="$file", sep="\t", header=T, quote="", row.names=1)
#postscript(file="${file}${mid}.eps", onefile=FALSE,
#horizontal=FALSE,paper="special" , width=10, height = 12,pointsize=10)

if ("$width" != "" && "$height" != ""  && "$res" != ""){
	png(filename="${file}${mid}.png", width=$width, height=$height,
	res=$res)
}else{
	png(filename="${file}${mid}.png")
}


scatterplot($yval~${xval}${group}, data=data, xlab="$xlab", ylab="$ylab",
main="$title", label=row.names(data), id.method="identify",
boxplots="xy", legend.plot=${legend}, ellipse=TRUE)
dev.off()
END

if [ "$execute" == "TRUE" ]; then
	Rscript ${file}${mid}.r
if [ "$?" == "0" ]; then /bin/rm -f ${file}${mid}.r; fi
fi

#convert -density 200 -flatten ${file}${mid}.eps ${first}${mid}.png
