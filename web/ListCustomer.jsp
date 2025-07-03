<%@page import="com.Model.Customer"%>
<%@page import="java.net.URLEncoder"%>
<%@page import="java.util.List"%>
<%@page import="com.DAO.CustomerDAO"%>
<%@page import="java.sql.SQLException"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%
    // --- Security Check ---
    if (session.getAttribute("admin") == null) {
        response.sendRedirect("Login.jsp?type=admin&error=Please+log+in+to+continue");
        return;
    }

    CustomerDAO customerDAO = new CustomerDAO();
    String action = request.getParameter("action");

    // --- Action Handler: Process Delete or Update ---
    if (action != null) {
        // HANDLE DELETE ACTION
        if ("delete".equals(action)) {
            String custUnameToDelete = request.getParameter("custUname");
            String deleteStatus = "delete_fail";
            try {
                if (custUnameToDelete != null) {
                    if (customerDAO.deleteCustomerByUsername(custUnameToDelete)) {
                        deleteStatus = "delete_success";
                    }
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }
            response.sendRedirect("ListCustomer.jsp?status=" + deleteStatus);
            return;
        }

        // HANDLE UPDATE ACTION
        if ("update".equals(action)) {
            String updateStatus = "update_fail";
            try {
                String custUname = request.getParameter("custUname");
                String custName = request.getParameter("custName");
                String custClub = request.getParameter("custClub");
                String custPwd = request.getParameter("custPwd");

                Customer customerToUpdate = new Customer();
                customerToUpdate.setCustUname(custUname);
                customerToUpdate.setCustName(custName);
                customerToUpdate.setCustClub(custClub);
                customerToUpdate.setCustPwd(custPwd);

                if (customerDAO.updateCustomerByUsername(customerToUpdate)) {
                    updateStatus = "update_success";
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
            response.sendRedirect("ListCustomer.jsp?status=" + updateStatus);
            return;
        }
    }

    // --- Data Fetching for Display ---
    if ("showEditForm".equals(action)) {
        String custUnameToEdit = request.getParameter("custUname");
        Customer customerToEdit = customerDAO.selectCustomerByUsername(custUnameToEdit);
        request.setAttribute("customerToEdit", customerToEdit);
    }
    
    String searchTerm = request.getParameter("search");
    if (searchTerm == null) searchTerm = "";
    
    int currentPage = request.getParameter("page") != null ? Integer.parseInt(request.getParameter("page")) : 1;
    int recordsPerPage = 10;
    
    List<Customer> listCustomers = customerDAO.getAllCustomers(searchTerm);
    
    int totalRecords = listCustomers.size();
    int totalPages = (int) Math.ceil((double) totalRecords / recordsPerPage);

    int start = (currentPage - 1) * recordsPerPage;
    int end = Math.min(start + recordsPerPage, totalRecords);
    List<Customer> paginatedList = listCustomers.subList(start, end);
    pageContext.setAttribute("paginatedList", paginatedList);
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Customer Management - Kuala Terengganu</title>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
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
        .action-cell { display: flex; gap: 1rem; }
        .action-btn { background: none; border: none; cursor: pointer; padding: 0; }
        .action-btn svg { width: 20px; height: 20px; }
        .icon-edit { fill: #2563EB; }
        .icon-delete { fill: #dc3545; }
        .form-grid { display: grid; grid-template-columns: repeat(2, 1fr); gap: 1.5rem; }
        .form-group { display: flex; flex-direction: column; }
        .form-group label { margin-bottom: 0.5rem; font-weight: 500; color: #374151; }
        .form-group input { padding: 0.75rem; border: 1px solid #d1d5db; border-radius: 6px; font-size: 1rem; }
        .form-actions { grid-column: 1 / -1; display: flex; justify-content: flex-end; gap: 1rem; margin-top: 1rem; }
        .pagination { display: flex; justify-content: center; padding: 20px 0; }
        .pagination a, .pagination span { color: #2563EB; padding: 8px 16px; text-decoration: none; border: 1px solid #ddd; margin: 0 4px; border-radius: 4px; }
        .pagination span.current { background-color: #2563EB; color: white; border-color: #2563EB; }
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
        <c:if test="${not empty customerToEdit}">
            <div class="form-container">
                <div class="form-header">
                    <h2>Edit Customer: <c:out value="${customerToEdit.custName}"/></h2>
                </div>
                <form action="ListCustomer.jsp" method="post">
                    <input type="hidden" name="action" value="update"/>
                    <input type="hidden" name="custUname" value="<c:out value="${customerToEdit.custUname}"/>"/>
                    <div class="form-grid">
                        <div class="form-group">
                            <label for="custName">Full Name</label>
                            <input type="text" id="custName" name="custName" value="<c:out value="${customerToEdit.custName}"/>" required>
                        </div>
                        <div class="form-group">
                            <label for="custClub">Club</label>
                            <input type="text" id="custClub" name="custClub" value="<c:out value="${customerToEdit.custClub}"/>" required>
                        </div>
                        <div class="form-group" style="display: none">
                             <label for="custPwd">New Password (leave blank to keep current)</label>
                             <input type="password" id="custPwd" name="custPwd" value="<c:out value="${customerToEdit.custPwd}"/>">
                        </div>
                    </div>
                    <div class="form-actions">
                        <a href="ListCustomer.jsp" class="btn-cancel">Cancel</a>
                        <button type="submit" class="btn-submit">Save Changes</button>
                    </div>
                </form>
            </div>
        </c:if>

        <div class="list-container">
            <div class="list-header">
                <h1>Customer Management</h1>
                <a href="CustomerRegistrationAdmin.jsp" class="btn-add">Add New Customer</a>
            </div>
            
            <div class="search-container">
                <form action="ListCustomer.jsp" method="get">
                    <input type="text" name="search" placeholder="Search by name or club..." value="<%= URLEncoder.encode(searchTerm, "UTF-8") %>">
                    <button type="submit">Search</button>
                </form>
            </div>

            <table class="corporate-table">
                <thead>
                    <tr>
                        <th>Phone No</th>
                        <th>Name</th>
                        <th>Club</th>
                        <th>Username</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="customer" items="${paginatedList}">
                        <tr>
                            <td><c:out value="${customer.custNo}"/></td>
                            <td><c:out value="${customer.custName}"/></td>
                            <td><c:out value="${customer.custClub}"/></td>
                            <td><c:out value="${customer.custUname}"/></td>
                            <td>
                                <div class="action-cell">
                                    <a href="ListCustomer.jsp?action=showEditForm&custUname=<c:out value='${customer.custUname}'/>" class="action-btn" title="Edit">
                                        <svg class="icon-edit" viewBox="0 0 20 20" fill="currentColor"><path d="M17.414 2.586a2 2 0 00-2.828 0L7 10.172V13h2.828l7.586-7.586a2 2 0 000-2.828z"></path><path fill-rule="evenodd" d="M2 6a2 2 0 012-2h4a1 1 0 010 2H4v10h10v-4a1 1 0 112 0v4a2 2 0 01-2 2H4a2 2 0 01-2-2V6z" clip-rule="evenodd"></path></svg>
                                    </a>
                                    <a href="javascript:void(0);" onclick="confirmDelete('<c:out value="${customer.custUname}"/>')" class="action-btn" title="Delete">
                                        <svg class="icon-delete" viewBox="0 0 20 20" fill="currentColor"><path fill-rule="evenodd" d="M9 2a1 1 0 00-.894.553L7.382 4H4a1 1 0 000 2v10a2 2 0 002 2h8a2 2 0 002-2V6a1 1 0 100-2h-3.382l-.724-1.447A1 1 0 0011 2H9zM7 8a1 1 0 012 0v6a1 1 0 11-2 0V8zm5-1a1 1 0 00-1 1v6a1 1 0 102 0V8a1 1 0 00-1-1z" clip-rule="evenodd"></path></svg>
                                    </a>
                                </div>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
            
            <div class="pagination">
                <%
                    // This block is now one single, safe scriptlet.
                    String urlParams = searchTerm.isEmpty() ? "" : "&search=" + URLEncoder.encode(searchTerm, "UTF-8");

                    // "Previous" link
                    if (currentPage > 1) {
                        out.println("<a href='ListCustomer.jsp?page=" + (currentPage - 1) + urlParams + "'>Previous</a>");
                    }

                    // Page number links
                    for (int i = 1; i <= totalPages; i++) {
                        if (i == currentPage) {
                            out.println("<span class='current'>" + i + "</span>");
                        } else {
                            out.println("<a href='ListCustomer.jsp?page=" + i + urlParams + "'>" + i + "</a>");
                        }
                    }

                    // "Next" link
                    if (currentPage < totalPages) {
                        out.println("<a href='ListCustomer.jsp?page=" + (currentPage + 1) + urlParams + "'>Next</a>");
                    }
                %>
            </div>
            </div>
    </div>

    <footer class="footer">
        &copy;  2025 Board Games Management System.
    </footer>
    
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            const urlParams = new URLSearchParams(window.location.search);
            const status = urlParams.get('status');
            if (status) {
                let config = {};
                if (status === 'delete_success') {
                    config = { title: 'Deleted!', text: 'The customer has been removed.', icon: 'success' };
                } else if (status === 'delete_fail') {
                    config = { title: 'Error!', text: 'Could not delete the customer.', icon: 'error' };
                } else if (status === 'update_success') {
                    config = { title: 'Updated!', text: 'Customer details saved successfully.', icon: 'success' };
                } else if (status === 'update_fail') {
                    config = { title: 'Error!', text: 'Could not save customer details.', icon: 'error' };
                }
                
                if (config.title) {
                    Swal.fire(config).then(() => {
                        window.history.replaceState(null, null, window.location.pathname);
                    });
                }
            }
        });
        
        function confirmDelete(custUname) {
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
                    window.location.href = 'ListCustomer.jsp?action=delete&custUname=' + encodeURIComponent(custUname);
                }
            });
        }
    </script>
</body>
</html>