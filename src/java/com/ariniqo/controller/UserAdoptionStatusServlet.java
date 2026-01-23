package com.ariniqo.controller;

import com.ariniqo.dao.AdoptionDAO;
import com.ariniqo.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/user/adoption-status")
public class UserAdoptionStatusServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String ctx = req.getContextPath();

        HttpSession session = req.getSession(false);
        User user = (session == null) ? null : (User) session.getAttribute("user");

        if (user == null) {
            resp.sendRedirect(ctx + "/login.jsp");
            return;
        }

        try {
            req.setAttribute("adoptions", new AdoptionDAO().listByUser(user.getUserId()));
            req.getRequestDispatcher("/user/adoption-status.jsp").forward(req, resp);
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }
}
