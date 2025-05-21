<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn"  uri="http://java.sun.com/jsp/jstl/functions"%>
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
    :root {
      --bg-offwhite:  #F9F8F4;
      --bg-white:     #fff;
      --radius-lg:    24px;
      --radius-sm:    12px;
      --shadow-md:    0 4px 16px rgba(0,0,0,0.1);
      --shadow-sm:    0 2px 6px rgba(0,0,0,0.08);
      --font:         'Helvetica Neue', sans-serif;
      --text:         #222;
      --muted:        #666;
    }
    * { box-sizing: border-box; margin: 0; padding: 0 }
    html, body { height: 100%; }
    body {
      font-family: var(--font);
      background: var(--bg-offwhite);
      color: var(--text);
    }

    /* ── DASHBOARD LAYOUT ── */
    .dashboard {
      display: flex;
      max-width: 1440px;
      margin: 0 auto;
      height: 100vh;
      overflow: hidden;
    }
    .dashboard__nav {
      width: 240px; padding: 1rem 0; position: sticky;
      top: 0; height: 100vh; z-index: 100;
    }
    .dashboard__nav::-webkit-scrollbar { width: 0; background: transparent }
    .dashboard__main {
      flex: 1; display: flex; flex-direction: column;
      overflow-y: auto; scrollbar-width: none; -ms-overflow-style: none;
    }
    .dashboard__main::-webkit-scrollbar { display: none }
    .dashboard__topbar { padding: 1rem 2rem }
    .dashboard__content {
      padding: 2rem; display: flex; flex-direction: column; gap: 2rem;
    }
    .page-title { font-size: 1.75rem; font-weight: 600 }

    /* ── STATS OVERVIEW ── */
    .stats-overview {
      background: var(--bg-white);
      border-radius: var(--radius-lg);
      padding: 2rem; box-shadow: var(--shadow-md);
    }
    .stats-overview__cards {
      display: grid;
      grid-template-columns: repeat(auto-fit,minmax(240px,1fr));
      gap: 1.5rem;
    }
    .stats-card {
      background: var(--bg-white);
      border: 1px solid #ddd;
      border-radius: var(--radius-sm);
      padding: 1.5rem; box-shadow: var(--shadow-sm);
    }
    .stats-card__label { font-size: .85rem; color: var(--muted) }
    .stats-card__value { font-size: 1.25rem; font-weight: 600; margin-top: .5rem }

    /* ── FILTERS & TABLE ── */
    .section {
      background: var(--bg-white);
      border-radius: var(--radius-lg);
      padding: 2rem; box-shadow: var(--shadow-md);
    }
    .section__header {
      display: flex; align-items: center; margin-bottom: 1.5rem;
    }
    .section__header h2 { font-size: 1.5rem }
    .section__header hr {
      flex: 1; margin-left: 1rem;
      border: none; border-bottom: 1px solid #E0E0E0;
    }
    .controls {
      display: flex; flex-wrap: wrap; gap: 1rem;
      align-items: center; margin-bottom: 1.5rem;
    }
    .controls__filter {
      position: relative; display: inline-flex; align-items: center;
      background: var(--bg-white); border: 1px solid #ddd;
      border-radius: 9999px; padding: .5rem 1rem;
      box-shadow: var(--shadow-sm); cursor: pointer;
    }
    .controls__filter select,
    .controls__filter input[type="date"] {
      border: none; background: transparent;
      font-size: .95rem; color: #444; appearance: none;
    }
    .controls__filter select:focus,.controls__filter input[type="date"]:focus {
	  outline: none !important;
	  box-shadow: none !important;
	}
    
    .controls__filter i {
      position: absolute; right: 1rem; pointer-events: none;
      color: var(--muted); font-size: .8rem;
    }
    .controls__apply {
      margin-left: auto; background: #111; color: #fff;
      border: none; border-radius: var(--radius-sm);
      padding: .5rem 1rem; cursor: pointer;
      transition: background .2s; white-space: nowrap;
    }
    .controls__apply:hover { background: #333 }

    .table-wrapper { overflow-x: auto }
    .data-table {
      width: 100%; border-collapse: collapse;
    }
    .data-table th,
    .data-table td {
      padding: .75rem 1rem; text-align: left;
      border-bottom: 1px solid #f0f0f0; font-size: .95rem;
    }
    .data-table th {
      background: #fafafa; color: var(--muted); font-size: .85rem;
    }
    .data-table tr:last-child td { border-bottom: none }
    .no-data {
      text-align: center; color: var(--muted);
      padding: 2rem 0;
    }
    .button--view {
      background: #111; color: #fff; border: none;
      border-radius: var(--radius-sm); padding: .5rem 1rem;
      font-size: .95rem; cursor: pointer; transition: background .2s;
    }
    .button--view:hover { background: #333 }

    /* ── MODAL OVERLAY ── */
    #detailModalBg {
      position: fixed; top: 0; left: 0;
      width: 100vw; height: 100vh;
      background: rgba(0,0,0,0.6);
      display: none; align-items: center; justify-content: center;
      z-index: 1000;
    }
    #detailModalBg.show { display: flex }

    /* ── DETAIL MODAL ── */
    .detail-modal {
      background: var(--bg-white);
      border: 1px solid #ddd;
      border-radius: var(--radius-lg);
      padding: 2rem;
      max-width: 900px;
      width: 90%;
      box-shadow: var(--shadow-md);
      position: relative;
    }
    .detail-modal .close-btn {
      position: absolute; top: 1rem; right: 1rem;
      background: transparent; border: none;
      font-size: 1.5rem; cursor: pointer; color: #666;
    }
    .detail-modal .close-btn:hover { color: #000 }

    .detail-header {
      display: flex; align-items: center;
      justify-content: space-between;
      flex-wrap: wrap;
      margin-bottom: 1.5rem;
    }
    .detail-header h2 {
      margin: 0; font-size: 1.75rem;
    }
    .detail-header .actions {
      display: flex; gap: 1rem;
    }
    .detail-header .actions button {
      display: flex; align-items: center; gap: .5rem;
      padding: .6rem 1.2rem;
      border-radius: var(--radius-sm);
      border: 1px solid #333;
      background: #fff;
      cursor: pointer;
      transition: background .2s;
      font-size: .95rem;
    }
    .detail-header .actions button.docs:hover { background: #f0f0f0; }
    .detail-header .actions button.github {
      background: #24292e; border-color: #24292e; color: #fff;
    }
    .detail-header .actions button.github:hover { background: #3b4148 }

    .detail-section {
      margin-bottom: 1.25rem;
    }
    .detail-section h3 {
      margin-bottom: .5rem;
      font-size: 1.1rem;
      border-bottom: 1px solid #e0e0e0;
      padding-bottom: .25rem;
    }
    .stats-grid {
      display: grid;
      grid-template-columns: repeat(auto-fit,minmax(120px,1fr));
      gap: .75rem;
    }
    .stat {
      padding: .75rem;
      border: 1px solid #ddd;
      border-radius: var(--radius-sm);
      text-align: center;
    }
    .stat .label {
      font-size: .85rem; color: var(--muted);
      margin-bottom: .25rem;
    }
    .stat .value {
      font-size: 1.25rem; font-weight: 600;
    }

    @media (max-width: 800px) {
      .controls, .stats-overview__cards {
        flex-direction: column;
      }
      .detail-modal {
        width: 95%;
        padding: 1.5rem;
      }
    }
  </style>
</head>
<body>
  <div class="dashboard">
    <aside class="dashboard__nav">
      <jsp:include page="/WEB-INF/pages/component/BuyerNav.jsp"/>
    </aside>
    <div class="dashboard__main">
      <div class="dashboard__content">
        <div class="page-title">My Purchased Models</div>

        <!-- Stats -->
        <section class="stats-overview">
          <div class="stats-overview__cards">
            <div class="stats-card">
              <p class="stats-card__label">Total Purchased</p>
              <div class="stats-card__value">${totalPurchased}</div>
            </div>
            <div class="stats-card">
              <p class="stats-card__label">Total Spent</p>
              <div class="stats-card__value">$${totalSpent}</div>
            </div>
            <div class="stats-card">
              <p class="stats-card__label">Most Recent</p>
              <div class="stats-card__value">
                <c:choose>
                  <c:when test="${not empty mostRecentDate}">
                    <fmt:formatDate value="${mostRecentDate}" pattern="yyyy-MM-dd"/>
                  </c:when>
                  <c:otherwise>—</c:otherwise>
                </c:choose>
              </div>
            </div>
          </div>
        </section>

        <!-- Table + Filters -->
        <section class="section">
          <div class="section__header">
            <h2>Purchased Models</h2><hr/>
          </div>
          <form method="get" class="controls">
            <div class="controls__filter">
              <select name="ownedCategory">
                <option value="">All Categories</option>
                <c:forEach var="cat" items="${ownedCategories}">
                  <option value="${fn:escapeXml(cat)}"
                    <c:if test="${param.ownedCategory==cat}">selected</c:if>>
                    ${fn:escapeXml(cat)}
                  </option>
                </c:forEach>
              </select>
              <i class="fas fa-chevron-down"></i>
            </div>
            <div class="controls__filter">
              <input type="date" name="fromDate" value="${param.fromDate}"/><i class="fas fa-calendar-alt"></i>
            </div>
            <div class="controls__filter">
              <input type="date" name="toDate"   value="${param.toDate}"/><i class="fas fa-calendar-alt"></i>
            </div>
            <button type="submit" class="controls__apply">Apply</button>
          </form>

          <div class="table-wrapper">
            <table class="data-table">
              <thead>
                <tr>
                  <th>SN</th><th>Name</th><th>Category</th>
                  <th>Price</th><th>Seller</th><th>Date</th><th>Action</th>
                </tr>
              </thead>
              <tbody>
                <c:forEach var="m" items="${purchasedList}" varStatus="st">
                  <tr>
                    <td>${st.index + 1}</td>
                    <td>${fn:escapeXml(m.name)}</td>
                    <td>${fn:escapeXml(m.category)}</td>
                    <td>$${m.price}</td>
                    <td>@${fn:escapeXml(m.sellerUsername)}</td>
                    <td><fmt:formatDate value="${m.purchaseDate}" pattern="yyyy-MM-dd"/></td>
                    <td>
                      <button
                        class="button--view"
                        data-name      ="${fn:escapeXml(m.name)}"
                        data-desc      ="${fn:escapeXml(m.description)}"
                        data-accuracy  ="${fn:escapeXml(m.accuracy)}"
                        data-precision ="${m.precision}"
                        data-recall    ="${fn:escapeXml(m.recall)}"
                        data-f1        ="${fn:escapeXml(m.f1Score)}"
                        data-params    ="${fn:escapeXml(m.parameters)}"
                        data-latency   ="${fn:escapeXml(m.inferenceTime)}"
                        data-docs      ="${fn:escapeXml(m.docsUrl)}"
                        data-github    ="${fn:escapeXml(m.githubUrl)}">
                        View Details
                      </button>
                    </td>
                  </tr>
                </c:forEach>
                <c:if test="${empty purchasedList}">
                  <tr><td colspan="7" class="no-data">No models purchased.</td></tr>
                </c:if>
              </tbody>
            </table>
          </div>
        </section>
      </div>
    </div>
  </div>

  <!-- Detail Modal -->
  <div id="detailModalBg">
    <div class="detail-modal">
      <button class="close-btn" id="modalClose">&times;</button>
      <div class="detail-header">
        <h2 id="modalTitle">Model Name</h2>
        <div class="actions">
          <button class="docs" id="modalDocs"><i class="fas fa-book-open"></i> Docs</button>
          <button class="github" id="modalGit"><i class="fab fa-github"></i> GitHub</button>
        </div>
      </div>
      <div class="detail-section">
        <h3>Description</h3>
        <p id="modalDesc">—</p>
      </div>
      <div class="detail-section">
        <h3>Stats</h3>
        <div class="stats-grid">
          <div class="stat"><div class="label">Accuracy</div><div class="value" id="statAcc">0</div></div>
          <div class="stat"><div class="label">Precision</div><div class="value" id="statPrec">0</div></div>
          <div class="stat"><div class="label">Recall</div><div class="value" id="statRec">0</div></div>
          <div class="stat"><div class="label">F1 Score</div><div class="value" id="statF1">0</div></div>
          <div class="stat"><div class="label">Params</div><div class="value" id="statPar">0</div></div>
          <div class="stat"><div class="label">Latency</div><div class="value" id="statLat">0 ms</div></div>
        </div>
      </div>
    </div>
  </div>

  <script>
    // open detail modal
    document.querySelectorAll('.button--view').forEach(btn => {
      btn.addEventListener('click', () => {
        document.getElementById('modalTitle').textContent = btn.dataset.name;
        document.getElementById('modalDesc').textContent  = btn.dataset.desc;
        document.getElementById('statAcc').textContent   = btn.dataset.accuracy;
        document.getElementById('statPrec').textContent  = btn.dataset.precision;
        document.getElementById('statRec').textContent   = btn.dataset.recall;
        document.getElementById('statF1').textContent    = btn.dataset.f1;
        document.getElementById('statPar').textContent   = btn.dataset.params;
        document.getElementById('statLat').textContent   = btn.dataset.latency + ' ms';
        document.getElementById('modalDocs').onclick     = () => window.open(btn.dataset.docs, '_blank');
        document.getElementById('modalGit').onclick      = () => window.open(btn.dataset.github, '_blank');
        document.getElementById('detailModalBg').classList.add('show');
        document.body.classList.add('modal-open');
      });
    });

    // close detail modal
    document.getElementById('modalClose').addEventListener('click', () => {
      document.getElementById('detailModalBg').classList.remove('show');
      document.body.classList.remove('modal-open');
    });
    document.getElementById('detailModalBg').addEventListener('click', e => {
      if (e.target.id === 'detailModalBg') {
        e.target.classList.remove('show');
        document.body.classList.remove('modal-open');
      }
    });
  </script>
</body>
</html>
