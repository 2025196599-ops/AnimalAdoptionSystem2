<%-- 
    Document   : adoption-reports
    Created on : Jan 18, 2026, 5:06:07 PM
    Author     : User
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*" %>
<%@ page import="com.ariniqo.model.User" %>

<%
    String ctx = request.getContextPath();

    // ✅ BASIC ADMIN GUARD
    User admin = (User) session.getAttribute("user");
    if (admin == null) {
        response.sendRedirect(ctx + "/login.jsp");
        return;
    }

    Integer totalObj = (Integer) request.getAttribute("total");
    Integer approvedObj = (Integer) request.getAttribute("approved");
    Integer rejectedObj = (Integer) request.getAttribute("rejected");
    Integer pendingObj = (Integer) request.getAttribute("pending");

    int total = (totalObj == null ? 0 : totalObj.intValue());
    int approved = (approvedObj == null ? 0 : approvedObj.intValue());
    int rejected = (rejectedObj == null ? 0 : rejectedObj.intValue());
    int pending = (pendingObj == null ? 0 : pendingObj.intValue());

    List rows = (List) request.getAttribute("rows");
    if (rows == null) rows = new ArrayList();
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Admin - Adoption Reports</title>
    <link rel="stylesheet" href="<%= ctx %>/css/admin-style.css" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body>
<div class="adoption-reports-container">
    <header class="reports-header">
        <div class="header-content">
            <h1><i class="fas fa-chart-line"></i> Adoption Reports</h1>
            <p>Complete history of all adoption activities and decisions</p>
        </div>
        <div style="padding-top: 12px;">
            <a href="<%= ctx %>/admin/dashboard.jsp" class="action-btn btn-success" style="text-decoration:none;">
                <i class="fas fa-arrow-left"></i> Back to Dashboard
            </a>
        </div>
    </header>

    <div class="reports-stats">
        <div class="stat-card-report"><div class="stat-icon-report"><i class="fas fa-paper-plane"></i></div><div class="stat-content-report"><h3><%= total %></h3><p>Total Applications</p></div></div>
        <div class="stat-card-report"><div class="stat-icon-report"><i class="fas fa-check-circle"></i></div><div class="stat-content-report"><h3><%= approved %></h3><p>Approved Adoptions</p></div></div>
        <div class="stat-card-report"><div class="stat-icon-report"><i class="fas fa-times-circle"></i></div><div class="stat-content-report"><h3><%= rejected %></h3><p>Rejected Applications</p></div></div>
        <div class="stat-card-report"><div class="stat-icon-report"><i class="fas fa-clock"></i></div><div class="stat-content-report"><h3><%= pending %></h3><p>Pending Review</p></div></div>
    </div>

    <div class="reports-table-container">
        <div class="reports-table-header">
            <h3 class="reports-table-title">Adoption History Log</h3>
            <div class="total-records"><i class="fas fa-history"></i> <%= total %> Total Records</div>
        </div>

        <table class="reports-table">
            <thead>
            <tr>
                <th>Date & Time</th>
                <th>Application ID</th>
                <th>Applicant</th>
                <th>Pet</th>
                <th>Status</th>
                <th>Details</th>
            </tr>
            </thead>
            <tbody>
            <%
                if (rows.isEmpty()) {
            %>
                <tr><td colspan="6">No adoption records found.</td></tr>
            <%
                } else {
                    for (int i=0; i<rows.size(); i++) {
                        Map row = (Map) rows.get(i);

                        Number idNum = (Number) row.get("adoptionId");
                        int adoptionId = (idNum == null ? 0 : idNum.intValue());

                        String st = (String) row.get("status");
                        Object tsObj = row.get("appliedDate");
                        String userName = (String) row.get("userName");
                        String userEmail = (String) row.get("userEmail");
                        String petName = (String) row.get("petName");
                        String petBreed = (String) row.get("petBreed");

                        String badgeClass = "action-submitted";
                        String up = (st == null ? "" : st.toUpperCase());
                        if ("APPROVED".equals(up)) badgeClass = "action-approved";
                        else if ("REJECTED".equals(up)) badgeClass = "action-rejected";
            %>
                <tr>
                    <td><%= (tsObj != null ? tsObj.toString() : "-") %></td>
                    <td>#AD-<%= adoptionId %></td>
                    <td><%= (userName != null ? userName : "") %><br><small><%= (userEmail != null ? userEmail : "") %></small></td>
                    <td><%= (petName != null ? petName : "") %><br><small><%= (petBreed != null ? petBreed : "") %></small></td>
                    <td><span class="action-type-badge <%= badgeClass %>"><i class="fas fa-clipboard"></i> <%= (st != null ? st : "") %></span></td>
                    <td>
                        <a href="<%= ctx %>/admin/adoption?id=<%= adoptionId %>" class="view-details-link">
                            <i class="fas fa-external-link-alt"></i> View
                        </a>
                    </td>
                </tr>
            <%
                    }
                }
            %>
            </tbody>
        </table>
    </div>
</div>
</body>
</html>
