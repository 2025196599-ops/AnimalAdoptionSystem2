package com.ariniqo.controller;

import com.ariniqo.dao.ArticleDAO;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/articles")
public class ArticlesServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        try {
            req.setAttribute("articles", new ArticleDAO().listApproved());

            // Support both guest UI and logged-in user UI
            String ui = req.getParameter("ui"); // "user" or null
            String target = ("user".equalsIgnoreCase(ui))
                    ? "/user/user-rescue-articles.jsp"
                    : "/rescue-articles.jsp";

            req.getRequestDispatcher(target).forward(req, resp);

        } catch (Exception e) {
            throw new ServletException(e);
        }
    }
}
