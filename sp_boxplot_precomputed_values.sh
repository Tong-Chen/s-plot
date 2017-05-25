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

fileformat for -f
(At least first 6 columns are needed, column names should not be changed)
(Column 'Set' is not necessary unless you have multiple groups)

Samp	minimum	maximum	lower_quantile	median	upper_quantile	Set
A	1	10	2	5	7	cl1
B	1	10	2	5	7	cl2
C	1	10	2	5	7	cl1
D	1	10	2	5	7	cl2

boxplot.onefile.sh -f file -a Set 


${txtbld}OPTIONS${txtrst}:
	-f	Data file (with header line, the first column is the
 		colname, tab seperated)${bldred}[NECESSARY]${txtrst}
	-a	Name for x-axis variable
		[${txtred}Default parameter values given to <-F>, 
		For the given example, 'Set' which represents groups of each gene, 
		and should be supplied to this parameter.
		${txtrst}]
	-F	The column represents the variable information, means
		sub-class.
		${bldred}[Default "variable" represents the column named
		"variable". For given example, "Samp" should given here.
		For files with both <Samp> and <Set> columns, each is suitable for 
		<-a> or <-F> but with different output.]${txtrst}
	-b	Rotation angle for x-axis value (anti clockwise)
		${bldred}[Default 0]${txtrst}
	-R	Rotate the plot. Usefull for plots with many values or very long labels at X-axis.
		${bldred}[Default FALSE]${txtrst}
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
	-G	Wrap plots by given column. This is used to put multiple plot
		in one picture. Used when -m is TRUE, normally a string <set>
		should be suitable for this parameter.
	-g	The levels of wrapping to set the order of each group.
		${txtred}Normally the unique value of the column given to B in
		a format like <"'a','b','c','d'">.${txtrst}
	-M	The number of rows one want when -G is used.Default NULL.
		${txtred}[one of -M and -N is enough]${txtrst}
	-N	The number of columns one want when -G is used.Default NULL.
		${txtred}[one of -M and -N is enough]${txtrst}
	-k	Paramter for scales for facet.
		[${txtred}Optional, only used when -B is given. Default each 
		inner graph use same scale [x,y range]. 'free','free_x','free_y' 
		is accepted. ${txtrst}]
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
xlab=' '
ylab=' '
xvariable=''
value='value'
variable='variable'
xtics_angle=0
xtics='TRUE'
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
scale_violin='width'
ID_var=""
jitter='FALSE'
jitter_bp='FALSE'
colormodel='srgb'
rotate_plot='FALSE'
facet='NoMeAnInGTh_I_n_G_s'
nrow='NULL'
ncol='NULL'
scales='fixed'
facet_level='NA'

while getopts "ha:A:b:B:c:C:d:D:e:E:f:F:g:G:M:N:k:i:I:R:j:J:l:L:m:n:o:O:p:P:r:s:S:t:u:v:V:w:W:x:y:z:" OPTION
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
		G)
			facet=$OPTARG
			;;
		g)
			facet_level=$OPTARG
			;;
		M)
			nrow=$OPTARG
			;;
		N)
			ncol=$OPTARG
			;;
		k)
			scales=$OPTARG
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
		R)
			rotate_plot=$OPTARG
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

mid='.boxplot'

#if test "${melted}" == "FALSE"; then
#	if test "${value}" != "value" || test "${variable}" != "variable"; then
#		value="value"
#		variable="variable"
#		echo "Warning, there is no need to set -d and -F for unmelted \
#files. We will ignore this setting and not affect the result."
#	fi
#fi

if test "${xvariable}" == ""; then
	xvariable=${variable}
fi

if test "${value}" != "value" || test "${variable}" != "variable"; then
	mid=${mid}'.'${value}_${variable}
fi
	
#if test "${ID_var}" != ""; then
#	ID_var=${ID_var}
#fi


if test "${outlier}" == "TRUE"; then
	mid=${mid}'.noOutlier'
fi

if test ${y_add} -ne 0; then
	scaleY="TRUE"
fi

if test "${scaleY}" == "TRUE"; then
	mid=${mid}'.scaleY'
fi

if test "${violin}" == "TRUE"; then
	mid=${mid}'.violin'
fi
if test "${violin_nb}" == "TRUE"; then
	mid=${mid}'.violin_nb'
fi

if test "${jitter}" == "TRUE"; then
	mid=${mid}'.jitter'
fi

if test "${jitter_bp}" == "TRUE"; then
	mid=${mid}'.jitter_bp'
fi

. `dirname $0`/sp_configure.sh

cat <<END >${file}${mid}.r

if ($ist){
	install.packages("ggplot2", repo="http://cran.us.r-project.org")
	install.packages("reshape2", repo="http://cran.us.r-project.org")
	install.packages("scales", repo="http://cran.us.r-project.org")
	if(${jitter_bp}){
		install.packages("ggbeeswarm", repo="http://cran.us.r-project.org")
	}
}

if(${jitter_bp}){
	library(ggbeeswarm)
}else if(${jitter}){
	library(ggbeeswarm)
}

library(ggplot2)
library(reshape2)
library(scales)

data_m <- read.table(file="${file}", sep="\t", header=$header,
row.names=NULL, quote="")

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

if ("${facet_level}" != "NA") {
	facet_level <- c(${facet_level})
	data_m\$${facet} <- factor(data_m\$${facet},
        levels=facet_level, ordered=T)
}


#Samp	minimum	maximum	lower_quantile	median	upper_quantile	Set
p <- ggplot(data_m, aes(x=factor($xvariable), ymin=minimum, lower=lower_quantile, 
			middle=median, upper=upper_quantile, ymax=maximum)) +
			xlab("$xlab") + ylab("$ylab") + labs(title="$title")


if (${notch}){
	p <- p + geom_boxplot(aes(fill=factor(${variable})), notch=TRUE,
		notchwidth=0.3, stat = "identity")
}else {
	p <- p + geom_boxplot(aes(fill=factor(${variable})), stat = "identity")
}


if($scaleY){
	p <- p + $scaleY_x
	p <- p + stat_summary(fun.y = "mean", geom = "text", label="----", size= 10, color= "black")
}


if($color){
	p <- p + scale_fill_manual(values=c(${color_v}))
}

if(${rotate_plot}){
	p <- p + coord_flip()	
}

if ("${facet}" != "NoMeAnInGTh_I_n_G_s"){
	p <- p + facet_wrap( ~ ${facet}, nrow=${nrow}, ncol=${ncol},
	scale="${scales}")
}


END


`ggplot2_configure`

##cat <<END >>${file}${mid}.r
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
##ggsave(p, filename="${file}${mid}.${ext}", dpi=$res, width=$uwid,
##height=$vhig, units=c("cm"))
##
###png(filename="${file}${mid}.png", width=$uwid, height=$vhig,
###res=$res)
###p
###dev.off()
##END

if [ "$execute" == "TRUE" ]; then
	Rscript ${file}${mid}.r
if [ "$?" == "0" ]; then /bin/rm -f ${file}${mid}.r; fi
fi

