<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8"/>
  <title><c:out value="${model.name}"/> – Cognix</title>
  <!-- Font Awesome -->
  <link rel="stylesheet"
        href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css"
        crossorigin="anonymous" referrerpolicy="no-referrer"/>
  <style>
  :root {
  --bg-offwhite: #F1EDE9;
  --bg-white:    #fff;
  --radius-lg:   24px;
  --radius-sm:   8px;
  --shadow-md:   0 2px 8px rgba(0,0,0,0.05);
  --shadow-sm:   0 1px 4px rgba(0,0,0,0.05);
  --font:        'Helvetica Neue', sans-serif;
  --text:        #333;
  --muted:       #666;
}
* {
  box-sizing: border-box;
  margin: 0;
  padding: 0;
}
html, body {
  height: 100%;
}
body {
  font-family: var(--font);
  background: var(--bg-offwhite);
  color: var(--text);
  /* allow scrolling when content overflows */
  overflow-x: hidden;
  overflow-y: auto;
}

/* layout */
.dashboard {
  display: flex;
  max-width: 1440px;
  margin: 0 auto;
}
.dashboard__nav {
  width: 240px;
  position: sticky;
  top: 0;
  height: 100vh;
  padding: 1rem 0;
}
.dashboard__main {
  flex: 1;
  display: flex;
  flex-direction: column;
  /* let main area scroll internally */
  overflow-y: auto;
}
.dashboard__main::-webkit-scrollbar {
  width: 0; /* hide scrollbar */
}
.dashboard__topbar {
  padding: 1rem 2rem;
}
.dashboard__content {
  padding: 2rem;
  display: flex;
  flex-direction: column;
  gap: 1rem;
}

/* title */
.page-title {
  font-size: 1.75rem;
  font-weight: 600;
}

/* banner image */
.banner {
  border-radius: var(--radius-sm);
  overflow: hidden;
  margin-bottom: 1rem;
  box-shadow: var(--shadow-md);
}
.banner img {
  display: block;
  width: 100%;
  max-height: 300px;
  object-fit: cover;
}

/* header & actions */
.model-header {
  display: flex;
  flex-wrap: wrap;
  justify-content: space-between;
  align-items: center;
  gap: 1rem;
  margin-bottom: 1rem;
}
.model-header .info {
  flex: 1 1 60%;
}
.model-header h1 {
  font-size: 2rem;
  margin-bottom: .25rem;
}
.model-header .meta {
  color: var(--muted);
  font-size: .9rem;
}
.model-header .actions {
  display: flex;
  gap: .75rem;
  flex-wrap: wrap;
}
.model-header .actions button {
  padding: .6rem 1.2rem;
  border-radius: var(--radius-sm);
  border: 1px solid #333;
  background: var(--bg-white);
  cursor: pointer;
  font-size: 1rem;
  transition: background .2s, color .2s;
}
.model-header .actions .buy {
  background: #111;
  color: #fff;
  border: none;
}
.model-header .actions button:hover {
  background: #000;
  color: #fff;
}

/* card sections */
.card-section {
  background: var(--bg-white);
  border-radius: var(--radius-lg);
  padding: 2rem;
  box-shadow: var(--shadow-md);
}
.card-section h2 {
  font-size: 1.5rem;
  margin-bottom: 1rem;
  border-bottom: 1px solid #e0e0e0;
  padding-bottom: .5rem;
}

/* stats grid */
.stats-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(200px,1fr));
  gap: 1rem;
}
.stat-card {
  padding: 1rem;
  border: 1px solid #e0e0e0;
  border-radius: var(--radius-sm);
  text-align: center;
  background: var(--bg-white);
}
.stat-card .label {
  font-size: .9rem;
  color: var(--muted);
  margin-bottom: .5rem;
}
.stat-card .value {
  font-size: 1.5rem;
  font-weight: 600;
}

/* responsive tweaks */
@media (max-width: 800px) {
  .dashboard {
    flex-direction: column;
  }
  .dashboard__nav {
    width: 100%;
    height: auto;
    position: relative;
  }
  .dashboard__content {
    padding: 1rem;
  }
  .model-header {
    flex-direction: column;
    align-items: flex-start;
  }
  .model-header .actions {
    margin-top: 1rem;
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

        <!-- Title -->
        <div class="page-title">
          <c:out value="${model.name}"/>
        </div>
        
        
        <!-- Banner (if any) -->
		<c:if test="${not empty model.imagePath}">
		  <div class="banner">
		    <img 
		      src="${pageContext.request.contextPath}/uploads/${model.imagePath}" 
		      alt="Model banner" 
		    />
		  </div>
		</c:if>
        

        <!-- Title + Meta + Actions -->
        <div class="model-header">
          <div class="info">
            <h1><c:out value="${model.name}"/></h1>
            <div class="meta">
              by <c:out value="${model.sellerUsername}"/>
              &bull; <fmt:formatDate value="${model.listedDate}" pattern="yyyy-MM-dd"/>
              &bull; Category: <c:out value="${model.category}"/>
            </div>
          </div>
          <div class="actions">
            <button onclick="location.href='${pageContext.request.contextPath}/Docs/${model.modelId}'">
              <i class="fas fa-book-open"></i> Docs
            </button>
                        <!-- fixed Add to Cart form: -->
            <form action="${pageContext.request.contextPath}/addToCart"
                  method="post"
                  style="display:inline">
              <input type="hidden" name="modelId" value="${model.modelId}" />
              <button type="submit" class="buy">
                <i class="fas fa-shopping-cart"></i> Add to Cart
              </button>
            </form>
                        
          </div>
        </div>

        <!-- Description -->
        <section class="card-section description">
          <h2>Description</h2>
          <p><c:out value="${model.description}"/></p>
        </section>

        <!-- Model Stats -->
        <section class="card-section">
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
              <div class="label">F1 Score</div>
              <div class="value"><c:out value="${model.f1Score}"/></div>
            </div>
            <div class="stat-card">
              <div class="label">Parameters</div>
              <div class="value"><c:out value="${model.parameters}"/></div>
            </div>
            <div class="stat-card">
              <div class="label">Inference Time</div>
              <div class="value"><c:out value="${model.inferenceTime}"/> ms</div>
            </div>
          </div>
        </section>

      </div>
      <footer class="dashboard__footer">
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
    ? '✅ Successfully added to cart!'
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
    const u = new URL(window.location);
    u.searchParams.delete('added');
    window.history.replaceState({}, '', u);
  }, 3000);
});
</script>
  
</body>
</html>
