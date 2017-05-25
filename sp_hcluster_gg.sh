#!/bin/bash

#set -x

usage()
{
cat <<EOF
${txtcyn}

***CREATED BY Chen Tong (chentong_biology@163.com)***

----Matrix file--------------
Name	T0_1	T0_2	T0_3	T4_1	T4_2
TR19267|c0_g1|CYP703A2	1.431	0.77	1.309	1.247	0.485
TR19612|c1_g3|CYP707A1	0.72	0.161	0.301	2.457	2.794
TR60337|c4_g9|CYP707A1	0.056	0.09	0.038	7.643	15.379
TR19612|c0_g1|CYP707A3	2.011	0.689	1.29	0	0
TR35761|c0_g1|CYP707A4	1.946	1.575	1.892	1.019	0.999
TR58054|c0_g2|CYP707A4	12.338	10.016	9.387	0.782	0.563
TR14082|c7_g4|CYP707A4	10.505	8.709	7.212	4.395	6.103
TR60509|c0_g1|CYP707A7	3.527	3.348	2.128	3.257	2.338
TR26914|c0_g1|CYP710A1	1.899	1.54	0.998	0.255	0.427
----Matrix file--------------


----Column annotation file --------------
------1. At least two columns--------------
------2. The first column should be the same as the first row in
---------matrix (order does not matter)--------------
Name	Sample
T0_1	T0
T0_2	T0
T0_3	T0
T4_1	T4
T4_2	T4
----Column annorarion file --------------


Usage:

$0 options${txtrst}

${bldblu}Function${txtrst}:

This script is used to do heatmap using package pheatmap.

The parameters for logical variable are either TRUE or FALSE.

${txtbld}OPTIONS${txtrst}:
	-f	Data file (with header line, the first column is the
 		rowname, tab seperated. Colnames must be unique unless you
		know what you are doing.)${bldred}[NECESSARY]${txtrst}
	-t	Title of picture[${txtred}Default empty title${txtrst}]
		[Scatter plot of horizontal and vertical variable]
	-H	Cluster tree shown in horizontal format.
		${bldred}Default FALSE meaning vertical tree, accept TRUE${txtrst}
	-c	Clustering method, Default "complete". 
		Accept "ward.D", "ward.D2","single", "average" (=UPGMA), 
		"mcquitty" (=WPGMA), "median" (=WPGMC) or "centroid" (=UPGMC)
	-C	Color vector. 
		${bldred}Default pheatmap_default. Aceept a vector containing
		multiple colors such as <c("white", "blue")> or 
		a R function generating a list of colors.${txtrst}
	-I	Clustering distance method for cols.
		${bldred}Default 'correlation', accept 'euclidean', 
		"manhattan", "maximum", "canberra", "binary", "minkowski". ${txtrst}
	-L	First get log-value, then do other analysis.
		Accept an R function log2 or log10. 
		${bldred}[Default FALSE]${txtrst}
	-d	Scale the data or not for clustering and visualization.
		[Default 'none' means no scale, accept 'row', 'column' to 
		scale by row or column.]
	-Q	A file to specify col-annotation.[${txtred}Default NA${txtrst}]
	-u	The width of output picture.[${txtred}Default 20${txtrst}]
	-v	The height of output picture.[${txtred}Default 20${txtrst}] 
	-E	The type of output figures.[${txtred}Default pdf, accept
		eps/ps, tex (pictex), png, jpeg, tiff, bmp, svg and wmf)${txtrst}]
	-r	The resolution of output picture.[${txtred}Default 300 ppi${txtrst}]
	-F	Font size [${txtred}Default 14${txtrst}]
	-e	Execute or not[${bldred}Default TRUE${txtrst}]
	-i	Install the required packages[${bldred}Default FALSE${txtrst}]

Example: sp_hcluster_gg.sh -f matrix.pearson.xls -Q cluster.txt

EOF
}

file=''
title=''
horizontal='FALSE'
clustering_distance_cols='correlation'
clustering_method='complete'
legend_breaks='NA'
color_vector='colorRampPalette(rev(brewer.pal(n=7, name="RdYlBu")))(100)'
width=''
label=''
logv='FALSE'
kclu='NA'
scale='none'
execute='TRUE'
ist='FALSE'
legend=' '
na_color='grey'
uwid=20
vhig=20
res=300
fontsize=14
ext='pdf'
colormodel='srgb'
xcol='green'
ycol='red'
mcol='yellow'
mid_value_use='FALSE'
mid_value='Inf'
xtics='TRUE'
xtics_angle=270
ytics='TRUE'
gradient=1
givenSepartor=''
gradientC="'green','yellow','red'"
generateNA='FALSE'
digits='FALSE'
annotation_row='NA'
annotation_col='NA'
preprocess='TRUE'

while getopts "hf:t:a:A:b:H:R:c:D:p:I:L:d:k:u:v:E:r:F:P:Q:x:y:M:Z:X:s:m:N:Y:G:C:O:e:i:" OPTION
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
		t)
			title=$OPTARG
			;;
		a)
			xtics=$OPTARG
			;;
		A)
			xtics_angle=$OPTARG
			;;
		b)
			ytics=$OPTARG
			;;
		H)
			horizontal=$OPTARG
			;;
		R)
			cluster_rows=$OPTARG
			;;
		c)
			clustering_method=$OPTARG
			;;
		D)
			clustering_distance_rows=$OPTARG
			;;
		I)
			clustering_distance_cols=$OPTARG
			;;
		p)
			preprocess=$OPTARG
			;;
		L)
			logv=$OPTARG
			;;
		P)
			annotation_row=$OPTARG
			;;
		Q)
			annotation_col=$OPTARG
			;;
		d)
			scale=$OPTARG
			;;
		k)
			kclu=$OPTARG
			;;
		u)
			uwid=$OPTARG
			;;
		v)
			vhig=$OPTARG
			;;
		E)
			ext=$OPTARG
			;;
		r)
			res=$OPTARG
			;;
		F)
			fontsize=$OPTARG
			;;
		x)
			xcol=$OPTARG
			;;
		y)
			ycol=$OPTARG
			;;
		M)
			mcol=$OPTARG
			;;
		K)
			logv_pos=$OPTARG
			;;
		Z)
			mid_value_use=$OPTARG
			;;
		X)
			mid_value=$OPTARG
			;;
		s)
			small=$OPTARG
			;;
		m)
			maximum=$OPTARG
			;;
		N)
			generateNA=$OPTARG
			;;
		Y)
			na_color=$OPTARG
			;;
		G)
			gradient=$OPTARG
			;;
		C)
			color_vector=$OPTARG
			;;
		O)
			givenSepartor=$OPTARG
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

mid=".hcluster"

if [ -z $file ] ; then
	echo 1>&2 "Please give filename."
	usage
	exit 1
fi


if test "$log" != ''; then
	mid=${mid}".$log"
fi

if test "${scale}" == "TRUE"; then
	mid=${mid}".scale"
fi

if test "${preprocess}" == "TRUE"; then
	/bin/mv -f ${file} ${file}".nostd0"
	dealWithSTD0.py -i ${file}".nostd0" >${file}
fi


cat <<END >${file}${mid}.r

if ($ist){
	install.packages("ggplot2", repo="http://cran.us.r-project.org")
	install.packages("ggdendro", repo="http://cran.us.r-project.org")
	install.packages("amap", repo="http://cran.us.r-project.org")
}

library(ggplot2)
library(ggdendro)
library(amap)

if($gradient){
	library(RColorBrewer)
}

data <- read.table(file="$file", sep="\t", header=T, row.names=1,
	check.names=F, quote="", comment="")


if ("${annotation_col}" != "NA") {
	annotation_col <- read.table(file="${annotation_col}", header=T,
		row.names=1, sep="\t", quote="", check.names=F, comment="")
	levs <- unique(unlist(lapply(annotation_col, unique)))
	annotation_col <- data.frame(lapply(annotation_col, factor,
		levels=levs), row.names=rownames(annotation_col))
} else {
	annotation_col <- NA
}

hc <- hcluster(data)
dhc <- as.dendrogram(hc)
dhc_data <- dendro_data(dhc, type="rectangle")

p <- ggplot(segment(dhc_data)) +
	geom_segment(aes(x=x, y=y, xend=xend, yend=yend)) +
	theme(axis.line.y=element_blank(), 
		axis.ticks.y=element_blank(), 
		axis.text.y=element_blank(), 
		axis.title.y=element_blank(), 
		panel.background=element_rect(fill="white"), 
		panel.grid=element_blank(), 
		legend.position="top")

if ("${annotation_col}" != "NA") {
	if (${horizontal}){
		p <- p + geom_text(data=dhc_data\$labels, aes(x,y,label=label, 
			color=annotation_col[,1]), angle=90, size=2, hjust=0) +
			oord_flip() + scale_y_reverse(expand=c(0.2, 0))	
	}else {
		p <- p + geom_text(data=dhc_data\$labels, aes(x,y,label=label, 
			color=annotation_col[,1]), angle=90, size=2, vjust=0) +
	}
} else {
	if (${horizontal}){
		p <- p + geom_text(data=dhc_data\$labels, aes(x,y,label=label), 
			angle=90, size=2, hjust=0) +
			oord_flip() + scale_y_reverse(expand=c(0.2, 0))	
	}else {
		p <- p + geom_text(data=dhc_data\$labels, aes(x,y,label=label), 
			angle=90, size=2, vjust=0) +
	}
}

if ("${ext}" == "pdf") {
	ggsave(p, filename="${file}${mid}.${ext}", dpi=$res, width=$uwid,
	height=$vhig, units=c("cm"),colormodel="${colormodel}")
} else {
	ggsave(p, filename="${file}${mid}.${ext}", dpi=$res, width=$uwid,
	height=$vhig, units=c("cm"))
}
END


if [ "$execute" == "TRUE" ]; then
	Rscript ${file}${mid}.r
	if [ "$?" == "0" ]; then 
		/bin/rm -f ${file}${mid}.r
		/bin/rm -f Rplots.pdf	
	fi
fi

if test "${preprocess}" == "TRUE"; then
	/bin/mv -f ${file}".nostd0" ${file}
fi

#convert -density 200 -flatten ${file}${mid}.eps ${first}${mid}.png
