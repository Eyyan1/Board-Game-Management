<%@page import="com.Model.Customer"%>
<%@page import="java.sql.*, java.text.SimpleDateFormat, java.util.Date" %>
<%@page import="com.DAO.BoardDAO"%>
<%@page import="com.Model.Board"%>
<%@page import="com.DAO.CustomerDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    // --- Security Check ---
    if (session.getAttribute("admin") == null) {
        response.sendRedirect("Login.jsp?type=admin&error=Please+log+in+to+continue");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Reservations</title>
    <link rel="stylesheet" href="style.css">
    <link rel="stylesheet" href="https://code.jquery.com/ui/1.13.2/themes/base/jquery-ui.css">
    <script src="https://code.jquery.com/jquery-3.6.0.js"></script>
    <script src="https://code.jquery.com/ui/1.13.2/jquery-ui.js"></script>
    <script type="text/javascript" src="app.js" defer></script>
    <style>
        body { font-family: 'Arial', sans-serif; background-color: #f4f7f9; margin: 0; }
        .header { background-color: #111827; color: white; padding: 1rem 2rem; display: flex; justify-content: space-between; align-items: center; }
        .header .navbar-brand { font-size: 1.5rem; font-weight: 700; text-decoration: none; color: white; }
        .header .nav-links a { color: #d1d5db; text-decoration: none; margin-left: 1.5rem; font-weight: 500; }
        .container { max-width: 1200px; margin: 2rem auto; padding: 0 1rem; }
        .list-container { background-color: #ffffff; padding: 2rem; border-radius: 8px; box-shadow: 0 4px 6px rgba(0,0,0,0.05); }
        .list-header { text-align: center; margin-bottom: 2rem; }
        .list-header h1 { font-size: 2rem; font-weight: 700; color: #1f2937; }
        .corporate-table { width: 100%; border-collapse: collapse; }
        .corporate-table th, .corporate-table td { padding: 12px 15px; border: 1px solid #e5e7eb; text-align: left; }
        .corporate-table th { background-color: #2563EB; color: white; font-weight: 600; }
        .corporate-table tr:nth-child(even) { background-color: #f9fafb; }
        .status-badge { padding: 5px 12px; border-radius: 12px; font-size: 0.8rem; font-weight: 600; color: white; text-transform: uppercase; }
        .status-not-returned { background-color: #F9A826; }
        .status-returned { background-color: #28a745; }
        .btn-return { display: inline-block; padding: 8px 16px; background-color: #16A34A; color: white; text-decoration: none; border-radius: 6px; font-weight: 500; text-align: center; }
        .footer { text-align: center; padding: 1.5rem; margin-top: 2rem; color: #6b7280; font-size: 0.875rem; }
    </style>
</head>
<body>
    <!-- Navbar -->
    <nav class="header">
        <a class="navbar-brand" href="AdminDashboard.jsp">Admin Dashboard</a>
        <div class="nav-links">
            <a href="AdminDashboard.jsp">Home</a>
            <a href="ListCustomer.jsp">Customer</a>
            <a href="board.jsp">Board</a>
            <a href="adminReservation.jsp">Reservation</a>
            <a href="index.html">Logout</a>
        </div>
    </nav>

    <!-- Main Content -->
    <div class="container">
        <div class="list-container">
            <div class="list-header">
                <h1>Reservation Management</h1>
            </div>
            <div id="tabs">
                <ul>
                    <li><a href="#tabs-1">Current Rentals</a></li>
                    <li><a href="#tabs-2">Rental History</a></li>
                </ul>
                <!-- Current Reservations Tab -->
                <div id="tabs-1">
                    <table class="corporate-table">
                        <thead>
                            <tr>
                                <th>Customer Name</th>
                                <th>Board Game</th>
                                <th>Quantity</th>
                                <th>Rent Date</th>
                                <th>Return By</th>
                                <th>Status</th>
                                <th>Action</th>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                                Connection currentConn = null;
                                try {
                                    Class.forName("com.mysql.jdbc.Driver");
                                    String myUrl = "jdbc:mysql://localhost:3306/brs";
                                    currentConn = DriverManager.getConnection(myUrl,"root","admin");
                                    
                                    String currentQuery = "SELECT r.rentID, c.custName, b.boardName, r.quantity, r.rentDate, r.returnDate, r.status, b.avbleQuant as bq " +
                                                        "FROM rentaldetail r JOIN customer c ON r.custID = c.custID JOIN board b ON r.boardID = b.boardID " +
                                                        "WHERE r.status = 'Not returned' ORDER BY r.rentDate ASC";
                                    
                                    try (PreparedStatement psCurrent = currentConn.prepareStatement(currentQuery);
                                         ResultSet rs = psCurrent.executeQuery()) {
                                        if (!rs.isBeforeFirst()) {
                                            out.println("<tr><td colspan='7' style='text-align:center; padding: 20px;'>No current reservations found.</td></tr>");
                                        }
                                        while (rs.next()) {
                            %>
                            <tr>
                                <td><%= rs.getString("custName") %></td>
                                <td><%= rs.getString("boardName") %></td>
                                <td><%= rs.getInt("quantity") %></td>
                                <td><%= new SimpleDateFormat("dd/MM/yyyy").format(rs.getDate("rentDate")) %></td>
                                <td><%= new SimpleDateFormat("dd/MM/yyyy").format(rs.getDate("returnDate")) %></td>
                                <td><span class="status-badge status-not-returned">Rented</span></td>
                                <td><a href="return.jsp?id=<%= rs.getInt("rentID") %>&quantity=<%=rs.getInt("quantity")%>&retdate=<%=rs.getDate("returnDate")%>&bq=<%=rs.getInt("bq")%>" class="btn-return">Mark as Returned</a></td>
                            </tr>
                            <%
                                        }
                                    }
                                } catch (Exception e) {
                                    e.printStackTrace();
                                } finally {
                                    if (currentConn != null) try { currentConn.close(); } catch (SQLException e) {}
                                }
                            %>
                        </tbody>
                    </table>
                </div>

                <!-- Past Reservations Tab -->
                <div id="tabs-2">
                     <table class="corporate-table">
                        <thead>
                            <tr>
                                <th>Customer Name</th><th>Board Game</th><th>Quantity</th><th>Rent Date</th><th>Expected Return</th><th>Actual Return</th><th>Status</th><th>Fine (RM)</th>
                            </tr>
                        </thead>
                        <tbody>
                             <%
                                Connection pastConn = null;
                                try {
                                    Class.forName("com.mysql.jdbc.Driver");
                                    String myUrl = "jdbc:mysql://localhost:3306/brs";
                                    pastConn = DriverManager.getConnection(myUrl,"root","admin");

                                    String pastQuery = "SELECT c.custName, b.boardName, r.quantity, r.rentDate, r.returnDate, r.actualReturnDate, r.status, r.fine " +
                                                     "FROM rentaldetail r JOIN customer c ON r.custID = c.custID JOIN board b ON r.boardID = b.boardID " +
                                                     "WHERE r.status = 'Returned' ORDER BY r.actualReturnDate DESC";
                                    
                                    try (PreparedStatement psPast = pastConn.prepareStatement(pastQuery);
                                         ResultSet rs = psPast.executeQuery()) {
                                        if (!rs.isBeforeFirst()) {
                                            out.println("<tr><td colspan='8' style='text-align:center; padding: 20px;'>No past reservations found.</td></tr>");
                                        }
                                        while (rs.next()) {
                            %>
                             <tr>
                                <td><%= rs.getString("custName") %></td>
                                <td><%= rs.getString("boardName") %></td>
                                <td><%= rs.getInt("quantity") %></td>
                                <td><%= new SimpleDateFormat("dd/MM/yyyy").format(rs.getDate("rentDate")) %></td>
                                <td><%= new SimpleDateFormat("dd/MM/yyyy").format(rs.getDate("returnDate")) %></td>
                                <td><%= rs.getDate("actualReturnDate") != null ? new SimpleDateFormat("dd/MM/yyyy").format(rs.getDate("actualReturnDate")) : "N/A" %></td>
                                <td><span class="status-badge status-returned">Returned</span></td>
                                <td><%= String.format("%.2f", rs.getDouble("fine")) %></td>
                            </tr>
                            <%
                                        }
                                    }
                                } catch (Exception e) {
                                    e.printStackTrace();
                                } finally {
                                    if (pastConn != null) try { pastConn.close(); } catch (SQLException e) {}
                                }
                            %>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>

    <footer class="footer">
        &copy;  2025 Board Games Management System.
    </footer>
    
    <script>
        $(function() {
            $("#tabs").tabs();
        });
    </script>
</body>
</html>
