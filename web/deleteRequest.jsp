<%-- 
    Document   : deleteRequest
    Created on : May 29, 2024, 6:51:52 PM
    Author     : User
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.*" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
    </head>
    <body>
        <%
            //get id from request.jsp page and initialize variable
            String reqID = request.getParameter("id");
            
            //load the JDBC Driver
            Class.forName("com.mysql.jdbc.Driver");

            //establish a connection to mysql database
            String myUrl = "jdbc:mysql://localhost:3306/brs";
            Connection myConnect = DriverManager.getConnection(myUrl,"root","admin");
            
            //do some query
            String myQuery = "delete from board where boardID = ?";
            
            PreparedStatement myPs = myConnect.prepareStatement(myQuery);
            
            //execute sql delete
            myPs.setString(1, reqID);
            if(myPs.executeUpdate() !=0 ){
                out.println("<script type=\"text/javascript\">");
                out.println("alert(\"Successfully Delete Board\")");
                out.println("window.location.href='board.jsp';");
                out.println("</script>");
            }
        %>
    </body>
</html>
