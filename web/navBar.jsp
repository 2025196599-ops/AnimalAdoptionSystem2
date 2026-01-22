<%-- 
    Document   : navBar
    Created on : Jan 19, 2026, 1:03:44 AM
    Author     : User
--%>

<%
    String ctx = request.getContextPath();
%>

<header class="header">
  <div class="container">
    <a href="<%= ctx %>/index.jsp" class="logo">
      <i class="fas fa-paw"></i>
      <span>Ariniqo Buddies</span>
    </a>

    <!-- Feature Buttons (Desktop) -->
    <div class="nav-container" style="display: flex; align-items: center; width: 100%; margin-top: 2%; gap: 20px;">

      <!-- Navigation buttons in the middle -->
      <div class="feature-buttons" style="flex: 1; display: flex; justify-content: center; gap: 15px;">
        <a href="<%= ctx %>/index.jsp" class="feature-btn">
          <i class="fas fa-home"></i> Home
        </a>

        <!-- servlet -->
        <a href="<%= ctx %>/pets" class="feature-btn">
          <i class="fas fa-paw"></i> Pet Listing
        </a>

        <!-- reuse pet listing until separate adoption page -->
        <a href="<%= ctx %>/pets" class="feature-btn">
          <i class="fas fa-heart"></i> Adoption
        </a>

        <!-- Use servlet so approved articles are loaded from DB -->
        <a href="<%= ctx %>/articles" class="feature-btn">
          <i class="fas fa-newspaper"></i> Articles
        </a>
      </div>

      <!-- Login/Signup on the right -->
      <div class="user-actions" style="display: flex; gap: 10px;">
        <a href="<%= ctx %>/login.jsp" class="login-btn">
          <i class="fas fa-sign-in-alt"></i> Login
        </a>
        <a href="<%= ctx %>/signup.jsp" class="signup-btn">
          <i class="fas fa-user-plus"></i> Sign Up
        </a>
      </div>

    </div>
  </div>
</header>
