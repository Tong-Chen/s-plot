#!/bin/bash

usage()
{
cat <<EOF
${txtcyn}

***CREATED BY Chen Tong (chentong_biology@163.com)***

Usage:

$0 options${txtrst}

${bldblu}Function${txtrst}:

This script is used to do clustring using heatmap.2.

${txtbld}OPTIONS${txtrst}:
	-f	Data file (with header line, the first column is the
 		colname, tab seperated)${bldred}[NECESSARY]${txtrst}
	-k	If the names of your rows and columns startwith numeric value,
		this can be set to FALSE to avoid modifying these names to be
		illegal variable names. But duplicates can not be picked out.
		[${bldred}Default TRUE${txtrst}]
		Accept FALSE.
	-t	Title of picture[${txtred}Default empty title${txtrst}]
	-x	xlab of picture[${txtred}Default empty xlab${txtrst}. 
		If setted, using the words which represents the 
		meaning of your columns]
	-y	ylab of picture[${txtred}Default empty ylab${txtrst}. 
		If setted, using the words which represents the 
		meaning of your rows]
	-r	row cluster[${bldred}Default TRUE${txtrst}]
		Accept FALSE.
	-c	col cluster[${txtred}Default FALSE${txtrst}]
		Accept TRUE.
	-s	row scale[${txtred}Default FALSE${txtrst}]
		Accept TRUE.
	-w	col scale[${txtred}Default FALSE${txtrst}]
		Accept TRUE.
	-C	Set the colormanually. [${txtred}Default 'greenred'${txtrst}]
		Accept a color string 'greenred' or 'greenred(75)' 
		or a function like 
		"colorpanel(2,low='white', high='steelblue')"
	-b	Add a vector for break points.[Default heatmap.2 default.
		Accept '0.0,0.1,0.2,0.3,0.4,0.5,0.6,0.8,1' or 
		\$(echo \`seq 0 0.05 1\` | sed 's/ /,/g')]
	-u	The width of pciture.[${txtred}Default 10${txtrst}]
	-v	The height of pciture.[${txtred}Default 12${txtrst}]
	-R	The size of points.[${txtred}Default 10.${txtrst}]
	-z	Is there a header[${bldred}Default TRUE${txtrst}]
		Accept FALSE.
	-e	Execute or not[${bldred}Default TRUE${txtrst}]
		Accept FALSE.
	-a	Trace line[${txtred}Default none${txtrst}, choice column,
		none, row, both]
	-d	Dendrom [${txtred}Default FALSE${txtrst}]
		Accept TRUE.
EOF
}

file=
checkNames='TRUE'
title=''
xlab=''
ylab=''
row_C='TRUE'
col_C='FALSE'
rows='FALSE'
cols='FALSE'
break_v=" "
header='TRUE'
execute='TRUE'
trace='none'
den='FALSE'
width=10
height=12
res=10
color='greenred'

while getopts "hf:k:t:x:y:r:c:s:C:w:u:v:R:b:z:e:a:d:" OPTION
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
		t)
			title=$OPTARG
			;;
		x)
			xlab=$OPTARG
			;;
		y)
			ylab=$OPTARG
			;;
		r)
			row_C=$OPTARG
			;;
		c)
			col_C=$OPTARG
			;;
		s)
			rows=$OPTARG
			;;
		w)
			cols=$OPTARG
			;;
		C)
			color=$OPTARG
			;;
		u)
			width=$OPTARG
			;;
		v)
			height=$OPTARG
			;;
		R)
			res=$OPTARG
			;;
		b)
			break_v=$OPTARG
			;;
		z)
			header=$OPTARG
			;;
		e)
			execute=$OPTARG
			;;
		a)
			trace=$OPTARG
			;;
		d)
			den=$OPTARG
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

#midname='.Heatmap'
midname=''
scale=

if [ "$rows" = 'TRUE' ]; then
	midname='.RowScale'
	scale='row'
fi

if [ "$cols" = 'TRUE' ]; then
	if [ -z ${midname} ]; then
		midname=${midname}'.ColScale'
	else
		midname=${midname}'.BothScale'
	fi

	if [ -z $scale ]; then
		scale='col'
	else
		scale='both'
	fi
fi

if [ -z $scale ]; then
	scale='none'
fi

dendrogram='none'
if [ "$row_C" = 'TRUE' ] && [ $col_C = 'TRUE' ]; then
	dendrogram='both'
elif [ "$row_C" = 'TRUE' ]; then
	dendrogram='row'
elif [ "$col_C" = 'TRUE' ]; then
	dendrogram='col'
fi	

midname=${midname}'.Heatmap'

cat <<EOF >$file${midname}.r
library(graphics)
data1 = read.table("$file", header=$header,
sep="\t",row.names=1, comment.char="", check.names=${checkNames})
x <- as.matrix(data1)
#rc <- rainbow(nrow(x), start=0, end=.3)
#cc <- rainbow(ncol(x), start=0, end=.3)
library(gplots)
pdf(file="${file}${midname}.pdf", onefile=FALSE,  
	paper="special", width=${width}, height = ${height},
	pointsize=${res})
#png(filename="${file}${midname}.png", width=${width}, height=${height},
#res=${res}, )
break_v <- c($break_v)
if (length(break_v) > 1) {

hv <- heatmap.2(x, col=${color}, trace="${trace}", 
	xlab="$xlab", ylab="$ylab", breaks=break_v, 
	main="$title", margins=c(7,12), keysize=0.6, Rowv=${row_C},
	Colv=${col_C}, dendrogram=c("${dendrogram}"), scale=c("$scale"))

} else {
hv <- heatmap.2(x, col=${color}, trace="${trace}", 
	xlab="$xlab", ylab="$ylab",
	main="$title", margins=c(7,12), keysize=0.6, Rowv=${row_C},
	Colv=${col_C}, dendrogram=c("${dendrogram}"), scale=c("$scale"))
}
dev.off()
EOF

if [ "${den}" = 'TRUE' ]; then
	if [ "$row_C" = 'TRUE' ] && [ $col_C = 'TRUE' ]; then
		cat <<EOF >>$file${midname}.r
	#postscript(file="${file}${midname}.rowden.eps", onefile=FALSE, horizontal=FALSE, 
	#	paper="special", width=10, height = 12, pointsize=10)
	pdf(file="${file}${midname}.pdf", onefile=FALSE,  
		paper="special", width=${width}, height = ${height},
		pointsize=${res})
	#png(filename="${file}${midname}.rowden.png", width=${width},
	#height=${height}, res=${res} )
	plot(hv\$rowDendrogram)
	dev.off()
	#postscript(file="${file}${midname}.colden.eps", onefile=FALSE, horizontal=FALSE, 
	#	paper="special", width=10, height = 12, pointsize=10)
	#png(filename="${file}${midname}.colden.png", width=${width},
	#height=${height}, res=${res})
	pdf(file="${file}${midname}.pdf", onefile=FALSE,  
		paper="special", width=${width}, height = ${height},
		pointsize=${res})
	plot(hv\$colDendrogram)
	dev.off()
EOF
	elif [ "$row_C" = 'TRUE' ]; then
		cat <<EOF >>$file${midname}.r
	#postscript(file="${file}${midname}.rowden.eps", onefile=FALSE, horizontal=FALSE, 
	#	paper="special", width=10, height = 12, pointsize=10)
	#png(filename="${file}${midname}.rowden.png", width=${width},
	#height=${height}, res=${res})
	pdf(file="${file}${midname}.pdf", onefile=FALSE,  
		paper="special", width=${width}, height = ${height},
		pointsize=${res})
	plot(hv\$rowDendrogram)
	dev.off()
EOF
	elif [ "$col_C" = 'TRUE' ]; then
		cat <<EOF >>$file${midname}.r
	#postscript(file="${file}${midname}.colden.eps", onefile=FALSE, horizontal=FALSE, 
	#	paper="special", width=10, height = 12, pointsize=10)
	#png(filename="${file}${midname}.colden.png", width=${width},
	#height=${height}, res=${res})
	pdf(file="${file}${midname}.pdf", onefile=FALSE,  
		paper="special", width=${width}, height = ${height},
		pointsize=${res})
	plot(hv\$colDendrogram)
	dev.off()
EOF
	fi	
fi


if [ "${execute}" = 'TRUE' ]; then
	Rscript $file${midname}.r
	#epstopdf ${file}${midname}.eps
	#convert -density 200 -flatten ${file}${midname}.eps ${file}${midname}.png
#-------------208-218---------
#if [ "${den}" = 'TRUE' ]; then
#	if [ "$row_C" = 'TRUE' ] && [ $col_C = 'TRUE' ]; then
#		convert -density 200 -flatten ${file}${midname}.rowden.eps ${file}${midname}.rowden.png
#		convert -density 200 -flatten ${file}${midname}.colden.eps ${file}${midname}.colden.png
#	elif [ "$row_C" = 'TRUE' ]; then
#		convert -density 200 -flatten ${file}${midname}.rowden.eps ${file}${midname}.rowden.png
#	elif [ "$col_C" = 'TRUE' ]; then
#		convert -density 200 -flatten ${file}${midname}.colden.eps ${file}${midname}.colden.png
#	fi	
#fi
#-------------208-219---------
fi
