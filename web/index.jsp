<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ page import="com.ariniqo.util.DBConnection" %>

<%
    String ctx = request.getContextPath();

    // ✅ Load featured pets from DB (AVAILABLE)
    List<Map> featuredPets = new ArrayList<Map>();

    Connection con = null;
    PreparedStatement ps = null;
    ResultSet rs = null;

    try {
        con = DBConnection.getConnection();

        String sql =
            "SELECT PET_ID, NAME, TYPE, BREED, AGE, STATUS, DESCRIPTION, IMAGE_PATH " +
            "FROM PETS " +
            "WHERE STATUS IS NULL OR TRIM(STATUS)='' OR UPPER(STATUS)='AVAILABLE' " +
            "ORDER BY PET_ID DESC";

        ps = con.prepareStatement(sql);
        rs = ps.executeQuery();

        while (rs.next() && featuredPets.size() < 3) {
            Map m = new HashMap();
            m.put("petId", rs.getInt("PET_ID"));
            m.put("name", rs.getString("NAME"));
            m.put("type", rs.getString("TYPE"));
            m.put("breed", rs.getString("BREED"));
            m.put("age", rs.getInt("AGE"));
            m.put("status", rs.getString("STATUS"));
            m.put("description", rs.getString("DESCRIPTION"));
            m.put("imagePath", rs.getString("IMAGE_PATH"));
            featuredPets.add(m);
        }

    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        try { if (rs != null) rs.close(); } catch (Exception e) {}
        try { if (ps != null) ps.close(); } catch (Exception e) {}
        try { if (con != null) con.close(); } catch (Exception e) {}
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>Ariniqo Buddies - Find Your New Best Friend</title>
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
  <link href="https://fonts.googleapis.com/css2?family=Nunito:wght@400;600;700;800&family=Poppins:wght@300;400;500;600&display=swap" rel="stylesheet">
  <link rel="stylesheet" href="<%= ctx %>/css/user-style.css">
</head>
<body>

<jsp:include page="/navBar.jsp" />

<div class="feature-buttons-mobile">
  <a href="<%= ctx %>/pets" class="feature-btn">
    <i class="fas fa-paw"></i>
    <span>Pet Listing</span>
  </a>
  <a href="<%= ctx %>/articles" class="feature-btn active">
    <i class="fas fa-newspaper"></i>
    <span>Articles</span>
  </a>
</div>

<!-- Login modal (unchanged) -->
<div class="login-modal-overlay" id="loginModal">
  <div class="login-modal">
    <button class="login-modal-close" onclick="hideLoginModal()">
      <i class="fas fa-times"></i>
    </button>
    <div class="login-modal-icon">
      <i class="fas fa-lock"></i>
    </div>
    <h2>Login Required</h2>
    <p>This feature requires you to be logged in. Please login or create an account to access:</p>
    <ul style="text-align: left; color: var(--text-light); margin: 20px 0; padding-left: 20px;">
      <li>Pet Adoption Applications</li>
      <li>Lost &amp; Found Reports</li>
      <li>Adoption Status Tracking</li>
      <li>Saved Favorite Pets</li>
      <li>Complete Pet Profiles</li>
    </ul>
    <div class="login-modal-buttons">
      <a href="<%= ctx %>/login.jsp" class="login-modal-btn primary">
        <i class="fas fa-sign-in-alt"></i> Login Now
      </a>
      <a href="<%= ctx %>/signup.jsp" class="login-modal-btn secondary">
        <i class="fas fa-user-plus"></i> Sign Up Free
      </a>
    </div>
  </div>
</div>

<section class="hero">
  <div class="container">
    <div class="hero-stats">
      <div class="stat-box homeless">
        <span class="stat-number">32,120</span>
        <span class="stat-label">Homeless</span>
      </div>
      <div class="stat-box happy">
        <span class="stat-number">83,957</span>
        <span class="stat-label">Happy</span>
      </div>
    </div>

    <div class="hero-content">
      <h1 class="hero-title">Find Your <span>Perfect</span> Pet Companion!</h1>
      <p class="hero-subtitle">Browse pets waiting for their forever homes. Create an account to adopt or report lost pets.</p>
      <div style="margin-top: 30px; display: flex; justify-content: center; gap: 20px; flex-wrap: wrap;">
        <a href="<%= ctx %>/pets" class="btn btn-primary">
          <i class="fas fa-search"></i> Browse All Pets
        </a>
        <a href="<%= ctx %>/signup.jsp" class="btn btn-success">
          <i class="fas fa-user-plus"></i> Create Account
        </a>
      </div>
    </div>
  </div>
</section>

<main class="main-content">
  <div class="container">
    <h2 class="page-title">Featured Pets Looking for Homes</h2>

    <div class="dashboard-cards">

      <%
        if (featuredPets.isEmpty()) {
      %>
        <div style="width:100%; text-align:center; color:var(--text-light); padding:30px;">
          No available pets yet. Please add pets in Admin.
        </div>
      <%
        } else {
          for (int i=0; i<featuredPets.size(); i++) {
            Map p = featuredPets.get(i);

            int petId = ((Integer)p.get("petId")).intValue();
            String name = (p.get("name") == null ? "Pet" : p.get("name").toString());
            String type = (p.get("type") == null ? "" : p.get("type").toString());
            String breed = (p.get("breed") == null ? "" : p.get("breed").toString());
            int age = 0;
            try { age = ((Integer)p.get("age")).intValue(); } catch (Exception ignore) {}

            String desc = (p.get("description") == null ? "" : p.get("description").toString());
            if (desc.length() > 120) desc = desc.substring(0, 120) + "...";

            String statusText = (p.get("status") == null || p.get("status").toString().trim().length()==0)
                    ? "AVAILABLE"
                    : p.get("status").toString();

            String icon = "fa-dog";
            if ("cat".equalsIgnoreCase(type)) icon = "fa-cat";

            // ✅ image logic (uploads via /file, images/ direct, fallback)
            String imgPath = (p.get("imagePath") == null ? "" : p.get("imagePath").toString().trim());
            String imgUrl;

            if (imgPath.length() == 0) {
              imgUrl = ctx + "/images/pet1.jpg";
            } else if (imgPath.startsWith("http://") || imgPath.startsWith("https://")) {
              imgUrl = imgPath;
            } else if (imgPath.startsWith("uploads/") || imgPath.startsWith("/uploads/")) {
              imgUrl = ctx + "/file?path=" + java.net.URLEncoder.encode(imgPath, "UTF-8");
            } else {
              imgUrl = imgPath.startsWith("/") ? (ctx + imgPath) : (ctx + "/" + imgPath);
            }
      %>

      <!-- ✅ Guest still requires login: clicking opens modal -->
      <a href="#login-required" class="dashboard-card pets require-login" onclick="showLoginRequired(); return false;">
        <div class="card-header">
          <div class="card-icon">
            <i class="fas <%= icon %>"></i>
          </div>
          <h3 class="card-title"><%= name %><%= (breed.length()==0 ? "" : " - " + breed) %></h3>
        </div>

        <div style="width:100%; margin: 10px 0 14px;">
          <img src="<%= imgUrl %>" alt="<%= name %>"
               style="width:100%; height:180px; object-fit:cover; border-radius:12px;"
               onerror="this.src='<%= ctx %>/images/pet1.jpg'">
        </div>

        <p style="color: var(--text-light); margin-bottom: 15px;">
          <%= (desc.length()==0 ? "Login to apply for adoption." : desc) %>
        </p>

        <div class="card-stats">
          <div class="stat-item">
            <span class="stat-number"><%= age %></span>
            <span class="stat-label"><%= (age == 1 ? "Year Old" : "Years Old") %></span>
          </div>
          <div class="stat-item">
            <span class="stat-label"><%= statusText %></span>
          </div>
        </div>

        <div style="margin-top: 15px; color: var(--text-light); font-size: 14px;">
          <i class="fas fa-info-circle" style="color: var(--primary);"></i>
          <em>Login to apply for adoption</em>
        </div>
      </a>

      <%
          }
        }
      %>

    </div>

    <!-- Rest of your page stays unchanged -->
    <div style="width: 100%; background-color: white; border-radius: var(--radius); padding: 40px; box-shadow: var(--shadow-light); margin-bottom: 40px;">
      <h2 style="font-family: 'Nunito', sans-serif; font-size: 28px; font-weight: 700; color: var(--dark); text-align: center; margin-bottom: 40px;">
        <i class="fas fa-star" style="color: var(--primary); margin-right: 10px;"></i>
        Platform Features
      </h2>

      <div class="features-grid">
        <a href="<%= ctx %>/pets" class="dashboard-card" style="border-top-color: var(--accent);">
          <div class="card-header">
            <div class="card-icon" style="background-color: var(--accent);">
              <i class="fas fa-paw"></i>
            </div>
            <h3 class="card-title">Browse Pets</h3>
          </div>
          <p style="color: var(--text-light); margin-bottom: 15px;">View all available pets. No login required to browse and see pet details.</p>
          <div style="color: var(--accent); font-weight: 600; display: flex; align-items: center; gap: 5px;">
            <span>View All Pets</span>
            <i class="fas fa-arrow-right"></i>
          </div>
        </a>

        <div class="dashboard-card require-login" onclick="showLoginRequired()" style="border-top-color: var(--primary); cursor: pointer;">
          <div class="card-header">
            <div class="card-icon" style="background-color: var(--primary);">
              <i class="fas fa-heart"></i>
            </div>
            <h3 class="card-title">Adopt a Pet</h3>
          </div>
          <p style="color: var(--text-light); margin-bottom: 15px;">Apply to adopt pets. Requires login to submit adoption applications.</p>
          <div style="color: var(--primary); font-weight: 600; display: flex; align-items: center; gap: 5px;">
            <span>Login to Adopt</span>
            <i class="fas fa-lock"></i>
          </div>
        </div>

        <div class="dashboard-card require-login" onclick="showLoginRequired()" style="border-top-color: #ffc107; cursor: pointer;">
          <div class="card-header">
            <div class="card-icon" style="background-color: #ffc107;">
              <i class="fas fa-search"></i>
            </div>
            <h3 class="card-title">Lost &amp; Found</h3>
          </div>
          <p style="color: var(--text-light); margin-bottom: 15px;">Report lost pets or found animals. Requires login to submit reports.</p>
          <div style="color: #ffc107; font-weight: 600; display: flex; align-items: center; gap: 5px;">
            <span>Login to Report</span>
            <i class="fas fa-lock"></i>
          </div>
        </div>

        <a href="<%= ctx %>/articles" class="dashboard-card" style="border-top-color: var(--secondary);">
          <div class="card-header">
            <div class="card-icon" style="background-color: var(--secondary);">
              <i class="fas fa-newspaper"></i>
            </div>
            <h3 class="card-title">Rescue Articles</h3>
          </div>
          <p style="color: var(--text-light); margin-bottom: 15px;">Educational articles about pet care, training, and rescue stories.</p>
          <div style="color: var(--secondary); font-weight: 600; display: flex; align-items: center; gap: 5px;">
            <span>Read Articles</span>
            <i class="fas fa-arrow-right"></i>
          </div>
        </a>
      </div>
    </div>

  </div>
</main>

<jsp:include page="/footer.jsp" />

<!-- Modal CSS unchanged -->
<style>
  .login-modal-overlay { display: none; position: fixed; top: 0; left: 0; right: 0; bottom: 0; background: rgba(0, 0, 0, 0.7); z-index: 2000; align-items: center; justify-content: center; animation: fadeIn 0.3s ease; }
  .login-modal-overlay.show { display: flex; }
  .login-modal { background: white; border-radius: var(--radius); padding: 40px; max-width: 500px; width: 90%; text-align: center; box-shadow: var(--shadow); animation: slideUp 0.4s ease; transform: translateY(0); position: relative; }
  @keyframes slideUp { from { opacity: 0; transform: translateY(50px); } to { opacity: 1; transform: translateY(0); } }
  .login-modal-icon { font-size: 64px; color: var(--primary); margin-bottom: 20px; animation: bounce 1s infinite alternate; }
  @keyframes bounce { from { transform: translateY(0); } to { transform: translateY(-10px); } }
  .login-modal h2 { font-family: 'Nunito', sans-serif; font-size: 28px; font-weight: 800; color: var(--dark); margin-bottom: 15px; }
  .login-modal p { color: var(--text-light); font-size: 16px; line-height: 1.6; margin-bottom: 30px; }
  .login-modal-buttons { display: flex; gap: 20px; justify-content: center; margin-top: 30px; flex-wrap: wrap; }
  .login-modal-btn { padding: 15px 30px; border-radius: var(--radius); font-family: 'Poppins', sans-serif; font-weight: 600; font-size: 16px; cursor: pointer; transition: all 0.3s ease; text-decoration: none; display: inline-flex; align-items: center; justify-content: center; gap: 10px; min-width: 150px; border: none; }
  .login-modal-btn.primary { background: linear-gradient(135deg, var(--primary), var(--primary-light)); color: white; }
  .login-modal-btn.secondary { background: transparent; color: var(--primary); border: 2px solid var(--primary); }
  .login-modal-close { position: absolute; top: 20px; right: 20px; background: none; border: none; font-size: 24px; color: var(--text-light); cursor: pointer; transition: color 0.3s ease; }
</style>

<script>
  function showLoginRequired() {
    var modal = document.getElementById('loginModal');
    modal.classList.add('show');
    document.body.style.overflow = 'hidden';
    return false;
  }

  function hideLoginModal() {
    var modal = document.getElementById('loginModal');
    modal.classList.remove('show');
    document.body.style.overflow = 'auto';
  }

  document.getElementById('loginModal').addEventListener('click', function(e) {
    if (e.target === this) {
      hideLoginModal();
    }
  });

  document.addEventListener('keydown', function(e) {
    if (e.key === 'Escape') {
      hideLoginModal();
    }
  });

  document.addEventListener('DOMContentLoaded', function() {
    function animateNumbers() {
      var homelessNumber = document.querySelector('.homeless .stat-number');
      var happyNumber = document.querySelector('.happy .stat-number');

      if (homelessNumber && happyNumber) {
        var homelessCount = 0;
        var happyCount = 0;
        var homelessTarget = 32120;
        var happyTarget = 83957;
        var increment = 100;

        var timer = setInterval(function() {
          homelessCount += increment;
          happyCount += increment * 2;

          if (homelessCount >= homelessTarget) homelessCount = homelessTarget;
          if (happyCount >= happyTarget) happyCount = happyTarget;

          homelessNumber.textContent = homelessCount.toLocaleString();
          happyNumber.textContent = happyCount.toLocaleString();

          if (homelessCount >= homelessTarget && happyCount >= happyTarget) clearInterval(timer);
        }, 20);
      }
    }
    setTimeout(animateNumbers, 500);
  });
</script>

</body>
</html>
