<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn"  uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8"/>
  <title>Orders Received – Cognix Seller</title>
  <link rel="stylesheet"
        href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css"/>
        
    <style>
    /* === Reset & Base === */
* {
  box-sizing: border-box;
  margin: 0;
  padding: 0;
}
html, body {
  height: 100%;
  overflow: hidden;            /* disable viewport scrolling */
}
body {
  font-family: 'Helvetica Neue', sans-serif;
  background: #F1EDE9;
  color: #222;
}

/* === Dashboard Container === */
.dashboard {
  display: flex;
  max-width: 1440px;
  height: 100%;
  margin: 0 auto;
}

/* === Fixed Sidebar === */
.dashboard__nav {
  width: 280px;
  position: fixed;
  top: 0;
  left: 0;
  height: 100%;
  background: #fff;
  overflow-y: auto;
  scrollbar-width: none;       /* Firefox: hide scrollbar */
}
.dashboard__nav::-webkit-scrollbar {
  width: 0;                     /* Chrome/Safari: hide scrollbar */
}

/* === Main Content (shifts right) === */
.dashboard__main {
  margin-left: 280px;
  flex: 1;
  display: flex;
  flex-direction: column;
  height: 100%;
}

/* === Scrollable Content Area === */
.dashboard__content {
  flex: 1;
  padding: 2rem;
  padding-top: 4rem;           /* space for any fixed headers */
  overflow-y: auto;            /* only this scrolls */
  scrollbar-width: none;       /* Firefox: hide scrollbar */
  display:flex;
  flex-direction:column;
  gap:2rem;
}
.dashboard__content::-webkit-scrollbar {
  width: 0;                     /* Chrome/Safari: hide scrollbar */
}

/* === Greeting === */
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
  grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
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
  justify-content: space-between;
  gap: 1rem;
  margin-bottom: 1.5rem;
}
.search-bar {
  flex: 1 1 200px;
  display: flex;
  align-items: center;
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
  transition: background .2s;
}
.filter-dropdown:hover {
  background: #f0f0f0;
}
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

/* === Table Wrapper & Table === */
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
/* Make the first column (SN) exactly 50px */
.orders-table th:first-child,
.orders-table td:first-child {
  width: 70px;
  max-width: 70px;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}
.orders-table th:nth-child(2),
.orders-table td:nth-child(2) {
  width: 120px;
  max-width: 120px;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}



/* === Page Footer (inside content) === */
.page-footer {
  margin-top: 2rem;
  text-align: center;
  color: #666;
  font-size: .85rem;
}
    
  </style>
</head>
<body>
  <div class="dashboard">
    <aside class="dashboard__nav">
      <%@ include file="/WEB-INF/pages/component/SellerNav.jsp" %>
    </aside>
    <div class="dashboard__main">
      <div class="dashboard__content">
      <h1>Oders</h1>

        <!-- Summary -->
        <section class="stats-overview">
          <h2>Orders Summary</h2>
          <div class="stats-cards">
            <div class="stat-card">
              <p>Total Orders Received</p>
              <h3><c:out value="${totalOrders}"/></h3>
            </div>
            <div class="stat-card">
              <p>Total Revenue Generated</p>
              <h3>
                $
                <fmt:formatNumber value="${totalRevenue}" type="number" minFractionDigits="2"/>
              </h3>
            </div>
            <div class="stat-card">
              <p>Latest Order</p>
              <h3>
                <c:choose>
                  <c:when test="${not empty latestOrderDate}">
                    <fmt:formatDate value="${latestOrderDate}" pattern="yyyy-MM-dd"/>
                  </c:when>
                  <c:otherwise>—</c:otherwise>
                </c:choose>
              </h3>
            </div>
          </div>
        </section>

        <!-- Orders Table -->
        <section class="orders-section">
          <h2>Orders Received</h2>
          <hr/>
          <form method="get" class="controls">
            <div class="search-bar" style="border-bottom: 1px solid #ddd;padding: 0.5rem;">
              <i class="fas fa-search"></i>
              <input name="search"
                     type="text"
                     placeholder="Search orders…"
                     value="${fn:escapeXml(param.search)}"/>
            </div>
            <div class="filter-dropdown">
			  <select name="modelType">
			    <option value="">All Categories</option>
			    <c:forEach var="cat" items="${categoriesList}">
			      <option value="${fn:escapeXml(cat)}"
			        <c:if test="${param.modelType == cat}">selected</c:if>>
			        <c:out value="${cat}"/>
			      </option>
			    </c:forEach>
			  </select>
			  <i class="fas fa-chevron-down"></i>
			</div>
            
            <div class="filter-dropdown">
              <select name="orderAt">
                <option value="">All Time</option>
                <option value="24h"
                  <c:if test="${param.orderAt=='24h'}">selected</c:if>>
                  Last 24 hrs
                </option>
                <option value="7d"
                  <c:if test="${param.orderAt=='7d'}">selected</c:if>>
                  Last 7 days
                </option>
                <option value="30d"
                  <c:if test="${param.orderAt=='30d'}">selected</c:if>>
                  Last 30 days
                </option>
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
                    <td>
                      <fmt:formatDate value="${o.purchaseDate}" pattern="yyyy-MM-dd"/>
                    </td>
                    <td>
                      $
                      <fmt:formatNumber value="${o.price}" type="number" minFractionDigits="2"/>
                    </td>
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
      <footer>
        <jsp:include page="/WEB-INF/pages/component/CopyRight.jsp"/>
      </footer>
      </div>

    </div>
  </div>
</body>
</html>
