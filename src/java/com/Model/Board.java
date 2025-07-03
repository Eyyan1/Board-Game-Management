/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.Model;

public class Board {
    private int boardID;
    private String boardName;
    private int availableQuantity;
     private int boardQuantity; 


    // Getters and Setters
    public int getBoardID() {
        return boardID;
    }

    public void setBoardID(int boardID) {
        this.boardID = boardID;
    }

    public String getBoardName() {
        return boardName;
    }

    public void setBoardName(String boardName) {
        this.boardName = boardName;
    }

    public int getAvailableQuantity() {
        return availableQuantity;
    }

    public void setAvailableQuantity(int availableQuantity) {
        this.availableQuantity = availableQuantity;
    }
    
    public int getBoardQuantity() {
        return boardQuantity;
    }

    /**
     * Sets the total quantity of this board game.
     * @param boardQuantity The total quantity.
     */
    public void setBoardQuantity(int boardQuantity) {
        this.boardQuantity = boardQuantity;
    }
}

