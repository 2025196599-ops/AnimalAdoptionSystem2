/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.ariniqo.dao;

import com.ariniqo.util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

public class ReportFoundItDAO {

    public void insert(int reportId, int userId, String message) throws SQLException {
        String sql = "INSERT INTO REPORT_FOUND_IT (REPORT_ID, USER_ID, MESSAGE, CREATED_DATE) VALUES (?, ?, ?, CURRENT_TIMESTAMP)";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, reportId);
            ps.setInt(2, userId);
            ps.setString(3, message);
            ps.executeUpdate();
        }
    }
}

