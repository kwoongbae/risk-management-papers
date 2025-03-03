# ===================================================
# 1. Import libraries and Advisen dataset

# setwd("../../05. 개인자료/01. 깃허브 레포지토리/risk-management-papers/code")
# getwd()

library("rlang")
library("dplyr")
library("ggplot2")
library("MASS") # import plotdist
library("fitdistrplus") #fitdist
library("lubridate") # transform to ymd
library("POT") # import fitgpd
library("extraDistr")
library("actuar") # fitdist on log-logistic
library("sn") # import snormFit

advisen <- read.csv("../../dataset/merged_advisen.csv")

colnames(advisen)
length(advisen$ACD) # 156,020
usa_advisen <- advisen[advisen$COUNTRY_CODE=="USA",]
length(usa_advisen$ACD) # 129,317

usa_advisen <- advisen[advisen$CASESTATUS=="Estimate",]
length(usa_advisen$ACD) # 129,317


# (i) case type (e.g. data breach, phishing); 
# (ii) affected count (e.g. in the event of a data breach, how many details were stolen);
# (iii) accident date; 
# (iv) source of the loss; 
# (v) type of loss; 
# (vi) actor (e.g. state-sponsored, terrorist, etc.); 
# (vii) loss amount; 
# (viii) company size (proxied by total revenues); 
# (ix) company type (e.g. government, private); 
# (x) number of employees; 
# (xi) NAICS code identifying the sector of the firm that suffered the cyber incident; 
# (xii) geography 

colnames(advisen)
col <- c("CASE_TYPE", "ACCIDENT_DATE", "ACTOR_TYPE", "TOTAL_AMOUNT", "REVENUES", "COMPANY_TYPE", "EMPLOYEES", "NAIC_SECTOR", "COUNTRY_CODE", "ZIP_x")

extracted_advisen <- usa_advisen[, col]

final_advisen <- extracted_advisen %>%
  filter(!is.na(CASE_TYPE) & !is.na(ACCIDENT_DATE) & !is.na(ACTOR_TYPE) & !is.na(TOTAL_AMOUNT)
         & !is.na(REVENUES) & !is.na(COMPANY_TYPE) & !is.na(EMPLOYEES) 
         & !is.na(NAIC_SECTOR) & !is.na(COUNTRY_CODE))

length(final_advisen$)


head(data.frame(table(final_advisen$RELATED_ID)))
summary(data.frame(table(final_advisen$RELATED_ID))$Freq)
# Min.    1st Qu. Median  Mean    3rd Qu.  Max. 
# 1.000   1.000   1.000   1.127   1.000    65.000 
sd(data.frame(table(final_advisen$RELATED_ID))$Freq)
# 1.44 




