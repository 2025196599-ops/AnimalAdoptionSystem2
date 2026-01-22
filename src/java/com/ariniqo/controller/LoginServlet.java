package com.ariniqo.controller;

import com.ariniqo.dao.UserDAO;
import com.ariniqo.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String selectedRole = request.getParameter("role"); // UI only: "admin" or "user"
        String email = safe(request.getParameter("email"));
        String password = request.getParameter("password");

        if (email.length() == 0 || password == null || password.trim().length() == 0) {
            request.setAttribute("error", "Please enter email and password.");
            request.getRequestDispatcher("/login.jsp").forward(request, response);
            return;
        }

        UserDAO dao = new UserDAO();
        User user = dao.login(email, password);

        if (user == null) {
            request.setAttribute("error", "Invalid email or password");
            request.getRequestDispatcher("/login.jsp").forward(request, response);
            return;
        }

        String realRole = user.getRole(); // "admin" or "user" (DB is truth)

        // (Optional) role selection message will not show after redirect anyway
        if ("admin".equalsIgnoreCase(selectedRole) && !"admin".equalsIgnoreCase(realRole)) {
            // you can ignore or store in session if you really want to display
        }

        HttpSession session = request.getSession(true);
        session.setAttribute("user", user);

        if ("admin".equalsIgnoreCase(realRole)) {
            response.sendRedirect(request.getContextPath() + "/admin/dashboard.jsp");
        } else {
            response.sendRedirect(request.getContextPath() + "/user/index.jsp");
        }
    }

    private String safe(String s) {
        return (s == null) ? "" : s.trim();
    }
}
