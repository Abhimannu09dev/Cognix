<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn"  uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8"/>
  <title>User Management – Cognix Admin</title>

  <!-- Font Awesome -->
  <link
    rel="stylesheet"
    href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css"
    crossorigin="anonymous"
    referrerpolicy="no-referrer"
  />

  <style>
    /* === Reset & Base === */
    * { box-sizing: border-box; margin: 0; padding: 0; }
    body {
      font-family: 'Helvetica Neue', sans-serif;
      background: #F1EDE9;
      color: #222;
    }

    /* === Dashboard Container === */
    .dashboard {
      display: flex;
      max-width: 1440px;
      margin: 0 auto;
      min-height: 100vh;
    }

    /* === Sidebar === */
    .dashboard__nav {
      width: 240px;
    }

    /* === Main Content === */
    .dashboard__main {
      flex: 1;
      display: flex;
      flex-direction: column;
    }
    .dashboard__header {
      padding: 2rem 3rem 0;
    }
    .dashboard__header h1 {
      font-size: 1.875rem;
      margin-bottom: 1.5rem;
    }
    .dashboard__content {
      flex: 1;
      padding: 1.5rem 3rem;
      overflow-y: auto;
      display: flex;
      flex-direction: column;
      gap: 0rem;
    }

    /* === Controls === */
    .controls {
      display: flex;
      flex-wrap: wrap;
      gap: 1rem;
      margin-bottom: 1.5rem;
      align-items: center;
    }
    .controls__search {
      flex: 1 1 200px;
      display: flex;
      align-items: center;
      border-bottom: 1px solid #ccc;
      padding-bottom: .25rem;
      color: #666;
    }
    .controls__search i { margin-right: .75rem; }
    .controls__search input {
      flex: 1; border: none; background: transparent;
      font-size: 1rem; color: #333;
    }
    .controls__search input::placeholder { color: #aaa; }
    .controls__search input:focus { outline: none; }

    .controls__filter {
      position: relative;
      background: #fafafa;
      border: 1px solid #ddd;
      border-radius: 8px;
      min-width: 170px;
    }
    .controls__filter select {
      appearance: none;
      border: none;
      background: transparent;
      padding: .5rem 1rem;
      font-size: .95rem;
      color: #444;
      cursor: pointer;
    }
    .controls__filter:hover { background: #f0f0f0; }
    .controls__filter::after {
      content: "\f078"; font-family: "Font Awesome 6 Free"; font-weight: 900;
      position: absolute; right: .75rem; top: 50%;
      transform: translateY(-50%);
      pointer-events: none; color: #666;
    }

    .controls__apply-btn {
      margin-left: auto;
      background: #111; color: #fff; border: none;
      border-radius: 8px; padding: .5rem 1rem;
      font-size: .95rem; cursor: pointer; white-space: nowrap;
      transition: background .2s;
    }
    .controls__apply-btn:hover { background: #333; }

    /* === Table Section === */
    .table-section {
      background: #fff;
      border-radius: 16px;
      padding: 1.5rem;
      box-shadow: 0 2px 8px rgba(0,0,0,0.05);
    }

    /* === Data Table === */
    .data-table {
      width: 100%;
      border-collapse: collapse;
      min-width: 600px;
    }
    .data-table th,
    .data-table td {
      padding: .75rem 1rem;
      text-align: left;
      border-bottom: 1px solid #f5f5f5;
      white-space: nowrap;
      font-size: .95rem;
    }
    .data-table th {
      background: #f9f9f9;
      color: #333;
      font-size: .85rem;
    }
    .data-table tr:last-child td { border-bottom: none; }
    .data-table tr:hover td { background: #f9f9f9; }

    .btn--delete {
      background: #c00; color: #fff;
      border: none; border-radius: 6px;
      padding: .4rem .8rem; font-size: .9rem;
      cursor: pointer; transition: background .2s;
    }
    .btn--delete:hover { background: #a00; }
  </style>
</head>
<body>
  <div class="dashboard">
    <!-- Sidebar -->
    <aside class="dashboard__nav">
      <jsp:include page="../component/AdminNav.jsp"/>
    </aside>

    <!-- Main Content -->
    <div class="dashboard__main">
      <header class="dashboard__header">
        <h1>User Management</h1>
      </header>
      <div class="dashboard__content">
        <form method="get" class="controls">
          <div class="controls__search">
            <i class="fas fa-search"></i>
            <input
              type="text"
              name="q"
              placeholder="Search users…"
              value="${fn:escapeXml(param.q)}"/>
          </div>

          <div class="controls__filter">
            <select name="role">
              <option value="">All Roles</option>
              <option value="admin"  <c:if test="${param.role=='admin'}">selected</c:if>>Admin</option>
              <option value="seller" <c:if test="${param.role=='seller'}">selected</c:if>>Seller</option>
              <option value="buyer"  <c:if test="${param.role=='buyer'}">selected</c:if>>Buyer</option>
            </select>
          </div>

          <div class="controls__filter">
            <select name="sort">
              <option value="">Sort by Joined</option>
              <option value="newest" <c:if test="${param.sort=='newest'}">selected</c:if>>Newest</option>
              <option value="oldest" <c:if test="${param.sort=='oldest'}">selected</c:if>>Oldest</option>
            </select>
          </div>

          <button type="submit" class="controls__apply-btn">Apply</button>
        </form>

        <section class="table-section">
          <table class="data-table">
            <thead>
              <tr>
                <th>SN</th>
                <th>Username</th>
                <th>Full Name</th>
                <th>Joined On</th>
                <th>Role</th>
                <th>Email</th>
                <th>Action</th>
              </tr>
            </thead>
            <tbody>
              <c:forEach var="user" items="${usersList}" varStatus="st">
                <tr>
                  <td>${st.index + 1}</td>
                  <td>${fn:escapeXml(user.username)}</td>
                  <td>${fn:escapeXml(user.fullName)}</td>
                  <td><fmt:formatDate value="${user.createdAt}" pattern="yyyy-MM-dd"/></td>
                  <td>${fn:escapeXml(user.role)}</td>
                  <td>${fn:escapeXml(user.email)}</td>
                  <td>
                    <form action="deleteUser" method="post" style="display:inline;">
                      <input type="hidden" name="id" value="${user.id}"/>
                      <button type="submit" class="btn--delete">Delete</button>
                    </form>
                  </td>
                </tr>
              </c:forEach>
              <c:if test="${empty usersList}">
                <tr>
                  <td colspan="7" style="text-align:center;color:#777;">No users found.</td>
                </tr>
              </c:if>
            </tbody>
          </table>
        </section>
      </div>
    </div>
  </div>
</body>
</html>
