<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn"  uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8"/>
  <title>Reports – Cognix Admin</title>
  <!-- Font Awesome for icons -->
  <link
    rel="stylesheet"
    href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css"
    crossorigin="anonymous"
    referrerpolicy="no-referrer"
  />
  <!-- Chart.js -->
  <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

  <style>
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

    /* === Reset & Base === */
    * { box-sizing: border-box; margin: 0; padding: 0; }
    body {
      font-family: var(--font);
      background: var(--bg-offwhite);
      color: var(--text);
    }
    a { text-decoration: none; color: inherit; }

    /* === Dashboard Container === */
    .dashboard {
	  display: flex;
	  max-width: 1440px;
	  margin: 0 auto;
	  /* fill the viewport and hide the native page scroll */
	  height: 100vh;
	  overflow: hidden;
	}
	
	.dashboard__nav {
	  width: 240px;
	
	  /* stick it to the top and make it scrollable if it's too tall */
	  position: sticky;
	  top: 0;
	  height: 100vh;
	  overflow-y: auto;
	}
	
	.dashboard__main {
	  flex: 1;
	
	  /* only this pane scrolls vertically */
	  overflow-y: auto;
	  scrollbar-width: none;       /* firefox */
	  -ms-overflow-style: none;    /* ie10+ */
	
	  /* if you want to hide the webkit scrollbar */
	}
	.dashboard__main::-webkit-scrollbar {
	  display: none;
	}
    
    .dashboard__header {
      padding: 2rem 3rem 0;
    }
    .dashboard__header h1 {
      font-size: 1.875rem;
      color: var(--accent);
      margin-bottom: .5rem;
    }
    .dashboard__content {
      flex: 1;
      padding: 1.5rem 3rem;
      overflow-y: auto;
      display: flex;
      flex-direction: column;
      gap: 2rem;
    }

    /* === Controls === */
    .controls {
      display: flex;
      flex-wrap: wrap;
      gap: 1rem;
      align-items: center;
      margin-bottom: 1.5rem;
    }
    .controls__filter {
      position: relative;
      background: var(--bg-white);
      border: 1px solid #ddd;
      border-radius: var(--radius-sm);
      transition: background 0.2s;
    }
    .controls__filter:hover { background: #f9f9f9; }
    .controls__filter select,
    .controls__filter input[type="date"] {
      appearance: none;
      border: none;
      background: transparent;
      padding: .5rem 1rem;
      font-size: .95rem;
      color: #444;
      cursor: pointer;
      min-width: 140px;
    }
    .controls__filter:focus-within { box-shadow: 0 0 0 2px rgba(0,0,0,0.05); }
    /* chevron for selects */
    .controls__filter:not(.date-filter)::after {
      content: "\f078";
      font-family: "Font Awesome 6 Free";
      font-weight: 900;
      position: absolute;
      right: .75rem;
      top: 50%;
      transform: translateY(-50%);
      pointer-events: none;
      color: var(--muted);
      font-size: .8rem;
    }
    /* calendar icon for date inputs */
    .controls__filter.date-filter::after {
      content: "\f073";
      font-family: "Font Awesome 6 Free";
      font-weight: 900;
      position: absolute;
      right: .75rem;
      top: 50%;
      transform: translateY(-50%);
      pointer-events: none;
      color: var(--muted);
      font-size: .8rem;
    }
    .controls__apply-btn {
      margin-left: auto;
      background: var(--accent);
      color: var(--bg-white);
      border: none;
      border-radius: var(--radius-sm);
      padding: .5rem 1rem;
      font-size: .95rem;
      cursor: pointer;
      white-space: nowrap;
      transition: background 0.2s;
    }
    .controls__apply-btn:hover { background: #333; }

    /* === Report Sections === */
    .report-section {
      background: var(--bg-white);
      border-radius: var(--radius-lg);
      padding: 1.5rem;
      box-shadow: var(--shadow-md);
    }
    .report-section h2 {
      font-size: 1.25rem;
      margin-bottom: .75rem;
      color: var(--accent);
    }
    .report-section hr {
      border: none;
      border-bottom: 1px solid #e0e0e0;
      margin-bottom: 1.5rem;
    }

    /* === Charts === */
    .chart-container {
      position: relative;
      width: 100%;
      max-width: 800px;
      margin: 0 auto;
    }
    .chart-container canvas {
      width: 100% !important;
      height: auto !important;
    }

    @media (max-width: 768px) {
      .dashboard { flex-direction: column; padding: 1rem; }
      .dashboard__nav { width: 100%; margin-bottom: 1rem; }
      .dashboard__content { padding: 1rem; }
      .controls { flex-direction: column; }
      .controls__apply-btn { width: 100%; margin-left: 0; }
    }
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
        <h1>Reports</h1>
      </header>

      <div class="dashboard__content">
        <!-- User Growth Report -->
        <section class="report-section">
          <h2>User Growth</h2>
          <hr/>
          <form method="get" class="controls">
            <div class="controls__filter date-filter">
              <input type="date" name="userFrom" value="${param.userFrom}"/>
            </div>
            <div class="controls__filter date-filter">
              <input type="date" name="userTo"   value="${param.userTo}"/>
            </div>
            <div class="controls__filter">
              <select name="userRole">
                <option value="">All Roles</option>
                <option value="admin"  <c:if test="${param.userRole=='admin'}">selected</c:if>>Admin</option>
                <option value="seller" <c:if test="${param.userRole=='seller'}">selected</c:if>>Seller</option>
                <option value="buyer"  <c:if test="${param.userRole=='buyer'}">selected</c:if>>Buyer</option>
              </select>
            </div>
            <button type="submit" class="controls__apply-btn">Apply</button>
          </form>
          <div class="chart-container">
            <canvas id="userChart"></canvas>
          </div>
        </section>

        <!-- Model Sales Report -->
        <section class="report-section">
          <h2>Model Sales</h2>
          <hr/>
          <form method="get" class="controls">
            <div class="controls__filter date-filter">
              <input type="date" name="modelFrom" value="${param.modelFrom}"/>
            </div>
            <div class="controls__filter date-filter">
              <input type="date" name="modelTo"   value="${param.modelTo}"/>
            </div>
            <div class="controls__filter">
              <select name="modelSort">
                <option value="">Sort By</option>
                <option value="most-sold"  <c:if test="${param.modelSort=='most-sold'}">selected</c:if>>Most Sold</option>
                <option value="least-sold" <c:if test="${param.modelSort=='least-sold'}">selected</c:if>>Least Sold</option>
                <option value="latest"     <c:if test="${param.modelSort=='latest'}">selected</c:if>>Newest</option>
                <option value="oldest"     <c:if test="${param.modelSort=='oldest'}">selected</c:if>>Oldest</option>
              </select>
            </div>
            <button type="submit" class="controls__apply-btn">Apply</button>
          </form>
          <div class="chart-container">
            <canvas id="modelChart"></canvas>
          </div>
        </section>
      </div>
    </div>
  </div>
  <!-- <h1>hello</h1> -->

  <script>
    // build label/data arrays…
    const userLabels = [<c:forEach var="m" items="${userReport.labels}" varStatus="st">${st.index>0?',' : ''}"${fn:escapeXml(m)}"</c:forEach>] || ['No Data'];
    const userData   = [<c:forEach var="v" items="${userReport.data}"   varStatus="st">${st.index>0?',' : ''}${v}</c:forEach>]   || [0];
    const modelLabels= [<c:forEach var="m" items="${modelReport.labels}" varStatus="st">${st.index>0?',' : ''}"${fn:escapeXml(m)}"</c:forEach>]||['No Data'];
    const modelData  = [<c:forEach var="v" items="${modelReport.data}"   varStatus="st">${st.index>0?',' : ''}${v}</c:forEach>]  || [0];

    new Chart(document.getElementById('userChart').getContext('2d'), {
      type: 'line',
      data: {
        labels: userLabels,
        datasets: [{
          label: 'New Users',
          data: userData,
          borderColor: 'rgba(75,192,192,1)',
          backgroundColor: 'rgba(75,192,192,0.2)',
          fill: true, tension: .3
        }]
      },
      options: { responsive: true, scales: { y: { beginAtZero: true } } }
    });

    new Chart(document.getElementById('modelChart').getContext('2d'), {
      type: 'bar',
      data: {
        labels: modelLabels,
        datasets: [{
          label: 'Units Sold',
          data: modelData,
          backgroundColor: 'rgba(255,159,64,0.6)',
          borderColor:     'rgba(255,159,64,1)',
          borderWidth: 1
        }]
      },
      options: { responsive: true, scales: { y: { beginAtZero: true } } }
    });
  </script>
</body>
</html>
