<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8"/>
  <title>Admin Side Nav</title>
  <style>
    * { box-sizing: border-box; margin: 0; padding: 0; }
    body { font-family:'Helvetica Neue',sans-serif; background:#F1EDE9; color:#333; }
    .sidebar {
      width: 238px; height: 100vh;
      padding: 2rem 0 1.5rem 1.5rem;
      background: #F1EDE9;
      display: flex; flex-direction: column; justify-content: space-between;
    }
    .sidebar__head__component { display: flex; flex-direction: column; gap: 2.5rem; align-items: center; }
    .sidebar__header img { max-width: 100%; height: auto; margin-bottom: 2rem; }
    .sidebar__nav { list-style: none; padding: 0; margin: 0; flex-grow: 1;
                     display: flex; flex-direction: column; gap: .5rem; }
    .sidebar__nav-item {
      display: flex; align-items: center; gap: .5rem;
      padding: .75rem 2.25rem .75rem .875rem;
      border-radius: .5rem; cursor: pointer;
      transition: background .2s, color .2s;
    }
    .sidebar__nav-item a {
      display: flex; align-items: center; gap: .5rem;
      color: inherit; text-decoration: none; width: 100%;
    }
    .sidebar__nav-item img { width: 1.75rem; height: 1.75rem; }
    .sidebar__nav-item:hover { background: #e2e2e2; color: #1a1a1a; }
    .sidebar__nav-item.active {
      background: #fff; color: #111; font-weight: 600;
      border-left: 4px solid #111; padding-left: .5rem;
    }
    .sidebar__profile {
      display: flex; align-items: center; gap: .5rem;
      padding: .75rem 1rem; background: #fff; border-radius: .75rem;
      cursor: pointer;
    }
    .profile-info { display: flex; align-items: center; gap: .5rem; }
    .profile-info img { width: 40px; height: 40px;
                        border-radius: 50%; object-fit: cover; }
    .profile-info .name { font-weight: 600; font-size: .875rem; color: #1a1a1a; }
    .profile-info .role { font-size: .5rem; color: #666; }
    .sidebar__profile img.settings {
      margin-left: auto; width: 1.75rem; height: 1.75rem;
    }
    .modal { position: fixed; top:0; left:0; width:100%; height:100%;
             background: rgba(0,0,0,0.5); display: none;
             justify-content: center; align-items: center; z-index:1000; }
    .modal.show { display: flex; }
    .modal-content {
      background: #fff; padding: 2rem; border-radius: 12px;
      box-shadow: 0 2px 10px rgba(0,0,0,0.1); text-align: center;
      width: 300px;
    }
    .modal-content h3 { margin-bottom: 1rem; font-size: 1.25rem; color: #333; }
    .modal-content .btn {
      display: block; margin: .5rem auto; padding: .75rem 1.5rem;
      border-radius: 8px; font-size: .95rem; text-decoration: none;
      text-align: center; transition: background .2s; width: 100%;
    }
    .btn-update { background: #111; color: #fff; }
    .btn-update:hover { background: #333; }
    .btn-logout { border:1px solid #111; }
    .btn-logout:hover { background: #c0392b; }
  </style>
</head>
<body>
  <aside class="sidebar">
    <div class="sidebar__head__component">
      <div class="sidebar__header">
        <img src="${pageContext.request.contextPath}/nav-icons/admin-logo.svg" alt="Logo" />
      </div>
      <ul class="sidebar__nav">
        <li class="sidebar__nav-item ${param.currentPage=='dashboard'?'active':''}">
          <a href="${pageContext.request.contextPath}/AdminDash?currentPage=dashboard">
            <img src="${pageContext.request.contextPath}/nav-icons/Home.svg" alt="Dashboard" />
            <span>Dashboard</span>
          </a>
        </li>
        <li class="sidebar__nav-item ${param.currentPage=='users'?'active':''}">
          <a href="${pageContext.request.contextPath}/Users?currentPage=users">
            <img src="${pageContext.request.contextPath}/nav-icons/users.svg" alt="Users" />
            <span>User Management</span>
          </a>
        </li>
        <li class="sidebar__nav-item ${param.currentPage=='models'?'active':''}">
          <a href="${pageContext.request.contextPath}/Model?currentPage=models">
            <img src="${pageContext.request.contextPath}/nav-icons/Folder.svg" alt="Models" />
            <span>Model Management</span>
          </a>
        </li>
        <li class="sidebar__nav-item ${param.currentPage=='reports'?'active':''}">
          <a href="${pageContext.request.contextPath}/AdminReport?currentPage=reports">
            <img src="${pageContext.request.contextPath}/nav-icons/File.svg" alt="Reports" />
            <span>Reports</span>
          </a>
        </li>
      </ul>
    </div>

    <div class="sidebar__profile" id="profileToggle">
      <div class="profile-info">
        <!-- ALWAYS pull from sessionScope.user -->
         <img src="${pageContext.request.contextPath}/${sessionScope.user.profilePicture}" alt="Admin Avatar"/>
        <div style="display:flex;flex-direction:column;">
          <span class="name">${sessionScope.user.name}</span>
          <span class="role">Admin</span>
        </div>
      </div>
      <img class="settings"
           src="${pageContext.request.contextPath}/nav-icons/sharp.svg"
           alt="Settings" />
    </div>
  </aside>

  <!-- Account Modal -->
  <div class="modal" id="profileModal">
    <div class="modal-content">
      <h3>Account</h3>
      <a href="${pageContext.request.contextPath}/Profile?currentPage=profile"
         class="btn btn-update">Update Profile</a>
      <a href="${pageContext.request.contextPath}/logout"
         class="btn btn-logout" style="background-color:#fff;color:red;border-color:red;">Logout</a>
    </div>
  </div>

  <script>
    const toggleArea = document.getElementById('profileToggle');
    const modal      = document.getElementById('profileModal');
    toggleArea.addEventListener('click', () => modal.classList.toggle('show'));
    modal.addEventListener('click', e => {
      if (e.target === modal) modal.classList.remove('show');
    });
  </script>
</body>
</html>
