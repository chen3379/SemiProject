# 🎬 WhatFlix

### Class4 A조

**팀장**  
- 김성주  

**팀원**  
- 임소희  
- 백진욱  
- 김현능  
- 조성진  

---

## 📌 프로젝트 주제
**영화 커뮤니티 웹사이트**

---

## 🌿 브랜치 규칙

### 1️⃣ 최종 브랜치 (main)
- 프로젝트 **완성 단계** 및 **분기별 배포용 브랜치**
- develop 브랜치의 안정 버전만 병합

### 2️⃣ 기본 브랜치 (develop)
- 모든 작업의 **기준 브랜치**
- ❌ 직접 push 금지

### 3️⃣ 개별 브랜치 (영문이니셜_담당기능)
- 개인 작업용 브랜치
- 브랜치명 규칙을 반드시 준수

**예시**
```bash
git checkout -b ksj_movie
````

* 작업 완료 후 PR을 통해 develop 브랜치에 병합

---

## 🔄 develop 브랜치 최신 내용 가져오기 (pull 과정)

### 작업 흐름

1. 본인 브랜치에서 작업 내용 저장
2. develop 브랜치로 이동
3. develop 최신화
4. 다시 본인 브랜치로 이동
5. develop 내용을 본인 브랜치에 병합

### Git Bash 명령어

```bash
git add .
git commit -m "본인 브랜치 작업 저장"

git checkout develop
git pull origin develop

git checkout 본인브랜치명
git merge develop
```

---

## 🚀 작업 완료 후 develop 브랜치로 반영하는 과정

### 작업 흐름

1. 본인 브랜치에 작업 내용 커밋
2. 원격 저장소(origin)에 push
3. GitHub에서 develop 브랜치로 PR 생성
4. 팀원 검토 후 팀장이 승인
5. develop 브랜치에 반영

### Git Bash 명령어

```bash
git add .
git commit -m "변경사항"
git push origin 본인브랜치명
```

👉 이후 **GitHub 저장소에서**
`본인 브랜치 → develop` 방향으로 **Pull Request(PR)** 생성

---

## 🛠 Git 명령어 정리

```bash
git checkout -b test   # test 브랜치 생성 + 이동
git checkout test      # test 브랜치로 이동
```

