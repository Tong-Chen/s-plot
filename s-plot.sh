#!/bin/bash

#set -x

filename=`basename $0`

usage()
{
cat <<EOF
${txtcyn}
Usage:

${filename} options${txtrst}

${bldblu}Function${txtrst}:

This software is designed to simply the process of plotting and help
researchers focus more on data rather than technology.

Currently, the following types of plot are supported.

#### Bars
${filename} barPlot
${filename} horizontalBar
${filename} multiBarNew
${filename} colorBar

#### Lines
${filename} lines

#### Dots
${filename} scatterplot
${filename} scatterplotColor
${filename} scatterplotContour
${filename} scatterplotLotsData
${filename} scatterplotMatrix
${filename} sp_scatterplotDoubleVariable
${filename} contourPlot

#### Distribution
${filename} areaplot
${filename} boxplot
${filename} densityPlot
${filename} densityHistPlot
${filename} histogram

#### Cluster
${filename} hcluster
${filename} hclust (depleted)

#### Heatmap
${filename} heatmapS
${filename} heatmapM
${filename} heatmap.2

#### Others
${filename} volcano
${filename} vennDiagram

EOF
}

if test $# -lt 1; then
	usage
	exit 1
fi

program="sp_"$1".sh"
type ${program} >/dev/null 2>&1
error=$?
if test $error != 0; then
	usage
	echo "**Please check the program name input**"
	exit 1
else
	shift
	${program} "$@"
fi

