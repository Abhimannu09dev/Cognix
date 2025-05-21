<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn"  uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8"/>
  <title>Admin Dashboard – Cognix</title>

  <!-- Font Awesome -->
  <link
    rel="stylesheet"
    href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css"
    crossorigin="anonymous"
    referrerpolicy="no-referrer"
  />
    <!-- CSS -->
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

/* === Reset & Base === */
* {
  box-sizing: border-box;
  margin: 0;
  padding: 0;
}
html, body {
  height: 100%;
  background: var(--bg-offwhite);
  color: var(--text);
  font-family: var(--font);
}
a { text-decoration: none; color: inherit; }

/* === Dashboard Layout === */
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
  padding: 0;
  position: sticky;
  top: 0;
  height: 100vh;
}
.dashboard__main {
  flex: 1;
  display: flex;
  flex-direction: column;
  overflow-y: auto;
  scrollbar-width: none;
}
.dashboard__main::-webkit-scrollbar { display: none; }

/* === Header === */
.dashboard__header {
  padding: 2rem;
  height: 100px;
}
.dashboard__header h1 {
  font-size: 2rem;
  line-height: 1.2;
  color: var(--accent);
}

/* === Content Container === */
.dashboard__content {
  padding: 2rem;
  display: flex;
  flex-direction: column;
  gap: 2rem;
}

/* === Section Card === */
.section {
  background: var(--bg-white);
  border-radius: var(--radius-lg);
  padding: 2rem;
  box-shadow: var(--shadow-md);
}
.section__header {
  display: flex;
  align-items: center;
  margin-bottom: 1.5rem;
}
.section__header h2 {
  font-size: 1.5rem;
  font-weight: 600;
}
.section__header hr {
  flex: 1;
  margin-left: 1rem;
  border: none;
  border-bottom: 1px solid #e0e0e0;
}

/* === Controls (filters & search) === */
.controls {
  display: flex;
  flex-wrap: wrap;
  gap: 1rem;
  align-items: center;
  margin-bottom: 1.5rem;
}
.controls__search {
  flex: 1 1 250px;
  display: flex;
  align-items: center;
  background: var(--bg-white);
  border: 1px solid #ddd;
  border-radius: 9999px;
  padding: 0.5rem 1rem;
  box-shadow: var(--shadow-sm);
}
.controls__search i {
  margin-right: 0.75rem;
  color: var(--muted);
}
.controls__search input {
  flex: 1;
  border: none;
  background: transparent;
  font-size: 1rem;
  outline: none;
}

.controls__filter {
  position: relative;
  display: inline-flex;
  align-items: center;
  background: var(--bg-white);
  border: 1px solid #ddd;
  border-radius: 9999px;
  padding: 0.5rem 1rem;
  box-shadow: var(--shadow-sm);
}
.controls__filter select {
  appearance: none;
  border: none;
  background: transparent;
  font-size: 0.95rem;
  color: #444;
  cursor: pointer;
}
.controls__filter i {
  position: absolute;
  right: 1rem;
  pointer-events: none;
  color: var(--muted);
  font-size: 0.8rem;
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



.controls__apply {
  margin-left: auto;
  background: var(--accent);
  color: var(--bg-white);
  border: none;
  border-radius: var(--radius-sm);
  padding: 0.5rem 1.25rem;
  font-size: 0.95rem;
  cursor: pointer;
  transition: background 0.2s;
}
.controls__apply:hover {
  background: #333;
}

/* === Table === */
.table-wrapper {
  overflow-x: auto;
}
.data-table {
  width: 100%;
  border-collapse: collapse;
}
.data-table th,
.data-table td {
  padding: 0.75rem 1rem;
  text-align: left;
  border-bottom: 1px solid #f0f0f0;
  font-size: 0.95rem;
}
.data-table th {
  background: #fafafa;
  color: var(--muted);
  font-size: 0.85rem;
}
.data-table tr:last-child td {
  border-bottom: none;
}
.data-table td.no-data {
  text-align: center;
  color: #777;
  padding: 2rem 0;
}

/* === Buttons (block/unblock, view) === */
.btn--block,
.btn--unblock,
.view-btn {
  display: inline-block;
  font-size: 0.95rem;
  padding: 0.4rem 0.8rem;
  border-radius: var(--radius-sm);
  border: 1px solid transparent;
  cursor: pointer;
  transition: background 0.2s, border-color 0.2s;
}
.btn--block {
  background: #e74c3c;
  color: #fff;
}
.btn--block:hover {
  background: #c0392b;
}
.btn--unblock {
  background: #27ae60;
  color: #fff;
}
.btn--unblock:hover {
  background: #1e8449;
}
.view-btn {
  background: var(--accent);
  color: var(--bg-white);
}
.view-btn:hover {
  background: #333;
}
/*–– when the Account modal is open, hide only the filter pills ––*/
body.modal-open .controls__filter {
  visibility: hidden !important;
  pointer-events: none !important;
}



/* === Responsive === */
@media (max-width: 768px) {
  .dashboard { flex-direction: column; }
  .dashboard__nav { width: 100%; position: relative; height: auto; }
  .dashboard__header { text-align: center; }
  .dashboard__content { padding: 1rem; }
  .controls { flex-direction: column; }
  .controls__apply { margin-left: 0; width: 100%; }
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
        <h1>Hey, Good Morning, <br> <c:out value="${sessionScope.user.name}"/></h1>
      </header>
      <div class="dashboard__content">
      
        <!-- New Users Section -->
        <section class="section">
          <div class="section__header">
            <h2>New Users</h2>
            <hr/>
          </div>
          <form method="get" class="controls">
              <div class="controls__search">
                <i class="fas fa-search"></i>
                <input
                    name="userSearch"
                    type="text"
                    placeholder="Search users…"
                    value="${fn:escapeXml(param.userSearch)}"/>
                </div>
			  <!-- … other filters … -->
			  <div class="controls__filter">
			    <select name="statusFilter">
			      <option value="">All Status</option>
			      <option value="blocked"
			        ${statusFilter == 'blocked' ? 'selected' : ''}>
			        Blocked
			      </option>
			      <option value="unblocked"
			        ${statusFilter == 'unblocked' ? 'selected' : ''}>
			        Unblocked
			      </option>
			    </select>
			  </div>
			
			  <div class="controls__filter">
			    <select name="roleFilter">
			      <option value="">Role</option>
			      <option value="seller" 
			        ${roleFilter == 'seller' ? 'selected' : ''}>Seller</option>
			      <option value="buyer"  
			        ${roleFilter == 'buyer'  ? 'selected' : ''}>Buyer</option>
			    </select>
			  </div>
			  <div class="controls__filter">
			    <select name="sortUsers">
			      <option value="">Sort By</option>
			      <option value="date-desc" 
			        ${sortUsers == 'date-desc' ? 'selected' : ''}>
			        Joined: New→Old
			      </option>
			      <option value="date-asc"  
			        ${sortUsers == 'date-asc'  ? 'selected' : ''}>
			        Joined: Old→New
			      </option>
			    </select>
			  </div>
			  <button type="submit" class="controls__apply">Apply</button>
			</form>
          
          <div class="table-wrapper">
            <table class="data-table">
              <thead>
                <tr>
                  <th>SN</th><th>Username</th><th>Full Name</th>
                  <th>Joined On</th><th>Role</th><th>Email</th><th>View</th>
                </tr>
              </thead>
              <tbody>
                <c:forEach var="user" items="${newUsersList}" varStatus="st">
                  <tr>
                    <td>${st.index + 1}</td>
                    <td>${fn:escapeXml(user.username)}</td>
                    <td>${fn:escapeXml(user.name)}</td>
                    <td><fmt:formatDate value="${user.createdAt}" pattern="yyyy-MM-dd"/></td>
                    <td>${fn:escapeXml(user.role)}</td>
                    <td>${fn:escapeXml(user.email)}</td>
                    <td>
	                    <form action="${pageContext.request.contextPath}/UserStatus" method="post" style="display:inline; ">
						  <input type="hidden" name="id" value="${user.id}"/>
						  <c:choose>
						    <c:when test="${user.status != 'blocked'}">
						      <input type="hidden" name="action" value="block"/>
						      <button type="submit" class="btn--block">Block</button>
						    </c:when>
						    <c:otherwise>
						      <input type="hidden" name="action" value="unblock"/>
						      <button type="submit" class="btn--unblock">Unblock</button>
						    </c:otherwise>
						  </c:choose>
						</form>
                    </td>
                  </tr>
                </c:forEach>
                <c:if test="${empty newUsersList}">
                  <tr><td colspan="7" style="text-align:center;color:#777;">
                    No users found.
                  </td></tr>
                </c:if>
              </tbody>
            </table>
          </div>
          
        </section>
        
        
        <!-- Top Models Section -->
        <section class="section">
          <div class="section__header">
            <h2>Top Models</h2>
            <hr/>
          </div>
          <form method="get" class="controls">
            <div class="controls__search">
              <i class="fas fa-search"></i>
              <input
                name="modelSearch"
                type="text"
                placeholder="Search models…"
                value="${fn:escapeXml(param.modelSearch)}"/>
            </div>
            <div class="controls__filter">
	            <select name="categoryFilter">
				  <option value="">Category</option>
				  <c:forEach var="cat" items="${modelCategories}">
				    <option value="${cat}"
				      <c:if test="${param.categoryFilter == cat}">selected</c:if>>
				      ${fn:escapeXml(cat)}
				    </option>
				  </c:forEach>
				</select>
            
            </div>
            <div class="controls__filter">
              <select name="sortModels">
                <option value="">Sort By</option>
                <option value="sales-desc" <c:if test="${param.sortModels=='sales-desc'}">selected</c:if>>Sales: High→Low</option>
                <option value="sales-asc"  <c:if test="${param.sortModels=='sales-asc'}">selected</c:if>>Sales: Low→High</option>
                <option value="date-desc"  <c:if test="${param.sortModels=='date-desc'}">selected</c:if>>Date: New→Old</option>
                <option value="date-asc"   <c:if test="${param.sortModels=='date-asc'}">selected</c:if>>Date: Old→New</option>
              </select>
            </div>
            <button type="submit" class="controls__apply">Apply</button>
          </form>
          <div class="table-wrapper">
            <table class="data-table">
              <thead>
                <tr>
                  <th>SN</th><th>Model Name</th><th>Category</th>
                  <th>Price (USD)</th><th>Seller</th><th>Listed Date</th>
                </tr>
              </thead>
              <tbody>
                <c:forEach var="model" items="${topModelsList}" varStatus="st">
                  <tr>
                    <td>${st.index + 1}</td>
                    <td>${fn:escapeXml(model.name)}</td>
                    <td>${fn:escapeXml(model.category)}</td>
                    <td>$${model.price}</td>
                    <td>@${fn:escapeXml(model.sellerUsername)}</td>
                    <td><fmt:formatDate value="${model.listedDate}" pattern="yyyy-MM-dd"/></td>
                  </tr>
                </c:forEach>
                <c:if test="${empty topModelsList}">
                  <tr>
                    <td colspan="7" style="text-align:center;color:#777;">
                      No models found.
                    </td>
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
