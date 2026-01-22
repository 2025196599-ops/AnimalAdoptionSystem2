<%-- 
    Document   : add-pet.jsp
    Created on : Jan 18, 2026, 3:15:55 PM
    Author     : User
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.ariniqo.model.User" %>

<%
    String ctx = request.getContextPath();

    // ✅ BASIC ADMIN GUARD
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect(ctx + "/login.jsp");
        return;
    }

    boolean success =
            "1".equals(request.getParameter("success")) ||
            "1".equals(request.getParameter("added"));

    boolean error = "1".equals(request.getParameter("error"));
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Admin - Add New Pet</title>
    <link rel="stylesheet" href="<%= ctx %>/css/admin-style.css" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body>
    <div class="add-pet-container">
        <header class="page-header">
            <div class="header-content">
                <h1><i class="fas fa-paw"></i> Add New Pet</h1>
                <p>Fill in the pet's information below. All fields marked with * are required.</p>
            </div>

            <a href="<%= ctx %>/admin/pets" class="back-btn">
                <i class="fas fa-arrow-left"></i> Back to Pet List
            </a>
        </header>

        <main class="main-content">

            <% if (error) { %>
            <div class="form-success active" style="border-color:#ef4444; color:#ef4444;">
                <i class="fas fa-exclamation-circle"></i>
                <p>Failed to add pet. Please fill in required fields and try again.</p>
            </div>
            <% } else if (success) { %>
            <div class="form-success active">
                <i class="fas fa-check-circle"></i>
                <p>Pet added successfully! Redirecting to pet list...</p>
            </div>

            <script>
                setTimeout(function(){
                    window.location.href = '<%= ctx %>/admin/pets';
                }, 1200);
            </script>

            <% } else { %>
            <div class="form-success">
                <i class="fas fa-check-circle"></i>
                <p>Pet added successfully! Redirecting to pet list...</p>
            </div>
            <% } %>

            <div class="form-container">
                <section class="form-section">
                    <div class="form-header">
                        <h2><i class="fas fa-info-circle"></i> Pet Information</h2>
                        <p>Enter the basic details about the pet</p>
                    </div>

                    <div class="required-note">
                        <i class="fas fa-asterisk"></i> Indicates required field
                    </div>

                    <form action="<%= ctx %>/admin/pets/add" method="POST" enctype="multipart/form-data" class="pet-form" id="addPetForm">
                        <div class="form-grid">
                            <div class="form-group">
                                <label for="petName">
                                    <i class="fas fa-dog"></i> Pet Name
                                </label>
                                <input type="text" id="petName" name="petName" required placeholder="Enter pet's name">
                            </div>

                            <div class="form-group">
                                <label for="petType">
                                    <i class="fas fa-cat"></i> Pet Type
                                </label>
                                <select id="petType" name="petType" required>
                                    <option value="">Select Type</option>
                                    <option value="dog">Dog</option>
                                    <option value="cat">Cat</option>
                                    <option value="bird">Bird</option>
                                    <option value="rabbit">Rabbit</option>
                                    <option value="other">Other</option>
                                </select>
                            </div>

                            <div class="form-group">
                                <label for="breed">
                                    <i class="fas fa-dna"></i> Breed
                                </label>
                                <input type="text" id="breed" name="breed" required placeholder="Enter breed">
                            </div>

                            <div class="form-group">
                                <label for="age">
                                    <i class="fas fa-birthday-cake"></i> Age (years)
                                </label>
                                <!-- If your DB AGE is INT, set step="1" -->
                                <input type="number" id="age" name="age" min="0" step="1" required placeholder="0">
                            </div>

                            <div class="form-group full-width">
                                <label for="description">
                                    <i class="fas fa-file-alt"></i> Description
                                </label>
                                <textarea id="description" name="description" required placeholder="Describe the pet..."></textarea>
                            </div>

                            <div class="form-group">
                                <label for="petImage">
                                    <i class="fas fa-camera"></i> Pet Image
                                </label>
                                <input type="file" id="petImage" name="petImage" accept="image/*" required>
                                <div class="file-preview" id="imagePreview">
                                    <img src="" alt="Image Preview">
                                    <p>Image Preview</p>
                                </div>
                            </div>

                            <div class="form-group">
                                <label for="status">
                                    <i class="fas fa-home"></i> Adoption Status
                                </label>
                                <!-- ✅ FIX: uppercase to match DB -->
                                <select id="status" name="status" required>
                                    <option value="AVAILABLE">Available</option>
                                    <option value="PENDING">Pending</option>
                                    <option value="ADOPTED">Adopted</option>
                                </select>
                            </div>
                        </div>

                        <div class="form-actions">
                            <button type="submit" class="btn btn-primary">
                                <i class="fas fa-plus-circle"></i> Add Pet
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

    <script>
        var imageInput = document.getElementById('petImage');
        var imagePreview = document.getElementById('imagePreview');

        if (imageInput) {
            imageInput.addEventListener('change', function() {
                var file = this.files[0];
                if (file) {
                    var reader = new FileReader();
                    reader.addEventListener('load', function() {
                        imagePreview.querySelector('img').src = reader.result;
                        imagePreview.classList.add('active');
                    });
                    reader.readAsDataURL(file);
                } else {
                    imagePreview.classList.remove('active');
                }
            });
        }
    </script>
</body>
</html>
