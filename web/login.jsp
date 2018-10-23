<%-- 
    Document   : login
    Created on : 2018-10-20, 14:31:04
    Author     : hanhui
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
        <style>
            .input { width: 100px; }
        </style>
        <script type="text/javascript">
            function check_user()
            {
                
            }
        </script>
    </head>
    <body>
        <%
            if (null != session.getAttribute("userName")) {
                response.sendRedirect("main.jsp");
            }
            
            if (session.getAttribute("error") != null) {
                out.println(session.getAttribute("error"));
            }
        %>
        <form action="main.jsp" method="POST">
            Name:&nbsp;&nbsp;<input type="text" name="userName" class="input" />
            <br/>
            Password:<input type="password" name="password" class="input" />
            <input type="submit" value="Login" />
        </form>
    </body>
</html>
