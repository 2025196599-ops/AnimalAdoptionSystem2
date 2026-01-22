package com.ariniqo.controller;

import com.ariniqo.dao.ArticleDAO;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/admin/articles")
public class AdminPendingArticlesServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        try {
            req.setAttribute("pendingArticles", new ArticleDAO().listPending());

            // ✅ ONLY forward (no redirect here)
            req.getRequestDispatcher("/admin/admin-article-approval.jsp")
               .forward(req, resp);

        } catch (Exception e) {
            throw new ServletException(e);
        }
    }
}
