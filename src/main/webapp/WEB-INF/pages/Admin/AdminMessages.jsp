<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn"  uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8"/>
  <title>Contact Messages – Cognix Admin</title>

  <!-- Font Awesome -->
  <link
    rel="stylesheet"
    href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css"
    crossorigin="anonymous" referrerpolicy="no-referrer"
  />
  <!-- Your existing CSS -->
  <style>
  	/* === Reset & Base === */
* { box-sizing: border-box; margin:0; padding:0 }
body {
  font-family:'Helvetica Neue', sans-serif;
  color:#222;
}

/* === Dashboard Layout === */
.dashboard {
  display: flex;
  max-width: 1440px;
  margin: 0 auto;
  height: 100vh;
  overflow: hidden;
}
.dashboard__nav {
  width: 240px;
}
.dashboard__main {
  flex:1;
  display:flex; flex-direction:column;
  overflow-y:auto;
  scrollbar-width:none;
  -ms-overflow-style:none;
}
.dashboard__main::-webkit-scrollbar { width:0; height:0; }

/* === Header === */
.dashboard__header {
  padding:2rem;
  height: 100px;
}
.dashboard__header h1 {
  font-size: 1.875rem;
  margin-bottom: 1.5rem;
}

/* === Stats Overview === */
.stats-overview {
  background: #fff;
  border-radius: 16px;
  padding: 1.5rem 2rem;
  margin: 1rem 2rem;
  display: flex;
  flex-direction: column;
  gap: 1rem;
  max-width: calc(100% - 4rem);
}
.stats-overview .stats-title {
  font-size: 1.25rem;
  font-weight: 600;
  color: #222;
  margin: 0;
}
.stats-overview .stats-cards {
  display: flex;
  gap: 1rem;
}
.stat-card {
  flex: 1;
  background: #fff;
  border: 1px solid #ddd;
  border-radius: 8px;
  padding: 1rem 1.5rem;
  display: flex;
  flex-direction: column;
  justify-content: center;
}
.stat-card .stat-title {
  font-size: .875rem;
  color: #666;
  text-transform: uppercase;
  margin: 0 0 .5rem;
}
.stat-card .stat-value {
  font-size: 1.5rem;
  font-weight: 600;
  color: #111;
  margin: 0;
}

/* === Messages Section === */
.messages-section {
  background:#fff;
  border-radius:12px;
  padding:2rem 2rem;
  margin:1rem 2rem;
  box-shadow:0 2px 8px rgba(0,0,0,0.05);
  display:flex; flex-direction:column;
  gap:1rem;
}
.messages-section h2 {
  font-size:1.25rem; color:#222;
  margin-bottom:1rem;
}

/* === Controls: search + sort === */
.controls {
  display:flex; flex-wrap:wrap;
  align-items:center; gap:1rem;
  padding:0 0 1rem;
}
.controls__search {
  flex:1 1 200px;
  display:flex; align-items:center;
  border-bottom:1px solid #ccc; color:#666;
}
.controls__search i { margin-right:.75rem; }
.controls__search input {
  flex:1; border:none; background:transparent;
  font-size:1rem; color:#333;
}
.controls__search input::placeholder { color:#aaa; }
.controls__search input:focus { outline:none; }

/* sort pill */
.filter-dropdown {
	width:200px;
  position:relative; display:inline-flex;
  align-items:center; background:#fafafa;
  border:1px solid #ddd; border-radius:9999px;
  padding:.4rem 1rem; cursor:pointer;
  transition:background .2s;
}
.filter-dropdown select {
  width:100%;
  appearance:none;
  border:none; background:transparent;
  font-size:.95rem; color:#444; cursor:pointer;
}
.filter-dropdown:hover { background:#f0f0f0; }
.filter-dropdown select:focus {
  outline:none; color:#111;
}
.filter-dropdown i.fa-chevron-down {
  position:absolute;
  right:1rem;
  top:50%;
  transform:translateY(-50%);
  pointer-events:none;
  color:#666;
}


/* apply button */
.apply-btn {
  background:#111; color:#fff; border:none;
  border-radius:8px; padding:.5rem 1rem;
  cursor:pointer; transition:background .2s;
}
.apply-btn:hover { background:#333; }

/* === Table Card === */
.table-section {
  background: var(--bg-white);
  border-radius: var(--radius-lg);
  box-shadow: var(--shadow-md);
  overflow-x: auto;
}
.table-section .data-table {
  width: 100%;
  border-collapse: collapse;
  table-layout: auto;
}
.data-table th,
.data-table td {
  padding: .75rem 1rem;
  text-align: left;
  border-bottom: 1px solid #f0f0f0;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
}
.data-table th {
  background: #fafafa;
  color: var(--muted);
  font-size: .85rem;
}
.data-table th:first-child {
  width: 70px;
}
.no-data {
  text-align: center;
  color: #777;
  padding: 2rem 0;
}

/* ── Widen Email (3rd) & Actions (7th) ── */
.table-section .data-table th:nth-child(3),
.table-section .data-table td:nth-child(3) {
  min-width: 250px;
}
.table-section .data-table th:nth-child(7),
.table-section .data-table td:nth-child(7) {
  min-width: 150px;
}






/* === Actions & Buttons === */
.actions-cell {
  display:flex; align-items:center; gap:.5rem;
}
.btn--view-detail,
.btn--mark {
  background:#111; color:#fff; border:none;
  border-radius:6px; padding:.4rem .8rem;
  font-size:.85rem; cursor:pointer;
  transition:background .2s;
}
.btn--view-detail:hover,
.btn--mark:hover { background:#333; }
.label--checked { color:#2ECC71; font-weight:bold; }

/* === Modal Overlay & Content === */
.modal {
  position:fixed; top:0;left:0;right:0;bottom:0;
  background:rgba(0,0,0,0.5);
  display:none; align-items:center; justify-content:center;
  z-index:1000;
}
.modal.show { display:flex; }
.modal-content {
  background:#fff; border-radius:12px;
  padding:1.5rem; max-width:600px; width:90%;
  box-shadow:0 2px 12px rgba(0,0,0,0.2);
  position:relative;
}
.modal-close {
  position:absolute; top:.5rem; right:.5rem;
  background:transparent; border:none;
  font-size:1.5rem; cursor:pointer; color:#666;
}
.modal-close:hover { color:#000; }
.modal-content h2 {
  margin-top:0; font-size:1.25rem; color:#222;
}
.modal-content p {
  margin:.5rem 0; line-height:1.4;
}

/*–– when the Account modal is open, hide only the filter pills ––*/
body.modal-open .controls__filter {
  visibility: hidden !important;
  pointer-events: none !important;
}
  	
  </style>
</head>
<body>
  <div class="dashboard">
    <!-- fixed sidebar -->
    <aside class="dashboard__nav">
      <jsp:include page="../component/AdminNav.jsp"/>
    </aside>

    <!-- scrollable main area -->
    <div class="dashboard__main">
      <header class="dashboard__header">
        <h1>Contact Messages</h1>
      </header>

      <div class="dashboard__content">
        <!-- Stats overview -->
        <section class="stats-overview">
          <h2 class="stats-title">Messages Overview</h2>
          <div class="stats-cards">
            <div class="stat-card">
              <p class="stat-title">Total Messages</p>
              <p class="stat-value">${totalMessages}</p>
            </div>
            <div class="stat-card">
              <p class="stat-title">Read</p>
              <p class="stat-value">${readMessages}</p>
            </div>
            <div class="stat-card">
              <p class="stat-title">Unread</p>
              <p class="stat-value">${unreadMessages}</p>
            </div>
          </div>
        </section>

        <!-- Messages list + controls -->
        <section class="messages-section">
          <h2 class="messages-title">Messages</h2>

          <!-- Search + Sort form -->
          <form method="get"
                action="${pageContext.request.contextPath}/AdminMessages"
                class="controls">
            <div class="controls__search">
              <i class="fas fa-search"></i>
              <input type="text"
                     name="q"
                     placeholder="Search by name or email…"
                     value="${fn:escapeXml(param.q)}"/>
            </div>

            <div class="filter-dropdown">
              <select name="sort">
                <option value="newest"
                  ${param.sort=='newest'?'selected':''}>Newest</option>
                <option value="oldest"
                  ${param.sort=='oldest'?'selected':''}>Oldest</option>
              </select>
              <i class="fas fa-chevron-down"></i>
            </div>

            <button type="submit" class="apply-btn">Apply</button>
          </form>

          <!-- Table -->
          <section class="table-section">
            <table class="data-table">
              <thead>
                <tr>
                  <th>SN</th><th>Name</th><th>Email</th>
                  <th>Subject</th><th>Received On</th>
                  <th>Status</th><th>Actions</th>
                </tr>
              </thead>
              <tbody>
                <c:forEach var="m" items="${messagesList}" varStatus="st">
                  <tr data-subject="${fn:escapeXml(m.subject)}"
                      data-body   ="${fn:escapeXml(m.body)}">
                    <td>${st.index + 1}</td>
                    <td>${fn:escapeXml(m.name)}</td>
                    <td>${fn:escapeXml(m.email)}</td>
                    <td>${fn:escapeXml(m.subject)}</td>
                    <td>
                      <fmt:formatDate value="${m.createdAt}"
                                      pattern="yyyy-MM-dd HH:mm"/>
                    </td>
                    <td>${m.status}</td>
                    <td class="actions-cell">
                      <!-- VIEW button -->
                      <button type="button"
                              class="btn--view-detail">
                        View
                      </button>
                      <!-- only show “Mark Read” if unread -->
                      <c:if test="${m.status != 'read'}">
                        <form method="post" style="display:inline">
                          <button name="markChecked"
                                  value="${m.id}"
                                  class="btn--mark">
                            Mark Read
                          </button>
                        </form>
                      </c:if>
                      <c:if test="${m.status == 'read'}">
                        <span class="label--checked">✔︎</span>
                      </c:if>
                    </td>
                  </tr>
                </c:forEach>

                <c:if test="${empty messagesList}">
                  <tr>
                    <td colspan="7" class="no-data">
                      No messages found.
                    </td>
                  </tr>
                </c:if>
              </tbody>
            </table>
          </section>
        </section>
      </div>
    </div>
  </div>

  <!-- Detail-view Modal -->
  <div class="modal" id="msgModal">
    <div class="modal-content">
      <button class="modal-close">&times;</button>
      <h2 id="modal-subject">Subject</h2>
      <p><strong>From:</strong>
         <span id="modal-name"></span>
         &lt;<span id="modal-email"></span>&gt;
      </p>
      <hr/>
      <p id="modal-body">Message body…</p>
    </div>
  </div>

  <script>
    document.addEventListener('DOMContentLoaded', () => {
      const modal  = document.getElementById('msgModal');
      const close  = modal.querySelector('.modal-close');
      const subj   = document.getElementById('modal-subject');
      const nameEl = document.getElementById('modal-name');
      const email  = document.getElementById('modal-email');
      const body   = document.getElementById('modal-body');

      document.querySelectorAll('.btn--view-detail').forEach(btn => {
        btn.addEventListener('click', e => {
          const tr      = e.target.closest('tr');
          subj.textContent   = tr.getAttribute('data-subject');
          nameEl.textContent = tr.children[1].textContent;
          email.textContent  = tr.children[2].textContent;
          body.textContent   = tr.getAttribute('data-body');
          modal.classList.add('show');
        });
      });

      close.addEventListener('click', () => modal.classList.remove('show'));
      modal.addEventListener('click', e => {
        if (e.target === modal) modal.classList.remove('show');
      });
    });
  </script>
</body>
</html>
