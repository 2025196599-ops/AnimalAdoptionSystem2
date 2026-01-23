<%-- 
    Document   : adoption-requests
    Updated on : Jan 2026
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*" %>
<%@ page import="com.ariniqo.model.User" %>

<%! 
    // ✅ JSP declaration (allowed) for helper method
    private String initialsOf(String name) {
        if (name == null) return "US";
        name = name.trim();
        if (name.length() == 0) return "US";

        String[] parts = name.split("\\s+");
        if (parts.length >= 2) {
            String a = parts[0];
            String b = parts[1];
            char c1 = (a.length() > 0 ? a.charAt(0) : 'U');
            char c2 = (b.length() > 0 ? b.charAt(0) : 'S');
            return ("" + Character.toUpperCase(c1) + Character.toUpperCase(c2));
        }

        char c1 = name.charAt(0);
        char c2 = (name.length() >= 2 ? name.charAt(1) : c1);
        return ("" + Character.toUpperCase(c1) + Character.toUpperCase(c2));
    }
%>

<%
    String ctx = request.getContextPath();

    // ✅ BASIC ADMIN GUARD
    User admin = (User) session.getAttribute("user");
    if (admin == null) {
        response.sendRedirect(ctx + "/login.jsp");
        return;
    }

    List adoptions = (List) request.getAttribute("adoptions");
    if (adoptions == null) adoptions = new ArrayList();

    boolean updated = "1".equals(request.getParameter("updated"));
    boolean error = "1".equals(request.getParameter("error"));
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Admin - Adoption Requests</title>

    <link rel="stylesheet" href="<%= ctx %>/css/admin-style.css" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body>

<div class="adoption-requests-container">

    <header class="adoption-header">
        <div class="header-content">
            <h1><i class="fas fa-heart"></i> Adoption Requests</h1>
            <p>Review and manage all adoption applications submitted by users</p>

            <div style="margin-top: 14px;">
                <a href="<%= ctx %>/admin/dashboard.jsp" class="action-btn btn-success" style="text-decoration:none;">
                    <i class="fas fa-arrow-left"></i> Back to Dashboard
                </a>
            </div>
        </div>
    </header>

    <% if (updated) { %>
        <div style="background: rgba(65, 216, 191, 0.12); padding: 12px 15px; border-radius: 8px; border: 1px solid #41D8BF; margin: 10px 0; display: flex; align-items: center; gap: 10px; color: #2d8f7f; font-size: 14px;">
            <i class="fas fa-check-circle"></i>
            <span>Adoption status updated successfully.</span>
        </div>
    <% } %>

    <% if (error) { %>
        <div style="background: rgba(244,67,54,0.12); padding: 12px 15px; border-radius: 8px; border: 1px solid #F44336; margin: 10px 0; display: flex; align-items: center; gap: 10px; color: #b71c1c; font-size: 14px;">
            <i class="fas fa-exclamation-circle"></i>
            <span>Action failed. Please try again.</span>
        </div>
    <% } %>

    <div class="requests-table-container">
        <div class="requests-table-header">
            <h3 class="requests-table-title">All Adoption Requests</h3>
            <div class="total-requests">
                <i class="fas fa-list"></i> <%= adoptions.size() %> Total Requests
            </div>
        </div>

        <table class="requests-table">
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Applicant</th>
                    <th>Pet</th>
                    <th>Applied Date</th>
                    <th>Status</th>
                    <th style="min-width: 320px;">Actions</th>
                </tr>
            </thead>

            <tbody>
            <% if (adoptions.isEmpty()) { %>
                <tr>
                    <td colspan="6" style="text-align:center; padding:30px;">No adoption requests found.</td>
                </tr>
            <% } else { %>

                <%
                    for (int i=0; i<adoptions.size(); i++) {
                        Map row = (Map) adoptions.get(i);

                        Number idNum = (Number) row.get("adoptionId");
                        int adoptionId = (idNum == null ? 0 : idNum.intValue());

                        String st = (row.get("status") == null ? "" : row.get("status").toString().trim());
                        if (st.length() == 0) st = "PENDING";
                        String up = st.toUpperCase();

                        Object tsObj = row.get("appliedDate");
                        String applied = (tsObj != null ? tsObj.toString() : "-");

                        String uName  = (row.get("userName") == null ? "" : row.get("userName").toString());
                        String uEmail = (row.get("email") == null ? "" : row.get("email").toString());

                        String pName = (row.get("petName") == null ? "" : row.get("petName").toString());

                        String badge = "status-pending";
                        String badgeIcon = "fa-clock";

                        if ("APPROVED".equals(up)) { badge = "status-approved"; badgeIcon = "fa-check-circle"; }
                        else if ("REJECTED".equals(up)) { badge = "status-rejected"; badgeIcon = "fa-times-circle"; }
                        else if ("COMPLETED".equals(up)) { badge = "status-completed"; badgeIcon = "fa-flag-checkered"; }

                        boolean isPending = "PENDING".equals(up);
                %>

                <tr>
                    <td>#AD-<%= adoptionId %></td>

                    <td>
                        <div class="user-info">
                            <div class="user-avatar"><%= initialsOf(uName) %></div>
                            <div class="user-details">
                                <div class="user-name"><%= (uName.length()>0 ? uName : "-") %></div>
                                <div class="user-email"><%= (uEmail.length()>0 ? uEmail : "-") %></div>
                            </div>
                        </div>
                    </td>

                    <td>
                        <div class="user-info">
                            <div class="user-avatar" style="background: linear-gradient(135deg, #667eea, #764ba2);">
                                <i class="fas fa-paw"></i>
                            </div>
                            <div class="user-details">
                                <div class="user-name"><%= (pName.length()>0 ? pName : "-") %></div>
                                <div class="user-email">Pet</div>
                            </div>
                        </div>
                    </td>

                    <td><%= applied %></td>

                    <td>
                        <span class="adoption-status-badge <%= badge %>">
                            <i class="fas <%= badgeIcon %>"></i> <%= st %>
                        </span>
                    </td>

                    <td>
                        <div class="adoption-actions">

                            <a href="<%= ctx %>/admin/adoption?id=<%= adoptionId %>"
                               class="adoption-action-btn btn-review"
                               style="text-decoration:none;">
                                <i class="fas fa-eye"></i> Review
                            </a>

                            <% if (isPending) { %>

                                <form action="<%= ctx %>/admin/adoption/update-status" method="post" style="display:inline;">
                                    <input type="hidden" name="id" value="<%= adoptionId %>">
                                    <input type="hidden" name="status" value="APPROVED">
                                    <button type="submit" class="adoption-action-btn btn-approve"
                                            onclick="return confirm('Approve this adoption request?');">
                                        <i class="fas fa-check"></i> Approve
                                    </button>
                                </form>

                                <form action="<%= ctx %>/admin/adoption/update-status" method="post" style="display:inline;">
                                    <input type="hidden" name="id" value="<%= adoptionId %>">
                                    <input type="hidden" name="status" value="REJECTED">
                                    <button type="submit" class="adoption-action-btn btn-reject"
                                            onclick="return confirm('Reject this adoption request?');">
                                        <i class="fas fa-times"></i> Reject
                                    </button>
                                </form>

                            <% } %>

                        </div>
                    </td>
                </tr>

                <%
                    }
                %>

            <% } %>
            </tbody>
        </table>

    </div>
</div>

</body>
</html>
