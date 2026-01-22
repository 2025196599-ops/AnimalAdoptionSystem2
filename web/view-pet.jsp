<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.ariniqo.model.Pet" %>
<%@ page import="com.ariniqo.model.User" %>
<%
    String ctx = request.getContextPath();
    Pet pet = (Pet) request.getAttribute("pet");
    User user = (User) session.getAttribute("user");
    boolean isLoggedIn = (user != null);

    if (pet == null) {
        response.sendRedirect(ctx + "/pets");
        return;
    }

    String img = (pet.getImagePath() == null || pet.getImagePath().trim().length() == 0)
            ? (ctx + "/images/pet1.jpg")
            : (pet.getImagePath().startsWith("/") ? (ctx + pet.getImagePath()) : (ctx + "/" + pet.getImagePath()));

    String statusText = (pet.getStatus() == null || pet.getStatus().trim().length() == 0)
            ? "AVAILABLE"
            : pet.getStatus();
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Ariniqo Buddies - View Pet Details</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Nunito:wght@400;600;700;800&family=Poppins:wght@300;400;500;600&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="<%= ctx %>/css/user-style.css">
</head>
<body>

<jsp:include page="/navBar.jsp" />

<main class="main-content">
    <div class="container">

        <% if (request.getParameter("applied") != null) { %>
            <div style="margin: 10px 0; color: #41d8bf; font-weight: 700;">
                Adoption application submitted (Pending).
            </div>
        <% } %>

        <div class="pet-detail-container">
            <div class="pet-detail-card">
                <div class="pet-image-container">
                    <img src="<%= img %>" alt="<%= pet.getName() %>" class="pet-detail-image" />
                </div>

                <div class="pet-info-container">
                    <div class="pet-status status-available"><%= statusText %></div>
                    <h1 class="pet-name"><%= pet.getName() %></h1>
                    <div class="pet-breed">
                        <i class="fas fa-paw"></i>
                        <%= pet.getType() %> | <%= (pet.getBreed()==null ? "-" : pet.getBreed()) %>
                    </div>

                    <div class="pet-details-grid">
                        <div class="pet-detail-item">
                            <div class="pet-detail-label"><i class="fas fa-birthday-cake"></i> Age</div>
                            <div class="pet-detail-value"><%= pet.getAge() %> years old</div>
                        </div>
                    </div>

                    <div class="pet-description-section">
                        <h3 class="section-title"><i class="fas fa-info-circle"></i> About</h3>
                        <div class="pet-description">
                            <%= (pet.getDescription()==null ? "No description yet." : pet.getDescription()) %>
                        </div>
                    </div>

                    <div class="action-buttons">
                        <% if (isLoggedIn) { %>
                            <form method="post" action="<%= ctx %>/adopt" style="margin:0;">
                                <input type="hidden" name="petId" value="<%= pet.getPetId() %>"/>
                                <button class="adoption-link" type="submit">
                                    <i class="fas fa-heart"></i> Apply to Adopt
                                </button>
                            </form>
                        <% } else { %>
                            <a class="adoption-link" href="<%= ctx %>/login.jsp">
                                <i class="fas fa-lock"></i> Login to Apply
                            </a>
                        <% } %>

                        <div class="back-link-container">
                            <a href="<%= ctx %>/pets" class="back-link">
                                <i class="fas fa-arrow-left"></i> Back to Pet Listing
                            </a>
                        </div>
                    </div>

                </div>
            </div>
        </div>

    </div>
</main>

<jsp:include page="/footer.jsp" />

</body>
</html>
