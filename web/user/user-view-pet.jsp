<%-- 
    Document   : user-view-pet
    Updated on : Jan 2026
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.ariniqo.model.Pet" %>
<%@ page import="com.ariniqo.model.User" %>
<%@ page import="com.ariniqo.dao.AdoptionDAO" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.net.URLEncoder" %>

<%
    String ctx = request.getContextPath();
    Pet pet = (Pet) request.getAttribute("pet");

    if (pet == null) {
        response.sendRedirect(ctx + "/pets?ui=user");
        return;
    }

    // logged in user
    User user = (User) session.getAttribute("user");
    boolean loggedIn = (user != null);

    int petId = pet.getPetId();

    String petName   = (pet.getName() != null) ? pet.getName().trim() : "";
    String petType   = (pet.getType() != null) ? pet.getType().trim() : "";
    String petBreed  = (pet.getBreed() != null) ? pet.getBreed().trim() : "";
    int petAge       = pet.getAge();
    String petStatus = (pet.getStatus() != null) ? pet.getStatus().trim() : "";
    String petDesc   = (pet.getDescription() != null) ? pet.getDescription().trim() : "";

    String imagePath = (pet.getImagePath() != null) ? pet.getImagePath().trim() : "";

    // ✅ image: support filename / uploads/... / images/... / http(s)
    String petImg;
    if (imagePath.length() == 0) {
        petImg = ctx + "/images/pet1.jpg";
    } else if (imagePath.startsWith("http://") || imagePath.startsWith("https://")) {
        petImg = imagePath;
    } else if (imagePath.startsWith("uploads/") || imagePath.startsWith("/uploads/")) {
        petImg = ctx + "/file?path=" + URLEncoder.encode(imagePath, "UTF-8");
    } else {
        // if DB stored ONLY filename, UploadViewServlet still supports it
        // but if it's a real web path like images/..., keep normal
        if (imagePath.indexOf("/") < 0) {
            petImg = ctx + "/file?path=" + java.net.URLEncoder.encode(imagePath, "UTF-8");
        } else {
            petImg = imagePath.startsWith("/") ? (ctx + imagePath) : (ctx + "/" + imagePath);
        }
    }

    String typeIcon = "fa-paw";
    if ("cat".equalsIgnoreCase(petType)) typeIcon = "fa-cat";
    else if ("dog".equalsIgnoreCase(petType)) typeIcon = "fa-dog";

    // ==========================================
    // ✅ Check current user's adoption status for this pet
    // ==========================================
    String myAdoptionStatus = "";   // PENDING / APPROVED / REJECTED / ""
    int myAdoptionId = 0;

    if (loggedIn) {
        try {
            List myList = new AdoptionDAO().listByUser(user.getUserId());
            for (int i = 0; i < myList.size(); i++) {
                Map row = (Map) myList.get(i);
  
                Number pid = (Number) row.get("petId");
                if (pid != null && pid.intValue() == petId) {
                    myAdoptionStatus = (row.get("status") == null) ? "" : row.get("status").toString().trim();
                    Number aid = (Number) row.get("adoptionId");
                    myAdoptionId = (aid == null) ? 0 : aid.intValue();
                    break;
                }
            }
        } catch (Exception ignore) {
            myAdoptionStatus = "";
            myAdoptionId = 0;
        }
    }

    String myUp = (myAdoptionStatus == null) ? "" : myAdoptionStatus.toUpperCase();
    String petUp = (petStatus == null) ? "" : petStatus.toUpperCase();

    boolean isAdopted = "ADOPTED".equals(petUp);
    boolean canApply = true;

    // if not logged in -> still show apply button (but link to login)
    // if already applied -> do not allow apply again
    if (loggedIn) {
        if ("PENDING".equals(myUp) || "APPROVED".equals(myUp)) {
            canApply = false;
        }
        // if pet is adopted and user is not approved -> block
        if (isAdopted && !"APPROVED".equals(myUp)) {
            canApply = false;
        }
        // if rejected, only allow reapply when pet still available
        if ("REJECTED".equals(myUp) && !("AVAILABLE".equals(petUp) || petUp.length() == 0)) {
            canApply = false;
        }
    }

    // badge for adoption status
    String badgeClass = "";
    String badgeText = "";
    String badgeIcon = "";

    if ("PENDING".equals(myUp)) { badgeClass="adopt-badge pending"; badgeText="PENDING"; badgeIcon="fa-clock"; }
    else if ("APPROVED".equals(myUp)) { badgeClass="adopt-badge approved"; badgeText="APPROVED"; badgeIcon="fa-check-circle"; }
    else if ("REJECTED".equals(myUp)) { badgeClass="adopt-badge rejected"; badgeText="REJECTED"; badgeIcon="fa-times-circle"; }
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

    <style>
        /* adoption status badge */
        .adopt-badge{
            display:inline-flex;
            align-items:center;
            gap:8px;
            padding:6px 12px;
            border-radius:999px;
            font-size:12px;
            font-weight:800;
            letter-spacing:.2px;
        }
        .adopt-badge.pending{ background: rgba(255, 179, 71, .18); color:#ff8a00; }
        .adopt-badge.approved{ background: rgba(65, 216, 191, .18); color:#1aa792; }
        .adopt-badge.rejected{ background: rgba(244, 67, 54, .14); color:#d32f2f; }

        .notice {
            margin-top: 14px;
            padding: 12px 14px;
            border-radius: 14px;
            background: #fff;
            box-shadow: var(--shadow-light);
            border: 1px solid var(--gray-border);
            color: var(--text-light);
            display:flex;
            align-items:center;
            gap:10px;
        }
        .notice.ok {
            border-color: rgba(65,216,191,.35);
            background: rgba(65,216,191,.08);
            color: #138b79;
        }
        .notice.warn {
            border-color: rgba(255,179,71,.45);
            background: rgba(255,179,71,.10);
            color: #b35b00;
        }
        .notice.err {
            border-color: rgba(244,67,54,.35);
            background: rgba(244,67,54,.08);
            color: #b71c1c;
        }

        /* disabled apply button look */
        .btn-disabled {
            opacity: .55;
            cursor: not-allowed;
            pointer-events: none;
        }
    </style>
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

                    <div style="display:flex; justify-content:space-between; align-items:flex-start; gap:12px; flex-wrap:wrap;">
                        <h1 class="pet-name" style="margin:0;"><%= (petName.length() > 0 ? petName : "-") %></h1>

                        <% if (loggedIn && myUp.length() > 0) { %>
                            <span class="<%= badgeClass %>">
                                <i class="fas <%= badgeIcon %>"></i> <%= badgeText %>
                            </span>
                        <% } %>
                    </div>

                    <div class="pet-breed">
                        <i class="fas <%= typeIcon %>"></i>
                        <%= (petBreed.length() > 0 ? petBreed : "-") %>
                        <%= (petType.length() > 0 ? (" • " + petType) : "") %>
                        • ID: PET-<%= String.format("%05d", petId) %>
                    </div>

                    <div class="pet-details-grid">
                        <div class="pet-detail-item">
                            <div class="pet-detail-label"><i class="fas fa-birthday-cake"></i> Age</div>
                            <div class="pet-detail-value"><%= petAge %> <%= (petAge == 1 ? "year" : "years") %></div>
                        </div>

                        <div class="pet-detail-item">
                            <div class="pet-detail-label"><i class="fas fa-info-circle"></i> Pet Status</div>
                            <div class="pet-detail-value"><%= (petStatus.length() > 0 ? petStatus : "-") %></div>
                        </div>
                    </div>

                    <div class="pet-description-section">
                        <h3 class="section-title"><i class="fas fa-align-left"></i> Description</h3>
                        <div class="pet-description"><%= (petDesc.length() > 0 ? petDesc : "-") %></div>
                    </div>

                    <!-- ✅ Notices about adoption -->
                    <% if (!loggedIn) { %>
                        <div class="notice warn">
                            <i class="fas fa-lock"></i>
                            Login is required to apply for adoption.
                        </div>
                    <% } else if ("PENDING".equals(myUp)) { %>
                        <div class="notice warn">
                            <i class="fas fa-clock"></i>
                            You already applied for this pet. Please wait for admin review.
                            <span style="margin-left:auto; font-weight:700;">AD-<%= myAdoptionId %></span>
                        </div>
                    <% } else if ("APPROVED".equals(myUp)) { %>
                        <div class="notice ok">
                            <i class="fas fa-check-circle"></i>
                            Your adoption is approved! You can check details in your adoption status page.
                            <span style="margin-left:auto; font-weight:700;">AD-<%= myAdoptionId %></span>
                        </div>
                    <% } else if ("REJECTED".equals(myUp)) { %>
                        <div class="notice err">
                            <i class="fas fa-times-circle"></i>
                            Your adoption request was rejected.
                            <span style="margin-left:auto; font-weight:700;">AD-<%= myAdoptionId %></span>
                        </div>
                    <% } else if (isAdopted) { %>
                        <div class="notice err">
                            <i class="fas fa-home"></i>
                            This pet has already been adopted.
                        </div>
                    <% } %>

                    <div class="action-buttons">

                        <% if (!loggedIn) { %>
                            <a href="<%= ctx %>/login.jsp" class="adoption-link">
                                <i class="fas fa-lock"></i> Login to Apply
                            </a>

                        <% } else if ("APPROVED".equals(myUp)) { %>
                            <a href="<%= ctx %>/user/adoption-status" class="adoption-link">
                                <i class="fas fa-heart"></i> View Adoption Status
                            </a>

                        <% } else if (canApply) { %>
                            <a href="<%= ctx %>/user/adoption-form.jsp?petId=<%= petId %>" class="adoption-link">
                                <i class="fas fa-heart"></i> Apply to Adopt
                            </a>

                        <% } else { %>
                            <a href="#" class="adoption-link btn-disabled">
                                <i class="fas fa-ban"></i> Cannot Apply
                            </a>
                        <% } %>

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
