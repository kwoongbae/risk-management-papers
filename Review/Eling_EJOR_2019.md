## What are the actual costs of cyber risk events?

> ### Questions
>
> - 본 논문에서 **빈도에 대한 요인분석**은 어떻게 진행했는가?
>   - 
> - POT란?
>   -  
> - 회귀분석에서 Panel이란?
>   - 

<hr>

### 2. Data

#### 2.2 Methodology

LDA(Loss Distribution Approach)로 진행

- $L = \Sigma_{i=1}^{N}X_i$

Loss Frequency  추정



Loss Severity 추정

- 심도분포는 아래의 분포들을 사용해서 추정을 하였음.
  - exponential, Gamma, log-normal, log-logistic, generalized Pareto distribution (GPD), and Weibull
  - non-parametric transformation kernel estimation
  - peaks-ver-threshold (POT) method from EVT
- POT분석 진행
  - 만약 기준치 $u$값이 충분히 높다면, $u$ 이상의 분포는 GPD에 의해 모델링 될 수 있음.
  - $\text{GPD}(\xi, \beta)$



- 본 논문에서는 GPD가 single parametric 함수에 대해서 제일 성능이 좋으므로, $u=0$인 dynamic EVT approach를 진행할 것.

### 3. Results

#### 3.2 Standard models and goodness-of-fit

- GPD로 하였을 때 로그우도값과 AIC의 값이 제일 best
  - 이는 Edwards et al (2015)와는 정반대의 값임.
- 사이버리스크의 GPD의 shape은 1.5998로 non-cyber risk의 shape값인 1.6385보다 더 작다.
  - 이는 non-cyber risk의 손실값의 꼬리분포다 더 두껍다는 것을 의미함.
- POT분석이 GPD보다 더 나은 값을 내었으며, 비모수 추정인 Kernel transformation도 fitting이 잘 됨.