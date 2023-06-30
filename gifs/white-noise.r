library(data.table)
library(ggplot2)
library(magick)
library(stringr)
library(fredr)
library(extrafont)
loadfonts(device="win",quiet=T)

theme_eg <- function(base_size=12,base_family="Segoe Print",border=F){
  theme(
    panel.background=element_rect(fill="white",color=NA),
    panel.grid=element_line(colour=NULL,linetype=3),
    panel.grid.major=element_line(colour="dimgray"),
    panel.grid.major.x=element_blank(),
    panel.grid.minor=element_blank(),
    plot.background=element_rect(fill="white",color=NA),
    plot.title=element_text(family=base_family,size=rel(1.2),colour="dimgray"),
    plot.caption=element_text(family=base_family,colour="darkgray"),
    plot.margin=margin(.25,.25,.25,.25,"lines"),
    axis.title=element_text(family=base_family,face="bold",size=rel(1.3),colour="dimgray"),
    axis.text=element_text(family=base_family,size=rel(1.1),colour="dimgray",margin=margin(t=1,r=1,b=1,l=1)),
    axis.line=element_line(colour="dimgray"),
    axis.line.y=element_blank(),
    axis.ticks=element_blank(),
    legend.background=element_rect(fill="transparent",color=NA),
    legend.position="none",
    legend.title=element_blank(),
    legend.text=element_text(family=base_family,size=rel(1.1),colour="dimgray"),
    legend.key.size=unit(.75,'lines'),
    strip.background=element_blank(),
    strip.text=element_text(family=base_family,size=rel(0.9),colour="dimgray",face="bold",margin=margin(.5,0,.5,0,"lines"))
  )
}


# 2.3 - white noise ----
n <- 120
set.seed(1)
x <- rnorm(n)
wn_dt <- data.table(t=1:n,x=x)


for(i in 1:n){
  
  # plot the time series
  gg_wn <- ggplot(wn_dt,aes(x=t,y=x))+
    geom_line(linewidth=.5,color=ifelse(wn_dt$t<i,"coral","lightgray"))+
    ylim(-2.5,2.5)+
    xlim(0,125)+
    labs(x="t",y=expression(y[t]))+
    theme_eg()
  
  # graph the dot-density of the series
  gg_dots <- ggplot(wn_dt[t<=i],aes(x=x))+
    geom_dotplot(binwidth=.12,color="coral",fill="lightgray",stroke=1,method="histodot",stackratio=1.1)+
    xlim(-2.5,2.5)+
    coord_flip()+
    theme_eg()+
    theme(axis.title=element_blank(),axis.title.y=element_blank(),axis.text=element_blank(),axis.line=element_blank())
  
  # combine the two graphs
  gg_comb <- plot_grid(gg_wn,gg_dots,align="hv",ncol=2,rel_widths = c(3,1))
  
  ggsave(paste0("gifs/white-noise/w",str_pad(i,3,pad="0"),".png"),width=1600*.4,height=900*.4,unit="px",dpi=100)
  
}

# this next few lines create a gif from the pre-generated images

## create a list of the png file names in the temp folder
the_list <- paste0("gifs/white-noise/",list.files("gifs/white-noise/"))

## store the graphs as a list in frames
frames <- lapply(the_list,image_read)

## generate a gif
animation <- image_animate(image_join(frames),fps=10)

## save the gif
image_write(animation,"gifs/white-noise.gif")

