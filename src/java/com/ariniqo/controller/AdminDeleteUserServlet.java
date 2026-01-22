package com.ariniqo.controller;

import com.ariniqo.dao.UserDAO;
import com.ariniqo.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/admin/users/delete")
public class AdminDeleteUserServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String ctx = req.getContextPath();

        User admin = (User) req.getSession().getAttribute("user");
        if (admin == null) {
            resp.sendRedirect(ctx + "/login.jsp");
            return;
        }

        int id = 0;
        try { id = Integer.parseInt(req.getParameter("id")); } catch (Exception ignore) {}

        if (id <= 0) {
            resp.sendRedirect(ctx + "/admin/users?error=1");
            return;
        }

        try {
            new UserDAO().deleteUser(id);
            resp.sendRedirect(ctx + "/admin/users?deleted=1");

        } catch (SQLException se) {
            // ✅ This usually happens if FK constraints exist (user has adoptions/articles/reports)
            se.printStackTrace();
            resp.sendRedirect(ctx + "/admin/users?error=constraint");

        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect(ctx + "/admin/users?error=1");
        }
    }
}
