package com.ariniqo.controller;

import com.ariniqo.util.DBConnection;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.*;
import java.util.*;

@WebServlet("/admin/users")
public class AdminUserManagementServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        List<Map<String, Object>> users = new ArrayList<Map<String, Object>>();

        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            con = DBConnection.getConnection();
            ps = con.prepareStatement("SELECT USER_ID, NAME, EMAIL, ROLE FROM USERS ORDER BY USER_ID DESC");
            rs = ps.executeQuery();

            while (rs.next()) {
                Map<String, Object> row = new HashMap<String, Object>();
                row.put("userId", rs.getInt("USER_ID"));
                row.put("name", rs.getString("NAME"));
                row.put("email", rs.getString("EMAIL"));
                row.put("role", rs.getString("ROLE"));
                users.add(row);
            }

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try { if (rs != null) rs.close(); } catch (Exception e) {}
            try { if (ps != null) ps.close(); } catch (Exception e) {}
            try { if (con != null) con.close(); } catch (Exception e) {}
        }

        req.setAttribute("users", users);
        req.getRequestDispatcher("/admin/user-management.jsp").forward(req, resp);
    }
}
