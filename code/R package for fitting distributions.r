library("fitdistrplus")
data("groundbeef")

str(groundbeef)

plotdist(groundbeef$serving, histo = TRUE, demp = TRUE)

descdist(groundbeef$serving, boot = 1000)

fw <- fitdist(groundbeef$serving, "weibull")
summary(fw)

fg <- fitdist(groundbeef$serving, "gamma")
fln <- fitdist(groundbeef$serving, "lnorm")
par(mfrow = c(2,2))

plot.legend <- c("Weibull", "lognormal", "gamma")
denscomp(list(fw, fln, fg), legendtext = plot.legend)
qqcomp(list(fw, fln, fg), legendtext = plot.legend)
cdfcomp(list(fw, fln, fg), legendtext = plot.legend)
ppcomp(list(fw, fln, fg), legendtext = plot.legend)

data("endosulfan")
endosulfan$ATV

summary(fendo.B)

fendo.B <- fitdist(ATV, "burr", start = list(shape1 = 0.3, shape2 = 1, rate = 1))
# denscomp(fendo.B)
cdfcomp(fendo.B)

data("endosulfan")
ATV <- endosulfan$ATV
fendo.ln <- fitdist(ATV, "lnorm")
library("actuar")
fendo.ll <- fitdist(ATV, "llogis", start = list(shape = 1, scale = 500)) # 왜 scale을 500으로 추정했지?
fendo.P <- fitdist(ATV, "pareto", start = list(shape = 1, scale = 500))
fendo.B <- fitdist(ATV, "burr", start = list(shape1 = 0.3, shape2 = 1, rate = 1))

cdfcomp(list(fendo.ln, fendo.ll, fendo.P, fendo.B), xlogscale = TRUE, ylogscale = TRUE
        , legendtext = c("lognormal","loglogistic","Pareto", "Burr"))

quantile(fendo.B, probs = 0.05) # fendo.B에서 5%에 해당하는 값은 0.29라는 뜻.

quantile(ATV, probs = 0.05)

gofstat(list(fendo.ln, fendo.ll, fendo.P, fendo.B), fitnames = c("lnorm", "llogis","Pareto","Burr"))

bendo.B <- bootdist(fendo.B, niter = 1001)
summary(bendo.B)

plot(bendo.B)

quantile(bendo.B, probs = 0.05)


