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

# library(ggplot2)
# library(data.table)
# library(fastDummies)
# 
# miles$month <- month(miles$date)
# miles_dum <- dummy_cols(miles$month,remove_selected_columns=T)
# colnames(miles_dum) <- paste0("d",c(1:12))
# 
# miles <- cbind(miles,miles_dum)

# Initial claims ----
claims_dt <- fread("Claims.csv")

ggplot(claims_dt,aes(x=DATE,y=ICNSA))+
  geom_line()

sub_dt <- claims_dt[DATE>=as.Date("1993-01-01") & DATE<=as.Date("2008-12-31")]

ggplot(sub_dt,aes(x=DATE,y=ICNSA))+
  geom_line()

claims <- data.table(date=as.Date(sub_dt$DATE),y=as.numeric(sub_dt$ICNSA))

save(claims,file="claims.RData")

# period <- 52.1429
# 
# claims[,`:=`(t=c(1:nrow(claims)))]
# 
# claims[,`:=`(sin1=sin(2*pi*1*t/period),cos1=cos(2*pi*1*t/period),sin2=sin(2*pi*2*t/period),cos2=cos(2*pi*2*t/period))]
# 
# est <- lm(y~sin1+cos1+sin2+cos2,data=claims)
# 
# claims$haty <- fitted(est)
# 
# ggplot(claims,aes(x=date,y=y))+
#   geom_line()+
#   geom_line(aes(y=haty),color="coral")


# Exchange rates ----
rates_dt <- fread("ExchangeRates.csv")

ggplot(rates_dt,aes(x=DATE,y=EXUSEU))+
  geom_line()

sub_dt <- rates_dt[DATE>=as.Date("2004-01-01") & DATE<=as.Date("2014-12-31")]

ggplot(sub_dt,aes(x=DATE,y=EXUSEU))+
  geom_line()

exchange_rates <- data.table(date=as.Date(sub_dt$DATE),y=as.numeric(sub_dt$EXUSEU))

save(exchange_rates,file="exchange_rates.RData")



# Bitcoin ----
bitcoin_dt <- fread("Bitcoin.csv")
bitcoin_dt[,`:=`(Date=as.Date(Date,format="%m/%d/%Y"))]

ggplot(bitcoin_dt,aes(x=Date,y=Value))+
  geom_line()

sub_dt <- bitcoin_dt[Date>=as.Date("2020-01-01") & Date<=as.Date("2021-12-31")]

ggplot(sub_dt,aes(x=Date,y=Value))+
  geom_line()

bitcoin <- data.table(date=as.Date(sub_dt$Date),y=as.numeric(sub_dt$Value))

bitcoin <- bitcoin[order(date)]

save(bitcoin,file="bitcoin.RData")


# Financial stress ----
stress_dt <- fread("Stress.csv")

ggplot(stress_dt,aes(x=DATE,y=STLFSI3))+
  geom_line()

sub_dt <- stress_dt[DATE>=as.Date("2010-01-01") & DATE<=as.Date("2019-12-31")]

ggplot(sub_dt,aes(x=DATE,y=STLFSI3))+
  geom_line()

stress <- data.table(date=as.Date(sub_dt$DATE),y=as.numeric(sub_dt$STLFSI3))

save(stress,file="stress.RData")

