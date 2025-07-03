<%@page import="java.sql.*" %>
<%@page import="com.Model.Board"%>
<%@page import="java.util.List"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.net.URLEncoder"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%
    // --- Security Check ---
    if (session.getAttribute("admin") == null) {
        response.sendRedirect("Login.jsp?type=admin&error=Please+log+in+to+continue");
        return;
    }

    String action = request.getParameter("action");

    // --- In-Page Controller for Actions ---
    if (action != null) {
        Connection conn = null;
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/brs", "root", "admin");

            // Handle DELETE action
            if ("delete".equals(action)) {
                int boardID = Integer.parseInt(request.getParameter("boardID"));
                String sql = "DELETE FROM board WHERE boardID = ?";
                try (PreparedStatement ps = conn.prepareStatement(sql)) {
                    ps.setInt(1, boardID);
                    int result = ps.executeUpdate();
                    if (result > 0) {
                        response.sendRedirect("board.jsp?status=delete_success");
                    } else {
                        response.sendRedirect("board.jsp?status=delete_fail");
                    }
                }
                return; // Stop processing after redirect
            }

            // Handle UPDATE action (from edit form submission)
            if ("update".equals(action)) {
                int boardID = Integer.parseInt(request.getParameter("boardID"));
                String boardName = request.getParameter("boardName");
                int boardQuantity = Integer.parseInt(request.getParameter("boardQuantity"));
                int avbleQuant = Integer.parseInt(request.getParameter("avbleQuant"));

                String sql = "UPDATE board SET boardName = ?, boardQuantity = ?, avbleQuant = ? WHERE boardID = ?";
                try (PreparedStatement ps = conn.prepareStatement(sql)) {
                    ps.setString(1, boardName);
                    ps.setInt(2, boardQuantity);
                    ps.setInt(3, avbleQuant);
                    ps.setInt(4, boardID);
                    if (ps.executeUpdate() > 0) {
                        response.sendRedirect("board.jsp?status=update_success");
                    } else {
                        response.sendRedirect("board.jsp?status=update_fail");
                    }
                }
                return; // Stop processing after redirect
            }
        } catch (Exception e) {
            e.printStackTrace();
            // Optional: Redirect to an error page or show an error message
            response.sendRedirect("board.jsp?status=db_error");
            return;
        } finally {
            if (conn != null) try { conn.close(); } catch (SQLException e) {}
        }
    }

    // --- Data Fetching Logic for Display ---
    List<Board> boardList = new ArrayList<>();
    Board boardToEdit = null;
    String searchTerm = request.getParameter("search");
    if (searchTerm == null) searchTerm = "";

    Connection dbConn = null;
    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        dbConn = DriverManager.getConnection("jdbc:mysql://localhost:3306/brs", "root", "admin");

        // Fetch board to edit if action is 'showEditForm'
        if ("showEditForm".equals(action)) {
            int boardID = Integer.parseInt(request.getParameter("boardID"));
            String sql = "SELECT * FROM board WHERE boardID = ?";
            try (PreparedStatement ps = dbConn.prepareStatement(sql)) {
                ps.setInt(1, boardID);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        boardToEdit = new Board();
                        boardToEdit.setBoardID(rs.getInt("boardID"));
                        boardToEdit.setBoardName(rs.getString("boardName"));
                        boardToEdit.setBoardQuantity(rs.getInt("boardQuantity"));
                        boardToEdit.setAvailableQuantity(rs.getInt("avbleQuant"));
                        // Store in request scope for the form
                        request.setAttribute("boardToEdit", boardToEdit);
                    }
                }
            }
        }

        // Fetch all boards for the list display
        String dataQuery = "SELECT * FROM board WHERE boardName LIKE ? ORDER BY boardName ASC";
        try (PreparedStatement psData = dbConn.prepareStatement(dataQuery)) {
            psData.setString(1, "%" + searchTerm + "%");
            try (ResultSet rs = psData.executeQuery()) {
                while (rs.next()) {
                    Board board = new Board();
                    board.setBoardID(rs.getInt("boardID"));
                    board.setBoardName(rs.getString("boardName"));
                    board.setBoardQuantity(rs.getInt("boardQuantity"));
                    board.setAvailableQuantity(rs.getInt("avbleQuant"));
                    boardList.add(board);
                }
            }
        }
    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        if (dbConn != null) try { dbConn.close(); } catch (SQLException e) {}
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Board Game Management - Kuala Terengganu</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <style>
        body { font-family: 'Inter', sans-serif; margin: 0; background-color: #f4f7f9; }
        .header { background-color: #111827; color: white; padding: 1rem 2rem; display: flex; justify-content: space-between; align-items: center; }
        .header .brand { font-size: 1.5rem; font-weight: 700; text-decoration: none; color: white; }
        .header .nav-links a { color: #d1d5db; text-decoration: none; margin-left: 1.5rem; font-weight: 500; }
        .container { max-width: 1200px; margin: 2rem auto; padding: 0 1rem; }
        .list-container, .form-container { background-color: #ffffff; padding: 2rem; border-radius: 8px; box-shadow: 0 4px 6px rgba(0,0,0,0.05); margin-bottom: 2rem; }
        .list-header, .form-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 1.5rem; }
        .list-header h1, .form-header h2 { font-size: 2rem; font-weight: 700; color: #1f2937; margin: 0; }
        .btn-add, .btn-submit { background-color: #16A34A; color: white; text-decoration: none; padding: 0.65rem 1.25rem; border-radius: 6px; font-weight: 500; border: none; cursor: pointer; }
        .btn-cancel { background-color: #6c757d; color: white; text-decoration: none; padding: 0.65rem 1.25rem; border-radius: 6px; font-weight: 500; }
        .search-container { display: flex; justify-content: flex-end; margin-bottom: 1.5rem; }
        .search-container form { display: flex; border: 1px solid #ced4da; border-radius: 6px; overflow: hidden; }
        .search-container input { border: none; padding: 10px; width: 300px; outline: none; }
        .search-container button { border: none; background-color: #f8f9fa; cursor: pointer; padding: 0 15px; }
        .corporate-table { width: 100%; border-collapse: collapse; }
        .corporate-table th, .corporate-table td { padding: 12px 15px; border: 1px solid #e5e7eb; text-align: left; }
        .corporate-table th { background-color: #2563EB; color: white; font-weight: 600; }
        .corporate-table tr:nth-child(even) { background-color: #f9fafb; }
        .action-cell { display: flex; gap: 1rem; }
        .action-btn { background: none; border: none; cursor: pointer; padding: 0; }
        .action-btn svg { width: 20px; height: 20px; }
        .icon-edit { fill: #2563EB; }
        .icon-delete { fill: #dc3545; }
        .form-grid { display: grid; grid-template-columns: repeat(3, 1fr); gap: 1.5rem; }
        .form-group { display: flex; flex-direction: column; }
        .form-group label { margin-bottom: 0.5rem; font-weight: 500; color: #374151; }
        .form-group input { padding: 0.75rem; border: 1px solid #d1d5db; border-radius: 6px; font-size: 1rem; }
        .form-actions { grid-column: 1 / -1; display: flex; justify-content: flex-end; gap: 1rem; margin-top: 1rem; }
        .footer { text-align: center; padding: 1.5rem; margin-top: 2rem; color: #6b7280; font-size: 0.875rem; }
    </style>
</head>
<body>
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

    <div class="container">
        <c:if test="${not empty boardToEdit}">
            <div class="form-container">
                <div class="form-header">
                    <h2>Edit Board Game: <c:out value="${boardToEdit.boardName}"/></h2>
                </div>
                <form action="board.jsp" method="post">
                    <input type="hidden" name="action" value="update"/>
                    <input type="hidden" name="boardID" value="<c:out value='${boardToEdit.boardID}'/>"/>
                    
                    <div class="form-grid">
                        <div class="form-group">
                            <label for="boardName">Board Name</label>
                            <input type="text" id="boardName" name="boardName" value="<c:out value='${boardToEdit.boardName}'/>" required>
                        </div>
                        <div class="form-group">
                            <label for="boardQuantity">Total Quantity</label>
                            <input type="number" id="boardQuantity" name="boardQuantity" value="<c:out value='${boardToEdit.boardQuantity}'/>" required>
                        </div>
                        <div class="form-group">
                            <label for="avbleQuant">Available Quantity</label>
                            <input type="number" id="avbleQuant" name="avbleQuant" value="<c:out value='${boardToEdit.availableQuantity}'/>" required>
                        </div>
                    </div>
                    <div class="form-actions">
                        <a href="board.jsp" class="btn-cancel">Cancel</a>
                        <button type="submit" class="btn-submit">Save Changes</button>
                    </div>
                </form>
            </div>
        </c:if>

        <div class="list-container">
            <div class="list-header">
                <h1>Board Game Management</h1>
                <a href="addBoard.jsp" class="btn-add">Add New Board</a>
            </div>
            
            <div class="search-container">
                <form action="board.jsp" method="get">
                    <input type="text" name="search" placeholder="Search by game name..." value="<%= searchTerm %>">
                    <button type="submit">Search</button>
                </form>
            </div>

            <table class="corporate-table">
                <thead>
                    <tr>
                        <th>Board Name</th>
                        <th>Total Quantity</th>
                        <th>Available Quantity</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <%-- Loop through the pre-fetched list of boards --%>
                    <% for (Board board : boardList) { %>
                        <tr>
                            <td><%= board.getBoardName() %></td>
                            <td><%= board.getBoardQuantity() %></td>
                            <td><%= board.getAvailableQuantity() %></td>
                            <td>
                                <div class="action-cell">
                                    <%-- Corrected EDIT link --%>
                                    <a href="board.jsp?action=showEditForm&boardID=<%= board.getBoardID() %>" class="action-btn" title="Edit">
                                        <svg class="icon-edit" viewBox="0 0 20 20" fill="currentColor"><path d="M17.414 2.586a2 2 0 00-2.828 0L7 10.172V13h2.828l7.586-7.586a2 2 0 000-2.828z"></path><path fill-rule="evenodd" d="M2 6a2 2 0 012-2h4a1 1 0 010 2H4v10h10v-4a1 1 0 112 0v4a2 2 0 01-2 2H4a2 2 0 01-2-2V6z" clip-rule="evenodd"></path></svg>
                                    </a>
                                    <%-- Corrected DELETE link --%>
                                    <a href="javascript:void(0);" onclick="confirmDelete(<%= board.getBoardID() %>)" class="action-btn" title="Delete">
                                        <svg class="icon-delete" viewBox="0 0 20 20" fill="currentColor"><path fill-rule="evenodd" d="M9 2a1 1 0 00-.894.553L7.382 4H4a1 1 0 000 2v10a2 2 0 002 2h8a2 2 0 002-2V6a1 1 0 100-2h-3.382l-.724-1.447A1 1 0 0011 2H9zM7 8a1 1 0 012 0v6a1 1 0 11-2 0V8zm5-1a1 1 0 00-1 1v6a1 1 0 102 0V8a1 1 0 00-1-1z" clip-rule="evenodd"></path></svg>
                                    </a>
                                </div>
                            </td>
                        </tr>
                    <% } %>
                    <%-- Show a message if the list is empty --%>
                    <% if (boardList.isEmpty()) { %>
                        <tr>
                            <td colspan="4" style="text-align: center;">No board games found.</td>
                        </tr>
                    <% } %>
                </tbody>
            </table>
        </div>
    </div>

    <footer class="footer">
        &copy;  2025 Board Games Management System.
    </footer>

    <script>
        // Handle status pop-ups from URL after an action
        document.addEventListener('DOMContentLoaded', function() {
            const urlParams = new URLSearchParams(window.location.search);
            const status = urlParams.get('status');
            if (status) {
                let config = {};
                if (status === 'delete_success') {
                    config = { title: 'Deleted!', text: 'The board game has been removed.', icon: 'success' };
                } else if (status === 'delete_fail') {
                    config = { title: 'Error!', text: 'Could not delete the board game.', icon: 'error' };
                } else if (status === 'update_success') {
                    config = { title: 'Updated!', text: 'Board game details saved.', icon: 'success' };
                } else if (status === 'update_fail') {
                    config = { title: 'Error!', text: 'Could not update board game details.', icon: 'error' };
                } else if (status === 'db_error') {
                    config = { title: 'Database Error!', text: 'An error occurred while communicating with the database.', icon: 'error' };
                }
                
                if (config.title) {
                    Swal.fire(config).then(() => {
                        window.history.replaceState(null, null, window.location.pathname);
                    });
                }
            }
        });

        // SweetAlert2 confirmation dialog for deleting
        function confirmDelete(boardId) {
            Swal.fire({
                title: 'Are you sure?',
                text: "You won't be able to revert this!",
                icon: 'warning',
                showCancelButton: true,
                confirmButtonColor: '#d33',
                cancelButtonColor: '#6c757d',
                confirmButtonText: 'Yes, delete it!'
            }).then((result) => {
                if (result.isConfirmed) {
                    // Redirect to this same page with the delete action
                    window.location.href = 'board.jsp?action=delete&boardID=' + boardId;
                }
            });
        }
    </script>
</body>
</html>