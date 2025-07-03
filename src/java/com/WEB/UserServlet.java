/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package com.WEB;

import com.DAO.AdminDAO;
import com.Model.Admin;
import com.DAO.CustomerDAO;
import com.Model.Customer;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.SQLException;
import java.util.List;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 *
 * @author user
 */
public class UserServlet extends HttpServlet {

      private AdminDAO adminDAO;
    private CustomerDAO customerDAO;

    public void init() {
        adminDAO = new AdminDAO();
        customerDAO = new CustomerDAO();
    }
    
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try ( PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet UserServlet</title>");            
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet UserServlet at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
     protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        try {
            switch (action) {
                case "registerAdmin":
                    registerAdmin(request, response);
                    break;
                case "registerCustomer":
                    registerCustomer(request, response);
                    break;
                case "loginAdmin":
                    loginAdmin(request, response);
                    break;
                case "loginCustomer":
                    loginCustomer(request, response);
                    break;
                    
                     case "/insert":
                    
                case "/delete":
                    deleteCustomer(request, response);
                    break;
                case "/edit":
                    showEditForm(request, response);
                    break;
                case "/update":
                    updateCustomer(request, response);
                    break;
                default:
                    listCustomer(request, response);
                    break;
            }
        } catch (SQLException e) {
            throw new ServletException(e);
        }
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
     protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>
    
    private void registerAdmin(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException {
        String adminUname = request.getParameter("adminUname");
        String adminPwd = request.getParameter("adminPwd");
        String adminNo = request.getParameter("adminNo");
        Admin admin = new Admin(adminUname, adminPwd, adminNo);
        adminDAO.registerAdmin(admin);
        response.sendRedirect("AdminDashboard.jsp");
    }

    private void registerCustomer(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException {
        String custNo = request.getParameter("custNo");
        String custName = request.getParameter("custName");
        String custClub = request.getParameter("custClub");
        String custUname = request.getParameter("custUname");
        String custPwd = request.getParameter("custPwd");
        Customer customer = new Customer(custNo, custName, custClub, custUname, custPwd);
        customerDAO.registerCustomer(customer);
        response.sendRedirect("Login.jsp?type=customer");
    }
    
        private void registerCustomerAdmin(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException {
        String custNo = request.getParameter("custNo");
        String custName = request.getParameter("custName");
        String custClub = request.getParameter("custClub");
        String custUname = request.getParameter("custUname");
        String custPwd = request.getParameter("custPwd");
        Customer customer = new Customer(custNo, custName, custClub, custUname, custPwd);
        customerDAO.registerCustomerAdmin(customer);
        response.sendRedirect("ListCustomer.jsp?type=customer");
    }

    private void loginAdmin(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException, ServletException {
        String adminUname = request.getParameter("adminUname");
        String adminPwd = request.getParameter("adminPwd");
        Admin admin = adminDAO.loginAdmin(adminUname);

        if (admin != null && admin.getAdminPwd().equals(adminPwd)) {
            request.getSession().setAttribute("admin", admin);
            response.sendRedirect("AdminDashboard.jsp");
        } else {
            response.sendRedirect("LoginError.jsp");
        }
    }

    private void loginCustomer(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException, ServletException {
        String custUname = request.getParameter("custUname");
        String custPwd = request.getParameter("custPwd");
        Customer customer = customerDAO.loginCustomer(custUname);

        if (customer != null && customer.getCustPwd().equals(custPwd)) {
            request.getSession().setAttribute("customer", customer);
            response.sendRedirect("customerDashboard.jsp");
        } else {
            response.sendRedirect("LoginError.jsp");
        }
    }
    
private void listCustomer(HttpServletRequest request, HttpServletResponse response)
        throws SQLException, ServletException, IOException {
    List<Customer> listCustomers = customerDAO.getAllCustomers();
    request.setAttribute("listCustomers", listCustomers);
    RequestDispatcher dispatcher = request.getRequestDispatcher("ListCustomer.jsp");
    dispatcher.forward(request, response);
}

    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
        throws SQLException, ServletException, IOException {
    String custUname = request.getParameter("custUname");
    Customer existingCustomer = customerDAO.selectCustomerByUsername(custUname);
    RequestDispatcher dispatcher = request.getRequestDispatcher("CustomerRegistration.jsp");
    request.setAttribute("customer", existingCustomer);
    dispatcher.forward(request, response);
}

    
    private void updateCustomer(HttpServletRequest request, HttpServletResponse response)
        throws SQLException, IOException {
    String custUname = request.getParameter("custUname");
    String custName = request.getParameter("custName");
    String custClub = request.getParameter("custClub");
    String custPwd = request.getParameter("custPwd");

    Customer customer = new Customer(custUname, custName, custClub, custPwd);
    customerDAO.updateCustomerByUsername(customer);

    response.sendRedirect("listCustomers");
}



    private void deleteCustomer(HttpServletRequest request, HttpServletResponse response)
        throws SQLException, IOException {
    String custUname = request.getParameter("custUname");
    customerDAO.deleteCustomerByUsername(custUname);

    response.sendRedirect("listCustomers");
}



}
