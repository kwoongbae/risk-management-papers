# Systemic Cyber Risk and Aggregate Impacts

> Title : Systemic Cyber Risk and Aggregate Impacts
>
> Authors : Jonathan W. Welburn, Aaron M. Strong
>
> Journal : Risk Analysis 2021

---

### 2. Efforts to understand systemic cyber risk

Systemic risk의 정의는 다음과 같음 (Bandt and Hartmann, 2000)

- an event, where the release of 'bad news' about a financial institution, or even its failure, or the crash of a financial market leads in a sequential fashion to considerable adverse effects on one or several other financial institutions or markets
- widespread systemic shock으로 인해 발생한 도미노 효과
- 2008년의 글로벌 금융위기 때 systemic risk in finance에 대한 많은 연구가 이루어짐.

금융처럼, cyberspace도 네트워크 tie를 통한 inter-dependent한 조직의 시스템임

- 따라서, 본 논문에서는 systemic risk + cyber risk하여 systemic cyber risk라는 용어를 만듦.
- cyberspace의 시스템적 위험에 대한 연구는 사이버 보안, 금융, 경제학, 위험 분석 분야를 기반으로 하는 연구

본 논문에서의 용어

- cyber incident: a loss of confidentiality, integrity, and availability of digital information and information systems
- hacking: the act of causing a cyber incident
- data breach: the loss and exposure of confidential data following a cyber incident
- cyber attack: degradation, disruption, or corruption of digital information and information systems

본 논문에서 등장하는 cyber incident는 data breach와 cyber attack이다.

- data breach: the 2017 cyber incident at Equifax.
- cyber attack: Ukrainian power grid.

#### 2.1 Approaches for Characterizing Systemic Cyber Risk

Systemic Cyber risk의 정의는 다음과 같음 (World Economic Forum, 2016)

- Systemic cyber risk is the risk that a cyber event at an individual component of a critical infrastructure ecosystem will cause significant delay, denial, breakdown, disruption or loss, such that services are impacted not only in the originating component but consequences also cascade into related ecosystem components, resulting in significant adverse effects to public health or safety, economic security or national security.

11가지 시스템적 사이버 공격패턴을 분류하였음.

- common mode/repeated attacks, common mode/scattershot attacks, common mode/pervasive attacks, rolling attacks, transitive attacks, cascading attacks, shared resource consumption attacks, critical function attacks, regional attacks, service dependency attacks, and coordinated supply chain attacks.

또한, systemic cyber incident의 잠재적 영향력에 대한 연구도 진행됨.

- systemic cyber risk can be a source of systemic financial risk where a cyber event on systemically important firms could lead to substantial spillover effects, or outward propagations (Office of Financial Research, 2017)
- OECD는 시스템적 사이버 사건들을 country level, 혹은 global level 수준으로 충격을 줄 수 있는 요인으로 인식하기 시작하였음. (Sommer & Brown, 2011)

#### 2.2 Approaches for Modeling the Economic Impact of Cyber Risk



### 3. Quantitative Model

Sector-specific 모델은 cascading failure로 인한 비용/결과를 설명하는데 부적절함. (Brenner et al, 2017)

- A 기업이 생산 네트워크 측면에서 어떤 기업들과 연결되어 있는지에 대한 데이터가 많이 존재하지 않기 때문.
- 이는 firm-level의 생산 네트워크에 대한 연구가 부족하기 때문임.
- 이러한 어려움으로 여러가지 challenge들이 있었음.

대표적인 사례로 CGE(Computable General Equilibrium) model 사용 예가 있음. 

- Carrera, Standardi, Bosello, & Mysiak, 2015; Rose, Oladosu, & Liao, 2007
- 본 연구에서는 기업 내 방해에 의한 경제적 영향력을 추정하려고 하였음.
- 하지만 firm-level의 생산 네트워크에 대한 데이터가 없어, 어떠한 사건으로 기업이 가격 변화에 맞춰 생산량을 통제하면 경제가 즉각적으로 균형으로 맞춘다는 가정을 하였음.
- 하지만 이는 틀린 가정임.

따라서, 본 논문에서는 Input-output 모델링을 사용함.

- 사이버 공격과 같은 특이한 shock으로 인한 경제적 영향력을 연구하고자 함.
- 원래 I/O 모델은 부문 별 변동에 따른 경제적 영향력을 조사하는데 사용되었음 (Leontief, 1966)

전통적인 I/O 모델은 downstream 영향력을 고려하지 않음.

- Upstream impact는 공급망이나 프로세스의 이전 단계에서 발생한 변화로 인해 downstream에 영향을 줌. 반면 Downstream impact는 공급망이나 프로세스의 이후 단계에서 발생한 변화로 인해 upstream에 영향을 줌.
- CGE분석은 가격의 변화 (어떠한 결정)로부터 발생되는 공급망의 영향력을 분석하였음.

기업은 운영유지 및 사이버 공격으로부터 회복하기 위한 다양한 복원력이 존재함.

- 따라서, short run에 대하여 I/O 모델을 사용하고, long run에 대하여 CGE 모델링을 사용함하면 기업의 복원력을 허용할 수 있게 되고, 복원력은 cyber maturity부터 비즈니스 성격에 이르기까지 다양한 요인에 따라 달라질 수 있음.
- 이때 이러한 요인들이 뭔지 정확하게 모르고, 복원의 방식이 정적이냐 동적이냐에 따라 달라진다는 것을 고려해보면, 개개인의 기업들의 복원력을 추정하는 것은 딱히 중요하지 않을 수 있음.
- 그럼에도 Rose et al, 2007에서는 경제적 부분 수준에서 바라본 기업들의 평균 복원력을 추정하는 연구를 진행하였으며, 테러 공격으로 인해 정전이 발생했을 때 기업들의 복원력을 조사함.
- 그러므로 본 논문에서는 각각 기업에서의 사이버 사건으로 인한 잠재적 영향력을 추정하기 위한 전통적인 I/O 모델링을 구현하기 위해 structural model을 정의하고자 함.


3장에서는 quantitative 모델을 이용하여 사이버 사건으로 인한 잠재적 경제적 결과를 추정하였음.

- 경제적 결과는 경제 전반에 걸친 매출 손실의 관점에서의 결과이며, 이는 사이버 공격을 받음으로써 발생한 결과임.
- 이를 통해, 본 논문에서는 business interruption이 기업의 생산량과 수익에 대한 영향력을 최소화하는 기업 수준의 복원력을 통합하였음.

#### 3.1 Cyber attack Foundations of Idiosyncratic Firm Risk

- cyber attack으로 발생한 기업 내 정전으로 인한 aggregate impact를 이해하기 위해, 본 논문에서는 다음과 같이 economy를 모델링하였음: $\varepsilon = \{S, W,  \epsilon\}$
  - $\varepsilon$ : economy, $S$: sector type, $W$ : weighted adjacency matrix, $\epsilon$ : a vector of sector-level shocks
  - 각각의 sector $S$에서, 
  - 기업 $f$에서의 생산량은 $y_f$이며, $i$ sector에서의 총 산출물 양은 $Y_i = \Sigma_{f \in i} y_f$로 계산함.
  - 총 합계 산출물 양 $Y$는 모든 기업들의 산출물 양을 합하여 $Y=\Sigma_{f}^{m} y_f$로 계산함.
- $\varepsilon$를 모델링하기 위해 본 논문에서는 충격 벡터인 $\epsilon$의 근원을 micro하게 분석하고자 함 (foundations of microorigins).
- 이러한 접근법은 **Assumption 1**을 기반으로 진행됨
  - Assumption 1: 각 sector의 유입/유출량이 그 sector 내 기업들을 대표하며, 모든 기업들의 생산과정은 동일하다고 가정한다: $u_{fj}=\omega_{fi}w_{ij}$
  - $w_{ij}$: sector $i$에서 생산된 물품들이 sector $j$로 유입되는 양
  - $\omega_{fi}$: sector $i$에서 산출되는 전체 양 대비, 기업 $f$에서 생산한 물품들 비율
  - $u_{fj}$: sector $j$로 유입되는 품목들의 양 대비, 기업 $f$에서 생산한 품목들 비율
  - 위 Assumption 1은 실생활에서는 허용되지는 못하지만, 이를 통해 기업 수준에서의 shock으로 인한 총합 손실을 구할 수 있다는 점에서 의의가 있음.
- 기업 수준에서의 shock인 $\phi_f$로 sector수준에서의 shock인 $\epsilon_i$를 설명할 수 있음: $\epsilon_i = \phi^` \omega_i$.
  - $\omega_i$: sector $i$에 속하는 총 m개의 기업들의 생산량 점유율 벡터
  - $\phi^`$: sector $i$에 속하는 총 m개의 기업들의 shock벡터
- 그리고 $\phi_f$는 cyber-attack이 지속된 기간에 비례하여 다음과 같이 계산: $\phi_f=(\frac{y_f}{365})M_f \Lambda$
  - $\frac{y_f}{365}$: 기업$f$의 평균 일일 소득
  - $M_f$: sector resilience multiplier
  - $M_f=0$이면 기업 $f$는 shock을 완전히 받지 않았음을 의미하며, $M_f=1$이면 entirety of shock를 받았음을 의미함.
  - $M_f$는 estimated by a model calibrated to the effects of a power outage.
- 

#### 3.2 Upstream Impacts

- 우선 traditional I/O 모델에 대해서 설명이 필요.
- 전통적인 I/O 모델은 내적을 통해 경제 내 backward linkages 또는 upstream supply chain linkages를 추정함: $\mathbf{x}=\mathbf{W}\mathbf{x}+d$
  - $\mathbf{W}$ : sector 내에서 weighted adjacency matrix
  - $\mathbf{x}$ : sector level output vector
  - $d$ : sector level demand vector
- 그리고 위 식은 다음과 같이 변환 가능함: $\mathbf{x}=(I-\mathbf{W})^{-1}d=\mathbf{L}^{-1}d$
  - $\mathbf{L}^{-1}$은 inverse Leontief 행렬
  - 생산량 변화와 관련된 간접효과 및 Upstream 상호작용을 통해 다른 sector에 미치는 영향을 의미함.
- 이 과정을 토대로 $d$대신 shock 지수인 $\epsilon$을 사용하여 aggregate upstream impact를 계산할 수 있음
  - $\Delta \mathbf{x}=\mathbf{L}^{-1}\epsilon$

#### 3.3 Downstream Impacts

- 기업은 물품의 제공자이면서 구매자이기도 하듯이, shock은 upstream 뿐만 아니라 downstream에도 영향을 줌.
  - downstream에서의 영향력을 분석하고자, 영향받는 sector를 인식해야하며, 이는 NAICS (North American Industry Classification System)을 기반으로 진행하였음.
  - 이를 통해 한 기업의 shock으로 인한 output 감소가 다른 sector들의 input에 얼마나 영향을 주는지 확인하고자 함.
- shock $\epsilon$으로인한 $Y_i$의 감소로 sector $j$로 들어가는 생산품들의 양을 $X_{ji}$라고 정의함.
  - allocate the lost output to each of the sectors
  - $\Delta X_{ji}$는 $\epsilon$과 percentage of sector $i$'s inputs to production from sector $j$의 곱과 같음.
  - ![image-20240316235520235](./imgs/image-20240316235520235.png)
  - $\Delta X_{ji}$는 sector $j$에서의 output인 $Y_j$에 영향을 줌.
- 결론적으로, 각각의 sector들은 cascading shock을 겪게 되는데, 이는 economy 내 기업 $f$의 중요도로 볼 수 있음.
- 따라서, 한 기업이 해당 부문 내 중요한 경우, 전체 경제에 큰 영향을 미칠 수 있음.

