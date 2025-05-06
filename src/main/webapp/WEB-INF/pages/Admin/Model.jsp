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
  <style type="text/css">
    :root {
      --bg-offwhite: #F1EDE9;
      --bg-white:    #fff;
      --radius-lg:   24px;
      --radius-sm:   8px;
      --shadow-md:   0 2px 8px rgba(0,0,0,0.05);
      --shadow-sm:   0 1px 4px rgba(0,0,0,0.05);
      --font:        'Helvetica Neue', sans-serif;
      --text:        #222;
      --muted:       #666;
      --accent:      #111;
    }

    /* ── Dashboard Container ── */
    .dashboard {
      display: flex;
      max-width: 1440px;
      margin: 0 auto;
      height: 100vh;           /* fill viewport height */
      overflow: hidden;        /* hide overall scrollbars */
      padding: 0rem;
      padding-left: 0.1rem;
    }
    .dashboard__nav {
      width: 240px;

      /* stick nav in place & allow internal scroll */
      position: sticky;
      top: 0;
      height: 100vh;
      overflow-y: auto;
    }
    .dashboard__main {
      flex: 1;
      display: flex;
      flex-direction: column;

      /* only this pane scrolls */
      overflow-y: auto;
      scrollbar-width: none;    /* firefox */
    }
    .dashboard__main::-webkit-scrollbar {
      display: none;            /* webkit */
    }

    /* ── Header ── */
    .dashboard__header {
      padding: 1.5rem 2rem;
    }
    .dashboard__header h1 {
      font-size: 1.75rem;
      color: var(--accent);
    }

    /* ── Content ── */
    .dashboard__content {
      padding: 1.5rem 2rem;
    }

    /* ── Section wrapper ── */
    .section {
      background: var(--bg-white);
      border-radius: var(--radius-lg);
      padding: 2rem;
      box-shadow: var(--shadow-md);
      margin-bottom: 2rem;
    }
    .section__header {
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

    /* ── Controls ── */
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
      border-bottom: 1px solid #ddd;
      padding-bottom: .5rem;
      color: var(--muted);
    }
    .controls__search i { margin-right: .75rem; }
    .controls__search input {
      flex: 1;
      border: none;
      background: transparent;
      font-size: 1rem;
      color: var(--text);
      outline: none;
    }

    .controls__filter {
      position: relative;
      display: inline-flex;
      align-items: center;
      background: var(--bg-white);
      border: 1px solid #ddd;
      border-radius: 9999px;
      padding: .5rem 1rem;
      cursor: pointer;
      box-shadow: var(--shadow-sm);
      transition: background .2s;
    }
    .controls__filter:hover { background: #f9f9f9; }
    .controls__filter select {
      appearance: none;
      border: none;
      background: transparent;
      font-size: .95rem;
      color: #444;
    }
    .controls__filter::after {
      content: "\f078";
      font-family: "Font Awesome 6 Free";
      font-weight: 900;
      position: absolute;
      right: 1rem;
      pointer-events: none;
      color: var(--muted);
    }

    .controls__apply {
      margin-left: auto;
      background: var(--accent);
      color: var(--bg-white);
      border: none;
      border-radius: var(--radius-sm);
      padding: .5rem 1rem;
      font-size: .95rem;
      cursor: pointer;
      transition: background .2s;
    }
    .controls__apply:hover { background: #333; }

    /* ── Table ── */
    .table-wrapper { overflow-x: auto; }
    .data-table {
      width: 100%;
      border-collapse: collapse;
      table-layout: fixed;
    }
    .data-table th,
    .data-table td {
      padding: .75rem 1rem;
      text-align: left;
      border-bottom: 1px solid #f0f0f0;
      overflow: hidden;
      text-overflow: ellipsis;
      white-space: nowrap;
    }
    .data-table th {
      background: #fafafa;
      font-size: .85rem;
      color: var(--muted);
    }
    .data-table th:first-child { width: 60px; }
    .data-table tbody tr:hover td { background: #f9f9f9; }
    .no-data {
      text-align: center;
      color: #777;
      padding: 2rem 0;
    }

    /* ── View button ── */
    .view-btn {
      background: var(--accent);
      color: var(--bg-white);
      border: none;
      border-radius: var(--radius-sm);
      padding: .5rem .8rem;
      font-size: .85rem;
      cursor: pointer;
      transition: background .2s;
    }
    .view-btn:hover { background: #333; }

    /* ── Responsive ── */
    @media (max-width: 768px) {
      .dashboard { flex-direction: column; }
      .dashboard__nav { width: 100%; }
      .dashboard__content { padding: 1rem; }
      .controls { flex-direction: column; }
      .controls__apply { width: 100%; margin-left: 0; }
    }
  </style>
</head>
<body>
  <div class="dashboard">
    <aside class="dashboard__nav">
      <jsp:include page="../component/AdminNav.jsp"/>
    </aside>
    <div class="dashboard__main">
      <header class="dashboard__header">
        <h1>Model Management</h1>
      </header>
      <div class="dashboard__content">
        <section class="section">
          <div class="section__header">
            <h2>Manage Models</h2><hr/>
          </div>
          <form method="get" class="controls">
            <div class="controls__search">
              <i class="fas fa-search"></i>
              <input type="text" name="q" placeholder="Search models…"
                     value="${fn:escapeXml(param.q)}"/>
            </div>
            <div class="controls__filter">
              <select name="category">
                <option value="">All Categories</option>
                <c:forEach var="cat" items="${modelCategories}">
                  <option value="${fn:escapeXml(cat)}"
                    <c:if test="${param.category == cat}">selected</c:if>>
                    ${fn:escapeXml(cat)}
                  </option>
                </c:forEach>
              </select>
            </div>
            <div class="controls__filter">
              <select name="sort">
                <option value="">Sort By</option>
                <option value="sales-desc" <c:if test="${param.sort=='sales-desc'}">selected</c:if>>Sales High→Low</option>
                <option value="sales-asc"  <c:if test="${param.sort=='sales-asc'}">selected</c:if>>Sales Low→High</option>
                <option value="date-desc"  <c:if test="${param.sort=='date-desc'}">selected</c:if>>Newest</option>
                <option value="date-asc"   <c:if test="${param.sort=='date-asc'}">selected</c:if>>Oldest</option>
              </select>
            </div>
            <button type="submit" class="controls__apply">Apply</button>
          </form>
          <div class="table-wrapper">
            <table class="data-table">
              <thead>
                <tr><th>SN</th><th>Name</th><th>Category</th><th>Seller</th><th>Listed On</th><th>Price</th></tr>
              </thead>
              <tbody>
                <c:forEach var="model" items="${modelsList}" varStatus="st">
                  <tr>
                    <td>${st.index+1}</td>
                    <td>${fn:escapeXml(model.name)}</td>
                    <td>${fn:escapeXml(model.category)}</td>
                    <td>@${fn:escapeXml(model.sellerUsername)}</td>
                    <td><fmt:formatDate value="${model.listedDate}" pattern="yyyy-MM-dd"/></td>
                    <td>$${model.price}</td>
                  </tr>
                </c:forEach>
                <c:if test="${empty modelsList}">
                  <tr><td colspan="7" class="no-data">No models found.</td></tr>
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
