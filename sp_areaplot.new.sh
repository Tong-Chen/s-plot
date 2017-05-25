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

This script is used to do areaplot using package ggplo2 and reshape2.

Input data format like:
len known_unexpr known_expr new group
30   1          0   0     1
42   1          0   0     1
45   3          0   0     1
46   1          0   0     1
48   2          0   0     1
49   1          0   0     1

The parameters for logical variable are either TRUE or FALSE.

${txtbld}OPTIONS${txtrst}:
	-f	Data file (with header line, the first column is not the
 		rowname, tab seperated)${bldred}[NECESSARY]${txtrst}
	-x	Variable name for x-axis value.
		${bldred}[NECESSARY, in sample data 'len']${txtrst}
	-g	Variable name for group to wrap data into several frames.
		${bldred}[optional, here 'group', 'FALSE' is forbidden]${txtrst}
	-b	If -g is given and no this variable in your data, please give
		a list of numbers to represent break points, program will
		generate this column.
		${bldred}[optional, like (with quote)
		"c(0,350,879,1300,1816,2430,2900,3338,5000,10000,100000)".
		usually, the first one must be smaller than the smallest. 
		The last one
		should be bigger for the largest for best.
		]${txtrst}
	-s	If you do not know how to set -b. Please give 'TRUE' here.
		The program will give a summary of data distributation
		for reference. [${txtred}Default FALSE${txtrst}]
	-n	If -g is given, please supply a number to indicate how many
		blocks you wanted at each row for outputted graph.
		${bldred}[NECESSARY, if -g is given]${txtrst}
	-t	Title of picture[${txtred}Default empty title${txtrst}]
		[Scatter plot of horizontal and vertical variable]
	-o	Xlab label[${txtred}Default NULL${txtrst}]
	-y	Ylab label[${txtred}Default NULL${txtrst}]
	-u	The width of output picture.[${txtred}Default 2000${txtrst}]
	-v	The height of output picture.[${txtred}Default 2000${txtrst}] 
	-r	The resolution of output picture.[${txtred}Default NA${txtrst}]
	-e	Execute or not[${bldred}Default TRUE${txtrst}]
	-i	Install the required packages[${bldred}Default FALSE${txtrst}]
EOF
}

file=''
x_var=''
grp_var='FALSE'
break_l='FALSE'
summary='FALSE'
ncol=''
title=''
x_label='NULL'
y_label='NULL'
width=''
label=''
execute='TRUE'
ist='FALSE'
uwid=2000
vhig=2000
res='NA'

while getopts "hf:x:g:b:s:n:t:o:y:u:v:r:e:i:" OPTION
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
		g)
			grp_var=$OPTARG
			;;
		b)
			break_l=$OPTARG
			;;
		s)
			summary=$OPTARG
			;;
		n)
			ncol=$OPTARG
			;;
		t)
			title=$OPTARG
			;;
		o)
			x_label=$OPTARG
			;;
		y)
			y_label=$OPTARG
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

mid=".areaplot.new"

if [ -z $file ] ; then
	echo 1>&2 "Please give filename."
	usage
	exit 1
fi


cat <<END >${file}${mid}.r

if ($ist){
	install.packages("ggplot2", repo="http://cran.us.r-project.org")
	install.packages("reshape2", repo="http://cran.us.r-project.org")
}

data <- read.table(file="$file", header=T, sep="\t", quote="")

if ($summary) {
	data.m <- melt(data, id.vars=c("$x_var"))
	alldata <- rep(data.m\$${x_var}, data.m\$value)
	print(summary(alldata))
	quit()
}

library(ggplot2)
library(reshape2)

if ("$grp_var" != "FALSE"){
	break_a=$break_l
	if (length(break_a) > 1){
		group_i_0023 = c()
		for (i in data\$${x_var}){ 
			outlier=1
			for (j in 1:length(break_a)){
				if (i <= break_a[j]){ 
					group_i_0023 = c(group_i_0023, j-1)
					outlier=0
					break 
				}
			} 
			if(outlier==1) {
				group_i_0023=c(group_i_0023,j-1)
			}
		}
		data\$${grp_var} <- group_i_0023
	}
	data.m <- melt(data, id.vars=c("${x_var}", "${grp_var}"))
} else {
	data.m <- melt(data, id.vars=c("${x_var}"))
}

#data.m\$variable <- factor(data.m\$variable, levels=c('1','2','3'))

p <- ggplot(data.m, aes(${x_var},value)) + geom_area(aes(fill=variable,
group=variable), position='stack', alpha=0.5) + xlab(${x_label}) +
ylab(${y_label}) + theme_bw() + theme(legend.title=element_blank(),
panel.grid.major = element_blank(), panel.grid.minor = element_blank())

if("${grp_var}" != "FALSE"){
	p <- p + facet_wrap(~${grp_var}, ncol=${ncol}, scale='free')
}

png(filename="${file}${mid}.png", width=$uwid, height=$vhig,
res=$res)
p
dev.off()
END

if [ "$execute" == "TRUE" ]; then
	Rscript ${file}${mid}.r
if [ "$?" == "0" ]; then /bin/rm -f ${file}${mid}.r; fi
fi

#if [ "$quiet" == "TRUE" ]; then
#	/bin/rm -f ${file}${mid}.r
#fi
#convert -density 200 -flatten ${file}${mid}.eps ${first}${mid}.png
