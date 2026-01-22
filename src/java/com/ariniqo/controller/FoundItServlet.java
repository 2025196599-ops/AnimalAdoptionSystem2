package com.ariniqo.controller;

import com.ariniqo.dao.ReportFoundItDAO;
import com.ariniqo.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/reports/found-it")
public class FoundItServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        try {
            // ✅ Use the same session attribute your app already uses
            User user = (User) req.getSession().getAttribute("user");

            if (user == null) {
                resp.sendRedirect(req.getContextPath() + "/login.jsp");
                return;
            }

            // ✅ Get userId from the User object
            // IMPORTANT: change this line if your getter name is different
            int userId = user.getUserId();   // OR user.getId();

            String reportIdStr = req.getParameter("reportId");
            if (reportIdStr == null || reportIdStr.trim().length() == 0) {
                resp.sendRedirect(req.getContextPath() + "/reports?ui=user");
                return;
            }

            int reportId = Integer.parseInt(reportIdStr);
            String message = req.getParameter("message");

            new ReportFoundItDAO().insert(reportId, userId, message);

            // ✅ Redirect back to the same detail page and show success alert
            resp.sendRedirect(req.getContextPath() + "/report?id=" + reportId + "&ui=user&sent=1");

        } catch (Exception e) {
            throw new ServletException(e);
        }
    }
}