package com.ariniqo.dao;

import com.ariniqo.util.DBConnection;

import java.sql.*;
import java.util.*;

public class AdoptionDAO {

    // =========================
    // Create adoption (no details)
    // =========================
    public int create(int userId, int petId) throws SQLException {
        String sql = "INSERT INTO ADOPTIONS (USER_ID, PET_ID, STATUS, APPLIED_DATE) " +
                     "VALUES (?, ?, 'PENDING', CURRENT_TIMESTAMP)";

        Connection con = null;
        PreparedStatement ps = null;

        try {
            con = DBConnection.getConnection();
            ps = con.prepareStatement(sql);
            ps.setInt(1, userId);
            ps.setInt(2, petId);
            return ps.executeUpdate();

        } finally {
            try { if (ps != null) ps.close(); } catch (Exception e) {}
            try { if (con != null) con.close(); } catch (Exception e) {}
        }
    }

    // =========================
    // Create adoption and return generated ID
    // =========================
    public int createReturnId(int userId, int petId) throws SQLException {
        String sql = "INSERT INTO ADOPTIONS (USER_ID, PET_ID, STATUS, APPLIED_DATE) " +
                     "VALUES (?, ?, 'PENDING', CURRENT_TIMESTAMP)";

        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            con = DBConnection.getConnection();
            ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            ps.setInt(1, userId);
            ps.setInt(2, petId);
            ps.executeUpdate();

            rs = ps.getGeneratedKeys();
            if (rs != null && rs.next()) {
                return rs.getInt(1);
            }
            return -1;

        } finally {
            try { if (rs != null) rs.close(); } catch (Exception e) {}
            try { if (ps != null) ps.close(); } catch (Exception e) {}
            try { if (con != null) con.close(); } catch (Exception e) {}
        }
    }

    // =========================
    // Insert adoption form details
    // =========================
    public int insertDetails(int adoptionId, String phone, String address, String formJson) throws SQLException {

        // If your table has unique ADOPTION_ID, we can safely insert.
        // If you want update instead, tell me and I'll change to MERGE.
        String sql = "INSERT INTO ADOPTION_APPLICATION_DETAILS (ADOPTION_ID, PHONE, ADDRESS, FORM_JSON) " +
                     "VALUES (?, ?, ?, ?)";

        Connection con = null;
        PreparedStatement ps = null;

        try {
            con = DBConnection.getConnection();
            ps = con.prepareStatement(sql);
            ps.setInt(1, adoptionId);
            ps.setString(2, phone);
            ps.setString(3, address);
            ps.setString(4, formJson);
            return ps.executeUpdate();

        } finally {
            try { if (ps != null) ps.close(); } catch (Exception e) {}
            try { if (con != null) con.close(); } catch (Exception e) {}
        }
    }

    // =========================
    // Admin: list all adoption requests
    // Used by /admin/adoptions
    // =========================
    public List<Map<String,Object>> listAll() throws SQLException {

        String sql =
            "SELECT a.ADOPTION_ID, a.STATUS, a.APPLIED_DATE, " +
            "u.NAME AS USER_NAME, u.EMAIL AS USER_EMAIL, " +
            "p.NAME AS PET_NAME " +
            "FROM ADOPTIONS a " +
            "JOIN USERS u ON a.USER_ID = u.USER_ID " +
            "JOIN PETS p ON a.PET_ID = p.PET_ID " +
            "ORDER BY a.APPLIED_DATE DESC";

        List<Map<String,Object>> out = new ArrayList<Map<String,Object>>();

        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            con = DBConnection.getConnection();
            ps = con.prepareStatement(sql);
            rs = ps.executeQuery();

            while (rs.next()) {
                Map<String,Object> row = new HashMap<String,Object>();
                row.put("adoptionId", rs.getInt("ADOPTION_ID"));
                row.put("status", rs.getString("STATUS"));
                row.put("appliedDate", rs.getTimestamp("APPLIED_DATE"));
                row.put("userName", rs.getString("USER_NAME"));
                row.put("email", rs.getString("USER_EMAIL"));
                row.put("petName", rs.getString("PET_NAME"));
                out.add(row);
            }

        } finally {
            try { if (rs != null) rs.close(); } catch (Exception e) {}
            try { if (ps != null) ps.close(); } catch (Exception e) {}
            try { if (con != null) con.close(); } catch (Exception e) {}
        }

        return out;
    }

    // =========================
    // Admin: get one adoption by id (detail page)
    // Includes phone/address/formJson
    // =========================
    public Map<String,Object> getById(int adoptionId) throws SQLException {

        String sql =
            "SELECT a.ADOPTION_ID, a.STATUS, a.APPLIED_DATE, " +
            "u.NAME AS USER_NAME, u.EMAIL AS USER_EMAIL, " +
            "p.NAME AS PET_NAME, p.BREED AS PET_BREED, p.TYPE AS PET_TYPE, " +
            "d.PHONE, d.ADDRESS, d.FORM_JSON " +
            "FROM ADOPTIONS a " +
            "JOIN USERS u ON a.USER_ID = u.USER_ID " +
            "JOIN PETS p ON a.PET_ID = p.PET_ID " +
            "LEFT JOIN ADOPTION_APPLICATION_DETAILS d ON d.ADOPTION_ID = a.ADOPTION_ID " +
            "WHERE a.ADOPTION_ID = ?";

        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            con = DBConnection.getConnection();
            ps = con.prepareStatement(sql);
            ps.setInt(1, adoptionId);
            rs = ps.executeQuery();

            if (!rs.next()) return null;

            Map<String,Object> m = new HashMap<String,Object>();
            m.put("adoptionId", rs.getInt("ADOPTION_ID"));
            m.put("status", rs.getString("STATUS"));
            m.put("appliedDate", rs.getTimestamp("APPLIED_DATE"));

            m.put("userName", rs.getString("USER_NAME"));
            m.put("email", rs.getString("USER_EMAIL"));

            m.put("petName", rs.getString("PET_NAME"));
            m.put("petBreed", rs.getString("PET_BREED"));
            m.put("petType", rs.getString("PET_TYPE"));

            m.put("phone", rs.getString("PHONE"));
            m.put("address", rs.getString("ADDRESS"));
            m.put("formJson", rs.getString("FORM_JSON"));

            return m;

        } finally {
            try { if (rs != null) rs.close(); } catch (Exception e) {}
            try { if (ps != null) ps.close(); } catch (Exception e) {}
            try { if (con != null) con.close(); } catch (Exception e) {}
        }
    }
}
