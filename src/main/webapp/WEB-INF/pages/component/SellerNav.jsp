<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8"/>
  <title>Seller Sidebar – Cognix</title>
  <style>
    /* === Reset & Base === */
    * { box-sizing: border-box; margin: 0; padding: 0; }
    body { font-family: 'Helvetica Neue', sans-serif; background: #F1EDE9; color: #333; }

    /* === Sidebar Layout === */
    .sidebar {
      width: 280px;
      height: 100vh;
      display: flex;
      flex-direction: column;
      justify-content: space-between;
      background: #F1EDE9;
      padding: 2rem 1.5rem 1.5rem;
      overflow-x: hidden;
    }
    .sidebar__logo {
      text-align: center;
      margin-bottom: 2rem;
    }
    .sidebar__logo img {
      max-width: 100%;
      height: auto;
    }

    /* === Navigation === */
    .nav-list {
      list-style: none;
      flex-grow: 1;
      display: flex;
      flex-direction: column;
      gap: .5rem;
    }
    .nav-item {
      border-radius: .5rem;
      transition: background .2s, color .2s;
    }
    .nav-item a {
      display: flex;
      align-items: center;
      gap: .75rem;
      padding: .75rem 1rem;
      color: inherit;
      text-decoration: none;
    }
    .nav-item img.icon {
      width: 1.75rem;
      height: 1.75rem;
    }
    .nav-item:hover {
      background: #e2e2e2;
      color: #1a1a1a;
    }
    .nav-item.active {
      background: #fff;
      color: #111;
      font-weight: 600;
      border-left: 4px solid #111;
      padding-left: .75rem;
    }

    /* === Profile & Settings === */
    .sidebar__profile {
      display: flex;
      align-items: center;
      gap: .75rem;
      background: #fff;
      border-radius: 12px;
      padding: .75rem 1rem;
      cursor: pointer;
    }
    .profile-info {
      display: flex;
      align-items: center;
      gap: .75rem;
      width: 100%;
    }
    .profile-info img.avatar {
      width: 40px;
      height: 40px;
      border-radius: 50%;
      object-fit: cover;
    }
    .profile-info .text {
      display: flex;
      flex-direction: column;
    }
    .text .name {
      font-size: .9rem;
      font-weight: 600;
      color: #1a1a1a;
    }
    .text .role {
      font-size: .65rem;
      color: #666;
    }
    .profile-settings {
      margin-left: auto;
    }
    .profile-settings img {
      width: 1.75rem;
      height: 1.75rem;
    }

    /* === Modal === */
    .modal {
      position: fixed;
      inset: 0;
      background: rgba(0,0,0,0.5);
      display: none;
      align-items: center;
      justify-content: center;
      z-index: 1000;
    }
    .modal.show { display: flex; }
    .modal__content {
      background: #fff;
      border-radius: 8px;
      padding: 2rem;
      width: 16rem;
      text-align: center;
      box-shadow: 0 2px 10px rgba(0,0,0,0.2);
    }
    .modal__btn {
      display: block;
      width: 100%;
      margin: .5rem 0;
      padding: .75rem 1rem;
      border-radius: 6px;
      font-size: .95rem;
      text-decoration: none;
      text-align: center;
      transition: background .2s;
    }
    .modal__btn--update { background: #111; color: #fff; }
    .modal__btn--update:hover { background: #000; }
    .modal__btn--logout {
      background: #fff; color: #111; border: 1px solid #111;
    }
    .modal__btn--logout:hover { background: #f5f5f5; }
  </style>
</head>
<body>

<aside class="sidebar">
  <div>
    <!-- Logo -->
    <div class="sidebar__logo">
      <img src="${pageContext.request.contextPath}/nav-icons/seller-logo.svg" alt="Seller Logo"/>
    </div>

    <!-- Primary Navigation -->
    <ul class="nav-list">
      <li class="nav-item ${param.currentPage=='dashboard'?'active':''}">
        <a href="${pageContext.request.contextPath}/HomeSeller?currentPage=dashboard">
          <img class="icon" src="${pageContext.request.contextPath}/nav-icons/Home.svg" alt="Dashboard"/>
          <span>Dashboard</span>
        </a>
      </li>
      <li class="nav-item ${param.currentPage=='uploadmodel'?'active':''}">
        <a href="${pageContext.request.contextPath}/SellerModel?currentPage=uploadmodel">
          <img class="icon" src="${pageContext.request.contextPath}/nav-icons/Folder.svg" alt="Model"/>
          <span>Model</span>
        </a>
      </li>
      <li class="nav-item ${param.currentPage=='mymodels'?'active':''}">
        <a href="${pageContext.request.contextPath}/SellerOder?currentPage=mymodels">
          <img class="icon" src="${pageContext.request.contextPath}/nav-icons/seller-icons-order.svg" alt="Orders"/>
          <span>Orders</span>
        </a>
      </li>
      <li class="nav-item ${param.currentPage=='reports'?'active':''}">
        <a href="${pageContext.request.contextPath}/SellerReport?currentPage=reports">
          <img class="icon" src="${pageContext.request.contextPath}/nav-icons/File.svg" alt="Reports"/>
          <span>Report</span>
        </a>
      </li>
    </ul>

    <!-- ── Extra Links ── -->
    <ul class="nav-list" style="margin-top:1rem; border-top:1px solid #ddd; padding-top:1rem;">
      <li class="nav-item ${param.currentPage=='contact'?'active':''}">
        <a href="${pageContext.request.contextPath}/ContactUs?currentPage=contact">
          <img class="icon" src="${pageContext.request.contextPath}/nav-icons/message.svg" alt="Contact"/>
          <span>Contact</span>
        </a>
      </li>
      <li class="nav-item ${param.currentPage=='about'?'active':''}">
        <a href="${pageContext.request.contextPath}/AboutUs?currentPage=about">
          <img class="icon" src="${pageContext.request.contextPath}/nav-icons/info.svg" alt="About"/>
          <span>About</span>
        </a>
      </li>
    </ul>
  </div>

  <!-- Profile & Settings Toggle -->
  <c:set var="avatarUrl"
         value="${not empty sessionScope.user.profilePicture 
                      ? pageContext.request.contextPath.concat('/').concat(sessionScope.user.profilePicture) 
                      : 'https://i.pravatar.cc/150?img=47'}"/>
  <div class="sidebar__profile" id="profileToggle">
    <div class="profile-info">
      <img class="avatar" src="${avatarUrl}" alt="User Avatar"/>
      <div class="text">
        <div class="name">${sessionScope.user.name}</div>
        <div class="role">${sessionScope.user.about}</div>
      </div>
    </div>
    <div class="profile-settings">
      <img src="${pageContext.request.contextPath}/nav-icons/sharp.svg" alt="Settings"/>
    </div>
  </div>
</aside>

<!-- Account Modal -->
<div class="modal" id="profileModal">
  <div class="modal__content">
    <h3>Account</h3>
    <a href="${pageContext.request.contextPath}/Profile?currentPage=Profile" class="modal__btn modal__btn--update">Update Profile</a>
    <a href="${pageContext.request.contextPath}/logout" class="modal__btn modal__btn--logout">Logout</a>
  </div>
</div>

<script>
  const toggle = document.getElementById('profileToggle');
  const modal  = document.getElementById('profileModal');
  toggle.addEventListener('click', () => modal.classList.toggle('show'));
  modal.addEventListener('click', e => {
    if (e.target === modal) modal.classList.remove('show');
  });
</script>

</body>
</html>
