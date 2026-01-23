package com.ariniqo.dao;

import com.ariniqo.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class AdoptionDAO {

    // ============================
    // USER submits application
    // ============================

    public void create(int userId, int petId) throws SQLException {
        Connection con = null;
        PreparedStatement ps = null;
        try {
            con = DBConnection.getConnection();
            ps = con.prepareStatement(
                "INSERT INTO ADOPTIONS (USER_ID, PET_ID, STATUS, APPLIED_DATE) " +
                "VALUES (?, ?, 'PENDING', CURRENT_TIMESTAMP)"
            );
            ps.setInt(1, userId);
            ps.setInt(2, petId);
            ps.executeUpdate();
        } finally {
            close(ps);
            close(con);
        }
    }

    public int createReturnId(int userId, int petId) throws SQLException {
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            con = DBConnection.getConnection();
            ps = con.prepareStatement(
                "INSERT INTO ADOPTIONS (USER_ID, PET_ID, STATUS, APPLIED_DATE) " +
                "VALUES (?, ?, 'PENDING', CURRENT_TIMESTAMP)",
                Statement.RETURN_GENERATED_KEYS
            );
            ps.setInt(1, userId);
            ps.setInt(2, petId);
            ps.executeUpdate();

            rs = ps.getGeneratedKeys();
            if (rs != null && rs.next()) return rs.getInt(1);
            return -1;

        } finally {
            close(rs);
            close(ps);
            close(con);
        }
    }

    // IMPORTANT: include CREATED_DATE so it won't be NULL
    public void insertDetails(int adoptionId, String phone, String address, String formJson) throws SQLException {
        Connection con = null;
        PreparedStatement ps = null;
        try {
            con = DBConnection.getConnection();
            ps = con.prepareStatement(
                "INSERT INTO ADOPTION_APPLICATION_DETAILS (ADOPTION_ID, PHONE, ADDRESS, FORM_JSON, CREATED_DATE) " +
                "VALUES (?, ?, ?, ?, CURRENT_TIMESTAMP)"
            );
            ps.setInt(1, adoptionId);
            ps.setString(2, phone);
            ps.setString(3, address);
            ps.setString(4, formJson);
            ps.executeUpdate();
        } finally {
            close(ps);
            close(con);
        }
    }

    // ============================
    // ADMIN list all requests
    // ============================
    public List<Map<String, Object>> listAll() throws SQLException {
        List<Map<String, Object>> out = new ArrayList<Map<String, Object>>();

        String sql =
            "SELECT a.ADOPTION_ID, a.STATUS, a.APPLIED_DATE, " +
            "       u.NAME AS USER_NAME, u.EMAIL AS USER_EMAIL, " +
            "       p.PET_ID, p.NAME AS PET_NAME " +
            "FROM ADOPTIONS a " +
            "JOIN USERS u ON a.USER_ID = u.USER_ID " +
            "JOIN PETS p  ON a.PET_ID  = p.PET_ID " +
            "ORDER BY a.APPLIED_DATE DESC";

        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            con = DBConnection.getConnection();
            ps = con.prepareStatement(sql);
            rs = ps.executeQuery();

            while (rs.next()) {
                Map<String, Object> m = new HashMap<String, Object>();
                m.put("adoptionId", rs.getInt("ADOPTION_ID"));
                m.put("status", rs.getString("STATUS"));
                m.put("appliedDate", rs.getTimestamp("APPLIED_DATE"));

                m.put("userName", rs.getString("USER_NAME"));
                m.put("email", rs.getString("USER_EMAIL"));

                m.put("petId", rs.getInt("PET_ID"));
                m.put("petName", rs.getString("PET_NAME"));

                out.add(m);
            }

        } finally {
            close(rs);
            close(ps);
            close(con);
        }

        return out;
    }

    // ============================
    // ADMIN view ONE request detail
    // ============================
    public Map<String, Object> getById(int adoptionId) throws SQLException {
        String sql =
            "SELECT a.ADOPTION_ID, a.STATUS, a.APPLIED_DATE, a.USER_ID, a.PET_ID, " +
            "       u.NAME AS USER_NAME, u.EMAIL AS USER_EMAIL, " +
            "       p.NAME AS PET_NAME, p.TYPE AS PET_TYPE, p.BREED AS PET_BREED, p.AGE AS PET_AGE, " +
            "       p.STATUS AS PET_STATUS, p.IMAGE_PATH AS PET_IMAGE, " +
            "       d.PHONE, d.ADDRESS, d.FORM_JSON " +
            "FROM ADOPTIONS a " +
            "JOIN USERS u ON a.USER_ID = u.USER_ID " +
            "JOIN PETS  p ON a.PET_ID  = p.PET_ID " +
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

            Map<String, Object> m = new HashMap<String, Object>();
            m.put("adoptionId", rs.getInt("ADOPTION_ID"));
            m.put("status", rs.getString("STATUS"));
            m.put("appliedDate", rs.getTimestamp("APPLIED_DATE"));

            m.put("userId", rs.getInt("USER_ID"));
            m.put("petId", rs.getInt("PET_ID"));

            m.put("userName", rs.getString("USER_NAME"));
            m.put("email", rs.getString("USER_EMAIL"));

            m.put("petName", rs.getString("PET_NAME"));
            m.put("petType", rs.getString("PET_TYPE"));
            m.put("petBreed", rs.getString("PET_BREED"));
            m.put("petAge", rs.getInt("PET_AGE"));
            m.put("petStatus", rs.getString("PET_STATUS"));
            m.put("petImage", rs.getString("PET_IMAGE"));

            m.put("phone", rs.getString("PHONE"));
            m.put("address", rs.getString("ADDRESS"));
            m.put("formJson", rs.getString("FORM_JSON"));

            return m;

        } finally {
            close(rs);
            close(ps);
            close(con);
        }
    }

    public int getPetIdForAdoption(int adoptionId) throws SQLException {
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            con = DBConnection.getConnection();
            ps = con.prepareStatement("SELECT PET_ID FROM ADOPTIONS WHERE ADOPTION_ID=?");
            ps.setInt(1, adoptionId);
            rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1);
            return -1;
        } finally {
            close(rs);
            close(ps);
            close(con);
        }
    }

    // ============================
    // USER adoption status page
    // ============================
    public List<Map<String, Object>> listByUser(int userId) throws SQLException {
        List<Map<String, Object>> out = new ArrayList<Map<String, Object>>();

        String sql =
            "SELECT a.ADOPTION_ID, a.STATUS, a.APPLIED_DATE, a.PET_ID, " +
            "       p.NAME AS PET_NAME, p.TYPE AS PET_TYPE, p.BREED AS PET_BREED, p.AGE AS PET_AGE, " +
            "       p.STATUS AS PET_STATUS, p.IMAGE_PATH AS PET_IMAGE " +
            "FROM ADOPTIONS a " +
            "JOIN PETS p ON a.PET_ID = p.PET_ID " +
            "WHERE a.USER_ID = ? " +
            "ORDER BY a.APPLIED_DATE DESC";

        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            con = DBConnection.getConnection();
            ps = con.prepareStatement(sql);
            ps.setInt(1, userId);
            rs = ps.executeQuery();

            while (rs.next()) {
                Map<String, Object> m = new HashMap<String, Object>();
                m.put("adoptionId", rs.getInt("ADOPTION_ID"));
                m.put("status", rs.getString("STATUS"));
                m.put("appliedDate", rs.getTimestamp("APPLIED_DATE"));

                m.put("petId", rs.getInt("PET_ID"));
                m.put("petName", rs.getString("PET_NAME"));
                m.put("petType", rs.getString("PET_TYPE"));
                m.put("petBreed", rs.getString("PET_BREED"));
                m.put("petAge", rs.getInt("PET_AGE"));
                m.put("petStatus", rs.getString("PET_STATUS"));
                m.put("petImage", rs.getString("PET_IMAGE"));

                out.add(m);
            }

        } finally {
            close(rs);
            close(ps);
            close(con);
        }

        return out;
    }

    // ============================
    // ADMIN approve flow helpers
    // ============================

    public void updateStatus(int adoptionId, String status) throws SQLException {
        Connection con = null;
        PreparedStatement ps = null;
        try {
            con = DBConnection.getConnection();
            ps = con.prepareStatement("UPDATE ADOPTIONS SET STATUS=? WHERE ADOPTION_ID=?");
            ps.setString(1, status);
            ps.setInt(2, adoptionId);
            ps.executeUpdate();
        } finally {
            close(ps);
            close(con);
        }
    }

    public void markPetAdopted(int petId) throws SQLException {
        Connection con = null;
        PreparedStatement ps = null;
        try {
            con = DBConnection.getConnection();
            ps = con.prepareStatement("UPDATE PETS SET STATUS='ADOPTED' WHERE PET_ID=?");
            ps.setInt(1, petId);
            ps.executeUpdate();
        } finally {
            close(ps);
            close(con);
        }
    }

    public void rejectOtherPendingForPet(int petId, int keepAdoptionId) throws SQLException {
        Connection con = null;
        PreparedStatement ps = null;
        try {
            con = DBConnection.getConnection();
            ps = con.prepareStatement(
                "UPDATE ADOPTIONS SET STATUS='REJECTED' " +
                "WHERE PET_ID=? AND UPPER(STATUS)='PENDING' AND ADOPTION_ID<>?"
            );
            ps.setInt(1, petId);
            ps.setInt(2, keepAdoptionId);
            ps.executeUpdate();
        } finally {
            close(ps);
            close(con);
        }
    }

    // ============================
    // small close helpers
    // ============================
    private void close(ResultSet rs) { try { if (rs != null) rs.close(); } catch (Exception e) {} }
    private void close(PreparedStatement ps) { try { if (ps != null) ps.close(); } catch (Exception e) {} }
    private void close(Connection con) { try { if (con != null) con.close(); } catch (Exception e) {} }
}
