package com.ariniqo.controller;

import com.ariniqo.dao.AdoptionDAO;
import com.ariniqo.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/adopt")
public class AdoptServlet extends HttpServlet {

    private String safe(String s) { return (s == null) ? "" : s.trim(); }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        User user = (session == null) ? null : (User) session.getAttribute("user");

        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        int petId = 0;
        try { petId = Integer.parseInt(request.getParameter("petId")); } catch (Exception ignore) {}

        if (petId <= 0) {
            response.sendRedirect(request.getContextPath() + "/pets?ui=user");
            return;
        }

        String phone = safe(request.getParameter("phone"));
        String address = safe(request.getParameter("address"));

        String houseType = safe(request.getParameter("houseType"));
        String experience = safe(request.getParameter("experience"));
        String reason = safe(request.getParameter("reason")).replace("\"", "\\\"");

        boolean hasFullForm =
                phone.length() > 0 || address.length() > 0 || houseType.length() > 0 || experience.length() > 0 || reason.length() > 0;

        try {
            AdoptionDAO dao = new AdoptionDAO();

            int adoptionId = dao.createReturnId(user.getUserId(), petId);

            if (hasFullForm && adoptionId > 0) {
                String formJson = "{"
                        + "\"houseType\":\"" + houseType + "\","
                        + "\"experience\":\"" + experience + "\","
                        + "\"reason\":\"" + reason + "\""
                        + "}";

                dao.insertDetails(adoptionId, phone, address, formJson);
            }

        } catch (Exception ex) {
            throw new ServletException(ex);
        }

        response.sendRedirect(request.getContextPath() + "/user/adoption-status?submitted=1");
    }
}
