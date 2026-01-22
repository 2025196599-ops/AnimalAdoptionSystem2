<%-- 
    Document   : view-pet
    Created on : Jan 18, 2026, 3:30:37 PM
    Author     : User
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.ariniqo.dao.PetDAO" %>
<%@ page import="com.ariniqo.model.Pet" %>
<%@ page import="com.ariniqo.model.User" %>

<%
    String ctx = request.getContextPath();

    // ✅ BASIC ADMIN GUARD
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect(ctx + "/login.jsp");
        return;
    }

    String idStr = request.getParameter("id");
    int id = -1;
    try { id = Integer.parseInt(idStr); } catch (Exception ignore) {}

    Pet pet = (id > 0) ? new PetDAO().getById(id) : null;
    if (pet == null) {
        response.sendRedirect(ctx + "/admin/pets");
        return;
    }

    String imgPath = pet.getImagePath();
    String img = (imgPath != null && !imgPath.trim().isEmpty())
            ? (imgPath.startsWith("/") ? (ctx + imgPath) : (ctx + "/" + imgPath))
            : "https://images.unsplash.com/photo-1552053831-71594a27632d?ixlib=rb-4.0.3&auto=format&fit=crop&w=600&q=80";

    String status = (pet.getStatus() == null || pet.getStatus().trim().isEmpty()) ? "AVAILABLE" : pet.getStatus();
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Admin - View Pet Details</title>
    <link rel="stylesheet" href="<%= ctx %>/css/admin-style.css" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body>
    <div class="view-pet-container">
        <header class="pet-view-header">
            <div class="header-content">
                <h1><i class="fas fa-eye"></i> Pet Details</h1>
                <p>View detailed information about the selected pet</p>
            </div>
            <a href="<%= ctx %>/admin/pets" class="back-btn">
                <i class="fas fa-arrow-left"></i> Back to Pet List
            </a>
        </header>

        <main class="main-content">
            <div class="pet-details-container">
                <div class="pet-image-section">
                    <div class="pet-image-main">
                        <img src="<%= img %>" alt="<%= pet.getName() %>">
                    </div>

                    <div class="meta-info">
                        <span class="pet-id-badge">
                            <i class="fas fa-fingerprint"></i> ID: PET-<%= String.format("%06d", pet.getPetId()) %>
                        </span>
                        <span class="last-updated">
                            <i class="far fa-clock"></i> Updated: -
                        </span>
                    </div>
                </div>

                <div class="pet-info-section">
                    <div class="pet-basic-info">
                        <div class="pet-name-section">
                            <div>
                                <h1 class="pet-name"><%= pet.getName() %></h1>
                                <span class="pet-type-badge">
                                    <i class="fas fa-paw"></i> <%= (pet.getType() != null ? pet.getType() : "") %>
                                </span>
                            </div>
                            <div class="status-badge status-available">
                                <i class="fas fa-circle"></i> <%= status %>
                            </div>
                        </div>

                        <div class="info-grid">
                            <div class="info-item">
                                <span class="info-label"><i class="fas fa-dna"></i> Breed</span>
                                <span class="info-value"><%= (pet.getBreed() != null ? pet.getBreed() : "") %></span>
                            </div>

                            <div class="info-item">
                                <span class="info-label"><i class="fas fa-birthday-cake"></i> Age</span>
                                <span class="info-value"><%= pet.getAge() %></span>
                            </div>

                            <div class="info-item">
                                <span class="info-label"><i class="fas fa-file-alt"></i> Description</span>
                                <span class="info-value"><%= (pet.getDescription() != null ? "Yes" : "No") %></span>
                            </div>
                        </div>
                    </div>

                    <div class="description-section">
                        <h3 class="section-title"><i class="fas fa-file-alt"></i> Description</h3>
                        <div class="description-content"><%= (pet.getDescription() != null ? pet.getDescription() : "") %></div>
                    </div>

                    <div class="action-buttons">
                        <a href="<%= ctx %>/admin/edit-pet.jsp?id=<%= pet.getPetId() %>" class="btn btn-primary">
                            <i class="fas fa-edit"></i> Edit Pet
                        </a>

                        <form action="<%= ctx %>/admin/pets/delete" method="post" style="display:inline;">
                            <input type="hidden" name="id" value="<%= pet.getPetId() %>">
                            <button type="submit" class="btn btn-danger"
                                    onclick="return confirm('Are you sure you want to delete this pet?');">
                                <i class="fas fa-trash"></i> Delete Pet
                            </button>
                        </form>
                    </div>
                </div>
            </div>
        </main>
    </div>
</body>
</html>
