<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core"       %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"        %>
<%@ taglib prefix="fn"  uri="http://java.sun.com/jsp/jstl/functions"  %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8"/>
  <title>My Profile – Cognix</title>
  <!-- Font Awesome -->
  <link
    rel="stylesheet"
    href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css"
    crossorigin="anonymous"
    referrerpolicy="no-referrer"
  />
  
  <style>
    /* === your existing CSS (unchanged) === */
	* { box-sizing: border-box; margin: 0; padding: 0; }
	body { font-family: 'Helvetica Neue', sans-serif; background: #F1EDE9; color: #333; }
	.main { display: flex; max-width: 1440px; margin: 0 auto; padding: 0 1.5rem; min-height: 100vh; }
	.nav { width: 240px; margin-right: 2rem; }
	.content { flex: 1; overflow-y: auto; }
	.search-wrapper { padding: 1rem 0; }
	.profile-section { background: #fff; padding: 2rem; border-radius: 12px; box-shadow: 0 2px 8px rgba(0,0,0,0.05); }
	.profile-section h2 { font-size: 1.5rem; margin-bottom: 0.5rem; }
	.subtitle { color: #888; font-size: 0.95rem; margin-bottom: 1.5rem; }
	.profile-form { display: grid; grid-template-columns: 200px 1fr auto; column-gap: 24px; row-gap: 1.5rem; align-items: start; }
	.label-cell { grid-column: 1; text-align: right; padding-top: .4rem; font-weight: 500; text-transform: capitalize; }
	.help-text { display: block; margin-top: .25rem; color: #aaa; font-size: .85rem; }
	.upload-area { grid-column: 2; max-width: 23rem; height: 140px; border: 2px dashed #ddd; border-radius: 8px;
	               display: flex; flex-direction: column; align-items: center; justify-content: center;
	               color: #888; position: relative; cursor: pointer; transition: background .2s; }
	.upload-area:hover { background: #fafafa; }
	.upload-area input { position: absolute; width: 100%; height: 100%; top: 0; left: 0; opacity: 0; cursor: pointer; }
	.upload-area .fa-cloud-upload-alt { font-size: 1.8rem; margin-bottom: .5rem; }
	.upload-area .text { text-align: center; font-size: .95rem; line-height: 1.2; }
	.avatar-preview { grid-column: 3; display: flex; align-items: flex-start; }
	.avatar-preview img { width: 120px; height: 120px; border-radius: 50%; object-fit: cover; border: 2px solid #eee; }
	.input-cell { grid-column: 2 / span 2; }
	.input-cell input, .input-cell select { width: 100%; max-width: 32rem; height: 2.5rem; padding: 0 1rem;
	                                        border: 1px solid #ccc; border-radius: 8px; font-size: 1rem; background: #fff;
	                                        transition: border-color .2s; }
	.input-cell input:focus, .input-cell select:focus { outline: none; border-color: #888; }
	.with-icon { position: relative; }
	.with-icon .fa-envelope { position: absolute; left: 1rem; top: 50%; transform: translateY(-50%); color: #888; }
	.with-icon input { padding-left: 2.5rem; }
	.date-picker { position: relative; width: 100%; }
	.date-picker input[type="date"] { appearance: textfield; width: 100%; height: 2.5rem; padding: 0 1rem;
	                                   padding-right: 2.5rem; border: 1px solid #ccc; border-radius: 8px;
	                                   font-size: 1rem; background: #fff; transition: border-color .2s; }
	.date-picker input[type="date"]::-webkit-calendar-picker-indicator { opacity: 0; position: absolute;
	                                                                      top: 0; right: 0; width: 2.5rem; height: 100%;
	                                                                      cursor: pointer; z-index: 2; }
	.date-picker i { position: absolute; right: 1rem; top: 50%; transform: translateY(-50%); color: #888; pointer-events: none; }
	.form-actions { grid-column: 2 / span 2; display: flex; justify-content: flex-end; margin-top: 1.5rem; }
	.btn { padding: .6rem 1.2rem; border-radius: 8px; font-size: 1rem; cursor: pointer; background: #333; border: none; color: #fff; transition: background .2s; }
	.toast { position: fixed; top:20px; right:20px; background:#28a745; color:#fff; padding:12px 20px;
	         border-radius:8px; box-shadow:0 4px 8px rgba(0,0,0,0.2); opacity:0; transform:translateY(-20px);
	         transition:opacity .4s, transform .4s; z-index:9999; }
	.toast.show { opacity:1; transform:translateY(0); }
	@media(max-width:800px) {
	  .main { flex-direction: column; }
	  .nav { margin-bottom:1.5rem; }
	  .profile-form { grid-template-columns: 1fr; }
	  .avatar-preview { justify-content: center; }
	  .form-actions { justify-content: center; }
	}
  </style>
</head>
<body>
  <div class="main">
    <!-- Sidebar Navigation -->
    <div class="nav">
      <c:choose>
        <c:when test="${sessionScope.role == 'admin'}">
          <jsp:include page="/WEB-INF/pages/component/AdminNav.jsp"/>
        </c:when>
        <c:when test="${sessionScope.role == 'seller'}">
          <jsp:include page="/WEB-INF/pages/component/SellerNav.jsp"/>
        </c:when>
        <c:otherwise>
          <jsp:include page="/WEB-INF/pages/component/BuyerNav.jsp"/>
        </c:otherwise>
      </c:choose>
    </div>

    <!-- Main Content -->
    <div class="content">
      <div class="search-wrapper">
        <jsp:include page="/WEB-INF/pages/component/SerachBar.jsp"/>
      </div>

      <section class="profile-section">
        <h2>Personal info</h2>
        <p class="subtitle">Update your photo and personal details here.</p>

        <!-- Validation Error Banner -->
        <c:if test="${not empty error}">
          <div style="
            margin-bottom:1rem;
            padding:.75rem;
            background:#f8d7da;
            color:#842029;
            border-radius:8px;
            font-weight:500;">
            ${error}
          </div>
        </c:if>

        <!-- Success Toast -->
        <c:if test="${param.success == '1'}">
          <div id="toast" class="toast show">Profile updated successfully!</div>
        </c:if>

        <form class="profile-form"
              action="<c:url value='/Profile'/>"
              method="post"
              enctype="multipart/form-data">

          <!-- Photo Upload -->
          <div class="label-cell">
            <label>Your Photo</label>
            <span class="help-text">This will be displayed on your profile.</span>
          </div>
          <div class="upload-area" onclick="avatarInput.click()">
            <i class="fas fa-cloud-upload-alt"></i>
            <div class="text">
              <strong>Click to upload</strong><br/>
              or drag and drop<br/>
              SVG, PNG, JPG or GIF
            </div>
            <input id="avatarInput" type="file" name="avatar" accept="image/*"/>
          </div>
          <div class="avatar-preview">
            <c:choose>
              <c:when test="${not empty profile.profilePicture}">
                <img id="avatarImg" src="${pageContext.request.contextPath}/${profile.profilePicture}" alt="Profile Photo"/>
              </c:when>
              <c:otherwise>
                <img id="avatarImg" src="${pageContext.request.contextPath}/uploads/default-avatar.png" alt="Default Avatar"/>
              </c:otherwise>
            </c:choose>
          </div>

          <!-- Username -->
          <div class="label-cell"><label for="username">Username</label></div>
          <div class="input-cell">
            <input id="username" name="username" type="text"
                   value="${fn:escapeXml(profile.username)}"/>
          </div>

          <!-- Name -->
          <div class="label-cell"><label for="name">Name</label></div>
          <div class="input-cell">
            <input id="name" name="name" type="text"
                   value="${fn:escapeXml(profile.name)}"/>
          </div>

          <!-- Email -->
          <div class="label-cell"><label for="email">Email Address</label></div>
          <div class="input-cell with-icon">
            <i class="fas fa-envelope"></i>
            <input id="email" name="email" type="email"
                   value="${fn:escapeXml(profile.email)}"/>
          </div>

          <!-- About -->
          <div class="label-cell"><label for="about">About</label></div>
          <div class="input-cell">
            <input id="about" name="about" type="text"
                   value="${fn:escapeXml(profile.about)}"/>
          </div>

          <!-- Date of Birth -->
          <div class="label-cell"><label for="dob">Date of Birth</label></div>
          <div class="input-cell">
            <div class="date-picker">
              <input id="dob" name="dob" type="date"
                     value="<fmt:formatDate value='${profile.dob}' pattern='yyyy-MM-dd'/>"/>
              <i class="fas fa-calendar-alt"></i>
            </div>
          </div>

          <!-- New Password -->
          <div class="label-cell"><label for="password">New Password</label></div>
          <div class="input-cell">
            <input id="password" name="password" type="password" placeholder="Enter new password"/>
          </div>

          <!-- Save Button -->
          <div class="form-actions">
            <button type="submit" class="btn">Save</button>
          </div>
        </form>
      </section>
    </div>
  </div>

  <script>
    // live avatar preview
    const avatarInput = document.getElementById('avatarInput');
    const avatarImg   = document.getElementById('avatarImg');
    if (avatarInput) {
      avatarInput.addEventListener('change', e => {
        const file = e.target.files[0];
        if (!file) return;
        const reader = new FileReader();
        reader.onload = () => avatarImg.src = reader.result;
        reader.readAsDataURL(file);
      });
    }
    // hide toast after 3s
    window.addEventListener('load', () => {
      const t = document.getElementById('toast');
      if (t) setTimeout(() => t.classList.remove('show'), 3000);
    });
  </script>
</body>
</html>
