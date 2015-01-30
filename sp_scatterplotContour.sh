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

This script is used to do scatter plot with contour lines or areas for
large amount of data 
using function ggplot and stat_density2d from package ggplot2. 

The parameters for logical variable are either TRUE or FALSE.

${txtbld}OPTIONS${txtrst}:
	-f	Data file (with header line, the first column is the
 		colname, tab seperated)${bldred}[NECESSARY]${txtrst}
	-m	One string added to the output file name to indicate the
		meaning of this file.
		${bldred}[Optional, normally is the combination of crucial 
		parameters used.]${txtrst}
	-t	Title of picture[${txtred}Default empty title${txtrst}]
		[Scatter plot of horizontal and vertical variable]
	-x	xlab of picture[${txtred}Default empty xlab${txtrst}]
		[The description for horizontal variable]
	-y	ylab of picture[${txtred}Default empty ylab${txtrst}]
		[The description for vertical variable]
	-o	The variable for horizontal axis.${bldred}[NECESSARY]${txtrst}
	-v	The variable for vertical axis.${bldred}[NECESSARY]${txtrst}
	-s	Color variable for contour regions.
		${bldred}[Default ..density.., accept ..level..]${txtrst}
	-p	Display original points.
		${bldred}[Default TRUE, accept FALSE.]${txtrst}
	-P	Color for points.
		${bldred}[Default red]${txtrst}
	-S 	Scale x or y axis
		[${bldred}Default FALSE, accept TRUE.
	   	If the number given to -a is not 0, this parameter will be set
		to TRUE.
		Detailed scale method should be set through -l.]${txtrst}
	-l	Log transference axis or not,
		${bldred}[Default scale_y_log10(), accept coord_trans(y="log10"),
		scale_y_continuous(trans=log2_trans()), 
		coord_trans(y="log2"). One can also do same operation to
		x-axis or both. Besides, all legal ggplot2 sentences are
		acceptable.]${txtrst}
	-a	A number to add to x-axis if scale is used.
		${bldred}[Default 0, if non-zero given, -S would be set to
		TRUE]${txtrst}
	-A	A number to add to y-axis if scale is used.
		${bldred}[Default 0, if non-zero given, -S would be set to
		TRUE]${txtrst}
	-L	Color for low value
		${bldred}[Default blue]${txtrst}
	-H	Color for high value
		${bldred}[Default yellow]${txtrst}
	-w	The width of output picture.[${txtred}Default 18${txtrst}]
	-u	The height of output picture.[${txtred}Default 15${txtrst}] 
	-E	The type of output figures.[${txtred}Default png, accept
		eps/ps, tex (pictex), pdf, jpeg, tiff, bmp, svg and wmf)${txtrst}]
	-r	The resolution of output picture.[${txtred}Default 300${txtrst}]
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
log='scale_y_log10()'
fill_contour="..density.."
scale='FALSE'
x_add=0
y_add=0
uwid=18
vhig=15
res=300
ext='png'
low="blue"
high="yellow"
user_mid=""
points="TRUE"
point_color="red"

while getopts "ha:A:e:E:f:H:i:l:L:m:o:p:P:r:s:S:t:u:v:w:x:y:" OPTION
do
	case $OPTION in
		h)
			usage
			exit 1
			;;
		a)
			x_add=$OPTARG
			;;
		A)
			y_add=$OPTARG
			;;
		f)
			file=$OPTARG
			;;
		m)
			user_mid=$OPTARG
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
		p)
			points=$OPTARG
			;;
		P)
			point_color=$OPTARG
			;;
		v)
			yval=$OPTARG
			;;
		s)
			fill_contour=$OPTARG
			;;
		S)
			scale=$OPTARG
			;;
		l)
			log=$OPTARG
			;;
		L)
			low=$OPTARG
			;;
		H)
			high=$OPTARG
			;;
		w)
			uwid=$OPTARG
			;;
		u)
			vhig=$OPTARG
			;;
		E)
			ext=$OPTARG
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


if [ -z $file ] || [ -z $xval ] || [ -z $yval ]; then
	echo 1>&2 "Please give filename, xval and yval."
	usage
	exit 1
fi


#if [ "$log" == "TRUE" ]; then
#	log=", trans=\"log\""
#fi

mid=".scatterContour"

if test "${user_mid}" != ""; then
	mid=${mid}".${user_mid}"
fi

cat <<END >${file}${mid}.r

if ($ist){
	install.packages("ggplot2", repo="http://cran.us.r-project.org")
}

library(ggplot2)

data <- read.table(file="$file", sep="\t", header=T, row.names=1)

data\$${xval} <- data\$${xval} + ${x_add}
data\$${yval} <- data\$${yval} + ${y_add}

p <- ggplot(data,aes(x=${xval},y=${yval}))+
labs(x="$xlab", y="$ylab") + ggtitle("$title")

if ("${fill_contour}" == "..density..") {
	p <- p + stat_density2d(aes(fill = ${fill_contour}), geom="tile",
	contour=FALSE) 
} else if ("${fill_contour}" == "..level.."){
	p <- p + stat_density2d(aes(fill = ${fill_contour}),
	geom="polygon") 
}

p <- p + scale_fill_gradient(low="${low}", high="${high}")

if (${points}){
	p <- p + geom_point(size=0.3, alpha=0.5, color="${point_color}")
}

if (${scale} || ${x_add} != 0 || ${y_add} != 0) {
	p <- p + ${log}
}

p <- p + theme_bw() + theme(legend.title=element_blank(),
	panel.grid.major = element_blank(), panel.grid.minor = element_blank())

ggsave(p, filename="${file}${mid}.${ext}", dpi=$res, width=$uwid,
height=$vhig, units=c("cm"))
END

if [ "$execute" == "TRUE" ]; then
	Rscript ${file}${mid}.r
if [ "$?" == "0" ]; then /bin/rm -f ${file}${mid}.r; fi
fi

#convert -density 200 -flatten ${file}${mid}.eps ${first}${mid}.png
