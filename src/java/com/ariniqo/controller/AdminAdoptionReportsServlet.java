package com.ariniqo.controller;

import com.ariniqo.util.DBConnection;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.*;
import java.util.*;

@WebServlet("/admin/adoption-reports")
public class AdminAdoptionReportsServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        int total = 0, approved = 0, rejected = 0, pending = 0;
        List<Map<String, Object>> rows = new ArrayList<Map<String, Object>>();

        // Stats
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(
                     "SELECT UPPER(STATUS) AS S, COUNT(*) AS C FROM ADOPTIONS GROUP BY UPPER(STATUS)");
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                String s = rs.getString("S");
                int c = rs.getInt("C");
                total += c;

                if ("APPROVED".equals(s)) approved += c;
                else if ("REJECTED".equals(s)) rejected += c;
                else if ("PENDING".equals(s)) pending += c;
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        // Table rows
        String sql =
            "SELECT a.ADOPTION_ID, a.STATUS, a.APPLIED_DATE, " +
            "u.NAME AS USER_NAME, u.EMAIL AS USER_EMAIL, " +
            "p.NAME AS PET_NAME, p.BREED AS PET_BREED " +
            "FROM ADOPTIONS a " +
            "JOIN USERS u ON a.USER_ID = u.USER_ID " +
            "JOIN PETS p ON a.PET_ID = p.PET_ID " +
            "ORDER BY a.APPLIED_DATE DESC";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Map<String, Object> row = new HashMap<String, Object>();
                row.put("adoptionId", rs.getInt("ADOPTION_ID"));
                row.put("status", rs.getString("STATUS"));
                row.put("appliedDate", rs.getTimestamp("APPLIED_DATE"));
                row.put("userName", rs.getString("USER_NAME"));
                row.put("userEmail", rs.getString("USER_EMAIL"));
                row.put("petName", rs.getString("PET_NAME"));
                row.put("petBreed", rs.getString("PET_BREED"));
                rows.add(row);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        req.setAttribute("total", total);
        req.setAttribute("approved", approved);
        req.setAttribute("rejected", rejected);
        req.setAttribute("pending", pending);
        req.setAttribute("rows", rows);

        req.getRequestDispatcher("/admin/adoption-reports.jsp").forward(req, resp);
    }
}
