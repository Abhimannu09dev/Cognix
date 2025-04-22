<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>Seller Models – Cognix</title>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css"/>
<style>
/* Reset & Base */
* { box-sizing: border-box; margin: 0; padding: 0; }
body { font-family: 'Helvetica Neue', sans-serif; background: #F1EDE9; color: #222; }
.dashboard { display: flex; max-width: 1440px; margin: 0 auto; min-height: 100vh; }
.dashboard__nav { width: 240px; }
.dashboard__main { flex: 1; display: flex; flex-direction: column; }
.dashboard__topbar { padding: 1rem 2rem; }
.dashboard__content { flex: 1; padding: 1rem 2rem; overflow-y: auto; display: flex; flex-direction: column; gap: 2rem; }
.stats-overview, .models-section { background: #fff; border-radius: 16px; padding: 1.5rem; }
.stats-cards { display: grid; grid-template-columns: repeat(auto-fit,minmax(200px,1fr)); gap: 1rem; }
.stat-card { background: #fafafa; border: 1px solid #e0e0e0; border-radius: 8px; padding: 1rem; }
.stat-card p { font-size: .75rem; color: #666; }
.stat-card h3 { margin-top: .5rem; font-size: .875rem; color: #222; }
.controls { display: flex; flex-wrap: wrap; gap: 1rem; margin-bottom: 1.5rem; align-items: center; padding: 1rem; }
.search-bar { flex: 1; display: flex; align-items: center; padding-bottom: .25rem; color: #666; }
.search-bar i { margin-right: .5rem; }
.search-bar input { flex: 1; border: none; background: transparent; font-size: 1rem; }
.filter-dropdown select, .filter-dropdown input[type="date"] { appearance: auto; border: 1px solid #ddd; background: #fafafa; border-radius: 8px; padding: .5rem 1rem; font-size: .95rem; }
.add-btn { background-color: #28a745; color: #fff; padding: .5rem 1rem; border: none; border-radius: 8px; cursor: pointer; }
.add-btn:hover { background-color: #218838; }
.edit-btn { background-color: #007bff; color: white; padding: 6px 12px; border: none; border-radius: 6px; cursor: pointer; }
.delete-btn { background-color: #dc3545; color: white; padding: 6px 12px; border: none; border-radius: 6px; cursor: pointer; }
.models-table { width: 100%; border-collapse: collapse; }
.models-table th, .models-table td { padding: .75rem 1rem; text-align: left; border-bottom: 1px solid #f5f5f5; }
.models-table th { background: #fafafa; font-size: .85rem; color: #666; }
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

      <!-- Stats Overview -->
      <section class="stats-overview">
        <h2>Stats Overview</h2>
        <div class="stats-cards">
          <div class="stat-card">
            <p>Total Listings</p>
            <h3>${empty modelsList ? 0 : fn:length(modelsList)}</h3>
          </div>
          <div class="stat-card">
            <p>Total Sales</p>
            <h3>${empty totalSales ? 0 : totalSales}</h3>
          </div>
          <div class="stat-card">
            <p>Total Earnings</p>
            <h3>$${empty totalRevenue ? 0 : totalRevenue}</h3>
          </div>
          <div class="stat-card">
            <p>Most Popular Model</p>
            <h3>${empty mostPopularModelName ? 'None' : mostPopularModelName}</h3>
          </div>
        </div>
      </section>

      <!-- Models Section -->
      <section class="models-section">
        <h2>Listed Models</h2>

        <!-- Filters -->
        <form method="get" class="controls">
          <div class="search-bar" style="border-bottom: 1px solid #ddd; border-radius: 8px; padding: .5rem 1rem;">
            <i class="fas fa-search"></i>
            <input name="search" type="text" placeholder="Search…"/>
          </div>
          <div class="filter-dropdown">
            <select name="modelType">
              <option value="">All Types</option>
              <option value="computer-vision">Computer Vision</option>
              <option value="nlp">NLP</option>
              <option value="reinforcement">Reinforcement</option>
            </select>
          </div>
          <div class="filter-dropdown">
            <input type="date" name="postedAt"/>
          </div>
          <button type="button" id="openAdd" class="add-btn">+ Add Model</button>
        </form>

        <!-- Model Table -->
        <div class="table-wrapper">
          <table class="models-table">
            <thead>
              <tr><th>SN</th><th>Name</th><th>Category</th><th>Listed</th><th>Price</th><th>Sales</th><th>Revenue</th><th>Action</th></tr>
            </thead>
            <tbody>
              <c:forEach var="model" items="${modelsList}" varStatus="status">
                <tr>
                  <td>${status.index + 1}</td>
                  <td>${empty model.name ? 'None' : model.name}</td>
                  <td>${empty model.category ? 'None' : model.category}</td>
                  <td>${empty model.listedDate ? 'None' : model.listedDate}</td>
                  <td>
                    <c:choose>
                      <c:when test="${empty model.price}">
                        $0
                      </c:when>
                      <c:otherwise>
                        $${model.price}
                      </c:otherwise>
                    </c:choose>
                  </td>
                  <td>
                    <c:choose>
                      <c:when test="${empty model.sales}">
                        0
                      </c:when>
                      <c:otherwise>
                        ${model.sales}
                      </c:otherwise>
                    </c:choose>
                  </td>
                  <td>
                    <c:choose>
                      <c:when test="${empty model.revenue}">
                        $0
                      </c:when>
                      <c:otherwise>
                        $${model.revenue}
                      </c:otherwise>
                    </c:choose>
                  </td>
                  <td>
                    <button class="edit-btn">Edit</button>
                    <button class="delete-btn">Delete</button>
                  </td>
                </tr>
              </c:forEach>

              <c:if test="${empty modelsList}">
                <tr><td colspan="8" style="text-align:center;">No models found.</td></tr>
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