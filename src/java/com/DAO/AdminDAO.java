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
import com.Model.Admin;

/**
 *
 * @author user
 */
public class AdminDAO {
    private String jdbcURL = "jdbc:mysql://localhost:3306/brs";
    private String jdbcUsername = "root";
    private String jdbcPassword = "admin";

    private static final String INSERT_ADMIN_SQL = "INSERT INTO admin (adminUname, adminPwd, adminNo) VALUES (?, ?, ?);";
    private static final String SELECT_ADMIN_BY_USERNAME = "SELECT * FROM admin WHERE adminUname = ?";

    protected Connection getConnection() {
        Connection connection = null;
        try {
            Class.forName("com.mysql.jdbc.Driver");
            connection = DriverManager.getConnection(jdbcURL, jdbcUsername, jdbcPassword);
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
        }
        return connection;
    }

    public void registerAdmin(Admin admin) throws SQLException {
        try (Connection connection = getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(INSERT_ADMIN_SQL)) {
            preparedStatement.setString(1, admin.getAdminUname());
            preparedStatement.setString(2, admin.getAdminPwd());
            preparedStatement.setString(3, admin.getAdminNo());
            preparedStatement.executeUpdate();
        }
    }

    public Admin loginAdmin(String adminUname) {
        Admin admin = null;
        try (Connection connection = getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(SELECT_ADMIN_BY_USERNAME)) {
            preparedStatement.setString(1, adminUname);
            ResultSet rs = preparedStatement.executeQuery();
            if (rs.next()) {
                int adminID = rs.getInt("adminID");
                String adminPwd = rs.getString("adminPwd");
                String adminNo = rs.getString("adminNo");
                admin = new Admin(adminID, adminUname, adminPwd, adminNo);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return admin;
    }
}