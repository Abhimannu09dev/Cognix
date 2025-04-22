<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8"/>
  <title>${model.name} – Cognix</title>
  <style>
    * { box‑sizing: border-box; margin: 0; padding: 0; }
    body { font-family: 'Helvetica Neue', sans-serif; background: #F1EDE9; color: #333; }
    .main { display: flex; height: 100vh; max-width: 1440px; margin: 0 auto; }
    aside { width: 280px; }
    .content { flex: 1; overflow-y: auto; padding: 1.5rem; }
    /* === Search Bar === */
    .search-wrapper { margin-bottom: 1.5rem; }
    /* === Header === */
    .model-header {
      display: flex;
      flex-wrap: wrap;
      justify-content: space-between;
      align-items: center;
      margin-bottom: 2rem;
    }
    .model-header .info {
      flex: 1 1 60%;
    }
    .model-header h1 {
      font-size: 2rem;
      margin-bottom: .25rem;
    }
    .model-header .meta {
      color: #666;
      font-size: .9rem;
    }
    .model-header .actions {
      display: flex;
      gap: .75rem;
      margin-top: .75rem;
    }
    .model-header .actions button {
      padding: .6rem 1.2rem;
      border-radius: 8px;
      border: 1px solid #333;
      background: #fff;
      cursor: pointer;
      font-size: 1rem;
      transition: background .2s;
    }
    .model-header .actions .buy { background: #333; color: #fff; border: none; }
    .model-header button:hover { background: #000; color: #fff; }

    /* === Description === */
    .description {
      background: #fff;
      padding: 1.5rem;
      border-radius: 12px;
      box-shadow: 0 2px 8px rgba(0,0,0,0.05);
      margin-bottom: 2rem;
    }
    .description h2 { margin-bottom: .75rem; font-size: 1.25rem; }
    .description p { line-height: 1.6; color: #444; }

    /* === Stats === */
    .stats {
      background: #fff;
      padding: 1.5rem;
      border-radius: 12px;
      box-shadow: 0 2px 8px rgba(0,0,0,0.05);
    }
    .stats h2 { margin-bottom: 1rem; font-size: 1.25rem; }
    .stats-grid {
      display: grid;
      grid-template-columns: repeat(auto-fill, minmax(200px,1fr));
      gap: 1rem;
    }
    .stat-card {
      padding: 1rem;
      border: 1px solid #e0e0e0;
      border-radius: 8px;
      text-align: center;
    }
    .stat-card .label { font-size: .9rem; color: #666; margin-bottom: .5rem; }
    .stat-card .value { font-size: 1.5rem; font-weight: 600; }

    @media (max-width: 800px) {
      .model-header { flex-direction: column; align-items: flex-start; }
      .model-header .actions { margin-top: 1rem; }
    }
  </style>
</head>
<body>

  <div class="main">
    <!-- Sidebar -->
    <aside>
      <jsp:include page="/WEB-INF/pages/component/BuyerNav.jsp"/>
    </aside>

    <!-- Main content -->
    <div class="content">

      <!-- Search bar -->
      <div class="search-wrapper">
        <jsp:include page="/WEB-INF/pages/component/SerachBar.jsp"/>
      </div>

      <!-- Model title, meta & actions -->
      <div class="model-header">
        <div class="info">
          <h1><c:out value="${model.name}"/></h1>
          <div class="meta">
            by <c:out value="${model.author}"/> |
            <fmt:formatDate value="${model.listedDate}" pattern="yyyy‑MM‑dd"/> |
            Category: <c:out value="${model.category}"/>
          </div>
        </div>
        <div class="actions">
          <button onclick="location.href='${pageContext.request.contextPath}/Docs/${model.id}'">
            View Docs
          </button>
          <button class="buy" onclick="location.href='${pageContext.request.contextPath}/Cart?add=${model.id}'">
            Buy Now
          </button>
        </div>
      </div>

      <!-- Description section -->
      <section class="description">
        <h2>Description</h2>
        <p><c:out value="${model.description}"/></p>
      </section>

      <!-- Stats section -->
      <section class="stats">
        <h2>Model Stats</h2>
        <div class="stats-grid">
          <div class="stat-card">
            <div class="label">Accuracy</div>
            <div class="value"><c:out value="${model.accuracy}"/></div>
          </div>
          <div class="stat-card">
            <div class="label">Precision</div>
            <div class="value"><c:out value="${model.precision}"/></div>
          </div>
          <div class="stat-card">
            <div class="label">Recall</div>
            <div class="value"><c:out value="${model.recall}"/></div>
          </div>
          <div class="stat-card">
            <div class="label">Parameters</div>
            <div class="value"><c:out value="${model.parameters}"/></div>
          </div>
          <div class="stat-card">
            <div class="label">F1 Score</div>
            <div class="value"><c:out value="${model.f1Score}"/></div>
          </div>
          <div class="stat-card">
            <div class="label">Inference Time</div>
            <div class="value"><c:out value="${model.inferenceTime}"/> ms</div>
          </div>
        </div>
      </section>

    </div>
  </div>

</body>
</html>
