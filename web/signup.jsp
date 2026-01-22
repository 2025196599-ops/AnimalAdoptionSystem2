<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    String ctx = request.getContextPath();
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Create Account - Ariniqo Buddies</title>

    <link rel="stylesheet" href="<%= ctx %>/css/login-style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Space+Grotesk:wght@300;400;500;600;700;800&family=Poppins:wght@300;400;500;600&family=Nunito:wght@400;600;700;800&display=swap" rel="stylesheet">
</head>
<body>

<div class="signup-container">

    <div class="brand-header">
        <a href="<%= ctx %>/index.jsp" class="brand-logo">
            <i class="fas fa-paw"></i>
            Ariniqo Buddies
        </a>
        <p class="brand-tagline">Join our pet adoption community</p>
    </div>

    <div class="signup-header">
        <h2><i class="fas fa-user-plus"></i> Create Account</h2>
        <p>Fill in your details to get started</p>
    </div>

    <% if (request.getAttribute("error") != null) { %>
        <div style="background: rgba(255, 126, 95, 0.1); padding: 12px 15px; border-radius: 8px; border: 1px solid #ff7e5f; margin: 10px 0; display: flex; align-items: center; gap: 10px; color: #ff7e5f; font-size: 14px;">
            <i class="fas fa-exclamation-circle"></i>
            <span><%= request.getAttribute("error") %></span>
        </div>
    <% } %>

    <form id="signupForm" method="post" action="<%= ctx %>/register">
        <input type="hidden" id="role" name="role" value="user">

        <div class="form-row">
            <div class="form-group">
                <label for="firstName"><i class="fas fa-user"></i> First Name</label>
                <input type="text" id="firstName" name="firstName" class="form-control" placeholder="John" required>
            </div>

            <div class="form-group">
                <label for="lastName"><i class="fas fa-user"></i> Last Name</label>
                <input type="text" id="lastName" name="lastName" class="form-control" placeholder="Doe" required>
            </div>
        </div>

        <div class="form-group">
            <label for="email"><i class="fas fa-envelope"></i> Email Address</label>
            <input type="email" id="email" name="email" class="form-control" placeholder="your.email@example.com" required>
        </div>

        <div class="form-row">
            <div class="form-group">
                <label for="password"><i class="fas fa-lock"></i> Password</label>
                <div class="password-wrapper">
                    <input type="password" id="password" name="password" class="form-control" required>
                    <button type="button" class="password-toggle"><i class="fas fa-eye"></i></button>
                </div>
            </div>

            <div class="form-group">
                <label for="confirmPassword"><i class="fas fa-lock"></i> Confirm Password</label>
                <div class="password-wrapper">
                    <input type="password" id="confirmPassword" class="form-control" required>
                    <button type="button" class="password-toggle"><i class="fas fa-eye"></i></button>
                </div>
            </div>
        </div>

        <div class="terms-checkbox">
            <input type="checkbox" id="terms" required>
            <label for="terms">
                I agree to the <a href="#">Terms of Service</a> and <a href="#">Privacy Policy</a>.
            </label>
        </div>

        <button type="submit" class="btn-submit">
            <i class="fas fa-user-plus"></i> Create Account
        </button>
    </form>

    <div class="link-container">
        Already have an account? <a href="<%= ctx %>/login.jsp">Sign in here</a>
    </div>

</div>

<script>
document.querySelectorAll('.password-toggle').forEach(function(btn) {
    btn.addEventListener('click', function() {
        var input = this.parentNode.querySelector('input');
        var icon = this.querySelector('i');
        if (input.type === 'password') {
            input.type = 'text';
            icon.classList.remove('fa-eye');
            icon.classList.add('fa-eye-slash');
        } else {
            input.type = 'password';
            icon.classList.remove('fa-eye-slash');
            icon.classList.add('fa-eye');
        }
    });
});

document.getElementById('signupForm').addEventListener('submit', function(e) {
    var pwd = document.getElementById('password').value;
    var cp  = document.getElementById('confirmPassword').value;

    if (pwd.length < 8 || !/[A-Z]/.test(pwd) || !/[0-9]/.test(pwd)) {
        e.preventDefault();
        alert('Password must be at least 8 characters, include one uppercase letter and one number.');
        return;
    }

    if (pwd !== cp) {
        e.preventDefault();
        alert('Passwords do not match.');
    }
});
</script>

</body>
</html>
