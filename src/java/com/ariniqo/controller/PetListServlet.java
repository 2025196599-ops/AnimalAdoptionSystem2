package com.ariniqo.controller;

import com.ariniqo.dao.PetDAO;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/pets")
public class PetListServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setAttribute("pets", new PetDAO().getAllAvailable());

        String ui = request.getParameter("ui");          // "user" or null
        String dashboard = request.getParameter("dashboard"); // "1" or null

        // ✅ MAIN default (unchanged)
        String target = "/pet-list.jsp";

        // ✅ USER UI routing (same servlet, different JSP)
        if ("user".equalsIgnoreCase(ui)) {
            if ("1".equals(dashboard)) {
                target = "/user/index.jsp";               // user dashboard uses DB pets
            } else {
                target = "/user/user-pet-list.jsp";       // user listing page
            }
        }

        request.getRequestDispatcher(target).forward(request, response);
    }
}
