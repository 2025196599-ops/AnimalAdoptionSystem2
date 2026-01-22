<%-- 
    Document   : edit-user
    Created on : Jan 22, 2026, 11:37:54 PM
    Author     : User
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.Map" %>
<%@ page import="com.ariniqo.model.User" %>

<%
    String ctx = request.getContextPath();

    User admin = (User) session.getAttribute("user");
    if (admin == null) {
        response.sendRedirect(ctx + "/login.jsp");
        return;
    }

    Map u = (Map) request.getAttribute("u");
    if (u == null) {
        response.sendRedirect(ctx + "/admin/users");
        return;
    }

    String id = (u.get("userId")==null ? "" : u.get("userId").toString());
    String name = (u.get("name")==null ? "" : u.get("name").toString());
    String email = (u.get("email")==null ? "" : u.get("email").toString());
    String role  = (u.get("role")==null ? "" : u.get("role").toString());

    boolean err = "1".equals(request.getParameter("error"));
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Admin - Edit User</title>
    <link rel="stylesheet" href="<%= ctx %>/css/admin-style.css" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body>
<div class="container" style="max-width: 900px;">
    <h1><i class="fas fa-user-edit"></i> Edit User</h1>

    <div style="margin: 12px 0 20px;">
        <a href="<%= ctx %>/admin/users" class="action-btn btn-success" style="text-decoration:none;">
            <i class="fas fa-arrow-left"></i> Back to Users
        </a>
    </div>

    <% if (err) { %>
        <div style="background: rgba(244,67,54,0.12); padding: 12px 15px; border-radius: 8px; border: 1px solid #F44336; margin: 10px 0; color: #b71c1c;">
            <i class="fas fa-exclamation-circle"></i> Update failed. Please try again.
        </div>
    <% } %>

    <div style="background:#fff; padding: 25px; border-radius: 16px; box-shadow: 0 4px 12px rgba(0,0,0,0.06);">
        <form action="<%= ctx %>/admin/users/update" method="post">

            <input type="hidden" name="id" value="<%= id %>">

            <div class="form-group">
                <label>User ID</label>
                <input type="text" value="<%= id %>" readonly>
            </div>

            <div class="form-group">
                <label class="required">Name</label>
                <input type="text" name="name" value="<%= name %>" required>
            </div>

            <div class="form-group">
                <label class="required">Email</label>
                <input type="email" name="email" value="<%= email %>" required>
            </div>

            <div class="form-group">
                <label class="required">Role</label>
                <select name="role" required>
                    <option value="user" <%= "user".equalsIgnoreCase(role) ? "selected" : "" %>>User</option>
                    <option value="admin" <%= "admin".equalsIgnoreCase(role) ? "selected" : "" %>>Admin</option>
                </select>
            </div>

            <div class="form-group">
                <label>New Password (optional)</label>
                <input type="password" name="newPassword" placeholder="Leave blank to keep current password">
                <small class="form-help">Only update if you want to reset this user's password.</small>
            </div>

            <div class="form-actions">
                <button type="submit" class="btn-submit">
                    <i class="fas fa-save"></i> Save Changes
                </button>
                <a href="<%= ctx %>/admin/users" class="btn-cancel">
                    <i class="fas fa-times"></i> Cancel
                </a>
            </div>

        </form>
    </div>
</div>
</body>
</html>
