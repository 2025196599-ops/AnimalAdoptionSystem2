package com.ariniqo.controller;

import com.ariniqo.dao.AdoptionDAO;
import com.ariniqo.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/admin/adoptions")
public class AdminAdoptionRequestsServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String ctx = req.getContextPath();

        User admin = (User) req.getSession().getAttribute("user");
        if (admin == null) {
            resp.sendRedirect(ctx + "/login.jsp");
            return;
        }

        try {
            req.setAttribute("adoptions", new AdoptionDAO().listAll());
            req.getRequestDispatcher("/admin/adoption-requests.jsp").forward(req, resp);
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }
}
