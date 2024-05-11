# ===================================================
# 1. Import libraries and SAS OpRisk Global dataset
# ===================================================

library("rlang")
library("ggplot2")
library("MASS") # import plotdist
library("fitdistrplus") #fitdist
library("lubridate") # transform to ymd
library("EnvStats") # import eexp
library("POT") # import fitgpd
library("extraDistr")
library("actuar") # fitdist on log-logistic
library("sn") # import snormFit
library("fGarch") # snormFit
library("evmix") #fgammagpd

sas <- read.csv("./dataset/SAS.csv")
sas$Month...Year.of.Settlement <- ymd(sas$Month...Year.of.Settlement)
sas <- subset(sas, Month...Year.of.Settlement < ymd("2015-01-01"))
sas <- subset(sas, Month...Year.of.Settlement > ymd("1995-01-01"))
sas <- sas[sas$cyber_risk==1,]
length(sas$Loss.Amount...M.) # Length is 1593
colnames(sas)

summary(sas$Shareholder.Equity...M.)

summary(sas$Assets...M.)

# ===================================================
# Operational Cyber Risk
# ===================================================
unique(sas$Basel.Business.Line...Level.1)

insurance_sas <- sas[sas$Basel.Business.Line...Level.1=="Insurance",]
length(insurance_sas$Shareholder.Equity...M.) #Length is 100

# removing missing values
insurance_sas <- insurance_sas[!is.na(insurance_sas$Shareholder.Equity...M.),]
insurance_sas <- insurance_sas[!is.na(insurance_sas$Revenue...M.),]
insurance_sas <- insurance_sas[!is.na(insurance_sas$Assets...M.),]
length(insurance_sas$Assets...M.) #Length is 92

# calculate scr_op=min(0.3*bscr, bc)
insurance_sas$Shareholder.Equity...M.
insurance_sas$bscr <- 0.3*(insurance_sas$Shareholder.Equity...M./2.11) #0.3bscr
insurance_sas$bscr
insurance_sas$bc <- pmax(0.035*insurance_sas$Revenue...M., 0.017*(insurance_sas$Assets...M.- insurance_sas$Shareholder.Equity...M.))

insurance_sas$op <- pmin(insurance_sas$bscr, insurance_sas$bc)

#insurance_sas$op
#c(min(insurance_sas$op),max(insurance_sas$op), length(insurance_sas$op))
#c(min(insurance_sas$Loss.Amount...M.),max(insurance_sas$Loss.Amount...M.), length(insurance_sas$Loss.Amount...M.))

plot(insurance_sas$op, insurance_sas$Loss.Amount...M., 
     xlab = "SCR_op", ylab = "Cyber Losses", 
     xlim = c(10, 15000),
     ylim = c(0, 500),
     main = "Operational Cyber Risk")

# y=x 그래프 추가
abline(a = 0, b = 1, col = "red")

# 그래프에 각 케이스 점으로 추가
points(insurance_sas$op, insurance_sas$Loss.Amount...M., col = "black")

cnt <- sum(insurance_sas$op < insurance_sas$Loss.Amount...M.)
cnt # the number of underestimated cases is 3

# ===================================================
# 5. Underwriting Cyber Risk
# ===================================================

