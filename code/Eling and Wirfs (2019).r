# ==============================================================================
# Import libraries and SAS OpRisk Global dataset
# ==============================================================================

# install.packages("goftest")
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
library("stringr") #str_replace_all
library("psych")
library("goftest")
library("evir")
library("mev")


getwd()
sas <- read.csv("../../../../05. 개인자료/01. 깃허브 레포지토리/dataset/SAS.csv")
length(sas$Reference.ID.Code)
sas$Month...Year.of.Settlement <- ymd(sas$Month...Year.of.Settlement)
sas <- subset(sas, Month...Year.of.Settlement < ymd("2014-03-01"))
sas <- subset(sas, Month...Year.of.Settlement > ymd("1995-01-01"))

# ==============================================================================
# Extract the cases of cyber risk using keywords.
# ==============================================================================

# function for extract the cases using keywords
cases_extract <- function(df, words1, words2, words3) {
  extracted_ids <- c()
  
  id_column <- colnames(df)[1]
  description_column <- colnames(df)[2]
  
  for (i in 1:nrow(df)) {
    description_text <- tolower(df[i, description_column])
    
    description_text <- str_replace_all(description_text, "[[:punct:]]", " ")
    splitted_description <- unlist(strsplit(description_text, " "))
    
    cnt <- 0
    
    if (any(words1 %in% splitted_description) && length(words1) >= 1) {
      cnt <- cnt + 1
    }
    if (any(words2 %in% splitted_description) && length(words2) >= 1) {
      cnt <- cnt + 1
    }
    if (any(words3 %in% splitted_description) && length(words3) >= 1) {
      cnt <- cnt + 1
    }
    
    if (cnt == 3) {
      extracted_ids <- c(extracted_ids, df[i, id_column])
    }
  }
  return(extracted_ids)
}

critical_assets = c("account", "accounting system", "address", "code",
                    "communication", "computer", "computer system", "confidential",
                    "confidential document", "cousumer information", "data",
                    "disk", "document", "file", "hard-disk", "hard-drive", "homepage",
                    "info", "information system", "internet site","names",
                    "network", "numbers", "online banking", "payment system",
                    "pc", "personal information", "record", "reports", "server",
                    "site", "social security number", "stored information",
                    "tablet", "trade secret", "webpage", "website")

actor = c("administrator", "deadline", "dos", "destruction", "devastation",
          "employee", "extortion", "forgot", "forget", "forgotten", "hacker",
          "hacked", "hacking", "human error", "infect", "infection", "infiltrate",
          "infiltrated", "key logger", "lapse", "logic bomb", "maintenance", 
          "malicious code", "malware", "manager", "manipulate", "miscommunication",
          "mistake", "misuse", "omission", "online attack", "oversight", "phish",
          "phishing", "spam", "trojan", "vandalism", "virus", "worm", "defect",
          "hardware", "loading", "software", "stress", "system crash", 
          "unauthorized access", "blizzard", "earthquake", "eruption", "explosion",
          "fire", "flood", "hail", "heat wave", "hurricane", "lightning",
          "natural catastrophe", "outage", "pipe burst", "riot", "smoke", "storm",
          "thunder", "tornado", "tsunami", "typhoon", "unrest", "utilities",
          "war", "weather", "wind")

outcome = c("availability", "available", "breach", "breakdown", "confidential",
            "congestion", "constrain", "control", "delete", "deletion", "disclosure",
            "disorder", "disruption", "distrubance", "encryption", "espionage",
            "failure", "false", "falsification", "falsified", "falsifying",
            "incompatibility", "incompatible", "incomplete", "integrity",
            "interruption", "limit", "lose", "loss", "lost", "malfunction",
            "missing", "modification", "modified", "modify", "overload",
            "publication", "restrict", "sabotage", "steal", "stole", "theft")

cyber_id <- cases_extract(sas[, c("Reference.ID.Code", "Description.of.Event")], 
                          critical_assets, actor, outcome)

cyber_risk <- sas[sas$Reference.ID.Code %in% cyber_id,]
non_cyber_risk <- sas[!sas$Reference.ID.Code %in% cyber_id,]
length(cyber_risk$Reference.ID.Code)
length(non_cyber_risk$Reference.ID.Code)



# ==============================================================================
# Goodness-of-fit (Frequency distribution)
# ==============================================================================

# monthly
# dates <- as.Date(paste0(format(as.Date(cyber_risk$Month...Year.of.Settlement), "%Y-%m"), "-01"))
dates <- as.Date(paste0(format(as.Date(non_cyber_risk$Month...Year.of.Settlement), "%Y-%m"), "-01"))

# yearly
# dates <- as.Date(paste0(format(as.Date(cyber_risk$Month...Year.of.Settlement), "%Y"), "-01-01"))
# dates <- as.Date(paste0(format(as.Date(non_cyber_risk$Month...Year.of.Settlement), "%Y"), "-01-01"))

dates_df <- data.frame(table(dates))
colnames(dates_df) <- c("date", "num")
dates_df
dates_df$date <- as.Date(dates_df$date)
plotdist(dates_df$num)

### monthly
all_dates <- seq(min(as.Date(dates)), max(as.Date(dates)), by = "1 month")
dates_missed <- as.Date((setdiff(as.Date(all_dates), as.Date(dates))))
all_dates

dates_missed_df <- data.frame(date_column = dates_missed, value = 0)
colnames(dates_missed_df) <- c("date", "num")
dates_missed_df$num <- as.integer(dates_missed_df$num)
dates_df
dates_missed_df

merged_dates_df <- rbind(dates_df, dates_missed_df)
N <- merged_dates_df[order(merged_dates_df$date), ]$num

### yearly
# N <- dates_df$num

plotdist(N)
total_length <- length(N)

#### estimation ####
poisson_fit <- fitdist(N, "pois")
summary(poisson_fit)
negbinom_fit <- fitdist(N, "nbinom")
summary(negbinom_fit)


# ------------------------------------------------------------------------------
### cyber risk ###
## poisson
# yearly --> loglik: -574.6948(-622.18), AIC: 1151.39(1246.36)
# monthly --> loglik: -1055.39(-958.49), AIC: 2112.781(1918.97)
## negbinom
# yearly --> loglik: -109.19(107.39), AIC: 222.39(218.78)
# monthly --> loglik: -713.09(-345.57), AIC: 1430.183(695.15)

### non-cyber risk ###
## poisson
# yearly --> loglik: -3224.97(-3267.56), AIC: 6451.941(6537.12)
# monthly --> loglik: -19642.36(-10327.28), AIC: 39286.72(20656.55)
## negbinom
# yearly --> loglik: -156.665(-157.08), AIC: 317.33(318.16)
# monthly --> loglik: -1758.869(-651.46), AIC: 3521.737(1306.93)
# ------------------------------------------------------------------------------

### Test ###

# generate samples
fitp <- dpois(as.integer(names(table(N))), poisson_fit$estimate["lambda"])
fitnb <- dnbinom(as.integer(names(table(N))), size = negbinom_fit$estimate["size"], mu = negbinom_fit$estimate["mu"])

# Chi-square test
chi_test_poisson <- chisq.test(N, pois_data)
chi_test_poisson
chi_test_negbinom <- chisq.test(N, nbinom_data)
chi_test_negbinom

# Kolmogorov-Smirnov-test
ks_test_poisson <- ks.test(N, "ppois", lambda=poisson_fit$estimate["lambda"])
ks_test_poisson
ks_test_negbinom <- ks.test(N, "pnbinom", size = negbinom_fit$estimate["size"], mu = negbinom_fit$estimate["mu"])
ks_test_negbinom


# ------------------------------------------------------------------------------
### cyber risk ###
## poisson
# yearly --> Chi-square: (1130.08***), KS: 0.499***(0.500***)
# monthly --> Chi-square: (1261.22***), KS: 0.33416***(0.611***)
## negbinom
# yearly --> Chi-square: (100.49***), KS: 0.177(0.218)
# monthly --> Chi-square: (35.40**), KS: 0.13522***(0.699***)

### non-cyber risk ###
## poisson
# yearly --> Chi-square: (>10000.00***), KS: 0.5***(0.500***)
# monthly --> Chi-square: (19719.11***), KS: 0.4148***(0.661***)
## negbinom
# yearly --> Chi-square: (194.33***), KS: 0.227(0.235)
# monthly --> Chi-square: (367.49***), KS: 0.14748***(0.627***)
# ------------------------------------------------------------------------------


# ==============================================================================
# Goodness-of-fit (Severity distribution, POT 100%)
# ==============================================================================

Z <- cyber_risk$Loss.Amount...M.
# Z <- non_cyber_risk$Loss.Amount...M.
describe(Z)

# ------------------------------------------------------------------------------
### Descriptive Statistics
# cyber risk
# N          Mean         Std.dev        Median    Skewness     Kurtosis 
# 1806(1579) 61.16(43.49) 601.53(426.36) 1.6(1.53) 24.49(27.12) 724.29(873.33)

# Non-cyber risk
# N            Mean        Std.dev         Median    Skewness     Kurtosis
# 24170(24962) 75.2(98.52) 721.27(1154.39) 4.1(5.09) 40.66(49.95) 2398.34(3388.69)
# ------------------------------------------------------------------------------

exp_fit <- fitdist(Z, "exp")
summary(exp_fit)

gamma_fit <- fitdist(Z, "gamma")
summary(gamma_fit)

pareto_fit <- fitdist(Z, "pareto")
summary(pareto_fit)

llogis_fit <- fitdist(Z, "llogis")
summary(llogis_fit)

lnorm_fit <- fitdist(Z, "lnorm")
summary(lnorm_fit)

weibull_fit <- fitdist(Z, "weibull")
summary(weibull_fit)

# ------------------------------------------------------------------------------
### cyber risk ###
# exp --> loglik: -9234.825(-7535.78), AIC: 18471.65(15073.55)
# gamma --> loglik: -6382.122(-5368.23), AIC: 12768.24(10740.46)
# pareto --> loglik: -5392.887(-4553.42), AIC: 10789.77(9110.84)
# llogis --> loglik: -5444.353(-4591.40), AIC: 10892.71(9186.80)
# lnorm --> loglik: -5445.872(-4588.09), AIC: 10895.74(9180.19)
# weibull --> loglik: -5795.983(-4886.78), AIC: 11595.97(9777.57)

### non-cyber risk ###
# exp --> loglik: -131459.8(-139542.80), AIC: 262921.7(279087.60)
# gamma --> loglik: -103077.6(-109184.80), AIC: 206159.3(218373.60)
# pareto --> loglik: -93659.64(-99438.54), AIC: 187321.3(198881.10)
# llogis --> loglik: -93849.27(-99572.73), AIC: 187702.5(199149.50)
# lnorm --> loglik: -93542.97(-99258.09), AIC: 187089.9(198520.20)
# weibull --> loglik: -96912.94(-102587.30), AIC: 193829.9(205178.60)
# ------------------------------------------------------------------------------

### Test ###

# Kolmogorov-Smirnov-test
ks_exp <- ks.test(Z, "pexp", exp_fit$estimate["rate"])
ks_exp
ks_gamma <- ks.test(Z, "pgamma", shape=gamma_fit$estimate["shape"],
                    rate=gamma_fit$estimate["rate"])
ks_gamma
ks_pareto <- ks.test(Z, "ppareto", shape=pareto_fit$estimate["shape"],
                     scale=pareto_fit$estimate["scale"])
ks_pareto
ks_llogis <- ks.test(Z, "pllogis", shape=llogis_fit$estimate["shape"],
                     scale=llogis_fit$estimate["scale"])
ks_llogis
ks_lnorm <- ks.test(Z, "plnorm", meanlog=lnorm_fit$estimate["meanlog"],
                    sdlog=lnorm_fit$estimate["sdlog"])
ks_lnorm
ks_weibull <- ks.test(Z, "pweibull", shape=weibull_fit$estimate["shape"],
                     scale=weibull_fit$estimate["scale"])
ks_weibull

# Anderson-Darling-test
ad_exp <- ad.test(Z, null = "pexp", rate = exp_fit$estimate["rate"])
ad_exp
ad_gamma <- ad.test(Z, null = "pgamma", shape = gamma_fit$estimate["shape"], rate = gamma_fit$estimate["rate"])
ad_gamma

# ------------------------------------------------------------------------------
### cyber risk ###
# exp --> KS: 0.63***(0.60***), AD: (79.94***)
# gamma --> KS: 0.25***(0.24***), AD: (18.79***)
# pareto --> KS: 0.06***(0.07***), AD: (7.18***)
# llogis --> KS: 0.08***(1.00***), AD: (13.22***)
# lnorm --> KS: 0.08***(0.08***), AD: (16.99***)
# weibull --> KS: 0.17***(0.16***), AD: (60.20***)

### non-cyber risk ###
# exp --> KS: 0.53***(0.54***), AD: (58.75***)
# gamma --> KS: 0.21***(0.21***), AD: (13.10***)
# pareto --> KS: 0.03***(0.03***), AD: (50.27***)
# llogis --> KS: 0.04***(1.00***), AD: (61.63***)
# lnorm --> KS: 0.04***(0.03***), AD: (54.86***)
# weibull --> KS: 0.11***(0.10***), AD: (6.30***)
# ------------------------------------------------------------------------------


# ==============================================================================
# Goodness-of-fit (Severity distribution, POT 90%)
# ==============================================================================

Z <- cyber_risk$Loss.Amount...M.
threshold <- quantile(Z, 0.90)
threshold

body <- Z[Z<=threshold]
tail <- Z[Z>threshold]


# tail on GPD distribution
pareto_fit_tail1 <- fitdist(tail, "pareto")
pareto_fit_tail2 <- fitdist(tail - threshold, "pareto")
gpd_fit_tail1 <- fit.gpd(tail, threshold <- threshold)
gpd_fit_tail2 <- fit.gpd(tail - threshold, threshold <- threshold)
gpd_fit_tail3 <- fit.gpd(tail - threshold, threshold <- 0)
library("extRemes")
gpd_fit_tail4 <- fevd(tail)
gpd_fit_tail4

# exp
exp_fit_body <- fitdist(body, "exp")

exp_fit_body$loglik + pareto_fit_tail1$loglik
exp_fit_body$loglik + pareto_fit_tail2$loglik
exp_fit_body$loglik - gpd_fit_tail1$nllh
exp_fit_body$loglik - gpd_fit_tail2$nllh
exp_fit_body$loglik - gpd_fit_tail3$nllh
exp_fit_body$loglik - 1182.819

exp_aic <- exp_fit_body$aic+gpd_fit_tail$aic
c(exp_loglik, exp_aic)


# gamma
gamma_fit_body <- fitdist(body, "gamma")

gamma_fit_body$loglik + pareto_fit_tail1$loglik
gamma_fit_body$loglik + pareto_fit_tail2$loglik
gamma_fit_body$loglik - gpd_fit_tail1$nllh
gamma_fit_body$loglik - gpd_fit_tail2$nllh
# gamma_aic <- gamma_fit_body$aic+pareto_fit_tail$aic
# gamma_aic

?fevd

# pareto
pareto_fit_body <- fitdist(body, "pareto")

pareto_fit_body$loglik + pareto_fit_tail1$loglik
pareto_fit_body$loglik + pareto_fit_tail2$loglik
pareto_fit_body$loglik - gpd_fit_tail1$nllh
pareto_fit_body$loglik - gpd_fit_tail2$nllh

# pareto_aic <- pareto_fit_body$aic+pareto_fit_tail$aic
# pareto_aic

# log-logistic
llogis_fit_body <- fitdist(body, "llogis")

llogis_fit_body$loglik + pareto_fit_tail1$loglik
llogis_fit_body$loglik + pareto_fit_tail2$loglik
llogis_fit_body$loglik - gpd_fit_tail1$nllh
llogis_fit_body$loglik - gpd_fit_tail2$nllh

# llogis_aic <- llogis_fit_body$aic+pareto_fit_tail$aic
# llogis_aic

# log-normal
lnorm_fit_body <- fitdist(body, "lnorm")

lnorm_fit_body$loglik + pareto_fit_tail1$loglik
lnorm_fit_body$loglik + pareto_fit_tail2$loglik
lnorm_fit_body$loglik - gpd_fit_tail1$nllh
lnorm_fit_body$loglik - gpd_fit_tail2$nllh

# lnorm_loglik <- lnorm_fit_body$loglik-1243.002
# lnorm_loglik
# lnorm_aic <- lnorm_fit_body$aic+pareto_fit_tail2$aic
# lnorm_aic

# weibull
weibull_fit_body <- fitdist(body, "weibull")

weibull_fit_body$loglik + pareto_fit_tail1$loglik
weibull_fit_body$loglik + pareto_fit_tail2$loglik
weibull_fit_body$loglik - gpd_fit_tail1$nllh
weibull_fit_body$loglik - gpd_fit_tail2$nllh


# weibull_aic <- weibull_fit_body$aic+pareto_fit_tail$aic
# weibull_aic

# ------------------------------------------------------------------------------
### cyber risk ###
# exp --> loglik: -9234.825(-7535.78), AIC: 18471.65(15073.55)
# gamma --> loglik: -6382.122(-5368.23), AIC: 12768.24(10740.46)
# pareto --> loglik: -5392.887(-4553.42), AIC: 10789.77(9110.84)
# llogis --> loglik: -5444.353(-4591.40), AIC: 10892.71(9186.80)
# lnorm --> loglik: -5445.872(-4588.09), AIC: 10895.74(9180.19)
# weibull --> loglik: -5795.983(-4886.78), AIC: 11595.97(9777.57)

### non-cyber risk ###
# exp --> loglik: -131459.8(-139542.80), AIC: 262921.7(279087.60)
# gamma --> loglik: -103077.6(-109184.80), AIC: 206159.3(218373.60)
# pareto --> loglik: -93659.64(-99438.54), AIC: 187321.3(198881.10)
# llogis --> loglik: -93849.27(-99572.73), AIC: 187702.5(199149.50)
# lnorm --> loglik: -93542.97(-99258.09), AIC: 187089.9(198520.20)
# weibull --> loglik: -96912.94(-102587.30), AIC: 193829.9(205178.60)
# ------------------------------------------------------------------------------

### Test ###

# Kolmogorov-Smirnov-test
ks_exp <- ks.test(Z, "pexp", exp_fit$estimate["rate"])
ks_exp
ks_gamma <- ks.test(Z, "pgamma", shape=gamma_fit$estimate["shape"],
                    rate=gamma_fit$estimate["rate"])
ks_gamma
ks_pareto <- ks.test(Z, "ppareto", shape=pareto_fit$estimate["shape"],
                     scale=pareto_fit$estimate["scale"])
ks_pareto
ks_llogis <- ks.test(Z, "pllogis", shape=llogis_fit$estimate["shape"],
                     scale=llogis_fit$estimate["scale"])
ks_llogis
ks_lnorm <- ks.test(Z, "plnorm", meanlog=lnorm_fit$estimate["meanlog"],
                    sdlog=lnorm_fit$estimate["sdlog"])
ks_lnorm
ks_weibull <- ks.test(Z, "pweibull", shape=weibull_fit$estimate["shape"],
                      scale=weibull_fit$estimate["scale"])
ks_weibull

# Anderson-Darling-test
ad_exp <- ad.test(Z, null = "pexp", rate = exp_fit$estimate["rate"])
ad_exp
ad_gamma <- ad.test(Z, null = "pgamma", shape = gamma_fit$estimate["shape"], rate = gamma_fit$estimate["rate"])
ad_gamma

# ------------------------------------------------------------------------------
### cyber risk ###
# exp --> KS: 0.63***(0.60***), AD: (79.94***)
# gamma --> KS: 0.25***(0.24***), AD: (18.79***)
# pareto --> KS: 0.06***(0.07***), AD: (7.18***)
# llogis --> KS: 0.08***(1.00***), AD: (13.22***)
# lnorm --> KS: 0.08***(0.08***), AD: (16.99***)
# weibull --> KS: 0.17***(0.16***), AD: (60.20***)

### non-cyber risk ###
# exp --> KS: 0.53***(0.54***), AD: (58.75***)
# gamma --> KS: 0.21***(0.21***), AD: (13.10***)
# pareto --> KS: 0.03***(0.03***), AD: (50.27***)
# llogis --> KS: 0.04***(1.00***), AD: (61.63***)
# lnorm --> KS: 0.04***(0.03***), AD: (54.86***)
# weibull --> KS: 0.11***(0.10***), AD: (6.30***)
# ------------------------------------------------------------------------------


# ==============================================================================
# Frequency Poisson GLM
# ==============================================================================









