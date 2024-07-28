# =====================================================================================================
# Import libraries and SAS OpRisk Global dataset
# SAS dataset, length is 1758

# Statistics of Loss amount
# Min     1st Qu.     Median    Mean     3rd Qu.     Max.
# 0.100   0.383       1.395     36.274   6.795       12180.700
# =====================================================================================================
install.packages("quantmod")

library("rlang")
library("ggplot2")
library("MASS") # import plotdist
library("fitdistrplus") #fitdist
library("POT") # import fitgpd
library("quantmod")
library("lubridate")
library("evmix")
library("psych")

getwd()
sas <- read.csv("../../dataset/SAS.csv")
sas$Month...Year.of.Settlement <- ymd(sas$Month...Year.of.Settlement)
sas <- subset(sas, Month...Year.of.Settlement < ymd("2015-01-01"))
sas <- subset(sas, Month...Year.of.Settlement > ymd("1995-01-01"))
sas <- sas[sas$cyber_risk==1,]
length(sas$Reference.ID.Code)

length(sas$Loss.Amount...M.) # Length is 1593
colnames(sas)
describe(sas$Loss.Amount...M.)
summary(sas$Loss.Amount...M.)

# =====================================================================================================
# Operational Cyber Risk
# cyber risk on insurance company
# =====================================================================================================

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




# =====================================================================================================
# Underwriting Cyber Risk
# s = coefficients of volatility
# v = volume measure. E[X]/b
# scr = 3sv
# =====================================================================================================

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
plotdist(log(sas$Loss.Amount...M.))

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
plotdist(X)


# (5) summary
mean(Z) # in paper, 43.9
sd(Z) # in paper, 429.9
mean(log(Z)) # in paper, mean(ln(Z)) is 0.8
sd(log(Z)) # in paper, std(ln(Z)) is 2.1
mean(X) # in paper, E[X] is 3.2
sd(X) # in paper, std(X) is 116.4
quantile(X, 0.995)
mean(X[X > quantile(X, 0.99)])


# =====================================================================================================
# Clayton copula
# =====================================================================================================


library(copula)

theta <- 0.5  # 상관계수 0.2에 대응하는 클레이튼 코퓰라 파라미터
clayton_copula <- claytonCopula(param = theta, dim = 2)


num_simulations <- 50
for (i in 1:num_simulations) {
  # 코퓰라 샘플 생성
  copula_samples <- rCopula(1, clayton_copula)
  
  # 빈도 샘플 생성 (음이항 분포)
  N <- qnbinom(copula_samples[, 1], size = nbinom.est$estimate["size"], mu = nbinom.est$estimate["mu"]) + 1
  
  # 심도 샘플 생성 (로그-정규 + GPD)
  if (N > 0) {
    Z <- rlognormgpd(N,
                     lnmean = lnorm_model$estimate["meanlog"],
                     lnsd = lnorm_model$estimate["sdlog"],
                     u = 2,
                     sigmau = gpd.model$fitted.values["scale"],
                     xi = gpd.model$fitted.values["shape"])
    total_losses[i] <- sum(Z)
  } else {
    total_losses[i] <- 0
  }
}

plotdist(total_losses)

























# examples codes ---------------------------------------------------------------------------
library("copula")
?claytonCopula
clayton_object <- claytonCopula(param = 0.5, dim=2) 
# with dependency parameter corresponding to a correlation of 0.2
# tau is 0.2, so theta is 0.5
clayton_object


copula_samples <- rCopula(1000, clayton_object)
q <- qnbinom(copula_samples[,1]
             , size=nbinom.est$estimate["size"]
             , mu=nbinom.est$estimate["mu"] )

losses <- sapply(q, function(n) sum(sample(Y, n, replace = TRUE)))

plotdist(losses)





  





cdf_function <- function(x) {
  ifelse(x < 0, 0, 1 - exp(-x))
}

# Numerical differentiation to get PDF
pdf_function <- function(x, delta = 1e-5) {
  (cdf_function(x + delta) - cdf_function(x - delta)) / (2 * delta)
}

# Example usage
x_values <- seq(0, 5, by = 0.1)
pdf_values <- sapply(x_values, pdf_function)
plotdist(pdf_values)


# Plotting the PDF
plot(x_values, pdf_values, type = "l", col = "blue", lwd = 2,
     main = "PDF derived from CDF",
     xlab = "x", ylab = "Density")





















library(copula)
library(mvtnorm)
library(ggplot2)

# 첫 번째 변수의 로그정규분포 모수
mu1 <- 0
sigma1 <- 0.2

# 두 번째 변수의 로그정규분포 모수
mu2 <- 1
sigma2 <- 0.5

# Clayton Copula 설정
theta <- 2  # Clayton Copula의 매개변수
clayton_copula <- claytonCopula(param = theta, dim = 2)

# 샘플 사이즈 설정
sample_size <- 10000

# Copula를 이용하여 의존 구조가 있는 샘플 생성
u <- rCopula(sample_size, clayton_copula)

# 마진 분포를 이용하여 샘플 변환
x1 <- qlnorm(u[,1], meanlog = mu1, sdlog = sigma1)
x2 <- qlnorm(u[,2], meanlog = mu2, sdlog = sigma2)

# 결합 데이터
data <- data.frame(x1 = x1, x2 = x2)

# 2D 히트맵을 이용한 결합 분포 시각화
ggplot(data, aes(x = x1, y = x2)) +
  geom_bin2d(bins = 50) +
  scale_fill_gradient(low = "white", high = "blue") +
  labs(title = "Joint Distribution of Lognormal Variables with Clayton Copula",
       x = "Variable 1",
       y = "Variable 2") +
  theme_minimal()

# CDF 계산
cdf_values <- apply(data, 1, function(row) {
  pCopula(c(qlnorm(pnorm(row[1], meanlog = mu1, sdlog = sigma1)),
            qlnorm(pnorm(row[2], meanlog = mu2, sdlog = sigma2))), clayton_copula)
})
cdf_values
# CDF 시각화
ggplot(data, aes(x = x1, y = x2, color = cdf_values)) +
  geom_point() +
  scale_color_gradient(low = "blue", high = "red") +
  labs(title = "CDF of Lognormal Variables with Clayton Copula",
       x = "Variable 1",
       y = "Variable 2",
       color = "CDF") +
  theme_minimal()













