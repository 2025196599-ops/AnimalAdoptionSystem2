package com.ariniqo.model;

public class User {
    private int userId;
    private String name;
    private String email;
    private String role;

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getRole() {
        return role;
    }

    public void setRole(String role) {
        this.role = role;
    }

    /* ===============================
       ✅ HELPER METHODS (IMPORTANT)
       =============================== */

    public boolean isAdmin() {
        return role != null && role.equalsIgnoreCase("ADMIN");
    }

    public boolean isUser() {
        return role != null && role.equalsIgnoreCase("USER");
    }
}
