/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.Model;

/**
 *
 * @author user
 */
public class Customer {
    protected int custID;
    protected String custNo;
    protected String custName;
    protected String custClub;
    protected String custUname;
    protected String custPwd;

    public Customer() {}

    public Customer(String custNo, String custName, String custClub, String custUname, String custPwd) {
        this.custNo = custNo;
        this.custName = custName;
        this.custClub = custClub;
        this.custUname = custUname;
        this.custPwd = custPwd;
    }

    public Customer(int custID, String custNo, String custName, String custClub, String custUname, String custPwd) {
        this.custID = custID;
        this.custNo = custNo;
        this.custName = custName;
        this.custClub = custClub;
        this.custUname = custUname;
        this.custPwd = custPwd;
    }
    
    public Customer( String custUname, String custName, String custClub,  String custPwd) {
        
        this.custName = custName;
        this.custClub = custClub;
        this.custUname = custUname;
        this.custPwd = custPwd;
    }

    public int getCustID() {
        return custID;
    }

    public void setCustID(int custID) {
        this.custID = custID;
    }

    public String getCustNo() {
        return custNo;
    }

    public void setCustNo(String custNo) {
        this.custNo = custNo;
    }

    public String getCustName() {
        return custName;
    }

    public void setCustName(String custName) {
        this.custName = custName;
    }

    public String getCustClub() {
        return custClub;
    }

    public void setCustClub(String custClub) {
        this.custClub = custClub;
    }

    public String getCustUname() {
        return custUname;
    }

    public void setCustUname(String custUname) {
        this.custUname = custUname;
    }

    public String getCustPwd() {
        return custPwd;
    }

    public void setCustPwd(String custPwd) {
        this.custPwd = custPwd;
    }

    
}
