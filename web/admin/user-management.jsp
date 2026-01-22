<%-- 
    Document   : user-management
    Created on : Jan 18, 2026
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*" %>
<%@ page import="com.ariniqo.model.User" %>

<%
    String ctx = request.getContextPath();

    User admin = (User) session.getAttribute("user");
    if (admin == null) {
        response.sendRedirect(ctx + "/login.jsp");
        return;
    }

    List users = (List) request.getAttribute("users");
    if (users == null) users = new ArrayList();

    boolean updated = "1".equals(request.getParameter("updated"));
    boolean deleted = "1".equals(request.getParameter("deleted"));

    String errParam = request.getParameter("error");
    boolean err = (errParam != null);
    boolean constraintErr = "constraint".equalsIgnoreCase(errParam);
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Admin - User Management</title>
    <link rel="stylesheet" href="<%= ctx %>/css/admin-style.css" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body>
<div class="container">
    <h1><i class="fas fa-users"></i> User Management</h1>

    <div style="margin: 12px 0 20px;">
        <a href="<%= ctx %>/admin/dashboard.jsp" class="action-btn btn-success" style="text-decoration:none;">
            <i class="fas fa-arrow-left"></i> Back to Dashboard
        </a>
    </div>

    <% if (updated) { %>
        <div style="background: rgba(65, 216, 191, 0.12); padding: 12px 15px; border-radius: 8px; border: 1px solid #41D8BF; margin: 10px 0; color: #2d8f7f;">
            <i class="fas fa-check-circle"></i> User updated successfully.
        </div>
    <% } %>

    <% if (deleted) { %>
        <div style="background: rgba(65, 216, 191, 0.12); padding: 12px 15px; border-radius: 8px; border: 1px solid #41D8BF; margin: 10px 0; color: #2d8f7f;">
            <i class="fas fa-check-circle"></i> User deleted successfully.
        </div>
    <% } %>

    <% if (err) { %>
        <div style="background: rgba(244,67,54,0.12); padding: 12px 15px; border-radius: 8px; border: 1px solid #F44336; margin: 10px 0; color: #b71c1c;">
            <i class="fas fa-exclamation-circle"></i>
            <% if (constraintErr) { %>
                Cannot delete this user because they have related records (adoptions/articles/reports). Delete those records first or use a “deactivate user” feature.
            <% } else { %>
                Action failed. Please try again.
            <% } %>
        </div>
    <% } %>

    <table class="table" style="width:100%; margin-top: 15px;">
        <thead>
            <tr>
                <th>ID</th>
                <th>Name</th>
                <th>Email</th>
                <th>Role</th>
                <th style="width:220px;">Actions</th>
            </tr>
        </thead>
        <tbody>
        <%
            if (users.isEmpty()) {
        %>
            <tr><td colspan="5">No users found.</td></tr>
        <%
            } else {
                for (int i=0; i<users.size(); i++) {
                    Map row = (Map) users.get(i);

                    String idStr = (row.get("userId") == null) ? "" : row.get("userId").toString();
                    String name = (row.get("name")==null ? "" : row.get("name").toString());
                    String email = (row.get("email")==null ? "" : row.get("email").toString());
                    String role  = (row.get("role")==null ? "" : row.get("role").toString());
        %>
            <tr>
                <td><%= idStr %></td>
                <td><%= name %></td>
                <td><%= email %></td>
                <td><%= role %></td>
                <td>
                    <a href="<%= ctx %>/admin/users/edit?id=<%= idStr %>" class="action-btn btn-edit" style="text-decoration:none;">
                        <i class="fas fa-edit"></i> Edit
                    </a>

                    <form action="<%= ctx %>/admin/users/delete" method="post" style="display:inline;">
                        <input type="hidden" name="id" value="<%= idStr %>">
                        <button type="submit" class="action-btn btn-delete"
                                onclick="return confirm('Delete this user? This cannot be undone.');">
                            <i class="fas fa-trash"></i> Delete
                        </button>
                    </form>
                </td>
            </tr>
        <%
                }
            }
        %>
        </tbody>
    </table>

    <p style="margin-top: 10px; color: #666;"><%= users.size() %> user(s)</p>
</div>
</body>
</html>
