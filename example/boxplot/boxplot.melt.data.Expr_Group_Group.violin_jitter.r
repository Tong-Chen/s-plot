source('/opt/bin/s-plot/rFunction.R')

if (FALSE){
	installp(c("ggplot2", "reshape2", "scales","ggbeeswarm","dplyr"))
}

if(FALSE || TRUE || FALSE){
	library(ggbeeswarm)
}
# else if(FALSE){
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
      (i-y)*(0.75/length(unique(x)))
    }
    cc<-sapply(x,dfd,y)
    return(cc)
  }
  if (more_v){
    temp1 <- mutate(dat,a1=as.integer(Group))
    temp1 <- mutate(temp1,a2=as.integer(Group))
    temp1$a3 <- temp1$a1+errorbarWidth(temp1$a2)
    temp2 <- temp1 %>% group_by(a3) %>% summarise(median=median(Expr))
    
    ## force boxplots from geom_boxplot to constant width
    ## Ref: https://stackoverflow.com/questions/16705129/force-boxplots-from-geom-boxplot-to-constant-width

    if ("NoMeAnInGTh_I_n_G_s" != "NoMeAnInGTh_I_n_G_s") {
    	tab <- xtabs(~Group+Group+NoMeAnInGTh_I_n_G_s,temp1)
	    tmp <- temp1[c("Group","Group","Expr","NoMeAnInGTh_I_n_G_s")]
    }else{
	    tab <- xtabs(~Group+Group,temp1)
	    tmp <- temp1[c("Group","Group","Expr")]
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
        if ("NoMeAnInGTh_I_n_G_s" != "NoMeAnInGTh_I_n_G_s") {
		    if (is.integer(dimnames(tab)[[1]])){
		      fake_3 <- as.integer(dimnames(tab)[[3]][x[3]])
		    }else{
		      fake_3 <- dimnames(tab)[[3]][x[3]]
		    }
		    setNames(data.frame(fake_1,fake_2,min(temp1$Expr)-0.06*(max(temp1$Expr)-min(temp1$Expr)),fake_3),names(tmp))
		}else{
	        setNames(data.frame(fake_1,fake_2,min(temp1$Expr)-0.06*(max(temp1$Expr)-min(temp1$Expr))),names(tmp))
	    }
      }
      )
     tmp2 <- rbind(tmp, do.call(rbind, fakeLines))
    }else{
      tmp2 <- tmp
    }

    return(list(data_m=tmp2,data_bp_median=temp2,data_m_temp=temp1))

  }else{

    temp2 <- dat %>% group_by(Group) %>% summarise(median=median(Expr))
    return(list(data_m=dat,data_bp_median=temp2))
  }
}


###### add by lindechun

if(! TRUE){
    ID_var <- c("")
    ID_var <- ID_var[ID_var!=""]
    data <- read.table(file="boxplot.melt.data", sep="\t", header=TRUE,
    row.names=1, quote="", check.names=F)
    if ("FALSE" != "FALSE") {
        data_m <- as.data.frame(t(data["FALSE", ]))
        data_m$Sample = rownames(data_m)

        if ("FALSE" != "FALSE") {
            sampleGroup <- read.table("FALSE",sep="\t",header=1,check.names=F,row.names=1)
            data_m <- merge(data_m, sampleGroup, by="row.names")
        }else{
        	print("Wainning: Because per x-axis tag contains only one data, so recommend you to use the scatterplot or lines script")
        }
    }else {
        if ("Group" != "variable") {
            if (length(ID_var) > 0){
                ID_var <- c(ID_var, "Group")
            } else {
                ID_var <- c("Group")
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
    data_m <- read.table(file="boxplot.melt.data", sep="\t",
    header=TRUE, quote="")
}


if (0 != 0){
    data_m$Expr <- data_m$Expr + 0
}

level <- c()


if ("" != "") {    
    data_m$Group <- cut(data_m$Group, )
} else if (length(level)>1){
    level_i <- level
    data_m$Group <- factor(data_m$Group, levels=level_i)
}

x_level <- c()

if ("" != "") {
    data_m$Group <- cut(data_m$Group,)
}else if (length(x_level)){
    data_m$Group <- factor(data_m$Group,levels=x_level)
}


facet_level <- c(NA)
if (length(facet_level)>1) {
    data_m$NoMeAnInGTh_I_n_G_s <- factor(data_m$NoMeAnInGTh_I_n_G_s,
        levels=facet_level, ordered=T)
}

### add by lindechun
if ("Group" == "Group") {
    dat <- s_boxplot_median(data_m, more_v=FALSE)
}else{
    dat <- s_boxplot_median(data_m, more_v=TRUE)
}

data_m <- dat$data_m

## calculate point size of jitter
data_nrow=nrow(dat$data_m)
if (data_nrow < 50) {
	jitter_size=1
}else{
	jitter_size=0.5
}

dat$data_m$Group <- factor(data_m$Group)
dat$data_m$Group <- factor(data_m$Group)

data_m$Group <- factor(data_m$Group)
data_m$Group <- factor(data_m$Group)

if ("NoMeAnInGTh_I_n_G_s" != "NoMeAnInGTh_I_n_G_s") {
	dat$data_m$NoMeAnInGTh_I_n_G_s <- factor(data_m$NoMeAnInGTh_I_n_G_s)
	data_m$NoMeAnInGTh_I_n_G_s <- factor(data_m$NoMeAnInGTh_I_n_G_s)
}


### add by lindechun

p <- ggplot(dat$data_m, aes(Group, Expr)) + xlab("Group") +
    ylab("Expr") + labs(title="")

if (FALSE) {
    p <- p + geom_violin(aes(color=Group,fill=Group), 
    stat = "ydensity", position = "dodge", trim = TRUE, 
    scale = "width")

	if ("Group" != "Group") {
        p <- p + geom_point(data=dat$data_bp_median,aes(x=a3,y=median), size=1)+
            coord_cartesian(ylim=c(min(dat$data_m_temp$Expr),max(dat$data_m_temp$Expr)))
     }else{
     	p <- p+geom_point(data=dat$data_bp_median,aes(x=Group, y=median),size=1)
     }

    # stat_summary(aes(group=Group), fun.y=mean, 
    # geom="point", fill="black", shape=19, size=1,
    # position = position_dodge(width = .9))

} else if (TRUE) {
    p <- p + geom_violin(aes(color=Group),size=0.5, 
    stat = "ydensity", position = "dodge", trim = TRUE, 
    scale = "width")+geom_quasirandom(size=jitter_size)

	if ("Group" != "Group") {
        p <- p + geom_point(data=dat$data_bp_median,aes(x=a3,y=median), size=1.5, shape=17)+
            coord_cartesian(ylim=c(min(dat$data_m_temp$Expr),max(dat$data_m_temp$Expr)))
     }else{
     	p <- p+geom_point(data=dat$data_bp_median,aes(x=Group,y=median), size=1.5, shape=17)
     }

} else if (FALSE) {

    p <- p + geom_quasirandom(aes(color=Group),size=jitter_size)
    p <- p + stat_summary(fun.y = "mean", geom = "text", label="----", size= 5, color= "black")
} else {
    if (FALSE){
        if (FALSE){
            p <- p + geom_boxplot(aes(fill=Group,color=Group), notch=TRUE,width=0.75, 
            notchwidth=0.3, outlier.colour='NA')
        }else{
            p <- p + geom_boxplot(aes(fill=Group,color=Group), notch=TRUE,outlier.size=0.5, width=0.75, 
            notchwidth=0.3)
        }
    } else {
        if (FALSE){
            p <- p + geom_boxplot(aes(fill=Group,color=Group),
            outlier.colour='NA', width=0.75)
        }else{
            p <- p + geom_boxplot(aes(fill=Group,color=Group),outlier.size=0.5, width=0.75)
        }
    }
    if ("Group" != "Group") {
        p <- p + geom_crossbar(data=dat$data_bp_median,aes(x=a3,y=median,ymin=median,ymax=median),width=0.8*0.75/length(unique(dat$data_m_temp$a2)),fatten=0,size=0.7,color="white")+
            coord_cartesian(ylim=c(min(dat$data_m_temp$Expr),max(dat$data_m_temp$Expr)))
    } else {
        p <- p + geom_crossbar(data=dat$data_bp_median,aes(x=Group,y=median,ymax=median,ymin=median),width=0.75,color="white",fatten=0,size=0.7)
    }
}

if (FALSE) {
    p <- p + geom_quasirandom(color="black",size=jitter_size)
}


if (FALSE) {
    p <- p + scale_y_log10()
    # p <- p + stat_summary(fun.y = "mean", geom = "text", label="----", size= 5, color= "black")
}

if (FALSE) {
    #ylim_zoomin <- boxplot.stats(dat$data_m$Expr)$stats[c(1,5)]
    stats <- boxplot.stats(dat$data_m$Expr)$stats
    ylim_zoomin <- c(stats[1]/1.05, stats[5]*1.05)
    p <- p + coord_cartesian(ylim = ylim_zoomin)
}


if (FALSE) {
    p <- p + scale_fill_manual(values=c())+scale_colour_manual(values=c())
}

if (FALSE) {
    p <- p + coord_flip()
}


if ("NoMeAnInGTh_I_n_G_s" != "NoMeAnInGTh_I_n_G_s") {
    # p <- p + facet_wrap( ~ NoMeAnInGTh_I_n_G_s, nrow=NULL, ncol=NULL,scale="fixed")
    p <- p + facet_wrap( ~ NoMeAnInGTh_I_n_G_s,scale="fixed")
}


#Configure the canvas

p <- p + theme_classic2()

#Correcting location of x-aixs label
p <- Xlable_angle_correct(p, 0)

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
w_auto_temp=length(levels(data_m$Group))

 w_h_auto <- Canvas_size(w_auto_temp, "Group", "Group", FALSE, "right")
 w_auto <- w_h_auto[1]
 h_auto <- w_h_auto[2]

if ("NoMeAnInGTh_I_n_G_s" != "NoMeAnInGTh_I_n_G_s"){
	if ("NULL" != 'NULL') {
		h_auto=h_auto*NULL
	}
	if ("NULL" != 'NULL') {
		w_auto=w_auto*NULL
	}
	if ("NULL" == 'NULL' && "NULL" == 'NULL'){
		w_auto=w_auto*3
		h_auto=h_auto*0.7*length(levels(data_m$NoMeAnInGTh_I_n_G_s))/3
	}
}


# Control margin of plot by exist status of title, xlab, ylab
if ("" == "") {
	p <- p+ theme(plot.title=element_blank())
}
if ("Group" == "") {
	p <- p+ theme(axis.title.x=element_blank())
}
if ("Expr" == "") {
	p <- p+ theme(axis.title.y=element_blank())
}

## savefig
if ("" != ''){
	if (!FALSE){
		Savefig("boxplot.melt.data.Expr_Group_Group.violin_jitter.pdf", p, , , "300", "pdf")
	}else{
		Savefig("boxplot.melt.data.Expr_Group_Group.violin_jitter.pdf", p, , , "300", "pdf")
	}
}else{
	if (!FALSE){
		Savefig("boxplot.melt.data.Expr_Group_Group.violin_jitter.pdf", p, w_auto, h_auto, "300", "pdf")
	}else{
		Savefig("boxplot.melt.data.Expr_Group_Group.violin_jitter.pdf", p, h_auto, w_auto, "300", "pdf")
	}
}
