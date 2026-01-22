package com.ariniqo.controller;

import com.ariniqo.dao.PetDAO;
import com.ariniqo.model.Pet;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/pet")
public class ViewPetServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String ui = request.getParameter("ui"); // "user" or null

        String idStr = request.getParameter("id");
        int id;
        try {
            id = Integer.parseInt(idStr);
        } catch (Exception e) {
            response.sendRedirect(request.getContextPath() + "/pets" + ("user".equalsIgnoreCase(ui) ? "?ui=user" : ""));
            return;
        }

        Pet pet = new PetDAO().getById(id);
        if (pet == null) {
            response.sendRedirect(request.getContextPath() + "/pets" + ("user".equalsIgnoreCase(ui) ? "?ui=user" : ""));
            return;
        }

        request.setAttribute("pet", pet);

        // ✅ MAIN default (unchanged)
        String target = "/view-pet.jsp";

        // ✅ USER view (your file name)
        if ("user".equalsIgnoreCase(ui)) {
            target = "/user/user-view-pet.jsp";
        }

        request.getRequestDispatcher(target).forward(request, response);
    }
}
