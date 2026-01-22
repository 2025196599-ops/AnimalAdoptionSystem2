<%-- 
    Document   : user-view-pet
    Updated on : Jan 2026
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.ariniqo.model.Pet" %>

<%
    String ctx = request.getContextPath();
    Pet pet = (Pet) request.getAttribute("pet");

    if (pet == null) {
        response.sendRedirect(ctx + "/pets?ui=user");
        return;
    }

    int petId = pet.getPetId();

    String petName   = (pet.getName() != null) ? pet.getName().trim() : "";
    String petType   = (pet.getType() != null) ? pet.getType().trim() : "";
    String petBreed  = (pet.getBreed() != null) ? pet.getBreed().trim() : "";
    int petAge       = pet.getAge();
    String petStatus = (pet.getStatus() != null) ? pet.getStatus().trim() : "";
    String petDesc   = (pet.getDescription() != null) ? pet.getDescription().trim() : "";

    String imagePath = (pet.getImagePath() != null) ? pet.getImagePath().trim() : "";

    // ✅ FIXED: Support uploads/, images/, http(s)
    String petImg;
    if (imagePath.length() == 0) {
        petImg = ctx + "/images/pet1.jpg";
    } else if (imagePath.startsWith("http://") || imagePath.startsWith("https://")) {
        petImg = imagePath;
    } else if (imagePath.startsWith("uploads/") || imagePath.startsWith("/uploads/")) {
        // ✅ uploaded image -> serve via UploadViewServlet
        petImg = ctx + "/file?path=" + java.net.URLEncoder.encode(imagePath, "UTF-8");
    } else {
        // ✅ static file under web app, e.g. images/pet3.jpg
        petImg = imagePath.startsWith("/") ? (ctx + imagePath) : (ctx + "/" + imagePath);
    }

    String typeIcon = "fa-paw";
    if ("cat".equalsIgnoreCase(petType)) typeIcon = "fa-cat";
    else if ("dog".equalsIgnoreCase(petType)) typeIcon = "fa-dog";
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>View Pet Details</title>

    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Nunito:wght@400;600;700;800&family=Poppins:wght@300;400;500;600&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="<%= ctx %>/css/user-style.css">
</head>

<body>

<jsp:include page="/user/user-navBar.jsp" />

<main class="main-content">
    <div class="container">
        <div class="pet-detail-container">
            <div class="pet-detail-card">

                <div class="pet-image-container">
                    <img src="<%= petImg %>"
                         alt="<%= (petName.length() > 0 ? petName : "Pet") %>"
                         class="pet-detail-image"
                         onerror="this.src='<%= ctx %>/images/pet1.jpg';" />
                </div>

                <div class="pet-info-container">

                    <h1 class="pet-name"><%= (petName.length() > 0 ? petName : "-") %></h1>

                    <div class="pet-breed">
                        <i class="fas <%= typeIcon %>"></i>
                        <%= (petBreed.length() > 0 ? petBreed : "-") %>
                        <%= (petType.length() > 0 ? (" • " + petType) : "") %>
                        • ID: PET-<%= String.format("%05d", petId) %>
                    </div>

                    <div class="pet-details-grid">

                        <div class="pet-detail-item">
                            <div class="pet-detail-label">
                                <i class="fas fa-birthday-cake"></i> Age
                            </div>
                            <div class="pet-detail-value">
                                <%= petAge %> <%= (petAge == 1 ? "year" : "years") %>
                            </div>
                        </div>

                        <div class="pet-detail-item">
                            <div class="pet-detail-label">
                                <i class="fas fa-info-circle"></i> Status
                            </div>
                            <div class="pet-detail-value">
                                <%= (petStatus.length() > 0 ? petStatus : "-") %>
                            </div>
                        </div>

                    </div>

                    <div class="pet-description-section">
                        <h3 class="section-title">
                            <i class="fas fa-align-left"></i> Description
                        </h3>
                        <div class="pet-description">
                            <%= (petDesc.length() > 0 ? petDesc : "-") %>
                        </div>
                    </div>

                    <div class="action-buttons">
                        <a href="<%= ctx %>/user/adoption-form.jsp?petId=<%= petId %>" class="adoption-link">
                            <i class="fas fa-heart"></i> Apply to Adopt
                        </a>

                        <a href="<%= ctx %>/pets?ui=user" class="back-link">
                            <i class="fas fa-arrow-left"></i> Back to Pets
                        </a>
                    </div>

                </div>
            </div>
        </div>
    </div>
</main>

<jsp:include page="/user/user-footer.jsp" />

</body>
</html>
