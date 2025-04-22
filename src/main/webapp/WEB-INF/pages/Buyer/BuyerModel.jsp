<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core"       %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"        %>
<%@ taglib prefix="fn"  uri="http://java.sun.com/jsp/jstl/functions"  %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8"/>
  <title>Explore AI Models – Cognix</title>

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
      margin: 0 auto;      /* center horizontally */
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

    /* === Page Title === */
    .page-title {
      font-size: 1.5rem;
      font-weight: 600;
      margin-bottom: 1.5rem;
    }

    /* === Models Section === */
    .models-section {
      background: #fff;
      border: 1px solid #e0e0e0;
      border-radius: 16px;
      padding: 1.5rem;
      max-width: 72rem;
      margin: 0 auto;
    }
    .models-section__header {
      display: flex;
      align-items: center;
      margin-bottom: 1rem;
    }
    .models-section__header h2 {
      font-size: 1.25rem;
      color: #222;
    }
    .models-section__header hr {
      flex: 1;
      margin-left: 1rem;
      border: none;
      border-bottom: 1px solid #e0e0e0;
    }

    /* === Controls === */
    .controls {
      display: flex;
      flex-wrap: wrap;
      align-items: center;
      gap: 1rem;
      margin-bottom: 1.5rem;
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
      display: inline-flex;
      background: #fafafa;
      border: 1px solid #ddd;
      border-radius: 9999px;
      cursor: pointer;
      transition: background .2s;
      padding: .5rem 1rem;
      min-width: 11.375rem;
    }
    .controls__filter:hover { background: #f0f0f0; }
    .controls__filter i.icon { margin-right: .5rem; color: #666; }
    .controls__filter select {
      appearance: none; border: none; background: transparent;
      font-size: .95rem; color: #444; cursor: pointer; width: 100%;
    }
    .controls__filter i.chevron {
      position: absolute; right: .75rem; top: 50%;
      transform: translateY(-50%); pointer-events: none;
      color: #666; font-size: .8rem;
    }

    .controls__input {
      display: inline-flex;
      align-items: center;
      background: #fafafa;
      border: 1px solid #ddd;
      border-radius: 9999px;
      padding: .5rem 1rem;
      gap: .5rem;
    }
    .controls__input i { color: #666; }
    .controls__input input {
      border: none; background: transparent;
      width: 4rem; font-size: .95rem; color: #444;
      outline: none;
    }

    .controls__apply-btn {
      margin-left: auto;
      background: #111; color: #fff; border: none;
      border-radius: 8px; padding: .5rem 1rem;
      font-size: .95rem; cursor: pointer;
      transition: background .2s; white-space: nowrap;
    }
    .controls__apply-btn:hover { background: #333; }

    /* === Table === */
    .table-wrapper { overflow-x: auto; }
    .models-table {
      width: 100%; border-collapse: collapse; table-layout: fixed;
    }
    .models-table th,
    .models-table td {
      padding: .75rem 1rem; text-align: left; vertical-align: middle;
      border-bottom: 1px solid #f5f5f5; font-size: .95rem;
    }
    .models-table th {
      color: #666; font-size: .85rem; border-bottom: 1px solid #e0e0e0;
    }
    .models-table tr:last-child td { border-bottom: none; }
    .models-table td.no-data {
      text-align: center; color: #666; padding: 2rem 0;
    }

    /* === View Button === */
    .view-btn {
      display: inline-block;
      background: #111; color: #fff; border-radius: 8px;
      padding: .5rem 1rem; font-size: .95rem;
      text-decoration: none; text-align: center;
      transition: background .2s;
    }
    .view-btn:hover { background: #333; }
  </style>
</head>
<body>
  <div class="dashboard">
    <aside class="dashboard__nav">
      <jsp:include page="/WEB-INF/pages/component/BuyerNav.jsp"/>
    </aside>

    <div class="dashboard__main">
      <header class="dashboard__topbar">
        <jsp:include page="/WEB-INF/pages/component/SerachBar.jsp"/>
      </header>

      <div class="dashboard__content">
        <div class="page-title">Explore AI Models</div>

        <section class="models-section">
          <div class="models-section__header">
            <h2>Models</h2>
            <hr/>
          </div>

          <form method="get" class="controls">
            <div class="controls__search">
              <i class="fas fa-search"></i>
              <input
                name="search"
                type="text"
                placeholder="Search for anything…"
                value="${fn:escapeXml(param.search)}"/>
            </div>

            <label class="controls__filter">
              <i class="fas fa-folder-open icon"></i>
              <select name="modelType">
                <option value="">Model Type</option>
                <option value="computer-vision" <c:if test="${param.modelType=='computer-vision'}">selected</c:if>>
                  Computer Vision
                </option>
                <option value="nlp" <c:if test="${param.modelType=='nlp'}">selected</c:if>>NLP</option>
                <option value="reinforcement" <c:if test="${param.modelType=='reinforcement'}">selected</c:if>>
                  Reinforcement
                </option>
              </select>
              <i class="fas fa-chevron-down chevron"></i>
            </label>

            <div class="controls__input">
              <i class="fas fa-dollar-sign"></i>
              <input
                name="minPrice"
                type="number"
                min="0"
                placeholder="Min $"
                value="${fn:escapeXml(param.minPrice)}"/>
            </div>

            <div class="controls__input">
              <i class="fas fa-dollar-sign"></i>
              <input
                name="maxPrice"
                type="number"
                min="0"
                placeholder="Max $"
                value="${fn:escapeXml(param.maxPrice)}"/>
            </div>

            <label class="controls__filter">
              <i class="fas fa-sort icon"></i>
              <select name="sortBy">
                <option value="">Sort By</option>
                <option value="priceAsc"<c:if test="${param.sortBy=='priceAsc'}">selected</c:if>>Price ↑</option>
                <option value="priceDesc"<c:if test="${param.sortBy=='priceDesc'}">selected</c:if>>Price ↓</option>
                <option value="dateDesc"<c:if test="${param.sortBy=='dateDesc'}">selected</c:if>>Newest</option>
              </select>
              <i class="fas fa-chevron-down chevron"></i>
            </label>

            <button type="submit" class="controls__apply-btn">Apply</button>
          </form>

          <div class="table-wrapper">
            <table class="models-table">
              <thead>
                <tr>
                  <th>SN</th><th>Model Name</th><th>Category</th>
                  <th>Listed Date</th><th>Price (USD)</th><th>Seller</th><th>View</th>
                </tr>
              </thead>
              <tbody>
                <c:forEach var="m" items="${modelsList}">
                  <tr>
                    <td><c:out value="${m.sn}"/></td>
                    <td><c:out value="${m.modelName}"/></td>
                    <td><c:out value="${m.category}"/></td>
                    <td><fmt:formatDate value="${m.listedDate}" pattern="yyyy-MM-dd"/></td>
                    <td>$<c:out value="${m.price}"/></td>
                    <td>@<c:out value="${m.sellerUsername}"/></td>
                    <td><a href="viewModel?id=${m.modelId}" class="view-btn">View</a></td>
                  </tr>
                </c:forEach>
                <c:if test="${empty modelsList}">
                  <tr>
                    <td colspan="7" class="no-data">No models found.</td>
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
