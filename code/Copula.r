# ===================================================
# Import libraries and SAS OpRisk Global dataset
# ===================================================
install.packages("sn")
set.seed(1234)
rm(list=ls())
# Required packages
library(mvtnorm)
library(ggplot2)
library(ggExtra)
library(sn)

# ===================================================
# normal margins
# ===================================================

sim.GC <- function(n, rho, qmarg1, qmarg2){
  R <- rbind(c(1,rho),c(rho,1)) #rho가 두 변수 간의 상관관계를 의미함.
  dat <- rmvnorm(n, mean = c(0,0), sigma = R)
  dat[,1] <- qmarg1(pnorm(dat[,1]))
  dat[,2] <- qmarg2(pnorm(dat[,2]))
  return(dat)
}

q1 <- function(p) qunif(p)
q2 <- function(p) qunif(p)

ns <- 1000; rho = 0.7
sim <- sim.GC(n = ns, rho = rho,q1,q2)
df <- data.frame(x = sim[,1], y = sim[,2])
p <- ggplot(df, aes(x, y)) + geom_point() + theme(axis.text.x = element_text(size = 14), axis.text.y = element_text(size = 14)) +
  xlab("X") + ylab("Y") + ggtitle(expression(paste(rho, "=0.5")))
ggExtra::ggMarginal(p, type = "histogram")


grid::grid.newpage()

ns <- 1000; rho = 0.75
sim <- sim.GC(n = ns,rho = rho,q1,q2)
df <- data.frame(x = sim[,1], y = sim[,2])
p <- ggplot(df, aes(x, y)) + geom_point() + theme(axis.text.x = element_text(size = 14), axis.text.y = element_text(size = 14)) +
  xlab("X") + ylab("Y") + ggtitle(expression(paste(rho, "=0.75")))
ggExtra::ggMarginal(p, type = "histogram")



grid::grid.newpage()


# ===================================================
# Logistic marginals
# ===================================================

q1 <- function(p) qlogis(p)
q2 <- function(p) qlogis(p)

ns <- 1000; rho = 0.5
sim <- sim.GC(n = ns,rho = rho,q1,q2)
df <- data.frame(x = sim[,1], y = sim[,2])
p <- ggplot(df, aes(x, y)) + geom_point() + theme(axis.text.x = element_text(size = 14), axis.text.y = element_text(size = 14)) +
  xlab("X") + ylab("Y") + ggtitle(expression(paste(rho, "=0.5")))
ggExtra::ggMarginal(p, type = "histogram")

grid::grid.newpage()


# ===================================================
# Student-t with 4 degrees of freedom marginals
# ===================================================

q1 <- function(p) qt(p, df = 4)
q2 <- function(p) qt(p, df = 4)

ns <- 1000; rho = 0.5
sim <- sim.GC(n = ns,rho = rho,q1,q2)
df <- data.frame(x = sim[,1], y = sim[,2])
p <- ggplot(df, aes(x, y)) + geom_point() + theme(axis.text.x = element_text(size = 14), axis.text.y = element_text(size = 14)) +
  xlab("X") + ylab("Y") + ggtitle(expression(paste(rho, "=0.5")))
ggExtra::ggMarginal(p, type = "histogram")

grid::grid.newpage()


# ===================================================
# Student-t with 4 degrees of freedom marginal for X
# Standard normal for Y
# ===================================================
q1 <- function(p) qt(p, df = 4)
q2 <- function(p) qnorm(p)

ns <- 1000; rho = 0.5
sim <- sim.GC(n = ns,rho = rho,q1,q2)
df <- data.frame(x = sim[,1], y = sim[,2])
p <- ggplot(df, aes(x, y)) + geom_point() + theme(axis.text.x = element_text(size = 14), axis.text.y = element_text(size = 14)) +
  xlab("X") + ylab("Y") + ggtitle(expression(paste(rho, "=0.5")))
ggExtra::ggMarginal(p, type = "histogram")
