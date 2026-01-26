<%@page import="config.SecretConfig"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ page import="java.io.*" %>
<%@ page import="java.net.*" %>
<%@ page import="org.json.simple.*" %>
<%@ page import="org.json.simple.parser.JSONParser" %>

<%@ page import="member.MemberDao" %>
<%@ page import="member.MemberDto" %>

<%
request.setCharacterEncoding("UTF-8");

// 1️⃣ 인가 코드
String code = request.getParameter("code");

if (code == null) {
    out.println("<script>alert('카카오 로그인에 실패했습니다.'); location.href='/WHATFLIX';</script>");
    return;
}

// 2️⃣ 설정값
String REST_API_KEY = SecretConfig.get("kakao.rest.key");
String REDIRECT_URI = SecretConfig.get("kakao.redirect.uri");

// 3️⃣ 토큰 요청
String tokenUrl = "https://kauth.kakao.com/oauth/token";

String tokenParams =
      "grant_type=authorization_code"
    + "&client_id=" + REST_API_KEY
    + "&redirect_uri=" + URLEncoder.encode(REDIRECT_URI, "UTF-8")
    + "&code=" + code;

HttpURLConnection conn = (HttpURLConnection) new URL(tokenUrl).openConnection();
conn.setRequestMethod("POST");
conn.setDoOutput(true);
conn.setRequestProperty("Content-Type", "application/x-www-form-urlencoded;charset=utf-8");

try (BufferedWriter bw = new BufferedWriter(new OutputStreamWriter(conn.getOutputStream()))) {
    bw.write(tokenParams);
}

// 응답 처리
BufferedReader br;
if (conn.getResponseCode() == 200) {
    br = new BufferedReader(new InputStreamReader(conn.getInputStream()));
} else {
    br = new BufferedReader(new InputStreamReader(conn.getErrorStream()));
}

StringBuilder sb = new StringBuilder();
String line;
while ((line = br.readLine()) != null) {
    sb.append(line);
}
br.close();

// 4️⃣ 토큰 파싱
JSONParser parser = new JSONParser();
JSONObject tokenJson = (JSONObject) parser.parse(new StringReader(sb.toString()));
String accessToken = (String) tokenJson.get("access_token");

if (accessToken == null) {
    out.println("<script>alert('토큰 발급 실패'); location.href='/WHATFLIX';</script>");
    return;
}

// 5️⃣ 사용자 정보 요청
HttpURLConnection userConn =
    (HttpURLConnection) new URL("https://kapi.kakao.com/v2/user/me").openConnection();
userConn.setRequestMethod("GET");
userConn.setRequestProperty("Authorization", "Bearer " + accessToken);

BufferedReader userBr = new BufferedReader(new InputStreamReader(userConn.getInputStream()));
StringBuilder userSb = new StringBuilder();
while ((line = userBr.readLine()) != null) {
    userSb.append(line);
}
userBr.close();

JSONObject userJson = (JSONObject) parser.parse(new StringReader(userSb.toString()));

// 6️⃣ 사용자 정보 추출 (안전)
Long kakaoId = (Long) userJson.get("id");
JSONObject kakaoAccount = (JSONObject) userJson.get("kakao_account");

String nickname = "카카오회원";
if (kakaoAccount != null) {
    JSONObject profile = (JSONObject) kakaoAccount.get("profile");
    if (profile != null && profile.get("nickname") != null) {
        nickname = (String) profile.get("nickname");
    }
}

// 내부용 ID
String kakaoLoginId = "kakao_" + kakaoId;

// 7️⃣ DB 처리
MemberDao memberDao = new MemberDao();
MemberDto member = memberDao.selectOneMemberbyId(kakaoLoginId);

if (member == null) {
    MemberDto newMember = new MemberDto();
    newMember.setId(kakaoLoginId);
    newMember.setPassword("KAKAO_LOGIN");
    newMember.setNickname(nickname);
    newMember.setJoinType("kakao");
    newMember.setRoleType("1");
    newMember.setStatus("active");

    memberDao.insertKakaoMember(newMember);
    member = memberDao.selectOneMemberbyId(kakaoLoginId);
}

// 8️⃣ 세션
session.setAttribute("loginid", member.getId());
session.setAttribute("memberInfo", member);
session.setAttribute("roleType", member.getRoleType());
session.setAttribute("loginStatus", true);
session.setMaxInactiveInterval(60 * 60 * 8);

// 9️⃣ 이동
response.sendRedirect(request.getContextPath() + "/");
%>
