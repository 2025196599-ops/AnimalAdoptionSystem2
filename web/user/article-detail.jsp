<%-- 
    Document   : article-detail
    Created on : Jan 22, 2026
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.ariniqo.model.Article" %>

<%
    String ctx = request.getContextPath();
    Article a = (Article) request.getAttribute("article");

    if (a == null) {
        response.sendRedirect(ctx + "/articles?ui=user");
        return;
    }

    String img = a.getImageUrl();
    if (img == null) img = "";
    img = img.trim();

    String imgSrc;
    if (img.length() == 0) imgSrc = ctx + "/images/pet1.jpg";
    else if (img.startsWith("http://") || img.startsWith("https://")) imgSrc = img;
    else imgSrc = img.startsWith("/") ? (ctx + img) : (ctx + "/" + img);

    // ✅ Clean weird hidden characters that show as boxes
    String cleanExcerpt = (a.getExcerpt() == null) ? "" : a.getExcerpt();
    cleanExcerpt = cleanExcerpt.replace("\uFEFF", ""); // BOM
    cleanExcerpt = cleanExcerpt.replace("\u200B", ""); // zero-width space
    cleanExcerpt = cleanExcerpt.replace("\u00A0", " "); // NBSP

    String cleanContent = (a.getContent() == null) ? "" : a.getContent();
    cleanContent = cleanContent.replace("\uFEFF", "");
    cleanContent = cleanContent.replace("\u200B", "");
    cleanContent = cleanContent.replace("\u00A0", " ");
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

    <!-- ✅ Force article text to look normal (prevents uppercase/letter-spacing bugs) -->
    <style>
        .article-body,
        .article-body p,
        .article-body div,
        .article-body span,
        .article-body li {
            font-family: 'Poppins', 'Nunito', sans-serif !important;
            text-transform: none !important;
            letter-spacing: normal !important;
            word-spacing: normal !important;
            font-variant: normal !important;
            line-height: 1.85 !important;
            font-size: 16px !important;
            color: var(--text) !important;
            white-space: pre-wrap;
        }
    </style>
</head>
<body>

<jsp:include page="/user/user-navBar.jsp" />

<main class="main-content">
    <div class="container" style="max-width: 900px;">
        <a href="<%= ctx %>/articles?ui=user" class="btn btn-primary" style="text-decoration:none; margin-bottom:15px;">
            <!-- ✅ fixed closing tag -->
            <i class="fas fa-arrow-left"></i> Back
        </a>

        <div style="background:#fff; border-radius:var(--radius); box-shadow:var(--shadow-light); overflow:hidden;">
            <img src="<%= imgSrc %>" alt="cover" style="width:100%; height:340px; object-fit:cover;"
                 onerror="this.src='<%= ctx %>/images/pet1.jpg'">

            <div style="padding:24px;">
                <div style="color:var(--text-light); margin-bottom:10px;">
                    <i class="fas fa-tag"></i> <%= a.getCategory() %> &nbsp; • &nbsp;
                    <i class="fas fa-user"></i> <%= a.getAuthorName() %>
                </div>

                <h1 style="font-family:'Nunito',sans-serif; margin:0 0 12px;"><%= a.getTitle() %></h1>

                <p style="color:var(--text-light); margin:0 0 18px;"><%= cleanExcerpt %></p>

                <hr style="border:none; border-top:1px solid var(--gray-border); margin:18px 0;">

                <!-- ✅ cleaned + forced normal font -->
                <div class="article-body">
                    <%= cleanContent %>
                </div>
            </div>
        </div>
    </div>
</main>

<jsp:include page="/user/user-footer.jsp" />

</body>
</html>
