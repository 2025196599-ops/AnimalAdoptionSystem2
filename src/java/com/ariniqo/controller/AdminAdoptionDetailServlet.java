package com.ariniqo.controller;

import com.ariniqo.dao.AdoptionDAO;
import com.ariniqo.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.Map;

@WebServlet("/admin/adoption")
public class AdminAdoptionDetailServlet extends HttpServlet {

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
            resp.sendRedirect(ctx + "/admin/adoptions");
            return;
        }

        try {
            Map adoption = new AdoptionDAO().getById(id); // must include phone/address/formJson
            if (adoption == null) {
                resp.sendRedirect(ctx + "/admin/adoptions");
                return;
            }

            req.setAttribute("adoption", adoption);
            req.getRequestDispatcher("/admin/adoption-request-detail.jsp").forward(req, resp);

        } catch (Exception e) {
            throw new ServletException(e);
        }
    }
}
