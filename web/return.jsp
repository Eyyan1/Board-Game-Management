<%-- 
    Document   : return
    Created on : Jun 25, 2024, 10:02:05 PM
    Author     : User
--%>

<%@page import="java.sql.*"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <%@ page import="java.time.LocalDate, java.time.format.DateTimeFormatter, java.time.temporal.ChronoUnit" %>
        <title>JSP Page</title>
    </head>
    <body>
        <%
            //retrieve data from reservation.jsp
            int rentID = Integer.parseInt(request.getParameter("id"));
            int avbleQuant = Integer.parseInt(request.getParameter("bq"));
            int quantity = Integer.parseInt(request.getParameter("quantity"));
            String returnDateStr = request.getParameter("retdate");
            String status = "Returned";
            // Define date formatter
            DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");

            // Parse the return date
            LocalDate returnDate = null;
            try {
                returnDate = LocalDate.parse(returnDateStr, formatter);
            } catch (Exception e) {
                out.println("Invalid date format");
            }

            // Set actual return date to the present date
            
            LocalDate actualReturnDate = LocalDate.now();

            // Calculate the fine
            double fine = 0;
            if (returnDate != null) {
                long daysLate = ChronoUnit.DAYS.between(returnDate, actualReturnDate);
                if (daysLate > 0) {
                    fine = daysLate * 2.00; // RM 2 per day late
                }
            }
            Date date = Date.valueOf(actualReturnDate);
            
            //load the JDBC Driver
            Class.forName("com.mysql.jdbc.Driver");

            //establish a connection to mysql database
            String myUrl = "jdbc:mysql://localhost:3306/brs";
            Connection myConnect = DriverManager.getConnection(myUrl,"root","admin");
            
            //execute and manipulate query
            //create sql statement for update
            String mySqlQuery = " update rentaldetail "
                    + " JOIN board ON rentaldetail.boardID = board.boardID "
                    + " SET rentaldetail.status = ?, rentaldetail.actualReturnDate = ?, rentaldetail.fine = ?, board.avbleQuant = ?"
                    + " where rentID = ?";
            PreparedStatement myPs = myConnect.prepareStatement(mySqlQuery);
            myPs.setString(1, status);
            myPs.setDate(2, date);
            myPs.setDouble(3, fine);
            myPs.setInt(4, avbleQuant + quantity);
            myPs.setInt(5, rentID);
            
            if (myPs.executeUpdate()!=0){
                out.println("<script type=\"text/javascript\">");
                out.println("alert(\"Successfully Update Record\")");
                out.println("window.location.href='adminReservation.jsp';");
                out.println("</script>");
            }
            //close database connection
            myConnect.close();  
        %>
    </body>
</html>
