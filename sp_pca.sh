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

This script is used to do full functional scatter plot using ggplot2. 


The parameters for logical variable are either TRUE or FALSE.

Input file (terms only exist in one or a few samples are suitable):

Samp	X_val	Y_val	Color	Size	Shape
a	1	1	grp1	10	cluster1
b	2	2	grp1	10	cluster1
c	1	3	grp1	10	cluster1
d	3	1	grp2	15	cluster2
e	2	2	grp2	15	cluster2
f	3	3	grp3	5	cluster2
g	2	1	grp3	5	cluster2



**********************A potential bug******************************
If -c column have only 1 value, program will be aborted by no reasons.


${txtbld}OPTIONS${txtrst}:
	-f	Data file 
		With header line, the first column is the rowname, tab seperated.
		Each row represents variable (normally genes), each column represents samples.
		${bldred}[NECESSARY]${txtrst}
	-g	Sample group file with first column as sample names, other columns as sample 
		attributes. Below, color, size, shape variable should be existed in this file.
		${bldred}[Optional. 
		If not supplied, each sample will be treated as one group.
		And a variable named 'group' can be used to set as color or shape variable.]${txtrst}
	-l	Log-transform data before principle component analysis. [Lowercase l]
		[${txtred}Default False. 
		Accept a string like log2, log10 to get logarithms values.
		Actually other R functions can be used also.${txtrst}]	
	-a	Add a value before log-transform to avoid log(0).
		${bldred}[Default 1]${txtrst}
	-F	Scale data for PCA analysis.
		In defaut, prcomp will centralized data by minus mean value and
		normalize data by column standard deviation dividing.
		Often, we would normalize data.
		Only when we care about the real number changes other than the trends, 
		we do not need scale. When this happens, we expect the changin ranges 
	    of data is small for example log-transformed data.	
		${bldred}[Default TRUE.]${txtrst}
	-T	Use top n most changed variables for PCA computation.
		${bldred}[Default 5000. Giving 0 to use all variables.]${txtrst}
	-D	Dimensions to plot.
		${bldred}[Default 2. 
		Accept 3 (both color and shape variable needed and should be same variable).]${txtrst}
	-t	Title of picture[${txtred}Default empty title${txtrst}]
		[Scatter plot of horizontal and vertical variable]
	-p	Legend position [Lowercase p]
		[${txtred}Default right. Accept
		top, bottom, left, none,  or c(0.08, 0.8).${txtrst}]
	-R	Rotation angle for x-axis value(anti clockwise)
		[Default 0]
	-c	The variable for point color.
		${bldred}[Optional, such as color]${txtrst}
	-I	The order for color variable.
		${bldred}[Default alphabetical order, accept a string like
		"'K562','hESC','GM12878','HUVEC','NHEK','IMR90','HMEC'"]
		${txtrst}
	-s	The variable for point size.
		${bldred}[Optional, such as a number or 
		a variable like count, normally should be number column]${txtrst}
	-S	The variable for point shape.
		${bldred}[Optional, such as shape]${txtrst}
	-K	The order for shape variable.
		${bldred}[Default alphabetical order, accept a string like
		"'K562','hESC','GM12878','HUVEC','NHEK','IMR90','HMEC'"]
		${txtrst}
	-C	Manually specified colors.
		${bldred}[Default system default. 
		Accept string in format like <'"green", "red"'> (both types of quotes needed).]
		${txtrst}
	-A	Transparency value for points.
		${bldred}[Optional, such as a number or 
		a variable indicating one data column, 
		normally should be number column]${txtrst}
	-L	Label points.
		${bldred}[Default no-label (FALSE), accept TRUE]${txtrst}
	-N	Label font size.
		${bldred}[Default system default.]${txtrst}
	-M	Points check_overlap.
		${bldred}[Default FALSE, accept TRUE]${txtrst}
	-Q	Point hjust.
		${bldred}[Default 0, accept a positive (at leftt) and negative value (at right)]${txtrst}
	-w	The width of output picture.[${txtred}Default 20${txtrst}]
	-u	The height of output picture.[${txtred}Default 20${txtrst}] 
	-E	The type of output figures.[${txtred}Default pdf, accept
		eps/ps, tex (pictex), png, jpeg, tiff, bmp, svg and wmf)${txtrst}]
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
	-d	If you may want to specifize the order of
		other variables (default alphabetically), please supply a string like below.
		[${txtred}Accept sth like 
		(one level one sentence, separate by';') 
		data\$size <- factor(data\$size, levels=c("l1",
		"l2",...,"l10"), ordered=T) ${txtrst}]
	-z	Other parameters in ggplot format.
		[${bldred}optional${txtrst}]
	-e	Execute or not[${bldred}Default TRUE${txtrst}]
	-i	Install the required packages[${bldred}Default FALSE${txtrst}]


s-plot pca -f mat -g grp_file -c color -s size -S shape -L Samp

EOF
}

file=''
grp_file=''
title=''
xlab=''
ylab=''
xval=''
xval_order=''
yval_order=''
yval=''
scale="TRUE"
execute='TRUE'
ist='FALSE'
color='c_t_c_t0304'
color_v=''
log='nolog'
uwid=20
vhig=20
res=300
point_hjust=0
ext='pdf'
facet=''
size=''
shape='c_t_c_t0304'
par=''
variable_order=''
color_order=''
top_n=5000
shape_order=''
dimensions=2
legend_pos='right'
xtics_angle=0
hjust=0.5
vjust=1
alpha=1
jitter='FALSE'
label='FALSE'
log_add=1
check_overlap="FALSE"
colormodel='srgb'
label_font_size=""
scale_y='FALSE'
scale_y_way='scale_y_continuous(trans="log2")'

while getopts "hf:g:t:a:x:y:p:X:O:Q:T:R:Y:B:H:V:I:K:v:c:C:A:l:D:F:N:L:M:J:w:u:r:E:s:S:b:d:z:e:i:" OPTION
do
	case $OPTION in
		h)
			usage
			exit 1
			;;
		f)
			file=$OPTARG
			;;
		g)
			grp_file=$OPTARG
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
		p)
			legend_pos=$OPTARG
			;;
		R)
			xtics_angle=$OPTARG
			;;
		X)
			xval=$OPTARG
			;;
		O)
			xval_order=$OPTARG
			;;
		Y)
			yval=$OPTARG
			;;
		B)
			yval_order=$OPTARG
			;;
		c)
			color=$OPTARG
			;;
		Q)
			point_hjust=$OPTARG
			;;
		C)
			color_v=$OPTARG
			;;
		A)
			alpha=$OPTARG
			;;
		l)
			log=$OPTARG
			;;
		a)
			log_add=$OPTARG
			;;
		L)
			label=$OPTARG
			;;
		M)
			check_overlap=$OPTARG
			;;
		N)
			label_font_size=$OPTARG
			;;
		I)
			color_order=$OPTARG
			;;
		T)
			top_n=$OPTARG
			;;
		K)
			shape_order=$OPTARG
			;;
		D)
			dimensions=$OPTARG
			;;
		F)
			scale=$OPTARG
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
		b)
			facet=$OPTARG
			;;
		d)
			variable_order=$OPTARG
			;;
		s)
			size=$OPTARG
			;;
		J)
			jitter=$OPTARG
			;;
		S)
			shape=$OPTARG
			;;
		z)
			par=$OPTARG
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

mid=".pca"

if [ -z $file ] ; then
	echo 1>&2 "Please give filename."
	usage
	exit 1
fi

if [ "${log}" != "nolog" ]; then
	mid=${mid}"."${log}
fi

if [ "${scale}" == "TRUE" ]; then
	mid=${mid}".scale"
fi

. `dirname $0`/sp_configure.sh

cat <<END >${file}${mid}.r

if ($ist){
	install.packages("ggplot2", repo="http://cran.us.r-project.org")
	install.packages("ggfortify", repo="http://cran.us.r-project.org")
	install.packages("data.table", repo="http://cran.us.r-project.org")
	install.packages("ggrepel", repo="http://cran.us.r-project.org")
}
library(plyr)
library(ggplot2)
library(grid)
library(data.table, quietly=T)
library(ggfortify)

if (${label}) {
	library("ggrepel")
}
data <- read.table(file="$file", sep="\t", quote="", comment="", header=T, row.names=1)

data <- data[rowSums(data)!=0, ]

if (${top_n} != 0) {
	data_mad <- apply(data, 1, mad)
	data <- data[order(data_mad, decreasing=T)[1:${top_n}], ]
}

data <- as.data.frame(t(data))

sampleL = rownames(data)

if ("${grp_file}" == "") {
	data_t_label <- data
	data_t_label\$group = sampleL
	data_t_label\$Row.names = sampleL
} else {
	grp_data <- read.table("${grp_file}", sep="\t", quote="", header=T, row.names=1)
	data_t_label <- merge(data, grp_data, by=0, all.x=T)
	rownames(data_t_label) <- data_t_label\$Row.names
	data_t_label <- data_t_label[match(sampleL, data_t_label\$Row.names), ]
	#data_t_label <- grp_data[na.omit(sampleL, rownames(grp_data)), ]
}

shape_order <- c(${shape_order})

if (length(shape_order) > 1) {
	data_t_label\$${shape} <- factor(data_t_label\$${shape}, levels=shape_order, ordered=T)
}

color_order <- c(${color_order})

if (length(color_order) > 1) {
	data_t_label\$${color} <- factor(data_t_label\$${color}, levels=color_order, ordered=T)
}


if ("${log}" != "nolog"){
	data <- ${log}(data + ${log_add})
}

$variable_order

color_v <- c(${color_v})

if ("${shape}" != "c_t_c_t0304") {
	shape_level <- length(unique(data_t_label\$${shape}))
	shapes = (1:shape_level)%%30
}

pca <- prcomp(data, scale=${scale})

# sdev: standard deviation of the principle components.
# Square to get variance
percentVar <- pca\$sdev^2 / sum( pca\$sdev^2)

if (${dimensions} == 2) {

	if (("${size}" != "") && ("${color}" != "c_t_c_t0304") && ("${shape}" != "c_t_c_t0304")) {
		p <- autoplot(pca, data=data_t_label, colour="${color}", shape="${shape}", size="${size}", alpha=${alpha})  
	} else if (("${color}" != "c_t_c_t0304") && ("${shape}" != "c_t_c_t0304")) {
		p <- autoplot(pca, data=data_t_label, colour="${color}", shape="${shape}",alpha=${alpha})  
	} else if (("${size}" != "") && ("${shape}" != "c_t_c_t0304")) {
		p <- autoplot(pca, data=data_t_label, shape="${shape}", size="${size}", alpha=${alpha})  
	} else if (("${size}" != "") && ("${color}" != "c_t_c_t0304")) {
		p <- autoplot(pca, data=data_t_label, colour="${color}", size="${size}", alpha=${alpha})  
	} else if ("${size}" != "") {
		p <- autoplot(pca, data=data_t_label, size="${size}", alpha=${alpha})  
	} else if ("${color}" != "c_t_c_t0304") {
		p <- autoplot(pca, data=data_t_label, colour="${color}", alpha=${alpha})  
	} else if ("${shape}" != "c_t_c_t0304") {
		p <- autoplot(pca, data=data_t_label, shape="${shape}", alpha=${alpha})  
	} else {
		p <- autoplot(pca, data=data_t_label)  
	}

	if (("${color}" != "c_t_c_t0304") && length(color_v) == 2) {
		p <- p + scale_colour_gradient(low=color_v[1], high=color_v[2], name="${color}")
	}

	if (("${shape}" != "c_t_c_t0304") && shape_level > 6) {
		p <- p + scale_shape_manual(values=shapes)
	}


	if (${label}) {
		#p <- p + geom_text(aes(label=Row.names), position="identity",
		#hjust=${point_hjust}, size=${label_font_size}, check_overlap=${check_overlap})
		if ("${label_font_size}" != "") {
			p <- p + geom_text_repel(aes(label=Row.names), size=${label_font_size})
		} else {
			p <- p + geom_text_repel(aes(label=Row.names))
		}
	}

	p <- p + xlab(paste0("PC1 (", round(percentVar[1]*100), "% variance)")) + 
		ylab(paste0("PC2 (", round(percentVar[2]*100), "% variance)"))

	p <- p ${facet}


} else {
	library(scatterplot)	
	if ("${color}" != "c_t_c_t0304") { 
		# 根据分组数目确定颜色变量
		group = data_t_label\$${color}
		colorA <- rainbow(length(unique(group)))
		
		# 根据每个样品的分组信息获取对应的颜色变量
		colors <- colorA[as.factor(group)]
		
		# 根据样品分组信息获得legend的颜色
		colorl <- colorA[as.factor(unique(group))]
	}

	if ("${shape}" != "c_t_c_t0304") { 
		# 获得PCH symbol列表
		group <- data_t_label\$${shape}
		pch_l <- as.numeric(as.factor(unique(group)))
		# 产生每个样品的pch symbol
		pch <- pch_l[as.factor(group)]
	}

	pc <- as.data.frame(pca\$x)
	pdf("${file}${mid}.pdf")
	scatterplot3d(x=pc\$PC1, y=pc\$PC2, z=pc\$PC3, pch=pch, color=colors, xlab=paste0("PC1 (", round(percentVar[1]*100), "% variance)"), ylab=paste0("PC2 (", round(percentVar[2]*100), "% variance)"), zlab=paste0("PC3 (", round(percentVar[3]*100), "% variance)"))

	legend(-3,8, legend=levels(as.factor(${color})), col=colorl, pch=pch_l, xpd=T, horiz=F, ncol=6)
	dev.off()
}

END

if [ "${dimensions}" == "2" ]; then
	`ggplot2_configure`
fi

if [ "$execute" == "TRUE" ]; then
	Rscript ${file}${mid}.r
if [ "$?" == "0" ]; then /bin/rm -f ${file}${mid}.r; fi
fi


#convert -density 200 -flatten ${file}${mid}.eps ${first}${mid}.png
