<%-- 
    Document   : all-reports
    Created on : Jan 18, 2026, 5:05:31 PM
    Author     : User
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*" %>
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

    List<LostFoundReport> reports = (List<LostFoundReport>) request.getAttribute("reports");
    if (reports == null) reports = new ArrayList<LostFoundReport>();
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>All Reports - Admin Panel</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Nunito:wght@400;600;700;800&family=Poppins:wght@300;400;500;600&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="<%= ctx %>/css/admin-style.css">
</head>
<body>
    <div class="admin-container">
        <main class="admin-main">
            <header class="admin-header">
                <h1><i class="fas fa-clipboard-list"></i> All Lost & Found Reports</h1>
            </header>

            <div class="reports-table-container">
                <div class="table-header">
                    <h2><i class="fas fa-list"></i> All Reports (<%= reports.size() %>)</h2>
                </div>

                <table class="reports-table">
                    <thead>
                        <tr>
                            <th>Report ID</th>
                            <th>Type</th>
                            <th>Pet</th>
                            <th>Reported By</th>
                            <th>Date</th>
                            <th>Status</th>
                            <th>Admin Action</th>
                        </tr>
                    </thead>
                    <tbody>
                    <%
                        if (reports.isEmpty()) {
                    %>
                        <tr><td colspan="7">No reports found.</td></tr>
                    <%
                        } else {
                            for (LostFoundReport r : reports) {
                                String type = r.getReportType();
                                String status = r.getStatus();

                                String petLabel = (r.getPetName()!=null && r.getPetName().trim().length()>0) ? r.getPetName() : "Unknown";
                                String petExtra = "";
                                if (r.getBreed()!=null && r.getBreed().trim().length()>0) petExtra = r.getBreed();
                                else if (r.getPetType()!=null && r.getPetType().trim().length()>0) petExtra = r.getPetType();

                                String typeBadge = "type-lost";
                                if ("FOUND".equalsIgnoreCase(type)) typeBadge = "type-found";

                                String statusBadge = "status-active";
                                if ("RESOLVED".equalsIgnoreCase(status)) statusBadge = "status-resolved";
                    %>
                        <tr>
                            <td>#LF-<%= r.getReportId() %></td>
                            <td><span class="type-badge <%= typeBadge %>"><%= type %></span></td>
                            <td><%= petLabel %><%= (petExtra.length()==0 ? "" : " (" + petExtra + ")") %></td>
                            <td><%= r.getReporterName() %></td>
                            <td><%= (r.getEventDate()!=null ? r.getEventDate().toString() : "-") %></td>
                            <td><span class="status-badge <%= statusBadge %>"><%= status %></span></td>
                            <td>
                                <% if (!"RESOLVED".equalsIgnoreCase(status)) { %>
                                <form action="<%= ctx %>/admin/reports/resolve" method="post" style="display:inline;">
                                    <input type="hidden" name="id" value="<%= r.getReportId() %>">
                                    <button type="submit" class="btn-submit"
                                            onclick="return confirm('Mark this report as resolved?');">
                                        <i class="fas fa-check"></i> Resolve
                                    </button>
                                </form>
                                <% } else { %>
                                    <span style="color:#666; font-weight:600;">
                                        <i class="fas fa-check-circle"></i> Resolved
                                    </span>
                                <% } %>
                            </td>
                        </tr>
                    <%
                            }
                        }
                    %>
                    </tbody>
                </table>

                <div style="margin-top: 20px;">
                    <a href="<%= ctx %>/admin/dashboard.jsp" class="action-btn btn-success">
                        <i class="fas fa-arrow-left"></i> Back to Dashboard
                    </a>
                </div>

            </div>
        </main>
    </div>
</body>
</html>
