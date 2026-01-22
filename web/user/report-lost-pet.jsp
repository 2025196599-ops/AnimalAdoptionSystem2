<%-- 
    Document   : report-lost-pet
    Created on : Jan 18, 2026
    Author     : User
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.ariniqo.model.User" %>
<%
    String ctx = request.getContextPath();

    User user = (User) session.getAttribute("user");
    boolean loggedIn = (user != null);

    String userName = (loggedIn && user.getName() != null) ? user.getName() : "";
    String userEmail = (loggedIn && user.getEmail() != null) ? user.getEmail() : "";
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <title>Ariniqo Buddies - Report Lost Pet</title>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Nunito:wght@400;600;700;800&family=Poppins:wght@300;400;500;600&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="<%= ctx %>/css/user-style.css">
    <link rel="stylesheet" href="<%= ctx %>/css/lost-found.css">
    <link rel="stylesheet" href="<%= ctx %>/css/report-forms.css">
</head>
<body>

<jsp:include page="/user/user-navBar.jsp" />

<main class="main-content">
    <div class="form-section">
        <div class="form-header">
            <h1 class="form-title">Report Lost Pet</h1>
            <p class="form-subtitle">Please provide as much detail as possible. All fields marked with * are required.</p>
        </div>

        <div class="form-container">
            <form id="lostPetForm" method="post" action="<%= ctx %>/reports/lost" enctype="multipart/form-data">

                <div class="form-section-header">
                    <h2><i class="fas fa-paw"></i> Pet Information</h2>
                </div>

                <div class="form-row">
                    <div class="form-group">
                        <label for="petName" class="required">Pet Name</label>
                        <input type="text" id="petName" name="petName" required placeholder="Enter pet's name">
                    </div>

                    <div class="form-group">
                        <label for="petType" class="required">Type of Animal</label>
                        <select id="petType" name="petType" required>
                            <option value="">Select animal type</option>
                            <option value="dog">Dog</option>
                            <option value="cat">Cat</option>
                            <option value="bird">Bird</option>
                            <option value="rabbit">Rabbit</option>
                            <option value="other">Other</option>
                        </select>
                    </div>
                </div>

                <div class="form-row">
                    <div class="form-group">
                        <label for="breed">Breed</label>
                        <input type="text" id="breed" name="breed" placeholder="e.g., Golden Retriever, Persian">
                    </div>

                    <div class="form-group">
                        <label for="age" class="required">Age</label>
                        <input type="text" id="age" name="age" required placeholder="e.g., 2 years old">
                    </div>
                </div>

                <div class="form-row">
                    <div class="form-group">
                        <label for="color" class="required">Color/Markings</label>
                        <input type="text" id="color" name="color" required placeholder="Describe pet's color and markings">
                    </div>

                    <div class="form-group">
                        <label for="gender" class="required">Gender</label>
                        <select id="gender" name="gender" required>
                            <option value="">Select gender</option>
                            <option value="male">Male</option>
                            <option value="female">Female</option>
                            <option value="unknown">Unknown</option>
                        </select>
                    </div>
                </div>

                <div class="form-section-header">
                    <h2><i class="fas fa-map-marker-alt"></i> Lost Information</h2>
                </div>

                <div class="form-row">
                    <div class="form-group">
                        <label for="lostDate" class="required">Date Lost</label>
                        <input type="date" id="lostDate" name="lostDate" required>
                    </div>

                    <div class="form-group">
                        <label for="lostTime" class="required">Approximate Time</label>
                        <input type="time" id="lostTime" name="lostTime" required>
                    </div>
                </div>

                <div class="form-group">
                    <label for="lostLocation" class="required">Location Lost</label>
                    <input type="text" id="lostLocation" name="lostLocation" required placeholder="Street, area, or landmark">
                </div>

                <div class="form-group">
                    <label for="city" class="required">City/Area</label>
                    <input type="text" id="city" name="city" required placeholder="e.g., Kuala Lumpur, Petaling Jaya">
                </div>

                <div class="form-section-header">
                    <h2><i class="fas fa-user"></i> Contact Information</h2>
                </div>

                <div class="form-row">
                    <div class="form-group">
                        <label for="ownerName" class="required">Your Name</label>
                        <input type="text" id="ownerName" name="ownerName" required value="<%= userName %>">
                    </div>

                    <div class="form-group">
                        <label for="phone" class="required">Phone Number</label>
                        <input type="tel" id="phone" name="phone" required placeholder="Enter your phone number">
                    </div>
                </div>

                <div class="form-row">
                    <div class="form-group">
                        <label for="email" class="required">Email Address</label>
                        <input type="email" id="email" name="email" required value="<%= userEmail %>">
                    </div>

                    <div class="form-group">
                        <label for="alternatePhone">Alternate Phone (Optional)</label>
                        <input type="tel" id="alternatePhone" name="alternatePhone" placeholder="Alternate contact number">
                    </div>
                </div>

                <div class="form-section-header">
                    <h2><i class="fas fa-info-circle"></i> Additional Information</h2>
                </div>

                <div class="form-group">
                    <label for="description" class="required">Description of Pet</label>
                    <textarea id="description" name="description" required></textarea>
                </div>

                <div class="form-group">
                    <label for="distinctiveFeatures" class="required">Distinctive Features</label>
                    <textarea id="distinctiveFeatures" name="distinctiveFeatures" required></textarea>
                </div>

                <div class="form-group">
                    <label for="collarDetails" class="optional">Collar/Tag Details</label>
                    <input type="text" id="collarDetails" name="collarDetails">
                </div>

                <div class="form-group">
                    <label for="reward" class="optional">Reward Offered (Optional)</label>
                    <input type="text" id="reward" name="reward" placeholder="e.g., RM500 reward">
                </div>

                <div class="form-section-header">
                    <h2><i class="fas fa-camera"></i> Pet Photo</h2>
                </div>

                <div class="form-group">
                    <label for="petPhoto" class="required">Upload Pet Photo</label>
                    <input type="file" id="petPhoto" name="petPhoto" accept="image/*" required>
                    <small class="form-help">Upload a clear photo of your pet (Max: 5MB, JPG/PNG)</small>
                </div>

                <div class="form-section-header">
                    <h2><i class="fas fa-check-circle"></i> Confirmation</h2>
                </div>

                <div class="form-group">
                    <div class="checkbox-group">
                        <input type="checkbox" id="consent" name="consent" required>
                        <label for="consent">I confirm the information provided is accurate and I allow sharing this report</label>
                    </div>
                </div>

                <div class="form-actions">
                    <button type="submit" class="btn-submit">
                        <i class="fas fa-paper-plane"></i> Submit Lost Pet Report
                    </button>
                    <a href="<%= ctx %>/user/user-lost-found.jsp" class="btn-cancel">
                        <i class="fas fa-times"></i> Cancel
                    </a>
                </div>
            </form>
        </div>
    </div>
</main>

<jsp:include page="/user/user-footer.jsp" />

<script>
var IS_LOGGED_IN = <%= loggedIn ? "true" : "false" %>;

document.getElementById('lostPetForm').addEventListener('submit', function(e) {
   if (!IS_LOGGED_IN) {
       e.preventDefault();
       alert('Please login to submit a lost pet report.');
       window.location.href = '<%= ctx %>/login.jsp';
       return;
   }
});

var today = new Date().toISOString().split('T')[0];
var lostDate = document.getElementById('lostDate');
if (lostDate) lostDate.max = today;
</script>
</body>
</html>
