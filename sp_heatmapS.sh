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

This script is used to do multiple heatmap horizontally for
comparing among samples using package ggplot2 and reshape2.
Also it can deal with kmeans cluster before heatmap.

The parameters for logical variable are either TRUE or FALSE.

${txtbld}OPTIONS${txtrst}:
	-f	Data file (with header line, the first column is the
 		rowname, tab seperated. Colnames must be unique unless you
		know what you are doing.)${bldred}[NECESSARY]${txtrst}
	-t	Title of picture[${txtred}Default empty title${txtrst}]
		[Scatter plot of horizontal and vertical variable]
	-a	Display xtics. ${bldred}[Default TRUE. 
		This should also be set to TRUE even using manual x-tics.]${txtrst}
	-Q	Manually set the position of xtics.
		${bldred}[Default FALSE,  accept a series of
		numbers in following format "c(1,2,3,4,5)" or other R code
		that can generate a vector to set the position of xtics]${txtrst}
	-S	[Uppercase] Manually set the value of xtics when -Q is specified.
		${bldred}[Default the content of -Q when -Q is specified, 
		accept a series of
		numbers in following format "c(1,2,3,4,5)" or other R code
		that can generate a vector to set the text of xtics]${txtrst}
	-A	Rotation angle for x-axis value(anti clockwise)
		${bldred}[Default 0]${txtrst}
	-U	Rotation angle for y-axis value(anti clockwise)
		${bldred}[Default 0]${txtrst}
	-T	Hjust when rotation angle for x-axis value is not zero(anti clockwise)
		[Default 0.5; angle 45, hjust 0.5 vjust 0.5]
	-V	Vjust when rotation angle for x-axis value is not zero(anti clockwise)
		[Default 1; angle 90, hjust 1 vjust 0.5]
	-l	The position of legend. [${bldred}
		Default right. Accept top,bottom,left,none,c(0.1,0.8).${txtrst}]
	-I	The title of legend [${bldred}Default no title${txtrst}]
	-b	Display ytics. ${bldred}[Default FALSE]${txtrst}
	-B	Specifying colormodel.${bldred}[Default srgb, accept cmyk only
		for pdf, postscript, eps format]${txtrst}
	-R	Reverse the order of rows. Normally the row order of heatmap
		is the reverse of the row order in file. Giving a TRUE here to
		make the row order of heatmap same as input file.
	-H	Get hieratical cluster for columns first, then do kmeans for rows.
		${bldred}Default FALSE, accept TRUE ${txtrst}
	-L	First get log-value, then do other analysis.
		Accept an R function log2 or log10. You may want to add
		parameter to -J (scale_add) and -s (small). Every logged value
		less than -s will be assigned by -J.[Default -s is -Inf and -J
		is 1. Usually -s should be 0 and -J should be -1.] 
		${bldred}[Default FALSE]${txtrst}
	-K	Get log value before or after clustering.
		${bldred}[Default before, means before. Accept after means
		after]${txtrst}
	-u	The width of output picture.[${txtred}Default 20${txtrst}]
	-v	The height of output picture.[${txtred}Default 20${txtrst}] 
	-E	The type of output figures.[${txtred}Default pdf, accept
		eps/ps, tex (pictex), png, jpeg, tiff, bmp, svg and wmf)${txtrst}]
	-r	The resolution of output picture.[${txtred}Default 300 ppi${txtrst}]
	-F	Font size [${txtred}Default 14${txtrst}]
	-x	The color for representing low value.[${txtred}Default 
		green${txtrst}]
	-y	The color for representing high value.[${txtred}Default
		red${txtrst}]
	-M	The color representing mid-value.
		[${txtred}Default yellow${txtrst}]
	-Z	Use mid-value or not. [${txtred}Default FALSE, which means
		do not use mid-value. ${txtrst}]
	-X	The mid value you want to use.[${txtred}Default median value. A
		number is ok. When -Z is FALSE and -G is TRUE, this value will be 
		used as a separator point. The program will separate data into
		two parts, [minimum, midpoint] and [midpoint, minimum]. Each
		of these parts will be binned to same number of regions.]${txtrst}]
	-k	Would you like cluster.[${txtred}Default 1 which means no
		cluster, other positive interger is accepted for executing
		kmeans cluster, also the parameter represents the number of
		expected clusters.${txtrst}]
	-c	The cluster methods you want to use.[${bldred}kmeans, for
		distance cluster,
		accept clara for trend cluster.${txtrst}]
	-d	Scale the data or not for clustering.[Default no scale. Accept TRUE, scale by
		row]
	-n	Include cluster info.[Default TRUE, accept FALSE]
	-p	Delete rows all zero.[Default FALSE, accept TRUE]
	-z	Presort data by covariance coefficient.
		[Default FALSE, accept TRUE]
	-s	The smallest value you want to keep, any number smaller will
		be taken as 0.[${bldred}Default -Inf, Optional${txtrst}]  
	-m	The maximum value you want to keep, any number larger willl
		be taken as the given maximum value.
		[${bldred}Default Inf, Optional${txtrst}] 
	-N	Generate NA value.[${bldred}Assign NA to values in data table equal
		to given value to get different color representation.${txtrst}]
	-Y	Color for NA value.
		[${txtred}Default grey${txtrst}]
	-q	The smallest screen and file output.
		[Default FALSE, means no log and data output. 
		In future, we will change to following syntax.
		Accept:
	   		0 no log and data output	
			1 output clustered data
			2 only output clustered data no plot
		] 
	-j	Scale data for picture.[Default FALSE, accept TRUE]
	-J	When -j is TRUE,  supply a value to add to all values in data
		to avoid zero. When -L is used, the supplied value will be
		used to substitute values less than -s generated log
		processing. However, this has no effection to final data.
	   	[${bldred}Default 1${txtrst}]
	-o	Log transfer ot not.[${bldred}Default no log transfer,
		accept log or log2 ${txtrst}]
	-g	Cluster by which group.[${bldred}Default by all group${txtrst}]
	-G	Use quantile for color distribution. Default 5 color scale
		for each quantile.[Default FALSE, accept TRUE. Suitable for data range
		vary large. This has high priviority than -Z. -X can work when
		-G is TRUE]
	-D	The number of digits after the decimal point. 
		[${bldred}Default FALSE. Accept a number. If you data value 
		is very large,  please this parameter.${txtrst}]
	-C	Color list for plot when -G is TRUE.
		[${bldred}Default 'green','yellow','dark red'.
		Accept a list of colors each wrapped by '' and totally wrapped
		by "" ${txtrst}]
	-O	When -G is TRUE, using given data points as separtor to
		assign colors. [${bldred}Default -G default. Normally you can
		select a mid-point and give same bins between the minimum and
		midpoint, the midpoint and maximum.
		[0,0.2,0.4,0.6,0.8,1,2,4,6,8,10]${txtrst}]
	-e	Execute or not[${bldred}Default TRUE${txtrst}]
	-i	Install the required packages[${bldred}Default FALSE${txtrst}]
EOF
}

file=''
title=''
width=''
label=''
logv='FALSE'
logv_pos='before'
kclu=1
clu='kmeans'
scale='FALSE'
clusterInclu='TRUE'
group=0
execute='TRUE'
ist='FALSE'
legend=' '
na_color='grey'
legend_pos='right'
small="-Inf"
maximum="Inf"
log=''
uwid=20
vhig=20
res=300
fontsize=14
ext='pdf'
scale_op='FALSE'
scale_add=1
xcol='green'
ycol='red'
mcol='yellow'
mid_value_use='FALSE'
mid_value='Inf'
xtics='TRUE'
xtics_angle=0
ytics_angle=0
ytics='FALSE'
quiet='TRUE'
delZero='FALSE'
cvSort='FALSE'
gradient='FALSE'
hcluster='FALSE'
givenSepartor=''
gradientC="'green','yellow','red'"
generateNA='FALSE'
digits='FALSE'
colormodel='srgb'
reverse_rows='FALSE'
hjust=0.5
vjust=1
xtics_pos=0
xtics_value=0

while getopts "hf:t:u:v:H:Q:S:x:y:T:V:Y:M:R:I:L:K:X:r:F:E:w:l:a:A:U:b:B:k:c:d:n:g:s:N:j:J:m:o:G:D:C:O:q:e:i:p:Z:z:" OPTION
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
		t)
			title=$OPTARG
			;;
		u)
			uwid=$OPTARG
			;;
		v)
			vhig=$OPTARG
			;;
		H)
			hcluster=$OPTARG
			;;
		T)
			hjust=$OPTARG
			;;
		V)
			vjust=$OPTARG
			;;
		E)
			ext=$OPTARG
			;;
		Q)
			xtics_pos=$OPTARG
			;;
		S)
			xtics_value=$OPTARG
			;;
		x)
			xcol=$OPTARG
			;;
		y)
			ycol=$OPTARG
			;;
		M)
			mcol=$OPTARG
			;;
		Y)
			na_color=$OPTARG
			;;
		R)
			reverse_rows=$OPTARG
			;;
		L)
			logv=$OPTARG
			;;
		K)
			logv_pos=$OPTARG
			;;
		Z)
			mid_value_use=$OPTARG
			;;
		X)
			mid_value=$OPTARG
			;;
		r)
			res=$OPTARG
			;;
		F)
			fontsize=$OPTARG
			;;
		w)
			width=$OPTARG
			;;
		l)
			legend_pos=$OPTARG
			;;
		I)
			legend=$OPTARG
			;;
		a)
			xtics=$OPTARG
			;;
		A)
			xtics_angle=$OPTARG
			;;
		U)
			ytics_angle=$OPTARG
			;;
		b)
			ytics=$OPTARG
			;;
		B)
			colormodel=$OPTARG
			;;
		k)
			kclu=$OPTARG
			;;
		c)
			clu=$OPTARG
			;;
		d)
			scale=$OPTARG
			;;
		n)
			clusterInclu=$OPTARG
			;;
		g)
			group=$OPTARG
			;;
		p)
			delZero=$OPTARG
			;;
		z)
			cvSort=$OPTARG
			;;
		s)
			small=$OPTARG
			;;
		m)
			maximum=$OPTARG
			;;
		N)
			generateNA=$OPTARG
			;;
		j)
			scale_op=$OPTARG
			;;
		J)
			scale_add=$OPTARG
			;;
		o)
			log=$OPTARG
			;;
		G)
			gradient=$OPTARG
			;;
		D)
			digits=$OPTARG
			;;
		C)
			gradientC=$OPTARG
			;;
		O)
			givenSepartor=$OPTARG
			;;
		q)
			quiet=$OPTARG
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

mid=".heatmapS"

if [ -z $file ] ; then
	echo 1>&2 "Please give filename."
	usage
	exit 1
fi

if test $kclu -gt 1; then
	mid=${mid}".${clu}.$kclu.$group"
fi

if test "$log" != ''; then
	mid=${mid}".$log"
fi

if test "${scale}" == "TRUE"; then
	mid=${mid}".scale"
fi

if test "${colormodel}" == "cmyk"; then
	mid=${mid}".cmyk"
fi

cat <<END >${file}${mid}.r

if ($ist){
	install.packages("ggplot2", repo="http://cran.us.r-project.org")
	install.packages("reshape2", repo="http://cran.us.r-project.org")
	#install.packages("extrafont", repo="http://cran.us.r-project.org")
	#font_import()
	if ($kclu > 1){
		install.packages("cluster", repo="http://cran.us.r-project.org")
	}
	if ($hcluster){
		install.packages("amap", repo="http://cran.us.r-project.org")
	}
}
library(ggplot2)
library(reshape2)
#library(extrafont)
#loadfonts()



if($gradient){
	library(RColorBrewer)
}
if ($kclu > 1){
	library(cluster)
}

if ($hcluster) {
	library(amap)
}

if (! $quiet){
	print("Read in data set.")
}
data <- read.table(file="$file", sep="\t", header=T, row.names=1,
	check.names=F, quote="")

if ($hcluster) {
	if (! $quiet){
		print("reorder columns using hieratical cluster")
	}
	t_data <- t(data)
	fit <- hcluster(t_data)
	data <- t(t_data[fit\$order, ])
	data <- as.data.frame(data)
}

#print("Read in label.")
#label is for group level
#label <- as.vector(read.table(file="$label", sep="\t", header=F)\$V1)
#dimD <- dim(data)
##size <- dimD[1] * $width
#size <- dimD[1] * ($width+1)
#print("Prepare group")
#grp <- rep(label, each=size)
#print("Rename each column to make each one uniqu")
#names(data) <- paste0(rep(label, each=$width), names(data))

if ("${logv_pos}" == "before" && "${logv}" != "FALSE"){
	if (! $quiet){
		print("${logv} data before clustering.")
	}
	data[data==1] <- 1.0001
	data <- ${logv}(data)
	data[data<${small}] = ${scale_add}
}

if ($kclu>1){

	if (! $quiet){
		print("Delete rows containing 0 only.")
	}
	data.zero <- data[rowSums(data)==0,]
	rowZero <- nrow(data.zero)
	data <- data[rowSums(data)!=0,]

	if (! $quiet){
		print("Prepare data for clustering.")
	}
	if ($small != "-Inf"){
		mindata <- $small
	}else{
		mindata <- min(data)
	}
	if ($maximum != "Inf"){
		maxdata <- $maximum
	}else{
		maxdata <- max(data)
	}
	step <- (maxdata-mindata)/$kclu
	if ($cvSort){
		if (! $quiet){
			print("Sort data by coefficient variance.")
		}
		sd <- apply(data, 1, sd) #1 means row, 2 means col
		mean <- rowMeans(data)
		cv <- sd/mean
		data <- data[order(cv),]
	}
	if ($group == 0){
		data.k <- data
	}
	else if ($group > 0){
		start = ($group-1) * $width + 1
		end = $group * $width
		data.k <- data[,start:end]
	}
	if ($scale){
		if (! $quiet){
			print("Scale data.")
		}
		data.k <- t(apply(data.k,1,scale))
	}
	if (! $quiet){
		print("Cluster data.")
	}
	if ("$clu" == "clara" ){
		data.d <- t(apply(data.k,1,diff))
		data.clara <- clara(data.d, $kclu)
		cluster_172 <- data.clara\$clustering
		#data.clara <- kmeans(data.d, $kclu, iter.max=1000)
		#cluster_172 <- data.clara\$cluster
		rm(data.d)
	}else
	if ("$clu" == 'kmeans'){
		set.seed(3)
		data.clara <- kmeans(data.k, $kclu, iter.max = 1000)
		cluster_172 <- data.clara\$cluster
	}
	tmp_cluster_172 <- mindata + (cluster_172-1) * step
	data.m1 <- cbind(cluster=cluster_172, rownames(data))[,1]
	if (! $quiet){
		print("Output clustered result")
		output <- paste("${file}${mid}", "cluster", sep='.')
		#data.m1 <- data.m1[order(cluster_172),]
		write.table(data.m1, file=output, sep="\t", quote=F, col.names=F)
		print("Sort data by cluster.")
	}
	if (${scale_op}){
		data <- data + ${scale_add}
		data.s <- as.data.frame(t(apply(data, 1, scale)))
		colnames(data.s) <- colnames(data)

		mindata <- min(data.s)
		maxdata <- max(data.s)
		step <- (maxdata-mindata)/$kclu
		tmp_cluster_172 <- mindata + (cluster_172-1) * step
		#---------------add cluster info-------------------
		if ($clusterInclu){
			data.s\$cluster <- tmp_cluster_172
		}
		#----------sort data by cluster-----this must be after add
		#-----cluster info-------------
		data.s <- data.s[order(cluster_172),]
		if ((rowZero > 0) & (! ${delZero})){
			if (! $quiet) {
				print("Add rows which are all zero")
			}
			if ($clusterInclu){
				if (! $quiet) {
					print("Add cluster info for rows which are all zero")
				}
				newcluster <- mindata - step
				cluster_315_for_zero <- c(rep(newcluster, rowZero)) 
				data.zero\$cluster <- cluster_315_for_zero
			}
			data.s <- rbind(data.zero, data.s)
		}
		if (! $quiet){
			output <- paste("${file}${mid}", \
				"cluster.scaleop.final", sep='.')
			write.table(data.s, file=output, sep="\t", \
				quote=F, col.names=NA)
		}
	}
	#--for output original data ---------------------------
	if ($clusterInclu){
		data\$cluster <- cluster_172
	}
	data <- data[order(cluster_172),]

	if ((rowZero > 0) & (! ${delZero})){
		if (! $quiet) {
			print("Add rows which are all zero")
		}
		if ($clusterInclu){
			if (! $quiet) {
				print("Add cluster info for rows which are all zero")
			}
			newcluster <- mindata - step
			cluster_315_for_zero <- c(rep(newcluster, rowZero)) 
			data.zero\$cluster <- cluster_315_for_zero
		}
		data <- rbind(data.zero, data)
	}


	if (! $quiet){
		output <- paste("${file}${mid}", "cluster.final", sep='.')
		write.table(data, file=output, sep="\t", quote=F, col.names=T)
	}
	#--for output original data ---------------------------
	#--for use scaled data-----------------------------
	if ($scale_op){
		data <- data.s
	}
	rm(data.m1, data.k, data.clara)
	
}else{
	#---for raw data scale-----no cluster------------
	if ($scale_op){
		colname <- colnames(data)
		data <- as.data.frame(t(apply(data,1,scale)))
		colnames(data) <- colname
	}
}

if ("${logv_pos}" == "after" && "${logv}" != "FALSE"){
	if (! $quiet){
		print("${logv} data after clustering.")
	}
	data[data==1] <- 1.0001
	data <- ${logv}(data)
	data[data<${small}] = ${scale_add}
}

if (! $quiet){
	print("Melt data.")
}
#oriLen <- dimD[2]
data\$id <- rownames(data)
idlevel <- as.vector(rownames(data))

if (${reverse_rows}) {
	idlevel <- rev(idlevel)
}

#data\$idsort <- data\$id[order(data\$cluster)]
#data\$idsort <- order(data\$idsort)
if (! $quiet){
	print("Reorganize data.")
}
#data.m <- melt(data, id.vars = c("id", "idsort"))
#---------------
#data.m <- melt(data, c("id"), names(data)[1:oriLen])
data.m <- melt(data, c("id"))
if (! $quiet){
	output2 <- paste("${file}${mid}", "cluster.melt", sep='.')
	write.table(data.m, file=output2, sep="\t" , quote=F,
	col.names=T, row.names=F)
}

if("${generateNA}" != "FALSE"){
	data.m\$value[data.m\$value == ${generateNA}] <- NA
}

data.m\$id <- factor(data.m\$id, levels=idlevel, ordered=T)

data.m\$value[data.m\$value < $small] <- 0

data.m\$value[data.m\$value > $maximum] <- $maximum

if (! $quiet){
	print("Prepare ggplot layers.")
}

#p <- ggplot(data=data.m, aes(x=variable, y=id)) + \
#geom_tile(aes(fill=value)) 
#facet_grid( .~grp) 

if($gradient){
	gradientC <- c(${gradientC})
	summary_v <- summary(data.m\$value)
	break_v <- c($givenSepartor)
	if (length(break_v) < 3){
		if (${mid_value} == Inf){
			break_v <- \
			unique(c(seq(summary_v[1]*0.95,summary_v[2],length=6),seq(summary_v[2],summary_v[3],length=6),seq(summary_v[3],summary_v[5],length=5),seq(summary_v[5],summary_v[6]*1.05,length=5)))
		} else {
			break_v <- \
			unique(c(seq(summary_v[1]*0.95, ${mid_value},
			length=10),
			seq(${mid_value},summary_v[6]*1.05,length=10)))
		}

		if("${digits}" != "FALSE"){
			break_v <- prettyNum(break_v, digits=${digits})
		}
		data.m\$value <- cut(data.m\$value, breaks=break_v,\
			labels=break_v[2:length(break_v)])

		break_v=unique(data.m\$value)
	}else {
		data.m\$value <- cut(data.m\$value, breaks=break_v,\
			labels=break_v[2:length(break_v)])
		#break_v=unique(data.m\$value)
	}
	
	col <- colorRampPalette(gradientC)(length(break_v))
	print(col)
	print(break_v)
	#p <- p + scale_fill_gradientn(colours = c("$xcol", "$mcol","$ycol"), breaks=break_v, labels=format(break_v))
	p <- ggplot(data=data.m, aes(x=variable, y=id)) + \
	geom_tile(aes(fill=value)) + scale_fill_manual(values=col,
	name="${legend}", na.value="${na_color}")
	#scale_fill_brewer(palette="PRGn")
} else {
	p <- ggplot(data=data.m, aes(x=variable, y=id)) + \
	geom_tile(aes(fill=value)) 
	if( "$log" == ''){
		if (${mid_value_use}){
			if (${mid_value} == Inf){
				midpoint = median(data.m\$value)
			}else {
				midpoint = ${mid_value}
			}
			p <- p + scale_fill_gradient2(low="$xcol", mid="$mcol",
				high="$ycol", midpoint=midpoint, name="$legend",
				na.value="${na_color}")
		}else {
			p <- p + scale_fill_gradient(low="$xcol", high="$ycol",
				name="${legend}", na.value="${na_color}")
		}
	}else {
		p <- p + scale_fill_gradient(low="$xcol", high="$ycol",
		trans="$log", name="${legend}", na.value="${na_color}")
	}
} #end the else of gradient 

p <- p + theme(axis.ticks=element_blank()) + theme_bw() + 
	theme(panel.grid.major = element_blank(), 
	panel.grid.minor = element_blank()) + xlab(NULL) + ylab(NULL)

	#theme(legend.title=element_blank(),
#if ("${legend}" != " "){
#	p <- p + theme(legend.title="${legend}")
#}

if ("$xtics" == "FALSE"){
	p <- p + theme(axis.text.x=element_blank())
}else{
	if (${xtics_angle} != 0){
	#p <- p + theme(axis.text.x=element_text(angle=${xtics_angle},hjust=1))
	p <- p + theme(axis.text.x=element_text(angle=${xtics_angle}, 
		hjust=${hjust}, vjust=${vjust}))
	}
}
if ("$ytics" == "FALSE"){
	p <- p + theme(axis.text.y=element_blank())
} else {
	if (${ytics_angle} != 0){
		p <- p + theme(axis.text.y=element_text(angle=${ytics_angle}, 
			hjust=${hjust}, vjust=${vjust}))
		}
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

if (! $quiet){
	print("Begin plotting.")
}


xtics_pos <- ${xtics_pos}
xtics_value <- ${xtics_value}

if(length(xtics_pos) > 1){
	if(length(xtics_value) <= 1){
		xtics_value <- xtics_pos
	}
	p <- p + scale_x_discrete(breaks=xtics_pos, labels=xtics_value)
}

#p <- p + theme(text=element_text(family="Arial", size=${fontsize}))
p <- p + theme(text=element_text(size=${fontsize}))


if ("${ext}" == "pdf") {
	ggsave(p, filename="${file}${mid}.${ext}", dpi=$res, width=$uwid,
	height=$vhig, units=c("cm"), colormodel="${colormodel}")
} else {
	ggsave(p, filename="${file}${mid}.${ext}", dpi=$res, width=$uwid,
	height=$vhig, units=c("cm"))
}

#ggsave(p, filename="${file}${mid}.${ext}", dpi=$res, width=$uwid,
#height=$vhig, units=c("cm"), colormodel="${colormodel}")

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
