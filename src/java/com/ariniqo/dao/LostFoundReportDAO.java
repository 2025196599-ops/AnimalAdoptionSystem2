/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.ariniqo.dao;

import com.ariniqo.model.LostFoundReport;
import com.ariniqo.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class LostFoundReportDAO {

    public int insert(LostFoundReport r) throws SQLException {
        // Some student projects evolve the DB schema over time (columns added/removed).
        // To avoid crashing the whole UI, we try a "full" insert first, and fall back to
        // smaller inserts if the database reports unknown/invalid columns.
        try {
            return insertFull(r);
        } catch (SQLException ex) {
            String msg = (ex.getMessage() == null) ? "" : ex.getMessage().toLowerCase();
            boolean looksLikeSchemaMismatch =
                    msg.contains("column") || msg.contains("does not exist") || msg.contains("not found") ||
                    msg.contains("invalid") || msg.contains("unknown");

            if (!looksLikeSchemaMismatch) throw ex;

            try {
                return insertNoStatePostcodePhone2(r);
            } catch (SQLException ex2) {
                String msg2 = (ex2.getMessage() == null) ? "" : ex2.getMessage().toLowerCase();
                boolean looksLikeSchemaMismatch2 =
                        msg2.contains("column") || msg2.contains("does not exist") || msg2.contains("not found") ||
                        msg2.contains("invalid") || msg2.contains("unknown");
                if (!looksLikeSchemaMismatch2) throw ex2;
                return insertMinimal(r);
            }
        }
    }

    private int insertFull(LostFoundReport r) throws SQLException {
        String sql = "INSERT INTO LOST_FOUND_REPORTS (" +
                "REPORT_TYPE, STATUS, PET_NAME, PET_TYPE, BREED, AGE_DESC, GENDER, COLOR_MARKINGS, " +
                "DESCRIPTION, DISTINCTIVE_FEATURES, COLLAR_DETAILS, REWARD, EVENT_DATE, EVENT_TIME, " +
                "LOCATION_TEXT, CITY, STATE, POSTCODE, REPORTER_NAME, REPORTER_EMAIL, REPORTER_PHONE, REPORTER_PHONE2, PHOTO_PATH, CREATED_DATE" +
                ") VALUES (?, 'ACTIVE', ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, CURRENT_TIMESTAMP)";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            ps.setString(1, r.getReportType());
            ps.setString(2, r.getPetName());
            ps.setString(3, r.getPetType());
            ps.setString(4, r.getBreed());
            ps.setString(5, r.getAgeDesc());
            ps.setString(6, r.getGender());
            ps.setString(7, r.getColorMarkings());
            ps.setString(8, r.getDescription());
            ps.setString(9, r.getDistinctiveFeatures());
            ps.setString(10, r.getCollarDetails());
            ps.setString(11, r.getReward());

            ps.setDate(12, r.getEventDate());
            ps.setTime(13, r.getEventTime());

            ps.setString(14, r.getLocationText());
            ps.setString(15, r.getCity());
            ps.setString(16, r.getState());
            ps.setString(17, r.getPostcode());

            ps.setString(18, r.getReporterName());
            ps.setString(19, r.getReporterEmail());
            ps.setString(20, r.getReporterPhone());
            ps.setString(21, r.getReporterPhone2());
            ps.setString(22, r.getPhotoPath());

            ps.executeUpdate();
            try (ResultSet rs = ps.getGeneratedKeys()) {
                if (rs.next()) return rs.getInt(1);
            }
        }
        return -1;
    }

    private int insertNoStatePostcodePhone2(LostFoundReport r) throws SQLException {
        String sql = "INSERT INTO LOST_FOUND_REPORTS (" +
                "REPORT_TYPE, STATUS, PET_NAME, PET_TYPE, BREED, AGE_DESC, GENDER, COLOR_MARKINGS, " +
                "DESCRIPTION, DISTINCTIVE_FEATURES, COLLAR_DETAILS, REWARD, EVENT_DATE, EVENT_TIME, " +
                "LOCATION_TEXT, CITY, REPORTER_NAME, REPORTER_EMAIL, REPORTER_PHONE, PHOTO_PATH, CREATED_DATE" +
                ") VALUES (?, 'ACTIVE', ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, CURRENT_TIMESTAMP)";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            ps.setString(1, r.getReportType());
            ps.setString(2, r.getPetName());
            ps.setString(3, r.getPetType());
            ps.setString(4, r.getBreed());
            ps.setString(5, r.getAgeDesc());
            ps.setString(6, r.getGender());
            ps.setString(7, r.getColorMarkings());
            ps.setString(8, r.getDescription());
            ps.setString(9, r.getDistinctiveFeatures());
            ps.setString(10, r.getCollarDetails());
            ps.setString(11, r.getReward());

            ps.setDate(12, r.getEventDate());
            ps.setTime(13, r.getEventTime());

            ps.setString(14, r.getLocationText());
            ps.setString(15, r.getCity());

            ps.setString(16, r.getReporterName());
            ps.setString(17, r.getReporterEmail());
            ps.setString(18, r.getReporterPhone());
            ps.setString(19, r.getPhotoPath());

            ps.executeUpdate();
            try (ResultSet rs = ps.getGeneratedKeys()) {
                if (rs.next()) return rs.getInt(1);
            }
        }
        return -1;
    }

    private int insertMinimal(LostFoundReport r) throws SQLException {
        String sql = "INSERT INTO LOST_FOUND_REPORTS (" +
                "REPORT_TYPE, STATUS, PET_NAME, PET_TYPE, DESCRIPTION, EVENT_DATE, LOCATION_TEXT, CITY, " +
                "REPORTER_NAME, REPORTER_PHONE, PHOTO_PATH, CREATED_DATE" +
                ") VALUES (?, 'ACTIVE', ?, ?, ?, ?, ?, ?, ?, ?, ?, CURRENT_TIMESTAMP)";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            ps.setString(1, r.getReportType());
            ps.setString(2, r.getPetName());
            ps.setString(3, r.getPetType());
            ps.setString(4, r.getDescription());
            ps.setDate(5, r.getEventDate());
            ps.setString(6, r.getLocationText());
            ps.setString(7, r.getCity());
            ps.setString(8, r.getReporterName());
            ps.setString(9, r.getReporterPhone());
            ps.setString(10, r.getPhotoPath());

            ps.executeUpdate();
            try (ResultSet rs = ps.getGeneratedKeys()) {
                if (rs.next()) return rs.getInt(1);
            }
        }
        return -1;
    }

    public List<LostFoundReport> listAllActiveFirst() throws SQLException {
        String sql = "SELECT * FROM LOST_FOUND_REPORTS ORDER BY " +
                     "CASE WHEN UPPER(STATUS)='ACTIVE' THEN 0 ELSE 1 END, CREATED_DATE DESC";
        List<LostFoundReport> out = new ArrayList<>();
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) out.add(map(rs));
        }
        return out;
    }

    public LostFoundReport getById(int id) throws SQLException {
        String sql = "SELECT * FROM LOST_FOUND_REPORTS WHERE REPORT_ID=?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return map(rs);
            }
        }
        return null;
    }

    public void markResolved(int id) throws SQLException {
        String sql = "UPDATE LOST_FOUND_REPORTS SET STATUS='RESOLVED', RESOLVED_DATE=CURRENT_TIMESTAMP WHERE REPORT_ID=?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            ps.executeUpdate();
        }
    }

    private LostFoundReport map(ResultSet rs) throws SQLException {
        LostFoundReport r = new LostFoundReport();
        r.setReportId(rs.getInt("REPORT_ID"));
        r.setReportType(rs.getString("REPORT_TYPE"));
        r.setStatus(rs.getString("STATUS"));
        r.setPetName(rs.getString("PET_NAME"));
        r.setPetType(rs.getString("PET_TYPE"));
        r.setBreed(rs.getString("BREED"));
        r.setAgeDesc(rs.getString("AGE_DESC"));
        r.setGender(rs.getString("GENDER"));
        r.setColorMarkings(rs.getString("COLOR_MARKINGS"));
        r.setDescription(rs.getString("DESCRIPTION"));
        r.setDistinctiveFeatures(rs.getString("DISTINCTIVE_FEATURES"));
        r.setCollarDetails(rs.getString("COLLAR_DETAILS"));
        r.setReward(rs.getString("REWARD"));
        r.setEventDate(rs.getDate("EVENT_DATE"));
        r.setEventTime(rs.getTime("EVENT_TIME"));
        r.setLocationText(rs.getString("LOCATION_TEXT"));
        r.setCity(rs.getString("CITY"));
        r.setState(rs.getString("STATE"));
        r.setPostcode(rs.getString("POSTCODE"));
        r.setReporterName(rs.getString("REPORTER_NAME"));
        r.setReporterEmail(rs.getString("REPORTER_EMAIL"));
        r.setReporterPhone(rs.getString("REPORTER_PHONE"));
        r.setReporterPhone2(rs.getString("REPORTER_PHONE2"));
        r.setPhotoPath(rs.getString("PHOTO_PATH"));
        r.setCreatedDate(rs.getTimestamp("CREATED_DATE"));
        r.setResolvedDate(rs.getTimestamp("RESOLVED_DATE"));
        return r;
    }
}

