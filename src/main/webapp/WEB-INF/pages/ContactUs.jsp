<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Contact Us – COGNIX</title>
  <link rel="stylesheet"
        href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css"
        crossorigin="anonymous"
        referrerpolicy="no-referrer" />
  <style>
    /* === Reset & Base === */
    * { box-sizing: border-box; margin:0; padding:0; line-height:1.6; }
    html, body { height: 100%; }
    body {
      font-family: 'Helvetica Neue', sans-serif;
      background: #F1EDE9;
      color: #222;
      overflow-x: hidden;
    }

    /* === Layout Container === */
    .layout {
      display: flex;
      max-width: 1440px;
      margin: 0 auto;
      height: 100vh;
      overflow: hidden;
    }

    /* === Sidebar === */
    .sidebarinner {
      height: 100vh;
      overflow-y: auto;
      overflow-x: hidden;
    }
    .sidebarinner::-webkit-scrollbar { width:0; background:transparent; }

    /* === Main Content === */
    .main-content {
      flex: 1;
      display: flex;
      flex-direction: column;
      overflow-y: auto;
      scrollbar-width: none;
      -ms-overflow-style: none;
      padding: 1rem;
      background: #F1EDE9;
    }
    .main-content::-webkit-scrollbar { display: none; }

    /* === Inner Container === */
    .container {
      max-width: 1000px;
      margin: 0 auto;
      width: 100%;
    }

    /* === Page Title === */
    h1 {
      font-size: 2rem;
      margin-bottom: .5rem;
    }

    /* === Form === */
    form {
      display: grid;
      grid-template-columns: repeat(3, 1fr);
      gap: 15px;
      margin-top: 20px;
    }
    form input,
    form textarea {
      width: 100%;
      padding: 10px;
      border: none;
      border-bottom: 1px solid #ccc;
      background: transparent;
      font-size: 14px;
    }
    form textarea {
      grid-column: span 3;
      height: 100px;
    }
    .submit-btn {
      grid-column: span 3;
      margin-top: 20px;
      background: #111;
      color: #fff;
      padding: .75rem 1.5rem;
      border: none;
      border-radius: 4px;
      cursor: pointer;
      transition: background .2s;
      justify-self: start;
    }
    .submit-btn:hover { background: #333; }

    /* === Modal Overlay === */
    .modal-overlay {
      position: fixed;
      inset: 0;
      background: rgba(0,0,0,0.5);
      display: none;
      align-items: center;
      justify-content: center;
      z-index: 1000;
    }
    .modal-overlay.show { display: flex; }
    .modal-box {
      background: #fff;
      padding: 2rem;
      border-radius: 8px;
      width: 90%;
      max-width: 400px;
      text-align: center;
      box-shadow: 0 4px 12px rgba(0,0,0,0.2);
    }
    .modal-box p {
      margin-bottom: 1.5rem;
      font-size: 1rem;
      color: #222;
    }
    .modal-box button {
      padding: .5rem 1rem;
      border: none;
      border-radius: 4px;
      background: #2ECC71;
      color: #fff;
      cursor: pointer;
      transition: background .2s;
    }
    .modal-box button:hover { background: #27ae60; }
  </style>
</head>
<body>
  <div class="layout">
    <!-- Sidebar -->
    <c:if test="${not empty sessionScope.user and sessionScope.user.status != 'blocked'}">
      <aside class="sidebarinner">
        <c:choose>
          <c:when test="${sessionScope.role == 'seller'}">
            <jsp:include page="/WEB-INF/pages/component/SellerNav.jsp"/>
          </c:when>
          <c:otherwise>
            <jsp:include page="/WEB-INF/pages/component/BuyerNav.jsp"/>
          </c:otherwise>
        </c:choose>
      </aside>
    </c:if>

    <!-- Main Content -->
    <div class="main-content">
      <div class="container">
        <h1>Get in touch with us.<br/>We’re here to assist you.</h1>

        <form action="${pageContext.request.contextPath}/ContactUs" method="post">
          <input type="hidden" name="userId" value="${sessionScope.user.id}" />
          <input type="text"    name="name"    placeholder="Your Name"     required />
          <input type="email"   name="email"   placeholder="Email Address" required />
          <input type="text"    name="subject" placeholder="Subject"       required />
          <textarea name="body" placeholder="Message" required></textarea>
          <button type="submit" class="submit-btn">Leave us a Message →</button>
        </form>
      </div>
    </div>
  </div>

  <!-- Success Modal -->
  <div id="successModal" class="modal-overlay">
    <div class="modal-box">
      <p>${fn:escapeXml(success)}</p>
      <button id="modalOk">OK</button>
    </div>
  </div>

  <script>
    document.addEventListener('DOMContentLoaded', () => {
      // only show if success attribute present
      const successMsg = "${fn:escapeXml(success)}";
      if (successMsg) {
        const modal = document.getElementById('successModal');
        const ok    = document.getElementById('modalOk');
        modal.classList.add('show');
        ok.addEventListener('click', () => modal.classList.remove('show'));
      }
    });
  </script>
</body>
</html>
