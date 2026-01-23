<%@page import="member.MemberDao"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="support.SupportAdminDto"%>
<%@page import="support.SupportAdminDao"%>
<%@page import="support.SupportDto"%>
<%@page import="support.SupportDao"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
    String id = (String)session.getAttribute("id");
    boolean isLogin = (id != null);
    String roleType = isLogin ? new MemberDao().getRoleType(id) : null;
    boolean isAdmin = ("3".equals(roleType) || "9".equals(roleType));

    String supportIdxStr = request.getParameter("supportIdx");
	//수정 오류 보완
    if(supportIdxStr == null || supportIdxStr.equals("undefined")){
        response.sendRedirect("supportList.jsp");
        return;
    }
    int supportIdx = Integer.parseInt(supportIdxStr);

    SupportDao dao = new SupportDao();
    SupportDto dto = dao.getOneData(supportIdx);

    // 글 없음(잘못된 번호 접근)
    if (dto == null) {
        out.print("<script>alert('존재하지 않는 글입니다');history.back();</script>");
        return;
    }

    // 삭제글
    if ("1".equals(dto.getDeleteType())) {
        out.print("<script>alert('삭제된 글입니다');history.back();</script>");
        return;
    }

    // 비밀글: 관리자 or 작성자만
    if ("1".equals(dto.getSecretType())) {
        boolean isWriter = isLogin && id.equals(dto.getId());
        if (!isAdmin && !isWriter) {
            out.print("<script>alert('비밀글 입니다');history.back();</script>");
            return;
        }
    }

    dao.updateReadCount(supportIdx);

    // 날짜 포맷
    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm");

    // 작성자 아이디 가공 (@앞만)
    String writerId = dto.getId();
    if (writerId != null && writerId.contains("@")) {
        writerId = writerId.substring(0, writerId.indexOf("@"));
    }

    // 문의 유형
    String ct = dto.getCategoryType();
    String categoryText = "기타";
	
	if (ct != null) {
	    ct = ct.trim();
	    if ("0".equals(ct)) categoryText = "회원정보";
	    else if ("1".equals(ct)) categoryText = "신고";
	}

    // 문의 상태
    String statusText = "답변대기";
    if ("1".equals(dto.getStatusType())) statusText = "답변완료";
    
    // 작성자, 관리자만 수정버튼 노출
    boolean canEdit = isLogin && (id.equals(dto.getId()) || isAdmin);
    
    
    
    
%>
<!DOCTYPE html>
<html>
<head>

<meta charset="UTF-8">
<link href="https://fonts.googleapis.com/css2?family=Dongle&family=Gamja+Flower&family=Nanum+Myeongjo&family=Nanum+Pen+Script&display=swap" rel="stylesheet">
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-sRIl4kxILFvY47J16cr9ZwB07vP4J8+LH7qKQnuqkuIAvNWLzeN8tE5YBujZqJLB" crossorigin="anonymous">
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.13.1/font/bootstrap-icons.min.css">
<script src="https://code.jquery.com/jquery-3.7.1.js"></script>
<title>WHATFLIX - 고객지원 상세</title>

<style>
  body{
    padding-top: 80px;
    background:#fff;
    color:#111;
  }
  .support-container{
    max-width: 820px;
    margin: 70px auto 120px;
    padding: 0 18px;
  }

  /* 상단 */
  .meta{
    color:#8a8a8a;
    font-size: 13px;
    display:flex;
    gap:10px;
    flex-wrap:wrap;
    margin-top: 4px;
  }

  /* 카테고리(보라톤) */
  .category{
    display:inline-block;
    font-size: 13px;
    font-weight: 700;
    color:#6f42c1;
    margin-top: 14px;
  }

  /* 제목 */
  .title{
    font-size: 30px;
    font-weight: 900;
    letter-spacing: -0.5px;
    margin: 6px 0 0;
    line-height: 1.12;
  }

  /* 본문 */
  .post-body{
    margin-top: 18px;
    font-size: 15px;
    line-height: 1.8;
    color:#222;
    white-space: pre-wrap;
    word-break: break-word;
  }

  /* 답변 카드 */
  .answer-wrap{
    margin-top: 40px;
    border: 1px solid #eee;
    border-radius: 14px;
    padding: 18px 18px;
    background: #fafafa;
  }
  .answer-label{
    display:inline-block;
    font-size: 13px;
    font-weight: 800;
    color:#6f42c1;
    margin-bottom: 10px;
  }
  .answer-content{
    margin:0;
    white-space: pre-wrap;
    line-height: 1.8;
    color:#222;
    font-size: 15px;
  }

  /* 하단 버튼 */
  .footer-actions{
    margin-top: 24px;
    display:flex;
    gap:10px;
    flex-wrap:wrap;
  }

  /* ⋮ 메뉴 (detail.jsp 느낌) */
  .more{
    cursor:pointer;
    font-size: 26px;
    line-height: 1;
    color:#666;
    padding: 6px 10px;
    border-radius: 10px;
    user-select:none;
  }
  .more:hover{
    background: rgba(0,0,0,0.05);
    color:#111;
  }
  .post-menu{
    position: absolute;
    top: 44px;
    right: 0;
    width: 140px;
    display:none;
    background: #fff;
    border: 1px solid #eee;
    border-radius: 12px;
    overflow:hidden;
    box-shadow: 0 10px 30px rgba(0,0,0,0.08);
    z-index: 50;
  }
  .post-menu a{
    display:block;
    padding: 12px 14px;
    font-size: 14px;
    color: #111;
  }
  .post-menu a:hover{
    background: rgba(0,0,0,0.04);
  }
  .post-menu a.danger{
    color:#e03131;
    font-weight:700;
  }

  /* 관리자 답변 입력 폼(화이트 톤) */
  .admin-form textarea.form-control{
    border-radius: 14px;
    border: 1px solid #eee;
    padding: 14px;
    font-size: 14px;
    line-height: 1.7;
  }
  .admin-form textarea.form-control:focus{
    box-shadow: none;
    border-color:#d0c5ff;
  }
</style>

</head>
<body>

<jsp:include page="../main/nav.jsp" />
    <jsp:include page="../login/loginModal.jsp" />
    <jsp:include page="../profile/profileModal.jsp"/>

<div class="support-container">

  <!-- 상단 (id/작성시간/조회 + ⋮ 메뉴) -->
  <div class="d-flex justify-content-between align-items-start position-relative">
    <div>
      <div class="d-flex align-items-center gap-2">
        <strong><%= writerId %></strong>
        <% if("1".equals(dto.getSecretType())){ %>
          <span style="color:#6f42c1;">🔒</span>
        <% } %>
      </div>
      <div class="meta">
        <span><%= sdf.format(dto.getCreateDay()) %></span>
        <span>조회 <%= dto.getReadcount() %></span>
      </div>
    </div>

    <% if (canEdit) { %>
      <span class="more" id="postMenuBtn">⋮</span>
      <div class="post-menu" id="postMenu">
        <a href="supportForm.jsp?supportIdx=<%=supportIdx%>">수정</a>
        <a href="javascript:void(0);" class="danger" id="deletePostBtn">삭제</a>
      </div>
    <% } %>
  </div>

  <!-- 카테고리(보라색 텍스트) -->
  <div class="category"><%= categoryText %> · <%= statusText %></div>

  <!-- 제목 -->
  <h2 class="title"><%= dto.getTitle() %></h2>

  <!-- 본문 -->
  <div class="post-body"><%= dto.getContent() %></div>

  <!-- 답변 -->
  <%
      SupportAdminDao aDao = new SupportAdminDao();
      SupportAdminDto answer = aDao.getAdminAnswer(supportIdx);

      boolean canSeeAnswer = false;
      if ("0".equals(dto.getSecretType())) canSeeAnswer = true;
      else if (isAdmin || (isLogin && id.equals(dto.getId()))) canSeeAnswer = true;
  %>

  <%-- 관리자면: 답변 입력/수정 UI 노출 --%>
  <% if (isAdmin) { %>

    <div class="answer-wrap admin-form">
      <span class="answer-label">관리자 답변</span>

      <% if (answer == null) { %>
        <form action="supportAdminInsertAction.jsp" method="post">
          <input type="hidden" name="supportIdx" value="<%= supportIdx %>">

          <div class="mb-2">
            <textarea name="content" class="form-control" rows="5"
                      placeholder="답변 내용을 입력하세요" required></textarea>
          </div>

          <div class="footer-actions">
            <button type="submit" class="btn btn-dark btn-sm">등록</button>
            <a href="supportList.jsp" class="btn btn-outline-secondary btn-sm">목록</a>
          </div>
        </form>

      <% } else { %>
        <pre class="answer-content"><%= answer.getContent() %></pre>

        <div style="height:12px;"></div>

        <form action="supportAdminUpdateAction.jsp" method="post">
          <input type="hidden" name="supportIdx" value="<%= supportIdx %>">

          <div class="mb-2">
            <textarea name="content" class="form-control" rows="5" required><%= answer.getContent() %></textarea>
          </div>

          <div class="footer-actions">
            <button class="btn btn-dark btn-sm" type="submit">수정</button>

            <a href="supportAdminDeleteAction.jsp?supportIdx=<%=supportIdx%>"
               class="btn btn-outline-danger btn-sm"
               onclick="return confirm('답변을 삭제하시겠습니까?');">
              답변 삭제
            </a>

            <a href="supportList.jsp" class="btn btn-outline-secondary btn-sm">목록</a>
          </div>
        </form>
      <% } %>
    </div>

  <%-- 일반 사용자: 답변 있으면 보여주기(권한 체크 포함) --%>
  <% } else { %>

    <% if (answer != null && canSeeAnswer) { %>
      <div class="answer-wrap">
        <span class="answer-label">관리자 답변</span>
        <pre class="answer-content"><%= answer.getContent() %></pre>
      </div>
    <% } %>

    <div class="footer-actions">
      <a href="supportList.jsp" class="btn btn-outline-secondary btn-sm">목록</a>
    </div>

  <% } %>

</div>

<script>
  // ⋮ 메뉴 토글 + 외부 클릭 닫기
  $(function(){
    const $btn = $("#postMenuBtn");
    const $menu = $("#postMenu");

    $btn.on("click", function(e){
      e.stopPropagation();
      $menu.toggle();
    });

    $(document).on("click", function(){
      $menu.hide();
    });

    $menu.on("click", function(e){
      e.stopPropagation();
    });

    // 문의글 삭제
    $("#deletePostBtn").on("click", function(){
      if(confirm("정말 삭제하시겠습니까?\\n삭제 후에는 복구할 수 없습니다.")){
        location.href = "supportDeleteAction.jsp?supportIdx=<%=supportIdx%>";
      }
    });
  });
</script>

<jsp:include page="../common/customAlert.jsp" />

</body>

</html>