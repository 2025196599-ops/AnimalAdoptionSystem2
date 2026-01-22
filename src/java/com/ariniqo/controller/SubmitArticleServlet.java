package com.ariniqo.controller;

import com.ariniqo.dao.ArticleDAO;
import com.ariniqo.model.Article;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/articles/submit")
public class SubmitArticleServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        try {
            Article a = new Article();
            a.setTitle(req.getParameter("title"));
            a.setCategory(req.getParameter("category"));
            a.setAuthorName(req.getParameter("author"));
            a.setAuthorEmail(req.getParameter("email"));
            a.setExcerpt(req.getParameter("excerpt"));
            a.setContent(req.getParameter("content"));
            a.setImageUrl(req.getParameter("image"));

            int newId = new ArticleDAO().insertPending(a);

            // ✅ FIXED PATH (matches WEB PAGES/User)
            resp.sendRedirect(
                req.getContextPath()
                + "/user/user-rescue-articles.jsp?submitted=1&id=" + newId
            );

        } catch (Exception e) {
            throw new ServletException(e);
        }
    }
}
