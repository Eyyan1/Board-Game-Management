/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.DAO;

import com.Model.Reservation;
import java.sql.*;

public class ReservationDAO {
    public void addReservation(Reservation reservation) throws SQLException, ClassNotFoundException {
        Class.forName("com.mysql.jdbc.Driver");
        String myUrl = "jdbc:mysql://localhost:3306/brs";
        Connection myConnect = DriverManager.getConnection(myUrl, "root", "admin");
        
        String query = "INSERT INTO rentalDetail (custID, boardID, rentDate, returnDate, quantity) VALUES (?, ?, ?, ?, ?)";
        PreparedStatement preparedStatement = myConnect.prepareStatement(query);
        
        preparedStatement.setInt(1, reservation.getCustID());
        preparedStatement.setInt(2, reservation.getBoardID());
        preparedStatement.setDate(3, (Date) reservation.getRentDate());
        preparedStatement.setDate(4, (Date) reservation.getReturnDate());
        preparedStatement.setInt(5, reservation.getQuantity());
        
        preparedStatement.executeUpdate();
        
        preparedStatement.close();
        myConnect.close();
    }
}
