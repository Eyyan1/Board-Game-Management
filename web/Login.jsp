<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%
    String type = request.getParameter("type");
    boolean isAdminLogin = type != null && type.equals("admin");
    String pageTitle = isAdminLogin ? "Admin Login" : "Customer Login";
    String formAction = isAdminLogin ? "loginAdmin" : "loginCustomer";
    String usernameParam = isAdminLogin ? "adminUname" : "custUname";
    String passwordParam = isAdminLogin ? "adminPwd" : "custPwd";
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><%= pageTitle %></title>
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
            margin-bottom: 2.5rem;
        }

        .header svg {
            margin: 0 auto;
            height: 3rem;
            width: auto;
            color: #2563EB;
        }

        .header h1 {
            margin-top: 1rem;
            font-size: 1.875rem;
            font-weight: 700;
            letter-spacing: -0.025em;
            color: #111827;
        }

        /* --- Form Styles --- */
        .form-group {
            margin-bottom: 1.5rem;
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
            border-color: #2563EB;
            box-shadow: 0 0 0 3px rgba(37, 99, 235, 0.1);
            outline: none;
        }
        
        .btn-login {
            width: 100%;
            padding: 0.75rem 1rem;
            font-size: 1rem;
            font-weight: 600;
            color: #ffffff;
            background-color: #2563EB;
            border: none;
            border-radius: 0.375rem;
            cursor: pointer;
            transition: background-color 0.15s ease-in-out;
        }
        .btn-login:hover {
            background-color: #1D4ED8;
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
            margin-top: 2rem;
            text-align: center;
            font-size: 0.875rem;
        }
        .back-link a {
            color: #2563EB;
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
                        <path stroke-linecap="round" stroke-linejoin="round" d="M15.75 5.25a3 3 0 013 3m3 0a6 6 0 01-7.029 5.912c-.563-.097-1.159.026-1.563.43L10.5 17.25H8.25v2.25H6v2.25H2.25v-2.818c0-.597.237-1.17.659-1.591l6.499-6.499c.404-.404.527-1 .43-1.563A6 6 0 1121.75 8.25z" />
                    </svg>
                    <h1><%= pageTitle %></h1>
                </div>
                
                <!-- Display error message if it exists -->
                <c:if test="${param.error != null}">
                    <div class="error-message">
                        <p>${param.error}</p>
                    </div>
                </c:if>

                <form action="UserServlet" method="post">
                    <input type="hidden" name="action" value="<%= formAction %>">

                    <div class="form-group">
                        <label for="username">Username</label>
                        <input type="text" id="username" class="form-control" name="<%= usernameParam %>" required>
                    </div>

                    <div class="form-group">
                        <label for="password">Password</label>
                        <input type="password" id="password" class="form-control" name="<%= passwordParam %>" required>
                    </div>

                    <button type="submit" class="btn-login">Login</button>
                </form>

                <div class="back-link">
                    <a href="index.html">&larr; Back to Home</a>
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
