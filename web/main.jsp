<%-- 
    Document   : main
    Created on : 2018-10-20, 14:33:59
    Author     : hanhui
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
    </head>
    <body>
        <%@page import="java.io.*, java.sql.*, java.util.*" %>
        <%!
            String g_userName;
            String g_password;
            int g_minUserNameLen;
            int g_maxUserNameLen;
            int g_minPasswordLen;
            int g_maxPasswordLen;
            
            String g_errMsg = "";
        %>
        <% // Check user name
            session.removeAttribute("error");
            g_errMsg = "";
            try{
                Properties configPro = new Properties();
                String realPath = pageContext.getServletContext().getRealPath("/WEB-INF/classes");
                FileInputStream configProStream = new FileInputStream(realPath + "/config.properties");
                configPro.load(configProStream);
                configProStream.close();
            }
            catch (Exception e) {
                g_errMsg = e.getClass().getName() + ":" + e.getMessage();
            } 
            if (g_errMsg.length() != 0) {
                session.setAttribute("error", g_errMsg);
                response.sendRedirect("login.jsp");
            }
            
            g_userName = request.getParameter("uesrName");
            if (g_userName.length()<g_minUserNameLen){
                session.setAttribute("error", "The user name should not be empty!");
                response.sendRedirect("login.jsp");
            }
            else if (g_userName.length()>g_maxUserNameLen){
                session.setAttribute("error", "The length of a user name should less than " + g_maxUserNameLen);
                response.sendRedirect("login.jsp");
            }
        %>
        <% 
            Connection c;
            try
            {
                Class.forName("org.sqlite.JDBC");
                c = DriverManager.getConnection("jdbc:sqlite:hellojsp.db");
                c.close();
            }
            catch(Exception e) {
                out.println(e.getClass().getName() + ":" + e.getMessage());
            }
        %>
        <h2>Session name:<% out.println(request.getParameter("userName")); %></h2>
        <h2>password:    <% out.println(request.getParameter("password")); %></h2>
    </body>
</html>
