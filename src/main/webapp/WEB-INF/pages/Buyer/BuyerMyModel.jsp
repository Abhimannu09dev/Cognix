<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core"       %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"        %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8"/>
  <title>My Purchased Models – Cognix</title>

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
	  margin: 0;
	  font-family: 'Helvetica Neue', sans-serif;
	  background: #F1EDE9;
	  color: #222;
	}
	
	/* Center the whole dashboard at max‑width */
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
	}

    /* === Page Title === */
    .page-title {
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
    .stats-overview__header {
      margin-bottom: 1rem;
    }
    .stats-overview__header h2 {
      font-size: 1.25rem;
      color: #222;
    }
    .stats-overview__cards {
      display: grid;
      grid-template-columns: repeat(auto-fit, minmax(200px,1fr));
      gap: 1rem;
    }
    .stats-card {
      background: #f9f9f9;
      border: 1px solid #e0e0e0;
      border-radius: 8px;
      padding: 1rem;
    }
    .stats-card__label {
      font-size: .75rem;
      color: #666;
    }
    .stats-card__value {
      font-size: .875rem;
      color: #222;
      margin-top: .5rem;
    }

    /* === Models Section === */
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
    .controls__filter {
      position: relative;
    }
    .controls__filter select,
    .controls__filter input[type="date"] {
      appearance: none;
      border: none;
      background: #fafafa;
      padding: .5rem 1rem;
      font-size: .95rem;
      color: #444;
      border: 1px solid #ddd;
      border-radius: 8px;
      cursor: pointer;
      min-width: 140px;
    }
    .controls__filter i {
      position: absolute;
      right: .75rem;
      top: 50%;
      transform: translateY(-50%);
      color: #666;
      font-size: .8rem;
      pointer-events: none;
    }
    .controls__apply {
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
    .controls__apply:hover {
      background: #333;
    }

    /* === Table === */
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
      vertical-align: middle;
      border-bottom: 1px solid #f5f5f5;
      font-size: .95rem;
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

    /* === Buttons === */
    .button--view {
      display: inline-block;
      background: #111;
      color: #fff;
      border-radius: 8px;
      padding: .5rem 1rem;
      font-size: .95rem;
      text-decoration: none;
      cursor: pointer;
      transition: background .2s;
    }
    .button--view:hover {
      background: #333;
    }
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
        <div class="page-title">My Purchased Models</div>

        <!-- Summary Stats -->
        <section class="stats-overview">
          <div class="stats-overview__header">
            <h2>Models Summary</h2>
          </div>
          <div class="stats-overview__cards">
            <div class="stats-card">
              <p class="stats-card__label">Total Models Purchased</p>
              <h3 class="stats-card__value">
                <c:out value="${totalPurchased}" default="0"/>
              </h3>
            </div>
            <div class="stats-card">
              <p class="stats-card__label">Total Amount Spent</p>
              <h3 class="stats-card__value">
                $<c:out value="${totalSpent}" default="0.00"/>
              </h3>
            </div>
            <div class="stats-card">
              <p class="stats-card__label">Most Recent Purchase</p>
              <h3 class="stats-card__value">
                <c:out value="${mostRecentDate}" default="—"/>
              </h3>
            </div>
          </div>
        </section>

        <!-- Purchased Models -->
        <section class="section">
          <div class="section__header">
            <h2>Purchased Models</h2>
            <hr/>
          </div>

          <form method="get" class="controls">
            <div class="controls__filter">
              <select name="category">
                <option value="">All Categories</option>
                <option value="computer-vision"  <c:if test="${param.category=='computer-vision'}">selected</c:if>>Computer Vision</option>
                <option value="nlp"               <c:if test="${param.category=='nlp'}">selected</c:if>>NLP</option>
                <option value="reinforcement"     <c:if test="${param.category=='reinforcement'}">selected</c:if>>Reinforcement</option>
              </select>
              <i class="fas fa-chevron-down"></i>
            </div>
            <div class="controls__filter">
              <input type="date" name="fromDate" value="${param.fromDate}"/>
              <i class="fas fa-calendar-alt"></i>
            </div>
            <div class="controls__filter">
              <input type="date" name="toDate" value="${param.toDate}"/>
              <i class="fas fa-calendar-alt"></i>
            </div>
            <button type="submit" class="controls__apply">Apply</button>
          </form>

          <div class="table-wrapper">
            <table class="data-table">
              <thead>
                <tr>
                  <th>SN</th>
                  <th>Model Name</th>
                  <th>Category</th>
                  <th>Price (USD)</th>
                  <th>Seller</th>
                  <th>Purchased Date</th>
                  <th>Action</th>
                </tr>
              </thead>
              <tbody>
                <c:forEach var="m" items="${purchasedList}" varStatus="st">
                  <tr>
                    <td><c:out value="${st.index + 1}" default="0"/></td>
                    <td><c:out value="${m.modelName}" default="—"/></td>
                    <td><c:out value="${m.category}" default="—"/></td>
                    <td>$<c:out value="${m.price}" default="0"/></td>
                    <td>@<c:out value="${m.sellerUsername}" default="—"/></td>
                    <td><fmt:formatDate value="${m.purchaseDate}" pattern="yyyy-MM-dd"/></td>
                    <td>
                      <a href="viewModel?id=${m.modelId}" class="button--view">View</a>
                    </td>
                  </tr>
                </c:forEach>
                <c:if test="${empty purchasedList}">
                  <tr>
                    <td colspan="7" class="no-data">No models purchased.</td>
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
