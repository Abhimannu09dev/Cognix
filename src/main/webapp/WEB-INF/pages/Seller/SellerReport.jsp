<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn"  uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8"/>
  <title>Seller Reports – Cognix</title>

  <!-- Font Awesome -->
  <link
    rel="stylesheet"
    href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css"
    crossorigin="anonymous"
    referrerpolicy="no-referrer"
  />
  <!-- Chart.js -->
  <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

  <style>
    /* === Reset & Base === */
    * { box-sizing: border-box; margin: 0; padding: 0; }
    body {
      font-family: 'Helvetica Neue', sans-serif;
      background: #F1EDE9;
      color: #222;
    }

    /* === Dashboard Container === */
    .layout {
      display: flex;
      max-width: 1440px;
      margin: 0 auto;
      height: 100vh;
    }
    .layout > aside {
      width: 280px;
    }
    .main-content {
      flex: 1;
      padding: 2rem;
      overflow-y: auto;
    }

    .greeting h1 {
      font-size: 1.5rem;
      margin-bottom: 1.5rem;
    }

    /* === Summary Cards === */
    .orders-summary {
      display: flex;
      gap: 1rem;
      margin-bottom: 2rem;
    }
    .summary-card {
      flex: 1;
      background: #fff;
      border: 1px solid #ddd;
      border-radius: 12px;
      padding: 1rem 1.5rem;
      box-shadow: 0 1px 4px rgba(0,0,0,0.04);
    }
    .summary-title {
      margin: 0 0 .5rem;
      font-size: .875rem;
      color: #555;
    }
    .summary-value {
      margin: 0;
      font-size: 1.5rem;
      font-weight: 600;
      color: #222;
    }

    /* === Reports Section === */
    .reports-section {
      background: #fff;
      border-radius: 16px;
      padding: 1.5rem;
      box-shadow: 0 2px 8px rgba(0,0,0,0.05);
      margin-bottom: 2rem;
    }
    .reports-section h2 {
      margin: 0 0 1rem;
      font-size: 1.25rem;
      color: #222;
    }
    .reports-section hr {
      border: none;
      border-bottom: 1px solid #e0e0e0;
      margin: 1rem 0 1.5rem;
    }

    /* === Controls === */
    .controls {
      display: flex;
      flex-wrap: wrap;
      align-items: center;
      gap: 1rem;
      margin-bottom: 1.5rem;
    }
    .controls .search-bar {
      flex: 1 1 200px;
      display: flex;
      align-items: center;
      border-bottom: 1px solid #ccc;
      padding-bottom: .25rem;
      color: #666;
    }
    .controls .search-bar i {
      margin-right: .75rem;
      color: #888;
    }
    .controls .search-bar input {
      flex: 1;
      border: none;
      background: transparent;
      font-size: 1rem;
      color: #333;
    }
    .controls .search-bar input::placeholder {
      color: #aaa;
    }
    .controls .search-bar input:focus {
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
    /* only add chevron on selects */
    .filter-dropdown select,
    .filter-dropdown input[type="date"],
    .filter-dropdown input[type="month"] {
      appearance: none;
      border: none;
      background: transparent;
      padding: .5rem 1rem;
      font-size: .95rem;
      color: #444;
      cursor: pointer;
      min-width: 140px;
    }
    .filter-dropdown select:focus,
    .filter-dropdown input:focus {
      outline: none;
    }
    .filter-dropdown select + i,
    .filter-dropdown input[type="month"] + i,
    .filter-dropdown input[type="date"] + i {
      position: absolute;
      right: .75rem;
      top: 50%;
      transform: translateY(-50%);
      pointer-events: none;
      color: #666;
      font-size: .8rem;
    }
    /* hide our fake icon overlay on native date pickers */
    .filter-dropdown input[type="date"]::-webkit-calendar-picker-indicator {
      opacity: 0;
      cursor: pointer;
      position: absolute;
      right: 0;
      top: 0;
      bottom: 0;
      width: 2.5rem;
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

    /* === Chart Container === */
    .chart-container {
      position: relative;
      width: 100%;
      max-width: 800px;
      margin: 0 auto;
    }
    .chart-container canvas {
      width: 100% !important;
      height: auto !important;
    }
  </style>
</head>
<body class="admin-layout">
  <div class="layout">
    <!-- Seller sidebar -->
    <jsp:include page="../component/SellerNav.jsp"/>

    <div class="main-content">
      <div class="greeting">
        <h1>Seller Reports</h1>
      </div>

      <!-- Summary Cards -->
      <section class="orders-summary">
        <div class="summary-card">
          <p class="summary-title">Total Models Listed</p>
          <h3 class="summary-value">
            <c:out value="${empty totalModelsListed ? 0 : totalModelsListed}"/>
          </h3>
        </div>
        <div class="summary-card">
          <p class="summary-title">Total Orders Received</p>
          <h3 class="summary-value">
            <c:out value="${empty totalOrdersReceived ? 0 : totalOrdersReceived}"/>
          </h3>
        </div>
        <div class="summary-card">
          <p class="summary-title">Total Revenue Generated</p>
          <h3 class="summary-value">
            $<fmt:formatNumber value="${empty totalRevenue ? 0 : totalRevenue}" type="number" minFractionDigits="2"/>
          </h3>
        </div>
        <div class="summary-card">
          <p class="summary-title">Best Selling Model</p>
          <h3 class="summary-value">
            <c:out value="${empty bestSellingModel ? 'N/A' : bestSellingModel}"/>
          </h3>
        </div>
      </section>

      <!-- Revenue Over Time -->
      <section class="reports-section">
        <h2>Revenue Over Time</h2>
        <hr/>
        <form method="get" class="controls">
          <div class="filter-dropdown">
            <input type="month" name="revenueMonth" value="${param.revenueMonth}"/>
            <i class="fas fa-calendar-alt"></i>
          </div>
          <div class="filter-dropdown">
            <input type="date" name="revenueFrom" value="${param.revenueFrom}"/>
            <i class="fas fa-calendar-alt"></i>
          </div>
          <div class="filter-dropdown">
            <input type="date" name="revenueTo" value="${param.revenueTo}"/>
            <i class="fas fa-calendar-alt"></i>
          </div>
          <div class="filter-dropdown">
            <select name="revenueSort">
              <option value="">Sort By Month</option>
              <option value="most-revenue"  <c:if test="${param.revenueSort=='most-revenue'}">selected</c:if>>Highest Revenue</option>
              <option value="least-revenue" <c:if test="${param.revenueSort=='least-revenue'}">selected</c:if>>Lowest Revenue</option>
            </select>
            <i class="fas fa-chevron-down"></i>
          </div>
          <button type="submit" class="apply-btn">Apply</button>
        </form>
        <div class="chart-container">
          <canvas id="revenueChart"></canvas>
        </div>
      </section>

      <!-- Model Sales -->
      <section class="reports-section">
        <h2>Model Sales</h2>
        <hr/>
        <form method="get" class="controls">
          <div class="search-bar">
            <i class="fas fa-search"></i>
            <input
              type="text"
              name="modelName"
              placeholder="Search model..."
              value="${fn:escapeXml(param.modelName)}"/>
          </div>
          <div class="filter-dropdown">
            <input type="date" name="fromDate" value="${param.fromDate}"/>
            <i class="fas fa-calendar-alt"></i>
          </div>
          <div class="filter-dropdown">
            <input type="date" name="toDate" value="${param.toDate}"/>
            <i class="fas fa-calendar-alt"></i>
          </div>
          <div class="filter-dropdown">
            <select name="sort">
              <option value="">Sort By</option>
              <option value="most-sold"  <c:if test="${param.sort=='most-sold'}">selected</c:if>>Most Sold</option>
              <option value="least-sold" <c:if test="${param.sort=='least-sold'}">selected</c:if>>Least Sold</option>
              <option value="latest"     <c:if test="${param.sort=='latest'}">selected</c:if>>Newest</option>
              <option value="oldest"     <c:if test="${param.sort=='oldest'}">selected</c:if>>Oldest</option>
            </select>
            <i class="fas fa-chevron-down"></i>
          </div>
          <button type="submit" class="apply-btn">Apply</button>
        </form>
        <div class="chart-container">
          <canvas id="soldChart"></canvas>
        </div>
      </section>
    </div>
  </div>

  <script>
    // Revenue chart
    const revLabels = [<c:forEach var="lbl" items="${revenueReport.labels}" varStatus="st">${st.index>0?',':''}"${fn:escapeXml(lbl)}"</c:forEach>]||['No Data'];
    const revData   = [<c:forEach var="v" items="${revenueReport.data}" varStatus="st">${st.index>0?',':''}${v}</c:forEach>]||[0];
    new Chart(document.getElementById('revenueChart').getContext('2d'), {
      type:'line',
      data:{ labels:revLabels, datasets:[{ label:'Revenue', data:revData, borderColor:'#111', fill:false, tension:0.3 }] },
      options:{ responsive:true, scales:{ y:{ beginAtZero:true } }}
    });

    // Sold chart
    const soldLabels = [<c:forEach var="lbl" items="${soldReport.labels}" varStatus="st">${st.index>0?',':''}"${fn:escapeXml(lbl)}"</c:forEach>]||['No Data'];
    const soldData   = [<c:forEach var="v" items="${soldReport.data}" varStatus="st">${st.index>0?',':''}${v}</c:forEach>]||[0];
    new Chart(document.getElementById('soldChart').getContext('2d'), {
      type:'bar',
      data:{ labels:soldLabels, datasets:[{ label:'Units Sold', data:soldData, backgroundColor:'#111' }] },
      options:{ responsive:true, scales:{ y:{ beginAtZero:true } }}
    });
  </script>
</body>
</html>
