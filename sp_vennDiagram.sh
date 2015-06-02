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
Gene Sample
g1	h3k27ac
g2	h3k27ac
a1	h3k27ac
a3	h3k27ac
b4	h3k27ac
g1	ctcf
h1	ctcf
a3	ctcf
b1	ctcf
b2	ctcf
g2	ctcf
-------------------------------------------------------------

${txtbld}OPTIONS${txtrst}:
	-f	Data file (without header line, the first column is the
 		name of genes or otehr things you want to compare, the second
		column is sample name, tab seperated)
		${bldred}[NECESSARY, the type of venn depends on ]${txtrst}
	-a	The name for label1.
		${bldred}[Necessary, one string in your second column,
		ordered. ]${txtrst}
	-b	The name for label1.
		${bldred}[Necessary, one string in your second column,
		ordered. A parameter to -b is enough for 2-way venn.]${txtrst}
	-c	The name for label1.
		${bldred}[Necessary, one string in your second column,
		ordered. A parameter to -c is enough for 3-way venn.]${txtrst}
	-d	The name for label1.
		${bldred}[Necessary, one string in your second column],
		ordered. A parameter to -d is enough for 4-way venn.]${txtrst}
	-C	Color for each area.
		[${txtred}Ususlly the number of colors should
		be equal to the number of labels. 
		If you manually set colors for 4-way
		venn diagram, the first color will be given to the
		leftmost set, the second will be given to the rightmost
		set, the third will be given to second leftmost and the forth 
		will be given to the second rightmost. You may want to change
		the color yourself.
		"'red','green','pink','blue','cyan','green','yellow'" or
		"rgb(255/255,0/255,0/255),rgb(255/255,0/255,255/255),rgb(0/255,0/255,255/255),
		rgb(0/255,255/255,255/255),rgb(0/255,255/255,0/255),rgb(255/255,255/255,0/255)"
		${txtrst}]
	-w	The width of output picture.[${txtred}Default 10${txtrst}]
	-u	The height of output picture.[${txtred}Default 10${txtrst}] 
	-E	The type of output figures.[${txtred}Default pdf, accept
		eps/ps, tex (pictex), png, jpeg, tiff, bmp, svg and
		wmf [Only png, eps, png(recommend if you want eps) is available, others are unuseable]${txtrst}]
	-r	The resolution of output picture.[${txtred}Default 300 ppi${txtrst}]
	-e	Execute or not[${bldred}Default TRUE${txtrst}]
	-i	Install depended packages[${bldred}Default FALSE${txtrst}]
EOF
}

file=
label1="CHENTONG"
label2="CHENTONG"
label3="CHENTONG"
label4="CHENTONG"
execute='TRUE'
ist='FALSE'
uwid=20
vhig=20
res=300
ext='pdf'
line_size=1
color_v='"cornflowerblue", "green", "yellow", "darkorchid1"'

while getopts "hf:a:b:c:d:C:w:u:r:e:E:i:" OPTION
do
	case $OPTION in
		h)
			usage
			exit 1
			;;
		f)
			file=$OPTARG
			;;
		a)
			label1=$OPTARG
			;;
		b)
			label2=$OPTARG
			;;
		c)
			label3=$OPTARG
			;;
		d)
			label4=$OPTARG
			;;
		C)
			color_v=$OPTARG
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

mid='.vennDiagram'

cat <<END >${file}${mid}.r

if ($ist){
	install.packages("VennDiagram", repo="http://cran.us.r-project.org")
	#install.packages("reshape2", repo="http://cran.us.r-project.org")
	#install.packages("grid", repo="http://cran.us.r-project.org")
}
library(VennDiagram)

data <- read.table(file="$file", sep="\t")

num <- 0

if("${label1}" != "CHENTONG"){
	$label1 <- data[grepl("\\\\<${label1}\\\\>",data[,2]),1]
	num <- num + 1
}

if("${label2}" != "CHENTONG"){
	$label2 <- data[grepl("\\\\<${label2}\\\\>",data[,2]),1]
	num <- num + 1
}

if("${label3}" != "CHENTONG"){
	$label3 <- data[grepl("\\\\<${label3}\\\\>",data[,2]),1]
	num <- num + 1
}

if("${label4}" != "CHENTONG"){
	$label4 <- data[grepl("\\\\<${label4}\\\\>",data[,2]),1]
	num <- num + 1
}

color_v <- c(${color_v})[1:num]

if(num == 4){
	p <- venn.diagram( 
		x = list($label1=$label1, $label4=$label4, $label2=$label2,
		$label3=$label3),
		filename = NULL, col = "black", lwd = 1, 
		fill = color_v,
		alpha = 0.50,
		label.col = c("orange", "white", "darkorchid4", "white", "white", "white", "white", "white", "darkblue", "white", "white", "white", "white", "darkgreen", "white"),
		cex = 2.5, fontfamily = "Helvetica",
		cat.col = color_v,cat.cex = 2.5,
		cat.fontfamily = "Helvetica"
	)
} else if (num==3) {
	p <- venn.diagram( 
		x = list($label1=$label1, $label2=$label2, $label3=$label3),
		filename = NULL, col = "transparent", 
		fill = color_v,
		alpha = 0.50,
		label.col = c("white", "white", "white", "white", "white", "white", "white"),
		cex = 2.5, fontfamily = "Helvetica", cat.default.pos="text",
		cat.pos=0,  
		cat.col = color_v,cat.cex = 2.5,cat.fontfamily = "Helvetica"
	)
} else if (num==2) {
	p <- venn.diagram( 
		x = list($label1=$label1, $label2=$label2),
		filename = NULL, col = "transparent", 
		fill = color_v,
		alpha = 0.50,
		label.col = c("white"),
		cex = 2.5, fontfamily = "Helvetica", cat.default.pos="text",
		cat.pos=0,  
		cat.col = color_v,cat.cex = 2.5,cat.fontfamily = "Helvetica"
	)
}

#cat.col = c("darkblue", "darkgreen", "orange", "darkorchid4"),

if ("${ext}" == "png") {
	png(filename="${file}${mid}.png", width=$uwid, height=$vhig,
	res=$res, units="cm")
} else if ("${ext}" == "eps") {
	postscript(file="${file}${mid}.eps", onefile=FALSE, horizontal=FALSE, 
	paper="special", width=10, height = 12, pointsize=10)
} else if ("${ext}" == "pdf") {
	pdf(file="${file}${mid}.pdf", onefile=FALSE, 
	paper="special")
} else {
	print("This format is currently unsupported. Please check the file <Rplots.pdf> in current dirsctory.")
}

grid.draw(p)

dev.off()

#ggsave(p, filename="${file}${mid}.${ext}", dpi=$res, width=$uwid,
#height=$vhig, units=c("cm"))

#postscript(file="${file}${mid}.eps", onefile=FALSE, horizontal=FALSE, 
#paper="special", width=10, height = 12, pointsize=10)
#dev.off()
END

if [ "$execute" == "TRUE" ]; then
	Rscript ${file}${mid}.r
if [ "$?" == "0" ]; then /bin/rm -f ${file}${mid}.r; fi
fi

