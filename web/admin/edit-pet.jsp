<%-- 
    Document   : edit-pet
    Created on : Jan 18, 2026, 3:30:55 PM
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
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Admin - Edit Pet</title>
    <link rel="stylesheet" href="<%= ctx %>/css/admin-style.css" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body>
    <div class="edit-pet-container">
        <header class="edit-page-header">
            <div class="header-content">
                <h1><i class="fas fa-edit"></i> Edit Pet Information</h1>
                <p>Update the pet's information. Fields marked with * are required.</p>
            </div>
            <a href="<%= ctx %>/admin/pets" class="back-btn">
                <i class="fas fa-arrow-left"></i> Back to Pet List
            </a>
        </header>

        <main class="main-content">
            <div class="form-container">
                <section class="form-section">
                    <div class="form-header">
                        <h2><i class="fas fa-paw"></i> Edit Pet Details</h2>
                        <p>Make changes to the pet's information below</p>
                    </div>

                    <div class="required-note">
                        <i class="fas fa-asterisk" style="color: #ef4444;"></i>
                        <span style="color: #ef4444;">Indicates required field</span>
                    </div>

                    <form action="<%= ctx %>/admin/pets/update" method="POST" enctype="multipart/form-data" class="pet-form" id="editPetForm">
                        <input type="hidden" name="id" value="<%= pet.getPetId() %>">

                        <div class="form-grid">
                            <div class="form-group">
                                <label for="petName"><i class="fas fa-dog"></i> Pet Name</label>
                                <input type="text" id="petName" name="petName" value="<%= pet.getName() %>" required placeholder="Enter pet's name">
                                <div class="form-error"><i class="fas fa-exclamation-circle"></i> Pet name is required</div>
                            </div>

                            <div class="form-group">
                                <label for="petType"><i class="fas fa-cat"></i> Pet Type</label>
                                <select id="petType" name="petType" required>
                                    <option value="">Select Type</option>
                                    <option value="dog" <%= "dog".equalsIgnoreCase(pet.getType()) ? "selected" : "" %>>Dog</option>
                                    <option value="cat" <%= "cat".equalsIgnoreCase(pet.getType()) ? "selected" : "" %>>Cat</option>
                                    <option value="bird" <%= "bird".equalsIgnoreCase(pet.getType()) ? "selected" : "" %>>Bird</option>
                                    <option value="rabbit" <%= "rabbit".equalsIgnoreCase(pet.getType()) ? "selected" : "" %>>Rabbit</option>
                                    <option value="other" <%= "other".equalsIgnoreCase(pet.getType()) ? "selected" : "" %>>Other</option>
                                </select>
                                <div class="form-error"><i class="fas fa-exclamation-circle"></i> Please select a pet type</div>
                            </div>

                            <div class="form-group">
                                <label for="breed"><i class="fas fa-dna"></i> Breed</label>
                                <input type="text" id="breed" name="breed" value="<%= (pet.getBreed()!=null?pet.getBreed():"") %>" required placeholder="Enter breed">
                                <div class="form-error"><i class="fas fa-exclamation-circle"></i> Breed is required</div>
                            </div>

                            <div class="form-group">
                                <label for="age"><i class="fas fa-birthday-cake"></i> Age (years)</label>
                                <input type="number" id="age" name="age" value="<%= pet.getAge() %>" min="0" step="1" required placeholder="0">
                                <div class="form-error"><i class="fas fa-exclamation-circle"></i> Please enter a valid age</div>
                            </div>

                            <div class="form-group full-width">
                                <label for="description"><i class="fas fa-file-alt"></i> Description</label>
                                <textarea id="description" name="description" required placeholder="Describe the pet..."><%= (pet.getDescription()!=null?pet.getDescription():"") %></textarea>
                                <div class="form-error"><i class="fas fa-exclamation-circle"></i> Description is required</div>
                            </div>

                            <div class="form-group">
                                <label for="petImage"><i class="fas fa-camera"></i> Change Pet Image</label>
                                <input type="file" id="petImage" name="petImage" accept="image/*">
                                <div class="form-hint"><i class="fas fa-lightbulb"></i> Optional: Upload a new photo</div>
                            </div>

                            <div class="form-group">
                                <label for="status"><i class="fas fa-home"></i> Adoption Status</label>
                                <select id="status" name="status" required>
                                    <option value="AVAILABLE" <%= "AVAILABLE".equalsIgnoreCase(pet.getStatus()) ? "selected" : "" %>>Available</option>
                                    <option value="PENDING" <%= "PENDING".equalsIgnoreCase(pet.getStatus()) ? "selected" : "" %>>Pending</option>
                                    <option value="ADOPTED" <%= "ADOPTED".equalsIgnoreCase(pet.getStatus()) ? "selected" : "" %>>Adopted</option>
                                </select>
                                <div class="form-error"><i class="fas fa-exclamation-circle"></i> Please select adoption status</div>
                            </div>
                        </div>

                        <div class="form-actions">
                            <button type="submit" class="btn btn-primary">
                                <i class="fas fa-save"></i> Update Pet
                            </button>
                            <a href="<%= ctx %>/admin/pets" class="btn btn-secondary">
                                <i class="fas fa-times"></i> Cancel
                            </a>
                        </div>
                    </form>
                </section>
            </div>
        </main>
    </div>
</body>
</html>
