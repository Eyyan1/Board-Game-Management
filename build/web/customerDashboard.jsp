<%@page import="com.Model.Customer"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    // --- Security Check ---
    Customer customer = (Customer)session.getAttribute("customer");
    if (customer == null) {
        response.sendRedirect("Login.jsp?type=customer&error=Please+log+in+to+continue");
        return;
    }
    // Set customer ID in session for other pages to use if needed
    session.setAttribute("custID", customer.getCustID());
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Customer Dashboard</title>
    <!-- Google Fonts: Inter -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <style>
        /* --- Basic Reset & Body Styles --- */
        body {
            font-family: 'Inter', sans-serif;
            margin: 0;
            background-color: #f4f7f9;
        }

        /* --- Header Styles --- */
        .header {
            background-color: #111827; /* Dark header */
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

        /* --- Main Content --- */
        .container {
            max-width: 1200px;
            margin: 2rem auto;
            padding: 0 1rem;
        }

        .welcome-header {
            background-color: #ffffff;
            padding: 2rem;
            border-radius: 8px;
            box-shadow: 0 4px 6px rgba(0,0,0,0.05);
            margin-bottom: 2rem;
        }
        .welcome-header h1 {
            margin: 0;
            color: #1f2937;
            font-size: 2rem;
            font-weight: 700;
        }
        .welcome-header p {
            margin: 0.5rem 0 0;
            color: #6b7280;
            font-size: 1.125rem;
        }
        
        /* --- Dashboard Cards --- */
        .card-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 1.5rem;
        }

        .dashboard-card {
            background-color: #ffffff;
            border-radius: 8px;
            box-shadow: 0 4px 6px rgba(0,0,0,0.05);
            padding: 1.5rem;
            display: flex;
            flex-direction: column;
            transition: transform 0.2s, box-shadow 0.2s;
        }
        .dashboard-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 8px 12px rgba(0,0,0,0.08);
        }

        .card-header {
            display: flex;
            align-items: center;
            gap: 1rem;
            padding-bottom: 1rem;
            border-bottom: 1px solid #e5e7eb;
        }

        .card-icon {
            color: #2563EB;
        }
        .card-icon svg {
            width: 2.5rem;
            height: 2.5rem;
        }
        
        .card-title {
            font-size: 1.25rem;
            font-weight: 600;
            color: #111827;
        }

        .card-body p {
            color: #4b5563;
            font-size: 1rem;
            line-height: 1.5;
            flex-grow: 1; /* Pushes button to the bottom */
        }

        .btn-card {
            display: inline-block;
            margin-top: 1rem;
            padding: 0.75rem 1.5rem;
            background-color: #2563EB;
            color: white;
            text-decoration: none;
            border-radius: 6px;
            font-weight: 500;
            text-align: center;
            transition: background-color 0.2s;
        }
        .btn-card:hover {
            background-color: #1D4ED8;
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
            <a href="profile.jsp">Profile</a>
            <a href="boardcust.jsp">Board Games</a>
            <a href="viewReservation.jsp">My Reservations</a>
            <a href="index.html">Logout</a>
        </div>
    </nav>

    <!-- Main Content -->
    <div class="container">
        <div class="welcome-header">
            <h1>Welcome, <%= customer.getCustName() %>!</h1>
            <p>Manage your board game reservations and account details here.</p>
        </div>

        <div class="card-grid">
            <!-- Account Information Card -->
            <div class="dashboard-card">
                <div class="card-header">
                    <div class="card-icon">
                        <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" d="M15.75 6a3.75 3.75 0 11-7.5 0 3.75 3.75 0 017.5 0zM4.501 20.118a7.5 7.5 0 0114.998 0A17.933 17.933 0 0112 21.75c-2.676 0-5.216-.584-7.499-1.632z" /></svg>
                    </div>
                    <h2 class="card-title">Account Information</h2>
                </div>
                <div class="card-body">
                    <p>View and manage your account details and update your personal information.</p>
                    <a href="profile.jsp" class="btn-card">Go to Profile</a>
                </div>
            </div>

            <!-- View Board Games Card -->
            <div class="dashboard-card">
                <div class="card-header">
                     <div class="card-icon">
                        <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" d="M21 7.5l-2.25-1.313M21 7.5v2.25m0-2.25l-2.25 1.313M3 7.5l2.25-1.313M3 7.5v2.25m0-2.25l2.25 1.313M4.5 12l2.25-1.313M4.5 12v2.25m0-2.25l2.25 1.313M19.5 12l-2.25-1.313M19.5 12v2.25m0-2.25l-2.25 1.313M12 21l2.25-1.313M12 21v2.25m0-2.25l-2.25 1.313M12 21l-2.25-1.313m0 0L7.5 12m2.25 7.688l2.25-1.313M14.25 19.688L12 21m0 0l-2.25-1.313m2.25 1.313l2.25-1.313M12 3l2.25 1.313M12 3v2.25m0-2.25L9.75 4.313M12 3L9.75 4.313m0 0L7.5 7.5m2.25-3.188L12 6M14.25 4.313L12 6m0 0L9.75 7.5M12 6L7.5 7.5m4.5 6l2.25-1.313m0 0L16.5 12m-2.25-1.313L12 12m2.25 0L12 12m0 0L9.75 10.687m2.25 1.313L9.75 12m0 0L7.5 10.687m2.25 1.313L7.5 12" /></svg>
                    </div>
                    <h2 class="card-title">View Board Games</h2>
                </div>
                <div class="card-body">
                    <p>Browse our collection of board games and make a reservation for your next game night.</p>
                    <a href="boardcust.jsp" class="btn-card">View Games</a>
                </div>
            </div>

            <!-- View Reservation Card -->
            <div class="dashboard-card">
                <div class="card-header">
                    <div class="card-icon">
                        <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" d="M6.75 3v2.25M17.25 3v2.25M3 18.75V7.5a2.25 2.25 0 012.25-2.25h13.5A2.25 2.25 0 0121 7.5v11.25m-18 0A2.25 2.25 0 005.25 21h13.5A2.25 2.25 0 0021 18.75m-18 0h18M12 15.75h.008v.008H12v-.008z" /></svg>
                    </div>
                    <h2 class="card-title">My Reservations</h2>
                </div>
                <div class="card-body">
                    <p>Review your current and past reservation details to keep track of your gaming history.</p>
                    <a href="viewReservation.jsp" class="btn-card">View Reservations</a>
                </div>
            </div>
        </div>
    </div>

    <footer class="footer">
        &copy;  2025 Board Games Management System.
    </footer>

</body>
</html>
