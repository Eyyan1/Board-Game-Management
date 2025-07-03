<%-- 
    Document   : processAddRequest
    Created on : May 27, 2024, 11:30:19 PM
    Author     : User
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!--import JDBC API-->
<%@page import="java.sql.*,java.time.LocalDate" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Process Add Request</title>
    </head>
    <script>
            let myWindow;

            function closeWin() {
              myWindow.close();
            }
    </script>
    <body>
        <%
                //retrive data from session
                String userID = "20";//(String) session.getAttribute("userid");
                

                
                //retrieve data from addRequest.jsp
                String title = request.getParameter("bdTitle");
                int firstAuthor = Integer.parseInt(request.getParameter("quantity"));

            
                //load the JDBC Driver
                Class.forName("com.mysql.jdbc.Driver");

                //establish a connection to mysql database
                String myUrl = "jdbc:mysql://localhost:3306/brs";
                Connection myConnect = DriverManager.getConnection(myUrl,"root","admin");

                //execute and manipulate query for create/insert data
                String mySqlQuery = "insert into board"
                        +"(boardName,boardQuantity,avbleQuant)"
                        +"values (?,?,?)";
                
                PreparedStatement myPs = myConnect.prepareStatement(mySqlQuery);
                
                //set para values for request
                myPs.setString(1,title);
                myPs.setInt(2,firstAuthor);
                myPs.setInt(3,firstAuthor);
            
                
                
                //execute sql insert
                if(!myPs.execute()){
                    //display alert message if succesful
                    out.println("<script type=\"text/javascript\">");
                    out.println("alert(\"Successfully Adding New Record\")");
                    out.println("window.close()");
                    out.println("</script>");
                    
                    //close database connection
                    myConnect.close();
                }
         %>
    </body>
</html>
