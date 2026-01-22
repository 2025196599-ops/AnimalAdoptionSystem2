package com.ariniqo.controller;

import com.ariniqo.dao.UserDAO;
import com.ariniqo.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.Map;

@WebServlet("/admin/users/edit")
public class AdminEditUserServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
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
            resp.sendRedirect(ctx + "/admin/users");
            return;
        }

        try {
            Map u = new UserDAO().getUserAsMapById(id);
            if (u == null) {
                resp.sendRedirect(ctx + "/admin/users");
                return;
            }
            req.setAttribute("u", u);
            req.getRequestDispatcher("/admin/edit-user.jsp").forward(req, resp);
        } catch (Exception e) {
            resp.sendRedirect(ctx + "/admin/users?error=1");
        }
    }
}
