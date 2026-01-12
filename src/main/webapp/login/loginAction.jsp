<%@page import="login.LoginDao"%>
<%@ page language="java" contentType="application/json; charset=UTF-8" pageEncoding="UTF-8" %><%
  	String id = request.getParameter("id");
  	String pass = request.getParameter("pass");
  	String saveId = request.getParameter("saveid");
  	
  	LoginDao dao = new LoginDao();
  	boolean isSuccess = dao.isLogin(id, pass);
  	String jsonResponse = "";
  	
  	if(isSuccess){
  		session.setAttribute("id", id);
  		session.setAttribute("saveId", (saveId != null ? "true" : "false"));
  		session.setAttribute("loginStatus", true);
  		
  		session.setMaxInactiveInterval(60*60*8);
  		jsonResponse = """
  			{
  				"status": "success",
  		        "message": "로그인 성공"
  			}
  			""";
  	} else {
  		jsonResponse = """
  	  			{
  	  				"status": "fail",
  	  		        "message": "아이디 또는 비밀번호를 확인하세요."
  	  			}
  	  			""";
  	}
  	out.print(jsonResponse);
    out.flush();
 	
%>