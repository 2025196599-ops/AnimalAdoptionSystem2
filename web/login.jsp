<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    String ctx = request.getContextPath();
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login - Ariniqo Buddies</title>
    <link rel="stylesheet" href="<%= ctx %>/css/login-style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Space+Grotesk:wght@300;400;500;600;700;800&family=Poppins:wght@300;400;500;600&family=Nunito:wght@400;600;700;800&display=swap" rel="stylesheet">
</head>
<body>
    <div class="login-container">
        <div class="brand-header">
            <a href="<%= ctx %>/index.jsp" class="brand-logo">
                <i class="fas fa-paw"></i>
                Ariniqo Buddies
            </a>
            <p class="brand-tagline">Pet Adoption Platform - Secure Login</p>
        </div>

        <div class="login-header">
            <h2><i class="fas fa-sign-in-alt"></i> Login</h2>
            <p>Select your role and enter your credentials</p>
        </div>

        <% if (request.getParameter("registered") != null) { %>
            <div style="background: rgba(65, 216, 191, 0.1); padding: 12px 15px; border-radius: 8px; border: 1px solid #41d8bf; margin: 10px 0; display: flex; align-items: center; gap: 10px; color: #41d8bf; font-size: 14px;">
                <i class="fas fa-check-circle"></i>
                <span>Account created successfully. Please login.</span>
            </div>
        <% } %>

        <% if (request.getAttribute("error") != null) { %>
            <div style="background: rgba(255, 126, 95, 0.1); padding: 12px 15px; border-radius: 8px; border: 1px solid #ff7e5f; margin: 10px 0; display: flex; align-items: center; gap: 10px; color: #ff7e5f; font-size: 14px;">
                <i class="fas fa-exclamation-circle"></i>
                <span><%= request.getAttribute("error") %></span>
            </div>
        <% } %>

        <form id="loginForm" method="post" action="<%= ctx %>/login">
            <div class="role-selection">
                <label for="role">
                    <i class="fas fa-user-tag"></i> Select Role
                </label>
                <div class="role-options">
                    <div class="role-option admin selected" data-role="admin">
                        <i class="fas fa-user-shield"></i>
                        <span>Admin</span>
                    </div>
                    <div class="role-option user" data-role="user">
                        <i class="fas fa-user"></i>
                        <span>User</span>
                    </div>
                </div>
                <input type="hidden" id="role" name="role" value="admin" class="role-input">
            </div>

            <div class="form-group">
                <label for="email">
                    <i class="fas fa-envelope"></i> Email Address
                </label>
                <input type="email" id="email" name="email" class="form-control" placeholder="Enter your email" required>
            </div>

            <div class="form-group">
                <label for="password">
                    <i class="fas fa-lock"></i> Password
                </label>
                <div class="password-wrapper">
                    <input type="password" id="password" name="password" class="form-control" placeholder="Enter your password" required>
                    <button type="button" class="password-toggle">
                        <i class="fas fa-eye"></i>
                    </button>
                </div>
            </div>

            <div class="form-options">
                <label class="remember-me">
                    <input type="checkbox" id="remember" name="remember"> Remember me
                </label>
                <a href="#" class="forgot-password">Forgot Password?</a>
            </div>

            <button type="submit" class="btn-submit">
                <i class="fas fa-sign-in-alt"></i> Sign In
            </button>
        </form>

        <div class="link-container">
            Need an account? <a href="<%= ctx %>/signup.jsp">Create Account</a>
        </div>
    </div>

    <script>
        document.querySelectorAll('.role-option').forEach(function(option) {
            option.addEventListener('click', function() {
                document.querySelectorAll('.role-option').forEach(function(opt) {
                    opt.classList.remove('selected');
                });
                this.classList.add('selected');
                var role = this.getAttribute('data-role');
                document.getElementById('role').value = role;
            });
        });

        document.querySelector('.password-toggle').addEventListener('click', function() {
            var passwordInput = document.getElementById('password');
            var icon = this.querySelector('i');

            if (passwordInput.type === 'password') {
                passwordInput.type = 'text';
                icon.classList.remove('fa-eye');
                icon.classList.add('fa-eye-slash');
            } else {
                passwordInput.type = 'password';
                icon.classList.remove('fa-eye-slash');
                icon.classList.add('fa-eye');
            }
        });

        document.querySelector('.forgot-password').addEventListener('click', function(e) {
            e.preventDefault();
            alert('Password reset feature will be added later.');
        });
    </script>
</body>
</html>
