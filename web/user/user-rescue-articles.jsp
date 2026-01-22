<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="com.ariniqo.model.Article" %>

<%
    String ctx = request.getContextPath();
    List<Article> articles = (List<Article>) request.getAttribute("articles");
    if (articles == null) articles = new ArrayList<Article>();
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Rescue Articles - Ariniqo Buddies</title>

    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Nunito:wght@400;600;700;800&family=Poppins:wght@300;400;500;600&display=swap" rel="stylesheet">

    <!-- ✅ same css as main -->
    <link rel="stylesheet" href="<%= ctx %>/css/user-style.css">
</head>
<body>

<!-- ✅ user navbar -->
<jsp:include page="/user/user-navBar.jsp" />

<main class="main-content">
    <div class="container">

        <!-- ✅ same header layout as main -->
        <h1 class="page-title"><i class="fas fa-newspaper"></i> Rescue Articles</h1>

        <%
            if (articles.isEmpty()) {
        %>
            <p style="color:var(--text-light); text-align:center; padding:30px;">
                No approved articles yet.
            </p>
        <%
            } else {
        %>
            <!-- ✅ same grid/card layout as main -->
            <div class="pet-grid">
                <%
                    for (int i=0; i<articles.size(); i++) {
                        Article a = articles.get(i);

                        String img = a.getImageUrl();
                        if (img == null) img = "";
                        img = img.trim();

                        String imgSrc;
                        if (img.length() == 0) {
                            imgSrc = ctx + "/images/pet1.jpg";
                        } else if (img.startsWith("http://") || img.startsWith("https://")) {
                            imgSrc = img;
                        } else {
                            imgSrc = img.startsWith("/") ? (ctx + img) : (ctx + "/" + img);
                        }
                %>
                    <div class="pet-card">
                        <img src="<%= imgSrc %>" alt="<%= a.getTitle() %>" class="pet-card-image"
                             onerror="this.src='<%= ctx %>/images/pet1.jpg'" />

                        <div class="pet-card-body">
                            <h3 class="pet-card-title"><%= a.getTitle() %></h3>

                            <div class="pet-card-info">
                                Category: <%= a.getCategory() %> |
                                By: <%= a.getAuthorName() %>
                            </div>

                            <p style="color: var(--text-light); margin: 12px 0;">
                                <%= a.getExcerpt() %>
                            </p>

                            <!-- ✅ user detail link keeps ui=user -->
                            <a class="btn btn-primary" href="<%= ctx %>/article?id=<%= a.getArticleId() %>&ui=user">
                                <i class="fas fa-eye"></i> Read More
                            </a>
                        </div>
                    </div>
                <%
                    }
                %>
            </div>
        <%
            }
        %>

        <!-- ✅ same submit button section as main (but user page goes to add-article.jsp) -->
        <div style="text-align:center; margin-top:40px;">
            <a href="<%= ctx %>/user/add-article.jsp" class="btn btn-success">
                <i class="fas fa-plus"></i> Submit an Article
            </a>
        </div>

    </div>
</main>

<!-- ✅ user footer -->
<jsp:include page="/user/user-footer.jsp" />

</body>
</html>
