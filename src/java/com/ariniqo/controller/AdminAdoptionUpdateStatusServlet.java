package com.ariniqo.controller;

import com.ariniqo.dao.AdoptionDAO;
import com.ariniqo.model.User;
import com.ariniqo.util.DBConnection;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

@WebServlet("/admin/adoption/update-status")
public class AdminAdoptionUpdateStatusServlet extends HttpServlet {

    private String safe(String s) { return (s == null) ? "" : s.trim(); }

    private boolean isPetAlreadyAdopted(int petId) {
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            con = DBConnection.getConnection();
            ps = con.prepareStatement("SELECT STATUS FROM PETS WHERE PET_ID = ?");
            ps.setInt(1, petId);
            rs = ps.executeQuery();

            if (rs.next()) {
                String st = rs.getString("STATUS");
                if (st == null) return false;
                return "ADOPTED".equalsIgnoreCase(st.trim());
            }
        } catch (Exception ignore) {
        } finally {
            try { if (rs != null) rs.close(); } catch (Exception e) {}
            try { if (ps != null) ps.close(); } catch (Exception e) {}
            try { if (con != null) con.close(); } catch (Exception e) {}
        }
        return false;
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String ctx = req.getContextPath();

        // ✅ admin guard
        User admin = (User) req.getSession().getAttribute("user");
        if (admin == null) {
            resp.sendRedirect(ctx + "/login.jsp");
            return;
        }

        int adoptionId = 0;
        try { adoptionId = Integer.parseInt(req.getParameter("id")); } catch (Exception ignore) {}

        String status = safe(req.getParameter("status")).toUpperCase();

        if (adoptionId <= 0) {
            resp.sendRedirect(ctx + "/admin/adoptions?error=1");
            return;
        }

        if (!"APPROVED".equals(status) && !"REJECTED".equals(status) && !"PENDING".equals(status)) {
            resp.sendRedirect(ctx + "/admin/adoptions?error=1");
            return;
        }

        try {
            AdoptionDAO dao = new AdoptionDAO();

            // petId for this request
            int petId = dao.getPetIdForAdoption(adoptionId);

            // ✅ If admin tries to approve but pet already adopted
            if ("APPROVED".equals(status) && petId > 0 && isPetAlreadyAdopted(petId)) {
                resp.sendRedirect(ctx + "/admin/adoptions?error=pet_adopted");
                return;
            }

            // ✅ update adoption status
            dao.updateStatus(adoptionId, status);

            // ✅ if approved: mark pet adopted + reject others
            if ("APPROVED".equals(status) && petId > 0) {
                dao.markPetAdopted(petId);
                dao.rejectOtherPendingForPet(petId, adoptionId);
            }

            resp.sendRedirect(ctx + "/admin/adoptions?updated=1");

        } catch (Exception e) {
            throw new ServletException(e);
        }
    }
}
