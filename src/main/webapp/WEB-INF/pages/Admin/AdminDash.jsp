<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn"  uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8"/>
  <title>Admin Dashboard – Cognix</title>

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

    /* === Main === */
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
    }
    .dashboard__content {
      flex: 1;
      padding: 1.5rem 3rem;
      overflow-y: auto;
      display: flex;
      flex-direction: column;
      gap: 2rem;
    }

    /* === Sections === */
    .section {
      background: #fff;
      border: 1px solid #e0e0e0;
      border-radius: 16px;
      padding: 1.5rem;
    }
    .section__header {
      display: flex;
      align-items: center;
      margin-bottom: 1rem;
    }
    .section__header h2 {
      font-size: 1.25rem;
      color: #222;
    }
    .section__header hr {
      flex: 1;
      margin-left: 1rem;
      border: none;
      border-bottom: 1px solid #e0e0e0;
    }

    /* === Controls === */
    .controls {
      display: flex;
      flex-wrap: wrap;
      gap: 1rem;
      margin-bottom: 1rem;
      align-items: center;
    }
    .controls__search {
      flex: 1 1 200px;
      display: flex;
      align-items: center;
      border-bottom: 1px solid #ddd;
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
    }
    .controls__filter select {
      appearance: none;
      border: 1px solid #ddd;
      background: #fafafa;
      padding: .5rem 2.25rem .5rem .75rem;
      font-size: .95rem;
      color: #444;
      border-radius: .5rem;
      cursor: pointer;
      min-width: max-content;
    }
    .controls__filter:hover { background: #f0f0f0; }
    .controls__filter::after {
      content: "\f078"; /* Font Awesome chevron-down */
      font-family: "Font Awesome 6 Free";
      font-weight: 900;
      position: absolute; right: .75rem; top: 50%;
      transform: translateY(-50%);
      pointer-events: none; color: #666;
    }

    .controls__apply {
      background: #333;
      color: #fff;
      border: none;
      padding: .5rem 1.5rem;
      border-radius: .5rem;
      font-size: .95rem;
      cursor: pointer;
      transition: background .2s;
      white-space: nowrap;
      margin-left: auto;
    }
    .controls__apply:hover { background: #444; }

    /* === Data Table === */
    .table-wrapper {
      overflow-x: auto;
    }
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
      font-size: .95rem;
      white-space: nowrap;
    }
    .data-table th {
      background: #f9f9f9;
      color: #333;
    }
    .data-table tr:last-child td {
      border-bottom: none;
    }
    .data-table tr:hover td {
      background: #f9f9f9;
    }
    .view-btn {
      display: inline-block;
      background: #007bff;
      color: #fff;
      padding: .4rem .8rem;
      border-radius: .5rem;
      font-size: .85rem;
      text-decoration: none;
      transition: background .2s;
    }
    .view-btn:hover { background: #0056b3; }
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
        <h1>Hey, Good Morning, <br> <c:out value="${sessionScope.user.name}"/></h1>
      </header>
      <div class="dashboard__content">

        <!-- New Users Section -->
        <section class="section">
          <div class="section__header">
            <h2>New Users</h2>
            <hr/>
          </div>
          <form method="get" class="controls">
            <div class="controls__search">
              <i class="fas fa-search"></i>
              <input
                name="userSearch"
                type="text"
                placeholder="Search users…"
                value="${fn:escapeXml(param.userSearch)}"/>
            </div>
            <div class="controls__filter">
              <select name="roleFilter">
                <option value="">Role</option>
                <option value="seller" <c:if test="${param.roleFilter=='seller'}">selected</c:if>>Seller</option>
                <option value="buyer"  <c:if test="${param.roleFilter=='buyer'}">selected</c:if>>Buyer</option>
              </select>
            </div>
            <div class="controls__filter">
              <select name="sortUsers">
                <option value="">Sort By</option>
                <option value="date-desc" <c:if test="${param.sortUsers=='date-desc'}">selected</c:if>>Joined: New→Old</option>
                <option value="date-asc"  <c:if test="${param.sortUsers=='date-asc'}">selected</c:if>>Joined: Old→New</option>
              </select>
            </div>
            <button type="submit" class="controls__apply">Apply</button>
          </form>
          <div class="table-wrapper">
            <table class="data-table">
              <thead>
                <tr>
                  <th>SN</th><th>Username</th><th>Full Name</th>
                  <th>Joined On</th><th>Role</th><th>Email</th><th>View</th>
                </tr>
              </thead>
              <tbody>
                <c:forEach var="user" items="${newUsersList}" varStatus="st" begin="0" end="4">
                  <tr>
                    <td>${st.index + 1}</td>
                    <td>${fn:escapeXml(user.username)}</td>
                    <td>${fn:escapeXml(user.fullName)}</td>
                    <td><fmt:formatDate value="${user.createdAt}" pattern="yyyy-MM-dd"/></td>
                    <td>${fn:escapeXml(user.role)}</td>
                    <td>${fn:escapeXml(user.email)}</td>
                    <td><a href="user-details?id=${user.id}" class="view-btn">View</a></td>
                  </tr>
                </c:forEach>
                <c:if test="${empty newUsersList}">
                  <tr>
                    <td colspan="7" style="text-align:center;color:#777;">
                      No users found.
                    </td>
                  </tr>
                </c:if>
              </tbody>
            </table>
          </div>
        </section>

        <!-- Top Models Section -->
        <section class="section">
          <div class="section__header">
            <h2>Top Models</h2>
            <hr/>
          </div>
          <form method="get" class="controls">
            <div class="controls__search">
              <i class="fas fa-search"></i>
              <input
                name="modelSearch"
                type="text"
                placeholder="Search models…"
                value="${fn:escapeXml(param.modelSearch)}"/>
            </div>
            <div class="controls__filter">
              <select name="categoryFilter">
                <option value="">Category</option>
                <option value="computer-vision" <c:if test="${param.categoryFilter=='computer-vision'}">selected</c:if>>Computer Vision</option>
                <option value="nlp"              <c:if test="${param.categoryFilter=='nlp'}">selected</c:if>>NLP</option>
                <option value="reinforcement"    <c:if test="${param.categoryFilter=='reinforcement'}">selected</c:if>>Reinforcement Learning</option>
              </select>
            </div>
            <div class="controls__filter">
              <select name="sortModels">
                <option value="">Sort By</option>
                <option value="sales-desc" <c:if test="${param.sortModels=='sales-desc'}">selected</c:if>>Sales: High→Low</option>
                <option value="sales-asc"  <c:if test="${param.sortModels=='sales-asc'}">selected</c:if>>Sales: Low→High</option>
                <option value="date-desc"  <c:if test="${param.sortModels=='date-desc'}">selected</c:if>>Date: New→Old</option>
                <option value="date-asc"   <c:if test="${param.sortModels=='date-asc'}">selected</c:if>>Date: Old→New</option>
              </select>
            </div>
            <button type="submit" class="controls__apply">Apply</button>
          </form>
          <div class="table-wrapper">
            <table class="data-table">
              <thead>
                <tr>
                  <th>SN</th><th>Model Name</th><th>Category</th>
                  <th>Price (USD)</th><th>Seller</th><th>Listed Date</th><th>View</th>
                </tr>
              </thead>
              <tbody>
                <c:forEach var="model" items="${topModelsList}" varStatus="st" begin="0" end="4">
                  <tr>
                    <td>${st.index + 1}</td>
                    <td>${fn:escapeXml(model.name)}</td>
                    <td>${fn:escapeXml(model.category)}</td>
                    <td>$${model.price}</td>
                    <td>@${fn:escapeXml(model.sellerUsername)}</td>
                    <td><fmt:formatDate value="${model.listedDate}" pattern="yyyy-MM-dd"/></td>
                    <td><a href="model-details?id=${model.id}" class="view-btn">View</a></td>
                  </tr>
                </c:forEach>
                <c:if test="${empty topModelsList}">
                  <tr>
                    <td colspan="7" style="text-align:center;color:#777;">
                      No models found.
                    </td>
                  </tr>
                </c:if>
              </tbody>
            </table>
          </div>
        </section>

      </div>
    </div>
  </div>
</body>
</html>
