<%@page import="com.Model.Customer"%>
<%@page import="com.DAO.CustomerDAO"%>
<%@page import="java.sql.SQLException"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
    // --- Security Check ---
    HttpSession httpSession = request.getSession();
    Customer customer = (Customer)httpSession.getAttribute("customer");
    if (customer == null) {
        response.sendRedirect("Login.jsp?type=customer&error=Please+log+in+to+continue");
        return;
    }

    // --- Form Submission Handling (POST Request) ---
    if ("POST".equalsIgnoreCase(request.getMethod())) {
        String status = "fail";
        try {
            CustomerDAO customerDAO = new CustomerDAO();
            
            Customer updatedCustomer = new Customer();
            updatedCustomer.setCustUname(request.getParameter("custUname"));
            updatedCustomer.setCustName(request.getParameter("custName"));
            updatedCustomer.setCustClub(request.getParameter("custClub"));
            updatedCustomer.setCustNo(request.getParameter("custNo"));
            updatedCustomer.setCustPwd(request.getParameter("custPwd"));

            boolean updated = customerDAO.updateCustomerByUsername(updatedCustomer);
            if(updated) {
                Customer refreshedCustomer = customerDAO.loginCustomer(updatedCustomer.getCustUname());
                if (refreshedCustomer != null) {
                    httpSession.setAttribute("customer", refreshedCustomer);
                }
                status = "success";
            } else {
                status = "update_fail";
            }
        } catch (SQLException e) {
            e.printStackTrace();
            status = "update_fail";
        } catch (Exception e){
            e.printStackTrace();
            status = "update_fail";
        }

        response.sendRedirect("profile.jsp?status=" + status);
        return; 
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Profile</title>
    <!-- Google Fonts: Inter -->
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
        .profile-container { background-color: #ffffff; padding: 2rem; border-radius: 8px; box-shadow: 0 4px 6px rgba(0,0,0,0.05); }
        .profile-header { text-align: center; margin-bottom: 2rem; }
        .profile-header h1 { font-size: 2rem; font-weight: 700; color: #1f2937; }
        .form-group { margin-bottom: 1.5rem; }
        .form-group label { display: block; margin-bottom: 0.5rem; font-size: 0.875rem; font-weight: 600; color: #374151; }
        .form-control { width: 100%; padding: 0.75rem 1rem; font-size: 1rem; border: 1px solid #D1D5DB; border-radius: 0.375rem; box-sizing: border-box; }
        input[readonly] { background-color: #e9ecef; cursor: not-allowed; }
        
        /* EDITED: Styles for password visibility toggle */
        .password-container {
            position: relative;
            display: flex;
            align-items: center;
        }
        .password-container .form-control {
            padding-right: 2.5rem; /* Make space for the icon */
        }
        .password-toggle {
            position: absolute;
            right: 0.75rem;
            cursor: pointer;
            color: #6b7280;
        }
        .password-toggle svg {
            width: 1.25rem;
            height: 1.25rem;
        }

        .button-group { display: flex; justify-content: flex-end; gap: 1rem; margin-top: 2rem; border-top: 1px solid #e5e7eb; padding-top: 1.5rem; }
        .btn { padding: 0.75rem 1.5rem; font-size: 1rem; font-weight: 500; border-radius: 6px; text-decoration: none; cursor: pointer; border: none; }
        .btn-primary { background-color: #2563EB; color: white; }
        .btn-secondary { background-color: #6c757d; color: white; }
        .btn-warning { background-color: #f9a826; color: #1f2937;}
        .footer { text-align: center; padding: 1.5rem; margin-top: 2rem; color: #6b7280; font-size: 0.875rem; }
    </style>
</head>
<body>
    <!-- Navbar -->
    <nav class="header">
        <a class="brand" href="customerDashboard.jsp">Board Games Rental</a>
        <div class="nav-links">
            <a href="customerDashboard.jsp">Home</a>
            <a href="profile.jsp">Profile</a>
            <a href="boardcust.jsp">Board Games</a>
            <a href="viewReservation.jsp">My Reservations</a>
            <a href="index.html">Logout</a>
        </div>
    </nav>

    <!-- Main Content -->
    <div class="container">
        <div class="profile-container">
            <div class="profile-header">
                <h1>My Profile</h1>
            </div>
            <form action="profile.jsp" method="post" id="profileForm">
                 <input type="hidden" name="custUname" value="<%= customer.getCustUname() %>">

                <div class="form-group">
                    <label>Username (Read-only)</label>
                    <input type="text" class="form-control" value="<%= customer.getCustUname() %>" readonly>
                </div>
                <div class="form-group">
                    <label for="custName">Full Name</label>
                    <input type="text" id="custName" name="custName" class="form-control" value="<%= customer.getCustName() %>" required>
                </div>
                 <div class="form-group">
                    <label for="custClub">Club/Organization</label>
                    <input type="text" id="custClub" name="custClub" class="form-control" value="<%= customer.getCustClub() %>" required>
                </div>
                 <div class="form-group">
                    <label for="custNo">Phone Number</label>
                    <input type="text" id="custNo" name="custNo" class="form-control" value="<%= customer.getCustNo() %>" required>
                </div>
                <div class="form-group">
                    <label for="custPwd">Password</label>
                    <div class="password-container">
                        <input type="password" id="custPwd" class="form-control" name="custPwd" value="<%= customer.getCustPwd() %>" required>
                        <span class="password-toggle" onclick="togglePasswordVisibility('custPwd')">
                            <svg id="eye-icon" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" d="M2.036 12.322a1.012 1.012 0 010-.639C3.423 7.51 7.36 4.5 12 4.5c4.638 0 8.573 3.007 9.963 7.178.07.207.07.431 0 .639C20.577 16.49 16.64 19.5 12 19.5c-4.638 0-8.573-3.007-9.963-7.178z" /><path stroke-linecap="round" stroke-linejoin="round" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z" /></svg>
                        </span>
                    </div>
                </div>

                <div class="button-group">
                    <a href="customerDashboard.jsp" class="btn btn-secondary">Back to Dashboard</a>
                    <button type="submit" class="btn btn-primary">Update Profile</button>
                </div>
            </form>
        </div>
    </div>
    
    <footer class="footer">
        &copy;  2025 Board Games Management System.
    </footer>
    
    <script>
        function togglePasswordVisibility(fieldId) {
            const passwordField = document.getElementById(fieldId);
            const icon = passwordField.nextElementSibling.querySelector('svg');
            
            if (passwordField.type === "password") {
                passwordField.type = "text";
                icon.innerHTML = `<path stroke-linecap="round" stroke-linejoin="round" d="M3.98 8.223A10.477 10.477 0 001.934 12C3.226 16.338 7.244 19.5 12 19.5c.993 0 1.953-.138 2.863-.395M6.228 6.228A10.45 10.45 0 0112 4.5c4.756 0 8.773 3.162 10.065 7.498a10.523 10.523 0 01-4.293 5.774M6.228 6.228L3 3m3.228 3.228l3.65 3.65m7.894 7.894L21 21m-3.228-3.228l-3.65-3.65m0 0a3 3 0 10-4.243-4.243m4.243 4.243l-4.243-4.243" />`;
            } else {
                passwordField.type = "password";
                icon.innerHTML = `<path stroke-linecap="round" stroke-linejoin="round" d="M2.036 12.322a1.012 1.012 0 010-.639C3.423 7.51 7.36 4.5 12 4.5c4.638 0 8.573 3.007 9.963 7.178.07.207.07.431 0 .639C20.577 16.49 16.64 19.5 12 19.5c-4.638 0-8.573-3.007-9.963-7.178z" /><path stroke-linecap="round" stroke-linejoin="round" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z" />`;
            }
        }
        
        document.addEventListener('DOMContentLoaded', function() {
            const urlParams = new URLSearchParams(window.location.search);
            const status = urlParams.get('status');

            if (status) {
                let alertConfig = {};
                if (status === 'success') {
                    alertConfig = { title: 'Success!', text: 'Your profile has been updated.', icon: 'success' };
                } else if (status === 'fail' || status === 'update_fail') {
                    alertConfig = { title: 'Update Failed', text: 'There was an error updating your profile.', icon: 'error' };
                }

                if (alertConfig.title) {
                    Swal.fire(alertConfig).then(() => {
                        window.history.replaceState(null, null, window.location.pathname);
                    });
                }
            }
        });
    </script>
</body>
</html>
