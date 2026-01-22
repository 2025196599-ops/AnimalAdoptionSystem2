<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ page import="com.ariniqo.util.DBConnection" %>
<%@ page import="com.ariniqo.model.User" %>

<%
    String ctx = request.getContextPath();

    // ✅ guard: user must be logged in for this dashboard
    User u = (User) session.getAttribute("user");
    if (u == null) {
        response.sendRedirect(ctx + "/login.jsp");
        return;
    }

    // ✅ Load featured pets from DB (AVAILABLE)
    List<Map> featuredPets = new ArrayList<Map>();

    Connection con = null;
    PreparedStatement ps = null;
    ResultSet rs = null;

    try {
        con = DBConnection.getConnection();

        String sql =
            "SELECT PET_ID, NAME, TYPE, BREED, AGE, STATUS, DESCRIPTION, IMAGE_PATH " +
            "FROM PETS " +
            "WHERE STATUS IS NULL OR TRIM(STATUS)='' OR UPPER(STATUS)='AVAILABLE' " +
            "ORDER BY PET_ID DESC";

        ps = con.prepareStatement(sql);
        rs = ps.executeQuery();

        while (rs.next() && featuredPets.size() < 3) {
            Map m = new HashMap();
            m.put("petId", rs.getInt("PET_ID"));
            m.put("name", rs.getString("NAME"));
            m.put("type", rs.getString("TYPE"));
            m.put("breed", rs.getString("BREED"));
            m.put("age", rs.getInt("AGE"));
            m.put("status", rs.getString("STATUS"));
            m.put("description", rs.getString("DESCRIPTION"));
            m.put("imagePath", rs.getString("IMAGE_PATH"));
            featuredPets.add(m);
        }

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
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>Ariniqo Buddies - User Dashboard</title>
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
  <link href="https://fonts.googleapis.com/css2?family=Nunito:wght@400;600;700;800&family=Poppins:wght@300;400;500;600&display=swap" rel="stylesheet">
  <link rel="stylesheet" href="<%= ctx %>/css/user-style.css">
</head>

<body>

<jsp:include page="/user/user-navBar.jsp" />

<section class="hero">
    <div class="container">
        <div class="hero-stats">
            <div class="stat-box homeless">
                <span class="stat-number">32,120</span>
                <span class="stat-label">Homeless</span>
            </div>
            <div class="stat-box happy">
                <span class="stat-number">83,957</span>
                <span class="stat-label">Happy</span>
            </div>
        </div>

        <div class="hero-content">
            <h1 class="hero-title">Welcome to Your <span>Dashboard</span>!</h1>
            <p class="hero-subtitle">Browse pets, track your adoption applications, and help animals in need.</p>

            <div style="margin-top: 30px; display: flex; justify-content: center; gap: 20px; flex-wrap: wrap;">
                <a href="<%= ctx %>/pets?ui=user" class="btn btn-primary">
                    <i class="fas fa-search"></i> Browse Pets
                </a>

                <a href="<%= ctx %>/pets?ui=user" class="btn btn-success">
                    <i class="fas fa-heart"></i> Start Adoption
                </a>

                <a href="<%= ctx %>/user/user-lost-found.jsp" class="btn btn-primary">
                    <i class="fas fa-search"></i> Lost &amp; Found
                </a>
            </div>
        </div>
    </div>
</section>

<main class="main-content">
    <div class="container">
        <h2 class="page-title">Featured Pets Looking for Homes</h2>

        <div class="dashboard-cards">

            <%
                if (featuredPets.isEmpty()) {
            %>
                <div style="width:100%; text-align:center; color:var(--text-light); padding:30px;">
                    No available pets in database yet.
                </div>
            <%
                } else {
                    for (int i=0; i<featuredPets.size(); i++) {
                        Map p = featuredPets.get(i);

                        int petId = ((Integer)p.get("petId")).intValue();
                        String name = (p.get("name") == null ? "Pet" : p.get("name").toString());
                        String type = (p.get("type") == null ? "" : p.get("type").toString());
                        String breed = (p.get("breed") == null ? "" : p.get("breed").toString());
                        int age = 0;
                        try { age = ((Integer)p.get("age")).intValue(); } catch (Exception ignore) {}

                        String desc = (p.get("description") == null ? "" : p.get("description").toString());
                        if (desc.length() > 120) desc = desc.substring(0, 120) + "...";

                        String statusText = (p.get("status") == null || p.get("status").toString().trim().length()==0)
                                ? "AVAILABLE"
                                : p.get("status").toString();

                        String icon = "fa-dog";
                        if ("cat".equalsIgnoreCase(type)) icon = "fa-cat";

                        String imgPath = (p.get("imagePath") == null ? "" : p.get("imagePath").toString().trim());
                        String imgUrl;

                        if (imgPath.length() == 0) {
                            imgUrl = ctx + "/images/pet1.jpg";
                        } else if (imgPath.startsWith("http://") || imgPath.startsWith("https://")) {
                            imgUrl = imgPath;
                        } else if (imgPath.startsWith("uploads/") || imgPath.startsWith("/uploads/")) {
                            imgUrl = ctx + "/file?path=" + java.net.URLEncoder.encode(imgPath, "UTF-8");
                        } else {
                            imgUrl = imgPath.startsWith("/") ? (ctx + imgPath) : (ctx + "/" + imgPath);
                        }
            %>

            <!-- ✅ Logged in user: go to real pet detail -->
            <a href="<%= ctx %>/pet?id=<%= petId %>&ui=user" class="dashboard-card pets">
                <div class="card-header">
                    <div class="card-icon">
                        <i class="fas <%= icon %>"></i>
                    </div>
                    <h3 class="card-title"><%= name %><%= (breed.length()==0 ? "" : " - " + breed) %></h3>
                </div>

                <div style="width:100%; margin: 10px 0 14px;">
                    <img src="<%= imgUrl %>" alt="<%= name %>"
                         style="width:100%; height:180px; object-fit:cover; border-radius:12px;"
                         onerror="this.src='<%= ctx %>/images/pet1.jpg'">
                </div>

                <p style="color: var(--text-light); margin-bottom: 15px;">
                    <%= (desc.length()==0 ? "View pet details and apply for adoption." : desc) %>
                </p>

                <div class="card-stats">
                    <div class="stat-item">
                        <span class="stat-number"><%= age %></span>
                        <span class="stat-label"><%= (age == 1 ? "Year Old" : "Years Old") %></span>
                    </div>
                    <div class="stat-item">
                        <span class="stat-label"><%= statusText %></span>
                    </div>
                </div>
            </a>

            <%
                    }
                }
            %>

        </div>
    </div>
</main>

<jsp:include page="/user/user-footer.jsp" />

<script>
document.addEventListener('DOMContentLoaded', function() {
    function animateNumbers() {
        var homelessNumber = document.querySelector('.homeless .stat-number');
        var happyNumber = document.querySelector('.happy .stat-number');

        if (homelessNumber && happyNumber) {
            var homelessCount = 0;
            var happyCount = 0;
            var homelessTarget = 32120;
            var happyTarget = 83957;
            var increment = 100;

            var timer = setInterval(function() {
                homelessCount += increment;
                happyCount += increment * 2;

                if (homelessCount >= homelessTarget) homelessCount = homelessTarget;
                if (happyCount >= happyTarget) happyCount = happyTarget;

                homelessNumber.textContent = homelessCount.toLocaleString();
                happyNumber.textContent = happyCount.toLocaleString();

                if (homelessCount >= homelessTarget && happyCount >= happyTarget) {
                    clearInterval(timer);
                }
            }, 20);
        }
    }

    setTimeout(animateNumbers, 500);
});
</script>

</body>
</html>
