<%-- 
    Document   : updateRequest
    Created on : May 29, 2024, 6:26:09 PM
    Author     : User
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!--import JDBC API-->
<%@page import="java.sql.*" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
        <style>
            fieldset{
                border: 2px solid #ccc;
                border-radius: 4px;
            }
            
            label a{
                color:red;
            }
            
            tr{
                height: 50px;
            }
            
            input[type=text]{
                padding: 12px;
                border: 1px solid #ccc;
                border-radius: 4px;
            }
            
            button{
                color: white;
                padding: 10px 20px;
                margin: 10px 5px 0px 5px;
                border: none;
                border-radius: 4px;
                cursor: pointer;
                background-color: #45a049;
            }
            
            button:hover{
                background-color: #04AA6D;
            }
        </style>
        <script>
            let myWindow;

            function back() {
              myWindow = window.open("board.jsp","_self");
            }
        </script>
    </head>
    <body>
        <%
            //get id from request.jsp page and initialize variable
            String boardID = request.getParameter("id");
            String boardName= "";
            int Quantity = 0,availableQuantity = 0;
            
            //load the JDBC Driver
            Class.forName("com.mysql.jdbc.Driver");

            //establish a connection to mysql database
            String myUrl = "jdbc:mysql://localhost:3306/brs";
            Connection myConnect = DriverManager.getConnection(myUrl,"root","admin");
            
            //create a statement to retrieve the inserted data
            Statement myStatement = myConnect.createStatement();
            
            //query to retrieve the existing records 
            String myQuery =" Select * from board "
            + " where  boardID = " + boardID;
            
            ResultSet myResult = myStatement.executeQuery(myQuery);
            
            //store record in variable
            while(myResult.next()){
                boardName = myResult.getString(2);
                Quantity = myResult.getInt(3);
                availableQuantity = myResult.getInt(4);
            }
            
            //close db connection
            myConnect.close();
        %>
        <div>
            <h1 align="center">Update Request</h1>
        </div
        <div class="updateRequestForm">
            <fieldset>
                <legend><b>Book Details</b></legend>
                <br>
                <form action="ProcessUpdateRequest.jsp" name="PUForm" method="POST">
                    <table>
                        <tr>
                            <td><label for="bTitle">board Name<a>*</a> :</label></td>
                            <td>&nbsp;<input type="text" name="bdname" value="<%=boardName%>" required></td>
                            <td>&nbsp;<input type="hidden" name="boardID" value="<%=boardID%>" ></td>
                        </tr>
                        
                        <tr>
                            <td><label for="author1">Quantity<a>*</a> :</label></td>
                            <td>&nbsp;<input type="number" name="quantity" value="<%=Quantity%>" required></td>
                        </tr>
                        
                        <tr>
                            <td><label for="author2">Available Quantity<a style="color: grey"> (optional)</a> :</label></td>
                            <td>&nbsp;<input type="number" name="avbquantity" value="<%=availableQuantity%>"></td>
                        </tr>
                        
                        <tr>
                            <td>
                                <button type="submit" id="btnSubmit">Submit</button>
                                <button type="reset" id="btnCancel" onClick="back()">Cancel</button>
                            </td>
                        </tr>
                    </table>
                </form>
            </fieldset>
        </div>
    </body>
    <footer class='footer'> &copy;  2025 Board Games Management System.</footer>
</html>
