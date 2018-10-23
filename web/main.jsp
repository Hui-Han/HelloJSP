<%-- 
    Document   : main
    Created on : 2018-10-20, 14:33:59
    Author     : hanhui
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.io.*, java.sql.*, java.util.*" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
        <%
            String g_userName = request.getParameter("username");
            if (null != g_userName) {
                g_userName = g_userName.trim();
            } else {
                g_userName = "";
            }

            String g_password = request.getParameter("password");
            if (null != g_password) {
                g_password = g_password.trim();
            } else {
                g_password = "";
            }            
            
            session.removeAttribute("error");
            String g_errMsg = "";
        %>
        
        <%!
            String checkLength(String str, int minLen, int maxLen, String thing) {
                if (str.length() < minLen){
                    return "The " + thing + "'length should not less than " + minLen;
                }
                else if (str.length()>maxLen){
                    return "The " + thing + "' should less than " + maxLen;
                }
                
                return "";
            }
            
            String checkIdentity(String username, String password, String dbPath) {
                String errMsg = "";

                try {
                    Class.forName("org.sqlite.JDBC");
                    Connection conn = DriverManager.getConnection("jdbc:sqlite:" + dbPath);
                    conn.setAutoCommit(false);
                    
                    Statement stmt = conn.createStatement();
                    String sqlStr = "SELECT * FROM users WHERE name=='" + username + "' and password='" + password + "';";
                    ResultSet rs = stmt.executeQuery(sqlStr);
                    if (false == rs.next()) {
                        errMsg = "Username or password wrong!";
                    }
                    rs.close();
                    stmt.close();
                    conn.close();
                }
                catch(Exception e) {
                    return e.getClass().getName() + ":" + e.getMessage();
                }
                
                return errMsg;
            }
        %>
        
        <%
            if (null == session.getAttribute("username")) {
                if (null == session.getAttribute("MIN_USERNAME_LENGTH")) {
                    session.setAttribute("error", "Please login first");
                    response.sendRedirect("login.jsp");
                    return;
                }

                int minUserNameLen = 0;
                int maxUserNameLen = 0;
                int minPasswordLen = 0;
                int maxPasswordLen = 0;
                String errMsg = "";
                
                try {
                    minUserNameLen = Integer.parseInt(session.getAttribute("MIN_USERNAME_LENGTH").toString());
                    maxUserNameLen = Integer.parseInt(session.getAttribute("MAX_USERNAME_LENGTH").toString());
                    minPasswordLen = Integer.parseInt(session.getAttribute("MIN_PASSWORD_LENGTH").toString());
                    maxPasswordLen = Integer.parseInt(session.getAttribute("MAX_PASSWORD_LENGTH").toString());
                }
                catch (Exception e) {
                    errMsg = e.getClass().getName() + ":" + e.getMessage();
                    session.setAttribute("error", errMsg);
                    response.sendRedirect("login.jsp");
                    return;
                }
                
                // Check user name
                errMsg = checkLength(g_userName, minUserNameLen, maxUserNameLen, "username");
                if (0 != errMsg.length()) {
                    session.setAttribute("error", errMsg);
                    response.sendRedirect("login.jsp");
                    return;
                }
                
                // Check password
                errMsg = checkLength(g_password, minPasswordLen, maxPasswordLen, "password");
                if (0 != errMsg.length()) {
                    session.setAttribute("error", errMsg);
                    response.sendRedirect("login.jsp");
                    return;
                }
                
                // Login
                String path = getServletContext().getRealPath("WEB-INF/hellojsp.db");
                errMsg = checkIdentity(g_userName, g_password, path);
                if (0 != errMsg.length()) {
                    session.setAttribute("error", errMsg);
                    response.sendRedirect("login.jsp");
                    return;
                }
                
                session.setAttribute("username", g_userName);
                session.setAttribute("password", g_password);

                session.removeAttribute("MIN_USERNAME_LENGTH");
                session.removeAttribute("MAX_USERNAME_LENGTH");
                session.removeAttribute("MIN_PASSWORD_LENGTH");
                session.removeAttribute("MAX_PASSWORD_LENGTH");
            } 
        %>
    </head>
    <body>
        <h2>Session name:</h2>
        <h2>password:     </h2>
    </body>
</html>
