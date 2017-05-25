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

This script is used to do scatter plot and color them by the third
column data using ggplot2. 
It is designed for representing the expression data which
may be affected by multiple factors(here for two). 

The parameters for logical variable are either TRUE or FALSE.

Input file:

Gene	hmC	Kme	Expr	Size
1_NM_001001130_23818	0.342364	0.387972	0.562945535966746	expr3
2_NM_001001144_16662	1.09501	0.927882	10.6244189482162	expr7
3_NM_001001152_23797	0.14429	0.375741	0	unexpr
4_NM_001001160_10503	0.991374	1.07919	0.0878474532737287	expr1
5_NM_001001176_17970	0.184586	0.202106	0.9731593253037	expr3
6_NM_001001177_28078	0.351389	0.411244	0	unexpr
7_NM_001001178_1650	0.328352	0.295332	0.0490132479669711	expr1
8_NM_001001179_10881	0.693106	0.55201	0	unexpr
9_NM_001001180_13669	0.533143	0.682877	3.73548640439016	expr5

**********************A potential bug******************************
If -c column have only 1 value, program will be aborted by no reasons.


${txtbld}OPTIONS${txtrst}:
	-f	Data file (with header line, the first column is the
 		colname, tab seperated)${bldred}[NECESSARY]${txtrst}
	-t	Title of picture[${txtred}Default empty title${txtrst}]
		[Scatter plot of horizontal and vertical variable]
	-x	xlab of picture[${txtred}Default empty xlab${txtrst}]
		[The description for horizontal variable]
	-y	ylab of picture[${txtred}Default empty ylab${txtrst}]
		[The description for vertical variable]
	-l	The legend for color scale.[${txtred}Default the 
		variable for color value${txtrst}]	
	-P  Legend position[${txtred}Default right. Accept
		top, bottom, left, none,  or c(0.08, 0.8).${txtrst}]
	-o	The variable for horizontal axis.${bldred}[NECESSARY, such hmC]${txtrst}
	-v	The variable for vertical axis.${bldred}[NECESSARY, such as Kme]${txtrst}
	-c	The variable for color value.${bldred}[Optional, such as Expr]${txtrst}
	-S	The variable for shape.${bldred}[Optional, such as Size]${txtrst}
	-g	Log transfer[${bldred}Default none, accept log, log2${txtrst}].
	-w	The width of output picture.[${txtred}Default 20${txtrst}]
	-a	The height of output picture.[${txtred}Default 20${txtrst}] 
	-E	The type of output figures.[${txtred}Default png, accept
		eps/ps, tex (pictex), pdf, jpeg, tiff, bmp, svg and wmf)${txtrst}]
	-r	The resolution of output picture.[${txtred}Default 300 ppi${txtrst}]
	-b	The formula for facets.[${bldred}Default no facets, 
		+facet_grid(level ~ .) means divide by levels of 'level' vertcally.
		+facet_grid(. ~ level) means divide by levels of 'level' horizontally.
		+facet_grid(lev1 ~ lev2) means divide by lev1 vertically and lev2
		horizontally.
		+facet_wrap(~level, ncol=2) means wrap horizontally with 2
		columns.
		Example: +facet_wrap(~Size,ncol=6,scale='free')
		${txtrst}]
	-d	If facet is given, you may want to specifize the order of
		variable in your facet, default alphabetically.
		[${txtred}Accept sth like 
		(one level one sentence, separate by';') 
		data\$size <- factor(data\$size, levels=c("l1",
		"l2",...,"l10"), ordered=T) ${txtrst}]
	-s	smoothed fit curve with confidence region or not.
		[${bldred}Default loss smooth, one can give 'lm' to
		get linear smooth. FALSE for no smooth.${txtrst}]
	-z	Other parameters in ggplot format.[${bldred}selection${txtrst}]
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
color=''
col_legend=''
log=''
width=20
height=20
res=300
ext='png'
facet=''
smooth='geom_smooth'
other=''
facet_o=''
legend_pos='right'

while getopts "hf:t:x:y:o:P:v:c:l:g:w:a:r:E:s:b:d:z:e:i:" OPTION
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
		P)
			legend_pos=$OPTARG
			;;
		o)
			xval=$OPTARG
			;;
		v)
			yval=$OPTARG
			;;
		c)
			color=$OPTARG
			;;
		l)
			col_legend=$OPTARG
			;;
		g)
			log=$OPTARG
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
		E)
			ext=$OPTARG
			;;
		b)
			facet=$OPTARG
			;;
		d)
			facet_o=$OPTARG
			;;
		s)
			smooth=$OPTARG
			;;
		z)
			other=$OPTARG
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

mid=".scatterplot.color"
if [ -z $file ] || [ -z $xval ] || [ -z $yval ] || [ -z $color ]; then
	echo 1>&2 "Please give filename, xval and yval."
	usage
	exit 1
fi


if [ -z $col_legend ]; then
	col_legend="$color"
fi

if [ ! -z $log ]; then
	log=", trans=\"${log}\""
fi

cat <<END >${file}${mid}.r

if ($ist){
	install.packages("ggplot2", repo="http://cran.us.r-project.org")
}
library(ggplot2)
library(grid)

data <- read.table(file="$file", sep="\t", header=T, row.names=1, quote="")

#if ("$width" != "" && "$height" != ""  && "$res" != ""){
#	png(filename="${file}${mid}.png", width=$width, height=$height,
#	res=$res)
#}else{
#	png(filename="${file}${mid}.png")
#}


$facet_o

p <- ggplot(data, aes(x=${xval},y=${yval})) \
+ geom_point(aes(color=${color})) \
+ scale_colour_gradient(low="green", high="red", 
name="$col_legend" ${log}) \
+ labs(x="$xlab", y="$ylab") + labs(title="$title")

#if ("$facet" != ""){
#	facet=$facet
p <- p ${facet}
#}

if ("$smooth" == "geom_smooth"){
	p <- p + geom_smooth()
} else 
if ("$smooth" == 'lm'){
	p <- p + geom_smooth(method=lm)
}

#if ("$other" != ''){
	#other=$other
	p <- p $other
#}


p <- p + theme_bw() + theme(legend.title=element_blank(),
panel.grid.major = element_blank(), panel.grid.minor = element_blank())

top='top'
bottom='bottom'
left='left'
right='right'
none='none'
legend_pos_par <- ${legend_pos}

p <- p + theme(legend.position=legend_pos_par)

ggsave(p, filename="${file}${mid}.${ext}", dpi=$res, width=${width},
height=${height}, units=c("cm"))

#p
#dev.off()
#+ geom_point(alpha=1/10)
END

if [ "$execute" == "TRUE" ]; then
	Rscript ${file}${mid}.r
if [ "$?" == "0" ]; then /bin/rm -f ${file}${mid}.r; fi
fi

if [ ! -z "$log" ]; then
	log=', trans=\"'$log'\"'
fi

#convert -density 200 -flatten ${file}${mid}.eps ${first}${mid}.png
