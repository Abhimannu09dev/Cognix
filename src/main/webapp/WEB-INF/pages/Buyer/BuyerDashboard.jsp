<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn"  uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%
   // expose context path so we can build absolute URLs
   String ctx = request.getContextPath();
%>
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
	.controls__filter::after {
	      content: "\f078";
	      font-family: "Font Awesome 6 Free";
	      font-weight: 900;
	      position: absolute;
	      right: 1rem;
	      pointer-events: none;
	      color: var(--muted);
	}
	.controls__filter select:focus {
	  outline: none !important;
	  box-shadow: none !important;
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
	    flex: 1;
        border: none;
        background: transparent;
        font-size: 1rem;
        color: #333;
        outline: none;
        appearance: none; /* hide default arrow */
	}
	.filter-dropdown .fa-chevron-down {
	  position: absolute;
	  right: 1rem;
	  pointer-events: none;
	  font-size: .8rem;
	  color: #666;
	}
	.filter-dropdown select:focus {
      outline: none !important;
      box-shadow: none !important;
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
	  grid-template-columns: repeat(3, 1fr);
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

/* both direct children: the link and the form */
.product-card .actions > a,
.product-card .actions > form {
  flex: 1;
}

/* make the button fill its parent <form> */
.product-card .actions form .btn-cart {
  width: 100%;
}

/* your existing button styles */
.btn-view,
.btn-cart {
  text-align: center;
  padding: .5rem;
  border-radius: 8px;
  font-size: .95rem;
  cursor: pointer;
  transition: background .2s;
}

.btn-view {
  background: #111;
  color: #fff;
  text-decoration: none;
}

.btn-view:hover {
  background: #333;
}

.btn-cart {
  background: #fafafa;
  color: #111;
  border: 1px solid #ddd;
}

.btn-cart:hover {
  background: #f0f0f0;
}
	
	
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
	/* DETAIL MODAL (borrowed from your purchased-models page) */
    #detailModalBg {
      position:fixed; top:0; left:0;
      width:100vw; height:100vh;
      background:rgba(0,0,0,0.5);
      display:none; align-items:center; justify-content:center;
      z-index:10000;
    }
    #detailModalBg.show { display:flex; }
    .detail-modal {
      background:#fff; border-radius:12px;
      max-width:900px; width:90%; max-height:90vh;
      overflow-y:auto; padding:1.5rem; position:relative;
    }
    .detail-modal .close-btn {
      position:absolute; top:.5rem; right:.5rem;
      background:transparent; border:none;
      font-size:1.5rem; cursor:pointer; color:#666;
    }
    .detail-modal .close-btn:hover { color:#000; }
    .detail-header {
      display:flex; justify-content:space-between;
      align-items:center; flex-wrap:wrap; gap:.5rem;
      margin-bottom:1rem;
    }
    .detail-header h2 { margin:0; font-size:1.5rem; }
    .detail-header .actions {
      display:flex; gap:.5rem; flex-wrap:wrap;
      align-items:center; justify-content:flex-end;
    }
    .detail-header .actions button {
      display:flex; align-items:center; gap:.5rem;
      padding:.5rem 1rem; border-radius:6px; border:1px solid #333;
      background:#fff; cursor:pointer; transition:background .2s;
      font-size:.95rem;
    }
    .detail-header .actions button.docs:hover { background:#f0f0f0; }
    .detail-header .actions button.github {
      background:#24292e; border:none; color:#fff;
    }
    .detail-header .actions button.github:hover { background:#3b4148; }
    .detail-section { margin-bottom:1.25rem; }
    .detail-section h3 {
      margin-bottom:.5rem; font-size:1.1rem;
      border-bottom:1px solid #e0e0e0; padding-bottom:.25rem;
    }
    .stats-grid {
      display:grid;
      grid-template-columns:repeat(auto-fit,minmax(120px,1fr));
      gap:.75rem;
    }
    .stat {
      padding:.75rem; border:1px solid #ddd;
      border-radius:6px; text-align:center;
    }
    .stat .label { font-size:.85rem; color:#666; margin-bottom:.25rem; }
    .stat .value { font-size:1.25rem; font-weight:600; }
	
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
		      <img src="${pageContext.request.contextPath}/uploads/${fn:escapeXml(m.imagePath)}" alt="${fn:escapeXml(m.name)}"/>
		      
		      <div class="info">
		        <h3>${fn:escapeXml(m.name)}</h3>
		        <p class="meta">Category: ${fn:escapeXml(m.category)}</p>
		        <p class="price">$${m.price}</p>
		        <p class="seller">by @${m.sellerUsername}</p>
		      </div>
		      <div class="actions">
		        <a href="ProductDes?id=${m.modelId}" class="btn-view">View</a>
		        <form action="${pageContext.request.contextPath}/addToCart" method="post" style="margin:0;">
				  <input type="hidden" name="modelId" value="${m.modelId}"/>
				  <button type="submit" class="btn-cart">Add to Cart</button>
				</form>
		        
		      </div>
		    </div>
		  </c:forEach>
		  <c:if test="${empty modelsList}">
		    <div class="no-data">No models found.</div>
		  </c:if>
		</div>
		
		<!-- pagination -->
		<div class="pagination">
		  <c:forEach var="i" begin="1" end="${totalPages}">
		    <c:url var="pageUrl" value="BuyerDashboard">
		      <c:param name="page" value="${i}" />
		      <c:if test="${not empty param.search}">
		        <c:param name="search" value="${param.search}" />
		      </c:if>
		      <c:if test="${not empty param.modelType}">
		        <c:param name="modelType" value="${param.modelType}" />
		      </c:if>
		      <c:if test="${not empty param.sortBy}">
		        <c:param name="sortBy" value="${param.sortBy}" />
		      </c:if>
		    </c:url>
		    <a href="${pageUrl}">
		      <button type="button" class="${i == currentPage ? 'active' : ''}">
		        ${i}
		      </button>
		    </a>
		  </c:forEach>
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
                     <button
                      class="btn-view"
                      data-name="${fn:escapeXml(p.modelName)}"
                      data-desc="${fn:escapeXml(p.description)}"
                      data-accuracy="${p.accuracy}"
                      data-precision="${p.precision}"
                      data-recall="${p.recall}"
                      data-f1="${p.f1Score}"
                      data-params="${p.parameters}"
                      data-latency="${p.inferenceTime}"
                      data-docs="${p.docsUrl}"
                      data-github="${p.githubUrl}">
                      View
                    </button>
                  </td>
                </tr>
              </c:forEach>
              <c:if test="${empty purchasedList}">
			  <tr>
			    <td colspan="7" class="no-data" style="text-align:center;">
			      No models owned.
			    </td>
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
  
  <!-- DETAIL MODAL -->
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
document.addEventListener('DOMContentLoaded', () => {
  const params = new URLSearchParams(window.location.search);
  if (!params.has('added')) return;

  const added   = params.get('added') === 'true';
  const message = added
    ? '✅ Added to cart!'
    : '⚠️ Already in cart';
  const color   = added ? '#4caf50' : '#f44336';  // green vs red

  const toast = document.createElement('div');
  toast.textContent = message;
  Object.assign(toast.style, {
    position: 'fixed',
    bottom:  '1.5rem',
    right:   '1.5rem',
    background: color,
    color:      '#fff',
    padding:    '0.75rem 1.25rem',
    borderRadius: '8px',
    fontSize:     '0.95rem',
    zIndex:       1000,
    boxShadow:    '0 2px 6px rgba(0,0,0,0.2)',
    fontFamily:   'sans-serif'
  });
  document.body.appendChild(toast);

  setTimeout(() => {
    toast.remove();
    // remove the query param so it doesn't reappear on reload
    const u = new URL(window.location);
    u.searchParams.delete('added');
    window.history.replaceState({}, '', u);
  }, 3000);
});

// wire up every “View” button to open the modal
document.querySelectorAll('.btn-view').forEach(btn => {
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

// close
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
