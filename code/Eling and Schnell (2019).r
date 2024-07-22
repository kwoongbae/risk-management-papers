# ============================================================
# Import libraries and SAS OpRisk Global dataset
# ============================================================
install.packages("psych")

library("rlang")
library("ggplot2")
library("MASS") # import plotdist
library("fitdistrplus") #fitdist
library("POT") # import fitgpd
library("quantmod")
library("lubridate")
library("evmix")
library("psych")

sas <- read.csv("../../dataset/SAS.csv")
sas$Month...Year.of.Settlement <- ymd(sas$Month...Year.of.Settlement)
sas <- subset(sas, Month...Year.of.Settlement < ymd("2015-01-01"))
sas <- subset(sas, Month...Year.of.Settlement > ymd("1995-01-01"))
sas <- sas[sas$cyber_risk==1,]
length(sas$Loss.Amount...M.) # Length is 1593
colnames(sas)
describe(sas$Loss.Amount...M.)

# ============================================================
# Operational Cyber Risk
# ============================================================
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

# ============================================================
# Underwriting Cyber Risk
# s = coefficients of volatility
# v = volume measure. E[X]/b
# scr = 3sv
# ============================================================

# CALCULATE THE COEFFICIENT OF VOLATILITY
# (1) summarize the coeffcients referred by EC(2015)
# (2) premium and reserve risk / catastrophe risk
# (3) total finalize

### referred by EC(2015) annex II
s.general_liability_p <- 0.14
s.general_liability_r <- 0.11

s.legal_expenses_p <- 0.07
s.legal_expenses_r <- 0.12

s.mis_financial_p <- 0.13
s.mis_financial_r <- 0.20

### referred by EC (2015) annex XI and XII
s.liability <- 1/3
s.other_cat_risk <- 0.4/3

corr.cat <- 0


### calculate s of 3 LoBs
s.general_liability <- round(sqrt((s.general_liability_p/2)^2+(s.general_liability_r/2)^2+2*0.5*(s.general_liability_p/2)*(s.general_liability_r/2)),2)
s.legal_expenses <- round(sqrt((s.legal_expenses_p/2)^2+(s.legal_expenses_r/2)^2+2*0.5*(s.legal_expenses_p/2)*(s.legal_expenses_r/2)),2)
s.mis_financial <- round(sqrt((s.mis_financial_p/2)^2+(s.mis_financial_r/2)^2+2*0.5*(s.mis_financial_p/2)*(s.mis_financial_r/2)),2)


### calculate s of premium and reserve risk
s.premium_reserve <- round(sqrt((s.general_liability/3)^2
             +(s.legal_expenses/3)^2+(s.mis_financial/3)^2
             +(s.general_liability/3)*((s.legal_expenses/3)+(s.mis_financial/3))
             +(s.legal_expenses/3)*(s.mis_financial/3)),2)
s.premium_reserve

### calculate s of catastrophe risk
s.catastrophe <- round(sqrt((s.liability/2)^2 + (s.other_cat_risk/2)^2),2)
s.catastrophe

### calculate s of non-life module
corr.non_life <- 0.25

s.non_life <- round(sqrt(s.premium_reserve^2 
                   + (s.catastrophe/2)^2 
                   + 2*corr.non_life
                   *s.premium_reserve
                   *(s.catastrophe/2)),2)

s.non_life

# CALCUATE THE VOLUME MEASURE(v)
# (1) estimate the distributions
# (2) truncate the severity distribution
# (3) LDA with MCMC simulation
# (4) underwriting with 50 policies
# (5) summary

### (1)-1 estimate the frequency distribution
sas$date_year <- as.Date(paste0(format(as.Date(sas$Month...Year.of.Settlement)
                                       , "%Y-%m"), "-01"))
freq.data <- data.frame(table(sas$date_year))
colnames(freq.data) <- c("date", "num")
freq.data$date <- as.Date(freq.data$date)
freq.data

all.dates <- seq(min(as.Date(sas$date_year)), max(as.Date(sas$date_year))
                 , by = "1 month")
missing.dates <- as.Date((setdiff(as.Date(all.dates), as.Date(sas$date_month))))
missing.dates.df <- data.frame(date_column = missing.dates, value = 0)
colnames(missing.dates.df) <- c("date", "num")
missing.dates.df$num <- as.integer(missing.dates.df$num)
combined.freq <- rbind(freq.data, missing.dates.df)
final.freq <- combined.freq[order(combined.freq$date), ]

plotdist(final.freq$num)

nbinom.est <- fitdist(final.freq$num, "nbinom")
nbinom.est

### (1)-2 estimate the severity distribution
threshold <- 2
loss.body <- sas$Loss.Amount...M.[sas$Loss.Amount...M.<threshold]
loss.tail <- sas$Loss.Amount...M.[sas$Loss.Amount...M.>= threshold]

lnorm_model <- fitdist(loss.body, "lnorm", method = "mle")
gpd.model <- fitgpd(loss.tail, 0, "mle")

lnorm_model
gpd.model


# (2) truncate the severity distribution
Z <- pmin(Z, 50)
mean(Z)
sd
plotdist(Z)


### (3) LDA with MCMC simulation
num_simulations <- 50
total_losses <- numeric(num_simulations)

for (i in 1:num_simulations){
  N <- rnbinom(1
               ,size=nbinom.est$estimate["size"]
               , mu=nbinom.est$estimate["mu"] )+1
  
  Z <- rlognormgpd(N,
                   lnmean = lnorm_model$estimate["meanlog"],
                   lnsd = lnorm_model$estimate["sdlog"],
                   u = 2,
                   sigmau = gpd.model$fitted.values["scale"],
                   xi = gpd.model$fitted.values["shape"])

  total_losses[i] <- sum(Z)
}
X <- total_losses

# (5) summary
mean(Z) # in paper, 43.9
sd(Z) # in paper, 429.9
mean(log(Z)) # in paper, mean(ln(Z)) is 0.8
sd(log(Z)) # in paper, std(ln(Z)) is 2.1
mean(X) # in paper, E[X] is 3.2
sd(X) # in paper, std(X) is 116.4
quantile(X, 0.995)
mean(X[X > quantile(X, 0.99)])




# ============================================================
# Clayton copula
# ============================================================


# To be continued...












