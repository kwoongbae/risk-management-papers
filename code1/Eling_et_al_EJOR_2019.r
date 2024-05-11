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

sas <- read.csv("./dataset/SAS.csv")
sas$Month...Year.of.Settlement <- ymd(sas$Month...Year.of.Settlement)
sas <- subset(sas, Month...Year.of.Settlement < ymd("2014-03-01"))
sas <- subset(sas, Month...Year.of.Settlement > ymd("1995-01-01"))
sas <- sas[sas$cyber_risk==1,]
length(sas$Loss.Amount...M.) # Length is 1593 (In Eling 2019, length is 1579)

# ===================================================
# 2. Goodness-of-fit analysis : severity
# ===================================================

loss <- sas$Loss.Amount...M.
plotdist(loss)

# Fit on Exponential distribution
exp.model <- eexp(loss, method = "mle") # rate = 0.02770837
exp.loglik <- sum(dexp(x=loss, rate = exp.model$param["rate"], log=T))
exp.loglik # -7305.53 (In paper, -7535.78)

# Fit on Gamma distribution
gam.model <- egamma(loss, method = "mle") # shape=0.2416648, scale=149.3397808
gam.loglik <- sum(dgamma(x=loss, shape = gam.model$param["shape"], scale = gam.model$param["scale"], log=T))
gam.loglik # -5183.15 (In paper, -5368.23)

# Fit on GPD distribution
gpd.u <- quantile(loss, probs = 0.9, type = 1)
gpd.model <- fitgpd(loss, gpd.u, "mle") #scale=60.9383, shape=0.9742
gpd.loglik <- sum(
    dgpd(x=loss, gpd.u, gpd.model$param["scale"], gpd.model$param["shape"], log = T)
)
gpd.loglik # -Inf (In paper, -4553.42)

# Fit on Log-logistic distribution
llogis_model <- fitdist(loss, "llogis", method = "mle") #shape=0.868823, scale=1.591586
llogis.loglik <- llogis_model$loglik
llogis.loglik # -4399.835 (In paper, -4588.09)

# Fit on Weibull distribution
wei_model <- fitdist(loss, "weibull", method = "mle")
weibull.loglik <- wei_model$loglik
weibull.loglik # -4700.99 (In paper, -4886.78)

# Fit on Skew-normal distribution
snorm_model <- snormFit(loss)
snorm.loglik <- sum(
    dsnorm(x=loss, 
           mean=snorm_model$par["mean"], 
           sd=snorm_model$par["sd"],
           xi=snorm_model$par["xi"], log=T)
)
snorm.loglik # -10503.05

# ===================================================
# 2.1 Goodness-of-fit analysis : severity with POT 56%
# ===================================================

loss.56 <- sort(loss)[1:round(length(loss)*0.56)]
loss.44 <- sort(loss)[round(length(loss)*0.56+1):round(length(loss))]
plotdist(loss.56)
plotdist(loss.44)

# Fit on GPD distribution (Tail 44% distribution)
gpd.u <- quantile(loss, probs = 0.59, type = 1)
gpd.model <- fitgpd(loss.44, gpd.u, "mle") #scale=60.9383, shape=0.9742
gpd.loglik <- sum(
    dgpd(x=loss, gpd.u, gpd.model$param["scale"], gpd.model$param["shape"], log = T)
)
gpd.loglik # -Inf (In paper, -4553.42)


