<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isErrorPage="true" %>
<%
    String ctx = request.getContextPath();
    String msg = (exception != null && exception.getMessage() != null)
            ? exception.getMessage()
            : "An unexpected error happened.";
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>Oops - Ariniqo Buddies</title>
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
  <link href="https://fonts.googleapis.com/css2?family=Nunito:wght@400;600;700;800&family=Poppins:wght@300;400;500;600&display=swap" rel="stylesheet">
  <link rel="stylesheet" href="<%= ctx %>/css/user-style.css">
  <style>
    .err-box{max-width:720px;margin:60px auto;background:#fff;border-radius:16px;padding:28px;box-shadow:0 10px 30px rgba(0,0,0,.08)}
    .err-title{font-size:28px;margin:0 0 10px 0}
    .err-msg{color:var(--text-light);margin:0 0 22px 0;word-break:break-word}
    .err-actions{display:flex;gap:12px;flex-wrap:wrap}
  </style>
</head>
<body>

<jsp:include page="/navBar.jsp" />

<main class="main-content">
  <div class="container">
    <div class="err-box">
      <h1 class="err-title"><i class="fas fa-triangle-exclamation"></i> Something went wrong</h1>
      <p class="err-msg"><%= msg %></p>
      <div class="err-actions">
        <a class="btn btn-primary" href="<%= ctx %>/index.jsp"><i class="fas fa-home"></i> Go Home</a>
        <a class="btn btn-success" href="javascript:history.back()"><i class="fas fa-arrow-left"></i> Go Back</a>
      </div>
    </div>
  </div>
</main>

<jsp:include page="/footer.jsp" />

</body>
</html>
