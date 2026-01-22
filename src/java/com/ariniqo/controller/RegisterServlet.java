package com.ariniqo.controller;

import com.ariniqo.dao.UserDAO;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String firstName = safe(request.getParameter("firstName"));
        String lastName  = safe(request.getParameter("lastName"));
        String email     = safe(request.getParameter("email"));
        String password  = request.getParameter("password");

        String name = (firstName + " " + lastName).trim();

        if (name.length() == 0 || email.length() == 0 || password == null || password.trim().length() == 0) {
            request.setAttribute("error", "Please fill in all required fields.");
            request.getRequestDispatcher("/signup.jsp").forward(request, response);
            return;
        }

        // SECURITY: Public registration is ALWAYS a normal user
        String forcedRole = "user";

        UserDAO dao = new UserDAO();

        if (dao.emailExists(email)) {
            request.setAttribute("error", "Email already registered.");
            request.getRequestDispatcher("/signup.jsp").forward(request, response);
            return;
        }

        boolean ok = dao.register(name, email, password, forcedRole);

        if (ok) {
            response.sendRedirect(request.getContextPath() + "/login.jsp?registered=1");
        } else {
            request.setAttribute("error", "Registration failed. Try again.");
            request.getRequestDispatcher("/signup.jsp").forward(request, response);
        }
    }

    private String safe(String s) {
        return (s == null) ? "" : s.trim();
    }
}
