<%-- 
    Document   : addRequest
    Created on : May 27, 2024, 10:35:17 PM
    Author     : User
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <title>Add New Request</title>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
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
    </head>
    <body>
        <div class="header1">
            <h1 align="center">Add New Board</h1>
        </div>
        <div class="requestForm">
            <fieldset>
                <legend><b>Book Details</b></legend>
                <br>
                <form action="processAddRequest.jsp" name="reqForm" method="POST">
                    <table>
                        <tr>
                            <td><label for="bTitle">Board Name<a>*</a> :</label></td>
                            <td>&nbsp;<input type="text" name="bdTitle" placeholder="Enter board name" required></td>
                        </tr>
                        
                        <tr>
                            <td><label for="author1">Quantity<a>*</a> :</label></td>
                            <td>&nbsp;<input type="numeric" name="quantity" placeholder="Enter quantity board" required></td>
                        </tr>
                        
                        <tr>
                            <td>
                                <button type="submit" id="btnSubmit">Submit</button>
                                <button type="reset" id="btnCancel">Cancel</button>
                            </td>
                        </tr>
                    </table>
                </form>
            </fieldset>
        </div>
    </body>
    <footer class='footer'> &copy;  2025 Board Games Management System.</footer>
</html>

