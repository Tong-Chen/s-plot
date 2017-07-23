# s_plot的数据格式说明
---
## sp_pheatmap.sh
### Matrix file
> heatmap_data.xls

| Name  |  T0_1  |  T0_2  |  T0_3  |  T4_1  |  T4_2 |
|:-------|:------:|:------:|:------:|:------:|:-----:|
|TR19267|c0_g1|CYP703A2  |  1.431  |  0.77  |  1.309  |  1.247  |  0.485 |
|TR19612|c1_g3|CYP707A1  |  0.72  |  0.161  |  0.301  |  2.457  |  2.794 |
|TR60337|c4_g9|CYP707A1  |  0.056  |  0.09  |  0.038  |  7.643  |  15.379 |
|TR19612|c0_g1|CYP707A3  |  2.011  |  0.689  |  1.29  |  0  |  0 |
|TR35761|c0_g1|CYP707A4  |  1.946  |  1.575  |  1.892  |  1.019  |  0.999 |
|TR58054|c0_g2|CYP707A4  |  12.338  |  10.016  |  9.387  |  0.782  |  0.563 |
|TR14082|c7_g4|CYP707A4  |  10.505  |  8.709  |  7.212  |  4.395   | 6.103 |
|TR60509|c0_g1|CYP707A7  |  3.527  |  3.348  |  2.128   | 3.257  |  2.338 |
|TR26914|c0_g1|CYP710A1  |  1.899  |  1.54  |  0.998   | 0.255  |  0.427 |


### Row annorarion file
> heatmap_row_anno.xls

> 1. At least two columns
> 2. The first column should be the same as the first column in matrix (order does not matter)

| Name |  Clan  |  Family |
|:------|:------:|:-------:|
| TR19267|c0_g1|CYP703A2  |  CYP71  |  CYP703|
| TR19612|c1_g3|CYP707A1  |  CYP85  | CYP707|
| TR60337|c4_g9|CYP707A1  |  CYP85  |  CYP707|
| TR19612|c0_g1|CYP707A3  |  CYP85  |  CYP707|
| TR35761|c0_g1|CYP707A4  |  CYP85  |  CYP707|
| TR58054|c0_g2|CYP707A4  |  CYP85  |  CYP707|
| TR14082|c7_g4|CYP707A4  |  CYP85  |  CYP707|
| TR60509|c0_g1|CYP707A7  |  CYP85  |  CYP707|
| TR26914|c0_g1|CYP710A1  |  CYP710  |  CYP710|

### Column annorarion file
> heatmap_col_anno.xls

> 1. At least two columns
> 2. The first column should be the same as the first row in matrix (order does not matter)

| Name | Sample |
|:------|:------:|
| T0_1 | T0|
| T0_2 | T0|
| T0_3 | T0|
| T4_1 | T4|
| T4_2 | T4|

## sp_boxplot.sh
> This script is used to do boxplot using ggplot2.

> For file using "Set" column, you can use boxplot.onefile.sh -f file -a Set
 
> fileformat when -m is true

> Default we use string "value" and "variable" to represent the data

> column and sub-class column. If you have other strings as column names, please give them to -d and -F.

> The "Set" column is optional.

> If you do have several groups, they can put at the "Set" column with "Set" or other string as labels. The label should be given to parameter -a.
> Actually this format is the melted result of last format.

### Matrix
> fileformat for -f (suitable for data extracted from one sample, the
number of columns is unlimited. Column 'Set' is not necessary unless
you have multiple groups)

> For file using "Set" column, you can use
boxplot.onefile.sh -f file -a Set

#### Matrix1
> boxplot.normal.data

| Name|2cell_1| 2cell_2 | 2cell_3 | 2cell_4 | 2cell_5 | 2cell_6 | 4cell_1 | 4cell_2 | 4cell_3 | 4cell_4 | 4cell_5 | 4cell_6 | zygote_1 | zygote_2 | zygote_3 | zygote_4 | zygote_5 | zygote_6|
|:--|:---:|:---:|:----:|:---:|:----:|:----:|:-----:|:-----:|:-----:|:-----:|:-----:|:-----:|:-----:|:-----:|:-----:|:-----:|:-----:|:----:|
|A | 8 | 13 | 14 | 9 | 19 | 12 | 3.2 | 5.2 | 5.6 | 3.6 | 7.6 | 4.8 | 0.8 | 1.3 | 1.4 | 0.9 | 1.9 | 1.2|
|B | 8 | 13 | 14 | 9 | 19 | 12 | 3.2 | 5.2 | 5.6 | 3.6 | 7.6 | 4.8 | 0.8 | 1.3 | 1.4 | 0.9 | 1.9 | 1.2|
|C | 8 | 13 | 14 | 9 | 19 | 12 | 3.2 | 5.2 | 5.6 | 3.6 | 7.6 | 4.8 | 0.8 | 1.3 | 1.4 | 0.9 | 1.9 | 1.2|
|D | 8 | 13 | 14 | 9 | 19 | 12 | 3.2 | 5.2 | 5.6 | 3.6 | 7.6 | 4.8 | 0.8 | 1.3 | 1.4 | 0.9 | 1.9 | 1.2|
|E | 8 | 13 | 14 | 9 | 19 | 12 | 3.2 | 5.2 | 5.6 | 3.6 | 7.6 | 4.8 | 0.8 | 1.3 | 1.4 | 0.9 | 1.9 | 1.2|
|F | 8 | 13 | 14 | 9 | 19 | 12 | 3.2 | 5.2 | 5.6 | 3.6 | 7.6 | 4.8 | 0.8 | 1.3 | 1.4 | 0.9 | 1.9 | 1.2|
|G | 8 | 13 | 14 | 9 | 19 | 12 | 3.2 | 5.2 | 5.6 | 3.6 | 7.6 | 4.8 | 0.8 | 1.3 | 1.4 | 0.9 | 1.9 | 1.2|
|H | 8 | 13 | 14 | 9 | 19 | 12 | 3.2 | 5.2 | 5.6 | 3.6 | 7.6 | 4.8 | 0.8 | 1.3 | 1.4 | 0.9 | 1.9 | 1.2|
|I | 8 | 13 | 14 | 9 | 19 | 12 | 3.2 | 5.2 | 5.6 | 3.6 | 7.6 | 4.8 | 0.8 | 1.3 | 1.4 | 0.9 | 1.9 | 1.2|

#### Matrix2
> boxplot.matrix2.data

|Gene | hmC | expr | Set|
|:-----|:---:|:--:|:--:|
|NM_001003918_26622 | 0 | 83.1269257376101 | TP16|
|NM_001011535_3260 | 0 | 0 | TP16|
|NM_001012640_14264 | 0 | 0 | TP16|
|NM_001012640_30427 | 0 | 0 | TP16|
|NM_001003918_2662217393_30486 | 0 | 0 | TP16|
|NM_001017393_30504 | 0 | 0 | TP16|
|NM_001025241_30464 | 0 | 0 | TP16|
|NM_001017393_30504001025241_30513 | 0 | 0 | TP16|

### sampleGroupFile 
> sampleGroup

> 1. TAB separated, first column corresponds to first row of matrix
> 2. Group should be gave to <-F>

|Sample | G|
|:------|:--:|
|zygote_1 | zygote|
|zygote_2 | zygote|
|zygote_3 | zygote|
|zygote_4 | zygote|
|zygote_5 | zygote|
|zygote_6 | zygote|
|2cell_1 | 2cell|
|2cell_2 | 2cell|
|2cell_3 | 2cell|
|2cell_4 | 2cell|
|2cell_5 | 2cell|
|2cell_6 | 2cell|
|4cell_1 | 4cell|
|4cell_2 | 4cell|
|4cell_3 | 4cell|
|4cell_4 | 4cell|
|4cell_5 | 4cell|
|4cell_6 | 4cell|

### Matrix_melted
> boxplot.melt.data

|Gene | Sample | Group | Expr|
|:--- |:------:|:-----:|:---:|
|A | zygote_1 | zygote | 0.8|
|A | zygote_2 | zygote | 1.3|
|A | zygote_3 | zygote | 1.4|
|A | zygote_4 | zygote | 0.9|
|A | zygote_5 | zygote | 1.9|
|A | zygote_6 | zygote | 1.2|
|A | 2cell_1 | 2cell | 8|
|A | 2cell_2 | 2cell | 13|
|A | 2cell_3 | 2cell | 14|
|A | 2cell_4 | 2cell | 9|
|A | 2cell_5 | 2cell | 19|
|A | 2cell_6 | 2cell | 12|
|A | 4cell_1 | 4cell | 3.2|
|A | 4cell_2 | 4cell | 5.2|
|A | 4cell_3 | 4cell | 5.6|
|A | 4cell_4 | 4cell | 3.6|
|A | 4cell_5 | 4cell | 7.6|
|A | 4cell_6 | 4cell | 4.8|