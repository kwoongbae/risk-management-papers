# Building resilience in cybersecurity: An artificial lab approach



#### 용어 정리

- Digital Twin : 객체가 있고, 그 객체에 대한 가상의 객체를 만들어서 두 객체를 데이터로 연결하는 것.
- Lab

### 1. Introduction

사이버 리스크의 영향력은 현재 증가하는 중이며, potentially **catastrophic consequences of cyber risk**는 주목할만한 이슈임.

- systemic relevance of certain types of cyber threats is highlighted.

- Systemic cyber risk에는 대표적인 두 사례가 있음:
  - WannaCry: 이 회사가 150개국의 230,000개의 컴퓨터 랜섬웨어로 감염시킴. 이때 데이터 암호화했는데, 이로 인해 data loss, IT 시스템을 사용할 수 없게 되면서 damage발생. 
  - NotPetya: 우크라이나에 NotPetya malware가 발생함. 이로 인해 데이터 암호화되고 IT서비스가 교란됨. 이로 인해 은행과 주식시장에 손해가 영향이 가서 영구적인 손실이 발생하게 됨. 

본 논문에서는 연결되어 있는 시스템 내에서 발생하여 전염이 되는 systemic cyber risk에 대해 연구하였음.

- 하지만 사이버 위협은 빠르게 성장하고 있기 때문에 모든 attack을 막는 것은 사실상 불가능함.
  - 따라서, **사이버 위협에 대한 회복력이 중요함.** 
  - 사이버 회복력이란? : ability to anticipate, withstand, recover from, and adapt to adverse conditions, stresses, attacks, or compromises on systems that use or are enabled by cyber resources.
- 다양한 법적인 제도도 마련이 되었지만, 이러한 노력은 사이버 위협에 대한 적절한 수준의 보호나 사이버 회복력에 대한 적절한 측정을 할 수는 없음. 

본 논문에서는 아래 4가지 contributions을 가지고 있음.

- 첫 번째 contribution : 사이버 시스템 내 디지털 트윈방식인 artificial cyber lab을 디자인하였음.
  - 디지털 트윈이란?: physical entity, a virtual counterpart, and **the data links** between them.
    - physical entity : interconnected cyber-physical systems
    - virtual counterpart : based on network contagion models
- 두 번째 contribution : 사이버 회복력 분석을 위한 실제 세계의 virtual counterpart로부터 인공적인 데이터 생성하는 lab 활용
  - Security-related interventions : 사이버 네트워크 내 상호연결된 요소들은 안전을 위한 투자를 한다.
  - Topology-based interventions : 네트워크의 위상의 중요성... 이와 관련된 연구 진행
- 세 번째 contribution : 사례들에 대한 연구를 바탕으로, 실제 사이버 시스템 네트워크 내에서 사용되거나, 사용 논의되고 있는 선별된 규제 측정모형들을 논의하였음.
- 네 번째 contribution : 현재 유럽과 미국내 사이버 안전 분야에서 사용 중인 규제모형을 다루었으며, 사이버 보험 기업과 같은 private actor들의 역할에 대해 다루었음.

#### 1.2 Outline

본 논문의 구조

- Section 2: 유럽과 미국에서 사용되고 있는 현재 사이버안전과 관련된 법적 규제에 대한 설명 및 보험회사들의 법적 역할 언급.
  - 추가로, 사이버 안전을 강화할 수 있는 접근법 또한 설명
- Section 3: 인공 사이버 랩에 대한 소개
- Section 4~5 : 안전/구조 측면에서 사이버 회복력 측정 분석에 대한 사례 연구 수행
  - 이러한 수행들을 바탕으로, Section 2에서 설명한 접근법 다시 설명
- Section 6 : 결론

### 2. The Real Word : The Current state of Cybersecurity Regulation

이 챕터에서는 아래 두 가지를 다룰 것임.

- 현재 통용되고 있는 사이버안전 관련 법률의 주요 특징
- 사이버안전을 다루는 보험회사들의 역할

#### 2.1 Current government regulations for cybersecurity

