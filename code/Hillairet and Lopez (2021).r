library(deSolve)


beta <- 2.556e-7   # 감염률
gamma <- 1         # 회복률
N <- 4064279       # 전체 인구 수
initial_infected <- 30100  # 초기 감염자 수

init <- c(S = N - initial_infected, I = initial_infected, R = 0)


SIR <- function(time, state, parameters) {
  with(as.list(c(state, parameters)), {
    dS <- -beta * S * I
    dI <- beta * S * I - gamma * I
    dR <- gamma * I
    return(list(c(dS, dI, dR)))
  })
}


times <- seq(0, 10, by = 0.001)


parameters <- c(beta = beta, gamma = gamma)


out <- ode(y = init, times = times, func = SIR, parms = parameters)
sir_df <- as.data.frame(out)
tail(sir_df)

plot(sir_df$time, sir_df$S, type = "l", col = "blue", lwd = 2, ylim = c(0, N),
     xlab = "Time (Days)", ylab = "Number of People",
     main = "SIR Model (Hillairet and Lopez, 2021)")
lines(sir_df$time, sir_df$I, col = "red", lwd = 2)
lines(sir_df$time, sir_df$R, col = "green", lwd = 2)

# 범례 추가
legend("right", legend = c("Susceptible", "Infected", "Recovered"), 
       col = c("blue", "red", "green"), lwd = 2)














# library(deSolve)
# 
# # SIR 모델 파라미터 설정
# beta <- 2.556e-7   # 감염률
# gamma <- 1         # 회복률
# N <- 4064279       # 전체 인구 수
# 
# # 초기 조건
# init <- c(S = N - 30100, I = 30100, R = 0)
# 
# # SIR 모델 정의
# SIR <- function(time, state, parameters) {
#   with(as.list(c(state, parameters)), {
#     dS <- -beta * S * I
#     dI <- beta * S * I - gamma * I
#     dR <- gamma * I
#     return(list(c(dS, dI, dR)))
#   })
# }
# 
# # 시뮬레이션 시간 설정
# times <- seq(0, 10, by = 0.001)
# 
# # 시뮬레이션 실행
# parameters <- c(beta = beta, gamma = gamma)
# out <- ode(y = init, times = times, func = SIR, parms = parameters)
# sir_df <- as.data.frame(out)
# tail(sir_df)
# tail(sir_df)
# plot(sir_df$time, sir_df$I, type = "l", col = "blue", lwd = 2,
#      xlab = "Time (days)", ylab = "Infected Individuals (I)",
#      main = "SIR Model: Number of Infected Individuals Over Time")
# 
# 
# 
# 
# i_values <- sir_df$I
# 
# generate_T <- function(n_policyholders, beta, i_values, times){
#   t_values <- numeric(n_policyholdres)
#   cumulative_hazard <- 0
#   
#   for (j in 1:n_policyholders){
#     for (t in seq_along(times)){
#       cumulative_hazard <- cumulative_hazard + beta*i_values[t]
#       t_values <- times[t]
#     } 
#   }
# }
# 
# set.seed(123)
# n_policyholders <- 5000
# T_values <- generate_T(n_policyholders, beta, i_values, times)
# 
# # ==============================================================
# 
# library(deSolve)
# sir_model <- function(time, state, parameters){
#   with(as.list(c(state, parameters)), {
#     dS <- -beta*S*I
#     dI <- beta*S*I - gamma*I
#     dR <- gamma *I
#     return(list(c(dS, dI, dR)))
#   })
# }
# 
# beta <- 2.556e-7
# gamma <- 1
# N <- 4064279
# 
# init <- c(S = N - 30100, I = 30100, R = 0)
# 
# sir_out <- ode(y=init, times = times, func = sir_model, parms = parameters)
# sir_df <- as.data.frame(sir_out)
# 
# hazard_exp <- function(t,c) c*(t>=3)
# hazard_pareto <- function(t,c,alpha) c*(t-3+0.5)^(-alpha)*(t>=3)
# hazard_weibull <- function(t,c,alpha) c*(t-3)^(alpha)*(t>=3)
# 
# set.seed(123)
# n_policyholders <- 10000
# n_simulations < 10000
# results <- data.frame(mean_victimes=numeric(n_simulations),
#                       sd_victims=numeric(n_simulations))
# 
# for(sim in 1:n_simulations){
#   T_j <- rexp()
# }
# 
# 
# # =============================================================
# library(deSolve)
# 
# # SIR 모델 설정
# sir_model <- function(time, state, parameters) {
#   with(as.list(c(state, parameters)), {
#     dS <- -beta * S * I / N
#     dI <- beta * S * I / N - gamma * I
#     dR <- gamma * I
#     return(list(c(dS, dI, dR)))
#   })
# }
# 
# beta <- 2.556e-7
# gamma <- 1
# N <- 4064279
# 
# init <- c(S = N - 30100, I = 30100, R = 0)
# parameters <- c(beta = beta, gamma = gamma)
# times <- seq(0, 10, by = 0.0001)  # 시간 범위 설정
# 
# # SIR 모델 실행
# sir_out <- ode(y = init, times = times, func = sir_model, parms = parameters)
# sir_df <- as.data.frame(sir_out)
# 
# # 면역 반응 속도별 위험률 함수 정의
# get_immunity_time <- function(type) {
#   if (type == "fast_exponential") {
#     return(rexp(1, rate = 1/3))  # 빠른 반응: 평균 3일
#   } else if (type == "medium_exponential") {
#     return(rexp(1, rate = 1/5))  # 중간 반응: 평균 5일
#   } else if (type == "slow_weibull") {
#     return(rweibull(1, shape = 2, scale = 7))  # 느린 반응: Weibull 분포 사용
#   }
# }
# 
# # 시뮬레이션 실행 함수 정의
# simulate_total_victims <- function(n_policyholders, sir_df, beta, response_type) {
#   cumulative_hazard <- 0
#   total_victims <- 0
#   
#   for (j in 1:n_policyholders) {
#     # 감염 시점 T_j 추출 (SIR 모델에서 감염자 수 기반으로 위험률 결정)
#     infection_rate <- beta * sir_df$I / N
#     T_j <- rexp(1, rate = mean(infection_rate))  # 감염 시점
#     
#     # 면역 시점 C_j 추출
#     C_j <- get_immunity_time(response_type)
#     
#     # 면역보다 감염이 먼저 일어난 경우 총 피해자 수 증가
#     if (T_j < C_j) {
#       total_victims <- total_victims + 1
#     }
#   }
#   return(total_victims)
# }
# 
# # 시뮬레이션 반복 및 통계 계산
# set.seed(123)
# n_simulations <- 10000
# response_types <- c("fast_exponential", "medium_exponential", "slow_weibull")
# results <- data.frame(matrix(ncol = length(response_types), nrow = n_simulations))
# colnames(results) <- response_types
# 
# for (i in 1:n_simulations) {
#   for (type in response_types) {
#     results[i, type] <- simulate_total_victims(N, sir_df, parameters["beta"], type)
#   }
# }
# 
# # 통계 요약
# summary_stats <- data.frame(
#   Response_Type = response_types,
#   Mean_Victims = colMeans(results),
#   SD_Victims = apply(results, 2, sd),
#   Median_Victims = apply(results, 2, median),
#   Min_Victims = apply(results, 2, min),
#   Max_Victims = apply(results, 2, max)
# )
# 
# print(summary_stats)
# 
# # 히스토그램 출력 (예: 빠른 반응에 대한 히스토그램)
# hist(results$fast_exponential, breaks = 30, main = "Total Victims (Fast Exponential)",
#      xlab = "Total Number of Victims", col = "lightblue")

# ==============================================================================
#install.packages("deSolve")
library(deSolve)
library(VGAM)
set.seed(123)

beta <- 2.556e-7   # 감염률
gamma <- 1         # 회복률
N <- 4064279       # 전체 인구 수

init <- c(S = N - 30100, I = 30100, R = 0)

SIR <- function(time, state, parameters) {
  with(as.list(c(state, parameters)), {
    dS <- -beta * S * I
    dI <- beta * S * I - gamma * I
    dR <- gamma * I
    return(list(c(dS, dI, dR)))
  })
}

log(1-300000/4064279)/(-1*300000)

times <- seq(0, 10, by = 0.0001)

parameters <- c(beta = beta, gamma = gamma)
out <- ode(y = init, times = times, func = SIR, parms = parameters)
sir_df <- as.data.frame(out)

dt <- diff(times)[1]  # 시간 간격
cumulative_infected <- sum(sir_df$I * dt)  # I(t) * dt의 총합

print(cumulative_infected)

plot(sir_df$time, sir_df$S, type = "l", col = "blue", lwd = 2, ylim = c(0, N),
     xlab = "Time (Days)", ylab = "Number of People",
     main = "SIR Model: Epidemic Over Time")
lines(sir_df$time, sir_df$I, col = "red", lwd = 2)
lines(sir_df$time, sir_df$R, col = "green", lwd = 2)

# 범례 추가
legend("right", legend = c("Susceptible", "Infected", "Recovered"), 
       col = c("blue", "red", "green"), lwd = 2)

plot(sir_df$time, sir_df$S, type = "l", col = "blue", lwd = 2,
     xlab = "Time (Days)", ylab = "Number of Susceptible Individuals",
     main = "Number of Susceptible Individuals Over Time")

# I 그래프
plot(sir_df$time, sir_df$I, type = "l", col = "red", lwd = 2,
     xlab = "Time (Days)", ylab = "Number of Infected Individuals",
     main = "Number of Infected Individuals Over Time")

# R 그래프
plot(sir_df$time, sir_df$R, type = "l", col = "green", lwd = 2,
     xlab = "Time (Days)", ylab = "Number of Recovered Individuals",
     main = "Number of Recovered Individuals Over Time")





num_simulations <- 10000
cumulative_value_results_exp <- numeric(num_simulations)
cumulative_value_results_pareto <- numeric(num_simulations)
cumulative_value_results_weibull <- numeric(num_simulations)

tau_j <- 7
for (sim in 1:num_simulations) {
  cumulative_value_exp <- 0
  cumulative_value_pareto <- 0
  cumulative_value_weibull <- 0
  
  for (t in seq_along(sir_df$time)) {
    lambda_C_exp <- ifelse(t>=tau_j,rexp(1,rate = 1),0)
    lambda_C_pareto <- ifelse(t>=tau_j, rpareto(1, scale=1/2, shape=2),0)
    lambda_C_weibull <- ifelse(t>=tau_j, rweibull(1, shape = 1),0)
    
    survival_C_exp <- exp(-lambda_C_exp*t)
    survival_C_pareto <- exp(-lambda_C_pareto*t)
    survival_C_weibull <- exp(-lambda_C_weibull*t)
    
    lambda_T <- beta*i_values[t]
    density_T <- lambda_T*exp(-lambda_T*t)
    
    value_exp <- survival_C_exp*density_T
    value_pareto <- survival_C_pareto*density_T
    value_weibull <- survival_C_weibull*density_T
    
    cumulative_value_exp <- cumulative_value_exp + value_exp*10000
    cumulative_value_pareto <- cumulative_value_pareto + value_pareto*10000
    cumulative_value_weibull <- cumulative_value_weibull + value_weibull*10000
  }
  cumulative_value_results_exp[sim] <- cumulative_value_exp
  cumulative_value_results_pareto[sim] <- cumulative_value_pareto
  cumulative_value_results_weibull[sim] <- cumulative_value_weibull
}


summary(cumulative_value_results_exp)
sd(cumulative_value_results_exp)

summary(cumulative_value_results_pareto)
sd(cumulative_value_results_pareto)

summary(cumulative_value_results_weibull)
sd(cumulative_value_results_weibull)

