<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn"  uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
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
	* {
	  box-sizing: border-box;
	  margin: 0;
	  padding: 0;
	}
	html, body { height: 100%; }
	body {
	  font-family: 'Helvetica Neue', sans-serif;
	  background: #F1EDE9;
	  color: #222;
	}
	
	/* === Layout Container === */
	.layout {
	  display: flex;
	  max-width: 1440px;
	  margin: 0 auto;
	  height: 100vh;
	  overflow: hidden;
	}
	
	/* === Main Content (with consistent left/right gutter) === */
	.main-content {
	  flex: 1;
	  display: flex;
	  flex-direction: column;
	  overflow-y: auto;
	  scrollbar-width: none;
	  -ms-overflow-style: none;
	  padding: 2rem;           /* ← uniform gutter on all sides */
	}
	.main-content::-webkit-scrollbar {
	  display: none;
	}
	
	/* === Topbar / Search === */
	.topbar {
	  padding: 1rem 0;
	}
	.search-bar {
	  display: flex;
	  /* max-width: 800px; */
	  margin: 0 auto;
	  align-items: center;
	  border-bottom: 1px solid #ddd;
	  padding-bottom: 1rem;
	}
	.search-bar i {
	  margin-right: .75rem;
	  color: #666;
	}
	.search-bar input {
	  flex: 1;
	  border: none;
	  background: transparent;
	  font-size: 1rem;
	  color: #333;
	  outline: none;
	}
	.search-go {
	  background: none;
	  border: none;
	  cursor: pointer;
	}
	.search-go i {
	  color: #111;
	  font-size: 1.1rem;
	}
	
	/* === Greeting Panel (white “card”) === */
	.greeting-panel {
	  background: #fff;
	  border-radius: 24px;
	  padding: 2rem;
	  margin: 0 0 2rem;        /* vertical spacing only */
	  display: flex;
	  flex-wrap: wrap;
	  justify-content: space-between;
	  align-items: center;
	  gap: 2rem;
	  box-shadow: 0 2px 8px rgba(0,0,0,0.05);
	  transition: transform 0.2s ease-out,
	              box-shadow 0.2s ease-out;
	}
	.greeting-panel:hover {
	  transform: translateY(-4px);
	  box-shadow: 0 6px 16px rgba(0,0,0,0.12);
	}
	.greeting-panel .greeting h1 {
	  font-size: 2rem;
	  line-height: 1.2;
	  margin: 0;
	}
	.stats {
	  display: flex;
	  gap: 1.5rem;
	}
	.stats .card {
	  background: #fff;
	  border-radius: 16px;
	  padding: 1rem 1.5rem;
	  box-shadow: 0 2px 8px rgba(0,0,0,0.05);
	  text-align: center;
	}
	.stats .card__title {
	  font-size: .85rem;
	  color: #666;
	  margin-bottom: .5rem;
	}
	.stats .card__value {
	  font-size: 1.5rem;
	  font-weight: 600;
	}
	
	/* === Section Containers (Featured & Owned) === */
	.section,
	.table-section {
	  background: #fff;
	  border-radius: 24px;
	  padding: 2rem;
	  margin: 0 0 2rem;        /* vertical spacing only */
	  box-shadow: 0 2px 8px rgba(0,0,0,0.05);
	}
	.section__header,
	.table-section .section__header {
	  display: flex;
	  align-items: center;
	  margin-bottom: 1rem;
	}
	.section__header h2 {
	  font-size: 1.25rem;
	  font-weight: 600;
	}
	.section__header hr {
	  flex: 1;
	  margin-left: 1rem;
	  border: none;
	  border-bottom: 1px solid #e0e0e0;
	}
	
	/* === Filter Controls === */
	.controls {
	  display: flex;
	  flex-wrap: wrap;
	  gap: 1rem;
	  align-items: center;
	  margin-bottom: 1.5rem;
	}
	.controls__search {
	  flex: 1 1 200px;
	  max-width: 600px;
	  display: flex;
	  align-items: center;
	  background: #fff;
	  border: 1px solid #ddd;
	  border-radius: 9999px;
	  padding: .5rem 1rem;
	}
	.controls__search i { color: #666; margin-right: .75rem; }
	.controls__search input {
	  flex: 1;
	  border: none;
	  background: transparent;
	  font-size: 1rem;
	  color: #333;
	  outline: none;
	}
	.filter-dropdown {
	  flex: 1 1 100px;
	  min-width: 100px;
	  position: relative;
	  display: inline-flex;
	  align-items: center;
	  background: #fff;
	  border: 1px solid #ddd;
	  border-radius: 9999px;
	  padding: .5rem 1rem;
	  cursor: pointer;
	}
	.filter-dropdown i:first-child { margin-right: .5rem; color: #666; }
	.filter-dropdown select {
	  appearance: none;
	  border: none;
	  background: transparent;
	  font-size: .95rem;
	  color: #444;
	  cursor: pointer;
	}
	.filter-dropdown .fa-chevron-down {
	  position: absolute;
	  right: 1rem;
	  pointer-events: none;
	  font-size: .8rem;
	  color: #666;
	}
	.apply-btn {
	  margin-left: auto;
	  background: #111;
	  color: #fff;
	  border: none;
	  border-radius: 8px;
	  padding: .5rem 1rem;
	  font-size: .95rem;
	  cursor: pointer;
	  transition: background .2s;
	}
	.apply-btn:hover { background: #333; }
	
	/* === Products Grid & Cards === */
	.grid {
	  display: grid;
	  grid-template-columns: repeat(auto-fill, minmax(240px,1fr));
	  gap: 1.5rem;
	}
	.product-card {
	  background: #fff;
	  border-radius: 16px;
	  overflow: hidden;
	  display: flex;
	  flex-direction: column;
	  box-sizing: border-box;
	  border: 1px solid #ddd;
	  box-shadow: 0 2px 8px rgba(0,0,0,0.05);
	  transition: transform .2s, box-shadow .2s;
	}
	.product-card:hover {
	  transform: translateY(-4px);
	  box-shadow: 0 6px 16px rgba(0,0,0,0.12);
	}
	.product-card img {
	  width: 100%;
	  aspect-ratio: 4/3;
	  object-fit: cover;
	}
	.product-card .info {
	  padding: 1rem;
	  flex: 1;
	}
	.product-card .info h3 {
	  font-size: 1.1rem;
	  margin-bottom: .5rem;
	}
	.product-card .info .meta {
	  font-size: .85rem;
	  color: #666;
	  margin-bottom: .5rem;
	}
	.product-card .info .price {
	  font-size: 1.1rem;
	  font-weight: 600;
	  margin-bottom: .25rem;
	}
	.product-card .info .seller {
	  font-size: .85rem;
	  color: #444;
	}
	.product-card .actions {
	  display: flex;
	  gap: .5rem;
	  padding: 1rem;
	  border-top: 1px solid #f0f0f0;
	}
	.btn-view, .btn-cart {
	  flex: 1;
	  text-align: center;
	  padding: .5rem;
	  border-radius: 8px;
	  font-size: .95rem;
	  text-decoration: none;
	  cursor: pointer;
	  transition: background .2s;
	}
	.btn-view {
	  background: #111;
	  color: #fff;
	}
	.btn-view:hover { background: #333; }
	.btn-cart {
	  background: #fafafa;
	  color: #111;
	  border: 1px solid #ddd;
	}
	.btn-cart:hover { background: #f0f0f0; }
	
	/* === Pagination === */
	.pagination {
	  display: flex;
	  gap: .5rem;
	  justify-content: center;
	  padding: 1.5rem 0;
	}
	.pagination button {
	  background: #fff;
	  border: 1px solid #ddd;
	  border-radius: 8px;
	  padding: .5rem .75rem;
	  cursor: pointer;
	  transition: background .2s;
	}
	.pagination button.active {
	  background: #111;
	  color: #fff;
	  border-color: #111;
	}
	.pagination button:hover:not(.active) {
	  background: #f5f5f5;
	}
	
	/* === Footer === */
	.page-footer {
	  padding: 1.5rem 2rem;
	  text-align: center;
	}
	
	/* === Models Owned Card === */
	.table-section {
	  background: #fff;
	  border-radius: 24px;
	  padding: 2rem;
	  box-shadow: 0 2px 8px rgba(0,0,0,0.05);
	  margin-top: 2rem;
	}
	
	/* === Owned Table === */
	.table-wrapper {
	  overflow-x: auto;
	}
	.data-table {
	  width: 100%; border-collapse: collapse;
	}
	.data-table th,
	.data-table td {
	  padding: .75rem 1rem;
	  text-align: left;
	  border-bottom: 1px solid #f5f5f5;
	  font-size: .95rem;
	}
	.data-table th {
	  background: #fafafa;
	  color: #666;
	  font-size: .85rem;
	}
	.data-table tr:last-child td {
	  border-bottom: none;
	}
	.data-table td.no-data {
	  text-align: center;
	  color: #666;
	  padding: 2rem 0;
	}
	
	/* === Footer === */
	.page-footer { padding: 1.5rem 2rem; text-align: center; }
	
	/* === Mobile tweaks === */
	@media (max-width: 768px) {
	  .layout { flex-direction: column; }
	  .main-content { padding: 1rem; }
	  .grid { grid-template-columns: 1fr; }
	  .controls { flex-direction: column; }
	}
</style>
</head>
<body>

  <div class="layout">
    <!-- Sidebar -->
    <aside class="sidebar">
      <jsp:include page="/WEB-INF/pages/component/BuyerNav.jsp"/>
    </aside>

    <!-- Main Content -->
    <div class="main-content">
      <!-- Topbar Search -->
      <header class="topbar">
        <form class="search-bar" action="BuyerDashboard" method="get">
          <i class="fas fa-search"></i>
          <input
            type="text"
            name="search"
            placeholder="Search for anything…"
            value="${fn:escapeXml(param.search)}"/>
          <button type="submit" class="search-go">
            <i class="fas fa-arrow-right"></i>
          </button>
        </form>
      </header>

      <!-- Greeting + Stats -->
      <section class="greeting-panel">
        <div class="greeting">
          <h1>Hey, good morning,<br/>${sessionScope.user.username}</h1>
        </div>
        <div class="stats">
          <div class="card">
            <p class="card__title">Available Models</p>
            <p class="card__value">${fn:length(modelsList)}</p>
          </div>
          <div class="card">
            <p class="card__title">Owned Models</p>
            <p class="card__value">${fn:length(purchasedList)}</p>
          </div>
        </div>
      </section>

      <!-- Featured Models -->
      <section class="section">
        <div class="section__header">
          <h2>Featured Models</h2><hr/>
        </div>
        <form method="get" class="controls" action="BuyerDashboard">
          <div class="controls__search">
            <i class="fas fa-search"></i>
            <input
              name="search"
              type="text"
              placeholder="Search models…"
              value="${fn:escapeXml(param.search)}"/>
          </div>
          <div class="filter-dropdown">
            <i class="fas fa-folder-open"></i>
            <select name="modelType">
              <option value="">All Categories</option>
              <c:forEach var="cat" items="${allCategories}">
                <option
                  value="${fn:escapeXml(cat)}"
                  <c:if test="${param.modelType==cat}">selected</c:if>>
                  ${fn:escapeXml(cat)}
                </option>
              </c:forEach>
            </select>
            <i class="fas fa-chevron-down"></i>
          </div>
          <div class="filter-dropdown">
            <i class="fas fa-sort"></i>
            <select name="sortBy">
              <option value="">Sort By</option>
              <option value="dateDesc" <c:if test="${param.sortBy=='dateDesc'}">selected</c:if>>Newest</option>
              <option value="priceAsc" <c:if test="${param.sortBy=='priceAsc'}">selected</c:if>>Price ↑</option>
              <option value="priceDesc" <c:if test="${param.sortBy=='priceDesc'}">selected</c:if>>Price ↓</option>
            </select>
            <i class="fas fa-chevron-down"></i>
          </div>
          <button type="submit" class="apply-btn">Apply</button>
        </form>

        <div class="grid">
          <c:forEach var="m" items="${modelsList}">
            <div class="product-card">
              <img
                src="${pageContext.request.contextPath}/${fn:escapeXml(m.imagePath)}"
                alt="${fn:escapeXml(m.name)}"/>
              <div class="info">
                <h3>${fn:escapeXml(m.name)}</h3>
                <p class="meta">Category: ${fn:escapeXml(m.category)}</p>
                <p class="price">$${m.price}</p>
                <p class="seller">by @${m.sellerUsername}</p>
              </div>
              <div class="actions">
                <a href="ProductDes?id=${m.modelId}" class="btn-view">View</a>
                <form action="addToCart" method="post" style="margin:0;">
                  <input type="hidden" name="modelId" value="${m.modelId}"/>
                  <button type="submit" class="btn-cart">Add to Cart</button>
                </form>
              </div>
            </div>
          </c:forEach>
        </div>

        <div class="pagination">
          <button class="active">1</button>
          <button>2</button>
          <button>3</button>
          <button>&raquo;</button>
        </div>
      </section>

      <!-- Models Owned -->
      <section class="table-section">
        <div class="section__header">
          <h2>Models Owned</h2><hr/>
        </div>
        <form method="get" class="controls" action="BuyerDashboard">
          <input type="hidden" name="search"      value="${fn:escapeXml(param.search)}"/>
          <input type="hidden" name="modelType"   value="${fn:escapeXml(param.modelType)}"/>
          <input type="hidden" name="sortBy"      value="${fn:escapeXml(param.sortBy)}"/>

          <div class="controls__search">
            <i class="fas fa-search"></i>
            <input
              name="ownedSearch"
              type="text"
              placeholder="Search owned…"
              value="${fn:escapeXml(param.ownedSearch)}"/>
          </div>

          <div class="filter-dropdown">
            <select name="ownedCategory">
              <option value="">All Categories</option>
              <c:forEach var="cat" items="${ownedCategories}">
                <option
                  value="${fn:escapeXml(cat)}"
                  <c:if test="${param.ownedCategory==cat}">selected</c:if>>
                  ${fn:escapeXml(cat)}
                </option>
              </c:forEach>
            </select>
            <i class="fas fa-chevron-down"></i>
          </div>

          <div class="filter-dropdown">
            <select name="purchasedFilter">
              <option value="">All Time</option>
              <option value="7d"   <c:if test="${param.purchasedFilter=='7d'}">selected</c:if>>Last 7 Days</option>
              <option value="30d"  <c:if test="${param.purchasedFilter=='30d'}">selected</c:if>>Last 30 Days</option>
              <option value="365d" <c:if test="${param.purchasedFilter=='365d'}">selected</c:if>>Last Year</option>
            </select>
            <i class="fas fa-chevron-down"></i>
          </div>

          <button type="submit" class="apply-btn">Apply</button>
        </form>

        <div class="table-wrapper">
          <table class="data-table">
            <thead>
              <tr>
                <th>SN</th>
                <th>Name</th>
                <th>Category</th>
                <th>Price (USD)</th>
                <th>Seller</th>
                <th>Purchased</th>
                <th>Action</th>
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
                  <td>
                    <fmt:formatDate
                      value="${p.purchaseDate}"
                      pattern="yyyy-MM-dd"/>
                  </td>
                  <td>
                    <a href="viewModel?id=${p.modelId}" class="btn-view">View</a>
                  </td>
                </tr>
              </c:forEach>
              <c:if test="${empty purchasedList}">
                <tr>
                  <td colspan="7" class="no-data">No models owned.</td>
                </tr>
              </c:if>
            </tbody>
          </table>
        </div>
      </section>

      <footer class="page-footer">
        <jsp:include page="/WEB-INF/pages/component/CopyRight.jsp"/>
      </footer>
    </div>
  </div>

</body>
</html>
