library(data.table)
library(ggplot2)

# Interest rates ----
int_dt <- fread("InterestRates.csv")

ggplot(int_dt,aes(x=DATE,y=MORTGAGE30US))+
  geom_line()

sub_dt <- int_dt[DATE>=as.Date("1991-01-01") & DATE<=as.Date("2020-12-31")]

ggplot(sub_dt,aes(x=DATE,y=MORTGAGE30US))+
  geom_line()

interest_rates <- data.table(date=as.Date(sub_dt$DATE),y=as.numeric(sub_dt$MORTGAGE30US))

save(interest_rates,file="interest_rates.RData")


# Miles traveled ----
miles_dt <- fread("Miles.csv")

ggplot(miles_dt,aes(x=DATE,y=VMT))+
  geom_line()

sub_dt <- miles_dt[DATE>=as.Date("2003-01-01") & DATE<=as.Date("2015-12-31")]

ggplot(sub_dt,aes(x=DATE,y=VMT))+
  geom_line()

miles <- data.table(date=as.Date(sub_dt$DATE),y=as.numeric(sub_dt$VMT))

save(miles,file="miles.RData")

library(ggplot2)
library(data.table)
library(fastDummies)

miles$month <- month(miles$date)
miles_dum <- dummy_cols(miles$month,remove_selected_columns=T)
colnames(miles_dum) <- paste0("d",c(1:12))

miles <- cbind(miles,miles_dum)

claims_dt <- fread("Claims.csv")

ggplot(claims_dt,aes(x=DATE,y=ICNSA))+
  geom_line()

sub_dt <- claims_dt[DATE>=as.Date("1993-01-01") & DATE<=as.Date("2008-12-31")]

ggplot(sub_dt,aes(x=DATE,y=ICNSA))+
  geom_line()

claims <- data.table(date=as.Date(sub_dt$DATE),y=as.numeric(sub_dt$ICNSA))

save(claims,file="claims.RData")

period <- 52.1429

claims[,`:=`(t=c(1:nrow(claims)))]

claims[,`:=`(sin1=sin(2*pi*1*t/period),cos1=cos(2*pi*1*t/period),sin2=sin(2*pi*2*t/period),cos2=cos(2*pi*2*t/period))]

est <- lm(y~sin1+cos1+sin2+cos2,data=claims)

claims$haty <- fitted(est)

ggplot(claims,aes(x=date,y=y))+
  geom_line()+
  geom_line(aes(y=haty),color="coral")


