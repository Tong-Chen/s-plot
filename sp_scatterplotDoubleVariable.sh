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

This script is used to do scatter plot and represents two value
variables by color and size using ggplot2. 

It is designed for representing the gene annotation data with enriched
GO terms and -pvalues, # of genes. 

The parameters for logical variable are either TRUE or FALSE.

Input file (terms only exist in one or a few samples are suitable):

Term	Sample	count	p_value
hsa04740:Olfactory transduction	b	379	6.48E-13
hsa04080:Neuroactive ligand-receptor interaction	b	256	5.21E-06
hsa04060:Cytokine-cytokine receptor interaction	b	262	8.62E-04
hsa00830:Retinol metabolism	b	54	0.124538325
hsa04062:Chemokine signaling pathway	b	187	0.913682422
hsa00120:Primary bile acid biosynthesis	b	16	0.995946178
hsa04614:Renin-angiotensin system	b	17	0.998465518
hsa04640:Hematopoietic cell lineage	b	86	0.99955116
hsa04650:Natural killer cell mediated cytotoxicity	b	133	0.999599558
hsa04740:Olfactory transduction	a	379	6.48E-13
hsa04080:Neuroactive ligand-receptor interaction	a	256	5.21E-06
hsa04060:Cytokine-cytokine receptor interaction	a	262	8.62E-04
hsa00830:Retinol metabolism	a	54	0.124538325
hsa04062:Chemokine signaling pathway	a	187	0.913682422
hsa00120:Primary bile acid biosynthesis	a	16	0.995946178
hsa04614:Renin-angiotensin system	a	17	0.998465518
hsa04640:Hematopoietic cell lineage	a	86	0.99955116
hsa04650:Natural killer cell mediated cytotoxicity	a	133	0.999599558


**********************A potential bug******************************
If -c column have only 1 value, program will be aborted by no reasons.


${txtbld}OPTIONS${txtrst}:
	-f	Data file (with header line, the first column is not the
 		rowname, tab seperated)${bldred}[NECESSARY]${txtrst}
	-t	Title of picture[${txtred}Default empty title${txtrst}]
		[Scatter plot of horizontal and vertical variable]
	-x	xlab of picture[${txtred}Default empty xlab${txtrst}]
		[The description for horizontal variable]
	-y	ylab of picture[${txtred}Default empty ylab${txtrst}]
		[The description for vertical variable]
	-P	Legend position[${txtred}Default right. Accept
		top, bottom, left, none,  or c(0.08, 0.8).${txtrst}]
	-o	The variable for horizontal axis.
		${bldred}[NECESSARY, such Sample]${txtrst}
	-v	The variable for vertical axis.
		${bldred}[NECESSARY, such as Term]${txtrst}
	-c	The variable for point value.
		${bldred}[NECESSARY, such as p_value]${txtrst}
	-s	The variable for point size.
		${bldred}[NECESSARY, such as count]${txtrst}
	-l	Get log-transformed data for given variable.
		[${txtred}Default nolog, means no log10 transform. Accept a variable
		like p_value to get (-1) * log10(p_value).${txtrst}]	
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
log='nolog'
width=20
height=20
res=300
ext='pdf'
facet=''
size=''
other=''
facet_o=''
legend_pos='right'

while getopts "hf:t:x:y:o:P:v:c:l:w:a:r:E:s:b:d:z:e:i:" OPTION
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
			size=$OPTARG
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

mid=".scatterplot.dv"
if [ -z $file ] || [ -z $xval ] || [ -z $yval ] ; then
	echo 1>&2 "Please give filename, xval and yval."
	usage
	exit 1
fi


cat <<END >${file}${mid}.r

if ($ist){
	install.packages("ggplot2", repo="http://cran.us.r-project.org")
}
library(plyr)
library(ggplot2)
library(grid)

data <- read.table(file="$file", sep="\t", header=T)

# First order by Term, then order by Sample
data <- data[order(data\$${yval}, data\$${xval}), ]

# Get the count of each unique Term
data_freq <- as.data.frame(table(data\$${yval}))

colnames(data_freq) <- c("${yval}", "ID")

data2 <- merge(data, data_freq, by="${yval}")

# Collapse sample for each Term 
data_samp <- ddply(data2, "${yval}", summarize,
	sam_ct_ct_ct=paste(${xval}, collapse="_"))

data2 <- merge(data2, data_samp, by="${yval}")

#print(data2)

data3 <- data2[order(data2\$ID, data2\$sam_ct_ct_ct, data2\$${xval}, data2\$${color}), ]

#print(data3)

term_order <- unique(data3\$${yval})

data\$${yval} <- factor(data\$${yval}, levels=term_order, ordered=T)

#print(data)
rm(data_freq, data2, data3)

if ("${log}" != "nolog"){
	data\$${log} <- log10(data\$${log}) * (-1)
}

$facet_o

p <- ggplot(data, aes(x=${xval},y=${yval})) \
+ labs(x="$xlab", y="$ylab") + labs(title="$title")

if (("${size}" != "") && ("${color}" != "")) {
	p <- p + geom_point(aes(size=${size}, color=${color})) + \
	scale_colour_gradient(low="green", high="red", name="${color}")
} else if ("${size}" != "") {
	p <- p + geom_point(aes(size=${size}))
} else if ("${color}" != "") {
	p <- p + geom_point(aes(color=${color})) + \
	scale_colour_gradient(low="green", high="red", name="${color}")
}


p <- p ${facet}

p <- p $other

p <- p + theme_bw() + theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank())

top='top'
bottom='bottom'
left='left'
right='right'
none='none'
legend_pos_par <- ${legend_pos}

p <- p + theme(legend.position=legend_pos_par)

ggsave(p, filename="${file}${mid}.${ext}", dpi=$res, width=${width},
height=${height}, units=c("cm"))

END

if [ "$execute" == "TRUE" ]; then
	Rscript ${file}${mid}.r
if [ "$?" == "0" ]; then /bin/rm -f ${file}${mid}.r; fi
fi

if [ ! -z "$log" ]; then
	log=', trans=\"'$log'\"'
fi

#convert -density 200 -flatten ${file}${mid}.eps ${first}${mid}.png
