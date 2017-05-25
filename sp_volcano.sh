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

This script is used to do volcano plot using package ggplo2.

Input data format like (at least the first 4 columns, do not need to
be the first 4 in given file. Usually, p-value should be
-log10(p_value)):
id	log2fc	-log10(pvalue)	significant
1	0	0	1
1	0	0	1
3	0	0	1
1	0	0	0
2	0	0	0
1	0	0	0

id	log2fc	-log10(pvalue)	significant
1	0	0	TRUE
1	0	0	TRUE
3	0	0	TRUE
1	0	0	FALSE
2	0	0	FALSE
1	0	0	FALSE

The parameters for logical variable are either TRUE or FALSE.

${txtbld}OPTIONS${txtrst}:
	-f	Data file (with header line, the first column is not the
 		rowname, tab seperated)${bldred}[NECESSARY]${txtrst}
	-x	Variable name for x-axis value.
		${bldred}[NECESSARY, in sample data 'log2fc']${txtrst}
	-m	Make x-axis symmetry. [Default TRUE, accept FALSE]
	-y	Variable name for y-axis value.
		${bldred}[NECESSARY, in sample data 'pvalue']${txtrst}
	-s	Column for labeling status.
		${bldred}[NECESSARY, in sample data 'significant'. Points will 
		be colored differently ]${txtrst}
	-S	Levels for labeling column, like "'TRUE','FALSE'".
   		[${bldred}Only needed when you trying to reorder the
		column to get different colors.${txtrst}]	
	-l	Label the names of significant points in graph.
		${bldred}[Default FALSE, accept a string represents the
		colname of labels. When TRUE, give the
		value to -V in column given to -s indicates which rows 
		you want to label]${txtrst}
	-V	Genes with this given value will be labeled.
		${bldred}[NECESSARY when -l is TRUE]${txtrst}
	-t	Title of picture[${txtred}Default empty title${txtrst}]
		[Scatter plot of horizontal and vertical variable]
	-X	Xlab label[${txtred}Default NULL${txtrst}]
	-Y	Ylab label[${txtred}Default NULL${txtrst}]
	-a	Transparent alpha value.
		[${txtred}Default 0.4, Accept a float from
		[0(transparent),1(opaque)]${txtrst}]
	-p	Point size.[${txtred}Default 1${txtrst}]
	-L	Legend position[${txtred}Default right. Accept
		top,bottom,left,none, or c(0.08,0.8).${txtrst}]
	-u	The width of output picture.[${txtred}Default 12${txtrst}]
	-v	The height of output picture.[${txtred}Default 12${txtrst}] 
	-E	The type of output figures.[${txtred}Default pdf, accept
		eps/ps, tex (pictex), png, jpeg, tiff, bmp, svg and wmf)${txtrst}]
	-r	The resolution of output picture.[${txtred}Default NA${txtrst}]
	-e	Execute or not[${bldred}Default TRUE${txtrst}]
	-i	Install the required packages[${bldred}Default FALSE${txtrst}]
EOF
}

file=''
x_var=''
y_var=''
status_col=''
status_col_level=''
label='FALSE'
val_label=''
title=''
x_label='NULL'
y_label='NULL'
alpha=0.4
point_size=1
execute='TRUE'
ist='FALSE'
uwid=12
vhig=12
#res='NA'
res=300
symmetry='TRUE'
legend_pos='right'
status_col_level=''
ext='pdf'
colormodel='srgb'

while getopts "hf:x:m:y:s:-S:l:L:V:t:X:Y:a:p:u:v:E:r:e:i:" OPTION
do
	case $OPTION in
		h)
			echo "Help mesage"
			usage
			exit 1
			;;
		f)
			file=$OPTARG
			;;
		x)
			x_var=$OPTARG
			;;
		m)
			symmetry=$OPTARG
			;;
		y)
			y_var=$OPTARG
			;;
		s)
			status_col=$OPTARG
			;;
		S)
			status_col_level=$OPTARG
			;;
		l)
			label=$OPTARG
			;;
		L)
			legend_pos=$OPTARG
			;;
		V)
			val_label=$OPTARG
			;;
		t)
			title=$OPTARG
			;;
		X)
			x_label=$OPTARG
			;;
		Y)
			y_label=$OPTARG
			;;
		a)
			alpha=$OPTARG
			;;
		p)
			point_size=$OPTARG
			;;
		u)
			uwid=$OPTARG
			;;
		v)
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
			echo "Unknown parameters"
			exit 1
			;;
	esac
done

if [ -z $file ] ; then
	echo 1>&2 "Please give filename."
	usage
	exit 1
fi

mid='.volcano'

cat <<END >${file}${mid}.r

if ($ist){
	install.packages("ggplot2", repo="http://cran.us.r-project.org")
}

library(ggplot2)
data <- read.table(file="$file", header=T, sep="\t")
sig_level <- c(${status_col_level})
if (length(sig_level)>1){
	data\$${status_col} <- factor(data\$${status_col},levels=sig_level,
		ordered=T)
}

p <- ggplot(data=data, aes(x=${x_var},y=${y_var},colour=${status_col}))
p <- p + geom_point(alpha=${alpha}, size=${point_size})
p <- p + theme(legend.position="none") + theme_bw() + 
	theme(legend.title=element_blank(),
	panel.grid.major = element_blank(), panel.grid.minor = element_blank())


if (${symmetry}) {
	boundary <- ceiling(max(abs(data\$${x_var})))
	p <- p + xlim(-1 * boundary, boundary)
}
if ($label != "FALSE"){
	data.l <- data[data\$${status_col}=="$val_label",]
	p <- p + geom_text(data=data.l, aes(x=${x_var}, y=${y_var},
	labels=$label), colour="black")
}


top='top'
botttom='bottom'
left='left'
right='right'
none='none'
legend_pos_par <- ${legend_pos}

#if ("${legend_pos}" != "right"){
p <- p + theme(legend.position=legend_pos_par)
#}


if ("${ext}" == "pdf") {
	ggsave(p, filename="${file}${mid}.${ext}", dpi=$res, width=$uwid,
	height=$vhig, units=c("cm"),colormodel="${colormodel}")
} else {
	ggsave(p, filename="${file}${mid}.${ext}", dpi=$res, width=$uwid,
	height=$vhig, units=c("cm"))
}

#png(filename="${file}${mid}.png", width=$uwid, height=$vhig,
#res=$res)
#p
#dev.off()
END

if [ "$execute" == "TRUE" ]; then
	Rscript ${file}${mid}.r
if [ "$?" == "0" ]; then /bin/rm -f ${file}${mid}.r; fi
fi

#if [ "$quiet" == "TRUE" ]; then
#	/bin/rm -f ${file}${mid}.r
#fi
#convert -density 200 -flatten ${file}${mid}.eps ${first}${mid}.png
