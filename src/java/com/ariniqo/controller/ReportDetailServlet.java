/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.ariniqo.controller;

import com.ariniqo.dao.LostFoundReportDAO;
import com.ariniqo.model.LostFoundReport;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/report")
public class ReportDetailServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        int id;
        try {
            id = Integer.parseInt(req.getParameter("id"));
        } catch (Exception e) {
            resp.sendRedirect(req.getContextPath() + "/reports?ui=user");
            return;
        }

        try {
            LostFoundReport r = new LostFoundReportDAO().getById(id);
            if (r == null) {
                resp.sendRedirect(req.getContextPath() + "/reports?ui=user");
                return;
            }

            req.setAttribute("report", r);
            req.getRequestDispatcher("/user/report-detail.jsp").forward(req, resp);

        } catch (Exception e) {
            throw new ServletException(e);
        }
    }
}
