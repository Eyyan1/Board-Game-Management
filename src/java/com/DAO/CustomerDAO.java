/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.DAO;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import com.Model.Customer;

/**
 *
 * @author user
 */
public class CustomerDAO {
    private String jdbcURL = "jdbc:mysql://localhost:3306/brs";
    private String jdbcUsername = "root";
    private String jdbcPassword = "admin";

    // It's better practice to define SQL queries as constants at the top
    private static final String INSERT_CUSTOMER_SQL = "INSERT INTO customer (custNo, custName, custClub, custUname, custPwd) VALUES (?, ?, ?, ?, ?);";
    private static final String SELECT_CUSTOMER_BY_USERNAME = "SELECT * FROM customer WHERE custUname = ?";
    private static final String SELECT_ALL_CUSTOMERS = "SELECT * FROM customer";
    private static final String DELETE_CUSTOMER_BY_USERNAME_SQL = "DELETE FROM customer WHERE custUname = ?;";
    private static final String UPDATE_CUSTOMER_BY_USERNAME_SQL = "UPDATE customer SET custName = ?, custClub = ?, custPwd = ? WHERE custUname = ?;";


    protected Connection getConnection() {
        Connection connection = null;
        try {
            // Note: com.mysql.jdbc.Driver is deprecated for newer versions of MySQL.
            // Consider using com.mysql.cj.jdbc.Driver if you upgrade your connector JAR.
            Class.forName("com.mysql.jdbc.Driver");
            connection = DriverManager.getConnection(jdbcURL, jdbcUsername, jdbcPassword);
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
        }
        return connection;
    }

    public void registerCustomer(Customer customer) throws SQLException {
        try (Connection connection = getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(INSERT_CUSTOMER_SQL)) {
            preparedStatement.setString(1, customer.getCustNo());
            preparedStatement.setString(2, customer.getCustName());
            preparedStatement.setString(3, customer.getCustClub());
            preparedStatement.setString(4, customer.getCustUname());
            preparedStatement.setString(5, customer.getCustPwd());
            preparedStatement.executeUpdate();
        }
    }
    
        public void registerCustomerAdmin(Customer customer) throws SQLException {
        try (Connection connection = getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(INSERT_CUSTOMER_SQL)) {
            preparedStatement.setString(1, customer.getCustNo());
            preparedStatement.setString(2, customer.getCustName());
            preparedStatement.setString(3, customer.getCustClub());
            preparedStatement.setString(4, customer.getCustUname());
            preparedStatement.setString(5, customer.getCustPwd());
            preparedStatement.executeUpdate();
        }
    }
    

    public Customer selectCustomerByUsername(String custUname) {
        Customer customer = null;
        // Re-using the constant defined at the top
        try (Connection connection = getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(SELECT_CUSTOMER_BY_USERNAME);) {
            preparedStatement.setString(1, custUname);
            System.out.println(preparedStatement);

            ResultSet rs = preparedStatement.executeQuery();

            while (rs.next()) {
                String custNo = rs.getString("custNo");
                String custName = rs.getString("custName");
                String custClub = rs.getString("custClub");
                String custPwd = rs.getString("custPwd");
                // Assuming your Customer constructor can handle these parameters
                customer = new Customer(custNo, custName, custClub, custUname, custPwd);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return customer;
    }

    public List<Customer> selectAllCustomers() {
        List<Customer> customers = new ArrayList<>();
        // Re-using the constant defined at the top
        try (Connection connection = getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(SELECT_ALL_CUSTOMERS);) {
            System.out.println(preparedStatement);
            ResultSet rs = preparedStatement.executeQuery();

            while (rs.next()) {
                String custNo = rs.getString("custNo");
                String custName = rs.getString("custName");
                String custClub = rs.getString("custClub");
                String custUname = rs.getString("custUname");
                String custPwd = rs.getString("custPwd");
                customers.add(new Customer(custNo, custName, custClub, custUname, custPwd));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return customers;
    }

    public Customer loginCustomer(String custUname) {
        Customer customer = null;
        try (Connection connection = getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(SELECT_CUSTOMER_BY_USERNAME)) {
            preparedStatement.setString(1, custUname);
            ResultSet rs = preparedStatement.executeQuery();
            if (rs.next()) {
                int custID = rs.getInt("custID");
                String custNo = rs.getString("custNo");
                String custName = rs.getString("custName");
                String custClub = rs.getString("custClub");
                String custPwd = rs.getString("custPwd");
                // IMPORTANT: This assumes you have a constructor in Customer.java like:
                // public Customer(int custID, String custNo, String custName, String custClub, String custUname, String custPwd)
                customer = new Customer(custID, custNo, custName, custClub, custUname, custPwd);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return customer;
    }

    // This method seems redundant as it's very similar to selectAllCustomers.
    // Kept it as it was in your original code.
    public List<Customer> getAllCustomers() {
        List<Customer> customers = new ArrayList<>();
        try (Connection connection = getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(SELECT_ALL_CUSTOMERS)) {
            ResultSet rs = preparedStatement.executeQuery();
            while (rs.next()) {
                String custNo = rs.getString("custNo");
                String custName = rs.getString("custName");
                String custClub = rs.getString("custClub");
                String custUname = rs.getString("custUname");
                String custPwd = rs.getString("custPwd");
                customers.add(new Customer(custNo, custName, custClub, custUname, custPwd));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return customers;
    }

    public boolean deleteCustomerByUsername(String custUname) throws SQLException {
        boolean rowDeleted;
        try (Connection connection = getConnection();
             PreparedStatement statement = connection.prepareStatement(DELETE_CUSTOMER_BY_USERNAME_SQL);) {
            statement.setString(1, custUname);
            rowDeleted = statement.executeUpdate() > 0;
        }
        return rowDeleted;
    }

    public boolean updateCustomerByUsername(Customer customer) throws SQLException {
        boolean rowUpdated;
        try (Connection connection = getConnection();
             PreparedStatement statement = connection.prepareStatement(UPDATE_CUSTOMER_BY_USERNAME_SQL);) {
            statement.setString(1, customer.getCustName());
            statement.setString(2, customer.getCustClub());
            statement.setString(3, customer.getCustPwd());
            statement.setString(4, customer.getCustUname());
            rowUpdated = statement.executeUpdate() > 0;
        }
        return rowUpdated;
    }
    
    // This method seems to create a new connection instead of using getConnection().
    // It's better to be consistent. Also, it only retrieves a partial customer object.
    public Customer getCustomerById(int custID) throws SQLException, ClassNotFoundException {
        Customer customer = null;
        String query = "SELECT * FROM customer WHERE custID = ?";
        try (Connection connection = getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(query)) {
            preparedStatement.setInt(1, custID);
            ResultSet resultSet = preparedStatement.executeQuery();
            
            if (resultSet.next()) {
                // Assuming a default constructor and setters in your Customer model
                customer = new Customer();
                customer.setCustID(resultSet.getInt("custID"));
                customer.setCustNo(resultSet.getString("custNo"));
                customer.setCustName(resultSet.getString("custName"));
                customer.setCustClub(resultSet.getString("custClub"));
                customer.setCustUname(resultSet.getString("custUname"));
                // Don't retrieve password unless necessary
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return customer;
    }
    
    // ======================================================================
    // ==                  NEW METHODS TO FIX THE ERROR                    ==
    // ======================================================================
    
    /**
     * Retrieves a paginated list of customers, with an optional search term.
     * This is one of the missing methods from the error.
     */
    public List<Customer> getPaginatedCustomers(String searchTerm, int currentPage, int recordsPerPage) {
        List<Customer> customers = new ArrayList<>();
        int start = currentPage * recordsPerPage - recordsPerPage;
        
        StringBuilder sql = new StringBuilder("SELECT * FROM customer");

        // Append search condition if a search term is provided
        if (searchTerm != null && !searchTerm.trim().isEmpty()) {
            sql.append(" WHERE custName LIKE ? OR custUname LIKE ?");
        }

        // Append pagination
        sql.append(" LIMIT ? OFFSET ?");

        try (Connection connection = getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(sql.toString())) {
            
            int paramIndex = 1;
            if (searchTerm != null && !searchTerm.trim().isEmpty()) {
                preparedStatement.setString(paramIndex++, "%" + searchTerm + "%");
                preparedStatement.setString(paramIndex++, "%" + searchTerm + "%");
            }
            preparedStatement.setInt(paramIndex++, recordsPerPage);
            preparedStatement.setInt(paramIndex, start);
            
            ResultSet rs = preparedStatement.executeQuery();
            
            while (rs.next()) {
                String custNo = rs.getString("custNo");
                String custName = rs.getString("custName");
                String custClub = rs.getString("custClub");
                String custUname = rs.getString("custUname");
                String custPwd = rs.getString("custPwd");
                customers.add(new Customer(custNo, custName, custClub, custUname, custPwd));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return customers;
    }

    /**
     * Gets the total count of customers, with an optional search term.
     * This is the second missing method from the error.
     */
    public int getCustomerCount(String searchTerm) {
        int count = 0;
        StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM customer");

        // Append search condition if a search term is provided
        if (searchTerm != null && !searchTerm.trim().isEmpty()) {
            sql.append(" WHERE custName LIKE ? OR custUname LIKE ?");
        }

        try (Connection connection = getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(sql.toString())) {
            
            if (searchTerm != null && !searchTerm.trim().isEmpty()) {
                preparedStatement.setString(1, "%" + searchTerm + "%");
                preparedStatement.setString(2, "%" + searchTerm + "%");
            }

            ResultSet rs = preparedStatement.executeQuery();
            if (rs.next()) {
                count = rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return count;
    }
      public List<Customer> getAllCustomers(String searchTerm) throws SQLException {
        List<Customer> customers = new ArrayList<>();
        String sql;

        // Dynamically choose the SQL query based on whether a search term exists
        if (searchTerm != null && !searchTerm.trim().isEmpty()) {
            sql = "SELECT * FROM customer WHERE custName LIKE ? OR custUname LIKE ?";
        } else {
            sql = "SELECT * FROM customer";
        }

        // 4. Use 'try-with-resources' to guarantee all resources are closed automatically
        try (Connection connection = getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(sql)) {

            // Only set parameters if we are searching
            if (searchTerm != null && !searchTerm.trim().isEmpty()) {
                String searchParameter = "%" + searchTerm + "%";
                preparedStatement.setString(1, searchParameter);
                preparedStatement.setString(2, searchParameter);
            }

            try (ResultSet rs = preparedStatement.executeQuery()) {
                while (rs.next()) {
                    Customer customer = new Customer();
                    customer.setCustNo(rs.getString("custNo"));
                    customer.setCustName(rs.getString("custName"));
                    customer.setCustClub(rs.getString("custClub"));
                    customer.setCustUname(rs.getString("custUname"));
                    customer.setCustPwd(rs.getString("custPwd"));
                    customers.add(customer);
                }
            }
        }
        return customers;
    }
}