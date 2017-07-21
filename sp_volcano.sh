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

This script is used to do volcano plot using package ggplo2.

Input data format 

1. at least the middle two columns,
2. unspecified columns will e ignored.

id	log2FoldChange	padj	significant	label
E007	4.28238	0	EHBIO_UP	A
E008	-1.1036	0.476466843393901	Unchanged	-
E009	-0.274368	1	Unchanged	-
E010	4.62347	7.37606076333335e-103	EHBIO_UP	-
E012	0.973987	0.482982440163204	Unchanged	-
E017	-1.30205	0.000555693857439792	Baodian_UP	B
E024	0.617636	2.78047837287061e-13	Unchanged	-
E033	1.48669	2.56000581595275e-60	EHBIO_UP	-
E034	-0.783716	0.00341521725291801	Unchanged	-
E036	2.01592	6.03136656016401e-06	EHBIO_UP	C
E040	-1.89657	4.73663890849056e-21	Baodian_UP	-
E041	-0.268168	0.563429434558031	Unchanged	-
E042	0.0861048	0.367700939634328	Unchanged	-
E043	-1.19328	1.42673872027352e-153	Baodian_UP	-
E044	-0.887981	2.43067804654905e-26	Unchanged	-
E047	-0.610941	5.51696648645932e-57	Unchanged	-
E048	-0.544351	2.42900721027123e-38	Unchanged	-
E054	0.373722	1.69385211067434e-06	Unchanged	-
E060	3.22733	1.08848317711107e-238	EHBIO_UP	-
E062	1.26537	6.3438645414141e-41	EHBIO_UP	-
E064	-0.401441	1.35363906397594e-07	Unchanged	-
E065	-0.905871	0.64100736122527	Unchanged	-
E066	-0.412675	1.89555581147485e-05	Unchanged	-
E068	-0.488643	2.81319250002425e-13	Unchanged	-
E073	0.144652	0.108536041355102	Unchanged	-
E075	0.475323	1.21849683011948e-07	Unchanged	-
E081	-0.273948	4.67906793891271e-05	Unchanged	-
E082	0.623662	1.53067032405198e-24	Unchanged	-
E095	0.0564134	0.61037011697553	Unchanged	-
E096	-1.29457	0.349818725268806	Unchanged	-
E098	-0.375406	4.80049162685674e-15	Unchanged	-
E104	-0.129981	0.0595371890365006	Unchanged	-
E105	0.811434	3.90502774603209e-49	Unchanged	-
E108	-0.493828	1.17208007432069e-10	Unchanged	-
E111	0.01269	0.935748848271866	Unchanged	-
E112	0.0568809	0.439992424549575	Unchanged	-
E113	-0.66374	9.59474680936351e-06	Unchanged	-
E121	-0.945522	4.94134699310043e-08	Unchanged	-
E122	0.510222	3.51349144156778e-16	Unchanged	-
E123	0.551709	4.06616785953765e-34	Unchanged	-
E127	-0.16277	0.00687878965463131	Unchanged	-
E129	1.96627	8.03319859544436e-27	EHBIO_UP	-
E130	1.7085	0	EHBIO_UP	-
E133	-0.16597	0.0199927844575907	Unchanged	-
E137	1.42666	1.75895642402667e-22	EHBIO_UP	-
E138	-0.991176	0.0041887933762352	Unchanged	-
E142	-1.29229	4.91329890422908e-59	Baodian_UP	D
E145	0.608214	3.9497193155922e-11	Unchanged	-
E150	-0.729799	6.22689684070255e-15	Unchanged	-

The parameters for logical variable are either TRUE or FALSE.

${txtbld}OPTIONS${txtrst}:
	-f	Data file (with header line, the first column is not the
 		rowname, tab seperated)${bldred}[NECESSARY]${txtrst}
	-x	Variable name for x-axis value (log2 transformed).
		${bldred}[NECESSARY, in sample data 'log2fc']${txtrst}
	-m	Make x-axis symmetry. [Default TRUE, accept FALSE]
	-y	Variable name for y-axis value.
		${bldred}[NECESSARY, in sample data 'pvalue']${txtrst}
	-s	Column for labeling status.
		${bldred}[Optional, in sample data 'significant'. Points will 
		be colored differently ]${txtrst}
	-S	Levels for labeling column, like "'TRUE','FALSE'".
   		[${bldred}Only needed when you trying to reorder the
		column to get different colors.${txtrst}]	
	-F	Set the filter threshold for selecting DE genes in format like 'pvalue,abs_log_fodchange'.
		This has lower priority than <-s>.
		[${bldred}Default "0.05,1". Here pvalue corresponds to the column given to <-y>.${txtrst}]
	-l	Label the names of significant points in graph.
		${bldred}[Default FALSE, accept a string represents the
		colname of labels. Non-hypen (-) strings in this column will be labeled.]${txtrst}
	-P	Get -log10(pvalue) for column given to <-y>
		[${bldred}Default FALSE, accept TRUE.${txtrst}]
	-M	Maximum transferred -log10(pvalue). Normally this should be 3 or 4.
		[${bldred}Default Inf, accept a number.${txtrst}]
	-t	Title of picture[${txtred}Default empty title${txtrst}]
		[Scatter plot of horizontal and vertical variable]
	-X	Xlab label[${txtred}Default "Log2 fold change"${txtrst}]
	-Y	Ylab label[${txtred}Default "Negative log10 transformed qvalue"${txtrst}]
	-a	Transparent alpha value.
		[${txtred}Default 0.4, Accept a float from
		[0(transparent),1(opaque)]${txtrst}]
	-p	Point size.[${txtred}Default 1${txtrst}]
	-L	Legend position[${txtred}Default right. Accept
		top,bottom,left,none, or c(0.08,0.8).${txtrst}]
	-u	The width of output picture.[${txtred}Default 12${txtrst}]
	-v	The height of output picture.[${txtred}Default 12${txtrst}] 
	-E	The type of output figures.[${txtred}Default pdf, accept
		eps/ps, tex (pictex), png, jpeg, tiff, bmp, svg and wmf)${txtrst}]
	-r	The resolution of output picture.[${txtred}Default NA${txtrst}]
	-e	Execute or not[${bldred}Default TRUE${txtrst}]
	-i	Install the required packages[${bldred}Default FALSE${txtrst}]
EOF




}

file=''
x_var=''
y_var=''
status_col=''
status_col_level=''
label='CTctctCT'
val_label=''
title=''
x_label='Log2 fold change'
y_label='Negative log10 transformed qvalue'
alpha=0.4
point_size=1
execute='TRUE'
ist='FALSE'
uwid=12
vhig=12
#res='NA'
res=300
symmetry='TRUE'
legend_pos='right'
status_col_level=''
ext='pdf'
colormodel='srgb'
transform_log='FALSE'
max_p='Inf'
filter_threshold='0.05,1'

while getopts "hf:x:m:y:s:-S:l:L:V:t:X:Y:F:a:p:P:M:u:v:E:r:e:i:" OPTION
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
		m)
			symmetry=$OPTARG
			;;
		y)
			y_var=$OPTARG
			;;
		s)
			status_col=$OPTARG
			;;
		S)
			status_col_level=$OPTARG
			;;
		F)
			filter_threshold=$OPTARG
			;;
		l)
			label=$OPTARG
			;;
		L)
			legend_pos=$OPTARG
			;;
		V)
			val_label=$OPTARG
			;;
		t)
			title=$OPTARG
			;;
		P)
			transform_log=$OPTARG
			;;
		M)
			max_p=$OPTARG
			;;
		X)
			x_label=$OPTARG
			;;
		Y)
			y_label=$OPTARG
			;;
		a)
			alpha=$OPTARG
			;;
		p)
			point_size=$OPTARG
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
		E)
			ext=$OPTARG
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

if [ -z $file ] ; then
	echo 1>&2 "Please give filename."
	usage
	exit 1
fi

self_compute_status='FALSE'
if [ -z $status_col ] && test "${filter_threshold}" != ""; then
	status_col='DE_genes'
	self_compute_status='TRUE'
fi

mid='.volcano'

cat <<END >${file}${mid}.r

if ($ist){
	install.packages("ggplot2", repo="http://cran.us.r-project.org")
}

library(ggplot2)
data <- read.table(file="$file", header=T, sep="\t", quote="")

if (! ${self_compute_status}){
	sig_level <- c(${status_col_level})
} else{
	filter_threshold <- c(${filter_threshold})
	pvalue = filter_threshold[1]
	fc = filter_threshold[2]
	sig_level <- c("UP", "DW", "NoDiff")
	data\$${status_col} <- ifelse(data\$${y_var}<=pvalue, ifelse(data\$${x_var}>=fc, "UP", ifelse(data\$${x_var}<=fc*(-1), "DW", "NoDiff")) , "NoDiff")
}

if (length(sig_level)>1){
	data\$${status_col} <- factor(data\$${status_col},levels=sig_level,
		ordered=T)
}

data\$${y_var} <- (-1)* log10(data\$${y_var})
data[data\$${y_var}>${max_p}, "${y_var}"] <- ${max_p}

p <- ggplot(data=data, aes(x=${x_var},y=${y_var},colour=${status_col}))
p <- p + geom_point(alpha=${alpha}, size=${point_size})
p <- p + theme(legend.position="none") + theme_bw() + 
	theme(legend.title=element_blank(),
	panel.grid.major = element_blank(), panel.grid.minor = element_blank())

if("${x_label}" != "NULL") {
	p <- p + xlab("${x_label}")
}

if("${y_label}" != "NULL") {
	p <- p + ylab("${y_label}")
}

if (${symmetry}) {
	boundary <- ceiling(max(abs(data\$${x_var})))
	p <- p + xlim(-1 * boundary, boundary)
}
if ("$label" != "CTctctCT"){
	data.l <- data[data\$${label}!="-" & data\$${label}!="",]
	p <- p + geom_text(data=data.l, aes(x=${x_var}, y=${y_var},
	label=$label), colour="black")
}


top='top'
botttom='bottom'
left='left'
right='right'
none='none'
legend_pos_par <- ${legend_pos}

#if ("${legend_pos}" != "right"){
p <- p + theme(legend.position=legend_pos_par)
#}


if ("${ext}" == "pdf") {
	ggsave(p, filename="${file}${mid}.${ext}", dpi=$res, width=$uwid,
	height=$vhig, units=c("cm"),colormodel="${colormodel}")
} else {
	ggsave(p, filename="${file}${mid}.${ext}", dpi=$res, width=$uwid,
	height=$vhig, units=c("cm"))
}

#png(filename="${file}${mid}.png", width=$uwid, height=$vhig,
#res=$res)
#p
#dev.off()
END

if [ "$execute" == "TRUE" ]; then
	Rscript ${file}${mid}.r
if [ "$?" == "0" ]; then /bin/rm -f ${file}${mid}.r; fi
fi

#if [ "$quiet" == "TRUE" ]; then
#	/bin/rm -f ${file}${mid}.r
#fi
#convert -density 200 -flatten ${file}${mid}.eps ${first}${mid}.png
