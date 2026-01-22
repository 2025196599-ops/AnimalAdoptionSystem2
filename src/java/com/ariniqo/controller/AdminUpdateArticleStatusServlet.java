package com.ariniqo.controller;

import com.ariniqo.dao.ArticleDAO;
import com.ariniqo.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/admin/articles/update-status")
public class AdminUpdateArticleStatusServlet extends HttpServlet {

    private String safe(String s) { return (s == null) ? "" : s.trim(); }

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
        String status = safe(req.getParameter("status")).toUpperCase();

        if (id <= 0 || status.length() == 0) {
            resp.sendRedirect(ctx + "/admin/article-approval?error=1");
            return;
        }

        try {
            new ArticleDAO().updateStatus(id, status);
            resp.sendRedirect(ctx + "/admin/article-approval?updated=1");
        } catch (Exception e) {
            resp.sendRedirect(ctx + "/admin/article-approval?error=1");
        }
    }
}
