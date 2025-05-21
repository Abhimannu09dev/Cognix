<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn"  uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8"/>
  <title>User Management – Cognix Admin</title>
  <!-- Font Awesome -->
  <link
    rel="stylesheet"
    href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css"
    crossorigin="anonymous"
    referrerpolicy="no-referrer"
  />
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
	
	/* ── Reset & Base ── */
	* {
	  box-sizing: border-box;
	  margin: 0;
	  padding: 0;
	}
	body {
	  font-family: var(--font);
	  background: var(--bg-offwhite);
	  color: var(--text);
	}
	a {
	  text-decoration: none;
	  color: inherit;
	}
	
	/* ── Dashboard Layout ── */
	.dashboard {
	  display: flex;
	  max-width: 1440px;
	  margin: 0 auto;
	  height: 100vh;
	  overflow: hidden;
	  padding-left: 0.1rem;
	}
	.dashboard__nav {
	  width: 240px;
	  position: sticky;
	  top: 0;
	  height: 100vh;
	  overflow-y: auto;
	}
	.dashboard__main {
	  flex: 1;
	  display: flex;
	  flex-direction: column;
	  overflow-y: auto;
	  scrollbar-width: none;
	}
	.dashboard__main::-webkit-scrollbar {
	  display: none;
	}
	
	/* ── Header ── */
	.dashboard__header {
	  padding: 2rem;
	  height: 100px;
	}
	.dashboard__header h1 {
	  font-size: 2rem;
	  color: var(--accent);
	}
	
	/* ── Content Wrapper ── */
	.dashboard__content {
	  padding: 1.5rem 2rem;
	}
	
	/* ── Users Card ── */
	.users-card {
	  background: var(--bg-white);
	  border-radius: var(--radius-lg);
	  padding: 1.5rem;
	  box-shadow: var(--shadow-md);
	  margin-bottom: 2rem;
	}
	.users-card__title {
	  font-size: 1.25rem;
	  font-weight: 600;
	  margin-bottom: 1rem;
	}
	
	/* ── Controls ── */
	.controls {
	  display: flex;
	  flex-wrap: wrap;
	  gap: 1rem;
	  align-items: center;
	  margin-bottom: 1rem;
	}
	.controls__search {
	  flex: 1 1 200px;
	  display: flex;
	  align-items: center;
	  border-bottom: 1px solid #ccc;
	  padding-bottom: .25rem;
	  color: var(--muted);
	}
	.controls__search i {
	  margin-right: .75rem;
	}
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
	  background: #fafafa;
	  border: 1px solid #ddd;
	  border-radius: 9999px;
	  padding: .4rem 1rem;
	  cursor: pointer;
	  transition: background .2s;
	}
	.controls__filter:hover {
	  background: #f0f0f0;
	}
	.controls__filter select {
	  appearance: none;
	  border: none;
	  background: transparent;
	  font-size: .95rem;
	  color: #444;
	  padding-right: 1.5rem;
	}
	.controls__filter::after {
	  content: "\f078";
	  font-family: "Font Awesome 6 Free";
	  font-weight: 900;
	  position: absolute;
	  right: .75rem;
	  pointer-events: none;
	  color: var(--muted);
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
	
	.controls__apply-btn {
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
	.controls__apply-btn:hover {
	  background: #333;
	}
	
	    body.modal-open .controls__filter {
      opacity: 0.6;
      pointer-events: none;
    }
	
	
	
	/* ── Table Section ── */
	.table-section {
	  background: var(--bg-white);
	  border-radius: var(--radius-sm);
	  padding: 1rem;
	  box-shadow: var(--shadow-sm);
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
	.data-table th:first-child {
	  width: 60px;
	}
	.data-table tbody tr:hover td {
	  background: #f9f9f9;
	}
	.no-data {
	  text-align: center;
	  color: #777;
	  padding: 2rem 0;
	}
	
	/* ── Dashboard‐style Block/Unblock Buttons ── */
	.btn--block,
	.btn--unblock {
	  display: inline-block;
	  background: var(--accent);
	  color: var(--bg-white);
	  border: none;
	  border-radius: var(--radius-sm);
	  padding: 0.5rem 1.25rem;
	  font-size: 0.95rem;
	  cursor: pointer;
	  transition: background 0.2s;
	}
	
	/* red variant for “Block” */
	.btn--block {
	  background: #e74c3c;
	}
	.btn--block:hover {
	  background: #c0392b;
	}
	
	/* green variant for “Unblock” */
	.btn--unblock {
	  background: #27ae60;
	}
	.btn--unblock:hover {
	  background: #1e8449;
	}
	
	
	/* ── Widen the Email Column ── */
	.table-section .data-table th:nth-child(6),
	.table-section .data-table td:nth-child(6) {
	  width: 250px;
	  min-width: 200px;
	}
	
	body.modal-open .controls__filter {
	  visibility: hidden !important;
	  pointer-events: none !important;
	}
	
	/* ── Responsive ── */
	@media (max-width: 768px) {
	  .dashboard {
	    flex-direction: column;
	  }
	  .dashboard__nav {
	    width: 100%;
	  }
	  .dashboard__content {
	    padding: 1rem;
	  }
	  .controls {
	    flex-direction: column;
	  }
	  .controls__apply-btn {
	    width: 100%;
	    margin-left: 0;
	  }
	}
  
  </style>
</head>
<body>
  <div class="dashboard">
    <!-- Sidebar -->
    <aside class="dashboard__nav">
      <jsp:include page="../component/AdminNav.jsp"/>
    </aside>
    <!-- Main area -->
    <div class="dashboard__main">
      <header class="dashboard__header">
        <h1>User Management</h1>
      </header>
      <div class="dashboard__content">
        <section class="users-card">
          <h2 class="users-card__title">Users</h2>
          <form method="get" action="${pageContext.request.contextPath}/Users" class="controls">
            <div class="controls__search">
              <i class="fas fa-search"></i>
              <input type="text" name="q" placeholder="Search users…"
                     value="${fn:escapeXml(param.q)}"/>
            </div>
            <div class="controls__filter">
              <select name="role">
                <option value="">All Roles</option>
                <option value="seller" <c:if test="${param.role=='seller'}">selected</c:if>>Seller</option>
                <option value="buyer"  <c:if test="${param.role=='buyer'}">selected</c:if>>Buyer</option>
              </select>
            </div>
            <div class="controls__filter">
              <select name="status">
                <option value="">All Status</option>
                <option value="blocked"   ${param.status=='blocked'  ? 'selected':''}>Blocked</option>
                <option value="unblocked" ${param.status=='unblocked'? 'selected':''}>Unblocked</option>
              </select>
            </div>
            <div class="controls__filter">
              <select name="sort">
                <option value="">Sort by Joined</option>
                <option value="newest" <c:if test="${param.sort=='newest'}">selected</c:if>>Newest</option>
                <option value="oldest" <c:if test="${param.sort=='oldest'}">selected</c:if>>Oldest</option>
              </select>
            </div>
            <button type="submit" class="controls__apply-btn">Apply</button>
          </form>
          <div class="table-section">
            <table class="data-table">
              <thead>
                <tr>
                  <th>SN</th><th>Username</th><th>Full Name</th>
                  <th>Joined On</th><th>Role</th><th>Email</th><th>Action</th>
                </tr>
              </thead>
              <tbody>
                <c:forEach var="user" items="${usersList}" varStatus="st">
                  <tr>
                    <td>${st.index + 1}</td>
                    <td>${fn:escapeXml(user.username)}</td>
                    <td>${fn:escapeXml(user.name)}</td>
                    <td><fmt:formatDate value="${user.createdAt}" pattern="yyyy-MM-dd"/></td>
                    <td>${fn:escapeXml(user.role)}</td>
                    <td>${fn:escapeXml(user.email)}</td>
                    <td>
                      <form action="${pageContext.request.contextPath}/UserStatus"
                            method="post" style="display:inline;">
                        <input type="hidden" name="id" value="${user.id}"/>
                        <c:choose>
                          <c:when test="${user.status != 'blocked'}">
                            <input type="hidden" name="action" value="block"/>
                            <button class="btn--block">Block</button>
                          </c:when>
                          <c:otherwise>
                            <input type="hidden" name="action" value="unblock"/>
                            <button class="btn--unblock">Unblock</button>
                          </c:otherwise>
                        </c:choose>
                      </form>
                    </td>
                  </tr>
                </c:forEach>
                <c:if test="${empty usersList}">
                  <tr><td colspan="7" class="no-data">No users found.</td></tr>
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
