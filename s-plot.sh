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

#### Lines
${filename} lines
${filename} lines.2

#### Dots
${filename} scatterplot
${filename} scatterplotColor
${filename} scatterplotContour
${filename} scatterplotLotsData
${filename} scatterplotMatrix
${filename} contourPlot (unfinished)

#### Distribution
${filename} areaplot
${filename} boxplot
${filename} densityPlot
${filename} densityHistPlot
${filename} histogram
${filename} histogram.2

#### Cluster
${filename} hcluster
${filename} hclust

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

sp_$1.sh


