package com.ariniqo.controller;

import com.ariniqo.dao.ArticleDAO;
import com.ariniqo.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/admin/articles/delete")
public class AdminDeleteArticleServlet extends HttpServlet {

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
            resp.sendRedirect(ctx + "/admin/article-approval?error=1");
            return;
        }

        try {
            new ArticleDAO().deleteById(id);
            resp.sendRedirect(ctx + "/admin/article-approval?deleted=1");
        } catch (Exception e) {
            resp.sendRedirect(ctx + "/admin/article-approval?error=1");
        }
    }
}
