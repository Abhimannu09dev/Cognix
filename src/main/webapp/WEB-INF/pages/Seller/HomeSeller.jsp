<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8"/>
  <title>Seller Dashboard – Cognix</title>
  <!-- Font Awesome for icons -->
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
    .dashboard__nav {
      width: 240px;
    }
    .dashboard__main {
      flex: 1;
      display: flex;
      flex-direction: column;
    }

    /* === Topbar === */
    .dashboard__topbar {
      padding: 1rem 2rem;
    }

    /* === Content === */
    .dashboard__content {
      flex: 1;
      padding: 2rem;
      overflow-y: auto;
      display: flex;
      flex-direction: column;
      gap: 2rem;
    }
    .dashboard__greeting h1 {
      font-size: 1.5rem;
      margin-bottom: 1rem;
    }

    /* === Stats Overview === */
    .stats-overview {
      background: #fff;
      border-radius: 16px;
      padding: 1.5rem;
      border: 1px solid #e0e0e0;
    }
    .stats-overview h2 {
      font-size: 1.25rem;
      margin-bottom: 1rem;
      color: #222;
    }
    .stats-cards {
      display: grid;
      grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
      gap: 1rem;
    }
    .stat-card {
      background: #fafafa;
      border: 1px solid #e0e0e0;
      border-radius: 8px;
      padding: 1rem;
      text-align: left;
    }
    .stat-card p {
      font-size: .75rem;
      color: #666;
    }
    .stat-card h3 {
      margin-top: .5rem;
      font-size: .95rem;
      color: #222;
    }

    /* === Models Overview === */
    .models-overview {
      background: #fff;
      border-radius: 16px;
      padding: 1.5rem;
      border: 1px solid #e0e0e0;
    }
    .models-overview h2 {
      font-size: 1.25rem;
      margin-bottom: .75rem;
      color: #222;
    }
    .models-overview hr {
      border: none;
      border-top: 1px solid #e0e0e0;
      margin-bottom: 1rem;
    }

    /* === Filters Bar === */
    .models-overview .models-controls {
      display: flex;
      align-items: center;
      gap: 1rem;
      margin-bottom: 1rem;
    }
    .models-overview .filter-dropdown {
      position: relative;
      background: #fafafa;
      border: 1px solid #ddd;
      border-radius: 8px;
      transition: background .2s;
    }
    .models-overview .filter-dropdown:hover {
      background: #f0f0f0;
    }
    .models-overview .filter-dropdown select {
      appearance: none;
      border: none;
      background: transparent;
      padding: .5rem 1rem;
      font-size: .95rem;
      cursor: pointer;
      min-width: 140px;
    }
    .models-overview .filter-dropdown::after {
      content: "\f078";
      font-family: "Font Awesome 6 Free";
      font-weight: 900;
      position: absolute;
      right: .75rem;
      top: 50%;
      transform: translateY(-50%);
      pointer-events: none;
      color: #666;
      font-size: .8rem;
    }
    .models-overview .action-btn {
      background: #111;
      color: #fff;
      border: none;
      border-radius: 8px;
      padding: .5rem 1rem;
      cursor: pointer;
      transition: background .2s;
    }
    .models-overview .action-btn:hover {
      background: #333;
    }

    /* === Models Table === */
    .table-wrapper {
      overflow-x: auto;
    }
    .models-table {
      width: 100%;
      border-collapse: collapse;
      min-width: 700px;
    }
    .models-table th,
    .models-table td {
      padding: .75rem 1rem;
      text-align: left;
      white-space: nowrap;
      border-bottom: 1px solid #f5f5f5;
    }
    .models-table th {
      background: #fafafa;
      color: #666;
      font-size: .85rem;
      border-bottom: 1px solid #e0e0e0;
    }
    .models-table tr:last-child td {
      border-bottom: none;
    }
  </style>
</head>
<body>
  <div class="dashboard">
    <!-- Seller sidebar -->
    <aside class="dashboard__nav">
      <%@ include file="/WEB-INF/pages/component/SellerNav.jsp" %>
    </aside>

    <!-- Main area -->
    <div class="dashboard__main">
      <header class="dashboard__topbar">
        <%@ include file="/WEB-INF/pages/component/SerachBar.jsp" %>
      </header>

      <div class="dashboard__content">
        <div class="dashboard__greeting">
          <h1>Hey, Good Morning<br/>${sessionScope.user.username}</h1>
        </div>

        <!-- Stats -->
        <section class="stats-overview">
          <h2>Stats Overview</h2>
          <div class="stats-cards">
            <div class="stat-card">
              <p>Total Listings</p>
              <h3><c:out value="${totalListings}" default="0"/></h3>
            </div>
            <div class="stat-card">
              <p>Total Sales</p>
              <h3><c:out value="${totalSales}" default="0"/></h3>
            </div>
            <div class="stat-card">
              <p>Total Earnings</p>
              <h3>$<c:out value="${totalEarnings}" default="0"/></h3>
            </div>
            <div class="stat-card">
              <p>Most Popular Model</p>
              <h3><c:out value="${mostPopularModel}" default="—"/></h3>
            </div>
          </div>
        </section>

        <!-- Top Models -->
        <section class="models-overview">
          <h2>Most Sold Models</h2>
          <hr/>
          <form method="get" class="models-controls">
            <div class="filter-dropdown">
              <select name="category">
                <option value="">All Categories</option>
                <option value="computer-vision" <c:if test="${param.category=='computer-vision'}">selected</c:if>>Computer Vision</option>
                <option value="nlp" <c:if test="${param.category=='nlp'}">selected</c:if>>NLP</option>
                <option value="reinforcement" <c:if test="${param.category=='reinforcement'}">selected</c:if>>Reinforcement</option>
              </select>
            </div>
            <div class="filter-dropdown">
              <select name="sortBy">
                <option value="">Sort By</option>
                <option value="revenue-desc" <c:if test="${param.sortBy=='revenue-desc'}">selected</c:if>>Revenue High→Low</option>
                <option value="revenue-asc"  <c:if test="${param.sortBy=='revenue-asc'}">selected</c:if>>Revenue Low→High</option>
                <option value="sales-desc"   <c:if test="${param.sortBy=='sales-desc'}">selected</c:if>>Sales High→Low</option>
                <option value="sales-asc"    <c:if test="${param.sortBy=='sales-asc'}">selected</c:if>>Sales Low→High</option>
              </select>
            </div>
            <button type="submit" class="action-btn">Apply</button>
          </form>
          <div class="table-wrapper">
            <table class="models-table">
              <thead>
                <tr>
                  <th>SN</th>
                  <th>Model Name</th>
                  <th>Category</th>
                  <th>Listed Date</th>
                  <th>Price (USD)</th>
                  <th>Total Sales</th>
                  <th>Total Revenue</th>
                </tr>
              </thead>
              <tbody>
                <c:forEach var="m" items="${topModels}" varStatus="st">
                  <tr>
                    <td>${st.index+1}</td>
                    <td><c:out value="${m.modelName}" default="—"/></td>
                    <td><c:out value="${m.category}" default="—"/></td>
                    <td><fmt:formatDate value="${m.listedDate}" pattern="yyyy-MM-dd"/></td>
                    <td>$<c:out value="${m.price}" default="0"/></td>
                    <td><c:out value="${m.totalSales}" default="0"/></td>
                    <td>$<c:out value="${m.totalRevenue}" default="0"/></td>
                  </tr>
                </c:forEach>
                <c:if test="${empty topModels}">
                  <tr>
                    <td colspan="7" style="text-align:center; padding:1rem; color:#666;">
                      No data available.
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
