package com.ariniqo.controller;

import com.ariniqo.dao.ArticleDAO;
import com.ariniqo.model.Article;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/article")
public class ArticleDetailServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String ui = req.getParameter("ui"); // "user" or null
        String idStr = req.getParameter("id");
        try {
            int id = Integer.parseInt(idStr);
            Article a = new ArticleDAO().getById(id);

            if (a == null || !"APPROVED".equalsIgnoreCase(a.getStatus())) {
                resp.sendRedirect(req.getContextPath() + "/articles" + ("user".equalsIgnoreCase(ui) ? "?ui=user" : ""));
                return;
            }

            req.setAttribute("article", a);

            String target = ("user".equalsIgnoreCase(ui))
                    ? "/user/article-detail.jsp"
                    : "/article-detail.jsp";

            req.getRequestDispatcher(target).forward(req, resp);


        } catch (Exception e) {
            resp.sendRedirect(req.getContextPath() + "/articles" + ("user".equalsIgnoreCase(ui) ? "?ui=user" : ""));
        }
    }
}
