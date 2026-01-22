<%-- 
    Document   : article-detail
    Created on : Jan 22, 2026, 11:49:17 AM
    Author     : User
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.ariniqo.model.Article" %>

<%
    String ctx = request.getContextPath();
    Article a = (Article) request.getAttribute("article");

    if (a == null) {
        response.sendRedirect(ctx + "/index.jsp");
        return;
    }

    // Image handling: supports http(s), relative path, or empty
    String img = a.getImageUrl();
    if (img == null) img = "";
    img = img.trim();

    String imgSrc;
    if (img.length() == 0) {
        imgSrc = ctx + "/images/pet1.jpg";
    } else if (img.startsWith("http://") || img.startsWith("https://")) {
        imgSrc = img;
    } else {
        imgSrc = ctx + "/" + img;
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title><%= a.getTitle() %> - Ariniqo Buddies</title>

    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Nunito:wght@400;600;700;800&family=Poppins:wght@300;400;500;600&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="<%= ctx %>/css/user-style.css">
</head>
<body>

<!-- ✅ Guest navbar -->
<jsp:include page="/navBar.jsp" />

<main class="main-content">
    <div class="container" style="max-width: 950px;">

        <div style="display:flex; justify-content:space-between; align-items:center; flex-wrap:wrap; gap:12px; margin: 10px 0 18px;">
            <a href="<%= ctx %>/index.jsp" class="btn btn-primary" style="text-decoration:none;">
                <i class="fas fa-arrow-left"></i> Back to Home
            </a>

            <a href="<%= ctx %>/articles" class="btn btn-success" style="text-decoration:none;">
                <i class="fas fa-newspaper"></i> All Articles
            </a>
        </div>

        <div style="background:#fff; border-radius: var(--radius); overflow:hidden; box-shadow: var(--shadow-light);">
            <img src="<%= imgSrc %>" alt="Cover"
                 style="width:100%; height:360px; object-fit:cover;"
                 onerror="this.src='<%= ctx %>/images/pet1.jpg'">

            <div style="padding: 26px;">
                <div style="display:flex; gap:10px; flex-wrap:wrap; align-items:center; color:var(--text-light); font-size:14px; margin-bottom: 12px;">
                    <span style="display:inline-flex; align-items:center; gap:6px;">
                        <i class="fas fa-tag"></i> <%= a.getCategory() %>
                    </span>
                    <span>•</span>
                    <span style="display:inline-flex; align-items:center; gap:6px;">
                        <i class="fas fa-user"></i> <%= a.getAuthorName() %>
                    </span>
                </div>

                <h1 style="font-family:'Nunito',sans-serif; font-size: 32px; font-weight: 800; margin: 0 0 12px;">
                    <%= a.getTitle() %>
                </h1>

                <p style="color:var(--text-light); margin:0 0 18px; line-height: 1.7;">
                    <%= a.getExcerpt() %>
                </p>

                <hr style="border:none; border-top:1px solid var(--gray-border); margin: 18px 0;">

                <div style="white-space: pre-wrap; line-height: 1.9; color: var(--text); font-size: 16px;">
                    <%= a.getContent() %>
                </div>
            </div>
        </div>

    </div>
</main>

<!-- ✅ Guest footer -->
<jsp:include page="/footer.jsp" />

</body>
</html>
