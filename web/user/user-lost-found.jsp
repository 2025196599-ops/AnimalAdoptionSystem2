<%-- 
    Document   : user-lost-found
    Created on : Jan 18, 2026
    Author     : User
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*" %>
<%@ page import="com.ariniqo.model.User" %>
<%@ page import="com.ariniqo.model.LostFoundReport" %>
<%@ page import="com.ariniqo.dao.LostFoundReportDAO" %>

<%
    String ctx = request.getContextPath();

    User user = (User) session.getAttribute("user");
    boolean loggedIn = (user != null);
    String userEmail = (loggedIn && user.getEmail() != null) ? user.getEmail() : "";

    List<LostFoundReport> reports = new ArrayList<LostFoundReport>();
    try {
        reports = new LostFoundReportDAO().listAllActiveFirst();
    } catch (Exception e) {
        reports = new ArrayList<LostFoundReport>();
    }

    int activeLost = 0, activeFound = 0, resolved = 0;
    for (LostFoundReport r : reports) {
        String st = (r.getStatus() == null ? "" : r.getStatus());
        String tp = (r.getReportType() == null ? "" : r.getReportType());
        if ("RESOLVED".equalsIgnoreCase(st)) resolved++;
        else if ("LOST".equalsIgnoreCase(tp)) activeLost++;
        else if ("FOUND".equalsIgnoreCase(tp)) activeFound++;
    }

    List<LostFoundReport> myReports = new ArrayList<LostFoundReport>();
    if (loggedIn && userEmail.length() > 0) {
        for (LostFoundReport r : reports) {
            if (userEmail.equalsIgnoreCase(r.getReporterEmail())) {
                myReports.add(r);
            }
        }
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <title>Lost & Found – Ariniqo Buddies</title>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />

    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Nunito:wght@400;600;700;800&family=Poppins:wght@300;400;500;600&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="<%= ctx %>/css/user-style.css">

<style>
/* ===== PAGE LAYOUT ===== */
.lost-found-container { max-width:1200px; margin:auto; padding:40px 20px; }
.page-header { text-align:center; margin-bottom:40px; }
.page-title { font-size:36px; font-weight:800; }
.page-subtitle { color:#777; max-width:650px; margin:10px auto 0; }

/* ===== STATS ===== */
.quick-stats {
    display:grid; grid-template-columns:repeat(auto-fit,minmax(220px,1fr));
    gap:20px; margin:40px 0;
}
.stat {
    background:white; border-radius:18px; padding:25px;
    box-shadow:0 10px 25px rgba(0,0,0,0.08);
    text-align:center;
}
.stat-number { font-size:34px; font-weight:800; }
.stat-label { color:#777; font-size:14px; margin-top:6px; }

/* ===== ACTION CARDS ===== */
.action-cards {
    display:grid; grid-template-columns:repeat(auto-fit,minmax(260px,1fr));
    gap:25px; margin:50px 0;
}
.action-card {
    background:white; padding:35px; border-radius:22px;
    text-decoration:none; color:inherit;
    box-shadow:0 12px 30px rgba(0,0,0,0.08);
    transition:all .3s ease;
}
.action-card:hover { transform:translateY(-6px); }
.action-icon {
    width:60px; height:60px; border-radius:50%;
    display:flex; align-items:center; justify-content:center;
    font-size:26px; color:white; margin-bottom:20px;
}
.lost-icon { background:#ff7e5f; }
.found-icon { background:#4caf50; }
.view-icon { background:#5d6afb; }
.action-title { font-size:20px; font-weight:700; margin-bottom:8px; }
.action-description { color:#777; font-size:14px; }
.action-link { margin-top:20px; font-weight:600; color:#ff7e5f; }

/* ===== SECTIONS ===== */
.section { margin-top:60px; }
.section-header {
    display:flex; justify-content:space-between; align-items:center;
    margin-bottom:25px;
}
.section-title { font-size:24px; font-weight:800; }

/* ===== REPORT CARDS ===== */
.reports-grid {
    display:grid; grid-template-columns:repeat(auto-fit,minmax(260px,1fr));
    gap:25px;
}
.report-card {
    background:white; border-radius:20px; padding:25px;
    box-shadow:0 10px 25px rgba(0,0,0,0.07);
}
.report-header {
    display:flex; justify-content:space-between; margin-bottom:12px;
}
.report-type { font-size:12px; font-weight:700; color:#ff7e5f; }
.type-found { color:#4caf50; }
.report-status { font-size:12px; font-weight:700; color:#777; }
.report-title { font-size:18px; font-weight:700; margin:10px 0; }
.report-info { font-size:14px; color:#666; margin-top:6px; display:flex; gap:8px; }
.report-action-btn {
    display:block; margin-top:20px; text-align:center;
    background:#ff7e5f; color:white;
    padding:12px; border-radius:30px; font-weight:600;
    text-decoration:none;
}
.report-action-btn:hover { background:#ff9a8b; }

/* ===== EMPTY STATES ===== */
.no-reports {
    text-align:center; padding:50px; color:#777;
    background:#f9fafc; border-radius:20px;
}
</style>
</head>

<body>

<jsp:include page="/user/user-navBar.jsp" />

<main class="main-content">
<div class="lost-found-container">

    <!-- HEADER -->
    <div class="page-header">
        <h1 class="page-title"><i class="fas fa-search"></i> Lost & Found Pets</h1>
        <p class="page-subtitle">
            Report lost or found animals and help reunite pets with their families.
        </p>
    </div>

    <!-- STATS -->
    <div class="quick-stats">
        <div class="stat"><div class="stat-number"><%= activeLost %></div><div class="stat-label">Lost Pets</div></div>
        <div class="stat"><div class="stat-number"><%= activeFound %></div><div class="stat-label">Found Pets</div></div>
        <div class="stat"><div class="stat-number"><%= resolved %></div><div class="stat-label">Resolved</div></div>
    </div>

    <!-- ACTIONS -->
    <div class="action-cards">
        <a href="<%= ctx %>/user/report-lost-pet.jsp" class="action-card">
            <div class="action-icon lost-icon"><i class="fas fa-search"></i></div>
            <h3 class="action-title">Report Lost Pet</h3>
            <p class="action-description">Create a lost pet report.</p>
            <div class="action-link">Report Now →</div>
        </a>

        <a href="<%= ctx %>/user/found-report.jsp" class="action-card">
            <div class="action-icon found-icon"><i class="fas fa-hand-holding-heart"></i></div>
            <h3 class="action-title">Report Found Pet</h3>
            <p class="action-description">Help return a found pet.</p>
            <div class="action-link">Report Found →</div>
        </a>

        <a href="<%= ctx %>/reports?ui=user" class="action-card">
            <div class="action-icon view-icon"><i class="fas fa-list"></i></div>
            <h3 class="action-title">View All Reports</h3>
            <p class="action-description">Browse community reports.</p>
            <div class="action-link">View Reports →</div>
        </a>
    </div>

    <!-- YOUR REPORTS -->
    <div class="section">
        <div class="section-header">
            <h2 class="section-title"><i class="fas fa-user"></i> Your Recent Reports</h2>
        </div>

        <% if (!loggedIn) { %>
            <div class="no-reports">
                <i class="fas fa-lock fa-2x"></i>
                <h3>Login Required</h3>
                <p>Please login to view your reports.</p>
            </div>
        <% } else if (myReports.isEmpty()) { %>
            <div class="no-reports">
                <h3>No Reports Yet</h3>
                <p>You haven't submitted any reports.</p>
            </div>
        <% } else { %>
            <div class="reports-grid">
                <% for (int i=0; i<Math.min(3,myReports.size()); i++) {
                    LostFoundReport r = myReports.get(i);
                %>
                <div class="report-card">
                    <div class="report-header">
                        <div class="report-type"><%= r.getReportType() %></div>
                        <div class="report-status"><%= r.getStatus() %></div>
                    </div>
                    <h4 class="report-title"><%= r.getPetName() %></h4>
                    <div class="report-info"><i class="fas fa-map-marker-alt"></i> <%= r.getLocationText() %></div>
                    <a class="report-action-btn"
                       href="<%= ctx %>/report?id=<%= r.getReportId() %>&ui=user">View Details</a>
                </div>
                <% } %>
            </div>
        <% } %>

    </div>

</div>
</main>

<jsp:include page="/user/user-footer.jsp" />
</body>
</html>