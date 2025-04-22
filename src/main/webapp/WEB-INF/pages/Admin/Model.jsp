<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn"  uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8"/>
  <title>Model Management – Cognix Admin</title>
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
    .dashboard__header {
      padding: 2rem 3rem 0;
    }
    .dashboard__header h1 {
      font-size: 1.875rem;
      margin-bottom: 1.5rem;
    }
    .dashboard__content {
      flex: 1;
      padding: 1.5rem 3rem;
      overflow-y: auto;
      display: flex;
      flex-direction: column;
      gap: 0rem;
    }

    /* === Controls === */
    .controls {
      display: flex;
      flex-wrap: wrap;
      gap: 1rem;
      align-items: center;
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
      background: #fafafa;
      border: 1px solid #ddd;
      border-radius: 8px;
      transition: background 0.2s;
    }
    .controls__filter:hover { background: #f0f0f0; }
    .controls__filter select {
      appearance: none; border: none; background: transparent;
      padding: .5rem 1rem; font-size: .95rem; color: #444;
      cursor: pointer; min-width: 140px;
    }
    .controls__filter::after {
      content: "\f078"; font-family: "Font Awesome 6 Free"; font-weight: 900;
      position: absolute; right: .75rem; top: 50%;
      transform: translateY(-50%); pointer-events: none; color: #666;
    }

    .controls__apply-btn {
      background: #111; color: #fff; border: none;
      border-radius: 8px; padding: .5rem 1rem;
      font-size: .95rem; cursor: pointer; white-space: nowrap;
      transition: background 0.2s;
    }
    .controls__apply-btn:hover { background: #333; }

    /* === Table Section === */
    .table-section {
      background: #fff;
      border-radius: 16px;
      padding: 1.5rem;
      box-shadow: 0 2px 8px rgba(0,0,0,0.05);
    }
    .table-section h2 {
      margin: 0 0 1rem;
      font-size: 1.25rem;
      color: #222;
    }
    .table-section hr {
      border: none;
      border-bottom: 1px solid #e0e0e0;
      margin-bottom: 1.5rem;
    }

    /* === Models Table === */
    .model-table {
      width: 100%;
      border-collapse: collapse;
      min-width: 700px;
    }
    .model-table th,
    .model-table td {
      padding: .75rem 1rem;
      text-align: left;
      white-space: nowrap;
      border-bottom: 1px solid #f5f5f5;
      font-size: .95rem;
    }
    .model-table th {
      color: #666;
      font-size: .85rem;
      border-bottom: 1px solid #e0e0e0;
    }
    .model-table tr:last-child td {
      border-bottom: none;
    }
    .model-table tr:hover td {
      background: #f9f9f9;
    }
    .table--empty {
      text-align: center;
      color: #777;
      padding: 1rem;
    }

    /* === Buttons === */
    .btn--delete {
      background: #c00; color: #fff;
      border: none; border-radius: 6px;
      padding: .4rem .8rem; font-size: .9rem;
      cursor: pointer; transition: background .2s;
    }
    .btn--delete:hover { background: #a00; }
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
        <h1>Model Management</h1>
      </header>
      <div class="dashboard__content">
        <form method="get" class="controls">
          <div class="controls__search">
            <i class="fas fa-search"></i>
            <input
              type="text"
              name="q"
              placeholder="Search models…"
              value="${fn:escapeXml(param.q)}"/>
          </div>

          <div class="controls__filter">
            <select name="category">
              <option value="">All Categories</option>
              <option value="computer-vision"
                <c:if test="${param.category=='computer-vision'}">selected</c:if>>
                Computer Vision
              </option>
              <option value="nlp"
                <c:if test="${param.category=='nlp'}">selected</c:if>>
                NLP
              </option>
              <option value="reinforcement"
                <c:if test="${param.category=='reinforcement'}">selected</c:if>>
                Reinforcement
              </option>
            </select>
          </div>

          <div class="controls__filter">
            <select name="sort">
              <option value="">Sort By</option>
              <option value="sales-desc"
                <c:if test="${param.sort=='sales-desc'}">selected</c:if>>
                Sales: High→Low
              </option>
              <option value="sales-asc"
                <c:if test="${param.sort=='sales-asc'}">selected</c:if>>
                Sales: Low→High
              </option>
              <option value="date-desc"
                <c:if test="${param.sort=='date-desc'}">selected</c:if>>
                Date: Newest
              </option>
              <option value="date-asc"
                <c:if test="${param.sort=='date-asc'}">selected</c:if>>
                Date: Oldest
              </option>
            </select>
          </div>

          <button type="submit" class="controls__apply-btn">Apply</button>
        </form>

        <section class="table-section">
          <h2>Manage Models</h2>
          <hr/>
          <div class="table-wrapper">
            <table class="model-table">
              <thead>
                <tr>
                  <th>SN</th>
                  <th>Model Name</th>
                  <th>Category</th>
                  <th>Seller</th>
                  <th>Listed On</th>
                  <th>Price (USD)</th>
                  <th>Action</th>
                </tr>
              </thead>
              <tbody>
                <c:forEach var="model" items="${modelsList}" varStatus="st">
                  <tr>
                    <td>${st.index + 1}</td>
                    <td>${fn:escapeXml(model.name)}</td>
                    <td>${fn:escapeXml(model.category)}</td>
                    <td>@${fn:escapeXml(model.sellerUsername)}</td>
                    <td><fmt:formatDate value="${model.listedDate}" pattern="yyyy-MM-dd"/></td>
                    <td>$${model.price}</td>
                    <td>
                      <button
                        class="btn--delete"
                        onclick="if(confirm('Delete ${fn:escapeXml(model.name)}?')) location.href='${pageContext.request.contextPath}/admin/deleteModel?id=${model.id}';">
                        Delete
                      </button>
                    </td>
                  </tr>
                </c:forEach>
                <c:if test="${empty modelsList}">
                  <tr>
                    <td colspan="7" class="table--empty">No models found.</td>
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
