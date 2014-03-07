#!/bin/bash

#set -x

usage()
{
cat <<EOF
${txtcyn}
Usage:

$0 options${txtrst}

${bldblu}Function${txtrst}:

This software is designed to simply the process of plotting and help
researchers focus more on data rather than technology.

Currently, the following types of plot are supported.

#### Bars
$0 barPlot
$0 horizontalBar
$0 multiBarNew

#### Lines
$0 lines
$0 lines.2

#### Dots
$0 scatterplot
$0 scatterplotColor
$0 scatterplotContour
$0 scatterplotLotsData
$0 scatterplotMatrix
$0 contourPlot (unfinished)

#### Distribution
$0 areaplot
$0 boxplot
$0 densityPlot
$0 densityHistPlot
$0 histogram
$0 histogram.2

#### Cluster
$0 hcluster
$0 hclust

#### Heatmap
$0 heatmapS
$0 heatmapM
$0 heatmap.2

#### Others
$0 volcano
$0 vennDiagram

EOF
}

if test $# -lt 1; then
	usage
	exit 1
fi

`dirname $0`/$1.sh


