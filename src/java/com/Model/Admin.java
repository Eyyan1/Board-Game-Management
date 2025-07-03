/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.Model;

/**
 *
 * @author user
 */
public class Admin {
    protected int adminID;
    protected String adminUname;
    protected String adminPwd;
    protected String adminNo;

    public Admin() {}

    public Admin(String adminUname, String adminPwd, String adminNo) {
        this.adminUname = adminUname;
        this.adminPwd = adminPwd;
        this.adminNo = adminNo;
    }

    public Admin(int adminID, String adminUname, String adminPwd, String adminNo) {
        this.adminID = adminID;
        this.adminUname = adminUname;
        this.adminPwd = adminPwd;
        this.adminNo = adminNo;
    }

    public int getAdminID() {
        return adminID;
    }

    public void setAdminID(int adminID) {
        this.adminID = adminID;
    }

    public String getAdminUname() {
        return adminUname;
    }

    public void setAdminUname(String adminUname) {
        this.adminUname = adminUname;
    }

    public String getAdminPwd() {
        return adminPwd;
    }

    public void setAdminPwd(String adminPwd) {
        this.adminPwd = adminPwd;
    }

    public String getAdminNo() {
        return adminNo;
    }

    public void setAdminNo(String adminNo) {
        this.adminNo = adminNo;
    }

   
}
