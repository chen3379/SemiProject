# 🎬 WhatFlix (왓플릭스) - 종합 영화 커뮤니티 플랫폼

**WhatFlix**는 최신 영화 정보 탐색, AI 기반 추천, 그리고 사용자 간의 활발한 소통을 지원하는 국내 최고의 영화 커뮤니티 플랫폼을 목표로 합니다. 단순한 정보 제공을 넘어, 기술 기반의 혁신적인 사용자 경험을 선사합니다.

---

## 🌟 핵심 특징

### 1. 지능형 영화 추천 및 탐색 (AI & API Integration)
- **Gemini AI 추천**: 사용자의 막연한 질문(예: "오늘 비 오는데 슬픈 영화 추천해줘")을 분석하여 Google Gemini AI가 맞춤형 영화 리스트를 제안합니다.
- **TMDB 실시간 연동**: 전 세계 영화 데이터베이스(TMDB)와 연동하여 실시간 박스오피스, 포스터, 출연진, 유튜브 트레일러 정보를 제공합니다.
- **데이터 통계**: 영화별 평점 통계 및 리뷰 분석을 통해 신뢰도 높은 영화 정보를 제공합니다.

### 2. 활발한 커뮤니티 생태계
- **다각화된 게시판**: 자유게시판(소통)과 영화리뷰게시판(심층 분석)을 분리하여 운영합니다.
- **인터랙션 시스템**: 게시글 좋아요, 조회수 추적, 실시간 댓글 기능을 통해 사용자 참여를 유도합니다.
- **마이페이지 활동**: 내가 쓴 글, 댓글, 찜한 영화(Wishlist)를 한눈에 관리할 수 있습니다.

### 3. 신뢰와 보안 (Trust & Security)
- **E-mail OTP 인증**: 회원가입 및 주요 정보 수정 시 이메일을 통한 2차 인증(Jakarta Mail)을 거쳐 계정 보안을 강화했습니다.
- **비밀 Q&A**: 민감한 문의사항은 작성자만 볼 수 있는 비밀글 기능을 지원합니다.

### 4. 강력한 관리 도구 (Admin Dashboard)
- **통합 대시보드**: 전체 회원 관리, 영화 데이터 갱신, 커뮤니티 정화 작업을 한곳에서 수행합니다.

---

## 🛠 기술 아키텍처 (Technical Stack)

| Layer | Technology |
| :--- | :--- |
| **Frontend** | HTML5, CSS3, JavaScript(ES6), jQuery, Bootstrap 5 |
| **Backend** | Java 11, JSP & Servlet (Jakarta EE 10) |
| **Database** | MySQL (AWS RDS), JDBC (Custom DBConnect) |
| **API/AI** | Google Gemini API, TMDB API |
| **DevOps** | AWS RDS, Git/GitHub |

---

## 📂 프로젝트 구조 (MVC Pattern)

```text
src/main/java
├── movie/        # 영화 정보(TMDB), AI(Gemini), 리뷰/평점 처리
├── board/        # 커뮤니티(자유, 리뷰), 댓글, 좋아요 시스템
├── member/       # 회원가입, 로그인, 마이페이지, 관리자 기능
├── support/      # 고객센터(FAQ, Q&A)
├── mysql/        # DB 연결 및 공통 유틸리티
└── config/       # API Key 및 설정 파일 관리

src/main/webapp
├── board/        # 게시판 관련 JSP (목록, 상세, 작성)
├── movie/        # 영화 상세, 목록, AI 추천 화면
├── profile/      # 마이페이지, 개인 정보 수정, 위시리스트
├── signUp/       # 회원가입 및 이메일 인증 절차
└── main/         # 메인 페이지 및 레이아웃
```

---

## 🚀 개발 환경 및 시작하기

### 1. 전제 조건
- Java JDK 17 이상
- Apache Tomcat 10.1.x
- MySQL Connector/J 8.0 이상

### 2. 설정 (Security)
`src/main/resources` 또는 `src/main/java/config`에 `secret2.properties` 파일을 생성하고 아래 정보를 입력해야 합니다.
```properties
# Database
AWS_ACCESS_KEY=your_db_password

# API Keys
GEMINI_KEY=your_google_gemini_api_key
TMDB_KEY=your_tmdb_api_key

# Email (SMTP) - Optional
SMTP_EMAIL=your_email
SMTP_PASSWORD=your_app_password
```

---

## 🤝 팀 프로젝트 기여 (Class4 A조)

- **김성주 (Team Leader)**: 영화/AI API 통합, 백엔드 설계
- **임소희**: 회원 인증 시스템, 마이페이지 구현
- **백진욱**: 커뮤니티 아키텍처 및 댓글 시스템
- **김현능**: 영화 상세 정보 및 사용자 인터랙션(찜/리뷰)
- **조성진**: 관리자 대시보드 및 고객 지원 UI

---

## 📝 라이선스
본 프로젝트는 교육적 목적의 세미 프로젝트이며, 사용된 영화 데이터의 저작권은 TMDB에 있습니다.
