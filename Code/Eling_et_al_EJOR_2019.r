library("rlang")
library("ggplot2")
library("MASS")
library("fitdistrplus")

sas <- read.csv("./dataset/SAS.csv")
sas <- sas[sas$cyber_risk==1,]
colnames(sas)

sas.loss <- sas$Loss.Amount...M.
length(sas.loss)

plotdist(sas.loss)

lnorm_model <- fitdist(sas.loss, "lnorm", method = "mle") # log-normal
llnorm.loglik <- lnorm_model$loglik

llnorm.loglik

sort(sas.loss)

total_rows <- length(sort(sas.loss))
number.90 <- round(total_rows * 0.9)
sas.loss.90 <- sort(sas.loss)[1:number.90]

lnorm_model.90 <- fitdist(sas.loss.90, "lnorm", method = "mle") # log-normal
llnorm.90.loglik <- lnorm_model.90$loglik
llnorm.90.loglik

lnorm_model.90$aic

number.56 <- round(total_rows * 0.56)
sas.loss.56 <- sort(sas.loss)[1:number.56]

lnorm_model.56 <- fitdist(sas.loss.56, "lnorm", method = "mle") # log-normal
llnorm.56.loglik <- lnorm_model.56$loglik
llnorm.56.loglik


