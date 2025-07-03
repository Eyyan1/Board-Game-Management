<%@page import="com.Model.Customer"%>
<%@page import="java.net.URLEncoder"%>
<%@page import="java.sql.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    // --- Security Check ---
    Customer customer = (Customer)session.getAttribute("customer");
    if (customer == null) {
        response.sendRedirect("Login.jsp?type=customer&error=Please+log+in+to+continue");
        return;
    }
    int custID = customer.getCustID();
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Board Games for Rent</title>
    <link rel="stylesheet" href="style.css">
    <!-- Google Fonts: Inter -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <style>
        body { font-family: 'Inter', sans-serif; margin: 0; background-color: #f4f7f9; }
        .header { background-color: #111827; color: white; padding: 1rem 2rem; display: flex; justify-content: space-between; align-items: center; }
        .header .brand { font-size: 1.5rem; font-weight: 700; text-decoration: none; color: white; }
        .header .nav-links a { color: #d1d5db; text-decoration: none; margin-left: 1.5rem; font-weight: 500; transition: color 0.2s; }
        .header .nav-links a:hover { color: white; }
        .container { max-width: 1200px; margin: 2rem auto; padding: 0 1rem; }
        .list-container { background-color: #ffffff; padding: 2rem; border-radius: 8px; box-shadow: 0 4px 6px rgba(0,0,0,0.05); }
        .list-header { text-align: center; margin-bottom: 2rem; }
        .list-header h1 { font-size: 2rem; font-weight: 700; color: #1f2937; }
        .search-container { display: flex; justify-content: flex-end; margin-bottom: 1.5rem; }
        .search-container form { display: flex; border: 1px solid #ced4da; border-radius: 6px; overflow: hidden; }
        .search-container input { border: none; padding: 10px; width: 300px; outline: none; }
        .search-container button { border: none; background-color: #f8f9fa; cursor: pointer; padding: 0 15px; }
        .corporate-table { width: 100%; border-collapse: collapse; }
        .corporate-table th, .corporate-table td { padding: 12px 15px; border: 1px solid #e5e7eb; text-align: left; }
        .corporate-table th { background-color: #2563EB; color: white; font-weight: 600; }
        .corporate-table tr:nth-child(even) { background-color: #f9fafb; }
        .btn-rent { display: inline-block; padding: 8px 16px; background-color: #16A34A; color: white; text-decoration: none; border-radius: 6px; font-weight: 500; text-align: center; transition: background-color 0.2s; }
        .btn-rent:hover { background-color: #15803D; }
        .btn-disabled { background-color: #9ca3af; cursor: not-allowed; }
        .pagination { display: flex; justify-content: center; padding: 20px 0; }
        .pagination a, .pagination span { color: #2563EB; padding: 8px 16px; text-decoration: none; border: 1px solid #ddd; margin: 0 4px; border-radius: 4px; }
        .pagination span.current { background-color: #2563EB; color: white; border-color: #2563EB; }
        .pagination a:hover { background-color: #dbeafe; }
        .footer { text-align: center; padding: 1.5rem; margin-top: 2rem; color: #6b7280; font-size: 0.875rem; }
    </style>
</head>
<body>
    <!-- Navbar -->
    <nav class="header">
        <a class="brand" href="customerDashboard.jsp">Board Games Rental</a>
        <div class="nav-links">
            <a href="customerDashboard.jsp">Home</a>
            <a href="#">Profile</a>
            <a href="boardcust.jsp">Board Games</a>
            <a href="viewReservation.jsp">My Reservations</a>
            <a href="index.html">Logout</a>
        </div>
    </nav>

    <!-- Main Content -->
    <div class="container">
        <div class="list-container">
            <div class="list-header">
                <h1>Board Games Available for Rent</h1>
            </div>
            
            <%
                String searchTerm = request.getParameter("search");
                if (searchTerm == null) searchTerm = "";
                int currentPage = request.getParameter("page") != null ? Integer.parseInt(request.getParameter("page")) : 1;
                int recordsPerPage = 10;
                int start = (currentPage - 1) * recordsPerPage;
                int totalPages = 0;
            %>
            
            <div class="search-container">
                <form action="boardcust.jsp" method="get">
                    <input type="text" name="search" placeholder="Search by game name..." value="<%= searchTerm %>">
                    <button type="submit">Search</button>
                </form>
            </div>

            <table class="corporate-table">
                <thead>
                    <tr>
                        <th>Board Name</th>
                        <th>Total Quantity</th>
                        <th>Available Now</th>
                        <th>Action</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                        Connection dbConn = null;
                        try {
                            // EDITED: Using standard JDBC connection instead of a custom class
                            Class.forName("com.mysql.jdbc.Driver");
                            String myUrl = "jdbc:mysql://localhost:3306/brs";
                            dbConn = DriverManager.getConnection(myUrl, "root", "admin");
                            
                            String countQuery = "SELECT COUNT(*) FROM board WHERE boardName LIKE ?";
                             try(PreparedStatement psCount = dbConn.prepareStatement(countQuery)) {
                                psCount.setString(1, "%" + searchTerm + "%");
                                try(ResultSet rsCount = psCount.executeQuery()) {
                                    if(rsCount.next()) {
                                        totalPages = (int) Math.ceil((double) rsCount.getInt(1) / recordsPerPage);
                                    }
                                }
                            }
                            
                            String dataQuery = "SELECT * FROM board WHERE boardName LIKE ? ORDER BY boardName ASC LIMIT ?, ?";
                            try(PreparedStatement psData = dbConn.prepareStatement(dataQuery)) {
                                psData.setString(1, "%" + searchTerm + "%");
                                psData.setInt(2, start);
                                psData.setInt(3, recordsPerPage);
                                try(ResultSet rs = psData.executeQuery()) {
                                    while (rs.next()) {
                    %>
                    <tr>
                        <td><%= rs.getString("boardName") %></td>
                        <td><%= rs.getInt("boardQuantity") %></td>
                        <td><%= rs.getInt("avbleQuant") %></td>
                        <td>
                            <% if (rs.getInt("avbleQuant") > 0) { %>
                                <a href="reservation.jsp?id=<%= custID %>&bid=<%= rs.getString("boardID") %>" class="btn-rent">Rent Now</a>
                            <% } else { %>
                                <span class="btn-rent btn-disabled">Unavailable</span>
                            <% } %>
                        </td>
                    </tr>
                    <%
                                    }
                                }
                            }
                        } catch (Exception e) {
                            e.printStackTrace();
                        } finally {
                            if (dbConn != null) try { dbConn.close(); } catch (SQLException e) {}
                        }
                    %>
                </tbody>
            </table>
            
            <div class="pagination">
                <% String urlParams = searchTerm.isEmpty() ? "" : "&search=" + URLEncoder.encode(searchTerm, "UTF-8");
                   if (currentPage > 1) { %><a href="boardcust.jsp?page=<%=currentPage-1%><%=urlParams%>">Previous</a><% } %>
                   <% for (int i = 1; i <= totalPages; i++) { %>
                    <% if (i == currentPage) { %><span class="current"><%= i %></span><% } else { %><a href="boardcust.jsp?page=<%= i %><%= urlParams %>"><%= i %></a><% } %>
                <% } %>
                <% if (currentPage < totalPages) { %><a href="boardcust.jsp?page=<%=currentPage+1%><%=urlParams%>">Next</a><% } %>
            </div>
        </div>
    </div>

    <footer class="footer">
        &copy;  2025 Board Games Management System.
    </footer>

</body>
</html>
