<%-- 
    Document   : lost-found-dashboard
    Created on : Jan 18, 2026, 3:31:20 PM
    Author     : User
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*" %>
<%@ page import="com.ariniqo.dao.LostFoundReportDAO" %>
<%@ page import="com.ariniqo.model.LostFoundReport" %>
<%@ page import="com.ariniqo.model.User" %>

<%
    String ctx = request.getContextPath();

    // ✅ BASIC ADMIN GUARD
    User admin = (User) session.getAttribute("user");
    if (admin == null) {
        response.sendRedirect(ctx + "/login.jsp");
        return;
    }

    List<LostFoundReport> reports = new LostFoundReportDAO().listAllActiveFirst();
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard - Lost & Found Reports</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Nunito:wght@400;600;700;800&family=Poppins:wght@300;400;500;600&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="<%= ctx %>/css/admin-style.css">
</head>
<body>
    <div class="lostfound-admin-container">
        <header class="lostfound-header">
            <div class="header-content">
                <h1><i class="fas fa-search"></i> Lost & Found Reports Dashboard</h1>
                <p>Manage and review all lost and found pet reports</p>
            </div>

            <div class="admin-user-section">
                <div class="admin-user">
                    <div class="admin-avatar">AD</div>
                    <div class="admin-info">
                        <div class="admin-name">Admin</div>
                        <div class="admin-role">Administrator</div>
                    </div>
                </div>

                <a href="<%= ctx %>/admin/dashboard.jsp" class="back-btn">
                    <i class="fas fa-arrow-left"></i> Back to Dashboard
                </a>
            </div>
        </header>

        <div class="lostfound-table-container">
            <div class="table-header">
                <h2><i class="fas fa-list"></i> Recent Reports</h2>
            </div>

            <table class="lostfound-table">
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Type</th>
                        <th>Pet Name</th>
                        <th>Reported By</th>
                        <th>Date</th>
                        <th>Status</th>
                        <th>Actions</th>
                    </tr>
                </thead>

                <tbody>
                <% if (reports.isEmpty()) { %>
                    <tr><td colspan="7" style="text-align:center; padding:30px;">No reports found.</td></tr>
                <% } else { %>
                    <% for (LostFoundReport r : reports) { %>
                    <tr>
                        <td>#LF-<%= r.getReportId() %></td>
                        <td>
                            <span class="type-badge <%= "FOUND".equalsIgnoreCase(r.getReportType()) ? "type-found" : "type-lost" %>">
                                <%= r.getReportType() %>
                            </span>
                        </td>
                        <td><%= (r.getPetName()!=null && !r.getPetName().isEmpty()) ? r.getPetName() : "Unknown" %> (<%= (r.getBreed()!=null?r.getBreed():"") %>)</td>
                        <td><%= r.getReporterName() %></td>
                        <td><%= r.getEventDate() %></td>
                        <td>
                            <span class="status-badge <%= "RESOLVED".equalsIgnoreCase(r.getStatus()) ? "status-resolved" : "status-active" %>">
                                <%= r.getStatus() %>
                            </span>
                        </td>
                        <td>
                            <div class="action-buttons">
                                <!-- ✅ FIX: go via servlet -->
                                <a class="btn-view" href="<%= ctx %>/admin/all-reports" style="text-decoration:none;">
                                    <i class="fas fa-eye"></i> View
                                </a>

                                <% if (!"RESOLVED".equalsIgnoreCase(r.getStatus())) { %>
                                <form action="<%= ctx %>/admin/reports/resolve" method="post" style="display:inline;">
                                    <input type="hidden" name="id" value="<%= r.getReportId() %>">
                                    <button class="btn-resolve" type="submit"
                                            onclick="return confirm('Mark this report as resolved?');">
                                        <i class="fas fa-check"></i> Resolve
                                    </button>
                                </form>
                                <% } %>
                            </div>
                        </td>
                    </tr>
                    <% } %>
                <% } %>
                </tbody>
            </table>
        </div>
    </div>
</body>
</html>
