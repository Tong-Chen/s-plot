
## CREATED BY Lin Dechun (lindechun@genomics.cn)

## install pacakge from Bioconductor
bio <- function(pacakge){
    source("http://bioconductor.org/biocLite.R")
    biocLite(pacakge)
}

## install.package
installp <- function(packagelist,force=F){
  for (package in packagelist){
    if (!package %in% .packages(all.available = T) || force == T){
      install.packages(package,repo="https://mirrors.tuna.tsinghua.edu.cn/CRAN/")
    }else{
      print(paste(package," has been installed!",sep=""))
    }
  }
}

# themes for ggplot2 self-definited
## axis.title的size大小适用于labs(),而对默认生成的坐标轴标题偏小5左右
theme_classic2 <- function(...) {
    ## 上下左右均有坐标线，主题风格简约
  theme_bw(...)+theme(panel.background=element_rect(color='black'),panel.border=element_rect(fill='transparent',color='black'), panel.grid=element_blank(),plot.margin=unit(c(0.5, 0.5, 0.5, 0.5),'cm'),title=element_text(color='black',family="Times"),plot.title=element_text(size = 19,margin=unit(c(0.5,0.5,0.5,0.5),'cm'),hjust=0.5), axis.title =element_text(size=18,vjust = 0.1),axis.text=element_text(family="Times",size=17,color='black',margin = unit(0.8,"lines")),legend.background = element_blank(),legend.text=element_text(size = 12,color = 'black',family = 'Times', hjust = 0),legend.title=element_text(size = 13,color = 'black',family = 'Times', hjust = 0))
}

theme_classic3 <- function(...) {
    ## 左边和下边才有坐标线
  theme_bw(...)+theme(panel.background=element_blank(),panel.border=element_blank(),panel.grid=element_blank(),plot.margin=unit(c(0.5, 0.5, 0.5, 0.5),'cm'),title=element_text(color='black',face='plain',family="Times"),plot.title=element_text(size = 19,margin=unit(c(0.5,0.5,0.5,0.5),'cm'),hjust=0.5), axis.title =element_text(size=18,vjust = 0.1),axis.text=element_text(family="Times",size=17,color='black',margin = unit(0.8,"lines")),legend.background = element_blank(),axis.line.x=element_line(size=0.5,colour="black", linetype='solid'), axis.line.y=element_line(size=0.5,colour="black", linetype='solid'),legend.text=element_text(size=12,color = 'black',family = 'Times', hjust = 0),legend.title=element_text(size = 13,color = 'black',family = 'Times', hjust = 0))
}

theme_cin <- function(..., bg='transparent'){
    ## 轴续向内伸
  require(grid)
  theme_bw(...) + theme(rect=element_rect(fill=bg), plot.margin=unit(rep(0.5,4), 'lines'), panel.background=element_rect(fill='transparent', color='black'), panel.border=element_rect(fill='transparent', color='transparent'), panel.grid=element_blank(),title=element_text(color='black',face='plain',family="Times"), plot.title=element_text(size = 19,color='black',margin=unit(c(0.5,0.5,0.5,0.5),'cm'),hjust=0.5),axis.title = element_text(size=18,color='black', vjust=0.1), axis.ticks.length = unit(-0.3,"lines"),axis.text.x=element_text(family="Times",size=17,color='black',margin=margin(8,0,3,0,"pt")),axis.text.y=element_text(family="Times",size=17,color='black',margin=margin(0,8,0,3,"pt")), axis.ticks = element_line(color='black'),legend.background = element_blank(),legend.text=element_text(size=12,color = 'black',family = 'Times', hjust = 0),legend.title=element_text(size = 13,color = 'black',family = 'Times', hjust = 0),legend.key=element_rect(fill='transparent', color='transparent'))
}

# plot tools
## self-correcting location of x-aixs label ( applies to ggplot2)

Xlable_angle_correct <- function(selfp, xtics_angle) {

  if (xtics_angle != 0){
    if (xtics_angle == 90){
      selfp <- selfp + theme(axis.text.x=
        element_text(angle=xtics_angle, hjust=1, vjust=0.5))
    }else if (xtics_angle == 45){
      selfp <- selfp + theme(axis.text.x=
        element_text(angle=xtics_angle, hjust=1.1, vjust=1.1))
    } else {
      selfp <- selfp + theme(axis.text.x=
        element_text(angle=xtics_angle, hjust=0.5, vjust=0.5))
    }
  }
  return(selfp)

}

Canvas_size <- function(w_auto_temp, variable, xvariable, rotate_plot, legend_pos){
  if (w_auto_temp < 8) {
    w_auto=w_auto_temp-1
  } else if (w_auto_temp < 20) {
    w_auto=8+(w_auto_temp-8)/5
  } else {
    w_auto=14+(w_auto_temp-20)/5
  }

  if (variable != xvariable){
    w_auto=w_auto+2
  }

  h_auto=6
  if (! rotate_plot){
    if (legend_pos == "right" || legend_pos == "left"){
      w_auto=w_auto+2
    }
    if (legend_pos == "top" || legend_pos == "bottom"){
      h_auto=h_auto+0.5
      w_auto=w_auto+1
    }
  }else{
    if (legend_pos == "top" || legend_pos == "bottom"){
      w_auto=w_auto+1
    }
  }
  return(c(w_auto, h_auto))
}

Savefig <- function(filename,plott, width, height, ppi, ftype="pdf"){
  if (ftype == "pdf") {
    ggsave(plot=plott, filename=filename, dpi=ppi, width=width,
    height=height, units=c("in"),colormodel="srgb")
  } else {
    ggsave(plot=plott, filename=filename, dpi=ppi, width=width,
    height=height, units=c("in"))
  }
}
