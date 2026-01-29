<%@page import="config.SecretConfig"%>
<%@ page contentType="text/html; charset=UTF-8" %>
<%
    String REST_API_KEY = SecretConfig.get("kakao.rest.key");
    String REDIRECT_URI = SecretConfig.get("kakao.redirect.uri");

    String url =
        "https://kauth.kakao.com/oauth/authorize"
      + "?client_id=" + REST_API_KEY
      + "&redirect_uri=" + java.net.URLEncoder.encode(REDIRECT_URI, "UTF-8")
      + "&response_type=code"
      + "&prompt=login";	
    
    response.sendRedirect(url);
%>
