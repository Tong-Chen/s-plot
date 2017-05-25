#!/bin/bash

#Only for debugging
#set -x

usage()
{
cat <<EOF
${txtcyn}


***CREATED BY Chen Tong (chentong_biology@163.com)***

Usage:

$0 options${txtrst}

${bldblu}Function${txtrst}:

This program is designed to test if two boxes have statistically
significant differences.

Currently multiple groups among one set are supported.

fileformat for -f (suitable for data extracted from one sample, the
number of columns is unlimited. Column 'Set' is not necessary unless
you have multiple groups)

Gene	hmC	expr	Set
NM_001003918_26622	0	83.1269257376101	TP16
NM_001011535_3260	0	0	TP16
NM_001012640_14264	0	0	TP16
NM_001012640_30427	0	0	TP16
NM_001003918_2662217393_30486	0	0	TP16
NM_001017393_30504	0	0	TP16
NM_001025241_30464	0	0	TP16
NM_001017393_30504001025241_30513	0	0	TP16

For file using "Set" column, you can use 
$0 -f file -a Set 

fileformat when -m is true
#The name "value" and "variable" shoud not be altered.
#The "Set" column is optional.
#If you do have several groups, they can put at the "Set" column 
#with "Set" or other string as labels. The label should be given
#to parameter -a.
#Actually this format is the melted result of last format.
value	variable	Set
0	hmC	g
1	expr	g
2	hmC	a
3	expr	a

${txtbld}OPTIONS${txtrst}:
	-f	Data file (with header line, the first column is the
 		colname, tab seperated)${bldred}[NECESSARY]${txtrst}
	-m	When true, it will skip preprocess. But the format must be
		the same as listed before.
		${bldred}[Default FALSE, accept TRUE]${txtrst}
	-a	Name for x-axis variable
		[${txtred}Default variable, which is an inner name, suitable 
		for data without 'Set' column. For the given example, 
		'Set' which represents groups of each gene, and should be 
		supplied to this parameter.
		${txtrst}]
	-s	The statistical method you want to use.${bldred}[Default
		t.test, accept wilcox.test, ks.test]${txtrst}
	-D	Self-define intervals for legend variable when legend is
		continuous numbers. Accept either a
		numeric vector of two or more cut points or a single number
		(greater than or equal to 2) giving the number of intervals
		into what 'x' is to be cut. This has higher priority than -l.
		[10 will generate 10 intervals or 
		"c(-1, 0, 1, 2, 5, 10)" will generate (-1,0],(0,1]...(5,10]]	
	-B	Self-define intervals for x-axis variable. Accept either a
		numeric vector of two or more cut points or a single number
		(greater than or equal to 2) giving the number of intervals
		into what 'x' is to be cut. 
		[10 will generate 10 intervals or 
		"c(-1, 0, 1, 2, 5, 10)" will generate (-1,0],(0,1]...(5,10]]	
	-e	Execute or not[${bldred}Default TRUE${txtrst}]
	-i	Install depeneded packages[${bldred}Default FALSE${txtrst}]
EOF
}

file=
melted='FALSE'
xvariable='variable'
level=""
legend_cut=""
x_level=""
x_cut=""
header='TRUE'
execute='TRUE'
ist='FALSE'
method='t.test'



while getopts "ha:B:D:e:f:i:m:s:" OPTION
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
			xvariable=$OPTARG
			;;
		s)
			method=$OPTARG
			;;
		B)
			x_cut=$OPTARG
			;;
		D)
			legend_cut=$OPTARG
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

mid=".boxplot.${method}"


cat <<END >${file}${mid}.r

if ($ist){
	#install.packages("ggplot2", repo="http://cran.us.r-project.org")
}

if(! $melted){

	data <- read.table(file="${file}", sep="\t", header=$header,
	row.names=1, quote="")
	if ("$xvariable" != "variable"){
		data_m <- melt(data, id.vars=c("${xvariable}"))
	} else {
		data_m <- melt(data)
	}
} else {
	data_m <- read.table(file="$file", sep="\t",
	header=$header, quote="")
}

if ("${legend_cut}" != ""){
	data_m\$variable <- cut(data_m\$variable, ${legend_cut})
} 
if ("${x_cut}" != ""){
	data_m\$${xvariable} <- cut(data_m\$${xvariable},${x_cut})
}

if ("$xvariable" == "variable"){
	#No Group information
	variableL <- unique(data_m\$variable)
	len_var <- length(variableL)
	if (len_var < 3){
		print(${method}(value~variable, data=data_m))
	} else {
		for(i in 1:(len_var-1)){
			var1 <- variableL[i]
			for(j in (i+1):len_var){
				var2 <- variableL[j]
				new_data <- data_m[data_m\$variable == var1 |
				data_m\$variable == var2, ]
				print(paste("### Compare for", var1, "and", var2, "###"))
				print(${method}(value~variable, data=new_data))
			}
		}
	}
} else {
	#Compute several groups
	group <- names(summary(data_m\$${xvariable}))
	for (i in group){
		tmp <- data_m[data_m\$${xvariable}==i,]
		print(paste("*** Compute for Group ", i, " ***"))
		#print(${method}(value~variable, data=tmp))

		variableL <- unique(tmp\$variable)
		len_var <- length(variableL)
		if (len_var < 3){
			print(${method}(value~variable, data=tmp))
		} else {
			for(i in 1:(len_var-1)){
				var1 <- variableL[i]
				for(j in (i+1):len_var){
					var2 <- variableL[j]
					new_data <- tmp[tmp\$variable == var1 |
					tmp\$variable == var2, ]
					print(paste("### Compare for", var1, "and", var2, "###"))
					print(${method}(value~variable, data=new_data))
				}
			}
		}
	}
}

END

if [ "$execute" == "TRUE" ]; then
	Rscript ${file}${mid}.r
	if [ "$?" == "0" ]; then /bin/rm -f ${file}${mid}.r; fi
fi

