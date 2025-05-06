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
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/AdminMessages.css"/>
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
