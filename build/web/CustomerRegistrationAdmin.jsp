<%@page import="com.Model.Customer"%>
<%@page import="com.DAO.CustomerDAO"%>
<%@page import="java.sql.SQLException"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%
    // This variable will hold the result of the form submission
    String status = null;

    // --- In-Page Controller: Handle the form submission ---
    if ("POST".equalsIgnoreCase(request.getMethod())) {
        
        // 1. Get all form parameters
        String custName = request.getParameter("custName");
        String custClub = request.getParameter("custClub");
        String custNo = request.getParameter("custNo");
        String custUname = request.getParameter("custUname");
        String custPwd = request.getParameter("custPwd");

        // 2. Create a Customer object with the data
        Customer newCustomer = new Customer();
        newCustomer.setCustName(custName);
        newCustomer.setCustClub(custClub);
        newCustomer.setCustNo(custNo);
        newCustomer.setCustUname(custUname);
        newCustomer.setCustPwd(custPwd);

        // 3. Use the DAO to register the customer
        CustomerDAO customerDAO = new CustomerDAO();
        try {
            customerDAO.registerCustomer(newCustomer);
            status = "add_success"; // Set status for the success pop-up
        } catch (SQLException e) {
            e.printStackTrace();
            // Check for duplicate username error
            if (e.getMessage().contains("Duplicate entry")) {
                status = "duplicate_user";
            } else {
                status = "db_error";
            }
        }
        // IMPORTANT: We do NOT redirect here. The script at the bottom will handle it.
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Add New Customer - Kuala Terengganu</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <!-- Add SweetAlert2 library -->
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <style>
        body { font-family: 'Inter', sans-serif; margin: 0; background-color: #f4f7f9; }
        .header { background-color: #111827; color: white; padding: 1rem 2rem; display: flex; justify-content: space-between; align-items: center; }
        .header .brand { font-size: 1.5rem; font-weight: 700; text-decoration: none; color: white; }
        .header .nav-links a { color: #d1d5db; text-decoration: none; margin-left: 1.5rem; font-weight: 500; }
        .container { max-width: 800px; margin: 2rem auto; padding: 0 1rem; }
        .form-container { background-color: #ffffff; padding: 2.5rem; border-radius: 8px; box-shadow: 0 4px 10px rgba(0,0,0,0.05); }
        .form-header h1 { font-size: 2rem; font-weight: 700; color: #1f2937; margin: 0; margin-bottom: 2rem; text-align: center; }
        .form-group { margin-bottom: 1.25rem; }
        .form-group label { display: block; margin-bottom: 0.5rem; font-weight: 500; color: #374151; }
        .form-control { width: 100%; padding: 0.75rem; border: 1px solid #d1d5db; border-radius: 6px; font-size: 1rem; box-sizing: border-box; }
        .form-actions { display: flex; justify-content: flex-end; gap: 1rem; margin-top: 2rem; }
        .btn-submit { background-color: #16A34A; color: white; text-decoration: none; padding: 0.75rem 1.5rem; border-radius: 6px; font-weight: 600; border: none; cursor: pointer; }
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
                <h1>Add New Customer</h1>
            </div>
            
            <!-- The form now submits to itself -->
            <form action="CustomerRegistrationAdmin.jsp" method="post">
                <div class="form-group">
                    <label for="custName">Full Name</label>
                    <input type="text" id="custName" class="form-control" name="custName" required>
                </div>
                <div class="form-group">
                    <label for="custClub">Club/Organization</label>
                    <input type="text" id="custClub" class="form-control" name="custClub" required>
                </div>
                <div class="form-group">
                    <label for="custNo">Phone Number</label>
                    <input type="text" id="custNo" class="form-control" name="custNo" required>
                </div>
                <div class="form-group">
                    <label for="custUname">Username</label>
                    <input type="text" id="custUname" class="form-control" name="custUname" required>
                </div>
                <div class="form-group">
                    <label for="custPwd">Password</label>
                    <input type="password" id="custPwd" class="form-control" name="custPwd" required>
                </div>
                <div class="form-actions">
                    <a href="ListCustomer.jsp" class="btn-cancel">Cancel</a>
                    <button type="submit" class="btn-submit">Add Customer</button>
                </div>
            </form>
        </div>
    </div>

    <footer class="footer">
        &copy;  2025 Board Games Management System.
    </footer>
    
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            // This string is populated by the Java code at the top after a POST request
            const postStatus = "<%= (status != null) ? status : "" %>";

            if (postStatus === 'add_success') {
                Swal.fire({
                    title: 'Success!',
                    text: 'The new customer has been registered.',
                    icon: 'success',
                    confirmButtonText: 'OK'
                }).then((result) => {
                    // After the user clicks "OK", redirect to the customer list page
                    if (result.isConfirmed) {
                        window.location.href = 'ListCustomer.jsp';
                    }
                });
            } else if (postStatus === 'duplicate_user') {
                Swal.fire({
                    title: 'Registration Failed',
                    text: 'A user with that username already exists. Please choose another.',
                    icon: 'error'
                });
            } else if (postStatus === 'db_error') {
                 Swal.fire({
                    title: 'Error!',
                    text: 'A database error occurred. Could not add the customer.',
                    icon: 'error'
                });
            }
        });
    </script>
</body>
</html>
