#!/bin/bash

#set -x

usage()
{
cat <<EOF
${txtcyn}

***CREATED BY Chen Tong (chentong_biology@163.com)***
***FURTHER MODIFY BY Lin Dechun (lindechun@genomics.cn)***
## new: boxplot median line; beautiful plot; auto adapt canvas(width and height); modify code logic; new functions

Usage:

$0 options${txtrst}

${bldblu}Function${txtrst}:

This script is used to do boxplot using ggplot2.

${txtbld}OPTIONS${txtrst}:
	-f	Data file (with header line, the first row is the
 		colname, tab seperated. Multiple formats are allowed and described above)
		${bldred}[NECESSARY]${txtrst}
	-m	When true, it will skip preprocess. But the format must be
		the same as listed before (Matrix_melted).
		${bldred}[Default FALSE, accept TRUE]${txtrst}
	-d	The column represents the digital values, such as Expr.
		${bldred}[Default "value" represents the column named "value".
		This parameter can only be set when -m is TRUE.]${txtrst}
	-F	The column represents the variable information, meaning legend_variable.
		If no-subclass of X-variavle, this will be used X-axis variable(-a).
		${bldred}[Default "variable" represents the column named "variable". 
		This parameter can only be set when -m is TRUE.]${txtrst}
	-I	Other columns you want to treat as ID variable columns except
		the one given to -a. Not used when <-m TRUE> or -q be seted.
		${bldred}[Default empty string, accept comma separated strings
		like "'Id1','Id2','Id3'" or single string "id1"]${txtrst}
	-a	Name for x-axis variable
		[${txtred}Default variable, which is an inner name, suitable 
		for data without 'Set' column. For the given example, 
		'Group' which represents groups of each gene should be 
		supplied to this parameter.
		This parameter must set when -q is not FALSE or -m is TRUE.${txtrst}]
	-b	Rotation angle for x-axis value(anti clockwise)
		${bldred}[Default 0]${txtrst}
	-R	Rotate the plot from vertical to horizontal. 
		Usefull for plots with many values or very long labels at X-axis.
		${bldred}[Default FALSE]${txtrst}
	-l	Levels for legend variable
		[${txtred}Default data order,accept a string like
		"'TP16','TP22','TP23'" ***for <variable> column***.
	   	${txtrst}]
	-q	Giving one gene ID to do boxplot specifically for this gene.
		${bldred}[Default FALSE, accept a string]${txtrst}
	-Q	Giving a sampleGroup file with format specified above to
   		tell the group information for each sample.	
		When <-Q> is given, <-F> and <-a> should be one of the column 
		names of sampleGrp file.
		${bldred}[Default FALSE, accept a file name]${txtrst}
	-D	Self-define intervals for legend variable when legend is
		continuous numbers. Accept either a
		numeric vector of two or more cut points or a single number
		(greater than or equal to 2) giving the number of intervals
		into what 'x' is to be cut. This has higher priority than -l.
		[10 will generate 10 intervals or 
		"c(-1, 0, 1, 2, 5, 10)" will generate (-1,0],(0,1]...(5,10]]	
	-P	[Uppercase P] Legend position[${txtred}Default right. Accept
		top,bottom,left,none, or c(0.08,0.8) (relative to left-bottom).${txtrst}]
	-L	Levels for x-axis variable
		[${txtred}Default data order,accept a string like
		"'g','a','j','x','s','c','o','u'" ***for <Set> column***.
	   	${txtrst}]
	-B	Self-define intervals for x-axis variable. Accept either a
		numeric vector of two or more cut points or a single number
		(greater than or equal to 2) giving the number of intervals
		into what 'x' is to be cut. This has higher priority than -L.
		[10 will generate 10 intervals or 
		"c(-1, 0, 1, 2, 5, 10)" will generate (-1,0],(0,1]...(5,10]]	
	-n	Using notch (sand clock shape) or not.${txtred}[Default FALSE]${txtrst}
	-V	Do violin plot instead of boxplot.${txtred}[Default FALSE]${txtrst}
	-W	Do violin plot overlay with jitter.${txtred}[Default FALSE]${txtrst}
	-j	Do jitter plot instead of boxplot.${txtred}[Default FALSE]${txtrst}
	-J	Do boxplot plot overlay with jitter.${txtred}[Default FALSE]${txtrst}
	-A	The value given to scale for violin plot.
		if "area", all violins have the same area (before trimming the tails). 
		If "count", areas are scaled proportionally to the number of observations. 
		If "width", all violins have the same maximum width. 
		'equal' is also accepted.
		${txtred}[Default 'width']${txtrst}
	-G	Wrap plots by given column. This is used to put multiple plot
		in one picture. Used when -m is TRUE, normally a string <set>
		should be suitable for this parameter.
	-g	The levels of wrapping to set the order of each group.
		${txtred}Normally the unique value of the column given to B in
		a format like <"'a','b','c','d'">.${txtrst}
	-M	The number of rows one wants when -G is used. Default NULL.
		${txtred}[one of -M and -N is enough]${txtrst}
	-N	The number of columns one wants when -G is used. Default NULL.
		${txtred}[one of -M and -N is enough]${txtrst}
	-k	Paramter for scales for facet.
		[${txtred}Optional, only used when -B is given. Default each 
		inner graph use same scale [x,y range]. 
		'free' (variable x, y ranges for each sub-plot),
		'free_x' (variable x ranges for each sub-plot),'free_y' 
		is accepted. ${txtrst}]
	-t	Title of picture[${txtred}Default empty title${txtrst}]
	-x	xlab of picture[${txtred}Default name for -a${txtrst}]
	-y	ylab of picture[${txtred}Default name for -d${txtrst}]
	-s	Scale y axis
		[${txtred}Default null. Accept TRUE.
		Also if the supplied number after -S is not 0, this
		parameter will be set to TRUE${txtrst}]
	-v	If scale is TRUE, give the following
		scale_y_log10()[default], coord_trans(y="log10"), 
		scale_y_continuous(trans=log2_trans()), coord_trans(y="log2"), 
	   	or other legal command for ggplot2). should use '***'${txtrst}]
	-o	Exclude outliers.
		[${txtred}Exclude outliers or not, default FALSE means not.${txtrst}]
	-O	The scales for you want to zoom in to exclude outliers.
		[${txtred}Default 1.05. No recommend to change unless you know
		what you are doing.${txtrst}]
	-S	A number to add if scale is used.
		[${txtred}Default 0. If a non-zero number is given, -s is
		TRUE.${txtrst}]	
	-c	Manually set colors for each box.[${txtred}Default FALSE,
		meaning using ggplot2 default.${txtrst}]
	-C	Color for each box.[${txtred}When -c is TRUE, str in given
		format must be supplied, ususlly the number of colors should
		be equal to the number of lines.
		"'red','pink','blue','cyan','green','yellow'" or
		"rgb(255/255,0/255,0/255),rgb(255/255,0/255,255/255),rgb(0/255,0/255,255/255),
		rgb(0/255,255/255,255/255),rgb(0/255,255/255,0/255),rgb(255/255,255/255,0/255)"
		${txtrst}]
	-p	[Lowercase p] Other legal R codes for gggplot2 will be given here.
		[${txtres}Begin with '+' ${txtrst}]
	-w	The width of output picture.[${txtred}Default auto calculate${txtrst}]
	-u	The height of output picture.[${txtred}Default auto calculate${txtrst}]
	-K	The width of sub-box or sub-violin.[${txtred}Default 0.75${txtrst}]
	-r	The resolution of output picture.[${txtred}Default 300 ppi${txtrst}]
	-E	The type of output figures.[${txtred}Default pdf, accept
		eps/ps, tex (pictex), pdf, jpeg, tiff, bmp, svg and wmf)${txtrst}]
	-T	The self-definited theme for ggplot2, give the followding theme_classic2 [Default], theme_classic3, theme_cin.${txtrst}
	-z	Is there a header[${bldred}Default TRUE${txtrst}]
	-e	Execute or not[${bldred}Default TRUE${txtrst}]
	-i	Install depeneded packages[${bldred}Default FALSE${txtrst}]
EOF
}

file=
title=''
melted='FALSE'
xlab=' '
ylab=' '
xvariable=''
value='value'
variable='variable'
xtics_angle=0
xtics='TRUE'
level=""
legend_cut=""
x_level=""
x_cut=""
scaleY='FALSE'
y_add=0
scaleY_x='scale_y_log10()'
self_theme='theme_classic2'
header='TRUE'
execute='TRUE'
ist='FALSE'
uwid=''
vhig=''
sub_box=0.75
res=300
notch='FALSE'
par=''
outlier='FALSE'
out_scale=1.05
legend_pos='right'
color='FALSE'
ext='pdf'
violin='FALSE'
violin_jitter='FALSE'
jitter='FALSE'
boxplot_jitter='FALSE'
scale_violin='width'
ID_var=""
colormodel='srgb'
rotate_plot='FALSE'
facet='NoMeAnInGTh_I_n_G_s'
nrow='NULL'
ncol='NULL'
scales='fixed'
facet_level='NA'
gene='FALSE'
sampleGroup='FALSE'

while getopts "ha:A:b:B:c:C:d:D:e:E:f:F:g:G:M:N:k:K:i:I:R:j:J:l:L:m:n:o:O:p:P:q:Q:r:s:S:t:T:u:v:V:w:W:x:y:z:" OPTION
do
	case $OPTION in
		h)
			usage
			exit 1
			;;
		f)
			file=$OPTARG
			;;
		m)
			melted=$OPTARG
			;;
		a)
			variable=$OPTARG
			;;
		d)
			value=$OPTARG
			;;
		F)
			xvariable=$OPTARG
			;;
		I)
			ID_var=$OPTARG
			;;
		j)
			jitter=$OPTARG
			;;
		J)
			boxplot_jitter=$OPTARG
			;;
		b)
			xtics_angle=$OPTARG
			;;
		G)
			facet=$OPTARG
			;;
		g)
			facet_level=$OPTARG
			;;
		q)
			gene=$OPTARG
			;;
		Q)
			sampleGroup=$OPTARG
			;;
		M)
			nrow=$OPTARG
			;;
		N)
			ncol=$OPTARG
			;;
		k)
			scales=$OPTARG
			;;
		t)
			title=$OPTARG
			;;
		T)
			self_theme=$OPTARG
			;;
		x)
			xlab=$OPTARG
			;;
		l)
			level=$OPTARG
			;;
		P)
			legend_pos=$OPTARG
			;;
		B)
			x_cut=$OPTARG
			;;
		D)
			legend_cut=$OPTARG
			;;
		L)
			x_level=$OPTARG
			;;
		n)
			notch=$OPTARG
			;;
		V)
			violin=$OPTARG
			;;
		W)
			violin_jitter=$OPTARG
			;;
		A)
			scale_violin=$OPTARG
			;;
		p)
			par=$OPTARG
			;;
		y)
			ylab=$OPTARG
			;;
		w)
			uwid=$OPTARG
			;;
		u)
			vhig=$OPTARG
			;;
		R)
			rotate_plot=$OPTARG
			;;
		r)
			res=$OPTARG
			;;
		E)
			ext=$OPTARG
			;;
		o)
			outlier=$OPTARG
			;;
		O)
			out_scale=$OPTARG
			;;
		s)
			scaleY=$OPTARG
			;;
		S)
			y_add=$OPTARG
			;;
		c)
			color=$OPTARG
			;;
		C)
			color_v=$OPTARG
			;;
		v)
			scaleY_x=$OPTARG
			;;
		z)
			header=$OPTARG
			;;
		K)
			sub_box=$OPTARG
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

# mid='.boxplot'

if test "${melted}" == "FALSE" && test "${sampleGroup}" == "FALSE"; then
	if test "${value}" != "value" || test "${variable}" != "variable"; then
		value="value"
		variable="variable"
		echo "Warning, there is no need to set -d and -F for unmelted \
files. We will ignore this setting and not affect the result."
	fi
fi

if test "${melted}" == "FALSE" && test "${gene}" != "FALSE";then
	if test "${variable}" == "variable";then
		variable="Sample"
	fi
fi

if test "${melted}" == "TRUE" && test "${variable}" == "variable"; then
	echo "If '-m TRUE' be set, then -a should be set"
	exit 1
fi

if test -z "${xvariable}"; then
	xvariable=${variable}
fi

## add by lindechun
if test "${xlab}" == " ";then
	xlab=${variable}
fi

if test "${ylab}" == " ";then
	ylab=${value}
fi

b=0
plot_judge=($violin $violin_jitter $jitter $boxplot_jitter)

for i in ${plot_judge[@]}
do
    if [ $i != 'FALSE' ];then
        ((b++))
    fi
done

if [ $b -gt 1 ];then
	echo "You can only choose one of these (-V -W -j -J)"
	exit 1
fi

if [ $b -eq 0 ];then
	mid=${mid}'.boxplot'
fi

## add by lindechun

if test "${gene}" != "FALSE"; then
	value="${gene}"
fi

if test "${value}" != "value" || test "${variable}" != "variable"; then
	mid=${mid}'.'${value}_${variable}
fi

if test "${variable}" != "${xvariable}"; then
	mid=${mid}'_'${xvariable}
fi

if test "${outlier}" == "TRUE"; then
	mid=${mid}'.noOutlier'
fi

if test ${y_add} -ne 0; then
	scaleY="TRUE"
fi

#if test "${gene}" != "FALSE"; then
#	mid=${mid}".${gene}"
#fi

if test "${scaleY}" == "TRUE"; then
	mid=${mid}'.scaleY'
fi

if test "${violin}" == "TRUE"; then
	mid=${mid}'.violin'
fi

if test "${violin_jitter}" == "TRUE"; then
	mid=${mid}'.violin_jitter'
fi

if test "${jitter}" == "TRUE"; then
	mid=${mid}'.jitter'
fi

if test "${boxplot_jitter}" == "TRUE"; then
	mid=${mid}'.boxplot_jitter'
fi

if test "${facet}" != "NoMeAnInGTh_I_n_G_s"; then
	mid=${mid}'.facet_wrap'
fi

function ggplot2_configure {

cat <<END >>${file}${mid}.r

#Configure the canvas

p <- p + ${self_theme}()

#Correcting location of x-aixs label
p <- Xlable_angle_correct(p, ${xtics_angle})

#Set the position of legend
top='top'
botttom='bottom'
left='left'
right='right'
none='none'
legend_pos_par <- ${legend_pos}

p <- p + theme(legend.position=legend_pos_par)

#add additional ggplot2 supported commands

p <- p${par}

# output pictures
w_auto_temp=length(levels(data_m\$${variable}))

 w_h_auto <- Canvas_size(w_auto_temp, "${variable}", "${xvariable}", ${rotate_plot}, "${legend_pos}")
 w_auto <- w_h_auto[1]
 h_auto <- w_h_auto[2]

if ("${facet}" != "NoMeAnInGTh_I_n_G_s"){
	if ("${nrow}" != 'NULL') {
		h_auto=h_auto*${nrow}
	}
	if ("${ncol}" != 'NULL') {
		w_auto=w_auto*${ncol}
	}
	if ("${nrow}" == 'NULL' && "${ncol}" == 'NULL'){
		w_auto=w_auto*3
		h_auto=h_auto*0.7*length(levels(data_m\$${facet}))/3
	}
}


# Control margin of plot by exist status of title, xlab, ylab
if ("$title" == "") {
	p <- p+ theme(plot.title=element_blank())
}
if ("$xlab" == "") {
	p <- p+ theme(axis.title.x=element_blank())
}
if ("$ylab" == "") {
	p <- p+ theme(axis.title.y=element_blank())
}

## savefig
if ("$uwid" != ''){
	if (!${rotate_plot}){
		Savefig("${file}${mid}.${ext}", p, $uwid, $vhig, "$res", "${ext}")
	}else{
		Savefig("${file}${mid}.${ext}", p, $vhig, $uwid, "$res", "${ext}")
	}
}else{
	if (!${rotate_plot}){
		Savefig("${file}${mid}.${ext}", p, w_auto, h_auto, "$res", "${ext}")
	}else{
		Savefig("${file}${mid}.${ext}", p, h_auto, w_auto, "$res", "${ext}")
	}
}
END
}

cat <<END >${file}${mid}.r
source('$(cd `dirname $0`; pwd)/rFunction.R')

if ($ist){
	installp(c("ggplot2", "reshape2", "scales","ggbeeswarm","dplyr"))
}

if(${boxplot_jitter} || ${violin_jitter} || ${jitter}){
	library(ggbeeswarm)
}
# else if(${jitter}){
# 	library(ggbeeswarm)
# }

library(ggplot2)
library(reshape2)
library(scales)
library(dplyr)

##### add by lindechun

s_boxplot_median <- function(dat, more_v=TRUE){

  ## errorbar(replace median line of boxplot or violin) adapt to sub-xvariable

  errorbarWidth <- function(x){
    y<-mean(unique(x))
    dfd <- function(i,y){
      (i-y)*($sub_box/length(unique(x)))
    }
    cc<-sapply(x,dfd,y)
    return(cc)
  }
  if (more_v){
    temp1 <- mutate(dat,a1=as.integer(${variable}))
    temp1 <- mutate(temp1,a2=as.integer(${xvariable}))
    temp1\$a3 <- temp1\$a1+errorbarWidth(temp1\$a2)
    temp2 <- temp1 %>% group_by(a3) %>% summarise(median=median(${value}))
    
    ## force boxplots from geom_boxplot to constant width
    ## Ref: https://stackoverflow.com/questions/16705129/force-boxplots-from-geom-boxplot-to-constant-width

    if ("${facet}" != "NoMeAnInGTh_I_n_G_s") {
    	tab <- xtabs(~${xvariable}+${variable}+${facet},temp1)
	    tmp <- temp1[c("${variable}","${xvariable}","${value}","${facet}")]
    }else{
	    tab <- xtabs(~${xvariable}+${variable},temp1)
	    tmp <- temp1[c("${variable}","${xvariable}","${value}")]
	}

    idx <- which(tab==0,arr.ind=TRUE)
    
    if(dim(idx)[1] != 0){
      fakeLines <- apply(idx, 1, function(x){
        
        if (is.integer(dimnames(tab)[[2]])){
          fake_1 <- as.integer(dimnames(tab)[[2]][x[2]])
        }else{
          fake_1 <- dimnames(tab)[[2]][x[2]]
        }
        
        if (is.integer(dimnames(tab)[[1]])){
          fake_2 <- as.integer(dimnames(tab)[[1]][x[1]])
        }else{
          fake_2 <- dimnames(tab)[[1]][x[1]]
        }
        if ("${facet}" != "NoMeAnInGTh_I_n_G_s") {
		    if (is.integer(dimnames(tab)[[1]])){
		      fake_3 <- as.integer(dimnames(tab)[[3]][x[3]])
		    }else{
		      fake_3 <- dimnames(tab)[[3]][x[3]]
		    }
		    setNames(data.frame(fake_1,fake_2,min(temp1\$${value})-0.06*(max(temp1\$${value})-min(temp1\$${value})),fake_3),names(tmp))
		}else{
	        setNames(data.frame(fake_1,fake_2,min(temp1\$${value})-0.06*(max(temp1\$${value})-min(temp1\$${value}))),names(tmp))
	    }
      }
      )
     tmp2 <- rbind(tmp, do.call(rbind, fakeLines))
    }else{
      tmp2 <- tmp
    }

    return(list(data_m=tmp2,data_bp_median=temp2,data_m_temp=temp1))

  }else{

    temp2 <- dat %>% group_by(${variable}) %>% summarise(median=median(${value}))
    return(list(data_m=dat,data_bp_median=temp2))
  }
}


###### add by lindechun

if(! $melted){
    ID_var <- c("${ID_var}")
    ID_var <- ID_var[ID_var!=""]
    data <- read.table(file="${file}", sep="\t", header=$header,
    row.names=1, quote="", check.names=F)
    if ("${gene}" != "FALSE") {
        data_m <- as.data.frame(t(data["${gene}", ]))
        data_m\$Sample = rownames(data_m)

        if ("${sampleGroup}" != "FALSE") {
            sampleGroup <- read.table("${sampleGroup}",sep="\t",header=1,check.names=F,row.names=1)
            data_m <- merge(data_m, sampleGroup, by="row.names")
        }else{
        	print("Wainning: Because per x-axis tag contains only one data, so recommend you to use the scatterplot or lines script")
        }
    }else {
        if ("$variable" != "variable") {
            if (length(ID_var) > 0){
                ID_var <- c(ID_var, "${variable}")
            } else {
                ID_var <- c("${variable}")
            }
            data_m <- melt(data, id.vars=ID_var)
        } else {
            if (length(ID_var) > 0) {
              data_m <- melt(data, id.vars=ID_var)
            } else {
                data_m <- melt(data)
            }
        }
    }
} else {
    data_m <- read.table(file="$file", sep="\t",
    header=$header, quote="")
}


if (${y_add} != 0){
    data_m\$${value} <- data_m\$${value} + ${y_add}
}

level <- c(${level})


if ("${legend_cut}" != "") {    
    data_m\$${variable} <- cut(data_m\$${xvariable}, ${legend_cut})
} else if (length(level)>1){
    level_i <- level
    data_m\$${variable} <- factor(data_m\$${xvariable}, levels=level_i)
}

x_level <- c(${x_level})

if ("${x_cut}" != "") {
    data_m\$${variable} <- cut(data_m\$${variable},${x_cut})
}else if (length(x_level)){
    data_m\$${variable} <- factor(data_m\$${variable},levels=x_level)
}


facet_level <- c(${facet_level})
if (length(facet_level)>1) {
    data_m\$${facet} <- factor(data_m\$${facet},
        levels=facet_level, ordered=T)
}

### add by lindechun
if ("${variable}" == "${xvariable}") {
    dat <- s_boxplot_median(data_m, more_v=FALSE)
}else{
    dat <- s_boxplot_median(data_m, more_v=TRUE)
}

data_m <- dat\$data_m

## calculate point size of jitter
data_nrow=nrow(dat\$data_m)
if (data_nrow < 50) {
	jitter_size=1
}else{
	jitter_size=0.5
}

dat\$data_m\$${xvariable} <- factor(data_m\$${xvariable})
dat\$data_m\$${variable} <- factor(data_m\$${variable})

data_m\$${xvariable} <- factor(data_m\$${xvariable})
data_m\$${variable} <- factor(data_m\$${variable})

if ("${facet}" != "NoMeAnInGTh_I_n_G_s") {
	dat\$data_m\$${facet} <- factor(data_m\$${facet})
	data_m\$${facet} <- factor(data_m\$${facet})
}


### add by lindechun

p <- ggplot(dat\$data_m, aes($variable, ${value})) + xlab("$xlab") +
    ylab("$ylab") + labs(title="$title")

if (${violin}) {
    p <- p + geom_violin(aes(color=${xvariable},fill=${xvariable}), 
    stat = "ydensity", position = "dodge", trim = TRUE, 
    scale = "${scale_violin}")

	if ("${variable}" != "${xvariable}") {
        p <- p + geom_point(data=dat\$data_bp_median,aes(x=a3,y=median), size=1)+
            coord_cartesian(ylim=c(min(dat\$data_m_temp\$${value}),max(dat\$data_m_temp\$${value})))
     }else{
     	p <- p+geom_point(data=dat\$data_bp_median,aes(x=${variable}, y=median),size=1)
     }

    # stat_summary(aes(group=${variable}), fun.y=mean, 
    # geom="point", fill="black", shape=19, size=1,
    # position = position_dodge(width = .9))

} else if (${violin_jitter}) {
    p <- p + geom_violin(aes(color=${xvariable}),size=0.5, 
    stat = "ydensity", position = "dodge", trim = TRUE, 
    scale = "${scale_violin}")+geom_quasirandom(size=jitter_size)

	if ("${variable}" != "${xvariable}") {
        p <- p + geom_point(data=dat\$data_bp_median,aes(x=a3,y=median), size=1.5, shape=17)+
            coord_cartesian(ylim=c(min(dat\$data_m_temp\$${value}),max(dat\$data_m_temp\$${value})))
     }else{
     	p <- p+geom_point(data=dat\$data_bp_median,aes(x=${variable},y=median), size=1.5, shape=17)
     }

} else if (${jitter}) {

    p <- p + geom_quasirandom(aes(color=${xvariable}),size=jitter_size)
    p <- p + stat_summary(fun.y = "mean", geom = "text", label="----", size= 5, color= "black")
} else {
    if (${notch}){
        if (${outlier}){
            p <- p + geom_boxplot(aes(fill=${xvariable},color=${xvariable}), notch=TRUE,width=$sub_box, 
            notchwidth=0.3, outlier.colour='NA')
        }else{
            p <- p + geom_boxplot(aes(fill=${xvariable},color=${xvariable}), notch=TRUE,outlier.size=0.5, width=$sub_box, 
            notchwidth=0.3)
        }
    } else {
        if (${outlier}){
            p <- p + geom_boxplot(aes(fill=${xvariable},color=${xvariable}),
            outlier.colour='NA', width=$sub_box)
        }else{
            p <- p + geom_boxplot(aes(fill=${xvariable},color=${xvariable}),outlier.size=0.5, width=$sub_box)
        }
    }
    if ("${variable}" != "${xvariable}") {
        p <- p + geom_crossbar(data=dat\$data_bp_median,aes(x=a3,y=median,ymin=median,ymax=median),width=0.8*$sub_box/length(unique(dat\$data_m_temp\$a2)),fatten=0,size=0.7,color="white")+
            coord_cartesian(ylim=c(min(dat\$data_m_temp\$${value}),max(dat\$data_m_temp\$${value})))
    } else {
        p <- p + geom_crossbar(data=dat\$data_bp_median,aes(x=${variable},y=median,ymax=median,ymin=median),width=$sub_box,color="white",fatten=0,size=0.7)
    }
}

if (${boxplot_jitter}) {
    p <- p + geom_quasirandom(color="black",size=jitter_size)
}


if ($scaleY) {
    p <- p + $scaleY_x
    # p <- p + stat_summary(fun.y = "mean", geom = "text", label="----", size= 5, color= "black")
}

if (${outlier}) {
    #ylim_zoomin <- boxplot.stats(dat\$data_m\$${value})\$stats[c(1,5)]
    stats <- boxplot.stats(dat\$data_m\$${value})\$stats
    ylim_zoomin <- c(stats[1]/${out_scale}, stats[5]*${out_scale})
    p <- p + coord_cartesian(ylim = ylim_zoomin)
}


if ($color) {
    p <- p + scale_fill_manual(values=c(${color_v}))+scale_colour_manual(values=c(${color_v}))
}

if (${rotate_plot}) {
    p <- p + coord_flip()
}


if ("${facet}" != "NoMeAnInGTh_I_n_G_s") {
    # p <- p + facet_wrap( ~ ${facet}, nrow=${nrow}, ncol=${ncol},scale="${scales}")
    p <- p + facet_wrap( ~ ${facet},scale="${scales}")
}

END


`ggplot2_configure`


if [ "$execute" == "TRUE" ]; then
	Rscript ${file}${mid}.r
    if [ "$?" == "0" ]; then 
        /bin/rm -f ${file}${mid}.r
    fi
fi