#!/bin/bash

#set -x

usage()
{
cat <<EOF
${txtcyn}

***CREATED BY Chen Tong (chentong_biology@163.com)***
***FURTHER MODIFY BY Lin Dechun (lindechun@genomics.cn)***
## add -o and auto decide width and height.

## add -o

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
		["Heatmap of gene expression profile"]
	-a	Display xtics. ${bldred}[Default TRUE]${txtrst}
	-A	Rotation angle for x-axis value (anti clockwise)
		${bldred}[Default 90]${txtrst}
	-b	Display ytics. ${bldred}[Default TRUE]${txtrst}
	-H	Hieratical cluster for columns.
		${bldred}Default FALSE, accept TRUE${txtrst}
	-R	Hieratical cluster for rows.
		${bldred}Default TRUE, accept FALSE${txtrst}
	-c	Clustering method, Default "complete". 
		Accept "ward.D", "ward.D2","single", "average" (=UPGMA), 
		"mcquitty" (=WPGMA), "median" (=WPGMC) or "centroid" (=UPGMC)
	-C	Color vector.
		${bldred}Default pheatmap_default. 
		Aceept a vector containing multiple colors such as 
		<'c("white", "blue")'> will be transferred 
		to <colorRampPalette(c("white", "blue"), bias=${bias})(30)>
		or an R function 
		<colorRampPalette(rev(brewer.pal(n=7, name="RdYlBu")))(100)>
		generating a list of colors.
		${txtrst}
	-T	Color type, a vetcor which will be transferred as described in <-C> [vector] or
   		a raw vector [direct vector] or	a function [function (default)].
	-B	A positive number. Default 1. Values larger than 1 will give more color
   		for high end. Values between 0-1 will give more color for low end.	
	-D	Clustering distance method for rows.
		${bldred}Default 'correlation', accept 'euclidean', 
		"manhattan", "maximum", "canberra", "binary", "minkowski". ${txtrst}
	-I	Clustering distance method for cols.
		${bldred}Default 'correlation', accept 'euclidean', 
		"manhattan", "maximum", "canberra", "binary", "minkowski". ${txtrst}
	-L	First get log-value, then do other analysis.
		Accept an R function log2 or log10. 
		${bldred}[Default FALSE]${txtrst}
	-d	Scale the data or not for clustering and visualization.
		[Default 'none' means no scale, accept 'row', 'column' to 
		scale by row or column.]
	-m	The maximum value you want to keep, any number larger willl
		be taken as this given maximum value.
		[${bldred}Default Inf, Optional${txtrst}] 
	-s	The smallest value you want to keep, any number smaller will
		be taken as this given minimum value.
		[${bldred}Default -Inf, Optional${txtrst}]  
	-k	Aggregate the rows using kmeans clustering. 
		This is advisable if number of rows is so big that R cannot 
		handle their hierarchical clustering anymore, roughly more than 1000.
		Instead of showing all the rows separately one can cluster the
		rows in advance and show only the cluster centers. The number
		of clusters can be tuned here.
		[${txtred}Default 'NA' which means no
		cluster, other positive interger is accepted for executing
		kmeans cluster, also the parameter represents the number of
		expected clusters.${txtrst}]
	-P	A file to specify row-annotation with format described above.
		[${txtred}Default NA${txtrst}]
	-Q	A file to specify col-annotation with format described above.
		[${txtred}Default NA${txtrst}]
	-u	The width of output picture.[${txtred}Default auto calculate${txtrst}]
	-v	The height of output picture.[${txtred}Default auto calculate${txtrst}] 
	-E	The type of output figures.[${txtred}Default pdf, accept
		eps/ps, tex (pictex), png, jpeg, tiff, bmp, svg and wmf)${txtrst}]
	-r	The resolution of output picture.[${txtred}Default 300 ppi${txtrst}]
	-F	Font size [${txtred}Default 14${txtrst}]
	-p	Preprocess data matrix to avoid 'STDERR 0 in cor(t(mat))'.
		Lowercase <p>.
		[${txtred}Default FALSE${txtrst}]
	-e	Execute script (Default) or just output the script.
		[${bldred}Default TRUE${txtrst}]
	-o	path of Output.[Default Current path, Optinal]
	-i	Install the required packages. Normmaly should be TRUE if this is 
		your first time run s-plot.[${bldred}Default FALSE${txtrst}]
EOF
}

file=''
title=''
cluster_rows='TRUE'
cluster_cols='FALSE'
clustering_distance_rows='correlation'
clustering_distance_cols='correlation'
clustering_method='complete'
legend_breaks='NA'
color_vector='colorRampPalette(rev(brewer.pal(n=7, name="RdYlBu")))(100)'
color_type='function'
width=''
label=''
logv='FALSE'
kclu='NA'
scale='none'
execute='TRUE'
ist='FALSE'
legend=' '
na_color='grey'
uwid='FALSE'  ## modify by lindechun, old: 20
vhig='FALSE'  ## modify by lindechun, old: 20
bias=1
res=300
fontsize=14
ext='pdf'
xcol='green'
ycol='red'
mcol='yellow'
mid_value_use='FALSE'
mid_value='Inf'
maximum='Inf'
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
preprocess='FALSE'
minimum='-Inf'
output=$(pwd)

while getopts "hf:t:a:A:b:B:H:R:c:D:T:p:I:L:d:k:u:v:E:r:F:P:Q:x:y:M:Z:X:s:m:N:Y:G:C:O:e:o:i:" OPTION
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
		B)
			bias=$OPTARG
			;;
		H)
			cluster_cols=$OPTARG
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
			minimum=$OPTARG
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
		T)
			color_type=$OPTARG
			;;
		O)
			givenSepartor=$OPTARG
			;;
		e)
			execute=$OPTARG
			;;
		o)
			output=$OPTARG
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

mid=".pheatmap"

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

cat <<END >$output/$(basename $file)${mid}.r
source('$(cd `dirname $0`; pwd)/rFunction.R')

if ($ist){
	installp("pheatmap",force = F)
	# install.packages("pheatmap", repo="http://cran.us.r-project.org")
}

library(grid)
library(pheatmap)

if($gradient){
	library(RColorBrewer)
}

#draw_colnames_custom <- function (coln, ...){
#	m = length(coln)
#	x = (1:m)/m - 1/2/m
#	grid.text(coln, x=x, y=unit(0.96, "npc"), vjust=.5, hjust=1,
#	rot=${xtics_angle}, gp=gpar(...))
#}
#
#
##Ref:http://stackoverflow.com/questions/15505607/diagonal-labels-orientation-on-x-axis-in-heatmaps


# Get the function to edit trace(pheatmap:::draw_colnames,  edit=TRUE)
# in R console

find_coordinates = function(n, gaps, m=1:n) {
	if(length(gaps)==0){
		return(list(coord=unit(m/n, "npc"), size=unit(1/n,"npc")))
	}

	if(max(gaps)>n){
		stop("Gaps do not match matrix size")
	}

	size = (1/n)*(unit(1, "npc")-length(gaps)*unit("4", "bigpts"))

	gaps2 = apply(sapply(gaps, function(gap, x){x>gap}, m), 1, sum)
	coord = m * size + (gaps2 * unit("4", "bigpts"))

	return(list(coord=coord, size=size))
}


vjust <- 0
hjust <- 0.5

if(${xtics_angle}==270){
	vjust <- 0.5
	hjust <- 0
}else if(${xtics_angle}==45){
	vjust <- .5
	hjust <- 1
}else if(${xtics_angle}==0){
	vjust <- 1
	hjust <- 0.5
}



draw_colnames_custom <- function (coln, gaps, ...){
	coord = find_coordinates(length(coln),  gaps)
	x = coord\$coord - 0.5 * coord\$size
	if (${xtics_angle}  == 90){
		hjust = 1
		vjust = 0.5
	}
	if (${xtics_angle}  == 45){
		hjust = 1
		vjust = 0.5
	}

	res = textGrob(coln, x=x, y=unit(1, "npc")-unit(3, "bigpts"),
		vjust = vjust, hjust=hjust, rot=${xtics_angle}, gp=gpar(...))
	return(res)
}


# Overwrite default draw_colnames with your own version
assignInNamespace(x="draw_colnames", value="draw_colnames_custom", 
	ns=asNamespace("pheatmap"))

data <- read.table(file="$file", sep="\t", header=T, row.names=1,
	check.names=F, quote="", comment="")

if ("${logv}" != "FALSE"){
	#data[data==0] <- 1.0000001
	#data[data==1] <- 1.0001
	data <- ${logv}(data+1)
}

if ($gradient == 1){
	legend_breaks = NA
} else if ($gradient == 2){
	if (${mid_value} == Inf){
		summary_v <- c(t(data))
		legend_breaks <- unique(c(seq(summary_v[1]*0.95,summary_v[2],length=6),
		  seq(summary_v[2],summary_v[3],length=6),
		  seq(summary_v[3],summary_v[5],length=5),
		  seq(summary_v[5],summary_v[6]*1.05,length=5)))
	} else {
		legend_breaks <- unique(c(seq(summary_v[1]*0.95, ${mid_value},
		 length=10), seq(${mid_value},summary_v[6]*1.05,length=10)))
	}

	if("${digits}" != "FALSE"){
		legend_breaks <- prettyNum(legend_breaks, digits=${digits})
	}
	
	print(col)
	print(legend_breaks)
} else {
	legend_breaks <- c($givenSepartor)
}


if ("${annotation_row}" != "NA") {
	annotation_row <- read.table(file="${annotation_row}", header=T,
		row.names=1, sep="\t", quote="", check.names=F, comment="")
} else {
	annotation_row <- NA
}

if ("${annotation_col}" != "NA") {
	annotation_col <- read.table(file="${annotation_col}", header=T,
		row.names=1, sep="\t", quote="", check.names=F, comment="")
	# Do not remember what this is for?
	#levs <- unique(unlist(lapply(annotation_col, unique)))
	#annotation_col <- data.frame(lapply(annotation_col, factor,
	#	levels=levs), row.names=rownames(annotation_col))
} else {
	annotation_col <- NA
}

data[data>${maximum}] <- ${maximum}
if ("${minimum}" != "-Inf"){
	data[data<${minimum}] <- ${minimum}
}

if ("${color_type}" == "function"){
	color_vector <- ${color_vector}
} else if ("${color_type}" == "vector"){
	colfunc <- colorRampPalette(${color_vector}, bias=${bias})
	color_vector <- colfunc(30)
} else {
	color_vector <- ${color_vector}
}

### control width and height add by lin dechun

if (!is.numeric(${uwid})) {
	if ("${annotation_row}" != "NA" || "${annotation_col}" != "NA") {
		temp1=ncol(data)+max(sapply(rownames(data),nchar))/10+4
	} else {
		temp1=ncol(data)+max(sapply(rownames(data),nchar))/10+2
	}

	temp2=nrow(data)+max(sapply(colnames(data),nchar))/10

	if (temp1 > temp2){
		temp2=temp2*(8/temp1)
		temp1=8
	} else{
		temp1=temp1*(8/temp2)
		temp2=8
	}

	pheatmap(data, kmean_k=$kclu, color=color_vector, 
	scale="${scale}", border_color=NA,
	cluster_rows=${cluster_rows}, cluster_cols=${cluster_cols}, 
	breaks=legend_breaks, clustering_method="${clustering_method}",
	clustering_distance_rows="${clustering_distance_rows}", 
	clustering_distance_cols="${clustering_distance_cols}", 
	legend_breaks=legend_breaks, show_rownames=${ytics}, show_colnames=${xtics}, 
	main="$title", annotation_col=annotation_col,
	annotation_row=annotation_row, 
	fontsize=${fontsize}, filename="$output/$(basename $file)${mid}.${ext}", width=temp1,
	height=temp2)
}else{
	pheatmap(data, kmean_k=$kclu, color=color_vector, 
	scale="${scale}", border_color=NA,
	cluster_rows=${cluster_rows}, cluster_cols=${cluster_cols}, 
	breaks=legend_breaks, clustering_method="${clustering_method}",
	clustering_distance_rows="${clustering_distance_rows}", 
	clustering_distance_cols="${clustering_distance_cols}", 
	legend_breaks=legend_breaks, show_rownames=${ytics}, show_colnames=${xtics}, 
	main="$title", annotation_col=annotation_col,
	annotation_row=annotation_row, 
	fontsize=${fontsize}, filename="$output/$(basename $file)${mid}.${ext}", width=${uwid},
	height=${vhig})
}

cat(system("/bin/rm -f Rplots.pdf",intern=TRUE))

END


if [ "$execute" == "TRUE" ]; then
	Rscript $output/$(basename $file)${mid}.r
	if [ "$?" == "0" ]; then
		/bin/rm -f $output/$(basename $file)${mid}.r
		/bin/rm -f Rplots.pdf
	fi
fi

if test "${preprocess}" == "TRUE"; then
	/bin/mv -f ${file}".nostd0" ${file}
fi

#convert -density 200 -flatten ${file}${mid}.eps ${first}${mid}.png
