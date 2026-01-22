<%-- 
    Document   : dashboard
    Created on : Jan 18, 2026
    Author     : User
--%>
<%
boolean deleted = "1".equals(request.getParameter("deleted"));
%>

<% if (deleted) { %>
<div style="background: rgba(65, 216, 191, 0.12); padding: 12px 15px; border-radius: 8px; border: 1px solid #41D8BF; margin: 10px 0; display: flex; align-items: center; gap: 10px; color: #2d8f7f; font-size: 14px;">
    <i class="fas fa-check-circle"></i>
    <span>Article deleted successfully.</span>
</div>
<% } %>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.ariniqo.model.User" %>
<%@ page import="java.sql.*" %>
<%@ page import="com.ariniqo.util.DBConnection" %>

<%
    String ctx = request.getContextPath();

    // ✅ BASIC ADMIN GUARD (adjust role check if you have user.getRole())
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect(ctx + "/login.jsp");
        return;
    }

    String adminName = (user.getName() != null && !user.getName().trim().isEmpty())
            ? user.getName()
            : "System Administrator";

    // ===== REAL COUNTS =====
    int totalPets = 0;
    int totalUsers = 0;
    int approvedAdoptions = 0;
    int pendingArticles = 0;
    int pendingAdoptions = 0;
    int pendingApprovals = 0;


    Connection con = null;
    PreparedStatement ps = null;
    ResultSet rs = null;

    try {
        con = DBConnection.getConnection();

        // total pets
        ps = con.prepareStatement("SELECT COUNT(*) FROM PETS");
        rs = ps.executeQuery();
        if (rs.next()) totalPets = rs.getInt(1);
        try { rs.close(); } catch (Exception e) {}
        try { ps.close(); } catch (Exception e) {}

        // total users
        ps = con.prepareStatement("SELECT COUNT(*) FROM USERS");
        rs = ps.executeQuery();
        if (rs.next()) totalUsers = rs.getInt(1);
        try { rs.close(); } catch (Exception e) {}
        try { ps.close(); } catch (Exception e) {}

        // approved adoptions
        ps = con.prepareStatement("SELECT COUNT(*) FROM ADOPTIONS WHERE UPPER(STATUS)='APPROVED'");
        rs = ps.executeQuery();
        if (rs.next()) approvedAdoptions = rs.getInt(1);
        try { rs.close(); } catch (Exception e) {}
        try { ps.close(); } catch (Exception e) {}

        // pending articles
        ps = con.prepareStatement("SELECT COUNT(*) FROM ARTICLES WHERE UPPER(STATUS)='PENDING'");
        rs = ps.executeQuery();
        if (rs.next()) pendingArticles = rs.getInt(1);
        try { rs.close(); } catch (Exception e) {}
        try { ps.close(); } catch (Exception e) {}

        // pending adoptions
        ps = con.prepareStatement("SELECT COUNT(*) FROM ADOPTIONS WHERE UPPER(STATUS)='PENDING'");
        rs = ps.executeQuery();
        if (rs.next()) pendingAdoptions = rs.getInt(1);
        try { rs.close(); } catch (Exception e) {}
        try { ps.close(); } catch (Exception e) {}

        pendingApprovals = pendingArticles + pendingAdoptions;

        try { rs.close(); } catch (Exception e) {}
        try { ps.close(); } catch (Exception e) {}

    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        try { if (rs != null) rs.close(); } catch (Exception e) {}
        try { if (ps != null) ps.close(); } catch (Exception e) {}
        try { if (con != null) con.close(); } catch (Exception e) {}
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard - Ariniqo Buddies</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Nunito:wght@400;600;700;800&family=Poppins:wght@300;400;500;600&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="<%= ctx %>/css/admin-style.css">
</head>
<body class="admin-dashboard">

    <header class="dashboard-header">
        <div class="header-content">
            <h1>Admin Dashboard</h1>
            <p>Manage your pet adoption platform with ease and efficiency</p>
        </div>
        <div class="admin-info">
            <div class="admin-avatar">
                <i class="fas fa-user-shield"></i>
            </div>
            <div class="admin-details">
                <h3><%= adminName %></h3>
                <p>Full Access</p>
            </div>
            <a href="<%= ctx %>/logout" class="logout-btn">
                <i class="fas fa-sign-out-alt"></i>
                Logout
            </a>
        </div>
    </header>

    <div class="stats-container">
        <div class="stat-card stat-1">
            <div class="stat-content">
                <div class="stat-icon"><i class="fas fa-paw"></i></div>
                <div class="stat-numbers">
                    <h2><%= totalPets %></h2>
                    <p>Total Pets</p>
                    <div class="stat-trend trend-up">
                        <i class="fas fa-arrow-up"></i>
                        <span>Live DB</span>
                    </div>
                </div>
            </div>
        </div>

        <div class="stat-card stat-2">
            <div class="stat-content">
                <div class="stat-icon"><i class="fas fa-users"></i></div>
                <div class="stat-numbers">
                    <h2><%= totalUsers %></h2>
                    <p>Registered Users</p>
                    <div class="stat-trend trend-up">
                        <i class="fas fa-arrow-up"></i>
                        <span>Live DB</span>
                    </div>
                </div>
            </div>
        </div>

        <div class="stat-card stat-3">
            <div class="stat-content">
                <div class="stat-icon"><i class="fas fa-heart"></i></div>
                <div class="stat-numbers">
                    <h2><%= approvedAdoptions %></h2>
                    <p>Successful Adoptions</p>
                    <div class="stat-trend trend-up">
                        <i class="fas fa-arrow-up"></i>
                        <span>Approved</span>
                    </div>
                </div>
            </div>
        </div>

        <div class="stat-card stat-4">
            <div class="stat-content">
                <div class="stat-icon"><i class="fas fa-clock"></i></div>
                <div class="stat-numbers">
                    <h2><%= pendingApprovals %></h2>
                    <p>Pending Approvals</p>
                    <div class="stat-trend trend-down">
                        <i class="fas fa-exclamation-circle"></i>
                        <span>Articles + Adoptions</span>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div class="management-grid">

        <section class="section-card articles-card">
            <h2 class="articles-title">
                <i class="fas fa-newspaper"></i>
                Articles Management
            </h2>
            <div class="articles-grid">
                <a href="<%= ctx %>/admin/articles" class="article-btn">
                    <div class="article-icon"><i class="fas fa-eye"></i></div>
                    <p class="article-text">View Articles</p>
                </a>
            </div>
        </section>

        <section class="section-card adoption-card-section">
            <h2 class="adoption-title">
                <i class="fas fa-paw"></i>
                Pet Management
            </h2>
            <div class="adoption-grid">
                <a href="<%= ctx %>/admin/pets" class="adoption-btn">
                    <div class="adoption-icon"><i class="fas fa-list"></i></div>
                    <p class="adoption-text">View Pet List</p>
                </a>

                <a href="<%= ctx %>/admin/add-pet.jsp" class="adoption-btn">
                    <div class="adoption-icon"><i class="fas fa-plus-circle"></i></div>
                    <p class="adoption-text">Add New Pet</p>
                </a>
            </div>
        </section>

        <section class="section-card lostfound-card">
            <h2 class="lostfound-title">
                <i class="fas fa-heart"></i>
                Adoption Management
            </h2>
            <div class="lostfound-grid">
                <a href="<%= ctx %>/admin/adoptions" class="lostfound-btn">
                    <div class="lostfound-icon"><i class="fas fa-list"></i></div>
                    <p class="lostfound-text">View Adoption Requests</p>
                </a>

                <a href="<%= ctx %>/admin/adoption-reports" class="lostfound-btn">
                    <div class="lostfound-icon"><i class="fas fa-chart-line"></i></div>
                    <p class="lostfound-text">Adoption Reports</p>
                </a>
            </div>
        </section>

        <section class="section-card users-card">
            <h2 class="users-title">
                <i class="fas fa-search"></i>
                Lost & Found
            </h2>
            <div class="users-grid">
                <a href="<%= ctx %>/admin/all-reports" class="user-btn">
                    <div class="user-icon"><i class="fas fa-list"></i></div>
                    <p class="user-text">View Reports</p>
                </a>
            </div>
        </section>
    </div>

<section class="section-card users-card">
    <h2 class="users-title">
        <i class="fas fa-users-cog"></i>
        User Management
    </h2>
    <div class="users-grid">
        <a href="<%= ctx %>/admin/users" class="user-btn">
            <div class="user-icon"><i class="fas fa-list"></i></div>
            <p class="user-text">View Users</p>
        </a>
    </div>
</section>

    <script>
        function animateCounter(element, target, duration) {
            if (!duration) duration = 1000;
            var start = 0;
            var increment = target / (duration / 16);
            var timer = setInterval(function() {
                start += increment;
                if (start >= target) {
                    element.textContent = target;
                    clearInterval(timer);
                } else {
                    element.textContent = Math.floor(start);
                }
            }, 16);
        }

        document.addEventListener('DOMContentLoaded', function() {
            var stats = document.querySelectorAll('.stat-numbers h2');
            for (var i = 0; i < stats.length; i++) {
                (function(stat) {
                    var target = parseInt(stat.textContent, 10);
                    stat.textContent = '0';
                    setTimeout(function() { animateCounter(stat, target); }, 300);
                })(stats[i]);
            }

            var buttons = document.querySelectorAll('.article-btn, .adoption-btn, .lostfound-btn, .user-btn, .user-management-btn');
            for (var j = 0; j < buttons.length; j++) {
                buttons[j].addEventListener('mouseenter', function() { this.style.transform = 'translateY(-5px)'; });
                buttons[j].addEventListener('mouseleave', function() { this.style.transform = 'translateY(0)'; });
            }
        });
    </script>
</body>
</html>
