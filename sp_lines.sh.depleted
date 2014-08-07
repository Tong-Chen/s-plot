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

This script is used to draw a line or multiple lines using ggplot2.
You can specify whether or not smooth your line or lines.

fileformat for -f (suitable for data extracted from one sample, the
number of columns is unlimited. Column 'Set' is not necessary)
------------------------------------------------------------
Pos	h3k27ac	ctcf	enhancer	h3k4me3	polII
-5000	8.71298	10.69130	11.7359	10.02510	8.26866
-4000	8.43246	10.76680	11.8442	9.76927	7.78358
-3000	8.25497	10.54410	12.2470	9.40346	6.96859
-2000	7.16265	10.86350	12.6889	8.35070	4.84365
-1000	3.55341	8.45751	12.8372	4.84680	1.26110
0	3.55030	8.50316	13.4152	5.17401	1.50022
1000	7.07502	10.91430	12.3588	8.13909	4.88096
2000	8.24328	10.70220	12.3888	9.47255	7.67968
3000	8.43869	10.41010	11.9760	9.80665	7.94148
4000	8.48877	10.57570	11.6562	9.71986	8.17849
-------------------------------------------------------------
fileformat when -m is true
#The name "value" and "variable" shoud not be altered.
#Actually this format is the melted result of last format.
--------------------------------------------------------------
Pos variable    value
-5000	h3k27ac	8.71298
-4000	h3k27ac	8.43246
-3000	h3k27ac	8.25497
-2000	h3k27ac	7.16265
-1000	h3k27ac	3.55341
0	h3k27ac	3.55030
1000	h3k27ac	7.07502
2000	h3k27ac	8.24328
3000	h3k27ac	8.43869
4000	h3k27ac	8.48877
-5000	ctcf	10.69130
-4000	ctcf	10.76680
-3000	ctcf	10.54410
-2000	ctcf	10.86350
-1000	ctcf	8.45751
0	ctcf	8.50316
1000	ctcf	10.91430
2000	ctcf	10.70220
3000	ctcf	10.41010
4000	ctcf	10.57570
-------------------------------------------------------------

${txtbld}OPTIONS${txtrst}:
	-f	Data file (with header line, the first column is the
 		will not be treated as rownames, tab seperated)${bldred}[NECESSARY]${txtrst}
	-m	When true, it will skip melt preprocesses. But the format must be
		the same as listed before.
		${bldred}[Default FALSE, accept TRUE]${txtrst}
	-a	Name for x-axis variable
		[${txtred}Necessary, no default value.  
		For the listed two examples, 'Pos' should be given here. 
	   	]${txtrst}]
	-A	The attribute of x-axis variable.
		[${txtred}Default TRUE, means X-axis label is text.
		FALSE means X-axis label is number.${txtrst}]
	-l	Levels for legend variable
		[${txtred}Default dictionary order,accept a string like
		"'ctcf','h3k27ac','enhancer'"  
	   	${txtrst}]
	-P	Legend position[${txtred}Default right. Accept
		top,bottom,left,none, or c(0.08,0.8).${txtrst}]
	-L	Levels for x-axis variable, suitable when x-axis is not used
		as a number. 
		[${txtred}Default the dictionary order, accept a string like
		"'g','a','j','x','s','c','o','u'"  
	   	This will only be considered when -A is TRUE.
		${txtrst}]
	-o	Smooth your data or not.
		[${txtred}Default FALSE means no smooth. Accept TRUE to smooth
		lines.${txtrst}]
	-O	The smooth method you want to use.
		[${txtred}smoothing method (function) to use,  eg. lm, glm,
		gam, loess,rlm. 
		For datasets with n < 1000 default is 'loess'. 
		For datasets with 1000 or more observations defaults to 'gam'.
		${txtrst}]
	-B	line size.[${txtred}Accept a number.${txtrst}]
	-t	Title of picture[${txtred}Default empty title${txtrst}]
	-x	xlab of picture[${txtred}Default empty xlab${txtrst}]
	-y	ylab of picture[${txtred}Default empty ylab${txtrst}]
	-s	Scale y axis
		[${txtred}Default null. Accept TRUE. This function is
		depleted. If the supplied number after -S is not 0, this
		parameter is TRUE${txtrst}]
	-v	If scale is TRUE, give the following
		scale_y_log10()[default], coord_trans(y="log10"), or other legal
		command for ggplot2)${txtrst}]
	-S	A number to add if scale is used.
		[${txtred}Default 0. If a non-zero number is given, -s is
		TRUE.${txtrst}]	
	-p	Other legal R codes for gggplot2 will be given here.
		[${txtres}Begin with '+' ${txtrst}]
	-w	The width of output picture.[${txtred}Default 800${txtrst}]
	-u	The height of output picture.[${txtred}Default 800${txtrst}] 
	-r	The resolution of output picture.[${txtred}Default NA${txtrst}]
	-z	Is there a header[${txtred}Default TRUE${txtrst}]
	-e	Execute or not[${txtred}Default TRUE${txtrst}]
	-i	Install depended packages[${txtred}Default FALSE${txtrst}]

****** This script is depleted, please use ${bldred}lines.2.sh${txtrst} instead. ***********

EOF
}

file=
title=''
melted='FALSE'
xlab='NULL'
ylab='NULL'
xvariable=''
level=""
x_level=""
x_type='TRUE'
scaleY='FALSE'
y_add=0
scaleY_x='scale_y_log10()'
header='TRUE'
execute='TRUE'
ist='FALSE'
uwid=800
vhig=800
res='NA'
par=''
legend_pos='right'
smooth='FALSE'
smooth_method='auto'
line_size=''

while getopts "hf:m:a:A:t:x:l:P:L:y:B:w:u:r:o:O:s:S:p:z:v:e:i:" OPTION
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
		A)
			x_type=$OPTARG
			;;
		t)
			title=$OPTARG
			;;
		x)
			xlab=$OPTARG
			;;
		l)
			level=$OPTARG
			;;
		P)
			legend_pos=$OPTARG
			;;
		B)
			line_size=$OPTARG
			;;
		L)
			x_level=$OPTARG
			;;
		p)
			par=$OPTARG
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
		o)
			smooth=$OPTARG
			;;
		O)
			smooth_method=$OPTARG
			;;
		s)
			scaleY=$OPTARG
			;;
		S)
			y_add=$OPTARG
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

if test ${y_add} -ne 0; then
	scaleY="TRUE"
fi

mid='.lines'

cat <<END >${file}${mid}.r

if ($ist){
	install.packages("ggplot2", repo="http://cran.us.r-project.org")
	install.packages("reshape2", repo="http://cran.us.r-project.org")
	install.packages("grid", repo="http://cran.us.r-project.org")
}
library(ggplot2)
library(reshape2)
library(grid)

if(! $melted){

	data <- read.table(file="${file}", sep="\t", header=$header)
	data_m <- melt(data, id.vars=c("${xvariable}"))
} else {
	data_m <- read.table(file="$file", sep="\t",
	header=$header)
}

if (${y_add} != 0){
	data_m\$value <- data_m\$value + ${y_add}
}

if ("${level}" != ""){
	level_i <- c(${level})
	data_m\$variable <- factor(data_m\$variable, levels=level_i)
}

if (${x_type}){
	if ("${x_level}" != ""){
		x_level <- c(${x_level})
		data_m\$${xvariable} <- factor(data_m\$${xvariable},levels=x_level)
	}else{
		data_m\$${xvariable} <- factor(data_m\$${xvariable})
	}
}

p <- ggplot(data_m, aes(x=$xvariable, y=value, color=variable,
	group=variable)) + xlab($xlab) + ylab($ylab) + theme_bw() +
	theme(legend.title=element_blank(),
   	panel.grid.major = element_blank(), panel.grid.minor = element_blank())

p <- p + theme(axis.ticks.x = element_blank(), legend.key=element_blank()) 
#legend.background = element_rect(colour='white'))

#legend.background = element_rect(fill = "white"), legend.box=NULL, 
#legend.margin=unit(0,"cm"))

if (${smooth}){
	if ("${line_size}" != ""){
		p <- p + stat_smooth(method=${smooth_method}, se=FALSE,
		size=${line_size})
	}else{
		p <- p + stat_smooth(method=${smooth_method}, se=FALSE,
		size=1)
	}	
}else{
	if ("${line_size}" != ""){
		p <- p + geom_line(size=${line_size}) 
	}else{
		p <- p + geom_line() 
	}
}

if("$scaleY"){
	p <- p + $scaleY_x
}



top='top'
botttom='bottom'
left='left'
right='right'
none='none'
legend_pos_par <- ${legend_pos}

p <- p + theme(legend.position=legend_pos_par)

p <- p${par}

png(filename="${file}${mid}.png", width=$uwid, height=$vhig,
res=$res)
p
dev.off()
END

if [ "$execute" == "TRUE" ]; then
	Rscript ${file}${mid}.r
fi

