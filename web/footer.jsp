<%-- 
    Document   : footer
    Created on : Jan 19, 2026, 1:00:31 AM
    Author     : User
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    String ctx = request.getContextPath();
%>

<footer class="footer">
    <div class="container">
        <div class="footer-content">
            <div class="footer-brand">
                <a href="<%= ctx %>/index.jsp" class="footer-logo">
                    <i class="fas fa-paw"></i>
                    <span>Ariniqo Buddies</span>
                </a>
                <p class="footer-tagline">
                    Connecting loving homes with animals in need since 2023.
                </p>
            </div>
        </div>

        <div class="footer-bottom">
            <p>&copy; 2024 Ariniqo Buddies Pet Adoption Platform. All rights reserved.</p>
        </div>
    </div>
</footer>
