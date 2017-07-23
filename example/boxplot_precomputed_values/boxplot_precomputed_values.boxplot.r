
if (FALSE){
	install.packages("ggplot2", repo="http://cran.us.r-project.org")
	install.packages("reshape2", repo="http://cran.us.r-project.org")
	install.packages("scales", repo="http://cran.us.r-project.org")
	if(FALSE){
		install.packages("ggbeeswarm", repo="http://cran.us.r-project.org")
	}
}

if(FALSE){
	library(ggbeeswarm)
}else if(FALSE){
	library(ggbeeswarm)
}

library(ggplot2)
library(reshape2)
library(scales)

data_m <- read.table(file="boxplot_precomputed_values", sep="\t", header=TRUE,
row.names=NULL, quote="")

if ("" != ""){
	data_m$variable <- cut(data_m$variable, )
} else if ("" != ""){
	level_i <- c()
	data_m$variable <- factor(data_m$variable, levels=level_i)
}
if ("" != ""){
	data_m$Samp <- cut(data_m$Samp,)
}else if ("" != ""){
	x_level <- c()
	data_m$Samp <- factor(data_m$Samp,levels=x_level)
}

if ("NA" != "NA") {
	facet_level <- c(NA)
	data_m$NoMeAnInGTh_I_n_G_s <- factor(data_m$NoMeAnInGTh_I_n_G_s,
        levels=facet_level, ordered=T)
}


#Samp	minimum	maximum	lower_quantile	median	upper_quantile	Set
p <- ggplot(data_m, aes(x=factor(Samp), ymin=minimum, lower=lower_quantile, 
			middle=median, upper=upper_quantile, ymax=maximum)) +
			xlab(" ") + ylab(" ") + labs(title="")


if (TRUE){
	p <- p + geom_boxplot(aes(fill=factor(variable)), notch=TRUE,
		notchwidth=0.3, stat = "identity")
}else {
	p <- p + geom_boxplot(aes(fill=factor(variable)), stat = "identity")
}


if(FALSE){
	p <- p + scale_y_log10()
	p <- p + stat_summary(fun.y = "mean", geom = "text", label="----", size= 10, color= "black")
}


if(FALSE){
	p <- p + scale_fill_manual(values=c())
}

if(FALSE){
	p <- p + coord_flip()	
}

if ("NoMeAnInGTh_I_n_G_s" != "NoMeAnInGTh_I_n_G_s"){
	p <- p + facet_wrap( ~ NoMeAnInGTh_I_n_G_s, nrow=NULL, ncol=NULL,
	scale="fixed")
}



#Configure the canvas
#legend.title=element_blank(),
p <- p + theme_bw() + theme(
	panel.grid.major = element_blank(), 
	panel.grid.minor = element_blank(),
	legend.key=element_blank())

if (0 != 0){
	if (0 == 90){
		p <- p + theme(axis.text.x=
		  element_text(angle=0,hjust=1, vjust=0.5))
	}else if (0 == 45){
		p <- p + theme(axis.text.x=
		  element_text(angle=0,hjust=0.5, vjust=0.5))
	} else {
		p <- p + theme(axis.text.x=
		  element_text(angle=0,hjust=0.5, vjust=0.5))
	}
}

#Set the position of legend
top='top'
botttom='bottom'
left='left'
right='right'
none='none'
legend_pos_par <- right

p <- p + theme(legend.position=legend_pos_par)

#add additional ggplot2 supported commands

p <- p


# output pictures

if ("pdf" == "pdf") {
	ggsave(p, filename="boxplot_precomputed_values.boxplot.pdf", dpi=300, width=20,
	height=12, units=c("cm"),colormodel="srgb")
} else {
	ggsave(p, filename="boxplot_precomputed_values.boxplot.pdf", dpi=300, width=20,
	height=12, units=c("cm"))
}
#png(filename="boxplot_precomputed_values.boxplot.png", width=20, height=12,
#res=300)
#p
#dev.off()
