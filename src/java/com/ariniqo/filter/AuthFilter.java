package com.ariniqo.filter;

import com.ariniqo.model.User;

import javax.servlet.*;
import javax.servlet.http.*;
import java.io.IOException;

public class AuthFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException { }

    @Override
    public void doFilter(ServletRequest req, ServletResponse res, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest request = (HttpServletRequest) req;
        HttpServletResponse response = (HttpServletResponse) res;

        String ctx = request.getContextPath();
        String uri = request.getRequestURI();
        String method = request.getMethod();

        // Public pages + static assets
        boolean isPublic =
                uri.equals(ctx + "/") ||
                uri.equals(ctx + "/index.jsp") ||
                uri.equals(ctx + "/login.jsp") ||
                uri.equals(ctx + "/signup.jsp") ||
                uri.equals(ctx + "/error.jsp") ||
                uri.equals(ctx + "/login") ||
                uri.equals(ctx + "/register") ||
                uri.equals(ctx + "/pets") ||
                uri.equals(ctx + "/pet") ||
                uri.equals(ctx + "/articles") ||
                uri.equals(ctx + "/article") ||
                (uri.equals(ctx + "/reports") && "GET".equalsIgnoreCase(method)) ||
                uri.startsWith(ctx + "/css/") ||
                uri.startsWith(ctx + "/js/") ||
                uri.startsWith(ctx + "/images/") ||
                uri.startsWith(ctx + "/uploads/");

        if (isPublic) {
            chain.doFilter(req, res);
            return;
        }

        // Determine login
        HttpSession session = request.getSession(false);
        Object sessionUserObj = (session == null) ? null : session.getAttribute("user");
        User user = (sessionUserObj instanceof User) ? (User) sessionUserObj : null;

        if (user == null) {
            response.sendRedirect(ctx + "/login.jsp");
            return;
        }

        // Admin-only
        if (uri.startsWith(ctx + "/admin/") && !"ADMIN".equalsIgnoreCase(user.getRole())) {
            response.sendRedirect(ctx + "/user/index.jsp");
            return;
        }

        chain.doFilter(req, res);
    }

    @Override
    public void destroy() { }
}
