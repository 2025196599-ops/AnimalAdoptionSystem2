<%-- 
    Document   : found-report
    Created on : Jan 18, 2026
    Author     : User
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="javax.servlet.http.HttpSession" %>
<%@ page import="com.ariniqo.model.User" %>

<%
    String ctx = request.getContextPath();

    HttpSession s = request.getSession(false);
    User user = (s == null) ? null : (User) s.getAttribute("user");

    boolean loggedIn = (user != null);

    String userName = (user != null && user.getName() != null) ? user.getName() : "";
    String userEmail = (user != null && user.getEmail() != null) ? user.getEmail() : "";
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <title>Report Found Animal - Ariniqo Buddies</title>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />

    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Nunito:wght@400;600;700;800&family=Poppins:wght@300;400;500;600&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="<%= ctx %>/css/user-style.css">
    <link rel="stylesheet" href="<%= ctx %>/css/found-report.css">

<style>
/* ===== Professional upgrades (safe override) ===== */
.fr-page { max-width: 1120px; margin: 0 auto; padding: 26px 16px 60px; }
.fr-hero {
    background: linear-gradient(135deg, rgba(93,106,251,.12), rgba(255,126,95,.10));
    border: 1px solid rgba(0,0,0,.06);
    border-radius: 22px;
    padding: 26px 22px;
    box-shadow: 0 14px 35px rgba(0,0,0,.06);
    margin-bottom: 18px;
}
.fr-hero h1 { margin: 0 0 8px; font-size: 30px; font-weight: 900; font-family: 'Nunito', sans-serif; }
.fr-hero p { margin: 0; color: var(--text-light); line-height: 1.6; }
.fr-hero .hint {
    margin-top: 14px;
    display:flex; flex-wrap:wrap; gap:10px;
    color:#444; font-size:13px;
}
.fr-pill {
    background: rgba(255,255,255,.7);
    border: 1px solid rgba(0,0,0,.06);
    padding: 8px 12px;
    border-radius: 999px;
    display:inline-flex;
    align-items:center;
    gap:8px;
}

/* Stepper */
.fr-stepper {
    background: white;
    border: 1px solid rgba(0,0,0,.06);
    border-radius: 20px;
    padding: 14px 14px;
    box-shadow: 0 10px 25px rgba(0,0,0,.06);
    margin-bottom: 18px;
}
.progress-steps { display:flex; align-items:center; justify-content:space-between; gap: 10px; }
.step {
    display:flex; align-items:center; gap: 10px;
    padding: 10px 12px;
    border-radius: 14px;
    transition: all .25s ease;
    flex: 1;
    min-width: 0;
}
.step-number {
    width: 34px; height: 34px;
    border-radius: 10px;
    display:flex; align-items:center; justify-content:center;
    font-weight: 800;
    background: #f2f4ff;
    color: #5d6afb;
}
.step-label { font-weight: 700; color:#333; white-space:nowrap; overflow:hidden; text-overflow:ellipsis; }
.step-line { flex: 0 0 28px; height: 2px; background: #e9ecff; border-radius: 999px; }
.step.active { background: rgba(93,106,251,.10); border: 1px solid rgba(93,106,251,.18); }
.step.active .step-number { background: #5d6afb; color: white; }
.step.completed { opacity: .75; }
@media (max-width: 900px) {
    .step-line { display:none; }
    .progress-steps { flex-wrap: wrap; }
    .step { flex: 1 1 calc(50% - 10px); }
}

/* Form container */
.fr-card {
    background: white;
    border-radius: 22px;
    border: 1px solid rgba(0,0,0,.06);
    box-shadow: 0 14px 35px rgba(0,0,0,.07);
    overflow: hidden;
}
.fr-card-head {
    padding: 18px 22px;
    border-bottom: 1px solid rgba(0,0,0,.06);
    background: linear-gradient(135deg, rgba(255,126,95,.08), rgba(93,106,251,.06));
}
.fr-card-head h2 { margin:0; font-size: 18px; font-weight: 900; }
.fr-card-body { padding: 22px; }

/* Step headers */
.step-header { margin-bottom: 18px; }
.step-title { margin: 0 0 6px; font-size: 22px; font-weight: 900; display:flex; gap:10px; align-items:center; }
.step-icon {
    width: 34px; height: 34px;
    border-radius: 10px;
    display:flex; align-items:center; justify-content:center;
    background: rgba(255,126,95,.12);
    color: #ff7e5f;
    font-weight: 900;
}
.step-description { margin:0; color: var(--text-light); }

/* Sections */
.form-section {
    border: 1px solid rgba(0,0,0,.06);
    border-radius: 18px;
    padding: 18px;
    background: #fbfcff;
    margin-bottom: 18px;
}
.section-title { margin:0 0 12px; font-size: 16px; font-weight: 900; display:flex; gap:10px; align-items:center; }

/* Inputs */
.form-group label { font-weight: 700; color:#333; }
input[type="text"], input[type="email"], input[type="tel"], input[type="date"], input[type="time"], select, textarea {
    border-radius: 14px !important;
    border: 1px solid rgba(0,0,0,.10) !important;
    padding: 12px 12px !important;
    background: white !important;
    outline: none;
}
textarea { resize: vertical; }

/* Radio cards */
.radio-option { border-radius: 16px !important; }
.radio-content {
    border-radius: 16px;
    transition: transform .2s ease, box-shadow .2s ease;
}
.radio-option:hover .radio-content { transform: translateY(-2px); box-shadow: 0 10px 20px rgba(0,0,0,.07); }

/* Suggestions */
.breed-suggestions { display:flex; flex-wrap:wrap; gap:10px; margin-top: 10px; }
.suggestion-tag {
    background: white;
    border: 1px solid rgba(0,0,0,.08);
    padding: 8px 12px;
    border-radius: 999px;
    font-weight: 700;
    font-size: 12px;
    cursor: pointer;
    transition: all .2s ease;
}
.suggestion-tag:hover { transform: translateY(-2px); box-shadow: 0 10px 18px rgba(0,0,0,.06); }

/* Photo upload */
.photo-upload-area {
    border-radius: 18px !important;
    border: 2px dashed rgba(93,106,251,.35) !important;
    background: rgba(93,106,251,.06);
    padding: 20px !important;
    transition: all .2s ease;
}
.photo-upload-area:hover { background: rgba(93,106,251,.09); }
.upload-placeholder i { font-size: 34px; color:#5d6afb; }
.uploaded-photos img { border-radius: 14px !important; border: 1px solid rgba(0,0,0,.08); }

/* Actions */
.form-actions {
    display:flex; gap: 12px; justify-content: flex-end; flex-wrap: wrap;
    margin-top: 12px;
}
.btn-next, .btn-prev, .btn-submit {
    border-radius: 999px !important;
    padding: 12px 18px !important;
    font-weight: 800 !important;
    display:inline-flex; align-items:center; gap: 10px;
    border: none;
    cursor: pointer;
}
.btn-prev { background: rgba(0,0,0,.06); }
.btn-next { background: #5d6afb; color: white; }
.btn-next:hover { filter: brightness(0.96); }
.btn-submit { background: #ff7e5f; color: white; }
.btn-submit:hover { filter: brightness(0.96); }

/* Review boxes */
.review-section {
    border: 1px solid rgba(0,0,0,.06);
    border-radius: 18px;
    padding: 16px;
    background: #fbfcff;
    margin-bottom: 14px;
}
.review-title { margin: 0 0 10px; font-weight: 900; }
.review-item { display:flex; justify-content:space-between; gap: 12px; padding: 8px 0; border-bottom: 1px dashed rgba(0,0,0,.10); }
.review-item:last-child { border-bottom:none; }
.review-label { color:#555; font-weight: 800; }
.review-value { color:#333; }

/* Login warning */
.fr-login-warning {
    margin-top: 14px;
    padding: 12px 14px;
    border-radius: 16px;
    border: 1px solid rgba(255,126,95,.25);
    background: rgba(255,126,95,.08);
    color:#8a3b2a;
    display:flex; gap:10px; align-items:flex-start;
}
/* ✅ FIX: prevent icon overlapping input text */
.input-with-icon{
  position: relative;
  width: 100%;
}

.input-with-icon i{
  position: absolute;
  left: 14px;
  top: 50%;
  transform: translateY(-50%);
  color: #9aa3af;
  pointer-events: none;
  font-size: 14px;
}

.input-with-icon input{
  width: 100%;
  padding-left: 44px !important;   /* space for icon */
  line-height: 1.2;
  height: 46px;                   /* consistent height */
  box-sizing: border-box;
}

</style>
</head>

<body>
<jsp:include page="/user/user-navBar.jsp" />

<main class="main-content">
    <div class="fr-page">

        <!-- HERO -->
        <div class="fr-hero">
            <h1><i class="fas fa-hand-holding-heart"></i> Report Found Animal</h1>
            <p>Help reunite a lost pet with its owner by submitting accurate details and a clear photo.</p>

            <div class="hint">
                <span class="fr-pill"><i class="fas fa-lightbulb"></i> Tip: Include clear face + full body photo</span>
                <span class="fr-pill"><i class="fas fa-map-marker-alt"></i> Tip: Write the exact area / landmark</span>
                <span class="fr-pill"><i class="fas fa-clock"></i> Tip: Fill date & time found</span>
            </div>

            <% if (!loggedIn) { %>
                <div class="fr-login-warning">
                    <i class="fas fa-lock" style="margin-top:2px;"></i>
                    <div>
                        <strong>Login required to submit.</strong><br>
                        You can fill the form first, but you must login before submitting.
                    </div>
                </div>
            <% } %>
        </div>

        <!-- STEPPER -->
        <div class="fr-stepper">
            <div class="progress-steps">
                <div class="step active"><div class="step-number">1</div><div class="step-label">Pet Details</div></div>
                <div class="step-line"></div>
                <div class="step"><div class="step-number">2</div><div class="step-label">Location & Time</div></div>
                <div class="step-line"></div>
                <div class="step"><div class="step-number">3</div><div class="step-label">Contact Info</div></div>
                <div class="step-line"></div>
                <div class="step"><div class="step-number">4</div><div class="step-label">Review & Submit</div></div>
            </div>
        </div>

        <!-- FORM CARD -->
        <div class="fr-card">
            <div class="fr-card-head">
                <h2><i class="fas fa-clipboard-list"></i> Found Report Form</h2>
            </div>

            <div class="fr-card-body">
                <form id="foundReportForm" action="<%= ctx %>/reports/found" method="post" enctype="multipart/form-data">

                    <!-- Step 1 -->
                    <div class="form-step active" id="step1">
                        <div class="step-header">
                            <h2 class="step-title"><span class="step-icon">1</span> Animal Information</h2>
                            <p class="step-description">Tell us about the animal you found.</p>
                        </div>

                        <div class="form-section">
                            <h3 class="section-title"><i class="fas fa-paw"></i> Basic Information</h3>

                            <div class="form-row">
                                <div class="form-group">
                                    <label><i class="fas fa-cat"></i> Animal Type</label>
                                    <div class="radio-group">
                                        <label class="radio-option">
                                            <input type="radio" name="animalType" value="dog" required>
                                            <div class="radio-content"><i class="fas fa-dog"></i><span>Dog</span></div>
                                        </label>
                                        <label class="radio-option">
                                            <input type="radio" name="animalType" value="cat">
                                            <div class="radio-content"><i class="fas fa-cat"></i><span>Cat</span></div>
                                        </label>
                                        <label class="radio-option">
                                            <input type="radio" name="animalType" value="other">
                                            <div class="radio-content"><i class="fas fa-dove"></i><span>Other</span></div>
                                        </label>
                                    </div>
                                </div>
                            </div>

                            <div class="form-row">
                                <div class="form-group">
                                    <label for="breed"><i class="fas fa-dna"></i> Breed (if known)</label>
                                    <div class="input-with-icon">
                                        <i class="fas fa-search"></i>
                                        <input type="text" id="breed" name="breed">
                                    </div>
                                    <div class="breed-suggestions">
                                        <span class="suggestion-tag">Persian</span>
                                        <span class="suggestion-tag">Siamese</span>
                                        <span class="suggestion-tag">Golden Retriever</span>
                                        <span class="suggestion-tag">Local Breed</span>
                                        <span class="suggestion-tag">Mixed Breed</span>
                                        <span class="suggestion-tag">Unknown</span>
                                    </div>
                                </div>
                            </div>

                            <div class="form-row">
                                <div class="form-group">
                                    <label><i class="fas fa-ruler-combined"></i> Size</label>
                                    <div class="radio-group horizontal">
                                        <label class="radio-option">
                                            <input type="radio" name="size" value="small" required>
                                            <div class="radio-content"><i class="fas fa-weight"></i><span>Small</span><small>(Under 10kg)</small></div>
                                        </label>
                                        <label class="radio-option">
                                            <input type="radio" name="size" value="medium">
                                            <div class="radio-content"><i class="fas fa-weight"></i><span>Medium</span><small>(10-25kg)</small></div>
                                        </label>
                                        <label class="radio-option">
                                            <input type="radio" name="size" value="large">
                                            <div class="radio-content"><i class="fas fa-weight"></i><span>Large</span><small>(Over 25kg)</small></div>
                                        </label>
                                    </div>
                                </div>
                            </div>

                            <div class="form-row">
                                <div class="form-group">
                                    <label for="color"><i class="fas fa-palette"></i> Color/Markings</label>
                                    <input type="text" id="color" name="color">
                                </div>
                                <div class="form-group">
                                    <label for="gender"><i class="fas fa-venus-mars"></i> Gender</label>
                                    <select id="gender" name="gender">
                                        <option value="">Select gender</option>
                                        <option value="male">Male</option>
                                        <option value="female">Female</option>
                                        <option value="unknown">Unknown</option>
                                    </select>
                                </div>
                            </div>
                        </div>

                        <div class="form-section">
                            <h3 class="section-title"><i class="fas fa-clipboard-check"></i> Health & Condition</h3>

                            <div class="form-row">
                                <div class="form-group">
                                    <label><i class="fas fa-heartbeat"></i> Overall Condition</label>
                                    <div class="radio-group horizontal">
                                        <label class="radio-option">
                                            <input type="radio" name="condition" value="healthy" required>
                                            <div class="radio-content"><i class="fas fa-smile"></i><span>Healthy</span></div>
                                        </label>
                                        <label class="radio-option">
                                            <input type="radio" name="condition" value="injured">
                                            <div class="radio-content"><i class="fas fa-band-aid"></i><span>Injured</span></div>
                                        </label>
                                        <label class="radio-option">
                                            <input type="radio" name="condition" value="sick">
                                            <div class="radio-content"><i class="fas fa-hospital"></i><span>Sick</span></div>
                                        </label>
                                    </div>
                                </div>
                            </div>

                            <div class="form-group">
                                <label for="injuries"><i class="fas fa-first-aid"></i> Visible Injuries or Issues</label>
                                <textarea id="injuries" name="injuries" rows="3"></textarea>
                            </div>
                        </div>

                        <div class="form-section">
                            <h3 class="section-title"><i class="fas fa-camera"></i> Upload Photos</h3>
                            <p class="section-description" style="margin:0 0 12px; color:var(--text-light);">
                                Clear photos help owners identify their pets faster.
                            </p>

                            <div class="photo-upload-area" id="photoUploadArea">
                                <div class="upload-placeholder">
                                    <i class="fas fa-cloud-upload-alt"></i>
                                    <p style="margin:8px 0 0; font-weight:800;">Click to upload photos</p>
                                    <small style="color:var(--text-light);">JPEG, PNG up to 5MB each</small>
                                </div>
                                <input type="file" id="photoUpload" name="photos" accept="image/*" multiple style="display: none;">
                            </div>

                            <div class="uploaded-photos" id="uploadedPhotos"></div>
                        </div>

                        <div class="form-actions">
                            <button type="button" class="btn-next" onclick="nextStep()">
                                Next: Location & Time <i class="fas fa-arrow-right"></i>
                            </button>
                        </div>
                    </div>

                    <!-- Step 2 -->
                    <div class="form-step" id="step2">
                        <div class="step-header">
                            <h2 class="step-title"><span class="step-icon">2</span> Where & When Found</h2>
                            <p class="step-description">Tell us where and when you found the animal.</p>
                        </div>

                        <div class="form-section">
                            <h3 class="section-title"><i class="fas fa-map-marker-alt"></i> Location Details</h3>

                            <div class="form-group">
                                <label for="foundAddress"><i class="fas fa-home"></i> Found Address</label>
                                <input type="text" id="foundAddress" name="foundAddress">
                            </div>

                            <div class="form-row">
                                <div class="form-group">
                                    <label for="area"><i class="fas fa-map"></i> Area/Neighborhood</label>
                                    <input type="text" id="area" name="area">
                                </div>
                                <div class="form-group">
                                    <label for="city"><i class="fas fa-city"></i> City</label>
                                    <input type="text" id="city" name="city" value="Kuala Lumpur">
                                </div>
                            </div>

                            <div class="form-row">
                                <div class="form-group">
                                    <label for="state"><i class="fas fa-flag"></i> State</label>
                                    <select id="state" name="state">
                                        <option value="">Select state</option>
                                        <option value="kuala-lumpur">Kuala Lumpur</option>
                                        <option value="selangor">Selangor</option>
                                        <option value="putrajaya">Putrajaya</option>
                                        <option value="johor">Johor</option>
                                        <option value="penang">Penang</option>
                                        <option value="perak">Perak</option>
                                        <option value="kedah">Kedah</option>
                                    </select>
                                </div>
                                <div class="form-group">
                                    <label for="postcode"><i class="fas fa-mail-bulk"></i> Postcode</label>
                                    <input type="text" id="postcode" name="postcode">
                                </div>
                            </div>
                        </div>

                        <div class="form-section">
                            <h3 class="section-title"><i class="fas fa-calendar-alt"></i> Time Found</h3>

                            <div class="form-row">
                                <div class="form-group">
                                    <label for="foundDate"><i class="fas fa-calendar"></i> Date Found</label>
                                    <input type="date" id="foundDate" name="foundDate">
                                </div>
                                <div class="form-group">
                                    <label for="foundTime"><i class="fas fa-clock"></i> Approximate Time</label>
                                    <input type="time" id="foundTime" name="foundTime">
                                </div>
                            </div>

                            <div class="form-actions">
                                <button type="button" class="btn-prev" onclick="prevStep()">
                                    <i class="fas fa-arrow-left"></i> Previous
                                </button>
                                <button type="button" class="btn-next" onclick="nextStep()">
                                    Next: Contact Information <i class="fas fa-arrow-right"></i>
                                </button>
                            </div>
                        </div>
                    </div>

                    <!-- Step 3 -->
                    <div class="form-step" id="step3">
                        <div class="step-header">
                            <h2 class="step-title"><span class="step-icon">3</span> Your Contact Information</h2>
                            <p class="step-description">How can the owner reach you?</p>
                        </div>

                        <div class="form-section">
                            <div class="form-row">
                                <div class="form-group">
                                    <label for="finderName"><i class="fas fa-user-circle"></i> Your Name</label>
                                    <input type="text" id="finderName" name="finderName" value="<%= userName %>">
                                </div>
                                <div class="form-group">
                                    <label for="finderEmail"><i class="fas fa-envelope"></i> Email Address</label>
                                    <input type="email" id="finderEmail" name="finderEmail" value="<%= userEmail %>">
                                </div>
                            </div>

                            <div class="form-row">
                                <div class="form-group">
                                    <label for="finderPhone"><i class="fas fa-phone"></i> Phone Number</label>
                                    <input type="tel" id="finderPhone" name="finderPhone">
                                </div>
                            </div>
                        </div>

                        <div class="form-actions">
                            <button type="button" class="btn-prev" onclick="prevStep()">
                                <i class="fas fa-arrow-left"></i> Previous
                            </button>
                            <button type="button" class="btn-next" onclick="nextStep()">
                                Next: Review & Submit <i class="fas fa-arrow-right"></i>
                            </button>
                        </div>
                    </div>

                    <!-- Step 4 -->
                    <div class="form-step" id="step4">
                        <div class="step-header">
                            <h2 class="step-title"><span class="step-icon">4</span> Review & Submit Report</h2>
                            <p class="step-description">Review all information before submitting.</p>
                        </div>

                        <div class="review-section">
                            <h3 class="review-title"><i class="fas fa-paw"></i> Found Animal Details</h3>
                            <div class="review-content" id="reviewPetDetails"></div>
                        </div>

                        <div class="review-section">
                            <h3 class="review-title"><i class="fas fa-map-marker-alt"></i> Location & Time</h3>
                            <div class="review-content" id="reviewLocation"></div>
                        </div>

                        <div class="review-section">
                            <h3 class="review-title"><i class="fas fa-user"></i> Your Information</h3>
                            <div class="review-content" id="reviewContact"></div>
                        </div>

                        <div class="form-actions">
                            <button type="button" class="btn-prev" onclick="prevStep()">
                                <i class="fas fa-arrow-left"></i> Previous
                            </button>
                            <button type="button" class="btn-submit" id="submitBtn" onclick="submitForm()">
                                <i class="fas fa-paper-plane"></i> Submit Found Report
                            </button>
                        </div>
                    </div>

                </form>
            </div>
        </div>

    </div>
</main>

<jsp:include page="/user/user-footer.jsp" />

<script>
var IS_LOGGED_IN = <%= loggedIn ? "true" : "false" %>;

var currentStep = 0;
var steps = document.querySelectorAll('.form-step');
var progressSteps = document.querySelectorAll('.progress-steps .step');

document.addEventListener('DOMContentLoaded', function() {
    var today = new Date().toISOString().split('T')[0];
    var foundDateInput = document.getElementById('foundDate');
    if (foundDateInput) foundDateInput.value = today;

    var now = new Date();
    var foundTimeInput = document.getElementById('foundTime');
    if (foundTimeInput) {
        foundTimeInput.value = now.getHours().toString().padStart(2, '0') + ':' + now.getMinutes().toString().padStart(2, '0');
    }

    var photoUploadArea = document.getElementById('photoUploadArea');
    var photoUploadInput = document.getElementById('photoUpload');
    var uploadedPhotos = document.getElementById('uploadedPhotos');

    if (photoUploadArea && photoUploadInput) {
        photoUploadArea.addEventListener('click', function() {
            photoUploadInput.click();
        });

        photoUploadInput.addEventListener('change', function(e) {
            var files = e.target.files;
            if (!uploadedPhotos) return;

            uploadedPhotos.innerHTML = '';
            for (var i=0; i<files.length; i++) {
                (function(file){
                    var reader = new FileReader();
                    reader.onload = function(ev) {
                        var img = document.createElement('img');
                        img.src = ev.target.result;
                        img.style.width = '110px';
                        img.style.height = '110px';
                        img.style.objectFit = 'cover';
                        img.style.margin = '6px';
                        img.style.borderRadius = '14px';
                        img.style.border = '1px solid rgba(0,0,0,.08)';
                        uploadedPhotos.appendChild(img);
                    };
                    reader.readAsDataURL(file);
                })(files[i]);
            }
        });
    }

    var tags = document.querySelectorAll('.suggestion-tag');
    for (var t=0; t<tags.length; t++) {
        tags[t].addEventListener('click', function() {
            var b = document.getElementById('breed');
            if (b) b.value = this.textContent;
        });
    }
});

function saveStepData() {
    var currentStepElement = steps[currentStep];
    var inputs = currentStepElement.querySelectorAll('input, select, textarea');

    for (var i=0; i<inputs.length; i++) {
        var input = inputs[i];

        if (input.type === 'checkbox') {
            localStorage.setItem(input.name, input.checked ? '1' : '0');
        } else if (input.type === 'radio') {
            if (input.checked) localStorage.setItem(input.name, input.value);
        } else if (input.type !== 'file') {
            localStorage.setItem(input.name, input.value);
        }
    }
}

function updateReviewSections() {
    var petDetails = document.getElementById('reviewPetDetails');
    if (petDetails) {
        petDetails.innerHTML =
            '<div class="review-item"><div class="review-label">Animal Type:</div><div class="review-value">' + (localStorage.getItem('animalType') || 'Not specified') + '</div></div>' +
            '<div class="review-item"><div class="review-label">Breed:</div><div class="review-value">' + (localStorage.getItem('breed') || 'Unknown') + '</div></div>' +
            '<div class="review-item"><div class="review-label">Size:</div><div class="review-value">' + (localStorage.getItem('size') || 'Not specified') + '</div></div>' +
            '<div class="review-item"><div class="review-label">Color:</div><div class="review-value">' + (localStorage.getItem('color') || 'Not specified') + '</div></div>';
    }

    var locationReview = document.getElementById('reviewLocation');
    if (locationReview) {
        var area = localStorage.getItem('area') || '';
        var city = localStorage.getItem('city') || '';
        locationReview.innerHTML =
            '<div class="review-item"><div class="review-label">Location:</div><div class="review-value">' + (area + ' ' + city).trim() + '</div></div>' +
            '<div class="review-item"><div class="review-label">Date Found:</div><div class="review-value">' + (localStorage.getItem('foundDate') || 'Not specified') + '</div></div>';
    }

    var contactReview = document.getElementById('reviewContact');
    if (contactReview) {
        contactReview.innerHTML =
            '<div class="review-item"><div class="review-label">Name:</div><div class="review-value">' + (localStorage.getItem('finderName') || 'Not specified') + '</div></div>' +
            '<div class="review-item"><div class="review-label">Phone:</div><div class="review-value">' + (localStorage.getItem('finderPhone') || 'Not specified') + '</div></div>' +
            '<div class="review-item"><div class="review-label">Email:</div><div class="review-value">' + (localStorage.getItem('finderEmail') || 'Not specified') + '</div></div>';
    }
}

window.nextStep = function() {
    var currentStepElement = steps[currentStep];
    var requiredInputs = currentStepElement.querySelectorAll('[required]');
    for (var i=0; i<requiredInputs.length; i++) {
        var el = requiredInputs[i];
        if (el.type === 'radio') {
            var group = currentStepElement.querySelectorAll('input[type="radio"][name="'+el.name+'"]');
            var ok = false;
            for (var j=0; j<group.length; j++) if (group[j].checked) ok = true;
            if (!ok) { alert('Please complete required fields before continuing.'); return; }
        } else if (!el.value) {
            alert('Please complete required fields before continuing.');
            return;
        }
    }

    saveStepData();

    steps[currentStep].classList.remove('active');
    progressSteps[currentStep].classList.remove('active');

    currentStep++;

    steps[currentStep].classList.add('active');
    progressSteps[currentStep].classList.add('active');

    if (currentStep > 0) progressSteps[currentStep - 1].classList.add('completed');

    window.scrollTo(0, 0);

    if (currentStep === 3) updateReviewSections();
};

window.prevStep = function() {
    steps[currentStep].classList.remove('active');
    progressSteps[currentStep].classList.remove('active');
    progressSteps[currentStep].classList.remove('completed');

    currentStep--;

    steps[currentStep].classList.add('active');
    progressSteps[currentStep].classList.add('active');

    window.scrollTo(0, 0);
};

window.submitForm = function() {
    if (!IS_LOGGED_IN) {
        alert('Please login to submit a report.');
        window.location.href = '<%= ctx %>/login.jsp';
        return;
    }

    var submitBtn = document.getElementById('submitBtn');
    if (submitBtn) {
        submitBtn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Submitting...';
        submitBtn.disabled = true;
    }

    document.getElementById('foundReportForm').submit();
};
</script>

</body>
</html>