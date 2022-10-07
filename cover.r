library(data.table)
library(wordcloud2)
library(htmlwidgets)
library(webshot2)
library(stringr)


edu <- data.table(Term="Educated",Count=155)
guess <- data.table(Term="Guess",Count=320)

sub0 <- "An Intuitive Guide to Forecasting With Time Series Models Using R"

sub1 <- data.table(Term="Using R",Count=seq(24,36,2))
sub2 <- data.table(Term="Forecasting",Count=seq(20,40,5))
sub3 <- data.table(Term="Time Series",Count=seq(21,33,3))
sub4 <- data.table(Term="An Intuitive Guide",Count=seq(10,20,2))
sub5 <- data.table(Term="Time Series Models",Count=seq(12,24,4))
sub6 <- data.table(Term="Guide to Forecasting",Count=seq(6,15,3))
sub7 <- data.table(Term="Forecasting with Time Series",Count=2:5)

sub8 <- c(str_split(sub0," ",simplify = T))

sub9 <- as.data.table(table(sample(sub8,100,replace=T)))
colnames(sub9) <- c("Term","Count")

allwords_dt <- Reduce(rbind,list(edu,guess,sub1,sub2,sub3,sub4,sub5,sub6,sub7,sub9))

cover <- wordcloud2(data=allwords_dt,color=ifelse(allwords_dt[, 2]>=100,'coral','darkgray'),shuffle=F,rotateRatio = .6)

cover

saveWidget(cover,"cover.html",selfcontained = F)

webshot2::webshot("cover.html","cover.png",delay=1,vwidth=720,vheight=480)
