
if (FALSE){
	install.packages("ggplot2", repo="http://cran.us.r-project.org")
	install.packages("reshape2", repo="http://cran.us.r-project.org")
	install.packages("scales", repo="http://cran.us.r-project.org")
}
library(ggplot2)
library(reshape2)
library(scales)

if(! FALSE){
	ID_var <- "expression"
	data <- read.table(file="file.matrix", sep="\t", header=TRUE,
	row.names=1)
	if ("variable" != "variable"){
		if (ID_var != ""){
			data_m <- melt(data, id.vars=c("variable", ID_var))
		} else {
			data_m <- melt(data, id.vars=c("variable"))
		}
	} else {
		if (ID_var != ""){
			data_m <- melt(data, id.vars=c(ID_var))
		} else {
			data_m <- melt(data)
		}
	}
} else {
	data_m <- read.table(file="file.matrix", sep="\t",
	header=TRUE)
}

if (0 != 0){
	data_m$value <- data_m$value + 0
}

if ("" != ""){
	data_m$variable <- cut(data_m$variable, )
} else if ("" != ""){
	level_i <- c()
	data_m$variable <- factor(data_m$variable, levels=level_i)
}
if ("" != ""){
	data_m$variable <- cut(data_m$variable,)
}else if ("" != ""){
	x_level <- c()
	data_m$variable <- factor(data_m$variable,levels=x_level)
}

p <- ggplot(data_m, aes(factor(variable), value)) + xlab("NULL") +
ylab("NULL")


if (FALSE){
	p <- p + geom_violin(aes(fill=factor(variable)), 
	stat = "ydensity", position = "dodge", trim = TRUE,  
	scale = "area") + 
	geom_boxplot(aes(fill=factor(variable)), alpha=.25, width=0.15, 
	position = position_dodge(width = .9), outlier.colour='NA',
	scale="area") + 
	stat_summary(aes(group=variable), fun.y=mean,  
	geom="point", fill="black", shape=19, size=1,
	position = position_dodge(width = .9))
   	
	#+ geom_jitter(height = 0)
} else if (FALSE){
	p <- p + geom_violin(aes(fill=factor(variable)), 
	stat = "ydensity", position = "dodge", trim = TRUE,  
	scale = "area") 
} else {
	if (TRUE){
		if (FALSE){
		p <- p + geom_boxplot(aes(fill=factor(variable)), notch=TRUE,
			notchwidth=0.3, outlier.colour='NA')
		}else{
		p <- p + geom_boxplot(aes(fill=factor(variable)), notch=TRUE,
			notchwidth=0.3)
		}
	}else {
		if (FALSE){
			p <- p + geom_boxplot(aes(fill=factor(variable)),
			outlier.colour='NA')
		}else{
			p <- p + geom_boxplot(aes(fill=factor(variable)))
		}
	}
}


if(FALSE){
	p <- p + scale_y_log10()
}

if(FALSE){
	#ylim_zoomin <- boxplot.stats(data_m$value)$stats[c(1,5)]
	stats <- boxplot.stats(data_m$value)$stats
	ylim_zoomin <- c(stats[1]/1.05, stats[5]*1.05)
	p <- p + coord_cartesian(ylim = ylim_zoomin)
}

if(FALSE){
	p <- p + scale_fill_manual(values=c())
}

#Configure the canvas
p <- p + theme_bw() + theme(legend.title=element_blank(),
	panel.grid.major = element_blank(), 
	panel.grid.minor = element_blank(),
	legend.key=element_blank(),
	axis.text.x=element_text(angle=0,hjust=1))

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

ggsave(p, filename="file.matrix.boxplot.png", dpi=300, width=20,
height=12, units=c("cm"))

#png(filename="file.matrix.boxplot.png", width=20, height=12,
#res=300)
#p
#dev.off()
