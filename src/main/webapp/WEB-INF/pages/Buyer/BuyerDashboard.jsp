<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core"       %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"        %>
<%@ taglib prefix="fn"  uri="http://java.sun.com/jsp/jstl/functions"  %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8"/>
  <title>Buyer Dashboard – Cognix</title>

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

    /* === Main area === */
    .dashboard__main {
      flex: 1;
      display: flex;
      flex-direction: column;
    }
    .dashboard__topbar {
      padding: 1rem 2rem;
    }
    .dashboard__content {
      flex: 1;
      padding: 2rem;
      display: flex;
      flex-direction: column;
      gap: 2rem;
      overflow-y: auto;
    }

    /* === Greeting === */
    .dashboard__greeting h1 {
      font-size: 1.5rem;
    }

    /* === Section === */
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
      border-bottom: 1px solid #ccc;
      padding-bottom: .25rem;
      color: #666;
    }
    .controls__search i { margin-right: .75rem; }
    .controls__search input {
      flex: 1;
      border: none;
      background: transparent;
      font-size: 1rem;
      color: #333;
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
      padding: .5rem 1rem;
      font-size: .95rem;
      color: #444;
      border-radius: 8px;
      cursor: pointer;
      min-width: 150px;
    }
    .controls__filter i {
      position: absolute;
      right: .75rem;
      top: 50%;
      transform: translateY(-50%);
      pointer-events: none;
      color: #666;
      font-size: .8rem;
    }

    .controls__apply-btn {
      margin-left: auto;
      background: #111;
      color: #fff;
      border: none;
      border-radius: 8px;
      padding: .5rem 1rem;
      font-size: .95rem;
      cursor: pointer;
      transition: background .2s;
      white-space: nowrap;
    }
    .controls__apply-btn:hover {
      background: #333;
    }

    /* === Tables === */
    .table-wrapper {
      overflow-x: auto;
    }
    .data-table {
      width: 100%;
      border-collapse: collapse;
      table-layout: fixed;
    }
    .data-table th,
    .data-table td {
      padding: .75rem 1rem;
      text-align: left;
      border-bottom: 1px solid #f5f5f5;
      vertical-align: middle;
    }
    .data-table th {
      font-size: .85rem;
      color: #666;
      border-bottom: 1px solid #e0e0e0;
    }
    .data-table tr:last-child td {
      border-bottom: none;
    }
    .data-table td.no-data {
      text-align: center;
      color: #666;
      padding: 2rem 0;
    }

    .view-btn {
      display: inline-block;
      background: #111;
      color: #fff;
      border-radius: 8px;
      padding: .5rem 1rem;
      font-size: .95rem;
      text-decoration: none;
      text-align: center;
      transition: background .2s;
    }
    .view-btn:hover {
      background: #333;
    }
  </style>
</head>
<body>
  <div class="dashboard">
    <!-- Sidebar -->
    <aside class="dashboard__nav">
      <jsp:include page="/WEB-INF/pages/component/BuyerNav.jsp"/>
    </aside>

    <!-- Main Content -->
    <div class="dashboard__main">
      <header class="dashboard__topbar">
        <jsp:include page="/WEB-INF/pages/component/SerachBar.jsp"/>
      </header>

      <div class="dashboard__content">
        <div class="dashboard__greeting">
          <h1>Hey, Good Morning,<br/>${sessionScope.username}</h1>
        </div>

        <!-- Featured Models -->
        <section class="section">
          <div class="section__header">
            <h2>Featured Models</h2>
            <hr/>
          </div>
          <form method="get" class="controls">
            <div class="controls__search">
              <i class="fas fa-search"></i>
              <input
                name="search"
                type="text"
                placeholder="Search models…"
                value="${fn:escapeXml(param.search)}"/>
            </div>
            <div class="controls__filter">
              <select name="modelType">
                <option value="">Model Type</option>
                <option value="computer-vision"  <c:if test="${param.modelType=='computer-vision'}">selected</c:if>>Computer Vision</option>
                <option value="nlp"               <c:if test="${param.modelType=='nlp'}">selected</c:if>>NLP</option>
                <option value="reinforcement"     <c:if test="${param.modelType=='reinforcement'}">selected</c:if>>Reinforcement</option>
              </select>
              <i class="fas fa-chevron-down"></i>
            </div>
            <div class="controls__filter">
              <select name="sortBy">
                <option value="">Sort By</option>
                <option value="date"      <c:if test="${param.sortBy=='date'}">selected</c:if>>Newest</option>
                <option value="priceAsc"  <c:if test="${param.sortBy=='priceAsc'}">selected</c:if>>Price ↑</option>
                <option value="priceDesc" <c:if test="${param.sortBy=='priceDesc'}">selected</c:if>>Price ↓</option>
              </select>
              <i class="fas fa-chevron-down"></i>
            </div>
            <button type="submit" class="controls__apply-btn">Apply</button>
          </form>

          <div class="table-wrapper">
            <table class="data-table">
              <thead>
                <tr>
                  <th>SN</th><th>Name</th><th>Category</th>
                  <th>Listed</th><th>Price</th><th>Seller</th><th>View</th>
                </tr>
              </thead>
              <tbody>
                <c:forEach var="m" items="${modelsList}">
                  <tr>
                    <td>${m.sn}</td>
                    <td>${m.modelName}</td>
                    <td>${m.category}</td>
                    <td><fmt:formatDate value="${m.listedDate}" pattern="yyyy-MM-dd"/></td>
                    <td>$${m.price}</td>
                    <td>@${m.sellerUsername}</td>
                    <td><a href="viewModel?id=${m.modelId}" class="view-btn">View</a></td>
                  </tr>
                </c:forEach>
                <c:if test="${empty modelsList}">
                  <tr><td colspan="7" class="no-data">No models found.</td></tr>
                </c:if>
              </tbody>
            </table>
          </div>
        </section>

        <!-- Models Owned -->
        <section class="section">
          <div class="section__header">
            <h2>Models Owned</h2>
            <hr/>
          </div>
          <form method="get" class="controls">
            <div class="controls__search">
              <i class="fas fa-search"></i>
              <input
                name="ownedSearch"
                type="text"
                placeholder="Search owned…"
                value="${fn:escapeXml(param.ownedSearch)}"/>
            </div>
            <div class="controls__filter">
              <select name="ownedCategory">
                <option value="">All Categories</option>
                <option value="computer-vision"  <c:if test="${param.ownedCategory=='computer-vision'}">selected</c:if>>Computer Vision</option>
                <option value="nlp"               <c:if test="${param.ownedCategory=='nlp'}">selected</c:if>>NLP</option>
                <option value="reinforcement"     <c:if test="${param.ownedCategory=='reinforcement'}">selected</c:if>>Reinforcement</option>
              </select>
              <i class="fas fa-chevron-down"></i>
            </div>
            <div class="controls__filter">
              <select name="purchasedFilter">
                <option value="">All Time</option>
                <option value="7d"   <c:if test="${param.purchasedFilter=='7d'}">selected</c:if>>Last 7 Days</option>
                <option value="30d"  <c:if test="${param.purchasedFilter=='30d'}">selected</c:if>>Last 30 Days</option>
                <option value="365d" <c:if test="${param.purchasedFilter=='365d'}">selected</c:if>>Last Year</option>
              </select>
              <i class="fas fa-chevron-down"></i>
            </div>
            <button type="submit" class="controls__apply-btn">Apply</button>
          </form>

          <div class="table-wrapper">
            <table class="data-table">
              <thead>
                <tr>
                  <th>SN</th><th>Name</th><th>Category</th>
                  <th>Price</th><th>Seller</th><th>Purchased</th><th>Action</th>
                </tr>
              </thead>
              <tbody>
                <c:forEach var="p" items="${purchasedList}">
                  <tr>
                    <td>${p.sn}</td>
                    <td>${p.modelName}</td>
                    <td>${p.category}</td>
                    <td>$${p.price}</td>
                    <td>@${p.sellerUsername}</td>
                    <td><fmt:formatDate value="${p.purchaseDate}" pattern="yyyy-MM-dd"/></td>
                    <td><a href="viewModel?id=${p.modelId}" class="view-btn">View</a></td>
                  </tr>
                </c:forEach>
                <c:if test="${empty purchasedList}">
                  <tr><td colspan="7" class="no-data">No models owned.</td></tr>
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
