<%@page import="com.Model.Customer"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    // --- Security Check ---
    Customer customer = (Customer)session.getAttribute("customer");
    if (customer == null) {
        response.sendRedirect("Login.jsp?type=customer&error=Please+log+in+to+continue");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Reservation Successful</title>
    <!-- Google Fonts: Inter -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <style>
        body {
            font-family: 'Inter', sans-serif;
            margin: 0;
            background-color: #f4f7f9;
        }
        .header {
            background-color: #111827;
            color: white;
            padding: 1rem 2rem;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        .header .brand {
            font-size: 1.5rem;
            font-weight: 700;
            text-decoration: none;
            color: white;
        }
        .header .nav-links a {
            color: #d1d5db;
            text-decoration: none;
            margin-left: 1.5rem;
            font-weight: 500;
            transition: color 0.2s;
        }
        .header .nav-links a:hover {
            color: white;
        }
        .container {
            max-width: 600px;
            margin: 4rem auto;
            padding: 0 1rem;
        }
        .success-card {
            background-color: #ffffff;
            padding: 2.5rem;
            border-radius: 12px;
            box-shadow: 0 10px 25px rgba(0,0,0,0.1);
            text-align: center;
        }
        .success-icon {
            width: 80px;
            height: 80px;
            background-color: #dcfce7; /* bg-green-100 */
            color: #16a34a; /* text-green-600 */
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 1.5rem auto;
        }
        .success-icon svg {
            width: 40px;
            height: 40px;
        }
        .success-card h1 {
            font-size: 2rem;
            font-weight: 700;
            color: #1f2937;
            margin: 0;
        }
        .success-card p {
            color: #4b5563;
            font-size: 1rem;
            line-height: 1.5;
            margin-top: 0.5rem;
            margin-bottom: 2rem;
        }
        .button-group {
            display: flex;
            justify-content: center;
            gap: 1rem;
        }
        .btn {
            display: inline-block;
            padding: 0.75rem 1.5rem;
            font-size: 1rem;
            font-weight: 500;
            border-radius: 6px;
            text-decoration: none;
            cursor: pointer;
            border: none;
            text-align: center;
            transition: background-color 0.2s;
        }
        .btn-primary {
            background-color: #2563EB;
            color: white;
        }
        .btn-primary:hover {
            background-color: #1D4ED8;
        }
        .btn-secondary {
            background-color: #e5e7eb;
            color: #1f2937;
        }
         .btn-secondary:hover {
            background-color: #d1d5db;
        }
        .footer {
            text-align: center;
            padding: 1.5rem;
            margin-top: 2rem;
            color: #6b7280;
            font-size: 0.875rem;
        }
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
        <div class="success-card">
            <div class="success-icon">
                <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor">
                    <path stroke-linecap="round" stroke-linejoin="round" d="M4.5 12.75l6 6 9-13.5" />
                </svg>
            </div>
            <h1>Reservation Successful!</h1>
            <p>Your board game has been successfully reserved. You can view your reservation details at any time.</p>
            <div class="button-group">
                <a href="boardcust.jsp" class="btn btn-secondary">Continue Browsing</a>
                <a href="viewReservation.jsp" class="btn btn-primary">View My Reservations</a>
            </div>
        </div>
    </div>

    <footer class="footer">
        &copy;  2025 Board Games Management System.
    </footer>

</body>
</html>
