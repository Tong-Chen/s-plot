#使用说明:
    ## 外层引号与内层引号不能相同
    ## 凡参数值中包括了空格，括号，逗号等都用引号括起来作为一个整体
    ##程序自动计算图形长宽

# 实例:
## 绘制每个样品的表达矩阵
s-plot boxplot -f boxplot.normal.data -P none -b 45 -V TRUE

## 绘制单个基因的小提琴图加抖动图(设定坐标标签顺序,图例颜色)
s-plot boxplot -f boxplot.normal.data -q A -Q sampleGroup -a Group -V TRUE -L "'zygote','2cell','4cell'" -c TRUE -C "'red', 'pink', 'blue'" -x A_sample -y expr

## 使用melted矩阵默认参数绘制小提琴图+扰动图
s-plot boxplot -f boxplot.melt.data -m TRUE -d Expr -a Group  -W TRUE
## 扰动图
s-plot boxplot -f boxplot.melt.data -m TRUE -d Expr -a Group  -j TRUE

# 使用主题
s-plot boxplot -f boxplot.melt.data -m TRUE -d Expr -F Rep -a Group -T theme_cin

## 旋转坐标轴
s-plot boxplot -f boxplot.melt.data -m TRUE -d Expr -a Group -J TRUE -R TRUE

##分面
s-plot boxplot -f boxplot.melt.data -m TRUE -d Expr -a Group -b 45 -G Rep -M 2 -N 2
