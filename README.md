# SemiProject

- **기술 스택**: Java, MySQL, AWS, JavaScript, CSS
- **팀장**: 김성주 / **팀원**: 임소희, 백진욱, 김현능, 조성진
- **주제**: 자유(미정)

-----------------------------------------------------------------------------------------------------

**초기 세팅(처음 1회만)**

저장소 초대 수락: 이메일이나 GitHub 알림에서 초대(Invitation)를 반드시 Accept 하세요.

개별 폴더 사용: 기존 수업용 work 폴더와 별개로 프로젝트용 새 폴더를 만들고 그 안에서 아래 명령어를 실행하세요.

Bash

git clone https://github.com/chen3379/SemiProject.git

Eclipse 연동: clone 받은 폴더를 Eclipse에서 Import -> Existing Projects into Workspace로 불러오세요.

-----------------------------------------------------------------------------------------------------

**브랜치 규칙**: 모든 작업은 `develop`에서 시작합니다.
  
기본 브랜치 (develop): 모든 작업의 기준점입니다. 직접 push X 

개별 브랜치 (feature/이름-기능): 기능 개발 시 반드시 본인 브랜치를 만드세요.

예: feature/gildong-login, feature/gildong-db-config

생성 명령어: git checkout -b feature/본인이름-기능명

프로젝트 완성 후 develop -> main

-----------------------------------------------------------------------------------------------------
**작업 흐름 (Daily Cycle)**

시작 전: develop의 최신 코드를 내 컴퓨터로 가져옵니다. 

bash

git pull origin develop

작업: 본인 브랜치에서 코드를 수정하고 저장합니다.

커밋 & 푸시: 작업이 끝나면 본인 브랜치에 올립니다.

bash

git add .
git commit -m "commit message(feat: 로그인 유효성 검사 기능 추가)"
git push origin feature/본인이름-기능명
합치기 (PR): GitHub 저장소에서 feature/.. → develop으로 Pull Request를 생성합니다. (팀장이 확인 후 승인)

feature/, commit message 규칙 정하기

-----------------------------------------------------------------------------------------------------

feature 작업 중 develop update 됐을 경우

내 작업 저장: 먼저 하던 작업을 커밋합니다. (git commit)

develop 이동: git checkout develop

develop 업데이트: git pull origin develop (내 로컬의 develop을 최신으로 만듦)

내 브랜치로 복귀: git checkout feature/내이름

합치기: git merge develop (최신이 된 develop을 내 브랜치에 넣음)

-----------------------------------------------------------------------------------------------------
**1월8일:   aws Rds(각조가 사용할 공동db를 등록할 예정)_ 각조1명은 반드시 등록할 카드소지해야함**

**1월9일:   이날까지는 각조가 하나의 프로젝트를 공유하여 테스트 완료**

**프로젝트**

**1월12일~1월29일(약3주):**

**오전에는 수업및 프로젝트 연습,오후는 풀로 프로젝트작업!!!**

**(못오시는 분은 집에서라도 작업 및 푸쉬하여 참여!!)**

**발표: 1월30일**
-----------------------------------------------------------------------------------------------------

참고 SemiProject 결과물: 

https://github.com/jooyoungsong/SemiProject

https://github.com/seyeonpark12/SemiProject

https://github.com/sist1/todaywithmydoggy

https://github.com/RheeMingyu/SemiSemi

