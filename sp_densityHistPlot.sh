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

This script is used to draw histogram and density plot 
for one column or multiple columns using ggplot2.

-------------------------------------------------------------
fileformat for -f,  when -m is true. [Currently -m is always TRUE]
#The name "value" and "variable" shoud not be altered, but the order
#of this two columns is unlimited. Other columns will be ignored.
#Actually this format is the melted result of last format.
--------------------------------------------------------------
variable    value	set(optional)	
h3k27ac	8.71298	1
h3k27ac	8.43246	1
h3k27ac	8.25497	1
h3k27ac	7.16265	1
h3k27ac	3.55341	1
h3k27ac	3.55030	2
h3k27ac	7.07502	2
h3k27ac	8.24328	2
h3k27ac	8.43869	2
h3k27ac	8.48877	2
ctcf	10.69130	1
ctcf	10.76680	1
ctcf	10.54410	1
ctcf	10.86350	1
ctcf	8.45751	1
ctcf	8.50316	2
ctcf	10.91430	2
ctcf	10.70220	2
ctcf	10.41010	2
ctcf	10.57570	2
-------------------------------------------------------------

${txtbld}OPTIONS${txtrst}:
	-f	Data file (with header line, the first column 
 		will not be treated as rownames, tab seperated)${bldred}[NECESSARY]${txtrst}
	-m	When true, it will skip melt preprocesses. But the format must be
		the same as listed before.
		${bldred}[Default TRUE]${txtrst}
	-M	Lists of variables not want to be melted.
		${bldred}[Only used when -m is FALSE, accept a string in
		format like "'Set','Id'" meaning the 'Set' column and 'Id'
		column will be retained as in original file.]${txtrst}
	-d	Plot frequency or density or hist or both frequency and
		histogram[${txtred}Default <line> means frequency
		accept <density_line>,  <hist> or <both>${txtrst}]
	-g	Plot with density or count or frequency in
		y-axis.[${txtred}Default <frequency>,
		accept <..density..>, <..count..>. 
		When -d is <both>,  <frequency> will be given here.${txtrst}]
	-s	Variable name for facet.[${txtred}Optional, the name of one
		column representing a group should be given if group
		information is needed. Here 'set' can be given if you want to
		plot set-1 and set-2 separatelt ${txtrst}]
	-J	Another variable for facet.[${txtred}Optional, same meaning as
		-s but different columns, like 'variable'. When this is given,
		facet_grid would be used in format like facet_grid(s_facet ~
		j_facet) pay attention to the order.]
	-H	Order of J_facet (facet variable given to -J).
		[${txtred}Optional even -s is given. Only specified if the
		facet order is what you want. Input format likes
		"'facet1','facet2',"facet10""${txtrst}]
	-S	Number of columns in one row when do faceting.
		${txtred}Necessary if only -s is given${txtrst}
	-D	Parameter for scales for facet.
		[${txtred}Necessary if only -s is given. Default each inner
		graph use same scale [x, y range]. "free", 'free_x', 'free_y'
		is accepted.${txtrst}]
	-G	Order of s_facet (facet_variable given to -s).
		[${txtred}Optional even -s is given. Only specified if the
		facet order is what you want. Input format likes
		"'facet1','facet2',"facet10""${txtrst}]
	-j	Position paramter for hist bars.[${txtred}Default identity,
		accept <dodge>. ${txtrst}]
	-k	Alpha value for transparent.[${txtred}Default 0.4,
		accept a number form 0 to 1,  the smaller, the more
		transparent. ${txtrst}]
	-v	Add mean value as vline.[${txtred}Default FALSE,  accept
		TRUE${txtrst}]
	-l	Levels for legend variable
		[${txtred}Default column order, accept a string like
		"'ctcf','h3k27ac','enhancer'"  
		***When -m is used, this default will be ignored.********* 
	   	${txtrst}]
	-P	Legend position[${txtred}Default right. Accept
		top,bottom,left,none, or c(0.08,0.8).${txtrst}]
	-a	The value for adjust (like the width of each bin) in geom_density. 
		and binwidth for geom_histogram)
		[${txtred}Default ggplot2 default, accept a number${txtrst}]
	-b	Fill the area if TRUE.[${txtred}Default FALSE${txtrst}]
	-X	Display xtics. ${bldred}[Default TRUE]${txtrst}
	-Y	Display ytics. ${bldred}[Default TRUE]${txtrst}
	-I	Manually set xtics.${bldred}[Default FALSE, accept a series of
		numbers in following format "c(1,2,3,4,5)" or other R code
		that can generate a vector]${txtrst}
	-R	Rotation angle for x-axis value(anti clockwise)
		${bldred}[Default 0]${txtrst}
	-V	Add vline by given point. 
		${bldred}[Default FALSE, accept a series of
		numbers in following format "c(1,2,3,4,5)" or other R code
		that can generate a vector]${txtrst}
	-A	Add labels to vline.
		${bldred}[Default FALSE, accept a series of
		numbers in following format "c(1,2,3,4,5)" or other R code
		that can generate a vector]${txtrst}
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
	-E	The type of output figures.[${txtred}Default pdf, accept
		eps/ps, tex (pictex), png, jpeg, tiff, bmp, svg and wmf)${txtrst}]
	-r	The resolution of output picture.[${txtred}Default 300 ppi${txtrst}]
	-z	Is there a header[${bldred}Default TRUE${txtrst}]
	-e	Execute or not[${bldred}Default TRUE${txtrst}]
	-i	Install depended packages[${bldred}Default FALSE${txtrst}]
EOF
}

file=
title=''
melted='TRUE'
type_p='line'
type_hist='..count../sum(..count..)'
vline='FALSE'
xlab='NULL'
ylab='NULL'
level=""
x_level=""
xvariable=
x_type='TRUE'
scaleY='FALSE'
adjust='FALSE'
fill_area='FALSE'
header='TRUE'
execute='TRUE'
ist='FALSE'
uwid=20
vhig=12
res=300
ext='pdf'
par=''
legend_pos='right'
smooth='FALSE'
smooth_method='auto'
line_size=1
xtics='TRUE'
alpha=0.4
xtics_angle=0
ytics='TRUE'
color='FALSE'
color_v=''
pos="identity"
xtics_input=0
custom_vline='NULL'
custom_vanno='NULL'
facet='haha'
facet_ncol=1
facet_order=''
facet_scale='fixed'
j_facet='haha'
j_facet_order=''

while getopts "hf:m:M:t:a:x:b:l:D:d:V:A:g:G:j:J:H:I:k:P:y:c:C:B:X:Y:R:s:S:w:u:r:E:p:z:v:e:i:" OPTION
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
		M)
			xvariable=$OPTARG
			;;
		V)
			custom_vline=$OPTARG
			;;
		A)
			custom_vanno=$OPTARG
			;;
		t)
			title=$OPTARG
			;;
		G)
			facet_order=$OPTARG
			;;
		D)
			facet_scale=$OPTARG
			;;
		S)
			facet_ncol=$OPTARG
			;;
		s)
			facet=$OPTARG
			;;
		J)
			j_facet=$OPTARG
			;;
		H)
			j_facet_order=$OPTARG
			;;
		a)
			adjust=$OPTARG
			;;
		I)
			xtics_input=$OPTARG
			;;
		d)
			type_p=$OPTARG
			;;
		g)
			type_hist=$OPTARG
			;;
		v)
			vline=$OPTARG
			;;
		b)
			fill_area=$OPTARG
			;;
		x)
			xlab=$OPTARG
			;;
		l)
			level=$OPTARG
			;;
		j)
			pos=$OPTARG
			;;
		k)
			alpha=$OPTARG
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


mid='.densityHist'

cat <<END >${file}${mid}.r

if ($ist){
	install.packages("ggplot2", repo="http://cran.us.r-project.org")
	install.packages("reshape2", repo="http://cran.us.r-project.org")
	install.packages("grid", repo="http://cran.us.r-project.org")
	install.packages("plyr", repo="http://cran.us.r-project.org")
}
library(ggplot2)
library(reshape2)
library(grid)
if (${vline}){
	library(plyr)
}
if(! $melted){
	#cat("Currently not supported for unmelted files")
	#quit()
	#currently this part is unused
	data <- read.table(file="${file}", sep="\t", header=$header)
#	data_rownames <- rownames(data)
#	data_colnames <- colnames(data)
#	data\$${xvariable} <- data_rownames
	data_m <- melt(data, id.vars=c(${xvariable}))
	#data_m <- melt(data)
} else {
	data_m <- read.table(file="$file", sep="\t",
	header=$header)
}


if ("${level}" != ""){
	level_i <- c(${level})
	data_m\$variable <- factor(data_m\$variable, levels=level_i)
} else if (! ${melted}){
	data_m\$variable <- factor(data_m\$variable, levels=data_colnames,
	ordered=T)
}

if ("${facet_order}" != ""){
	data_m\$${facet} <- factor(data_m\$${facet},
	levels=c(${facet_order}))
}


if ("${j_facet_order}" != ""){
	data_m\$${j_facet} <- factor(data_m\$${j_facet},
	levels=c(${j_facet_order}))
}


p <- ggplot(data_m, aes(x=value))

if ("${type_p}"=="hist" || "${type_p}"=="both"){
	#if ("${type_p}" == "both" || "${type_hist}" == "density"){
	if (${adjust}){
		p <- p + geom_histogram(aes(y=${type_hist},
		fill=variable), binwidth=${adjust}, alpha=${alpha},
		position="${pos}")
	} else {
		p <- p + geom_histogram(aes(y=${type_hist}, 
		fill=variable), alpha=${alpha}, position="${pos}")
	}
	#} else {
	#	if (${adjust}){
	#		p <- p + geom_histogram(alpha=${alpha}, aes(fill=variable),
	#		binwidth=${adjust}, position="${pos}")
	#	} else {
	#		p <- p + geom_histogram(alpha=${alpha}, aes(fill=variable),
	#		position="${pos}")
	#	}
	#}
}

if ("${type_p}"=="density_line"){
	if (${fill_area} && "${type_p}" != "both"){
		if (${adjust}){
			p <- p + geom_density(size=${line_size}, alpha=${alpha},
			aes(fill=variable, y=${type_hist}), adjust=${adjust})
		}
			p <- p + geom_density(size=${line_size}, alpha=${alpha},
			aes(fill=variable), y=${type_hist}) 
	} else {
		if (${adjust}){
			p <- p + stat_density(adjust=${adjust}, size=${line_size},
			aes(color=variable, group=variable, y=${type_hist}), geom="line",
			position="identity") 
		} else {
			p <- p + stat_density(size=${line_size},
			aes(color=variable, group=variable, y=${type_hist}), geom="line",
			position="identity") 
		}
	}
}

if ("${type_p}"=="line" || "${type_p}"=="both"){
	#if (${fill_area} && "${type_p}" != "both"){
		if (${adjust}){
			p <- p + geom_freqpoly(size=${line_size}, alpha=${alpha},
			aes(color=variable, y=${type_hist}), binwidth=${adjust})
		}else{
			p <- p + geom_freqpoly(size=${line_size}, alpha=${alpha},
			aes(color=variable, y=${type_hist})) 
		}
	#} else {
	#	if (${adjust}){
	#		p <- p + stat_density(adjust=${adjust}, size=${line_size},
	#		aes(color=variable, group=variable, y=${type_hist}), geom="line",
	#		position="identity") 
	#	} else {
	#		p <- p + stat_density(size=${line_size},
	#		aes(color=variable, group=variable, y=${type_hist}), geom="line",
	#		position="identity") 
	#	}
	#}
}

if (${vline}){
	cdf <- ddply(data_m, .(value), summarise, rating.mean=mean(rating))
	p <- p + geom_vline(data=cdf, aes(xintercept=rating.mean,
	colour=variable),linetype="dashed", size=1)
}

p <- p + xlab($xlab) + ylab($ylab) + theme_bw() +
	theme(legend.title=element_blank(),
   	panel.grid.major = element_blank(), panel.grid.minor = element_blank())

p <- p + theme(axis.ticks.x = element_blank(), legend.key=element_blank()) 

#legend.background = element_rect(fill = "white"), legend.box=NULL, 
#legend.margin=unit(0,"cm"))

#if ("${line_size}" != ""){
#	p <- p + geom_line(size=${line_size}) 
#}else{
#	p <- p + geom_line() 
#}

if(${color}){
	if (${fill_area}){
		p <- p + scale_fill_manual(values=c(${color_v}))
	} else {
		p <- p + scale_color_manual(values=c(${color_v}))
	}
}

if ("${j_facet}" != "haha") {
	p <- p + facet_grid(${facet} ~ ${j_facet}, scales="${facet_scale}")
}else {
	if ("${facet}" != "haha") {
		p <- p + facet_wrap(~${facet}, ncol=${facet_ncol},
		scales="${facet_scale}")
	}
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

xtics_v <- ${xtics_input}

if(length(xtics_v) > 1){
	p <- p + scale_x_continuous(breaks=xtics_v, labels=xtics_v)
}

custom_vline_coord <- ${custom_vline}
custom_vline_anno <- ${custom_vanno}

if(is.vector(custom_vline_coord)){
	p <- p + geom_vline(xintercept=custom_vline_coord,
	linetype="dotted")
	if(is.vector(custom_vline_anno)){
		ymax_range <- ggplot_build(p)\$panel\$ranges[[1]]\$y.range
		ymax_v <- ymax_range[2]
		p <- p + annotate("text", x=custom_vline_coord, y=ymax_v,
		label=custom_vline_anno, hjust=0)
	}
}


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

