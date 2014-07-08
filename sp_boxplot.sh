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

fileformat for -f (suitable for data extracted from one sample, the
number of columns is unlimited. Column 'Set' is not necessary unless
you have multiple groups)

Gene	hmC	expr	Set
NM_001003918_26622	0	83.1269257376101	TP16
NM_001011535_3260	0	0	TP16
NM_001012640_14264	0	0	TP16
NM_001012640_30427	0	0	TP16
NM_001003918_2662217393_30486	0	0	TP16
NM_001017393_30504	0	0	TP16
NM_001025241_30464	0	0	TP16
NM_001017393_30504001025241_30513	0	0	TP16

For file using "Set" column, you can use 
boxplot.onefile.sh -f file -a Set 

fileformat when -m is true
#Default we use string "value" and "variable" to represent the data
#column and sub-class column. If you have other strings as column
#names, please give them to -d and -F.
#The "Set" column is optional.
#If you do have several groups, they can put at the "Set" column 
#with "Set" or other string as labels. The label should be given
#to parameter -a.
#Actually this format is the melted result of last format.
value	variable	Set
0	hmC	g
1	expr	g
2	hmC	a
3	expr	a

${txtbld}OPTIONS${txtrst}:
	-f	Data file (with header line, the first column is the
 		colname, tab seperated)${bldred}[NECESSARY]${txtrst}
	-m	When true, it will skip preprocess. But the format must be
		the same as listed before.
		${bldred}[Default FALSE, accept TRUE]${txtrst}
	-d	The column represents the digital values.
		${bldred}[Default "value" represents the column named "value".
		This parameter can only set when -m is TRUE.]${txtrst}
	-F	The column represents the variable information, means
		sub-class.
		${bldred}[Default "variable" represents the column named
		"variable".
		This parameter can only set when -m is TRUE.]${txtrst}
	-I	Other columns you want to treat as ID variable columns except
		the one given to -a.
		${bldred}[Default empty string, accept comma separated strings
		like "'Id1','Id2','Id3'" or single string "id1"]${txtrst}
	-a	Name for x-axis variable
		[${txtred}Default variable, which is an inner name, suitable 
		for data without 'Set' column. For the given example, 
		'Set' which represents groups of each gene, and should be 
		supplied to this parameter.
		${txtrst}]
	-b	Rotation angle for x-axis value(anti clockwise)
		${bldred}[Default 0]${txtrst}
	-l	Levels for legend variable
		[${txtred}Default data order,accept a string like
		"'TP16','TP22','TP23'" ***for <variable> column***.
	   	${txtrst}]
	-D	Self-define intervals for legend variable when legend is
		continuous numbers. Accept either a
		numeric vector of two or more cut points or a single number
		(greater than or equal to 2) giving the number of intervals
		into what 'x' is to be cut. This has higher priority than -l.
		[10 will generate 10 intervals or 
		"c(-1, 0, 1, 2, 5, 10)" will generate (-1,0],(0,1]...(5,10]]	
	-P	Legend position[${txtred}Default right. Accept
		top,bottom,left,none, or c(0.08,0.8).${txtrst}]
	-L	Levels for x-axis variable
		[${txtred}Default data order,accept a string like
		"'g','a','j','x','s','c','o','u'" ***for <Set> column***.
	   	${txtrst}]
	-B	Self-define intervals for x-axis variable. Accept either a
		numeric vector of two or more cut points or a single number
		(greater than or equal to 2) giving the number of intervals
		into what 'x' is to be cut. This has higher priority than -L.
		[10 will generate 10 intervals or 
		"c(-1, 0, 1, 2, 5, 10)" will generate (-1,0],(0,1]...(5,10]]	
	-n	Using notch or not.${txtred}[Default TRUE]${txtrst}
	-V	Do violin plot instead of boxplot.${txtred}[Default FALSE]${txtrst}
	-W	Do violin plot without inner boxplot.${txtred}[Default FALSE]${txtrst}
	-j	Do jitter plot instead of boxplot.${txtred}[Default FALSE]${txtrst}
	-J	Do jitter plot overlay with boxplot.${txtred}[Default FALSE]${txtrst}
	-A	The value given to scale for violin plot.
		if "area" (default), all violins have the same area (before
		trimming the tails). If "count", areas are scaled
		proportionally to the number of observations. If "width",
		all violins have the same maximum width. 'equal' is also
		accepted.
		${txtred}[Default 'area']${txtrst}
	-t	Title of picture[${txtred}Default empty title${txtrst}]
	-x	xlab of picture[${txtred}Default empty xlab${txtrst}]
	-y	ylab of picture[${txtred}Default empty ylab${txtrst}]
	-s	Scale y axis
		[${txtred}Default null. Accept TRUE.
		Also if the supplied number after -S is not 0, this
		parameter is TRUE${txtrst}]
	-v	If scale is TRUE, give the following
		scale_y_log10()[default], coord_trans(y="log10"), 
		scale_y_continuous(trans=log2_trans()), coord_trans(y="log2"), 
	   	or other legal
		command for ggplot2)${txtrst}]
	-o	Exclude outliers.
		[${txtred}Exclude outliers or not, default FALSE means not.${txtrst}]
	-O	The scales for you want to zoom in to exclude outliers.
		[${txtred}Default 1.05. No recommend to change unless you know
		what you are doing.${txtrst}]
	-S	A number to add if scale is used.
		[${txtred}Default 0. If a non-zero number is given, -s is
		TRUE.${txtrst}]	
	-c	Manually set colors for each line.[${txtred}Default FALSE,
		meaning using ggplot2 default.${txtrst}]
	-C	Color for each line.[${txtred}When -c is TRUE, str in given
		format must be supplied, ususlly the number of colors should
		be equal to the number of lines.
		"'red','pink','blue','cyan','green','yellow'" or
		"rgb(255/255,0/255,0/255),rgb(255/255,0/255,255/255),rgb(0/255,0/255,255/255),
		rgb(0/255,255/255,255/255),rgb(0/255,255/255,0/255),rgb(255/255,255/255,0/255)"
		${txtrst}]
	-p	Other legal R codes for gggplot2 will be given here.
		[${txtres}Begin with '+' ${txtrst}]
	-w	The width of output picture.[${txtred}Default 20${txtrst}]
	-u	The height of output picture.[${txtred}Default 12${txtrst}] 
	-r	The resolution of output picture.[${txtred}Default 300 ppi${txtrst}]
	-E	The type of output figures.[${txtred}Default pdf, accept
		eps/ps, tex (pictex), pdf, jpeg, tiff, bmp, svg and wmf)${txtrst}]
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
value='value'
variable='variable'
xtics_angle=0
level=""
legend_cut=""
x_level=""
x_cut=""
scaleY='FALSE'
y_add=0
scaleY_x='scale_y_log10()'
header='TRUE'
execute='TRUE'
ist='FALSE'
uwid=20
vhig=12
res=300
notch='TRUE'
par=''
outlier='FALSE'
out_scale=1.05
legend_pos='right'
color='FALSE'
ext='pdf'
violin='FALSE'
violin_nb='FALSE'
scale_violin='area'
ID_var=""
jitter='FALSE'
jitter_bp='FALSE'

while getopts "ha:A:b:B:c:C:d:D:e:E:f:F:i:I:j:J:l:L:m:n:o:O:p:P:r:s:S:t:u:v:V:w:W:x:y:z:" OPTION
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
		d)
			value=$OPTARG
			;;
		F)
			variable=$OPTARG
			;;
		I)
			ID_var=$OPTARG
			;;
		j)
			jitter=$OPTARG
			;;
		J)
			jitter_bp=$OPTARG
			;;
		b)
			xtics_angle=$OPTARG
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
			x_cut=$OPTARG
			;;
		D)
			legend_cut=$OPTARG
			;;
		L)
			x_level=$OPTARG
			;;
		n)
			notch=$OPTARG
			;;
		V)
			violin=$OPTARG
			;;
		W)
			violin_nb=$OPTARG
			;;
		A)
			scale_violin=$OPTARG
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
		E)
			ext=$OPTARG
			;;
		o)
			outlier=$OPTARG
			;;
		O)
			out_scale=$OPTARG
			;;
		s)
			scaleY=$OPTARG
			;;
		S)
			y_add=$OPTARG
			;;
		c)
			color=$OPTARG
			;;
		C)
			color_v=$OPTARG
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

midname='.boxplot'

if test "${melted}" == "FALSE"; then
	if test "${value}" != "value" || test "${variable}" != "variable"; then
		value="value"
		variable="variable"
		echo "Warning, there is no need to set -d and -F for unmelted \
files. We will ignore this setting and not affect the result."
	fi
fi

if test "${xvariable}" == ""; then
	xvariable=${variable}
fi

if test "${value}" != "value" || test "${variable}" != "variable"; then
	midname=${midname}'.'${value}_${variable}
fi
	
#if test "${ID_var}" != ""; then
#	ID_var=${ID_var}
#fi


if test "${outlier}" == "TRUE"; then
	midname=${midname}'.noOutlier'
fi

if test ${y_add} -ne 0; then
	scaleY="TRUE"
fi

if test "${scaleY}" == "TRUE"; then
	midname=${midname}'.scaleY'
fi

if test "${violin}" == "TRUE"; then
	midname=${midname}'.violin'
fi
if test "${violin_nb}" == "TRUE"; then
	midname=${midname}'.violin_nb'
fi

if test "${jitter}" == "TRUE"; then
	midname=${midname}'.jitter'
fi

if test "${jitter_bp}" == "TRUE"; then
	midname=${midname}'.jitter_bp'
fi

. `dirname $0`/sp_configure.sh

cat <<END >${file}${midname}.r

if ($ist){
	install.packages("ggplot2", repo="http://cran.us.r-project.org")
	install.packages("reshape2", repo="http://cran.us.r-project.org")
	install.packages("scales", repo="http://cran.us.r-project.org")
}
library(ggplot2)
library(reshape2)
library(scales)

if(! $melted){
	ID_var <- c(${ID_var})
	ID_var <- ID_var[ID_var!=""]
	data <- read.table(file="${file}", sep="\t", header=$header,
	row.names=1)
	if ("$xvariable" != "${variable}"){
		if (length(ID_var) > 0){
			ID_var <- c(ID_var, "${xvariable}")
		} else {
			ID_var <- c("${xvariable}")
		}
		data_m <- melt(data, id.vars=ID_var)
	} else {
		if (length(ID_var) > 0){
			data_m <- melt(data, id.vars=ID_var)
		} else {
			data_m <- melt(data)
		}
	}
} else {
	data_m <- read.table(file="$file", sep="\t",
	header=$header)
}

if (${y_add} != 0){
	data_m\$${value} <- data_m\$${value} + ${y_add}
}

if ("${legend_cut}" != ""){
	data_m\$${variable} <- cut(data_m\$${variable}, ${legend_cut})
} else if ("${level}" != ""){
	level_i <- c(${level})
	data_m\$${variable} <- factor(data_m\$${variable}, levels=level_i)
}
if ("${x_cut}" != ""){
	data_m\$${xvariable} <- cut(data_m\$${xvariable},${x_cut})
}else if ("${x_level}" != ""){
	x_level <- c(${x_level})
	data_m\$${xvariable} <- factor(data_m\$${xvariable},levels=x_level)
}

p <- ggplot(data_m, aes(factor($xvariable), ${value})) + xlab("$xlab") +
ylab("$ylab")


if (${violin}){
	p <- p + geom_violin(aes(fill=factor(${variable})), 
	stat = "ydensity", position = "dodge", trim = TRUE,  
	scale = "${scale_violin}") + 
	geom_boxplot(aes(fill=factor(${variable})), alpha=.25, width=0.15, 
	position = position_dodge(width = .9), outlier.colour='NA',
	scale="${scale_violin}") + 
	stat_summary(aes(group=${variable}), fun.y=mean,  
	geom="point", fill="black", shape=19, size=1,
	position = position_dodge(width = .9))
   	
	#+ geom_jitter(height = 0)
} else if (${violin_nb}){
	p <- p + geom_violin(aes(fill=factor(${variable})), 
	stat = "ydensity", position = "dodge", trim = TRUE,  
	scale = "${scale_violin}") 
} else if (${jitter}){
	p <- p + geom_jitter(aes(colour=factor(${variable})))
} else {
	if (${notch}){
		if (${outlier}){
		p <- p + geom_boxplot(aes(fill=factor(${variable})), notch=TRUE,
			notchwidth=0.3, outlier.colour='NA')
		}else{
		p <- p + geom_boxplot(aes(fill=factor(${variable})), notch=TRUE,
			notchwidth=0.3)
		}
	}else {
		if (${outlier}){
			p <- p + geom_boxplot(aes(fill=factor(${variable})),
			outlier.colour='NA')
		}else{
			p <- p + geom_boxplot(aes(fill=factor(${variable})))
		}
	}
}

if (${jitter_bp}){
	p <- p + geom_jitter(aes(colour=factor(${variable})))
}

if($scaleY){
	p <- p + $scaleY_x
}

if(${outlier}){
	#ylim_zoomin <- boxplot.stats(data_m\$${value})\$stats[c(1,5)]
	stats <- boxplot.stats(data_m\$${value})\$stats
	ylim_zoomin <- c(stats[1]/${out_scale}, stats[5]*${out_scale})
	p <- p + coord_cartesian(ylim = ylim_zoomin)
}

if($color){
	p <- p + scale_fill_manual(values=c(${color_v}))
}
END

`ggplot2_configure`

##cat <<END >>${file}${midname}.r
##
##p <- p + theme_bw() + theme(legend.title=element_blank(),
##	panel.grid.major = element_blank(), 
##	panel.grid.minor = element_blank(),
##	legend.key=element_blank(),
##	axis.text.x=element_text(angle=${xtics_angle},hjust=1))
##
##top='top'
##botttom='bottom'
##left='left'
##right='right'
##none='none'
##legend_pos_par <- ${legend_pos}
##
###if ("${legend_pos}" != "right"){
##p <- p + theme(legend.position=legend_pos_par)
###}
##
##
##p <- p${par}
##
##
##ggsave(p, filename="${file}${midname}.${ext}", dpi=$res, width=$uwid,
##height=$vhig, units=c("cm"))
##
###png(filename="${file}${midname}.png", width=$uwid, height=$vhig,
###res=$res)
###p
###dev.off()
##END

if [ "$execute" == "TRUE" ]; then
	Rscript ${file}${midname}.r
fi

