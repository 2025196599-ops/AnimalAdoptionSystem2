package com.ariniqo.controller;

import com.ariniqo.dao.UserDAO;
import com.ariniqo.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/admin/users/update")
public class AdminUpdateUserServlet extends HttpServlet {

    private String safe(String s) {
        return (s == null) ? "" : s.trim();
    }

    private String normalizeRole(String role) {
        role = safe(role).toLowerCase();
        if (role.length() == 0) return "user";
        if (!"user".equals(role) && !"admin".equals(role)) return "user";
        return role;
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String ctx = req.getContextPath();

        // ✅ basic admin guard
        User admin = (User) req.getSession().getAttribute("user");
        if (admin == null) {
            resp.sendRedirect(ctx + "/login.jsp");
            return;
        }

        int id = 0;
        try { id = Integer.parseInt(req.getParameter("id")); } catch (Exception ignore) {}

        String name = safe(req.getParameter("name"));
        String email = safe(req.getParameter("email")).toLowerCase();
        String role = normalizeRole(req.getParameter("role"));
        String newPassword = safe(req.getParameter("newPassword"));

        if (id <= 0 || name.length() == 0 || email.length() == 0) {
            resp.sendRedirect(ctx + "/admin/users/edit?id=" + id + "&error=1");
            return;
        }

        try {
            UserDAO dao = new UserDAO();

            // ✅ Optional: prevent duplicate email
            // Only block if changing to an email used by another user
            java.util.Map<String,Object> existing = dao.getUserAsMapById(id);
            if (existing == null) {
                resp.sendRedirect(ctx + "/admin/users?error=1");
                return;
            }
            String oldEmail = (existing.get("email") == null) ? "" : existing.get("email").toString().toLowerCase();

            if (!email.equals(oldEmail) && dao.emailExists(email)) {
                // email already used by someone else
                resp.sendRedirect(ctx + "/admin/users/edit?id=" + id + "&error=1");
                return;
            }

            // ✅ update
            if (newPassword.length() > 0) {
                // hashes inside DAO method (PASSWORD_HASH)
                dao.updateUserWithPassword(id, name, email, role, newPassword);
            } else {
                dao.updateUserNoPassword(id, name, email, role);
            }

            resp.sendRedirect(ctx + "/admin/users?updated=1");

        } catch (Exception e) {
            resp.sendRedirect(ctx + "/admin/users/edit?id=" + id + "&error=1");
        }
    }
}
