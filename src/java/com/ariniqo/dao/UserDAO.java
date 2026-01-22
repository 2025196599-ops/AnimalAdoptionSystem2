package com.ariniqo.dao;

import com.ariniqo.model.User;
import com.ariniqo.util.DBConnection;

import java.security.MessageDigest;
import java.sql.*;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class UserDAO {

    // ======================
    // REGISTER USER
    // ======================
    public boolean register(String name, String email, String password, String role) {
        String sql = "INSERT INTO USERS (NAME, EMAIL, PASSWORD_HASH, ROLE) VALUES (?, ?, ?, ?)";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, name);
            ps.setString(2, email);
            ps.setString(3, hash(password));
            ps.setString(4, role == null ? "user" : role.toLowerCase());

            return ps.executeUpdate() == 1;

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    // ======================
    // LOGIN USER
    // ======================
    public User login(String email, String password) {
        String sql = "SELECT * FROM USERS WHERE EMAIL=?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, email);

            try (ResultSet rs = ps.executeQuery()) {
                if (!rs.next()) return null;

                String dbHash = rs.getString("PASSWORD_HASH");
                if (dbHash == null) return null;

                if (!dbHash.equals(hash(password))) return null;

                User u = new User();
                u.setUserId(rs.getInt("USER_ID"));
                u.setName(rs.getString("NAME"));
                u.setEmail(rs.getString("EMAIL"));
                u.setRole(rs.getString("ROLE"));
                return u;
            }

        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    // ======================
    // CHECK EMAIL
    // ======================
    public boolean emailExists(String email) {
        String sql = "SELECT 1 FROM USERS WHERE EMAIL=?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, email);
            return ps.executeQuery().next();

        } catch (Exception e) {
            return false;
        }
    }

    // ======================
    // ADMIN: LIST USERS
    // ======================
    public List<Map<String,Object>> listAllUsersAsMap() throws SQLException {
        List<Map<String,Object>> rows = new ArrayList<Map<String,Object>>();

        String sql = "SELECT USER_ID, NAME, EMAIL, ROLE FROM USERS ORDER BY USER_ID DESC";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Map<String,Object> m = new HashMap<String,Object>();
                m.put("userId", rs.getInt("USER_ID"));
                m.put("name", rs.getString("NAME"));
                m.put("email", rs.getString("EMAIL"));
                m.put("role", rs.getString("ROLE"));
                rows.add(m);
            }
        }
        return rows;
    }

    // ======================
    // ADMIN: GET USER BY ID
    // ======================
    public Map<String,Object> getUserAsMapById(int id) throws SQLException {
        String sql = "SELECT USER_ID, NAME, EMAIL, ROLE FROM USERS WHERE USER_ID = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (!rs.next()) return null;

                Map<String,Object> m = new HashMap<String,Object>();
                m.put("userId", rs.getInt("USER_ID"));
                m.put("name", rs.getString("NAME"));
                m.put("email", rs.getString("EMAIL"));
                m.put("role", rs.getString("ROLE"));
                return m;
            }
        }
    }

    // ======================
    // ADMIN: UPDATE USER (NO PASSWORD)
    // ======================
    public void updateUserNoPassword(int id, String name, String email, String role) throws SQLException {
        String sql = "UPDATE USERS SET NAME=?, EMAIL=?, ROLE=? WHERE USER_ID=?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, name);
            ps.setString(2, email);
            ps.setString(3, (role == null ? "user" : role.toLowerCase()));
            ps.setInt(4, id);
            ps.executeUpdate();
        }
    }

    // ======================
    // ADMIN: UPDATE USER (WITH PASSWORD RESET)
    // ✅ FIXED: uses PASSWORD_HASH and hashes password
    // ======================
    public void updateUserWithPassword(int id, String name, String email, String role, String newPassword) throws Exception {
        String sql = "UPDATE USERS SET NAME=?, EMAIL=?, ROLE=?, PASSWORD_HASH=? WHERE USER_ID=?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, name);
            ps.setString(2, email);
            ps.setString(3, (role == null ? "user" : role.toLowerCase()));
            ps.setString(4, hash(newPassword));   // ✅ hashed
            ps.setInt(5, id);
            ps.executeUpdate();
        }
    }

    // ======================
    // ADMIN: DELETE USER
    // ======================
    public void deleteUser(int id) throws SQLException {
        String sql = "DELETE FROM USERS WHERE USER_ID=?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, id);
            ps.executeUpdate();
        }
    }

    // ======================
    // HASH FUNCTION
    // ======================
    private String hash(String password) throws Exception {
        MessageDigest md = MessageDigest.getInstance("SHA-256");
        byte[] bytes = md.digest(password.getBytes("UTF-8"));
        StringBuilder sb = new StringBuilder();
        for (int i = 0; i < bytes.length; i++) sb.append(String.format("%02x", bytes[i]));
        return sb.toString();
    }
}
