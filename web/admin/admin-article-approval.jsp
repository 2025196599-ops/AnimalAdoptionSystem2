<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.ariniqo.dao.ArticleDAO" %>
<%@ page import="com.ariniqo.model.Article" %>
<%@ page import="com.ariniqo.model.User" %>
<%@ page import="java.util.*" %>

<%
    String ctx = request.getContextPath();

    User admin = (User) session.getAttribute("user");
    if (admin == null) {
        response.sendRedirect(ctx + "/login.jsp");
        return;
    }

    List<Article> pendingArticles = new ArrayList<Article>();
    List<Article> approvedArticles = new ArrayList<Article>();

    // 2) DAO load
    try {
        ArticleDAO dao = new ArticleDAO();
        pendingArticles = dao.listPending();
        approvedArticles = dao.listApproved();
    }catch (Exception e) {
    e.printStackTrace();
    pendingArticles = new ArrayList<Article>();
    approvedArticles = new ArrayList<Article>();
}


    boolean updated = "1".equals(request.getParameter("updated"));
    boolean deleted = "1".equals(request.getParameter("deleted"));
    boolean error   = "1".equals(request.getParameter("error"));
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Article Approval - Admin</title>

    <link rel="stylesheet" href="<%= ctx %>/css/admin-style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

    <style>
        .approval-container { max-width: 1000px; margin: 0 auto; padding: 30px; }
        .approval-header { text-align: center; margin-bottom: 18px; }
        .section-title { font-size: 20px; font-weight: 800; margin: 22px 0 12px; display:flex; gap:10px; align-items:center; }
        .card { background:#fff; border-radius:12px; padding:22px; margin-bottom:16px; box-shadow:0 4px 12px rgba(0,0,0,0.08); border-left:4px solid #ff7e5f; }
        .card.approved { border-left-color:#41D8BF; }
        .meta { display:flex; justify-content:space-between; gap:12px; flex-wrap:wrap; margin-bottom:12px; padding-bottom:10px; border-bottom:1px solid #eee; }
        .title { font-size:20px; font-weight:800; margin:12px 0 10px; }
        .cat { display:inline-block; padding:4px 12px; border-radius:20px; font-size:12px; font-weight:700; background:rgba(93,106,251,0.1); color:#5D6AFB; margin-bottom:12px; }
        .excerpt { background:#f9f9f9; padding:14px; border-radius:10px; color:#666; margin-bottom:12px; }
        .content { background:#f5f7fa; padding:14px; border-radius:10px; color:#444; max-height:220px; overflow:auto; white-space:pre-wrap; }
        .actions { display:flex; gap:12px; justify-content:center; flex-wrap:wrap; margin-top:14px; padding-top:14px; border-top:1px solid #eee; }
        .btnA { padding:10px 26px; border-radius:30px; border:none; font-weight:700; cursor:pointer; }
        .approve { background:#41D8BF; color:white; }
        .reject { background:transparent; border:2px solid #F44336; color:#F44336; }
        .delete { background:transparent; border:2px solid #111; color:#111; }
        .msg-ok { background: rgba(65,216,191,0.12); border:1px solid #41D8BF; padding:10px 12px; border-radius:10px; color:#2d8f7f; margin:10px 0; }
        .msg-err { background: rgba(244,67,54,0.12); border:1px solid #F44336; padding:10px 12px; border-radius:10px; color:#b71c1c; margin:10px 0; }
        .back-btn { display:inline-flex; gap:10px; align-items:center; padding:10px 22px; border-radius:30px; background:#5D6AFB; color:#fff; text-decoration:none; font-weight:700; margin-top:12px; }
        .empty { background:#fff; border-radius:12px; padding:32px; text-align:center; box-shadow:0 4px 12px rgba(0,0,0,0.08); color:#666; }
        .debug { background:#fff3cd; border:1px solid #ffeeba; padding:10px 12px; border-radius:10px; color:#856404; margin:10px 0; font-size:14px; }
    </style>
</head>
<body>

<main class="admin-main-content">
    <div class="approval-container">
        <div class="approval-header">
            <h1><i class="fas fa-clipboard-check"></i> Article Approval</h1>
            <p>Pending + Approved articles. You can delete approved articles anytime.</p>
            <a href="<%= ctx %>/admin/dashboard.jsp" class="back-btn">
                <i class="fas fa-arrow-left"></i> Back to Dashboard
            </a>
        </div>

        <% if (updated) { %><div class="msg-ok"><i class="fas fa-check-circle"></i> Updated successfully.</div><% } %>
        <% if (deleted) { %><div class="msg-ok"><i class="fas fa-check-circle"></i> Deleted successfully.</div><% } %>
        <% if (error)   { %><div class="msg-err"><i class="fas fa-exclamation-circle"></i> Action failed.</div><% } %>

        <div class="section-title"><i class="fas fa-clock"></i> Pending Articles (<%= pendingArticles.size() %>)</div>

        <% if (pendingArticles.isEmpty()) { %>
            <div class="empty">
                <i class="fas fa-check-circle" style="font-size:42px; color:#ddd;"></i>
                <h3>No Pending Articles</h3>
                <p>There are no articles waiting for review.</p>
            </div>
        <% } else { %>
            <% for (Article a : pendingArticles) { %>
            <div class="card">
                <div class="meta">
                    <div><b><i class="fas fa-user"></i> <%= a.getAuthorName() %></b> (<%= a.getAuthorEmail() %>)</div>
                    <div><i class="far fa-calendar"></i> <%= a.getSubmittedDate() %></div>
                </div>

                <div class="title"><%= a.getTitle() %></div>
                <div class="cat"><%= a.getCategory() %></div>

                <div class="excerpt"><b>Description:</b> <%= a.getExcerpt() %></div>
                <div class="content"><%= a.getContent() %></div>

                <div class="actions">
                    <form action="<%= ctx %>/admin/articles/update-status" method="post">
                        <input type="hidden" name="id" value="<%= a.getArticleId() %>">
                        <input type="hidden" name="status" value="APPROVED">
                        <button class="btnA approve" type="submit"><i class="fas fa-check"></i> Approve</button>
                    </form>

                    <form action="<%= ctx %>/admin/articles/update-status" method="post">
                        <input type="hidden" name="id" value="<%= a.getArticleId() %>">
                        <input type="hidden" name="status" value="REJECTED">
                        <button class="btnA reject" type="submit"><i class="fas fa-times"></i> Reject</button>
                    </form>

                    <form action="<%= ctx %>/admin/articles/delete" method="post"
                          onsubmit="return confirm('Delete this article permanently?');">
                        <input type="hidden" name="id" value="<%= a.getArticleId() %>">
                        <button class="btnA delete" type="submit"><i class="fas fa-trash"></i> Delete</button>
                    </form>
                </div>
            </div>
            <% } %>
        <% } %>

        <div class="section-title"><i class="fas fa-check-circle"></i> Approved Articles (<%= approvedArticles.size() %>)</div>

        <% if (approvedArticles.isEmpty()) { %>
            <div class="empty">
                <i class="fas fa-file-alt" style="font-size:42px; color:#ddd;"></i>
                <h3>No Approved Articles Yet</h3>
                <p>Approved articles will appear here.</p>
            </div>
        <% } else { %>
            <% for (Article a : approvedArticles) { %>
            <div class="card approved">
                <div class="meta">
                    <div><b><i class="fas fa-user"></i> <%= a.getAuthorName() %></b> (<%= a.getAuthorEmail() %>)</div>
                    <div><i class="far fa-calendar"></i> <%= (a.getReviewedDate()!=null?a.getReviewedDate():a.getSubmittedDate()) %></div>
                </div>

                <div class="title"><%= a.getTitle() %></div>
                <div class="cat"><%= a.getCategory() %></div>

                <div class="excerpt"><b>Description:</b> <%= a.getExcerpt() %></div>

                <div class="actions">
                    <form action="<%= ctx %>/admin/articles/delete" method="post"
                          onsubmit="return confirm('Delete this approved article permanently?');">
                        <input type="hidden" name="id" value="<%= a.getArticleId() %>">
                        <button class="btnA delete" type="submit"><i class="fas fa-trash"></i> Delete</button>
                    </form>
                </div>
            </div>
            <% } %>
        <% } %>

    </div>
</main>

</body>
</html>
