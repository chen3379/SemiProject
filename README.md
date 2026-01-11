<h1>WhatFlix</h1>

<h3>Class4 A조</h3>
<b>팀장</b>: 김성주  <b>팀원</b>: 임소희, 백진욱, 김현능, 조성진

<b>주제</b>: 영화 커뮤니티 웹사이트

<hr>

<h3>브랜치 규칙</h3>

최종 브랜치 (main): 프로젝트 완성 분기별 배포용 브랜치. 

기본 브랜치 (develop): 모든 작업의 기준점입니다. 직접 push X 

개별 브랜치 (영문 이름 이니셜_담당 기능): 개별 작업을 진행하기 위한 브랜치

- 규칙에 맞게 생성 후 작업

- ex> ksj_movie, git checkout -b ksj_movie

- 프로젝트 분기별 완성 후 develop -> main

<hr>

<h3>Slack에 merge 알림이 왔을 때</h3>
<h3>pull받는 과정</h3>

내 작업 저장 (내 브랜치 저장)
↓
develop 이동 (내 로컬의 develop 브랜치로 이동)
↓
develop pull (내 로컬의 develop을 최신으로 만듦)
↓
내 브랜치로 복귀
↓
내 브랜치에 develop 업데이트 내용 합치기 (최신이 된 develop을 내 브랜치에 반영)

<b>git bash</b>

git add .
↓
git commit -m "내 브랜치 저장"
↓
git checkout develop
↓
git pull origin develop
↓
git checkout 내 브랜치
↓
git merge develop
↓

<hr>

<h3>본인 작업 완료 후</h3>
<h3>develop에 push하는 과정</h3>

<b>git bash</b>

git add .
↓
git commit -m "변경사항"
↓
git push origin 내 브랜치
↓
합치기 (PR): GitHub 저장소에서 feature/.. → develop으로 Pull Request를 생성합니다.
↓
팀 전체 확인 후 팀장이 승인 시 develop 반영



