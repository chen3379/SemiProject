<h1>WhatFlix</h1>
<br>
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

<h3>develop에서 pull받는 과정</h3>
<br>
본인 작업 저장 (본인 브랜치에 저장)
<br>↓<br>
develop 이동 (본인 로컬의 develop 브랜치로 이동)
<br>↓<br>
develop pull (본인 로컬의 develop을 최신으로 만듦)
<br>↓<br>
본인 브랜치로 복귀
<br>↓<br>
본인 브랜치에 develop 업데이트 내용 합치기 (최신이 된 develop을 본인 브랜치에 반영)
<br>
<h4>[git bash]</h4>

git add .
<br>↓<br>
git commit -m "본인 브랜치 저장"
<br>↓<br>
git checkout develop
<br>↓<br>
git pull origin develop
<br>↓<br>
git checkout 본인 브랜치
<br>↓<br>
git merge develop

<hr>

<h3>본인 작업 완료 후 develop으로 push하는 과정</h3>
<br>
본인 작업 저장 (본인 브랜치에 저장)
<br>↓<br>
본인 브랜치를 origin에 push
<br>↓<br>
GitHub 저장소에서 develop에 본인 브랜치 합치기 요청 (PR)
<br>↓<br>
팀 전체 확인 후 팀장이 승인 시 develop 반영
<br>
<h4>[git bash]</h4>

git add .
<br>↓<br>
git commit -m "변경사항"
<br>↓<br>
git push origin 본인 브랜치
<br>↓<br>
합치기 (PR): GitHub 저장소에서 본인 브랜치 → develop으로 Pull Request를 생성합니다.
<br>↓<br>
팀 전체 확인 후 팀장이 승인 시 develop 반영

<hr>

<h5>[git 명령어 정리]</h5>

git checkout -b test : test라는 브랜치를 생성하고 이동
<br>
git checkout test: test라는 브랜치로 이동
