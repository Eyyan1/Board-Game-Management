<%@page import="java.sql.*" %>
<%@page import="java.net.URLEncoder" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    // --- Security Check: Ensure an admin is logged in ---
    if (session.getAttribute("admin") == null) {
        response.sendRedirect("Login.jsp?type=admin&error=Please+log+in+to+continue");
        return;
    }

    String status = null; // Will hold the result of the POST action

    // --- In-Page Controller: Handle the form submission ---
    if ("POST".equalsIgnoreCase(request.getMethod())) {
        String boardName = request.getParameter("boardName");
        int boardQuantity = 0;
        
        status = "add_fail"; // Default status

        // Try to parse the integer quantity, handle potential errors
        try {
            boardQuantity = Integer.parseInt(request.getParameter("boardQuantity"));
        } catch (NumberFormatException e) {
            // If quantity is not a valid number, redirect with an error status in the URL
            response.sendRedirect("addBoard.jsp?status=invalid_quantity");
            return;
        }

        int availableQuantity = boardQuantity;

        Connection conn = null;
        PreparedStatement ps = null;
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/brs", "root", "admin");

            String sql = "INSERT INTO board (boardName, boardQuantity, avbleQuant) VALUES (?, ?, ?)";
            ps = conn.prepareStatement(sql);
            
            ps.setString(1, boardName);
            ps.setInt(2, boardQuantity);
            ps.setInt(3, availableQuantity);

            int result = ps.executeUpdate();

            if (result > 0) {
                // If insertion is successful, set the status for the JavaScript pop-up
                status = "add_success";
            }
        } catch (Exception e) {
            e.printStackTrace();
            status = "db_error"; // Set a specific error for database issues
        } finally {
            if (ps != null) try { ps.close(); } catch (SQLException e) {}
            if (conn != null) try { conn.close(); } catch (SQLException e) {}
        }
        
        // IMPORTANT: We do NOT redirect here. 
        // We let the page render so the script at the bottom can show the pop-up.
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Add New Board Game - Kuala Terengganu</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <style>
        body { font-family: 'Inter', sans-serif; margin: 0; background-color: #f4f7f9; }
        .header { background-color: #111827; color: white; padding: 1rem 2rem; display: flex; justify-content: space-between; align-items: center; }
        .header .brand { font-size: 1.5rem; font-weight: 700; text-decoration: none; color: white; }
        .header .nav-links a { color: #d1d5db; text-decoration: none; margin-left: 1.5rem; font-weight: 500; }
        .container { max-width: 800px; margin: 2rem auto; padding: 0 1rem; }
        .form-container { background-color: #ffffff; padding: 2.5rem; border-radius: 8px; box-shadow: 0 4px 10px rgba(0,0,0,0.05); }
        .form-header h1 { font-size: 2rem; font-weight: 700; color: #1f2937; margin: 0; margin-bottom: 2rem; text-align: center; }
        .form-group { margin-bottom: 1.5rem; }
        .form-group label { display: block; margin-bottom: 0.5rem; font-weight: 500; color: #374151; }
        .form-group input { width: 100%; padding: 0.75rem; border: 1px solid #d1d5db; border-radius: 6px; font-size: 1rem; box-sizing: border-box; }
        .form-actions { display: flex; justify-content: flex-end; gap: 1rem; margin-top: 2rem; }
        .btn-submit { background-color: #2563EB; color: white; text-decoration: none; padding: 0.75rem 1.5rem; border-radius: 6px; font-weight: 500; border: none; cursor: pointer; }
        .btn-cancel { background-color: #6c757d; color: white; text-decoration: none; padding: 0.75rem 1.5rem; border-radius: 6px; font-weight: 500; }
        .footer { text-align: center; padding: 1.5rem; margin-top: 2rem; color: #6b7280; font-size: 0.875rem; }
    </style>
</head>
<body>
    <!-- Navbar -->
    <nav class="header">
        <a class="brand" href="AdminDashboard.jsp">Admin Dashboard</a>
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
        <div class="form-container">
            <div class="form-header">
                <h1>Add a New Board Game</h1>
            </div>
            
            <form action="addBoard.jsp" method="post">
                <div class="form-group">
                    <label for="boardName">Board Game Name</label>
                    <input type="text" id="boardName" name="boardName" placeholder="e.g., Settlers of Catan" required>
                </div>
                
                <div class="form-group">
                    <label for="boardQuantity">Total Quantity</label>
                    <input type="number" id="boardQuantity" name="boardQuantity" min="1" placeholder="e.g., 5" required>
                </div>
                
                <div class="form-actions">
                    <a href="board.jsp" class="btn-cancel">Cancel</a>
                    <button type="submit" class="btn-submit">Add Board Game</button>
                </div>
            </form>
        </div>
    </div>

    <footer class="footer">
        &copy;  2025 Board Games Management System.
    </footer>
    
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            // --- This block handles the pop-up AFTER the form is submitted ---
            const postStatus = "<%= (status != null) ? status : "" %>";

            if (postStatus === 'add_success') {
                Swal.fire({
                    title: 'Added!',
                    text: 'The new board game has been saved.',
                    icon: 'success'
                }).then((result) => {
                    // After the user clicks "OK", redirect to the board list page
                    if (result.isConfirmed) {
                        window.location.href = 'board.jsp';
                    }
                });
            } else if (postStatus === 'add_fail' || postStatus === 'db_error') {
                Swal.fire({
                    title: 'Error!',
                    text: 'Could not add the board game. Please try again.',
                    icon: 'error'
                });
            }

            // --- This block handles the "invalid quantity" error from the URL ---
            const urlParams = new URLSearchParams(window.location.search);
            const urlStatus = urlParams.get('status');
            if (urlStatus === 'invalid_quantity') {
                Swal.fire({
                    title: 'Invalid Input',
                    text: 'Please enter a valid number for the quantity.',
                    icon: 'error'
                }).then(() => {
                    // Clean the URL
                    window.history.replaceState(null, null, window.location.pathname);
                });
            }
        });
    </script>
</body>
</html>