# nbcamp-Project-YOUFLIX
[내일배움캠프 iOS트랙] 9주차 팀과제/iOS 앱개발 입문 프로젝트 - 유튜브 영상 앱 만들기(API 활용)
<br><br><br><br>

## 🧑🏻‍💻 프로젝트 소개
"유튜브 앱 프로젝트"<p> 
이 프로젝트는 Swift 언어를 사용하여 Xcode에서 개발한 애플리케이션입니다. <br>
이 앱은 유튜브 API를 활용하여 만든 동영상 스트리밍 애플리케이션입니다. 사용자는 회원가입 및 로그인을 통해 앱을 이용할 수 있으며, 다양한 기능과 사용자 경험을 제공합니다.
1. **홈 화면**: 최신 동영상을 무한 스크롤로 탐색하세요.
2. **검색 화면**: 원하는 동영상을 빠르게 찾을 수 있습니다.
3. **디테일 페이지**: 동영상을 자세히 살펴보고 댓글을 남기며 찜하기 및 재생 기록 저장 기능을 활용하세요.
4. **마이페이지**: 회원 정보를 관리하고 개인 설정을 수정하세요.
<br>
이 앱은 쉽고 편리한 사용자 경험을 제공하며, 유튜브 동영상을 더욱 흥미롭게 즐길 수 있도록 도와줍니다. 지금 바로 다운로드하여 다양한 동영상을 탐험해보세요! <br><br>

프로젝트 관련 문서 - 🔗 [삼인조(3조) Youflix](https://drive.google.com/drive/folders/1tba-H_tzJ2IRxSwA80xvuqwvpv78s8i0?usp=sharing)

<br><br>

## 🛠️ 사용한 기술 스택 (Tech Stack)
<img src="https://img.shields.io/badge/Swift-F05138?style=for-the-badge&logo=Swift&logoColor=white"><img src="https://img.shields.io/badge/GitHub-181717?style=for-the-badge&logo=github&logoColor=white"><img src="https://img.shields.io/badge/Slack-4A154B?style=for-the-badge&logo=slack&logoColor=white">

<br><br>

## 🗓️ 개발 기간
* 2023-09-04(월) ~ 2023-09-09(토), 6일간

<br><br>

## 💁🏻 개발자
- 김서온 - [anfgbwl](https://github.com/anfgbwl)
- 박상우 - [angwoo0503](https://github.com/angwoo0503)
- 홍성철 - [EyeGrampus](https://github.com/EyeGrampus)

<br><br>

## 📌 주요 기능
#### 회원가입 및 로그인
- 회원가입 및 로그인은 간단하게 이루어집니다.
- 사용자는 닉네임을 랜덤으로 설정하고, 이메일 주소와 비밀번호를 입력하여 가입할 수 있습니다.
- 이메일 주소와 비밀번호는 정규식을 통해 유효성을 검증합니다.
#### 홈 화면
- 홈 화면에서는 유튜브 API를 통해 인기 동영상의 목록을 표시합니다.
- 사용자가 스크롤을 내리면 다음 페이지의 데이터를 로드하여 무한 스크롤을 지원합니다.
#### 검색 화면
- 검색 기능을 통해 사용자가 원하는 동영상을 찾을 수 있습니다.
- 검색 결과를 클릭하면 해당 동영상의 디테일 페이지로 이동할 수 있습니다.
#### 디테일 페이지
- 디테일 페이지에서는 선택한 동영상의 정보를 표시합니다.
- 댓글 기능을 제공하며, 현재 페이지에 있는 댓글을 로드합니다.
- 사용자는 동영상을 찜하기 할 수 있고, 재생 기록을 저장할 수 있습니다.
#### 마이페이지
- 마이페이지에서는 사용자의 회원 정보를 확인하고 수정할 수 있습니다.
- 찜한 동영상과 시청기록을 확인할 수 있습니다.


이 앱은 유튜브 동영상을 효과적으로 탐색하고 관리할 수 있는 기능을 제공하여 사용자에게 편리한 유튜브 스트리밍 경험을 제공합니다.
무한 스크롤과 검색 기능은 사용자가 원하는 동영상을 쉽게 찾을 수 있도록 도와주며, 찜하기 및 재생 기록 저장과 같은 기능은 사용자가 동영상을 즐기는 데 도움을 줍니다.
또한, 회원가입과 로그인을 통해 개인화된 경험을 제공하고, 마이페이지에서는 사용자 정보를 관리할 수 있습니다.


<br><br>

## 🧐 앱 실행 및 사용 방법
![‎앱실행화면 ‎001](https://github.com/anfgbwl/Youfilx/assets/53863005/b24d3afc-123d-4ec9-b3ac-75d26778d8ac)
앱 가이드 영상 : [Youflix](https://youtu.be/P0AlOSLLunY?si=iL6gG3_x-RkYXGOg)


<br><br>

## 💥 트러블 슈팅
- 다음 페이지를 토큰을 계속해서 여러번  호출하는 문제로 인해 중복 동영상 생성
  ```
  API를 로드하는 로직에 isLoadingData라는 Bool 형태의 프로퍼티를 생성하여,
  한 페이지에서 데이터를 가져올 동안에 다시 로드할 수 없게끔 처리함
  ```
- 시청기록 동영상들의 순서가 바뀌며 중복된 동영상들이 출력
  ```
  비동기적으로 처리하여 콜렉션 뷰에 동영상들이 순서대로 출력되지 않아,
  로딩 시간이 걸리더라도 동기적으로 처리해 시청기록 동영상들의 순서를 정렬함
  ```