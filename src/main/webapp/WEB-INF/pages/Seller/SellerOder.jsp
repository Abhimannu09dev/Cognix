<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn"  uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8"/>
  <title>Orders Received – Cognix Seller</title>
  <link
    rel="stylesheet"
    href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css"
    crossorigin="anonymous"
    referrerpolicy="no-referrer"/>
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
      border: 1px solid #e0e0e0;
      border-radius: 16px;
      padding: 1.5rem;
    }
    .stats-overview h2 {
      font-size: 1.25rem;
      margin-bottom: 1rem;
      color: #222;
    }
    .stats-cards {
      display: grid;
      grid-template-columns: repeat(auto-fit, minmax(200px,1fr));
      gap: 1rem;
    }
    .stat-card {
      background: #fafafa;
      border: 1px solid #e0e0e0;
      border-radius: 8px;
      padding: 1rem;
    }
    .stat-card p {
      font-size: .75rem;
      color: #666;
      margin: 0;
    }
    .stat-card h3 {
      margin-top: .5rem;
      font-size: .875rem;
      color: #222;
    }

    /* === Orders Section === */
    .orders-section {
      background: #fff;
      border: 1px solid #e0e0e0;
      border-radius: 16px;
      padding: 1.5rem;
    }
    .orders-section h2 {
      font-size: 1.5rem;
      margin-bottom: .75rem;
      color: #222;
    }
    .orders-section hr {
      border: none;
      border-bottom: 1px solid #e0e0e0;
      margin-bottom: 1.5rem;
    }

    /* === Controls === */
    .controls {
      display: flex;
      flex-wrap: wrap;
      align-items: center;
      gap: 1rem;
      margin-bottom: 1.5rem;
      justify-content: space-between;
    }
    .search-bar {
      flex: 1 1 200px;
      display: flex;
      align-items: center;
      padding-bottom: .25rem;
      color: #666;
    }
    .search-bar i {
      margin-right: .75rem;
    }
    .search-bar input {
      flex: 1;
      border: none;
      background: transparent;
      font-size: 1rem;
      color: #333;
    }
    .search-bar input::placeholder {
      color: #aaa;
    }
    .search-bar input:focus {
      outline: none;
    }
    .filter-dropdown {
      position: relative;
      background: #fafafa;
      border: 1px solid #ddd;
      border-radius: 8px;
      transition: background 0.2s;
    }
    /* chevron only for select */
    .filter-dropdown select {
      appearance: none;
      border: none;
      background: transparent;
      padding: .5rem 1rem;
      font-size: .95rem;
      color: #444;
      cursor: pointer;
      min-width: 140px;
    }
    .filter-dropdown select:focus {
      outline: none;
    }
    .filter-dropdown select + i {
      position: absolute;
      right: .75rem;
      top: 50%;
      transform: translateY(-50%);
      pointer-events: none;
      color: #666;
      font-size: .8rem;
    }
    /* native date input left alone */
    .filter-dropdown input[type="date"] {
      appearance: auto;
      border: none;
      background: transparent;
      padding: .5rem 1rem;
      font-size: .95rem;
      color: #444;
      cursor: pointer;
      min-width: 140px;
    }
    .filter-dropdown:hover {
      background: #f0f0f0;
    }
    .apply-btn {
      background: #111;
      color: #fff;
      border: none;
      border-radius: 8px;
      padding: .5rem 1rem;
      font-size: .95rem;
      cursor: pointer;
      white-space: nowrap;
      transition: background .2s;
    }
    .apply-btn:hover {
      background: #333;
    }

    /* === Table === */
    .table-wrapper {
      overflow-x: auto;
    }
    .orders-table {
      width: 100%;
      border-collapse: collapse;
      table-layout: fixed;
    }
    .orders-table th,
    .orders-table td {
      padding: .75rem 1rem;
      text-align: left;
      vertical-align: middle;
      border-bottom: 1px solid #f5f5f5;
    }
    .orders-table th {
      font-size: .85rem;
      color: #666;
      border-bottom: 1px solid #e0e0e0;
    }
    .orders-table tr:last-child td {
      border-bottom: none;
    }
    .orders-table td.no-data {
      text-align: center;
      color: #666;
      padding: 2rem 0;
    }
  </style>
</head>
<body>
  <div class="dashboard">
    <aside class="dashboard__nav">
      <%@ include file="/WEB-INF/pages/component/SellerNav.jsp" %>
    </aside>

    <div class="dashboard__main">
      <header class="dashboard__topbar">
        <%@ include file="/WEB-INF/pages/component/SerachBar.jsp" %>
      </header>

      <div class="dashboard__content">

        <!-- Orders Summary -->
        <section class="stats-overview">
          <h2>Orders Summary</h2>
          <div class="stats-cards">
            <div class="stat-card">
              <p>Total Orders Received</p>
              <h3><c:out value="${empty totalOrders ? 0 : totalOrders}"/></h3>
            </div>
            <div class="stat-card">
              <p>Total Revenue Generated</p>
              <h3>$<c:out value="${empty totalRevenue ? 0 : totalRevenue}"/></h3>
            </div>
            <div class="stat-card">
              <p>Latest Order</p>
              <h3><c:out value="${empty latestOrderDate ? '—' : fn:escapeXml(latestOrderDate)}"/></h3>
            </div>
          </div>
        </section>

        <!-- Orders Received Table -->
        <section class="orders-section">
          <h2>Orders Received</h2>
          <hr/>
          <form method="get" class="controls">
            <div class="search-bar" style="border-bottom: 1px solid #ccc;">
              <i class="fas fa-search"></i>
              <input
                name="search"
                type="text"
                placeholder="Search orders…"
                value="${fn:escapeXml(param.search)}"/>
            </div>
            <div class="filter-dropdown">
              <select name="modelType">
                <option value="">Model Type</option>
                <option value="computer-vision" <c:if test="${param.modelType=='computer-vision'}">selected</c:if>>Computer Vision</option>
                <option value="nlp"              <c:if test="${param.modelType=='nlp'}">selected</c:if>>NLP</option>
                <option value="reinforcement"    <c:if test="${param.modelType=='reinforcement'}">selected</c:if>>Reinforcement</option>
              </select>
              <i class="fas fa-chevron-down"></i>
            </div>
            <div class="filter-dropdown">
              <select name="orderAt">
                <option value="">Order At</option>
                <option value="24h" <c:if test="${param.orderAt=='24h'}">selected</c:if>>Last 24 hrs</option>
                <option value="7d"  <c:if test="${param.orderAt=='7d'}">selected</c:if>>Last 7 days</option>
                <option value="30d" <c:if test="${param.orderAt=='30d'}">selected</c:if>>Last 30 days</option>
              </select>
              <i class="fas fa-chevron-down"></i>
            </div>
            <button type="submit" class="apply-btn">Apply</button>
          </form>

          <div class="table-wrapper">
            <table class="orders-table">
              <thead>
                <tr>
                  <th>SN</th>
                  <th>Order ID</th>
                  <th>Model</th>
                  <th>Buyer</th>
                  <th>Category</th>
                  <th>Purchased</th>
                  <th>Price (USD)</th>
                </tr>
              </thead>
              <tbody>
                <c:forEach var="o" items="${ordersList}" varStatus="st">
                  <tr>
                    <td>${st.index + 1}</td>
                    <td>${fn:escapeXml(o.orderId)}</td>
                    <td>${fn:escapeXml(o.modelName)}</td>
                    <td>${fn:escapeXml(o.buyerUsername)}</td>
                    <td>${fn:escapeXml(o.category)}</td>
                    <td><fmt:formatDate value="${o.purchaseDate}" pattern="yyyy-MM-dd"/></td>
                    <td>$${o.price}</td>
                  </tr>
                </c:forEach>
                <c:if test="${empty ordersList}">
                  <tr>
                    <td colspan="7" class="no-data">No orders found.</td>
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
