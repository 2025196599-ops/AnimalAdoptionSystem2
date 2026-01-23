<%-- 
    Document   : user-navBar
    Created on : Jan 18, 2026
    Author     : User
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.ariniqo.model.User" %>
<%
    String ctx = request.getContextPath();
    User user = (User) session.getAttribute("user");
    boolean isLoggedIn = (user != null);

    String userName = (user != null && user.getName() != null && !user.getName().trim().isEmpty())
            ? user.getName()
            : "User";
%>

<header class="header">
  <div class="container">
    <a href="<%= ctx %>/pets?ui=user&dashboard=1" class="logo">
      <i class="fas fa-paw"></i>
      <span>Ariniqo Buddies</span>
    </a>

    <div class="nav-container" style="display: flex; align-items: center; width: 100%; margin-top: 2%; gap: 20px;">

      <!-- Navigation buttons in the middle -->
      <div class="feature-buttons" style="flex: 1; display: flex; justify-content: center; gap: 15px;">
        <a href="<%= ctx %>/pets?ui=user&dashboard=1" class="feature-btn">
          <i class="fas fa-home"></i> Home
        </a>

        <a href="<%= ctx %>/pets?ui=user" class="feature-btn">
          <i class="fas fa-paw"></i> Pet Listing
        </a>

        <a href="<%= ctx %>/user/adoption-status" class="feature-btn">
          <i class="fas fa-heart"></i> Adoption
        </a>

        <!-- ✅ ADD: Lost & Found on desktop (was missing) -->
        <a href="<%= ctx %>/user/user-lost-found.jsp" class="feature-btn">
          <i class="fas fa-search"></i> Lost &amp; Found
        </a>

        <a href="<%= ctx %>/articles?ui=user" class="feature-btn">
          <i class="fas fa-newspaper"></i> Articles
        </a>


      </div>

      <!-- Login/Signup or User/Logout on the right -->
      <div class="user-actions" style="display: flex; gap: 10px;">
        <% if (!isLoggedIn) { %>
          <a href="<%= ctx %>/login.jsp" class="login-btn">
            <i class="fas fa-sign-in-alt"></i> Login
          </a>
          <a href="<%= ctx %>/signup.jsp" class="signup-btn">
            <i class="fas fa-user-plus"></i> Sign Up
          </a>
        <% } else { %>
          <a href="<%= ctx %>/pets?ui=user&dashboard=1" class="login-btn">
            <i class="fas fa-user"></i> <%= userName %>
          </a>
          <a href="<%= ctx %>/logout" class="signup-btn">
            <i class="fas fa-sign-out-alt"></i> Logout
          </a>
        <% } %>
      </div>

    </div>
  </div>
</header>

<div class="feature-buttons-mobile">
    <a href="<%= ctx %>/pets?ui=user&dashboard=1" class="feature-btn">
        <i class="fas fa-home"></i>
        <span>Home</span>
    </a>

    <a href="<%= ctx %>/pets?ui=user" class="feature-btn">
        <i class="fas fa-paw"></i>
        <span>Pet Listing</span>
    </a>

    <!-- ✅ FIX: same as desktop -->
    <a href="<%= ctx %>/pets?ui=user" class="feature-btn">
        <i class="fas fa-heart"></i>
        <span>Adoption</span>
    </a>

    <a href="<%= ctx %>/user/user-lost-found.jsp" class="feature-btn">
        <i class="fas fa-search"></i>
        <span>Lost &amp; Found</span>
    </a>

    <a href="<%= ctx %>/articles?ui=user" class="feature-btn">
        <i class="fas fa-newspaper"></i>
        <span>Articles</span>
    </a>

        <!-- ✅ FIX: Adoption Status page -->
    <a href="<%= ctx %>/user/adoption-status" class="feature-btn">
        <i class="fas fa-heart"></i>
        <span>Adoption</span>
    </a>

</div>

        
        