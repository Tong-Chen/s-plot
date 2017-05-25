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

This script is used to draw density plot for one column or multiple
columns using ggplot2.

-------------------------------------------------------------
fileformat for -f,  when -m is true. [Currently -m is always TRUE]
#The name "value" and "variable" shoud not be altered, but the order
#of this two columns is unlimited
#Actually this format is the melted result of last format.
--------------------------------------------------------------
variable    value
h3k27ac	8.71298
h3k27ac	8.43246
h3k27ac	8.25497
h3k27ac	7.16265
h3k27ac	3.55341
h3k27ac	3.55030
h3k27ac	7.07502
h3k27ac	8.24328
h3k27ac	8.43869
h3k27ac	8.48877
ctcf	10.69130
ctcf	10.76680
ctcf	10.54410
ctcf	10.86350
ctcf	8.45751
ctcf	8.50316
ctcf	10.91430
ctcf	10.70220
ctcf	10.41010
ctcf	10.57570
-------------------------------------------------------------

${txtbld}OPTIONS${txtrst}:
	-f	Data file (with header line, the first column is the
 		will not be treated as rownames, tab seperated)${bldred}[NECESSARY]${txtrst}
	-m	When true, it will skip melt preprocesses. But the format must be
		the same as listed before.
		${bldred}[Default TRUE currently]${txtrst}
	-l	Levels for legend variable
		[${txtred}Default column order, accept a string like
		"'ctcf','h3k27ac','enhancer'"  
		***When -m is used, this default will be ignored too.********* 
	   	${txtrst}]
	-P	Legend position[${txtred}Default right. Accept
		top,bottom,left,none, or c(0.08,0.8).${txtrst}]
	-X	Display xtics. ${bldred}[Default TRUE]${txtrst}
	-Y	Display ytics. ${bldred}[Default TRUE]${txtrst}
	-R	Rotation angle for x-axis value(anti clockwise)
		${bldred}[Default 0]${txtrst}
	-B	line size.[${txtred}Default 1. Accept a number.${txtrst}]
	-t	Title of picture[${txtred}Default empty title${txtrst}]
	-x	xlab of picture[${txtred}Default empty xlab${txtrst}]
	-y	ylab of picture[${txtred}Default empty ylab${txtrst}]
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
	-E	The type of output figures.[${txtred}Default png, accept
		eps/ps, tex (pictex), pdf, jpeg, tiff, bmp, svg and wmf)${txtrst}]
	-r	The resolution of output picture.[${txtred}Default 300 ppi${txtrst}]
	-z	Is there a header[${bldred}Default TRUE${txtrst}]
	-e	Execute or not[${bldred}Default TRUE${txtrst}]
	-i	Install depended packages[${bldred}Default FALSE${txtrst}]
EOF
}

file=
title=''
melted='TRUE'
xlab='NULL'
ylab='NULL'
level=""
x_level=""
x_type='TRUE'
scaleY='FALSE'
y_add=0
scaleY_x='scale_y_log10()'
header='TRUE'
execute='TRUE'
ist='FALSE'
uwid=20
vhig=12
res=300
ext='png'
par=''
legend_pos='right'
smooth='FALSE'
smooth_method='auto'
line_size=1
xtics='TRUE'
xtics_angle=0
ytics='TRUE'
color='FALSE'
color_v=''

while getopts "hf:m:a:A:t:x:l:P:L:y:c:C:B:X:Y:R:w:u:r:E:o:O:s:S:p:z:v:e:i:" OPTION
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
		c)
			color=$OPTARG
			;;
		C)
			color_v=$OPTARG
			;;
		X)
			xtics=$OPTARG
			;;
		R)
			xtics_angle=$OPTARG
			;;
		Y)
			ytics=$OPTARG
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
		E)
			ext=$OPTARG
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

	data <- read.table(file="${file}", sep="\t", header=$header,
	row.names=1, quote="")
	data_rownames <- rownames(data)
	data_colnames <- colnames(data)
	data\$${xvariable} <- data_rownames
	data_m <- melt(data, id.vars=c("${xvariable}"))
} else {
	data_m <- read.table(file="$file", sep="\t",
	header=$header, quote="")
}

if (${y_add} != 0){
	data_m\$value <- data_m\$value + ${y_add}
}

if ("${level}" != ""){
	level_i <- c(${level})
	data_m\$variable <- factor(data_m\$variable, levels=level_i)
} else {
	data_m\$variable <- factor(data_m\$variable, levels=data_colnames,
	ordered=T)
}

if (${x_type}){
	if ("${x_level}" != ""){
		x_level <- c(${x_level})
		data_m\$${xvariable} <- factor(data_m\$${xvariable},levels=x_level)
	}else{
		data_m\$${xvariable} <- factor(data_m\$${xvariable},levels=data_rownames,ordered=TRUE)
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
		p <- p + stat_smooth(method="${smooth_method}", se=FALSE,
		size=${line_size})
	}else{
		p <- p + stat_smooth(method="${smooth_method}", se=FALSE,
		size=${line_size})
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

if(${color}){
	p <- p + scale_color_manual(values=c(${color_v}))
}

if ("$xtics" == "FALSE"){
	p <- p + theme(axis.text.x=element_blank())
}else{
	if (${xtics_angle} != 0){
	p <- p + theme(axis.text.x=element_text(angle=${xtics_angle},hjust=1))
	}
}
if ("$ytics" == "FALSE"){
	p <- p + theme(axis.text.y=element_blank())
}


top='top'
botttom='bottom'
left='left'
right='right'
none='none'
legend_pos_par <- ${legend_pos}

p <- p + theme(legend.position=legend_pos_par)

p <- p${par}


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

