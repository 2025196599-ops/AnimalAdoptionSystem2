<%-- 
    Document   : report-detail
    Updated on : Jan 2026
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.ariniqo.model.LostFoundReport" %>
<%@ page import="com.ariniqo.model.User" %>

<%
    String ctx = request.getContextPath();
    LostFoundReport r = (LostFoundReport) request.getAttribute("report");
    if (r == null) {
        response.sendRedirect(ctx + "/user/user-lost-found.jsp");
        return;
    }

    User user = (User) session.getAttribute("user");
    boolean loggedIn = (user != null);

    String type = (r.getReportType() == null ? "" : r.getReportType());
    String status = (r.getStatus() == null ? "" : r.getStatus());

    // ✅ FIXED: use UploadViewServlet (/file) for uploaded images
    String photoPath = (r.getPhotoPath() == null ? "" : r.getPhotoPath().trim());
    String photo = (photoPath.length() > 0)
            ? (ctx + "/file?path=" + java.net.URLEncoder.encode(photoPath, "UTF-8"))
            : (ctx + "/images/pet1.jpg");

    boolean isLost = "LOST".equalsIgnoreCase(type);
    boolean isActive = !"RESOLVED".equalsIgnoreCase(status);

    boolean sent = "1".equals(request.getParameter("sent"));
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <title>Report Detail - Lost & Found</title>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Nunito:wght@400;600;700;800&family=Poppins:wght@300;400;500;600&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="<%= ctx %>/css/user-style.css">
    <style>
.rd-wrap{ max-width: 1120px; margin: 0 auto; padding: 26px 16px 60px; }
.rd-topbar{ display:flex; align-items:center; justify-content:space-between; gap:12px; flex-wrap:wrap; margin-bottom: 14px; }
.rd-title{ margin:0; font-size: 28px; font-weight: 900; font-family:'Nunito',sans-serif; display:flex; align-items:center; gap:10px; }
.rd-sub{ color: var(--text-light); font-size: 14px; margin-top: 4px; }

.rd-alert{
  margin: 0 0 14px; padding: 12px 14px; border-radius: 16px;
  display:flex; align-items:center; gap:10px; font-weight: 800;
  border: 1px solid rgba(65,216,191,.45);
  background: rgba(65,216,191,.12); color:#2d8f7f;
}

.rd-card{
  background: white; border: 1px solid rgba(0,0,0,.06); border-radius: 24px;
  box-shadow: 0 16px 40px rgba(0,0,0,.08); overflow: hidden;
}
.rd-head{
  padding: 18px 22px; border-bottom: 1px solid rgba(0,0,0,.06);
  background: linear-gradient(135deg, rgba(93,106,251,.10), rgba(255,126,95,.10));
}
.rd-head-row{ display:flex; align-items:flex-start; justify-content:space-between; gap:14px; flex-wrap:wrap; }
.rd-id{
  color: var(--text-light); font-weight: 700; font-size: 13px;
  display:flex; align-items:center; gap:8px; padding: 8px 12px;
  border-radius: 999px; background: rgba(255,255,255,.65); border: 1px solid rgba(0,0,0,.06);
}

.rd-body{ padding: 22px; }
.rd-grid{ display:grid; grid-template-columns: 420px 1fr; gap: 22px; }
@media (max-width: 980px){ .rd-grid{ grid-template-columns: 1fr; } }

.rd-photoFrame{ background: #f7f8fc; border: 1px solid rgba(0,0,0,.08); border-radius: 20px; padding: 12px; }
.rd-photo{
  width: 100%; height: 360px; object-fit: contain; display:block;
  border-radius: 16px; background: #f5f7fa;
}
@media (max-width: 980px){ .rd-photo{ height: 320px; } }

.rd-photoHint{
  margin-top: 10px; color: var(--text-light); font-size: 13px;
  display:flex; align-items:center; justify-content:space-between; gap:10px; flex-wrap:wrap;
}
.rd-photoHint a{ text-decoration:none; font-weight:800; color: var(--secondary); }

.rd-badges{ display:flex; gap:10px; flex-wrap:wrap; align-items:center; margin-bottom: 10px; }
.rd-badge{
  display:inline-flex; align-items:center; gap:8px; padding: 8px 12px;
  border-radius: 999px; font-size: 12px; font-weight: 900; letter-spacing: .3px;
  border: 1px solid rgba(0,0,0,.06); background: rgba(255,255,255,.8);
}
.rd-badge.lost{ background: rgba(255,126,95,.12); color:#ff7e5f; }
.rd-badge.found{ background: rgba(76,175,80,.12); color:#2e8b57; }
.rd-badge.active{ background: rgba(93,106,251,.12); color:#5d6afb; }
.rd-badge.resolved{ background: rgba(120,120,120,.12); color:#666; }

.rd-name{ margin: 0; font-size: 32px; font-weight: 950; font-family:'Nunito',sans-serif; }
.rd-line{ margin-top: 6px; color: var(--text-light); font-size: 14px; }
.rd-meta{ display:flex; flex-wrap:wrap; gap: 12px; margin-top: 14px; }
.rd-metaItem{
  display:inline-flex; align-items:center; gap:10px; padding: 10px 12px;
  border-radius: 16px; background: #fbfcff; border: 1px solid rgba(0,0,0,.06);
  color: #555; font-size: 14px;
}
.rd-metaItem i{ color:#9aa3af; }

.rd-section{ margin-top: 18px; padding-top: 18px; border-top: 1px solid rgba(0,0,0,.08); }
.rd-section h3{ margin: 0 0 10px; font-size: 18px; font-weight: 950; display:flex; align-items:center; gap:10px; }
.rd-section p{ margin: 0; color: var(--text-light); line-height: 1.75; }

.rd-contact{ display:grid; grid-template-columns: 1fr 1fr; gap: 12px; margin-top: 10px; }
@media (max-width: 700px){ .rd-contact{ grid-template-columns: 1fr; } }
.rd-contact .box{
  background: #fbfcff; border: 1px solid rgba(0,0,0,.06);
  border-radius: 16px; padding: 12px 14px; color: var(--text-light);
}
.rd-contact strong{ color:#222; }

.rd-form{
  background: rgba(93,106,251,.06);
  border: 1px solid rgba(93,106,251,.14);
  border-radius: 18px; padding: 14px; margin-top: 12px;
}
.rd-form label{ font-weight: 900; display:block; margin-bottom: 8px; }
.rd-form textarea{
  width:100%; padding: 12px; border-radius: 14px;
  border: 1px solid rgba(0,0,0,.10); resize: vertical;
  font-family: 'Poppins', sans-serif; background: white;
}
.rd-actions{ display:flex; gap:12px; flex-wrap:wrap; margin-top: 12px; }
.rd-btn{ border-radius: 999px; padding: 12px 16px; font-weight: 900; text-decoration:none; display:inline-flex; align-items:center; gap:10px; }
.rd-btn.ghost{ background: rgba(0,0,0,.06); color:#333; }
</style>
</head>
<body>

<jsp:include page="/user/user-navBar.jsp" />

<main class="main-content">
    <div class="container">

        <% if (sent) { %>
            <div style="margin: 10px 0; padding: 12px 15px; border-radius: 10px; background: rgba(65,216,191,0.12); border: 1px solid #41D8BF; color:#2d8f7f;">
                <i class="fas fa-check-circle"></i> Your “Found It” message has been submitted.
            </div>
        <% } %>

        <div style="display:flex; justify-content:space-between; align-items:center; flex-wrap:wrap; gap:12px; margin-bottom: 20px;">
            <h1 class="page-title" style="margin:0;">
                <i class="fas fa-file-alt"></i> Report Detail
            </h1>

            <a href="<%= ctx %>/user/user-lost-found.jsp" class="btn btn-primary" style="text-decoration:none;">
                <i class="fas fa-arrow-left"></i> Back to Lost &amp; Found
            </a>
        </div>

        <div style="background:white; border-radius: var(--radius); padding: 24px; box-shadow: var(--shadow-light);">

            <div style="display:flex; gap:20px; flex-wrap:wrap;">
                <img src="<%= photo %>" alt="Report Photo"
                     style="width:320px; max-width:100%; height:220px; object-fit:cover; border-radius: 16px;"
                     onerror="this.src='<%= ctx %>/images/pet1.jpg'">

                <div style="flex:1; min-width:260px;">
                    <div style="display:flex; gap:10px; flex-wrap:wrap; align-items:center; margin-bottom: 10px;">
                        <span class="pet-card-status status-available" style="display:inline-block;">
                            <i class="fas fa-tag"></i> <%= type %>
                        </span>
                        <span class="pet-card-status <%= isActive ? "status-available" : "status-unavailable" %>" style="display:inline-block;">
                            <i class="fas fa-info-circle"></i> <%= status %>
                        </span>
                        <span style="color:var(--text-light); font-size:13px;">
                            ID: #LF-<%= r.getReportId() %>
                        </span>
                    </div>

                    <h2 style="font-family:'Nunito',sans-serif; font-size:26px; margin: 8px 0;">
                        <%= (r.getPetName() != null && r.getPetName().trim().length() > 0) ? r.getPetName() : "Unnamed Pet" %>
                    </h2>

                    <p style="color:var(--text-light); margin:0 0 10px;">
                        <strong>Type:</strong> <%= (r.getPetType() != null ? r.getPetType() : "") %>
                        <% if (r.getBreed() != null && r.getBreed().trim().length() > 0) { %>
                            | <strong>Breed:</strong> <%= r.getBreed() %>
                        <% } %>
                    </p>

                    <p style="color:var(--text-light); margin:0 0 10px;">
                        <i class="fas fa-map-marker-alt"></i>
                        <%= (r.getLocationText() != null ? r.getLocationText() : "") %>
                        <% if (r.getCity() != null && r.getCity().trim().length() > 0) { %>
                            , <%= r.getCity() %>
                        <% } %>
                    </p>

                    <p style="color:var(--text-light); margin:0 0 10px;">
                        <i class="fas fa-calendar"></i>
                        <%= (r.getEventDate() != null ? r.getEventDate().toString() : "-") %>
                        &nbsp;&nbsp;
                        <i class="fas fa-clock"></i>
                        <%= (r.getEventTime() != null ? r.getEventTime().toString() : "-") %>
                    </p>
                </div>
            </div>

            <hr style="margin: 24px 0; border:none; border-top:1px solid var(--gray-border);">

            <h3 style="font-family:'Nunito',sans-serif; font-size:20px; margin:0 0 10px;">
                <i class="fas fa-info-circle"></i> Description
            </h3>
            <p style="color:var(--text-light); line-height:1.7;">
                <%= (r.getDescription() != null ? r.getDescription() : "No description provided.") %>
            </p>

            <h3 style="font-family:'Nunito',sans-serif; font-size:20px; margin:20px 0 10px;">
                <i class="fas fa-star"></i> Distinctive Features
            </h3>
            <p style="color:var(--text-light); line-height:1.7;">
                <%= (r.getDistinctiveFeatures() != null ? r.getDistinctiveFeatures() : "-") %>
            </p>

            <% if (r.getCollarDetails() != null && r.getCollarDetails().trim().length() > 0) { %>
            <h3 style="font-family:'Nunito',sans-serif; font-size:20px; margin:20px 0 10px;">
                <i class="fas fa-dog"></i> Collar Details
            </h3>
            <p style="color:var(--text-light); line-height:1.7;">
                <%= r.getCollarDetails() %>
            </p>
            <% } %>

            <% if (r.getReward() != null && r.getReward().trim().length() > 0) { %>
            <h3 style="font-family:'Nunito',sans-serif; font-size:20px; margin:20px 0 10px;">
                <i class="fas fa-gift"></i> Reward
            </h3>
            <p style="color:var(--text-light); line-height:1.7;">
                <%= r.getReward() %>
            </p>
            <% } %>

            <hr style="margin: 24px 0; border:none; border-top:1px solid var(--gray-border);">

            <h3 style="font-family:'Nunito',sans-serif; font-size:20px; margin:0 0 10px;">
                <i class="fas fa-user"></i> Contact (Reporter)
            </h3>
            <p style="color:var(--text-light); margin:0;">
                <strong>Name:</strong> <%= (r.getReporterName() != null ? r.getReporterName() : "-") %><br>
                <strong>Email:</strong> <%= (r.getReporterEmail() != null ? r.getReporterEmail() : "-") %><br>
                <strong>Phone:</strong> <%= (r.getReporterPhone() != null ? r.getReporterPhone() : "-") %>
            </p>

            <% if (isLost && isActive) { %>
                <hr style="margin: 24px 0; border:none; border-top:1px solid var(--gray-border);">
                <h3 style="font-family:'Nunito',sans-serif; font-size:20px; margin:0 0 10px;">
                    <i class="fas fa-hand-holding-heart"></i> I Found This Pet
                </h3>

                <% if (!loggedIn) { %>
                    <a href="<%= ctx %>/login.jsp" class="btn btn-primary" style="text-decoration:none;">
                        <i class="fas fa-lock"></i> Login to Submit “Found It”
                    </a>
                <% } else { %>
                    <form method="post" action="<%= ctx %>/reports/found-it" style="margin-top: 10px;">
                        <input type="hidden" name="reportId" value="<%= r.getReportId() %>">

                        <div style="margin-bottom: 10px;">
                            <label style="display:block; font-weight:600; margin-bottom:6px;">Message to owner (optional)</label>
                            <textarea name="message" rows="3"
                                      style="width:100%; padding:12px; border:1px solid var(--gray-border); border-radius: 12px;"></textarea>
                        </div>

                    <button type="submit" class="btn btn-success rd-btn">
                        <i class="fas fa-check"></i> Submit Found It
                      </button>
                    </form>
                <% } %>
            <% } %>

        </div>

    </div>
</main>

<jsp:include page="/user/user-footer.jsp" />

</body>
</html>
