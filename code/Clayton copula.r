# ---------------------------------------------------------------------------
# import libraries

library(copula)
library(MASS)
library(fitdistrplus)


# ---------------------------------------------------------------------------
# create the data
params <- list(
  return1 = list(meanlog = 0, sdlog = 0.5),
  return2 = list(meanlog = 0.5, sdlog = 0.75),
  return3 = list(meanlog = 1, sdlog = 1),
  return4 = list(meanlog = 1.5, sdlog = 1.25),
  return5 = list(meanlog = 2, sdlog = 1.5),
  return6 = list(meanlog = 2.5, sdlog = 1.75)
)

generate_data <- function(meanlog, sdlog, n = 100, noise_level = 0.3) {
  data <- rlnorm(n, meanlog, sdlog)
  noise <- rnorm(n, mean = 0, sd = noise_level)
  data_with_noise <- data + noise
  return(data_with_noise)
}

return1 <- generate_data(params$return1$meanlog, params$return1$sdlog)
return2 <- generate_data(params$return2$meanlog, params$return2$sdlog)
return3 <- generate_data(params$return3$meanlog, params$return3$sdlog)
return4 <- generate_data(params$return4$meanlog, params$return4$sdlog)
return5 <- generate_data(params$return5$meanlog, params$return5$sdlog)
return6 <- generate_data(params$return6$meanlog, params$return6$sdlog)

ret_sum <- cbind(return1, return2, return3, return4, return5, return6)



# ---------------------------------------------------------------------------
# create empirical distribution functions
ret_sum_u <- ret_sum

for(i in 1:6){
  ret_sum_u[,i] <- rank(ret_sum[,i], ties.method="random")/(length(ret_sum[,i])+1)
}

ret_sum_u <- data.matrix(ret_sum_u)
ret_sum_u

plotdist(ret_sum_u[,4])


# ---------------------------------------------------------------------------
# fit an archimedean copula

clayton_object <- claytonCopula(dim=3)
clayton_object

fitted_clayton_ml <- fitCopula(clayton_object, ret_sum_u[,2:4], method="ml")
fitted_clayton_ml # alpha is 0.06655, MLE is 0.3673 (optimization converged)

fitted_clayton_tau <- fitCopula(clayton_object, ret_sum_u[,2:4], method="itau")
fitted_clayton_tau # alpha is 0.0246

fitted_clayton_rho <- fitCopula(clayton_object, ret_sum_u[,2:4], method="irho")
fitted_clayton_rho # error

?rCopula
u <- rCopula(1000, claytonCopula(0.3673, 3)) # random generation
u

d <- dCopula(u, claytonCopula(0.3673, 3)) # Density
d
plotdist(d)

p <- pCopula(u, claytonCopula(0.3673, 3)) # distribution function
p
plotdist(p)



mu_A <- 0
sigma_A <- 1
mu_B <- 0
sigma_B <- 1

# Step 3: Define the copula
clayton_copula <- claytonCopula(param = 0.3673, dim = 2)

# Step 4: Generate samples from the copula
set.seed(123)
samples <- rCopula(1000, clayton_copula)
samples[,1]
plotdist(samples[,1]) # uniform

samples_A <- qnorm(samples[, 1], mean = mu_A, sd = sigma_A) #from cdf to pdf
plotdist(samples_A)

samples_B <- qnorm(samples[, 2], mean = mu_B, sd = sigma_B)

portfolio_returns <- samples_A + samples_B

VaR_95 <- quantile(portfolio_returns, 0.05)

insurance_price <- -VaR_95

# Print the results
print(paste("95% VaR for the portfolio is:", round(VaR_95, 4)))
print(paste("Insurance price based on VaR is:", round(insurance_price, 4)))


# ----------------------------------------------------------------------------------
# 필요한 패키지 로드
library(fitdistrplus)
library(boot)

# 예제 데이터 생성 (경험적 심도 데이터)
severity_data <- rexp(100, rate = 1/500)  # 평균 500의 지수 분포

# 포아송 빈도 파라미터
lambda <- 10

# 부트스트랩 함수 정의
bootstrap_function <- function(data, indices) {
  resampled_data <- data[indices]
  mean(resampled_data)
}

# 부트스트랩 적용
bootstrap_results <- boot(severity_data, bootstrap_function, R = 1000)
bootstrap_ci <- boot.ci(bootstrap_results, type = "perc")

# 생존 확률 계산
survival_probability <- function(threshold) {
  poisson_frequency <- rpois(1000, lambda)
  losses <- sapply(poisson_frequency, function(n) sum(sample(severity_data, n, replace = TRUE)))
  mean(losses < threshold)
}

# 예시 생존 확률 계산
threshold <- 10000
sp <- survival_probability(threshold)

# 결과 출력
cat("Survival Probability:", sp, "\n")
cat("Bootstrap Confidence Interval:", bootstrap_ci$percent[4:5], "\n")


# 음이항 분포 파라미터
size <- 5
prob <- 0.5

# 생존 확률 계산 함수 (음이항 + 경험적 심도)
survival_probability_negbinom <- function(threshold) {
  negbinom_frequency <- rnbinom(1000, size, prob)
  losses <- sapply(negbinom_frequency, function(n) sum(sample(severity_data, n, replace = TRUE)))
  mean(losses < threshold)
}

# 예시 생존 확률 계산
sp_negbinom <- survival_probability_negbinom(threshold)

# 결과 출력
cat("Survival Probability with Negative Binomial Frequency:", sp_negbinom, "\n")

# 필요한 패키지 로드
library(copula)

# 클레이튼 코퓰라 설정
theta <- 2  # 상관계수 0.2에 대응하는 클레이튼 코퓰라 파라미터
clayton_copula <- claytonCopula(param = theta, dim = 2)

# 생존 확률 계산 함수 (클레이튼 코퓰라 + 경험적 심도)
survival_probability_clayton <- function(threshold) {
  copula_samples <- rCopula(1000, clayton_copula)
  poisson_frequency <- qpois(copula_samples[, 1], lambda)
  losses <- sapply(poisson_frequency, function(n) sum(sample(severity_data, n, replace = TRUE)))
  mean(losses < threshold)
}

# 예시 생존 확률 계산
sp_clayton <- survival_probability_clayton(threshold)

# 결과 출력
cat("Survival Probability with Clayton Copula:", sp_clayton, "\n")

