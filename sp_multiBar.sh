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

This script is used to do boxplot using ggplot2.

fileformat for -f (suitable for data extracted from one sample)

Gene	hmC	expr	Set
NM_001003918_26622	0	83.1269257376101	1
NM_001011535_3260	0	0	1
NM_001012640_14264	0	0	1
NM_001012640_30427	0	0	1
NM_001003918_266221	0	0	1
NM_001017393_30504	0	0	1
NM_001025241_30464	0	0	1
NM_001017393_30504	0	0	1

fileformat when -m is true
#The name "value" and "variable" shoud not be altered.
#"Set" needs to be the parameter after -a.
#Actually this format is the melted result of last format.
value	variable	Set
0	var	1
1	vhig	2

${txtbld}OPTIONS${txtrst}:
	-f	Data file (with header line, the first column is the
 		colname, tab seperated)${bldred}[NECESSARY]${txtrst}
	-m	When true, it will skip preprocess. But the format must be
		the same as listed before.
		${bldred}[Default FALSE, accept TRUE]${txtrst}
	-a	Name for x-axis variable
		[${txtred}Necessary, for example 'Gene' which represents 
	   	name of each gene Set${txtrst}]
	-b	Order of xvariable (parameter for -a). 	
		[${txtred}Optional, format: 'chr1','chr2','chr3',...${txtrst}]
		["'chr1','chr2','chr3','chr4','chr5','chr6','chr7','chr8',
		'chr9','chr10','chr11','chr12','chr13','chr14','chr15',
		'chr16','chr17','chr18','chr19','chrX','chrY','chrM'"]
	-l	Order for legend.
		[${txtred}Optional, format: 'Expected','5hmC',...${txtrst}]
	-n	Rotation angle for x-axis.  
		[${txtred}Optional, Default oriental. Accept an integer
		like 45,90 (count anti-clockwise). ${txtrst}]
	-g	Variable name for facet.
		[${txtred}Optional, like 'sample' or 'grp' ${txtrst}]
	-j	Number of columns in one row.	
		[${txtred}Necessary if -g is given ${txtrst}]
	-k	Paramter for scales for facet.
		[${txtred}Optional, only used when -g is given. Default each 
	    inner graph use same scale [x,y range]. 'free','free_x','free_y' 
	    is accepted. ${txtrst}]
	-o	Order of facet.
		[${txtred}Optional, format:
		'F1_6-1','R1','F1_MEF','1422','2737','17-3-15','15-4-6','513','233'${txtrst}]
	-p	Other columns that needs to be ignored.
		[Optional, format (begins with ,) ',col_name1,colname2...']
	-t	Title of picture[${txtred}Default empty title${txtrst}]
	-x	xlab of picture[${txtred}Default empty xlab${txtrst}]
	-y	ylab of picture[${txtred}Default empty ylab${txtrst}]
	-s	Scale y axis
		[${txtred}Default null. Accept TRUE.${txtrst}]
	-v	If scale is TRUE, give the following
		scale_y_log10(), coord_trans(y="log10"), or other legal
		#command for ggplot2)${txtrst}]
	-w	The width of output picture.[${txtred}Default 20${txtrst}]
	-u	The height of output picture.[${txtred}Default 12${txtrst}] 
	-E	The type of output figures.[${txtred}Default png, accept
		eps/ps, tex (pictex), pdf, jpeg, tiff, bmp, svg and wmf)${txtrst}]
	-r	The resolution of output picture.[${txtred}Default 300 ppi${txtrst}]
	-z	Is there a header[${bldred}Default TRUE${txtrst}]
	-e	Execute or not[${bldred}Default TRUE${txtrst}]
	-i	Install depeneded packages[${bldred}Default FALSE${txtrst}]
EOF
}

file=
title=''
melted='FALSE'
xlab='NULL'
ylab='NULL'
xvariable=''
xvar_order=''
legend_order=''
angle=0
facet='haha'
facet_ncol=1
facet_order=''
col_exclu=''
scales='fixed'
scaleY='FALSE'
scaleY_x='FALSE'
header='TRUE'
execute='TRUE'
ist='FALSE'
uwid=20
vhig=12
res=300
ext='png'


while getopts "hf:m:a:b:l:o:n:g:j:k:p:t:x:y:w:u:r:E:s:z:v:e:i:" OPTION
do
	case $OPTION in
		h)
			usage
			exit 1
			;;
		f)
			file=$OPTARG
			;;
		m)
			melted=$OPTARG
			;;
		a)
			xvariable=$OPTARG
			;;
		b)
			xvar_order=$OPTARG
			;;
		l)
			legend_order=$OPTARG
			;;
		o)
			facet_order=$OPTARG
			;;
		n)
			angle=$OPTARG
			;;
		g)
			facet=$OPTARG
			;;
		j)
			facet_ncol=$OPTARG
			;;
		k)
			scales=$OPTARG
			;;
		p)
			col_exclu=$OPTARG
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
		s)
			scaleY=$OPTARG
			;;
		v)
			scaleY_x=$OPTARG
			;;
		z)
			header=$OPTARG
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

if [ -z $file ]; then
	usage
	exit 1
fi

mid=".multiBarNew"

cat <<END >${file}${mid}.r

if ($ist){
	install.packages("ggplot2", repo="http://cran.us.r-project.org")
	install.packages("reshape2", repo="http://cran.us.r-project.org")
}
library(ggplot2)
library(reshape2)

if(! $melted){

	data <- read.table(file="${file}", sep="\t", header=$header)
	if ("${facet}" != "haha"){
		id_vars = c("${xvariable}", "${facet}" ${col_exclu})
		#data_m <- melt(data, id.vars=c("${xvariable}", "${facet}"))
	} else {
		id_vars = c("${xvariable}" ${col_exclu})
		#data_m <- melt(data, id.vars=c("${xvariable}"))
	}
	data_m <- melt(data, id.vars=id_vars)
} else {
	data_m <- read.table(file="$file", sep="\t",
	header=$header)
}

if ("${legend_order}" != ""){
	data_m\$variable <- factor(data_m\$variable,
	levels=c(${legend_order}))
}

if ("${xvar_order}" != ""){
	data_m\$${xvariable} <- factor(data_m\$${xvariable},
	levels=c(${xvar_order}))
}

if ("${facet_order}" != ""){
	data_m\$${facet} <- factor(data_m\$${facet},
	levels=c(${facet_order}))
}

p <- ggplot(data_m, aes(factor($xvariable), value)) + xlab($xlab) +
ylab($ylab)

p <- p + geom_bar(aes(fill=factor(variable)), stat="identity",
position="dodge") + theme_bw()

if ($angle != 0) {
	p <- p + theme(axis.text.x=element_text(angle=${angle},hjust=1))
}

if ("$facet" != "haha"){
	p <- p + facet_wrap(~${facet}, ncol=${facet_ncol},
	scales="${scales}")
}



if("$scaleY"){
	p <- p + $scaleY_x
}


ggsave(p, filename="${file}${mid}.${ext}", dpi=$res, width=$uwid,
height=$vhig, units=c("cm"))

#png(filename="${file}${mid}.png", width=$uwid, height=$vhig,
#res=$res)
#p
#dev.off()
END

if [ "$execute" == "TRUE" ]; then
	Rscript ${file}${mid}.r
if [ "$?" == "0" ]; then /bin/rm -f ${file}${mid}.r; fi
fi

