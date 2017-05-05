### s-plot
=====
A simple plot library based on `bash`, `R` mainly `ggplot2` to make
the plot easily and flexibly.

This lists the basic information for using [`s-plot`](https://github.com/Tong-Chen/Plot/blob/master/s-plot).

#### Currently supported plots

Please type `s-plot` in command line directly to have the latest list.

```
#### Bars
${filename} barPlot
${filename} horizontalBar
${filename} multiBar
${filename} colorBar

#### Lines
${filename} lines

#### Dots
${filename} pca
${filename} scatterplot
${filename} scatterplot2
${filename} scatterplotColor
${filename} scatterplotContour
${filename} scatterplotLotsData
${filename} scatterplotMatrix
${filename} scatterplotDoubleVariable
${filename} contourPlot

#### Distribution
${filename} areaplot
${filename} boxplot
${filename} densityPlot
${filename} densityHistPlot
${filename} histogram

#### Cluster
${filename} hcluster_gg (latest)
${filename} hcluster
${filename} hclust (depleted)

#### Heatmap
${filename} heatmapS
${filename} heatmapM
${filename} heatmap.2
${filename} pheatmap
${filename} pretteyHeatmap

#### Others
${filename} volcano
${filename} vennDiagram
${filename} upsetView
```

#### Basic test data set

Here lists the general information of `diamonds` dataset that comes packaged with `ggplot2`. 

This dataset contains ~50,000 entries. Each row is an individual diamond, and some of the variables of interest include the weight of the diamond in carats, color, clarity, and its price. 

One can get, save and view the dataset using below commands. Or download data set from 

* [diamond.extract.matrix](https://github.com/Tong-Chen/Plot/blob/master/diamond.extract.matrix)
* [diamond.extract.matrix.melt](https://github.com/Tong-Chen/Plot/blob/master/diamond.extract.matrix.melt)

```r
> library(ggplot2)
> data(diamonds)

> head(diamonds)
  carat       cut color clarity depth table price    x    y    z
1  0.23     Ideal     E     SI2  61.5    55   326 3.95 3.98 2.43
2  0.21   Premium     E     SI1  59.8    61   326 3.89 3.84 2.31
3  0.23      Good     E     VS1  56.9    65   327 4.05 4.07 2.31
4  0.29   Premium     I     VS2  62.4    58   334 4.20 4.23 2.63
5  0.31      Good     J     SI2  63.3    58   335 4.34 4.35 2.75
6  0.24 Very Good     J    VVS2  62.8    57   336 3.94 3.96 2.48

> summary(diamonds)
     carat               cut        color        clarity          depth      
 Min.   :0.2000   Fair     : 1610   D: 6775   SI1    :13065   Min.   :43.00  
 1st Qu.:0.4000   Good     : 4906   E: 9797   VS2    :12258   1st Qu.:61.00  
 Median :0.7000   Very Good:12082   F: 9542   SI2    : 9194   Median :61.80  
 Mean   :0.7979   Premium  :13791   G:11292   VS1    : 8171   Mean   :61.75  
 3rd Qu.:1.0400   Ideal    :21551   H: 8304   VVS2   : 5066   3rd Qu.:62.50  
 Max.   :5.0100                     I: 5422   VVS1   : 3655   Max.   :79.00  
                                    J: 2808   (Other): 2531                  
     table           price             x                y         
 Min.   :43.00   Min.   :  326   Min.   : 0.000   Min.   : 0.000  
 1st Qu.:56.00   1st Qu.:  950   1st Qu.: 4.710   1st Qu.: 4.720  
 Median :57.00   Median : 2401   Median : 5.700   Median : 5.710  
 Mean   :57.46   Mean   : 3933   Mean   : 5.731   Mean   : 5.735  
 3rd Qu.:59.00   3rd Qu.: 5324   3rd Qu.: 6.540   3rd Qu.: 6.540  
 Max.   :95.00   Max.   :18823   Max.   :10.740   Max.   :58.900  
                                                                  
       z         
 Min.   : 0.000  
 1st Qu.: 2.910  
 Median : 3.530  
 Mean   : 3.539  
 3rd Qu.: 4.040  
 Max.   :31.800  
                 
#col.names=NA can generate an empty string to represent the name of first column
> write.table(diamonds, file="diamond.matrix",sep="\t", col.names=NA, row.names=T, quote=F)

#melt data set
> library(reshape2)

#Default all non-numerical column will be used as id variables
#melt will group each data value into combinations of factor variable or categorial variable.
> data_m <- melt(diamonds)
Using cut, color, clarity as id variables

> head(data_m)
        cut color clarity variable value
1     Ideal     E     SI2    carat  0.23
2   Premium     E     SI1    carat  0.21
3      Good     E     VS1    carat  0.23
4   Premium     I     VS2    carat  0.29
5      Good     J     SI2    carat  0.31
6 Very Good     J    VVS2    carat  0.24

# Extract four columns from full data sets
> diamonds_extract <- diamonds[c(1,2,3,7)]
> diamonds_extract$price <- diamonds_extract$price / 1000
> head(diamonds_extract)
  carat       cut color price
1  0.23     Ideal     E 0.326
2  0.21   Premium     E 0.326
3  0.23      Good     E 0.327
4  0.29   Premium     I 0.334
5  0.31      Good     J 0.335
6  0.24 Very Good     J 0.336
> write.table(diamonds_extract, file="diamond.extract.matrix",sep="\t", col.names=NA, row.names=T, quote=F)

> diamonds_extract_melt <- melt(diamonds_extract)
Using cut, color as id variables
> head(diamonds_extract_melt)
        cut color variable value
1     Ideal     E    carat  0.23
2   Premium     E    carat  0.21
3      Good     E    carat  0.23
4   Premium     I    carat  0.29
5      Good     J    carat  0.31
6 Very Good     J    carat  0.24

> tail(diamonds_extract_melt)
             cut color variable value
107875   Premium     D    price 2.757
107876     Ideal     D    price 2.757
107877      Good     D    price 2.757
107878 Very Good     D    price 2.757
107879   Premium     H    price 2.757
107880     Ideal     D    price 2.757

> write.table(diamonds_extract_melt, file="diamond.extract.matrix.melt",sep="\t", row.names=F, quote=F)
```

#### Basic layouts and themes

* Legend position

  Defult, the legend is posited at the right of pictures. One can give `top` to `-p` to put the legend above pictures. Other accepted strings to `-p` is `bottom`,`left`,`right`, or `c(0.008,0.8)`. The two element numerical vactor indicats the reltaive position of legend in pictures. 0.008 means position relative y-axis and 0.8 means position relative to x-axis. Specially, `c(1,1)` put legends at top-right.

* Width, Height, Resolution, type of output pictures

  Default, width is `20 cm`, one can give `number` to `-w` to change it. Height is `12 cm`, give `number` to `-u` to change height. Give `number` to `-r` to alter resolution instead of using `300` as default.

  8 picture formats are supported, `eps/ps`, `tex` (pictex), `pdf`, `jpeg`, `tiff`, `bmp`, `svg` and `wmf`, with `png` as default. Give any mentioned string to `-E` to change output format.

* Title, xlab, ylab of picture

  One can set title, xlab, ylab with `-t`, `-x`, `-y`.

* Install modules

  Give `TRUE` to `-i` to install required modules for the first time. (`i` is shorted for `install`)

  Give `FALSE` to `-e` if you only want to get the R scripts instead of running them. (`e` is shorted for `execute`)

Ref:
<http://blog.genesino.com/2013/01/test-data-sets/>
