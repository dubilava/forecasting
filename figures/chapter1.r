# load the libraries (install them if needed)
library(data.table)
library(ggplot2)
library(ggthemes)
library(extrafont)
loadfonts(device="win",quiet=T)
# font_import()
# loadfonts(device="win")
library(cowplot)

# plot aesthetics
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
    # axis.title.x=element_text(),
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

# 1.1 - dag (birds) ----

# set up the coordinates for nodes and edges
nudge <- .05
dt <- data.table(x=c(0,0,1,2),y=c(0,1,0,1),xbeg=c(0,0+nudge,0+2*nudge,NA),xend=c(0,1-nudge,1-1.5*nudge,NA),ybeg=c(1-1.5*nudge,1-1.5*nudge,0,NA),yend=c(0+1.5*nudge,0+1.5*nudge,0,NA),labels=c("B[t-1]","P[t-1]","S[t]",NA))

# plot the graph
gg_dag <- ggplot(dt)+
  geom_text(aes(x=x,y=y,label=labels),size=6,parse=T,color=c("black","gray","black","white"),na.rm=T,family="Segoe Print")+
  geom_segment(aes(x=xbeg,y=ybeg,xend=xend,yend=yend),lineend = c("round"),linejoin = c("round"),arrow=arrow(type="closed",angle=30,length=unit(0.1,"in")),linewidth=1,linetype=c(1,1,5,1),color=c("gray","gray","black","white"),na.rm=T)+
  geom_segment(data=dt[3,],aes(x=xend-.5*nudge,y=yend,xend=xend,yend=yend),lineend = c("round"),linejoin = c("round"),arrow=arrow(type="closed",angle=30,length=unit(0.1,"in")),linewidth=1,linetype=1,color="black")+
  coord_cartesian(clip="off")+
  theme_eg()+
  theme(axis.title=element_blank(),axis.title.y=element_blank(),axis.text=element_blank(),axis.line=element_blank(),panel.grid.major = element_blank())

gg_dag

ggsave("figures/c1/dag-birds.png",gg_dag,width=6.5,height=3.75,dpi="retina",device="png")
ggsave("figures/c1/dag-birds.eps",gg_dag,width=6.5,height=3.75,dpi="retina",device=cairo_ps)


# 1.2 - time series ----

# generate a sample of time series
n <- 20

set.seed(24)
x <- rnorm(n,3,1.5)
for(i in 2:n) x[i] <- .2*x[i-1]+x[i]
dt <- data.table(x=round(x),t=1:n)

# graph the time series
gg_ts <- ggplot(dt,aes(x=t,y=x))+
  geom_line(color="coral",linetype=1,linewidth=.8)+
  geom_point(color="coral",fill="lightgray",stroke=1,shape=21,size=3)+
  ylim(0,7)+
  labs(x=expression(t),y=expression(x[t]))+
  theme_eg()

# graph the dot-density of the series
gg_hist <- ggplot(dt,aes(x=x))+
  geom_dotplot(binwidth=.25,color="coral",fill="lightgray",stroke=2,stackratio=1.1)+
  xlim(0,7)+
  coord_flip()+
  theme_eg()+
  theme(axis.title=element_blank(),axis.title.y=element_blank(),axis.text=element_blank(),axis.line=element_blank())

# combine the two graphs
gg_comb <- plot_grid(gg_ts,gg_hist,align="hv",ncol=2,rel_widths = c(3,1))

gg_comb

ggsave("figures/c1/time-series.png",gg_comb,width=6.5,height=3.75,dpi="retina",device="png")
ggsave("figures/c1/time-series.eps",gg_comb,width=6.5,height=3.75,dpi="retina",device=cairo_ps)


# 1.3 - quadratic loss ----

# generate a sampe of forecast errors
n <- 7
set.seed(4)
dt <- data.table(x=rnorm(n,5,2))
dt[,`:=`(e=x-mean(x))]
dt[,`:=`(l=e^2)]
dt[,`:=`(t=1:n)]

line_dt <- data.table(x=rnorm(n*100,5,2))
line_dt[,`:=`(e=x-mean(x))]
line_dt[,`:=`(l=e^2)]

# graph the time series
gg_errors <- ggplot(dt,aes(x=t,y=e))+
  geom_line(color="dimgray",linetype=1,linewidth=.8)+
  geom_point(color="dimgray",fill="lightgray",stroke=1,shape=21,size=2.5)+
  ylim(-3.5,3.5)+
  labs(x=expression(t),y=expression(e[t]))+
  theme_eg()

map_dt <- data.table(x=c(max(dt$e),max(dt$e)),xend=c(max(dt$e),0),y=c(0,dt[e==max(dt$e)]$l),yend=c(dt[e==max(dt$e)]$l,dt[e==max(dt$e)]$l))

# plot the quadratic loss function
gg_loss <- ggplot()+
  geom_vline(xintercept=0,color="gray",linewidth=.4)+
  geom_segment(data=map_dt,aes(x=x,y=y,xend=xend,yend=yend),linetype=5,color="gray",linewidth=.8)+
  geom_text(data=data.table(x=rep(0,2),y=seq(5,10,5)),aes(x=x,y=y),label=seq(5,10,5),hjust=1,nudge_x=-.4,size=4.5,family="Segoe Print")+
  geom_text(data=data.table(x=c(3.1,-.65),y=c(0,7)),aes(x=x,y=y),label=c("e['5']","l(e['5'])"),hjust=.5,size=5,parse=T,family="Segoe Print")+
  geom_line(data=line_dt,aes(x=e,y=l),color="dimgray",linetype=1,linewidth=.8,na.rm=T)+
  geom_point(data=dt,aes(x=e,y=l),color="dimgray",fill="white",stroke=.5,shape=21,size=2)+
  geom_point(data=dt,aes(x=e,y=0),color="dimgray",fill="lightgray",stroke=1,shape=21,size=2.5)+
  geom_point(data=dt,aes(x=0,y=l),color="coral",fill="lightgray",stroke=1,shape=21,size=2.5)+
  xlim(-3.5,3.5)+
  ylim(0,11)+
  coord_flip()+
  theme_eg()+
  theme(axis.title=element_blank(),axis.text=element_blank(),axis.line=element_blank())

# combine the two graphs
gg_comb <- plot_grid(gg_errors,gg_loss,align="hv",ncol=2,rel_widths = c(2,2))

gg_comb

ggsave("figures/c1/loss.png",gg_comb,width=6.5,height=3.75,dpi="retina",device="png")
ggsave("figures/c1/loss.eps",gg_comb,width=6.5,height=3.75,dpi="retina",device=cairo_ps)

