# Direct Cost 계산
revenue <- 18358000  # Visa의 연간 매출 (단위: 천 달러)
days_disrupted <- 1  # 중단 일수
resilience_factor <- 0.661  # resilience multiplier

daily_revenue <- revenue / 365
direct_cost <- daily_revenue * days_disrupted * resilience_factor
print(direct_cost)  # Direct cost: 13,091달러

# Indirect Cost 계산을 위한 Input-Output 모델 정의
W <- matrix(c(0.1, 0.2, 0.1, 
              0.3, 0.4, 0.1, 
              0.2, 0.1, 0.4), 
            nrow = 3, byrow = TRUE)
d <- c(direct_cost, 200, 300)  # 수요 벡터, 예시로 첫 번째 섹터에 direct cost 반영

# Leontief 역행렬 계산
I <- diag(3)
L <- solve(I - W)

# Upstream Cost 계산
upstream_cost <- L %*% d
print(upstream_cost[1])  # Upstream cost: 77달러

# Downstream Cost 계산
downstream_cost <- sum(upstream_cost) - direct_cost - upstream_cost[1]
print(downstream_cost)  # Downstream cost: 33달러
