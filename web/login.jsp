<%-- 
    Document   : login
    Created on : 2018-10-20, 14:31:04
    Author     : hanhui
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.io.*, java.util.*" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
        <style>
            .input { width: 100px; }
            #errorLabel { width: 300px; height:20px; font-size: 10px; color: red; }
        </style>
        <%!
            int g_minUserNameLen;
            int g_maxUserNameLen;
            int g_minPasswordLen;
            int g_maxPasswordLen;
            String g_errMsg = "";
        %>
        <%
            if (null != session.getAttribute("username")) {
                response.sendRedirect("main.jsp");
                return;
            }
            
            if (null != session.getAttribute("error")) {
                g_errMsg = session.getAttribute("error").toString();
                session.removeAttribute("error");
            }
        %>
        <% // Read config properties
            if (null == session.getAttribute("MIN_USERNAME_LENGTH")) {
                try{
                    Properties configPro = new Properties();
                    String realPath = pageContext.getServletContext().getRealPath("/WEB-INF/classes");
                    FileInputStream configProStream = new FileInputStream(realPath + "/config.properties");
                    configPro.load(configProStream);
                    g_minUserNameLen = Integer.parseInt(configPro.getProperty("MIN_USERNAME_LENGTH").trim());
                    g_maxUserNameLen = Integer.parseInt(configPro.getProperty("MAX_USERNAME_LENGTH").trim());
                    g_minPasswordLen = Integer.parseInt(configPro.getProperty("MIN_PASSWORD_LENGTH").trim());
                    g_maxPasswordLen = Integer.parseInt(configPro.getProperty("MAX_PASSWORD_LENGTH").trim());
                    session.setAttribute("MIN_USERNAME_LENGTH", g_minUserNameLen);
                    session.setAttribute("MAX_USERNAME_LENGTH", g_maxUserNameLen);
                    session.setAttribute("MIN_PASSWORD_LENGTH", g_minPasswordLen);
                    session.setAttribute("MAX_PASSWORD_LENGTH", g_maxPasswordLen);
                    configProStream.close();
                }
                catch (Exception e) {
                    g_errMsg = e.getClass().getName() + ":" + e.getMessage();
                } 
            }
            else {
                g_minUserNameLen = Integer.parseInt(session.getAttribute("MIN_USERNAME_LENGTH").toString());
                g_maxUserNameLen = Integer.parseInt(session.getAttribute("MAX_USERNAME_LENGTH").toString());
                g_minPasswordLen = Integer.parseInt(session.getAttribute("MIN_PASSWORD_LENGTH").toString());
                g_maxPasswordLen = Integer.parseInt(session.getAttribute("MAX_PASSWORD_LENGTH").toString());
            }
        %>
        <script type="text/javascript">            
            function checkSubmit() {
                var minUesrNameLen = <%=g_minUserNameLen %>;
                var maxUesrNameLen = <%=g_maxUserNameLen%>;
                var minPasswordLen = <%=g_minPasswordLen%>;
                var maxPasswordLen = <%=g_maxPasswordLen%>;
                
                var usernameLen = document.getElementById("username").value.length;
                var passwordLen = document.getElementById("password").value.length;
                var errorMsg = "";
                if (usernameLen < minUesrNameLen) {
                    errorMsg = "The user name's length should not be less than " + minUesrNameLen;
                }
                else if (usernameLen > maxUesrNameLen) {
                    errorMsg = "The user name's length should not more than " + maxUesrNameLen;
                }
                else if (passwordLen < minPasswordLen) {
                    errorMsg = "The password' length should not less than " + minPasswordLen;
                }
                else if (passwordLen > maxPasswordLen) {
                    errorMsg = "The password's length should not more than " + maxPasswordLen;
                }

                if (errorMsg.length != 0) {
                    document.getElementById("errorLabel").innerText = errorMsg;
                    return false;
                }
                
                return true;
            }
            
            function checkErrorMsg() {
                var errMsg = "<%=g_errMsg%>";
                if (0 != errMsg.length) {
                    document.getElementById("errorLabel").innerText = errMsg;
                }
            }
        </script>
    </head>
    <body onload="checkErrorMsg()">
        <form action="main.jsp" method="post" onsubmit="return checkSubmit()">
            Name:&nbsp;&nbsp;<input type="text" id="username" name="username" class="input" />
            <br/>
            Password:<input type="password" id="password" name="password" class="input" />
            <input type="submit" value="Login" />
        </form>
        <div id="errorLabel"></div>
    </body>
</html>
