<%-- 
    Document   : LoginError
    Created on : 19 Jun 2024, 9:57:50 AM
    Author     : user
--%>

<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login Error</title>
    <!-- Bootstrap CSS -->
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css"
        integrity="sha384-JcKb8q3iqJ61gNV9KGb8thSsNjpSL0n8PARn9HuZOnIxN0hoP+VmmDGMN5t9UJ0Z"
        crossorigin="anonymous">
    <style>
        .error-container {
            margin-top: 50px;
        }
    </style>
</head>
<body>

    <div class="container error-container">
        <div class="alert alert-danger" role="alert">
            <h4 class="alert-heading">Login Error!</h4>
            <p>Please insert correct username and password.</p>
            <hr>
            <p class="mb-0">If you continue to have issues, please contact support.</p>
        </div>
        <a href="Login.jsp" class="btn btn-primary">Back to Login</a>
    </div>

    <!-- Bootstrap JS and dependencies -->
    <script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"
        integrity="sha384-DfXdz2htPH0lsSSs5nCTpuj/zy4C+OGpamoFVy38MVBnE+IbbVYUew+OrCXaRkfj"
        crossorigin="anonymous"></script>
    <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.5.4/dist/umd/popper.min.js"
        integrity="sha384-1BmUZHln2VrlmIA2uPPA7thfUB3kqzqQ/E46cjFy0cPQHR0ekfO4DHmr1Y8mp2S+"
        crossorigin="anonymous"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"
        integrity="sha384-B4gt1jrGC7Jh4AgTPSdUtOBvfO8sh+TpssLsmuBO880j7hIbbVYUew+OrCXaRkfj"
        crossorigin="anonymous"></script>
</body>
</html>

