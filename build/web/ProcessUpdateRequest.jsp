<%-- 
    Document   : ProcessUpdateRequest
    Created on : May 30, 2024, 12:18:22 AM
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
            //retrieve data from updateRequest.jsp
            String rID = request.getParameter("boardID");
            String title = request.getParameter("bdname");
            int firstAuthor = Integer.parseInt(request.getParameter("quantity"));
            int secondAuthor = Integer.parseInt(request.getParameter("avbquantity"));

            
            //load the JDBC Driver
            Class.forName("com.mysql.jdbc.Driver");

            //establish a connection to mysql database
            String myUrl = "jdbc:mysql://localhost:3306/brs";
            Connection myConnect = DriverManager.getConnection(myUrl,"root","admin");
            
            //execute and manipulate query
            //create sql statement for update
            String mySqlQuery = " update board "
                    + " set boardName = ? , boardQuantity = ?, avbleQuant = ?"
                    + " where boardID = ?";
            PreparedStatement myPs = myConnect.prepareStatement(mySqlQuery);
            //set param values for student
            myPs.setString(1, title);
            myPs.setInt(2, firstAuthor);
            myPs.setInt(3, secondAuthor);
            myPs.setString(4, rID);
            
            if (myPs.executeUpdate()!=0){
                out.println("<script type=\"text/javascript\">");
                out.println("alert(\"Successfully Update Record\")");
                out.println("window.location.href='board.jsp';");
                out.println("</script>");
            }
            //close database connection
            myConnect.close();  
        %>
        
    </body>
</html>
