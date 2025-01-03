library(data.table)  # 데이터 처리
library(stats)       # 최적화 함수

# SIR 시뮬레이션 함수
sir_simulation <- function(N, tau, gamma, max_time, initial_infected) {
  S <- N - initial_infected
  I <- initial_infected
  R <- 0
  time <- 0
  results <- list()
  
  while (I > 0 && time < max_time) {
    infection_rate <- tau * S * I / N
    recovery_rate <- gamma * I
    total_rate <- infection_rate + recovery_rate
    
    time <- time + rexp(1, rate = total_rate)
    if (runif(1) < infection_rate / total_rate) {
      S <- S - 1
      I <- I + 1
    } else {
      I <- I - 1
      R <- R + 1
    }
    results[[length(results) + 1]] <- data.frame(time = time, S = S, I = I, R = R)
  }
  
  return(rbindlist(results))
}

# 손실 함수 계산
calculate_loss <- function(gamma_i, gamma_others, tau_0, k, N, max_time, initial_infected) {
  # 감염률 계산
  tau_i <- tau_0 * (1 - gamma_i)
  tau_effective <- tau_i * mean(1 - gamma_others)
  
  # SIR 모델 시뮬레이션
  sir_results <- sir_simulation(N, tau_effective, 0.05, max_time, initial_infected)
  final_state <- tail(sir_results, 1)
  
  # 손실 계산 (감염 확률 * 지속 시간)
  infection_loss <- final_state$I * tau_effective * final_state$time
  
  # 보안 비용 계산 (C_i = k * gamma_i^2)
  security_cost <- k * gamma_i^2
  
  return(infection_loss + security_cost)
}

# 보안 수준 최적화 함수
optimize_security_level <- function(node, gamma, tau_0, k, N, max_time, initial_infected) {
  other_nodes <- setdiff(1:length(gamma), node)
  gamma_others <- gamma[other_nodes]
  
  # 최적화 대상 함수
  target_function <- function(gamma_i) {
    calculate_loss(gamma_i, gamma_others, tau_0, k, N, max_time, initial_infected)
  }
  
  # 최적화 수행
  result <- optimize(target_function, interval = c(0, 1))
  return(result$minimum)
}

# 보안 투자 게임 구현
security_investment_game <- function(N, tau_0, k, max_rounds, max_time, initial_infected) {
  gamma <- rep(0.1, N)  # 초기 보안 수준
  for (round in 1:max_rounds) {
    cat("Round:", round, "\n")
    
    # 각 노드별로 보안 수준 최적화
    for (node in 1:N) {
      gamma[node] <- optimize_security_level(node, gamma, tau_0, k, N, max_time, initial_infected)
    }
    
    # 중간 결과 출력
    cat("Updated security levels:", gamma, "\n")
  }
  return(gamma)
}

# 매개변수 설정
N <- 50                     # 노드 수
tau_0 <- 0.1                # 기본 감염률
k <- 1                      # 보안 비용 상수
max_rounds <- 50            # 최대 라운드 수
max_time <- 100             # SIR 시뮬레이션 최대 시간
initial_infected <- 1       # 초기 감염자 수

# 보안 투자 게임 실행
final_security_levels <- security_investment_game(N, tau_0, k, max_rounds, max_time, initial_infected)

# 최종 보안 수준 출력
print(final_security_levels)
