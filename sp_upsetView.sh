#!/bin/bash

#set -x
set -e
set -u

usage()
{
cat <<EOF >&2
${txtcyn}
Usage:

$0 options${txtrst}

${bldblu}Function${txtrst}:

This script is used to do another type of VennDiagram using R package <UpSetR>.

Input file is a matrix:

(First row would be treated as header line. First column is just a normal column (but needed). 0 represents the sample does not contain the genes in row. 1 represents the containing relationship)

ID	Samp1	Samp2	Samp3	Samp4	Samp5
G1	1	0	1	0	1
G2	0	0	1	1	1
G3	1	1	1	0	1
G4	1	1	1	0	0
G5	0	1	0	1	1
G6	1	0	1	0	0

The output contains two barplots, horizontal bar represents the number of genes in each sample, which is the sum of all 1 in sample column. Vertical bar represents the number of sample specific and common genes as indicated by linking vertical lines and points (just as the overlapping regions of venndiagram).



${txtbld}OPTIONS${txtrst}:
	-f	Data matrix file ${bldred}[NECESSARY]${txtrst}
	-u	Plot width ${bldred}[Default 14]${txtrst} 
	-v	Plot height ${bldred}[Default 6]${txtrst} 
	-p	Point size ${bldred}[Default 8]${txtrst} 
	-i	Install required packages. 
		${bldred}[Default FALSE]${txtrst} 
EOF
}

file=
header='TRUE'
install='FALSE'
width=14
height=6
pointsize=8

while getopts "hf:i:u:v:p:" OPTION
do
	case $OPTION in
		h)
			usage
			exit 1
			;;
		f)
			file=$OPTARG
			;;
		u)
			width=$OPTARG
			;;
		v)
			height=$OPTARG
			;;
		p)
			pointsize=$OPTARG
			;;
		i)
			install=$OPTARG
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

mid=".upsetV"

cat <<END >${file}${mid}.r

if ($install){
	install.packages("UpSetR", repo="http://cran.us.r-project.org")
}

library(UpSetR)

matrix = read.table("${file}", header=T, row.names=NULL, sep="\t")

nsets = dim(matrix)[2]-1

pdf(file="${file}${mid}.pdf", onefile=FALSE, paper="special", width=${width}, height=${height}, bg="white", pointsize=${pointsize})

upset(matrix, nsets=nsets, sets.bar.color = "#56B4E9", order.by = "freq", empty.intersections = "on")

dev.off()

END

Rscript ${file}${mid}.r
