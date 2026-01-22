package com.ariniqo.controller;

import com.ariniqo.dao.ArticleDAO;
import com.ariniqo.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/admin/article-approval")
public class AdminArticleApprovalServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String ctx = req.getContextPath();

        User admin = (User) req.getSession().getAttribute("user");
        if (admin == null) {
            resp.sendRedirect(ctx + "/login.jsp");
            return;
        }

        // Optional role check if you use role column
        // if (admin.getRole() == null || !admin.getRole().equalsIgnoreCase("admin")) {
        //     resp.sendError(HttpServletResponse.SC_FORBIDDEN);
        //     return;
        // }

        try {
            ArticleDAO dao = new ArticleDAO();
            req.setAttribute("pendingArticles", dao.listPending());
            req.setAttribute("approvedArticles", dao.listApproved());

            req.getRequestDispatcher("/admin/admin-article-approval.jsp").forward(req, resp);

        } catch (Exception e) {
            throw new ServletException(e);
        }
    }
}
