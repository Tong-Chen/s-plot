#awk 'BEGIN{OFS="\t";FS="\t"}{if(FNR==1) {$1="GENE.NAME"; print "GENE.ID", $0;} else {print $1, $0}}' lsm.expr.shannon.selected >lsm.expr.shannon.selected.mfuzz

file <- "lsm.expr.shannon.selected"

data <- read.table(file=file, header=T,sep="\t",row.names=1)

file.m <- "lsm.expr.shannon.selected.mfuzz"

data.eset <- table2eset(file.m)

data.eset.s <- standardise(data.eset)

cl <- mfuzz(data.eset.s,  c=10,  m=1.25)

cluster <- cl$cluster

data.c <- cbind(data, cluster)

data.c <- data.c[order(data.c$cluster), ]

write.table(data.c, file="lsm.expr.shannon.selected.cluster",
	sep="\t", row.names=T, col.names=T, quote=F)

transferNormalClusteredMatrixForLinePlot.py -i lsm.expr.shannon.selected.cluster >lsm.expr.shannon.selected.cluster.forLine
s-plot lines -f lsm.expr.shannon.selected.cluster.forLine -m TRUE -a Sample -P none -F " + facet_wrap(~set, ncol=2, scale='free')"  -G 'data_m$set <- factor(data_m$set, levels=c(1,2,3,4,5,6,7,8,9,10), ordered=T)' -w 30 -u 60 -r 50 -L "'COL_2D','GEL_2D','PS_2D','MES','COL_3D','PLGA_3D','QB_3D','EB_5d'" -B 0.5


print("Output the mean value of each cluster")
cluster.mean <- aggregate(data, by=list(cl$cluster), FUN=mean)
write.table(t(cluster.mean), file="lsm.expr.shannon.selected.cluster.10.kmeans.cluster.mean.lines", sep='\t', col.names=F, row.names=T, quote=F)

s-plot lines -f lsm.expr.shannon.selected.cluster.10.kmeans.cluster.mean.lines -B 0.5


#pdf("lsm.expr.shannon.selected.cluster.pdf")
#mfuzz.plot2(data.eset, cl, mforw=c(5,2), colo="fancy", x11=FALSE)
#dev.off()
