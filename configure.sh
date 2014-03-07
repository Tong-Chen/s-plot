#!/bin/bash

function ggplot2_configure {

cat <<END >>${file}${midname}.r

#Configure the canvas
p <- p + theme_bw() + theme(legend.title=element_blank(),
	panel.grid.major = element_blank(), 
	panel.grid.minor = element_blank(),
	legend.key=element_blank(),
	axis.text.x=element_text(angle=${xtics_angle}))

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

ggsave(p, filename="${file}${midname}.${ext}", dpi=$res, width=$uwid,
height=$vhig, units=c("cm"))

#png(filename="${file}${midname}.png", width=$uwid, height=$vhig,
#res=$res)
#p
#dev.off()
END
}
