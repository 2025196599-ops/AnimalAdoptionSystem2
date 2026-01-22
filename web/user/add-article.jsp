<%-- 
    Document   : add-article
    Created on : Jan 19, 2026, 1:19:16 PM
    Author     : User
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.ariniqo.model.User" %>
<%
    String ctx = request.getContextPath();
    User user = (User) session.getAttribute("user");

    String authorName = (user != null && user.getName() != null) ? user.getName() : "";
    String authorEmail = (user != null && user.getEmail() != null) ? user.getEmail() : "";
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Submit Article - Ariniqo Buddies</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Nunito:wght@400;600;700;800&family=Poppins:wght@300;400;500;600&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="<%= ctx %>/css/user-style.css">
    <style>
/* ==============================
   COLOR VARIABLES (ORANGE THEME)
================================ */
:root {
    --orange-main: #f97316;
    --orange-dark: #ea580c;
    --orange-soft: #fff7ed;
    --orange-glow: rgba(249, 115, 22, 0.35);
    --text-dark: #1f2937;
    --text-muted: #6b7280;
    --border-light: #e5e7eb;
}

/* ==============================
   PAGE BACKGROUND
================================ */
.main-content {
    background: linear-gradient(180deg, #fff7ed 0%, #f9fafb 100%);
    padding: 60px 0;
}

/* ==============================
   HEADER
================================ */
.form-header {
    text-align: center;
    margin-bottom: 55px;
}

.form-header h1 {
    font-family: 'Nunito', sans-serif;
    font-size: 2.6rem;
    font-weight: 900;
    color: var(--text-dark);
    letter-spacing: -0.4px;
}

.form-header h1 i {
    color: var(--orange-main);
}

.form-header p {
    margin-top: 14px;
    font-size: 1.05rem;
    color: var(--text-muted);
    max-width: 650px;
    margin-inline: auto;
    line-height: 1.75;
}

/* ==============================
   INFO NOTE
================================ */
.guest-info-note {
    max-width: 900px;
    margin: 0 auto 45px;
    padding: 26px 30px;
    border-radius: 16px;
    background: var(--orange-soft);
    border: 1px solid #fed7aa;
}

.guest-info-note h4 {
    font-family: 'Nunito', sans-serif;
    font-size: 1.1rem;
    font-weight: 800;
    color: var(--text-dark);
    display: flex;
    align-items: center;
    gap: 10px;
}

.guest-info-note h4 i {
    color: var(--orange-main);
}

.guest-info-note p {
    font-size: 0.95rem;
    color: var(--text-muted);
    line-height: 1.65;
}

/* ==============================
   FORM CARD
================================ */
.article-form-container {
    max-width: 900px;
    margin: 0 auto;
    padding: 52px;
    background: #ffffff;
    border-radius: 22px;
    border: 1px solid var(--border-light);
    box-shadow: 0 25px 55px rgba(0,0,0,0.08);
}

/* ==============================
   FORM GROUP
================================ */
.form-group {
    margin-bottom: 30px;
}

.form-group label {
    font-family: 'Poppins', sans-serif;
    font-size: 0.85rem;
    font-weight: 600;
    text-transform: uppercase;
    letter-spacing: 0.06em;
    color: #374151;
    margin-bottom: 8px;
    display: block;
}

.form-group label.required::after {
    content: " *";
    color: #ef4444;
}

/* ==============================
   INPUTS
================================ */
.form-group input,
.form-group select,
.form-group textarea {
    width: 100%;
    padding: 15px 18px;
    border-radius: 14px;
    border: 1.8px solid #d1d5db;
    background: #fffaf5;
    font-family: 'Poppins', sans-serif;
    font-size: 0.95rem;
    color: var(--text-dark);
    transition: all 0.25s ease;
}

.form-group textarea {
    min-height: 190px;
}

#content {
    min-height: 340px;
}

/* Focus */
.form-group input:focus,
.form-group select:focus,
.form-group textarea:focus {
    outline: none;
    background: #ffffff;
    border-color: var(--orange-main);
    box-shadow: 0 0 0 5px rgba(249,115,22,0.18);
}

/* ==============================
   HELP TEXT
================================ */
.form-help {
    margin-top: 6px;
    font-size: 0.78rem;
    color: var(--text-muted);
}

.form-help i {
    color: var(--orange-main);
}

/* ==============================
   ACTIONS
================================ */
.form-actions {
    display: flex;
    justify-content: center;
    gap: 22px;
    margin-top: 55px;
    padding-top: 30px;
    border-top: 1px dashed #fed7aa;
}

/* SUBMIT BUTTON */
.btn-submit {
    padding: 16px 52px;
    background: linear-gradient(135deg, var(--orange-main), var(--orange-dark));
    color: #ffffff;
    border-radius: 999px;
    border: none;
    font-size: 0.95rem;
    font-weight: 700;
    letter-spacing: 0.02em;
    display: inline-flex;
    align-items: center;
    gap: 10px;
    cursor: pointer;
    box-shadow: 0 18px 40px var(--orange-glow);
    transition: all 0.25s ease;
}

.btn-submit:hover {
    transform: translateY(-3px);
    box-shadow: 0 26px 60px rgba(249,115,22,0.55);
}

/* CANCEL */
.btn-cancel {
    padding: 16px 52px;
    border-radius: 999px;
    background: transparent;
    border: 1.8px solid #fed7aa;
    color: var(--orange-dark);
    font-size: 0.95rem;
    font-weight: 600;
    text-decoration: none;
    display: inline-flex;
    align-items: center;
    gap: 10px;
    transition: all 0.25s ease;
}

.btn-cancel:hover {
    background: var(--orange-soft);
    transform: translateY(-3px);
}

/* ==============================
   MOBILE
================================ */
@media (max-width: 768px) {
    .article-form-container {
        padding: 34px 26px;
    }

    .form-actions {
        flex-direction: column;
    }

    .btn-submit,
    .btn-cancel {
        width: 100%;
        justify-content: center;
    }
}
    </style>
</head>
<body>

<jsp:include page="/user/user-navBar.jsp" />

<main class="main-content">
    <div class="container">
        <div id="articleForm">
            <div class="form-header">
                <h1><i class="fas fa-edit"></i> Submit Your Article</h1>
                <p>Share your pet rescue stories, care tips, or adoption experiences. All submissions will be reviewed by our admin team before publishing.</p>
            </div>

            <div class="guest-info-note">
                <h4><i class="fas fa-info-circle"></i> Note for Guest Users</h4>
                <p>You can submit articles without creating an account! Simply fill in your name and email below. We'll use your email to notify you when your article is reviewed and published.</p>
            </div>

            <div class="article-form-container">
                <!-- ✅ REAL submission -->
                <form id="articleSubmissionForm" method="post" action="<%= ctx %>/articles/submit">

                    <div class="form-group">
                        <label for="title" class="required">Article Title</label>
                        <input type="text" id="title" name="title" placeholder="e.g., My Journey with a Rescue Dog" required>
                        <span class="form-help"><i class="fas fa-info-circle"></i> Make it descriptive and engaging</span>
                    </div>

                    <div class="form-group">
                        <label for="category" class="required">Category</label>
                        <select id="category" name="category" required>
                            <option value="">Select a category</option>
                            <option value="care">Pet Care</option>
                            <option value="training">Training</option>
                            <option value="health">Health</option>
                            <option value="rescue">Rescue Stories</option>
                            <option value="adoption">Adoption Tips</option>
                            <option value="other">Other</option>
                        </select>
                        <span class="form-help"><i class="fas fa-info-circle"></i> Choose the most relevant category</span>
                    </div>

                    <div class="form-group">
                        <label for="author" class="required">Your Name</label>
                        <input type="text" id="author" name="author" placeholder="e.g., Jane Smith" required
                               value="<%= authorName %>">
                        <span class="form-help"><i class="fas fa-info-circle"></i> This will be displayed as the article author</span>
                    </div>

                    <div class="form-group">
                        <label for="email" class="required">Your Email</label>
                        <input type="email" id="email" name="email" placeholder="jane@example.com" required
                               value="<%= authorEmail %>">
                        <span class="form-help"><i class="fas fa-info-circle"></i> We'll notify you when your article is reviewed</span>
                    </div>

                    <div class="form-group">
                        <label for="excerpt" class="required">Short Description</label>
                        <textarea id="excerpt" name="excerpt" placeholder="Brief summary of your article (2-3 sentences)" maxlength="200" required></textarea>
                        <span class="form-help"><i class="fas fa-info-circle"></i> This will appear in the article preview</span>
                    </div>

                    <div class="form-group">
                        <label for="content" class="required">Article Content</label>
                        <textarea id="content" name="content" placeholder="Write your full article here..." required></textarea>
                        <span class="form-help"><i class="fas fa-info-circle"></i> You can include headings, paragraphs, and lists</span>
                    </div>

                    <div class="form-group">
                        <label for="image">Cover Image URL (Optional)</label>
                        <input type="text" id="image" name="image" placeholder="https://example.com/image.jpg">
                        <span class="form-help"><i class="fas fa-info-circle"></i> Add a link to a relevant image. Must be publicly accessible.</span>
                    </div>

                    <div class="form-actions">
                        <button type="submit" class="btn-submit">
                            <i class="fas fa-paper-plane"></i> Submit for Review
                        </button>
                        <a href="<%= ctx %>/articles" class="btn-cancel">
                            <i class="fas fa-times"></i> Cancel
                        </a>
                    </div>
                </form>
            </div>
        </div>
    </div>
</main>

<jsp:include page="/user/user-footer.jsp" />

</body>
</html>
