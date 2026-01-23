<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*" %>

<%
    String ctx = request.getContextPath();

    List adoptions = (List) request.getAttribute("adoptions");
    if (adoptions == null) adoptions = new ArrayList();
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <title>My Adoption Status - Ariniqo Buddies</title>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />

    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Nunito:wght@400;600;700;800&family=Poppins:wght@300;400;500;600&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="<%= ctx %>/css/user-style.css">
</head>
<body>

<jsp:include page="/user/user-navBar.jsp" />

<main class="main-content">
    <div class="container">

        <h1 class="page-title"><i class="fas fa-heart"></i> My Adoption Status</h1>

        <% if (adoptions.isEmpty()) { %>
            <div style="background:#fff; padding:30px; border-radius:16px; box-shadow:var(--shadow-light); text-align:center; color:var(--text-light); width:100%; max-width:900px;">
                <i class="fas fa-file-alt" style="font-size:50px; color:#ddd;"></i>
                <h3 style="margin-top:10px; color:var(--dark);">No Adoption Applications Yet</h3>
                <p style="margin:0;">Apply for adoption from a pet details page.</p>
                <div style="margin-top:18px;">
                    <a href="<%= ctx %>/pets?ui=user" class="btn btn-primary" style="text-decoration:none;">
                        <i class="fas fa-search"></i> Browse Pets
                    </a>
                </div>
            </div>
        <% } else { %>

        <div class="pet-grid">
            <%
                for (int i = 0; i < adoptions.size(); i++) {
                    Map a = (Map) adoptions.get(i);

                    String status = (a.get("status") == null ? "PENDING" : a.get("status").toString().trim());
                    String petName = (a.get("petName") == null ? "" : a.get("petName").toString());
                    String petType = (a.get("petType") == null ? "" : a.get("petType").toString());
                    String petBreed = (a.get("petBreed") == null ? "" : a.get("petBreed").toString());

                    Object petIdObj = a.get("petId");
                    int petId = 0;
                    if (petIdObj instanceof Number) petId = ((Number) petIdObj).intValue();

                    String petImg = (a.get("petImage") == null ? "" : a.get("petImage").toString().trim());

                    // ✅ same image rules you use elsewhere
                    String imgSrc;
                    if (petImg.length() == 0) {
                        imgSrc = ctx + "/images/pet1.jpg";
                    } else if (petImg.startsWith("http://") || petImg.startsWith("https://")) {
                        imgSrc = petImg;
                    } else if (petImg.startsWith("uploads/") || petImg.startsWith("/uploads/") || petImg.indexOf("/") < 0) {
                        // uploads/... OR filename-only => UploadViewServlet
                        imgSrc = ctx + "/file?path=" + java.net.URLEncoder.encode(petImg, "UTF-8");
                    } else {
                        imgSrc = petImg.startsWith("/") ? (ctx + petImg) : (ctx + "/" + petImg);
                    }

                    String badgeClass = "status-pending";
                    if ("APPROVED".equalsIgnoreCase(status)) badgeClass = "status-available";
                    else if ("REJECTED".equalsIgnoreCase(status)) badgeClass = "status-unavailable";
            %>

            <div class="pet-card">
                <img src="<%= imgSrc %>" class="pet-card-image" alt="<%= petName %>"
                     onerror="this.src='<%= ctx %>/images/pet1.jpg'">

                <div class="pet-card-body">
                    <h3 class="pet-card-title"><%= petName %></h3>

                    <div class="pet-card-info">
                        Type: <%= petType %> |
                        Breed: <%= (petBreed != null && petBreed.trim().length() > 0 ? petBreed : "-") %>
                    </div>

                    <div class="pet-card-status <%= badgeClass %>">
                        <%= status %>
                    </div>

                    <a href="<%= ctx %>/pet?id=<%= petId %>&ui=user" class="btn btn-primary" style="text-decoration:none;">
                        <i class="fas fa-eye"></i> View Pet
                    </a>
                </div>
            </div>

            <%
                } // end for
            %>
        </div>

        <% } %>

    </div>
</main>

<jsp:include page="/user/user-footer.jsp" />
</body>
</html>
