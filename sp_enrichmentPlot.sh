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

Description	GeneRatio	qvalue	Count	Type
ERBB signaling pathway	7/320	0.001836081	7	EHBIO_up
regulation of ERBB signaling pathway	5/320	0.003886659	5	EHBIO_up
negative regulation of cell cycle G1/S phase transition	4/320	0.016153254	4	EHBIO_up
Wnt signaling pathway	13/320	0.01680096	13	EHBIO_up
cell-cell signaling by wnt	13/320	0.0171473	13	EHBIO_up
negative regulation of cell cycle process	8/320	0.019453085	8	EHBIO_up
extrinsic apoptotic signaling pathway	9/320	0.024164034	9	EHBIO_up
positive regulation of extrinsic apoptotic signaling pathway	4/320	0.025708228	4	EHBIO_up
cell cycle G1/S phase transition	7/320	0.035797856	7	EHBIO_up
negative regulation of apoptotic signaling pathway	8/320	0.038684745	8	EHBIO_up
regulation of Notch signaling pathway	4/320	0.041592045	4	EHBIO_up
regulation of cell cycle G1/S phase transition	5/320	0.047407619	5	EHBIO_up
negative regulation of BMP signaling pathway	3/320	0.049460847	3	EHBIO_up
regulation of ERK1 and ERK2 cascade	14/342	0.000629602	14	Baodian_up
positive regulation of cell adhesion	17/342	0.000827275	17	Baodian_up
ERK1 and ERK2 cascade	14/342	0.001086508	14	Baodian_up
regulation of cell growth	17/342	0.002228511	17	Baodian_up
positive regulation of cytoskeleton organization	10/342	0.004406867	10	Baodian_up
regulation of cell-cell adhesion	15/342	0.005075219	15	Baodian_up
regulation of cytoskeleton organization	15/342	0.019685646	15	Baodian_up
negative regulation of Notch signaling pathway	3/342	0.020578211	3	Baodian_up
neuron apoptotic process	10/342	0.040284925	10	Baodian_up



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
	-R	Rotation angle for x-axis value(anti clockwise)
		[Default 0]
	-H	Hjust when rotation angle for x-axis value is not zero(anti clockwise)
		[Default 0.5; angle 45, hjust 0 vjust 0]
	-V	Vjust when rotation angle for x-axis value is not zero(anti clockwise)
		[Default 1; angle 90, hjust 0 vjust 1]
	-o	The variable for horizontal axis.
		${bldred}[NECESSARY, such Sample]${txtrst}
	-T	Type of horizontal axis variable.
		${bldred}[NECESSARY, default string, accept numeric]${txtrst}
	-O	The order for horizontal axis.
		${bldred}[Only woroks if horizontal axis variables are strings. 
		If horizontaol axis are numbers like GeneRatio, this will be treated as 
		sample order.
		Default alphabetical order, accept a string like
		"'K562','hESC','GM12878','HUVEC','NHEK','IMR90','HMEC'"  
		***When -m is used, this default will be ignored too.********* 
	   	${txtrst}]
		]${txtrst}
	-v	The variable for vertical axis.
		${bldred}[NECESSARY, such as Term]${txtrst}
	-c	The variable for point color.
		${bldred}[NECESSARY, such as p_value]${txtrst}
	-s	The variable for point size.
		${bldred}[NECESSARY, such as count]${txtrst}
	-S	The variable for sample classification.
		${bldred}[Optional, if given will use different shapes for each sample]${txtrst}
	-C	The specified colors.
		${bldred}[Default '"green", "red"'. ]${txtrst}
	-l	Get log-transformed data for given variable.
		[${txtred}Default nolog, means no log10 transform. Accept a variable
		like p_value to get (-1) * log10(p_value).${txtrst}]	
	-w	The width of output picture.[${txtred}Default 20${txtrst}]
	-a	The height of output picture.[${txtred}Default 20${txtrst}] 
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
	-d	If facet is given, you may want to specifize the order of
		variable in your facet, default alphabetically.
		[${txtred}Accept sth like 
		(one level one sentence, separate by';') 
		data\$size <- factor(data\$size, levels=c("l1",
		"l2",...,"l10"), ordered=T) ${txtrst}]
	-z	Other parameters in ggplot format.[${bldred}selection${txtrst}]
	-e	Execute or not[${bldred}Default TRUE${txtrst}]
	-i	Install the required packages[${bldred}Default FALSE${txtrst}]

Examples:
 
# -f: 指定输入文件，格式如上面描述
# -o: 指定横轴的变量，单个样品一般选择GeneRatio或样品名字
# -T: 指定横轴变量的类似，是字符串还是数值
# -v: 指定Y轴显示的内容，一般为富集条目的描述
# -c: 指定用哪一列设置颜色展示，一般为qvalue或p.adjust
# -s: 指定用哪一列设置点的大小，一般为Count
# -l: 指定某一列进行对数操作，一般选qvalue列；如果已做过对数操作，则忽略
# -a: 设置图片输出高度
# -x, -y: 设置横轴和纵轴标题，注意多个单词需要引号括起来
* sp_enrichmentPlot.sh -f GOenrichement.ehbio.xls -o GeneRatio -T numeric -v Description -c qvalue -s Count -l qvalue -a 12 -x "GeneRatio" -y "GO description"

# -o: 指定横轴的变量，单个样品一般选择GeneRatio或样品名字
# -T: 如果是样品名字，指定为字符串
* sp_enrichmentPlot.sh -f GOenrichement.ehbio.xls -o Type -T string -v Description -c qvalue -s Count -l qvalue -a 12 -x "Sample" -y "GO description"

# 多出来的参数是-S用来指定样品分组，不同类型的基因的富集分析用不同的形状表示
* sp_enrichmentPlot.sh -f GOenrichement.xls -o GeneRatio -T numeric -v Description -c qvalue -s Count -l qvalue -a 12 -x "GeneRatio" -y "GO description" -S Type

# 跟单个样品不显示GeneRatio的命令一样，不同的样品分列展示。
* sp_enrichmentPlot.sh -f GOenrichement.xls -o GeneRatio -T numeric -v Description -c qvalue -s Count -l qvalue -a 12 -x "GeneRatio" -y "GO description" -S Type

EOF
}

file=''
title=''
xlab=''
ylab=''
xval=''
xval_ho=''
xval_type='string'
yval=''
execute='TRUE'
ist='FALSE'
color=''
color_v='"green", "red"'
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
xtics_angle=0
hjust=0.5
vjust=1
sample='CTctCT'

while getopts "hf:t:x:y:o:O:P:R:H:V:v:T:c:C:l:w:a:r:E:s:S:b:d:z:e:i:" OPTION
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
		R)
			xtics_angle=$OPTARG
			;;
		H)
			hjust=$OPTARG
			;;
		V)
			vjust=$OPTARG
			;;
		o)
			xval=$OPTARG
			;;
		S)
			sample=$OPTARG
			;;
		O)
			xval_ho=$OPTARG
			;;
		T)
			xval_type=$OPTARG
			;;
		v)
			yval=$OPTARG
			;;
		c)
			color=$OPTARG
			;;
		C)
			color_v=$OPTARG
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


if test "${xval_type}" == "string"; then
	if test "${sample}" == "CTctCT"; then 
		sample="${xval}"
	fi
fi
	
shape=''

if test "${sample}" != "CTctCT" && test "${sample}" != "${xval}"; then
	shape=", shape=${sample}"
fi

if test "${log}" != "nolog"; then
	color="negLog10_${color}"
fi

cat <<END >${file}${mid}.r

if ($ist){
	install.packages("ggplot2", repo="http://cran.us.r-project.org")
}
library(plyr)
library(stringr)
library(ggplot2)
library(grid)

# Function get from https://stackoverflow.com/questions/10674992/convert-a-character-vector-of-mixed-numbers-fractions-and-integers-to-numeric?rq=1
# With little modifications

mixedToFloat <- function(x){
  x <- sapply(x, as.character)
  is.integer  <- grepl("^-?\\\\d+$", x)
  is.fraction <- grepl("^-?\\\\d+\\\\/\\\\d+$", x)
  is.float <- grepl("^-?\\\\d+\\\\.\\\\d+$", x)
  is.mixed    <- grepl("^-?\\\\d+ \\\\d+\\\\/\\\\d+$", x)
  stopifnot(all(is.integer | is.fraction | is.float | is.mixed))

  numbers <- strsplit(x, "[ /]")

  ifelse(is.integer,  as.numeric(sapply(numbers, \`[\`, 1)),
  ifelse(is.float,    as.numeric(sapply(numbers, \`[\`, 1)),
  ifelse(is.fraction, as.numeric(sapply(numbers, \`[\`, 1)) /
                      as.numeric(sapply(numbers, \`[\`, 2)),
                      as.numeric(sapply(numbers, \`[\`, 1)) +
                      as.numeric(sapply(numbers, \`[\`, 2)) /
                      as.numeric(sapply(numbers, \`[\`, 3)))))
  
}

#mixedToFloat(c('1 1/2', '2 3/4', '2/3', '11 1/4', '1'))


data <- read.table(file="$file", sep="\t", quote="", comment="", header=T)

xval_ho <- c(${xval_ho})

if ("${sample}" != "CTctCT" & length(xval_ho) > 1) {
	data\$${sample} <- factor(data\$${sample}, levels=sample_ho, ordered=T)
} #else {
#	data\$${xval} <- factor(data\$${xval})
#}

# First order by Term, then order by Sample
if ("${sample}" != "CTctCT") {
	data <- data[order(data\$${yval}, data\$${sample}), ]
}

if ("${xval_type}" != "string"){
	data\$${xval} = mixedToFloat(data\$${xval})
}


if ("${log}" != "nolog"){
	log_name = paste0("negLog10_", "${log}")
	col_name_data <- colnames(data)
	col_name_data <- c(col_name_data, log_name)
	data\$log_name <- log10(data\$${log}) * (-1)
	colnames(data) <- col_name_data
}

# Get the count of each unique Term
data_freq <- as.data.frame(table(data\$${yval}))

colnames(data_freq) <- c("${yval}", "IDctct")

data2 <- merge(data, data_freq, by="${yval}")

if ("${sample}" != "CTctCT"){
	# Collapse sample for each Term 
	data_samp <- ddply(data2, "${yval}", summarize,
		sam_ct_ct_ct=paste(${sample}, collapse="_"))

	data2 <- merge(data2, data_samp, by="${yval}")

	#print(data2)

	if ("${xval_type}" != "string"){
		data3 <- data2[order(data2\$IDctct, data2\$sam_ct_ct_ct, data2\$${sample}, data2\$${xval}, data2\$${color}), ]
	} else {
		data3 <- data2[order(data2\$IDctct, data2\$sam_ct_ct_ct, data2\$${sample}, data2\$${color}), ]
	}
} else{
	if ("${xval_type}" != "string"){
		data3 <- data2[order(data2\$IDctct, data2\$${xval}, data2\$${color}), ]
	} else {
		data3 <- data2[order(data2\$IDctct, data2\$${color}), ]
	}
}
#print(data3)

term_order <- unique(data3\$${yval})

data\$${yval} <- factor(data\$${yval}, levels=term_order, ordered=T)



#print(data)
rm(data_freq, data2, data3)


$facet_o

color_v <- c(${color_v})

p <- ggplot(data, aes(x=${xval},y=${yval})) \
+ labs(x="$xlab", y="$ylab") + labs(title="$title")

if (("${size}" != "") && ("${color}" != "")) {
	
	p <- p + geom_point(aes(size=${size}, color=${color} ${shape})) + \
	scale_colour_gradient(low=color_v[1], high=color_v[2], name="${color}")
} else if ("${size}" != "") {
	p <- p + geom_point(aes(size=${size} ${shape}))
} else if ("${color}" != "") {
	p <- p + geom_point(aes(color=${color} ${shape})) + \
	scale_colour_gradient(low="color_v[1]", high=color_v[2], name="${color}")
}


p <- p ${facet}

p <- p + scale_y_discrete(labels=function(x) str_wrap(x, width=60))
 
p <- p $other


p <- p + theme_bw() + theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank())

if (${xtics_angle} != 0){
	p <- p +
	theme(axis.text.x=element_text(angle=${xtics_angle},hjust=${hjust},
	vjust=${vjust}))
}

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
