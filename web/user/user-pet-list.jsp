<%-- 
    Document   : user-pet-list
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.ariniqo.model.Pet" %>
<%
    String ctx = request.getContextPath();
    List<Pet> pets = (List<Pet>) request.getAttribute("pets");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <title>Ariniqo Buddies - Pet Listing</title>
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
        <h1 class="page-title">Available Pets for Adoption</h1>

        <div class="pet-grid">
            <%
                if (pets == null || pets.isEmpty()) {
            %>
                <div style="width:100%; text-align:center; color:var(--text-light); padding:30px;">
                    No pets found in database yet.
                </div>
            <%
                } else {
                    for (int i=0; i<pets.size(); i++) {
                        Pet p = pets.get(i);

                        String imgPath = (p.getImagePath() == null ? "" : p.getImagePath().trim());
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

                        String status = (p.getStatus() == null || p.getStatus().trim().isEmpty()) ? "AVAILABLE" : p.getStatus();
            %>
            <div class="pet-card">
                <img src="<%= imgUrl %>" alt="<%= p.getName() %>" class="pet-card-image"
                     onerror="this.src='<%= ctx %>/images/pet1.jpg'" />
                <div class="pet-card-body">
                    <h3 class="pet-card-title"><%= p.getName() %></h3>
                    <div class="pet-card-info">
                        Type: <%= (p.getType() != null ? p.getType() : "") %> |
                        Breed: <%= (p.getBreed() != null ? p.getBreed() : "") %> |
                        Age: <%= p.getAge() %> years
                    </div>
                    <div class="pet-card-status status-available"><%= status %></div>

                    <a class="btn btn-primary" href="<%= ctx %>/pet?id=<%= p.getPetId() %>&ui=user" style="text-decoration:none;">
                        <i class="fas fa-eye"></i> View Details
                    </a>
                </div>
            </div>
            <%
                    }
                }
            %>
        </div>
    </div>
</main>

<jsp:include page="/user/user-footer.jsp" />
</body>
</html>
