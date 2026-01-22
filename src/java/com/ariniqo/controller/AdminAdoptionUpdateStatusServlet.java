package com.ariniqo.controller;

import com.ariniqo.util.DBConnection;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

@WebServlet("/admin/adoption/update-status")
public class AdminAdoptionUpdateStatusServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        int id;
        try {
            id = Integer.parseInt(req.getParameter("id"));
        } catch (Exception e) {
            resp.sendRedirect(req.getContextPath() + "/admin/adoptions");
            return;
        }

        String status = req.getParameter("status");
        status = (status == null) ? "" : status.trim().toUpperCase();

        if (!"APPROVED".equals(status) && !"REJECTED".equals(status) && !"PENDING".equals(status)) {
            resp.sendRedirect(req.getContextPath() + "/admin/adoptions");
            return;
        }

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(
                     "UPDATE ADOPTIONS SET STATUS=? WHERE ADOPTION_ID=?")) {

            ps.setString(1, status);
            ps.setInt(2, id);
            ps.executeUpdate();

        } catch (Exception e) {
            throw new ServletException(e);
        }

        // ✅ redirect back to adoption request list + show banner
        resp.sendRedirect(req.getContextPath() + "/admin/adoptions?updated=1");
    }
}
