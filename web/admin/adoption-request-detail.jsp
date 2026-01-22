<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ page import="com.ariniqo.util.DBConnection" %>
<%@ page import="com.ariniqo.model.User" %>

<%
    String ctx = request.getContextPath();

    // basic guard
    User admin = (User) session.getAttribute("user");
    if (admin == null) {
        response.sendRedirect(ctx + "/login.jsp");
        return;
    }

    int adoptionId = -1;
    try { adoptionId = Integer.parseInt(request.getParameter("id")); } catch (Exception ignore) {}

    if (adoptionId <= 0) {
        response.sendRedirect(ctx + "/admin/adoptions");
        return;
    }

    boolean updated = "1".equals(request.getParameter("updated"));

    // fields we want to display
    String status = "";
    Timestamp appliedDate = null;

    String userName = "";
    String userEmail = "";

    String petName = "";
    String petBreed = "";
    String petType = "";

    String phone = "";
    String address = "";
    String formJson = "";

    // Load from DB (no try-with-resources)
    String sql =
        "SELECT a.ADOPTION_ID, a.STATUS, a.APPLIED_DATE, " +
        "u.NAME AS USER_NAME, u.EMAIL AS USER_EMAIL, " +
        "p.NAME AS PET_NAME, p.BREED AS PET_BREED, p.TYPE AS PET_TYPE, " +
        "d.PHONE, d.ADDRESS, d.FORM_JSON " +
        "FROM ADOPTIONS a " +
        "JOIN USERS u ON a.USER_ID = u.USER_ID " +
        "JOIN PETS p ON a.PET_ID = p.PET_ID " +
        "LEFT JOIN ADOPTION_APPLICATION_DETAILS d ON d.ADOPTION_ID = a.ADOPTION_ID " +
        "WHERE a.ADOPTION_ID = ?";

    Connection con = null;
    PreparedStatement ps = null;
    ResultSet rs = null;

    try {
        con = DBConnection.getConnection();
        ps = con.prepareStatement(sql);
        ps.setInt(1, adoptionId);
        rs = ps.executeQuery();

        if (!rs.next()) {
            response.sendRedirect(ctx + "/admin/adoptions");
            return;
        }

        status = rs.getString("STATUS");
        appliedDate = rs.getTimestamp("APPLIED_DATE");

        userName = rs.getString("USER_NAME");
        userEmail = rs.getString("USER_EMAIL");

        petName = rs.getString("PET_NAME");
        petBreed = rs.getString("PET_BREED");
        petType = rs.getString("PET_TYPE");

        phone = rs.getString("PHONE");
        address = rs.getString("ADDRESS");
        formJson = rs.getString("FORM_JSON");

        if (phone == null) phone = "";
        if (address == null) address = "";
        if (formJson == null) formJson = "";

    } catch (Exception e) {
        e.printStackTrace();
        response.sendRedirect(ctx + "/admin/adoptions");
        return;

    } finally {
        try { if (rs != null) rs.close(); } catch (Exception e) {}
        try { if (ps != null) ps.close(); } catch (Exception e) {}
        try { if (con != null) con.close(); } catch (Exception e) {}
    }

    // Badge UI
    String stUp = (status == null) ? "" : status.trim().toUpperCase();
    String badgeClass = "status-pending";
    String badgeIcon = "fa-clock";
    if ("APPROVED".equals(stUp)) { badgeClass = "status-approved"; badgeIcon = "fa-check"; }
    else if ("REJECTED".equals(stUp)) { badgeClass = "status-rejected"; badgeIcon = "fa-times"; }

    // --- Parse formJson into Map (simple parser: expects {"k":"v",...} style)
    Map parsed = new LinkedHashMap();
    try {
        String s = formJson.trim();
        if (s.startsWith("{")) s = s.substring(1);
        if (s.endsWith("}")) s = s.substring(0, s.length()-1);

        // split by comma (basic). If values contain commas, this won't be perfect, but good enough for student forms.
        String[] parts = s.split(",");
        for (int i=0; i<parts.length; i++) {
            String p = parts[i];
            int colon = p.indexOf(':');
            if (colon < 0) continue;

            String k = p.substring(0, colon).trim();
            String v = p.substring(colon+1).trim();

            // remove quotes
            if (k.startsWith("\"")) k = k.substring(1);
            if (k.endsWith("\"")) k = k.substring(0, k.length()-1);
            if (v.startsWith("\"")) v = v.substring(1);
            if (v.endsWith("\"")) v = v.substring(0, v.length()-1);

            // unescape
            v = v.replace("\\n", "\n").replace("\\\"", "\"");

            parsed.put(k, v);
        }
    } catch (Exception ignore) {}
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Admin - Adoption Request Details</title>
    <link rel="stylesheet" href="<%= ctx %>/css/admin-style.css" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body>

<div class="adoption-detail-container">
    <header class="adoption-detail-header">
        <div class="header-content">
            <h1><i class="fas fa-file-alt"></i> Adoption Request Details</h1>
            <p>Review application details and make a decision</p>
        </div>
        <a href="<%= ctx %>/admin/adoptions" class="back-btn">
            <i class="fas fa-arrow-left"></i> Back to Requests
        </a>
    </header>

    <% if (updated) { %>
        <div style="background: rgba(65, 216, 191, 0.12); padding: 12px 15px; border-radius: 8px; border: 1px solid #41D8BF; margin: 15px 0; color: #2d8f7f; font-size: 14px;">
            <i class="fas fa-check-circle"></i> Status updated successfully.
        </div>
    <% } %>

    <div class="request-details-grid">

        <!-- Applicant -->
        <div class="applicant-info-section">
            <div class="applicant-header">
                <div class="applicant-avatar"><%= (userName != null && userName.length()>=2 ? (""+userName.charAt(0)+userName.charAt(1)) : "US") %></div>
                <div class="applicant-details">
                    <h2><%= userName %></h2>
                    <p><%= userEmail %><%= (phone.length()>0 ? " | " + phone : "") %></p>
                </div>
            </div>

            <div class="applicant-info-grid">
                <div class="info-row">
                    <span class="info-label">Application ID:</span>
                    <span class="info-value">#AD-<%= adoptionId %></span>
                </div>
                <div class="info-row">
                    <span class="info-label">Applied Date:</span>
                    <span class="info-value"><%= (appliedDate != null ? appliedDate.toString() : "-") %></span>
                </div>
                <div class="info-row">
                    <span class="info-label">Address:</span>
                    <span class="info-value"><%= (address.length()>0 ? address : "-") %></span>
                </div>
            </div>
        </div>

        <!-- Pet -->
        <div class="pet-info-section">
            <div class="pet-header">
                <div class="pet-image">
                    <img src="https://images.unsplash.com/photo-1552053831-71594a27632d?auto=format&fit=crop&w=400&q=80" alt="<%= petName %>">
                </div>
                <div class="pet-details">
                    <h2><%= petName %></h2>
                    <p><%= (petBreed != null ? petBreed : "") %> • <%= (petType != null ? petType : "") %></p>
                    <span class="adoption-status-badge status-available" style="margin-top: 10px;">
                        <i class="fas fa-paw"></i> Pet Record
                    </span>
                </div>
            </div>
        </div>

        <!-- Admin actions + Form -->
        <div class="admin-action-section">
            <h3 class="section-title" style="color: #4facfe;">
                <i class="fas fa-user-cog"></i> Admin Actions
            </h3>

            <div class="admin-action-content">

                <div class="status-actions-row">
                    <div class="status-display">
                        <span class="status-display-label">Current Status:</span>
                        <span class="adoption-status-badge <%= badgeClass %>">
                            <i class="fas <%= badgeIcon %>"></i> <%= (status != null ? status : "") %>
                        </span>
                    </div>

                    <div class="action-buttons-group">
                        <form action="<%= ctx %>/admin/adoption/update-status" method="post" style="display:inline;">
                            <input type="hidden" name="id" value="<%= adoptionId %>">
                            <input type="hidden" see name="status" value="APPROVED">
                            <button type="submit" class="btn btn-success" onclick="return confirm('Approve this adoption request?');">
                                <i class="fas fa-check"></i> Approve
                            </button>
                        </form>

                        <form action="<%= ctx %>/admin/adoption/update-status" method="post" style="display:inline;">
                            <input type="hidden" name="id" value="<%= adoptionId %>">
                            <input type="hidden" name="status" value="REJECTED">
                            <button type="submit" class="btn btn-danger" onclick="return confirm('Reject this adoption request?');">
                                <i class="fas fa-times"></i> Reject
                            </button>
                        </form>
                    </div>
                </div>

                <hr style="margin:18px 0; border:none; border-top:1px solid #eee;">

                <h3 style="margin:0 0 10px;">
                    <i class="fas fa-clipboard-list"></i> Adoption Form Submitted
                </h3>

                <div style="background:#f9fafb; border:1px solid #eee; border-radius:12px; padding:14px;">
                    <div style="margin-bottom:10px;"><strong>Phone:</strong> <%= (phone.length()>0 ? phone : "-") %></div>
                    <div style="margin-bottom:10px;"><strong>Address:</strong> <%= (address.length()>0 ? address : "-") %></div>

                    <%
                        if (formJson.trim().length() == 0) {
                    %>
                        <div style="color:#666;">No extra form fields stored.</div>
                    <%
                        } else if (parsed.isEmpty()) {
                    %>
                        <div style="color:#666;">
                            <strong>Form JSON (raw):</strong>
                            <pre style="white-space:pre-wrap; margin:10px 0 0;"><%= formJson %></pre>
                        </div>
                    <%
                        } else {
                    %>
                        <table style="width:100%; border-collapse:collapse;">
                            <tbody>
                            <%
                                Iterator it = parsed.entrySet().iterator();
                                while (it.hasNext()) {
                                    Map.Entry e = (Map.Entry) it.next();
                            %>
                                <tr>
                                    <td style="padding:8px 6px; width:35%; font-weight:700; color:#333; border-bottom:1px solid #eee;">
                                        <%= e.getKey() %>
                                    </td>
                                    <td style="padding:8px 6px; color:#444; border-bottom:1px solid #eee;">
                                        <%= (e.getValue() == null ? "" : e.getValue().toString()) %>
                                    </td>
                                </tr>
                            <%
                                }
                            %>
                            </tbody>
                        </table>
                    <%
                        }
                    %>
                </div>

                <hr style="margin:18px 0; border:none; border-top:1px solid #eee;">

                <h3 style="margin:0 0 10px;">
                    <i class="fas fa-code"></i> Stored Form JSON
                </h3>
                <pre style="white-space:pre-wrap; background:#fff; border:1px solid #eee; padding:12px; border-radius:12px; margin:0;"><%= formJson %></pre>

            </div>
        </div>

    </div>
</div>

</body>
</html>
