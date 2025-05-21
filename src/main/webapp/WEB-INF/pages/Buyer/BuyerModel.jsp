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
  * { box-sizing: border-box; margin:0; padding:0 }
  html, body { height:100% }
  body {
    background: #F9F8F4;
    font-family: 'Helvetica Neue', sans-serif;
    color: #222;
  }

  /* === Layout === */
.dashboard {
  display: flex;
  max-width: 1440px;
  margin: 0 auto;
  height: 100vh;
  /* overflow: hidden;  ← removed */
}

/* ← make nav sticky */
.dashboard__nav {
  position: sticky;
  top: 0;
  align-self: flex-start;
  height: 100vh;
  overflow-y: auto;
  flex-shrink: 0;
  padding-top: 1rem;
}

/* only this scrolls */
.dashboard__main {
  flex: 1;
  overflow-y: auto;
  scrollbar-width: none;
}
.dashboard__main::-webkit-scrollbar {
  display: none;
}

  .dashboard__topbar { padding:1rem 2rem; }
  .dashboard__content {
    flex:1; padding:2rem; display:flex; flex-direction:column; gap:2rem;
  }

  /* === Page Title === */
  .page-title {
    font-size:1.75rem; font-weight:600;
  }

  /* === Models Section === */
  .models-section {
    background: #fff;
    border-radius: 24px;
    padding: 2rem;
    box-shadow: 0 2px 8px rgba(0,0,0,0.05);
    margin-bottom: 2rem;
    transition: box-shadow .3s;
  }
  .models-section:hover {
    box-shadow: 0 6px 16px rgba(0,0,0,0.1);
  }
  .models-section__header {
    display: flex; align-items: center; margin-bottom:1.5rem;
  }
  .models-section__header h2 { font-size:1.5rem; }
  .models-section__header hr {
    flex:1; margin-left:1rem; border:none; border-bottom:1px solid #E0E0E0;
  }

  /* === Controls === */
  .controls {
    display:flex; flex-wrap:wrap; align-items:center; gap:1rem; margin-bottom:1.5rem;
  }
  .controls__search {
    flex:1 1 200px; display:flex; align-items:center;
    background:#fff; border:1px solid #ddd; border-radius:9999px;
    padding:.5rem 1rem; box-shadow:0 1px 3px rgba(0,0,0,0.05);
  }
  .controls__search i { margin-right:.75rem; color:#666 }
  .controls__search input {
    flex:1; border:none; background:transparent;
    font-size:1rem; color:#333; outline:none;
  }

  .controls__filter {
    position:relative; display:inline-flex; align-items:center;
    background:#fff; border:1px solid #ddd; border-radius:9999px;
    padding:.5rem 1rem; box-shadow:0 1px 3px rgba(0,0,0,0.05);
    cursor:pointer; min-width:150px;
  }
  .controls__filter:hover { background:#f5f5f5 }
  .controls__filter i.icon { margin-right:.5rem; color:#666 }
  .controls__filter select {
    appearance:none; border:none; background:transparent;
    font-size:.95rem; color:#444; cursor:pointer; width:100%;
  }
  .controls__filter select:focus {
	  outline: none !important;
	  box-shadow: none !important;
	}
  
  .controls__filter .chevron {
    position:absolute; right:1rem; pointer-events:none;
    color:#666; font-size:.8rem;
  }

  .controls__input {
    display:flex; align-items:center;
    background:#fff; border:1px solid #ddd; border-radius:9999px;
    padding:.5rem 1rem; box-shadow:0 1px 3px rgba(0,0,0,0.05);
  }
  .controls__input i { margin-right:.75rem; color:#666 }
  .controls__input input {
    border:none; background:transparent; font-size:1rem;
    color:#333; width:4rem; outline:none;
  }
  
  .controls__apply-btn {
    margin-left:auto; background:#111; color:#fff; border:none;
    border-radius:8px; padding:.5rem 1rem; font-size:.95rem;
    cursor:pointer; white-space:nowrap; box-shadow:0 1px 3px rgba(0,0,0,0.1);
    transition:background .2s, transform .2s;
  }
  .controls__apply-btn:hover {
    background:#333; transform:translateY(-2px);
  }

  /* === Grid & Cards === */
  .grid {
	  display: grid;
	  grid-template-columns: repeat(3, 1fr);
	  gap: 1.5rem;
	}
  
  .product-card {
    background:#fff; border-radius:16px; overflow:hidden;
    display:flex; flex-direction:column;
    box-shadow:0 2px 8px rgba(0,0,0,0.05);
    transition:transform .3s,box-shadow .3s;
  }
  .product-card:hover {
    transform:translateY(-6px);
    box-shadow:0 8px 20px rgba(0,0,0,0.1);
  }
  .product-card img {
    width:100%; aspect-ratio:4/3; object-fit:cover;
  }
  .product-card .info {
    padding:1rem; flex:1;
  }
  .product-card .info h3 {
    font-size:1.1rem; margin-bottom:.5rem;
  }
  .product-card .info .meta {
    font-size:.85rem; color:#666; margin-bottom:.5rem;
  }
  .product-card .info .price {
    font-size:1.1rem; font-weight:600; margin-bottom:.25rem;
  }
  .product-card .info .seller {
    font-size:.85rem; color:#444;
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
    display:flex; gap:.5rem; justify-content:center; margin-top:1.5rem;
  }
  .pagination button {
    background:#fff; border:1px solid #ddd;
    border-radius:8px; padding:.5rem .75rem;
    cursor:pointer; transition:background .2s;
  }
  .pagination button.active {
    background:#111; color:#fff; border-color:#111;
  }
  .pagination button:hover:not(.active) {
    background:#f5f5f5;
  }

  /* === No-data helper === */
  /* make the “no-data” div span across every column in the grid */
.grid .no-data {
  grid-column: 1 / -1;      /* start at first column, end at last */
  justify-self: center;     /* center it horizontally */
  text-align: center;       /* center the text inside */
  color: #666;
  padding: 2rem 0;
}
  

  /* === Responsive === */
  @media(max-width:768px) {
    .dashboard { flex-direction:column }
    .dashboard__nav { width:100%; }
    .dashboard__content { padding:1rem }
    .grid { grid-template-columns:1fr }
    .controls { flex-direction:column }
    .controls__apply-btn { width:100%; margin-left:0 }
  }
  @media (max-width: 900px) {
	  .grid {
	    grid-template-columns: repeat(2, 1fr);
	  }
	}
	@media (max-width: 600px) {
	  .grid {
	    grid-template-columns: 1fr;
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
        <div class="page-title">Explore AI Models</div>

        <section class="models-section">
          <div class="models-section__header">
            <h2>Models</h2><hr/>
          </div>

          <form method="get" class="controls">
            <div class="controls__search">
              <i class="fas fa-search"></i>
              <input name="search" type="text" placeholder="Search…" value="${fn:escapeXml(param.search)}"/>
            </div>
            <label class="controls__filter">
              <i class="fas fa-folder-open icon"></i>
              <select name="modelType">
                <option value="">All Categories</option>
                <c:forEach var="cat" items="${allCategories}">
                  <option value="${fn:escapeXml(cat)}" <c:if test="${param.modelType==cat}">selected</c:if>>
                    ${fn:escapeXml(cat)}
                  </option>
                </c:forEach>
              </select>
              <i class="fas fa-chevron-down chevron"></i>
            </label>
            <div class="controls__input">
              <i class="fas fa-dollar-sign"></i>
              <input name="minPrice" type="number" min="0" placeholder="Min $" value="${fn:escapeXml(param.minPrice)}"/>
            </div>
            <div class="controls__input">
              <i class="fas fa-dollar-sign"></i>
              <input name="maxPrice" type="number" min="0" placeholder="Max $" value="${fn:escapeXml(param.maxPrice)}"/>
            </div>
            <label class="controls__filter">
              <i class="fas fa-sort icon"></i>
              <select name="sortBy">
                <option value="">Sort By</option>
                <option value="priceAsc"  <c:if test="${param.sortBy=='priceAsc'}">selected</c:if>>Price ↑</option>
                <option value="priceDesc" <c:if test="${param.sortBy=='priceDesc'}">selected</c:if>>Price ↓</option>
                <option value="dateDesc"  <c:if test="${param.sortBy=='dateDesc'}">selected</c:if>>Newest</option>
              </select>
              <i class="fas fa-chevron-down chevron"></i>
            </label>
            <button type="submit" class="controls__apply-btn">Apply</button>
          </form>

          <div class="grid">
          <c:forEach var="m" items="${pagedModelsList}">
			  <div class="product-card">
			    <img src="${pageContext.request.contextPath}/uploads/${fn:escapeXml(m.imagePath)}"
					  alt="${fn:escapeXml(m.name)}"/>
			    
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
			<c:if test="${empty pagedModelsList}">
			  <div
			    class="no-data"
			    style="display: flex; justify-content: center; align-items: center; width: 100%; padding: 2rem 0; color: #666;">
			    No models found.
			  </div>
			</c:if>
			
          
          </div>

            <!-- pagination -->
            <div class="pagination">
			  <c:forEach var="i" begin="1" end="${totalPages}">
			    <a href="?page=${i}
			      <c:if test='${not empty param.search}'>&amp;search=${fn:escapeXml(param.search)}</c:if>
			      <c:if test='${not empty param.modelType}'>&amp;modelType=${fn:escapeXml(param.modelType)}</c:if>
			      <c:if test='${not empty param.sortBy}'>&amp;sortBy=${fn:escapeXml(param.sortBy)}</c:if>">
			      <button type="button"
			              class="${i == currentPage ? 'active' : ''}">
			        ${i}
			      </button>
			    </a>
			  </c:forEach>
			</div>
            

      <footer class="page-footer">
        <jsp:include page="/WEB-INF/pages/component/CopyRight.jsp"/>
      </footer>
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
</script>
  
</body>
</html>
