library(data.table)
library(wordcloud2)
library(htmlwidgets)
library(webshot2)
library(stringr)


edu <- data.table(Term="Educated",Count=182)
guess <- data.table(Term="Guess",Count=375)

sub0 <- "An Intuitive Guide to Forecasting With Time Series Models Using R"

sub1 <- data.table(Term="Using R",Count=unique(round(exp(seq(1,4,.35)))))
sub2 <- data.table(Term="Forecasting",Count=unique(round(exp(seq(1,4,.5)))))
sub3 <- data.table(Term="Time Series",Count=unique(round(exp(seq(1,3.5,.2)))))
sub4 <- data.table(Term="An Intuitive Guide",Count=unique(round(exp(seq(1,3,.15)))))
sub5 <- data.table(Term="Time Series Models",Count=unique(round(exp(seq(1,3,.15)))))
sub6 <- data.table(Term="Guide to Forecasting",Count=unique(round(exp(seq(.5,2.5,.1)))))
sub7 <- data.table(Term="Forecasting with Time Series",Count=unique(round(exp(seq(.5,2,.1)))))

sub8 <- c(str_split(sub0," ",simplify = T))

set.seed(1)
sub9 <- as.data.table(table(sample(sub8,120,replace=T)))
colnames(sub9) <- c("Term","Count")

allwords_dt <- Reduce(rbind,list(edu,guess,sub1,sub2,sub3,sub4,sub5,sub6,sub7,sub9))

# square cover
cover <- wordcloud2(data=allwords_dt,color=ifelse(allwords_dt[, 2]>=100,'coral','darkgray'),backgroundColor = "white",shuffle=F,rotateRatio = .6,ellipticity = 0.6)

saveWidget(cover,"cover.html",selfcontained=F)

webshot2::webshot("cover.html","cover.png",delay=1,vwidth=650,vheight=500)

# narrow cover
cover_narrow <- wordcloud2(data=allwords_dt,color=ifelse(allwords_dt[, 2]>=100,'coral','darkgray'),backgroundColor = "white",shuffle=F,rotateRatio = .6,ellipticity = 0.4)

saveWidget(cover_narrow,"cover_narrow.html",selfcontained=F)

webshot2::webshot("cover_narrow.html","cover_narrow.png",delay=1,vwidth=1500,vheight=500)
