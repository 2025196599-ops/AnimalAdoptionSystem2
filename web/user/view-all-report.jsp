<%--
    Document   : view-all-report
    Updated on : Jan 2026
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*" %>
<%@ page import="com.ariniqo.model.User" %>
<%@ page import="com.ariniqo.model.LostFoundReport" %>
<%@ page import="com.ariniqo.dao.LostFoundReportDAO" %>

<%
    String ctx = request.getContextPath();
    User user = (User) session.getAttribute("user");
    boolean loggedIn = (user != null);

    // ✅ load real reports from DB
    List<LostFoundReport> reports = new ArrayList<LostFoundReport>();
    try {
        reports = new LostFoundReportDAO().listAllActiveFirst();
    } catch (Exception e) {
        e.printStackTrace();
        reports = new ArrayList<LostFoundReport>();
    }

    // ✅ quick stats (real)
    int activeCount = 0;
    int resolvedCount = 0;
    for (int i=0; i<reports.size(); i++) {
        LostFoundReport rr = reports.get(i);
        String st = (rr.getStatus() == null ? "" : rr.getStatus());
        if ("RESOLVED".equalsIgnoreCase(st)) resolvedCount++;
        else activeCount++;
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <title>All Lost & Found Reports - Ariniqo Buddies</title>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />

    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

    <link rel="stylesheet" href="<%= ctx %>/css/user-style.css">
    <link rel="stylesheet" href="<%= ctx %>/css/view-all-report.css">
</head>
<body>

<jsp:include page="/user/user-navBar.jsp" />

<main class="main-content">
    <div class="view-reports-container">

        <div class="page-header">
            <h1 class="page-title">
                <i class="fas fa-list-alt"></i>
                All Lost & Found Reports
            </h1>
            <p class="page-subtitle">
                Browse real reports from the database. Found a pet? Open a LOST report and click "Found It".
            </p>

            <div class="quick-stats">
                <div class="stat"><span class="stat-number"><%= activeCount %></span><span class="stat-label">Active Reports</span></div>
                <div class="stat"><span class="stat-number"><%= resolvedCount %></span><span class="stat-label">Resolved</span></div>
                <div class="stat"><span class="stat-number"><%= reports.size() %></span><span class="stat-label">Total</span></div>
            </div>
        </div>

        <div class="filter-bar">
            <div class="search-box">
                <i class="fas fa-search"></i>
                <input type="text" id="searchReports" placeholder="Search by pet name, breed, or location...">
            </div>

            <div class="filter-controls">
                <select id="filterType">
                    <option value="all">All Reports</option>
                    <option value="lost">Lost Pets</option>
                    <option value="found">Found Pets</option>
                </select>

                <select id="filterStatus">
                    <option value="all">All Status</option>
                    <option value="active">Active</option>
                    <option value="resolved">Resolved</option>
                </select>

                <select id="filterLocation">
                    <option value="all">All Locations</option>
                    <option value="kuala lumpur">Kuala Lumpur</option>
                    <option value="petaling jaya">Petaling Jaya</option>
                    <option value="cheras">Cheras</option>
                    <option value="bangsar">Bangsar</option>
                </select>

                <button class="filter-btn" onclick="applyFilters()">
                    <i class="fas fa-filter"></i> Apply Filters
                </button>

                <button class="reset-btn" onclick="resetFilters()">
                    <i class="fas fa-redo"></i> Reset
                </button>
            </div>
        </div>

        <div class="reports-section">
            <div class="section-header">
                <h2 class="section-title">
                    <i class="fas fa-paw"></i>
                    Reports
                    <span class="report-count" id="reportCountText">(Showing 0 reports)</span>
                </h2>
            </div>

            <div class="reports-grid" id="reportsGrid">

                <%
                    if (reports.isEmpty()) {
                %>
                    <div class="no-reports" style="grid-column: 1 / -1; text-align:center; padding:40px; color:var(--text-light);">
                        <i class="fas fa-file-alt" style="font-size:40px; color:#ddd;"></i>
                        <h3 style="margin-top:10px;">No Reports Found</h3>
                        <p style="margin:0;">No reports in database yet.</p>
                    </div>
                <%
                    } else {
                        for (int i=0; i<reports.size(); i++) {
                            LostFoundReport r = reports.get(i);

                            String tp = (r.getReportType() == null ? "" : r.getReportType().trim());
                            String st = (r.getStatus() == null ? "" : r.getStatus().trim());

                            String typeKey = "lost";
                            if ("FOUND".equalsIgnoreCase(tp)) typeKey = "found";

                            String statusKey = "active";
                            if ("RESOLVED".equalsIgnoreCase(st)) statusKey = "resolved";

                            String title = (r.getPetName() != null && r.getPetName().trim().length() > 0)
                                    ? r.getPetName()
                                    : (typeKey.equals("lost") ? "Lost Pet Report" : "Found Pet Report");

                            String breed = (r.getBreed() != null ? r.getBreed() : "");
                            String loc = (r.getLocationText() != null ? r.getLocationText() : "");
                            String city = (r.getCity() != null ? r.getCity() : "");
                            String locationFull = (loc + " " + city).trim();

                            String blob = (title + " " + breed + " " + locationFull + " " + tp + " " + st).toLowerCase();

                            // ✅ FIXED: use UploadViewServlet (/file) to show uploaded image
                            String photoPath = (r.getPhotoPath() == null ? "" : r.getPhotoPath().trim());
                            String photoUrl = (photoPath.length() > 0)
                                    ? (ctx + "/file?path=" + java.net.URLEncoder.encode(photoPath, "UTF-8"))
                                    : (ctx + "/images/pet1.jpg");
                %>

                <div class="report-card <%= typeKey %> <%= statusKey %>"
                     data-type="<%= typeKey %>"
                     data-status="<%= statusKey %>"
                     data-location="<%= locationFull.toLowerCase() %>"
                     data-blob="<%= blob %>">

                    <div class="report-card-header">
                        <div class="report-type <%= typeKey %>">
                            <%= typeKey.equals("lost") ? "LOST PET" : "FOUND PET" %>
                        </div>
                        <div class="report-status <%= statusKey %>">
                            <%= statusKey.equals("active") ? "ACTIVE" : "RESOLVED" %>
                        </div>
                    </div>

                    <div class="report-image" style="background:#f5f7fa; overflow:hidden;">
                        <!-- ✅ FIXED: use photoUrl -->
                        <img src="<%= photoUrl %>" alt="report"
                             style="width:100%; height:200px; object-fit:cover;"
                             onerror="this.src='<%= ctx %>/images/pet1.jpg'">
                    </div>

                    <div class="report-card-body">
                        <h3 class="report-title"><%= title %></h3>

                        <div class="report-info">
                            <div class="info-item">
                                <i class="fas fa-paw"></i>
                                <span><%= (breed.length() > 0 ? breed : "Unknown") %></span>
                            </div>
                            <div class="info-item">
                                <i class="fas fa-map-marker-alt"></i>
                                <span><%= (locationFull.length() > 0 ? locationFull : "-") %></span>
                            </div>
                            <div class="info-item">
                                <i class="fas fa-calendar"></i>
                                <span><%= (r.getEventDate() != null ? r.getEventDate().toString() : "-") %></span>
                            </div>
                        </div>

                        <p class="report-description">
                            <%= (r.getDescription() != null && r.getDescription().trim().length() > 0)
                                    ? r.getDescription()
                                    : "No description provided." %>
                        </p>
                    </div>

                    <div class="report-card-footer">
                        <a class="view-details-btn" style="text-decoration:none;"
                           href="<%= ctx %>/report?id=<%= r.getReportId() %>&ui=user">
                            <i class="fas fa-eye"></i> View Details
                        </a>

                        <% if ("lost".equals(typeKey) && "active".equals(statusKey)) { %>
                            <a class="found-it-btn" style="text-decoration:none;"
                               href="<%= ctx %>/report?id=<%= r.getReportId() %>&ui=user">
                                <i class="fas fa-hand-holding-heart"></i> Found It
                            </a>
                        <% } %>
                    </div>
                </div>

                <%
                        }
                    }
                %>

            </div>

            <div class="no-results" id="noResults" style="display:none;">
                <i class="fas fa-search fa-3x"></i>
                <h3>No Reports Found</h3>
                <p>Try adjusting your search filters.</p>
            </div>

        </div>

        <div class="quick-actions">
            <button class="action-btn lost-btn" onclick="requireLoginForReport('lost')">
                <i class="fas fa-plus-circle"></i> Report Lost Pet
            </button>
            <button class="action-btn found-btn" onclick="requireLoginForReport('found')">
                <i class="fas fa-plus-circle"></i> Report Found Pet
            </button>
        </div>

        <div id="loginModal" style="display:none; position:fixed; inset:0; background: rgba(0,0,0,0.8); z-index:9999; justify-content:center; align-items:center;">
            <div style="background:white; padding:40px; border-radius:16px; max-width:500px; text-align:center;">
                <div style="font-size:64px; color:#ff7e5f; margin-bottom:20px;">
                    <i class="fas fa-lock"></i>
                </div>
                <h2 style="font-family:'Nunito',sans-serif; font-size:28px; margin-bottom:15px;">Login Required</h2>
                <p id="modalMessage" style="color:#777; margin-bottom:30px; line-height:1.6;">
                    To submit a report, you need to be logged in.
                </p>
                <div style="display:flex; gap:15px; justify-content:center;">
                    <a href="<%= ctx %>/login.jsp" style="background:#ff7e5f; color:white; padding:15px 30px; border-radius:30px; text-decoration:none; font-weight:600;">
                        <i class="fas fa-sign-in-alt"></i> Login Now
                    </a>
                    <a href="<%= ctx %>/signup.jsp" style="background:transparent; color:#ff7e5f; border:2px solid #ff7e5f; padding:15px 30px; border-radius:30px; text-decoration:none; font-weight:600;">
                        <i class="fas fa-user-plus"></i> Sign Up
                    </a>
                </div>
            </div>
        </div>

    </div>
</main>

<jsp:include page="/user/user-footer.jsp" />

<script>
var IS_LOGGED_IN = <%= loggedIn ? "true" : "false" %>;

function requireLoginForReport(type) {
    if (!IS_LOGGED_IN) {
        var modal = document.getElementById('loginModal');
        var message = document.getElementById('modalMessage');

        message.textContent = (type === 'lost')
            ? 'To report a lost pet, you need to be logged in. Please login or create an account.'
            : 'To report a found pet, you need to be logged in. Please login or create an account.';

        modal.style.display = 'flex';
        document.body.style.overflow = 'hidden';

        modal.addEventListener('click', function(e) {
            if (e.target === this) {
                modal.style.display = 'none';
                document.body.style.overflow = 'auto';
            }
        });
    } else {
        if (type === 'lost') window.location.href = '<%= ctx %>/user/report-lost-pet.jsp';
        else window.location.href = '<%= ctx %>/user/found-report.jsp';
    }
}

function normalize(s) { return (s || '').toString().toLowerCase(); }

function filterReports() {
    var q = normalize(document.getElementById('searchReports').value);
    var type = document.getElementById('filterType').value;
    var status = document.getElementById('filterStatus').value;
    var loc = document.getElementById('filterLocation').value;

    var cards = document.querySelectorAll('.report-card');
    var shown = 0;

    for (var i=0; i<cards.length; i++) {
        var c = cards[i];
        var cType = c.getAttribute('data-type');
        var cStatus = c.getAttribute('data-status');
        var cLoc = c.getAttribute('data-location');
        var blob = c.getAttribute('data-blob');

        var ok = true;
        if (type !== 'all' && cType !== type) ok = false;
        if (status !== 'all' && cStatus !== status) ok = false;
        if (loc !== 'all' && cLoc.indexOf(loc) === -1) ok = false;
        if (q && blob.indexOf(q) === -1) ok = false;

        c.style.display = ok ? '' : 'none';
        if (ok) shown++;
    }

    var countEl = document.getElementById('reportCountText');
    if (countEl) countEl.textContent = '(Showing ' + shown + ' reports)';

    var noResults = document.getElementById('noResults');
    if (noResults) noResults.style.display = (shown === 0 ? 'block' : 'none');
}

function applyFilters() { filterReports(); }
function resetFilters() {
    document.getElementById('searchReports').value = '';
    document.getElementById('filterType').value = 'all';
    document.getElementById('filterStatus').value = 'all';
    document.getElementById('filterLocation').value = 'all';
    filterReports();
}

document.addEventListener('DOMContentLoaded', function() {
    filterReports();
    document.getElementById('searchReports').addEventListener('input', filterReports);
    document.getElementById('filterType').addEventListener('change', filterReports);
    document.getElementById('filterStatus').addEventListener('change', filterReports);
    document.getElementById('filterLocation').addEventListener('change', filterReports);
});
</script>

</body>
</html>
