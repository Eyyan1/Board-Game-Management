<%@page import="com.Model.Board"%>
<%@page import="com.DAO.BoardDAO"%>
<%@page import="com.Model.Customer"%>
<%@page import="com.DAO.CustomerDAO"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.time.LocalDate"%>
<%
    // --- Security Check ---
    if (session.getAttribute("customer") == null) {
        response.sendRedirect("Login.jsp?type=customer&error=Please+log+in+to+continue");
        return;
    }

    int custID = Integer.parseInt(request.getParameter("id"));
    int boardID = Integer.parseInt(request.getParameter("bid"));

    CustomerDAO customerDAO = new CustomerDAO();
    Customer customer = customerDAO.getCustomerById(custID);

    BoardDAO boardDAO = new BoardDAO();
    Board board = boardDAO.getBoardById(boardID);

    String currentDate = LocalDate.now().toString();
    String returnDate = LocalDate.now().plusDays(5).toString();
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Board Game Reservation</title>
    <link rel="stylesheet" href="style.css">
    <!-- Google Fonts: Inter -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <style>
        body { font-family: 'Inter', sans-serif; margin: 0; background-color: #f4f7f9; }
        .header { background-color: #111827; color: white; padding: 1rem 2rem; display: flex; justify-content: space-between; align-items: center; }
        .header .brand { font-size: 1.5rem; font-weight: 700; text-decoration: none; color: white; }
        .header .nav-links a { color: #d1d5db; text-decoration: none; margin-left: 1.5rem; font-weight: 500; transition: color 0.2s; }
        .header .nav-links a:hover { color: white; }
        .container { max-width: 800px; margin: 2rem auto; padding: 0 1rem; }
        .form-container { background-color: #ffffff; padding: 2rem; border-radius: 8px; box-shadow: 0 4px 6px rgba(0,0,0,0.05); }
        .form-header { text-align: center; margin-bottom: 2rem; }
        .form-header h1 { font-size: 2rem; font-weight: 700; color: #1f2937; }
        .form-group { margin-bottom: 1.5rem; }
        .form-group label { display: block; margin-bottom: 0.5rem; font-size: 0.875rem; font-weight: 600; color: #374151; }
        .form-control { width: 100%; padding: 0.75rem 1rem; font-size: 1rem; border: 1px solid #D1D5DB; border-radius: 0.375rem; box-sizing: border-box; }
        input[readonly], input[disabled] { background-color: #e9ecef; cursor: not-allowed; }
        .button-group { display: flex; justify-content: flex-end; gap: 1rem; margin-top: 2rem; }
        .btn { padding: 0.75rem 1.5rem; font-size: 1rem; font-weight: 500; border-radius: 6px; text-decoration: none; cursor: pointer; border: none; text-align: center; }
        .btn-primary { background-color: #16A34A; color: white; }
        .btn-primary:hover { background-color: #15803D; }
        .btn-secondary { background-color: #6c757d; color: white; }
        .btn-secondary:hover { background-color: #5a6268; }
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
        <div class="form-container">
            <div class="form-header">
                <h1>Board Game Reservation</h1>
            </div>
            <form action="ReservationServlet" method="post" id="reservationForm">
                <!-- Hidden fields -->
                <input type="hidden" name="bid" value="<%= board.getBoardID() %>">
                <input type="hidden" name="cid" value="<%= custID %>">

                <div class="form-group">
                    <label>Customer Name</label>
                    <input type="text" class="form-control" value="<%= customer.getCustName() %>" readonly>
                </div>

                <div class="form-group">
                    <label>Board Game</label>
                    <input type="text" class="form-control" value="<%= board.getBoardName() %>" readonly>
                </div>

                <div class="form-group">
                    <label>Date of Rent</label>
                    <input type="text" class="form-control" name="date" value="<%= currentDate %>" readonly>
                </div>

                <div class="form-group">
                    <label>Return By</label>
                    <input type="text" class="form-control" name="rdate" value="<%= returnDate %>" readonly>
                </div>

                <div class="form-group">
                    <label for="quantity">Quantity (Available: <%= board.getAvailableQuantity() %>)</label>
                    <input type="number" id="quantity" class="form-control" name="quantity" min="1" max="<%= board.getAvailableQuantity() %>" placeholder="Enter quantity" required>
                </div>
                
                <div class="button-group">
                    <a href="boardcust.jsp" class="btn btn-secondary">Cancel</a>
                    <button type="submit" class="btn btn-primary">Confirm Reservation</button>
                </div>
            </form>
        </div>
    </div>

    <footer class="footer">
        &copy;  2025 Board Games Management System.
    </footer>
    
    <script>
        document.getElementById('reservationForm').addEventListener('submit', function(event) {
            event.preventDefault(); // Prevent the form from submitting immediately
            
            Swal.fire({
                title: 'Confirm Reservation?',
                text: "You are about to reserve this board game.",
                icon: 'question',
                showCancelButton: true,
                confirmButtonColor: '#16A34A',
                cancelButtonColor: '#6c757d',
                confirmButtonText: 'Yes, reserve it!'
            }).then((result) => {
                if (result.isConfirmed) {
                    // If confirmed, submit the form
                    event.target.submit();
                }
            });
        });
    </script>

</body>
</html>
