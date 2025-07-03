/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.DAO;

import com.Model.Board;
import java.sql.*;

public class BoardDAO {

    public Board getBoardById(int boardID) throws SQLException, ClassNotFoundException {
        Class.forName("com.mysql.jdbc.Driver");
        String myUrl = "jdbc:mysql://localhost:3306/brs";
        Connection myConnect = DriverManager.getConnection(myUrl, "root", "admin");
        
        String query = "SELECT boardID, boardName, avbleQuant FROM board WHERE boardID = ?";
        PreparedStatement preparedStatement = myConnect.prepareStatement(query);
        preparedStatement.setInt(1, boardID);
        
        ResultSet resultSet = preparedStatement.executeQuery();
        Board board = null;
        if (resultSet.next()) {
            board = new Board();
            board.setBoardID(resultSet.getInt("boardID"));
            board.setBoardName(resultSet.getString("boardName"));
            board.setAvailableQuantity(resultSet.getInt("avbleQuant"));
        }
        
        resultSet.close();
        preparedStatement.close();
        myConnect.close();
        
        return board;
    }

    public void updateBoardQuantity(int boardID, int quantity) throws SQLException, ClassNotFoundException {
        Class.forName("com.mysql.jdbc.Driver");
        String myUrl = "jdbc:mysql://localhost:3306/brs";
        Connection myConnect = DriverManager.getConnection(myUrl, "root", "admin");
        
        String query = "UPDATE board SET avbleQuant = avbleQuant - ? WHERE boardID = ?";
        PreparedStatement preparedStatement = myConnect.prepareStatement(query);
        preparedStatement.setInt(1, quantity);
        preparedStatement.setInt(2, boardID);
        
        preparedStatement.executeUpdate();
        
        preparedStatement.close();
        myConnect.close();
    }
}

