<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Registration</title>
    <!-- Google Fonts: Inter -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <style>
        /* --- Basic Reset & Body Styles --- */
        body {
            font-family: 'Inter', sans-serif;
            margin: 0;
            background-color: #f8f9fa;
        }

        /* --- Main Layout Containers --- */
        .main-container {
            display: flex;
            min-height: 100vh;
        }

        .content-container {
            width: 100%;
            background-color: #ffffff;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 2rem;
        }

        .image-container {
            width: 50%;
            display: none;
        }
        
        .image-container img {
            object-fit: cover;
            width: 100%;
            height: 100%;
        }
        
        .content-wrapper {
            width: 100%;
            max-width: 28rem;
        }

        /* --- Header & Logo Styles --- */
        .header {
            text-align: center;
            margin-bottom: 2rem;
        }

        .header svg {
            margin: 0 auto;
            height: 3rem;
            width: auto;
            color: #4338CA; /* Indigo color for admin */
        }

        .header h1 {
            margin-top: 1rem;
            font-size: 1.875rem;
            font-weight: 700;
            color: #111827;
        }

        /* --- Form Styles --- */
        .form-group {
            margin-bottom: 1.25rem;
        }

        .form-group label {
            display: block;
            margin-bottom: 0.5rem;
            font-size: 0.875rem;
            font-weight: 500;
            color: #374151;
        }

        .form-control {
            width: 100%;
            padding: 0.75rem 1rem;
            font-size: 1rem;
            border: 1px solid #D1D5DB;
            border-radius: 0.375rem;
            box-sizing: border-box;
            transition: border-color 0.2s, box-shadow 0.2s;
        }
        .form-control:focus {
            border-color: #4338CA;
            box-shadow: 0 0 0 3px rgba(67, 56, 202, 0.1);
            outline: none;
        }
        
        .btn-register {
            width: 100%;
            padding: 0.75rem 1rem;
            font-size: 1rem;
            font-weight: 600;
            color: #ffffff;
            background-color: #4338CA;
            border: none;
            border-radius: 0.375rem;
            cursor: pointer;
            transition: background-color 0.15s ease-in-out;
        }
        .btn-register:hover {
            background-color: #3730A3;
        }

        /* --- Error Message Style --- */
        .error-message {
            background-color: #FEE2E2;
            color: #B91C1C;
            padding: 1rem;
            border-radius: 0.375rem;
            margin-bottom: 1.5rem;
            text-align: center;
        }

        /* --- Footer & Back Link --- */
        .back-link {
            margin-top: 1.5rem;
            text-align: center;
            font-size: 0.875rem;
        }
        .back-link a {
            color: #4338CA;
            text-decoration: none;
            font-weight: 500;
        }
        .back-link a:hover {
            text-decoration: underline;
        }
        
        /* --- Responsive Breakpoints --- */
        @media (min-width: 1024px) {
            .content-container {
                width: 50%;
            }
            .image-container {
                display: block;
            }
        }
    </style>
</head>
<body>

    <div class="main-container">
        <!-- Left Side: Content and Form -->
        <div class="content-container">
            <div class="content-wrapper">
                <div class="header">
                    <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor">
                        <path stroke-linecap="round" stroke-linejoin="round" d="M18 7.5v3m0 0v3m0-3h3m-3 0h-3m-2.25-4.125a3.375 3.375 0 11-6.75 0 3.375 3.375 0 016.75 0zM4 19.235v-.11a6.375 6.375 0 0112.75 0v.109A12.318 12.318 0 0110.374 21c-2.331 0-4.512-.645-6.374-1.766z" />
                    </svg>
                    <h1>Register New Admin</h1>
                </div>
                
                <c:if test="${param.error != null}">
                    <div class="error-message">
                        <p>${param.error}</p>
                    </div>
                </c:if>

                <form action="UserServlet" method="post">
                    <input type="hidden" name="action" value="registerAdmin">

                    <div class="form-group">
                        <label for="adminUname">Username</label>
                        <input type="text" id="adminUname" class="form-control" name="adminUname" required>
                    </div>

                    <div class="form-group">
                        <label for="adminPwd">Password</label>
                        <input type="password" id="adminPwd" class="form-control" name="adminPwd" required>
                    </div>

                     <div class="form-group">
                        <label for="adminNo">Phone Number</label>
                        <input type="text" id="adminNo" class="form-control" name="adminNo" required>
                    </div>

                    <button type="submit" class="btn-register">Register Admin</button>
                </form>

                <div class="back-link">
                    <a href="AdminDashboard.jsp">&larr; Back to Dashboard</a>
                </div>
            </div>
        </div>

        <!-- Right Side: Image -->
        <div class="image-container">
            <img src="brd_images/rightside.jpg" alt="A collection of board games on a shelf">
        </div>
    </div>

</body>
</html>
