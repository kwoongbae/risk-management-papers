### 01. Overview


- 이 레포는 **리스크관리**와 관련된 다양한 자료, 논문들을 정리하여 요약 및 리뷰를 하는 모음입니다.
- 통계학 기반의 보험 및 리스크관리 기법들을 다룬 논문들을 공부하며, 사이버리스크와 자연재해 리스크를 중점적으로 다룹니다. 

---
### 02. Quick-Summary
- [https://github.com/kwoongbae/risk-management-papers/issues](https://github.com/kwoongbae/risk-management-papers/issues)

---
### 03. Deep-Dive

- **A Neural Network Extension of the Lee-Carter Model to Multiple Populations (*AAS 2021*)** [pdf](./Paper/Richman_AAS_2021.pdf) / [review](./Review/Richman_AAS_2021.md)
  
  - *This paper **predicted the morality rates of HMD dataset using Lee-carter model**, Augmented Common Factor (ACF), Common Age Effect (CAE),  and **Deep Neural Network** (fully-connected).*
  - mortality rates
- **The Drivers of Cyber risk (*JFS 2022*)** [pdf](./Paper/Aldasoro_JFS_2022.pdf) / [review](./Review/Aldasoro_et_al_JRS_2022.md)
  - *This paper explained the relationship between cyber risk loss and independent variables such as sector, risk type, company size, and maliciousness based on **Advisen dataset.***
  - cyber risk
- **The Economic Impact of Extreme Cyber Risk Scenarios (*NAAJ 2022*)** [pdf](./Paper/Eling_NAAJ_2022.pdf) / [review](./Review/Eling_NAAJ_2022.md)
  - *This paper designed the **6 scenarios based on the most significant cyberattacks threats** (Supervisory control, Cloud service failure, Health sector and hospitals, Municipal services, Telecommunication, Cross-sector attack) and estimated the economic affects using **Inoperability Input-Output Model**.*
  - cyber risk, scenario
- **Cyber Risk Scenarios, the Financial System, and Systemic Risk Assessment (*CEIP 2019*)** [pdf](./Paper/Kaffenberger_et_al_2019.pdf) / [review](./Review/Kaffenberger_et_al_2019.md) 
  - *This report proposed a **scenario analysis method based on the magnitude of cyber risk** (High-Impact Operational Risk Scenarios, Upstream Infrastructure Scenarios, and External Shock Scenarios) and a **framework for risk assessment** (Cyber Risk Exposure - Cybersecurity Preparedness - Shock Resilience = Systemic Cyber Risk Score!! )*
  - cyber risk, scenario
- **Building resilience in Cybersecurity: An artificial lab approach (*JRI 2023*)** [pdf](./Paper/Awiszus_et_al_JRI_2023.pdf) / [review](./Review/Awiszus_et_al_JRI_2023.md) / [ppt(en)](./Presentation/Seminar_20240125.pdf)
  - *This paper reproduced cyber risks with network topology (digital twin) and simulations.*
  - cyber risk, simulation(graph network)
- **What are the actual costs of cyber risk events? (*EJOR 2019*)** [pdf](./Paper/Eling_EJOR_2019.pdf) / [code(R)](./Code/Eling_et_al_EJOR_2019.r) 
  - *This paper extracted cyber risk cases from operational risks, estimated the distribution of loss frequency/severity, and analyzed the factors of cyber risks.*
  - cyber risk
- **Systemic Cyber Risk and Aggregate Impacts (*RISA 2021*)** [pdf](./Paper/Welburn_RISA_2021.pdf) / [review](./Review/Welburn_RISA_2021.md) / [ppt(en)](./Presentation/Seminar_20240321.pdf)
  - *The paper used **Quantitative modeling** (Input-Output modeling and Computational General Equilibrium models) to calculate **direct costs** and **indirect costs** (upstream impacts and downstream impacts) caused by Systemic Cyber Risk.*
  - systemic cyber risk, input-ouput model

---

### 04. Academic Publications


- **Journal** + **Impact factor**
  - ***EJOR*** [(European Journal of Operational Research)](https://www.sciencedirect.com/journal/european-journal-of-operational-research) **[6.4]**
  - ***RISA*** [(RISk Analysis)](https://onlinelibrary.wiley.com/journal/15396924) **[4.302]**
  - ***JRU*** [(Journal of Risk and Uncertainty)](https://www.springer.com/journal/11166) [**3.977**]
  - ***JFS*** [(Journal of Financial Stability)](https://www.sciencedirect.com/journal/journal-of-financial-stability) [**3.554**]
  - ***AAS*** [(Annals of Actuarial Science)](https://www.cambridge.org/core/journals/annals-of-actuarial-science) [**2.00**]
  - ***IME*** [(Insurance: Mathematics and Economics)]() [**1.933**]
  - ***JRI*** [(Journal of Risk and Insurance)](https://onlinelibrary.wiley.com/journal/15396975) [**1.90**]
  - ***SAJ*** [(Scandinavian Actuarial Journal)](https://www.tandfonline.com/toc/sact20/current) [**1.782**]
  - ***GEVENA*** [(The Geneva Papers on Risk and Insurance – Issues and Practice)](https://www.genevaassociation.org/publications/the-geneva-papers) **[1.6]**
  - ***EAJ*** [(European Actuarial Journal)](https://link.springer.com/journal/13385) **[1.2]**
  - ***NAAJ*** [(North American Actuarial Journal)](https://www.tandfonline.com/toc/uaaj20/current) [**0.59**]
- **Conference**
  - ***ARIA*** [(American Risk & Insurance Association)](https://www.aria.org/)
  - ***APRIA*** ([Asia-Pacific Risk and Insurance Association](https://www.apria.org/))
- **Report**

  - ***EIOPA*** ([European Insurance and Occupational Pensions Authority](https://www.eiopa.europa.eu/index_en))
  - ***LLOYD'S*** ([Lloyd's of London](https://www.lloyds.com/news-and-insights/risk-reports))

---

### 05. Terminologies

- **공제액 (deductible)**
  
  - 자기 부담금. 보험사고가 발생하게 되면 피보험자(보험계약자, policyholder)는 전체 금액에서 공제액을 차감한 만큼의 보험금을 지급받게 됨.
- **백테스트 (backtest)**
  - 해당 모델(전략)을 과거 데이터에 대입 및 테스트(시뮬레이션)하여 성과를 내는지 확인하는 과정을 의미함.
- **수재** 
  - 다른 보험회사의 보상책임을 인수하는 것을 의미하며, 원수보험사와 재보험사가 있을 때 재보험사가 수재를 하며 이를 수재사(cedent)라고 부름.
- **언더라이팅 리스크 (underwriting risk)**
  - 언더라이팅이란 보험가입을 원하는 피보험자의 리스크를 선택하여 적절한 위험집단으로 분류하는 과정을 의미하며, 언더라이팅 리스크는 이 때 피보험자가 지니고 있는 리스크를 의미함.
  - 위험을 평가하고, 요율을 결정하는 등의 업무들이 언더라이팅에 포함됨.
- **재출재 (retrocession)**
  - 재보험사가 인수한 위험을 다시 타 재보험사에게 전가하는 것을 말함.
- **출재 (cession)**
  - 보험회사가 타보험회사에 재보험을 드는 것을 출재라고 하며, 원수보험사와 재보험사가 있을 때 원수보험사를 출재를 하게 됨.
- **채권 (bond)**
  - 중앙정부, 지방정부, 금융기관 등이 정책시행이나 사업수행을 위한 자금조달을 위해 발행하는 차용증서
- **CAPM (Capital Asset Pricing Model)**
  - 자본시장의 균형하에서 위험이 존재하는 자산의 균형수익률을 도출해내는 모형
- **CTF**
  - Catastrophe Task Force의 준말. Solvency II의 건강보험과 손해보험에 속한 CAT 모듈에 대해서 SCR 산출 및 aggregation에 대한 내용을 정리한 [보고서](https://register.eiopa.europa.eu/CEIOPS-Archive/Documents/Reports/CEIOPS-DOC-79-10-CAT-TF-Report.pdf)
- **LOB (Line of Business)**
  - 기업이 돈을 버는데 핵심적인 기능을 하는 부서
