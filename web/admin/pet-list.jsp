<%-- 
    Document   : pet-list
    Created on : Jan 18, 2026, 3:30:19 PM
    Author     : User
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*" %>
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

    List<Pet> pets = (List<Pet>) request.getAttribute("pets");
    if (pets == null) pets = new ArrayList<Pet>();
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Pet Management - Ariniqo Buddies</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Nunito:wght@400;600;700;800&family=Poppins:wght@300;400;500;600&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="<%= ctx %>/css/admin-style.css">
</head>
<body class="pet-management-container">

    <header class="pet-management-header">
        <div>
            <h1>Pet Management</h1>
            <p>Manage all pets in the adoption system. Add, edit, or remove pets as needed.</p>
        </div>
        <div class="header-actions">
            <a href="<%= ctx %>/admin/add-pet.jsp" class="action-btn btn-primary">
                <i class="fas fa-plus-circle"></i> Add New Pet
            </a>
            <a href="<%= ctx %>/admin/dashboard.jsp" class="action-btn btn-success">
                <i class="fas fa-arrow-left"></i> Back to Dashboard
            </a>
        </div>
    </header>

    <section class="pets-table-container">
        <div class="table-header">
            <h2 class="table-title">All Pets</h2>
            <div class="total-pets">
                <i class="fas fa-paw"></i>
                Total: <%= pets.size() %> Pets
            </div>
        </div>

        <table class="pets-table">
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Pet</th>
                    <th>Type</th>
                    <th>Breed</th>
                    <th>Age</th>
                    <th>Status</th>
                    <th>Actions</th>
                </tr>
            </thead>

            <tbody>
            <% if (pets.isEmpty()) { %>
                <tr>
                    <td colspan="7" style="text-align:center; padding:30px;">
                        No pets found.
                    </td>
                </tr>
            <% } else { %>
                <% for (Pet p : pets) { 
                       String status = (p.getStatus() == null || p.getStatus().trim().isEmpty()) ? "AVAILABLE" : p.getStatus();
                %>
                    <tr>
                        <td>PET<%= String.format("%03d", p.getPetId()) %></td>

                        <td>
                            <div style="display: flex; align-items: center; gap: 12px;">
                                <div style="width: 40px; height: 40px; border-radius: 10px; background: linear-gradient(135deg, #667eea, #764ba2); display: flex; align-items: center; justify-content: center; color: white;">
                                    <i class="fas fa-paw"></i>
                                </div>
                                <div>
                                    <div style="font-weight: 600; color: #2d3436;"><%= p.getName() %></div>
                                    <div style="font-size: 12px; color: #94a3b8;"><%= (p.getBreed() != null ? p.getBreed() : "") %></div>
                                </div>
                            </div>
                        </td>

                        <td><%= (p.getType() != null ? p.getType() : "") %></td>
                        <td><%= (p.getBreed() != null ? p.getBreed() : "") %></td>
                        <td><%= p.getAge() %></td>
                        <td>
                            <span class="status-badge status-available"><%= status %></span>
                        </td>

                        <td>
                            <div class="action-buttons">
                                <a href="<%= ctx %>/admin/view-pet.jsp?id=<%= p.getPetId() %>" class="action-btn btn-view">
                                    <i class="fas fa-eye"></i> View
                                </a>
                                <a href="<%= ctx %>/admin/edit-pet.jsp?id=<%= p.getPetId() %>" class="action-btn btn-edit">
                                    <i class="fas fa-edit"></i> Edit
                                </a>

                                <form action="<%= ctx %>/admin/pets/delete" method="post" style="display:inline;">
                                    <input type="hidden" name="id" value="<%= p.getPetId() %>">
                                    <button class="action-btn btn-delete" type="submit"
                                            onclick="return confirm('Are you sure you want to delete this pet?');">
                                        <i class="fas fa-trash"></i> Delete
                                    </button>
                                </form>
                            </div>
                        </td>
                    </tr>
                <% } %>
            <% } %>
            </tbody>
        </table>
    </section>
</body>
</html>
