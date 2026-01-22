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

        int petId;
        try {
            petId = Integer.parseInt(request.getParameter("petId"));
        } catch (Exception e) {
            response.sendRedirect(request.getContextPath() + "/pets");
            return;
        }

        // If the form includes details, save them. Otherwise do quick apply.
        String phone = safe(request.getParameter("phone"));
        String address = safe(request.getParameter("address"));

        String houseType = safe(request.getParameter("houseType"));
        String experience = safe(request.getParameter("experience"));
        String reason = safe(request.getParameter("reason")).replace("\"", "\\\"");

        boolean hasFullForm =
                !phone.isEmpty() || !address.isEmpty() || !houseType.isEmpty() || !experience.isEmpty() || !reason.isEmpty();

        AdoptionDAO dao = new AdoptionDAO();

        try {
            if (hasFullForm) {
                int adoptionId = dao.createReturnId(user.getUserId(), petId);

                String formJson = "{"
                        + "\"houseType\":\"" + houseType + "\","
                        + "\"experience\":\"" + experience + "\","
                        + "\"reason\":\"" + reason + "\""
                        + "}";

                if (adoptionId > 0) {
                    dao.insertDetails(adoptionId, phone, address, formJson);
                }
            } else {
                dao.create(user.getUserId(), petId);
            }
        } catch (Exception ex) {
            throw new ServletException(ex);
        }

        // Keep UI consistent: if request came from user UI, keep ui=user in redirect
        String ui = request.getParameter("ui");
        if ("user".equalsIgnoreCase(ui)) {
            response.sendRedirect(request.getContextPath() + "/pet?id=" + petId + "&ui=user&applied=1");
        } else {
            response.sendRedirect(request.getContextPath() + "/pet?id=" + petId + "&applied=1");
        }
    }
}
