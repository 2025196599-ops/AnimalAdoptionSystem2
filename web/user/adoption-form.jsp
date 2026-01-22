<%-- 
    Document   : adoption-form
    Created on : Jan 18, 2026
    Author     : User
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%@ page import="javax.servlet.http.HttpSession" %>
<%@ page import="com.ariniqo.model.User" %>

<%@ page import="com.ariniqo.dao.PetDAO" %>
<%@ page import="com.ariniqo.model.Pet" %>

<%
    String ctx = request.getContextPath();

    // =========================
    // Logged-in user (optional)
    // =========================
    HttpSession s = request.getSession(false);
    User user = (s == null) ? null : (User) s.getAttribute("user");

    String userName  = (user != null && user.getName() != null) ? user.getName() : "";
    String userEmail = (user != null && user.getEmail() != null) ? user.getEmail() : "";

    // =========================
    // Get petId from URL
    // =========================
    String petIdFromUrl = request.getParameter("petId");

    // minimal safety: if opened without petId, go back
    if (petIdFromUrl == null || petIdFromUrl.trim().isEmpty()) {
        response.sendRedirect(ctx + "/pets?ui=user");
        return;
    }

    int petId = 0;
    try {
        petId = Integer.parseInt(petIdFromUrl.trim());
    } catch (Exception e) {
        response.sendRedirect(ctx + "/pets?ui=user");
        return;
    }

    // =========================
    // Load pet from DB
    // =========================
    Pet selectedPet = new PetDAO().getById(petId);
    if (selectedPet == null) {
        response.sendRedirect(ctx + "/pets?ui=user");
        return;
    }

    String dbPetName  = (selectedPet.getName() != null) ? selectedPet.getName().trim() : "";
    String dbPetType  = (selectedPet.getType() != null) ? selectedPet.getType().trim() : "";
    String dbPetBreed = (selectedPet.getBreed() != null) ? selectedPet.getBreed().trim() : "";
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <title>Ariniqo Buddies - Adoption Form</title>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />

    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Nunito:wght@400;600;700;800&family=Poppins:wght@300;400;500;600&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="<%= ctx %>/css/user-style.css">
    <link rel="stylesheet" href="<%= ctx %>/css/adoption-form.css">
</head>
<body>

<jsp:include page="/user/user-navBar.jsp" />

<main class="main-content">
    <div class="container">
        <div class="form-section">

            <div class="form-header">
                <h1 class="form-title"><i class="fas fa-heart"></i> Adoption Application Form</h1>
                <p class="form-subtitle">
                    Thank you for your interest in adopting a pet! Please fill out this form completely.
                </p>
            </div>

            <div class="form-container">

                <!-- ✅ ui=user included -->
                <form id="adoptionForm" action="<%= ctx %>/adopt?ui=user" method="post">

                    <!-- ===================== -->
                    <!-- PERSONAL INFORMATION -->
                    <!-- ===================== -->
                    <div class="form-section-header">
                        <h2><i class="fas fa-user"></i> Personal Information</h2>
                    </div>

                    <div class="form-grid">
                        <div class="form-group">
                            <label class="required">Full Name</label>
                            <input type="text" name="fullName" required
                                   value="<%= userName %>" <%= userName.isEmpty() ? "" : "readonly" %>>
                        </div>

                        <div class="form-group">
                            <label class="required">Email Address</label>
                            <input type="email" name="email" required
                                   value="<%= userEmail %>" <%= userEmail.isEmpty() ? "" : "readonly" %>>
                        </div>

                        <div class="form-group">
                            <label class="required">Phone Number</label>
                            <input type="tel" name="phone" required>
                        </div>

                        <div class="form-group">
                            <label class="required">Home Address</label>
                            <textarea name="address" rows="3" required></textarea>
                        </div>
                    </div>

                    <!-- ===================== -->
                    <!-- PET INFORMATION (FROM DB) -->
                    <!-- ===================== -->
                    <div class="form-section-header">
                        <h2><i class="fas fa-paw"></i> Pet Information</h2>
                    </div>

                    <div class="form-grid">
                        <div class="form-group">
                            <label class="required">Pet ID</label>
                            <input type="text" value="<%= petId %>" readonly>
                            <!-- ✅ Required by AdoptServlet -->
                            <input type="hidden" name="petId" value="<%= petId %>"/>
                        </div>

                        <div class="form-group">
                            <label class="required">Pet Name</label>
                            <input type="text" value="<%= dbPetName %>" readonly>
                            <!-- optional: send to servlet (but servlet should still verify by petId) -->
                            <input type="hidden" name="petName" value="<%= dbPetName %>">
                        </div>

                        <div class="form-group">
                            <label class="required">Pet Type</label>
                            <input type="text" value="<%= dbPetType %>" readonly>
                            <input type="hidden" name="petType" value="<%= dbPetType %>">
                        </div>

                        <div class="form-group">
                            <label>Breed</label>
                            <input type="text" value="<%= dbPetBreed %>" readonly>
                            <input type="hidden" name="breed" value="<%= dbPetBreed %>">
                        </div>
                    </div>

                    <!-- ===================== -->
                    <!-- LIVING SITUATION -->
                    <!-- ===================== -->
                    <div class="form-section-header">
                        <h2><i class="fas fa-home"></i> Living Situation</h2>
                    </div>

                    <div class="form-grid">
                        <div class="form-group">
                            <label class="required">Housing Type</label>
                            <select name="houseType" required>
                                <option value="">Select</option>
                                <option value="apartment">Apartment</option>
                                <option value="terrace">Terrace</option>
                                <option value="bungalow">Bungalow</option>
                                <option value="condo">Condo</option>
                            </select>
                        </div>

                        <div class="form-group">
                            <label class="required">Pet Experience</label>
                            <select name="experience" required>
                                <option value="">Select</option>
                                <option value="none">None</option>
                                <option value="some">Some</option>
                                <option value="experienced">Experienced</option>
                            </select>
                        </div>
                    </div>

                    <!-- ===================== -->
                    <!-- REASON -->
                    <!-- ===================== -->
                    <div class="form-section-header">
                        <h2><i class="fas fa-comment"></i> Reason for Adoption</h2>
                    </div>

                    <div class="form-group">
                        <textarea name="reason" rows="4" required></textarea>
                    </div>

                    <!-- ===================== -->
                    <!-- AGREEMENT -->
                    <!-- ===================== -->
                    <div class="form-group">
                        <label>
                            <input type="checkbox" name="agree" required>
                            I agree to provide lifelong care
                        </label>
                    </div>

                    <!-- ===================== -->
                    <!-- ACTIONS -->
                    <!-- ===================== -->
                    <div class="form-actions">
                        <button type="submit" class="btn-submit">
                            <i class="fas fa-paper-plane"></i> Submit Application
                        </button>

                        <a href="<%= ctx %>/pets?ui=user" class="btn-cancel">
                            <i class="fas fa-times"></i> Cancel
                        </a>
                    </div>

                </form>

            </div>
        </div>
    </div>
</main>

<jsp:include page="/user/user-footer.jsp" />

</body>
</html>