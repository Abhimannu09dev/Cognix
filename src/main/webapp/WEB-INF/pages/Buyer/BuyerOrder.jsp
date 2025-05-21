<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core"%>
<%
   String ctx = request.getContextPath();
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8"/>
  <title>My Cart – Cognix</title>
  <!-- Font Awesome & your CSS… -->
    <link
    rel="stylesheet"
    href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css"
    crossorigin="anonymous"
    referrerpolicy="no-referrer"
  />  
<style>
    :root {
      --bg-offwhite: #F9F8F4;
      --bg-white:    #fff;
      --radius-lg:   24px;
      --radius-sm:   8px;
      --shadow-md:   0 2px 8px rgba(0,0,0,0.05);
      --shadow-sm:   0 1px 4px rgba(0,0,0,0.05);
      --font:        'Helvetica Neue', sans-serif;
      --text:        #222;
      --muted:       #666;
    }

    /* === Reset & Base === */
    * { box-sizing: border-box; margin:0; padding:0; }
    html, body { height:100%; }
    body {
      font-family: var(--font);
      background: var(--bg-offwhite);
      color: var(--text);
    }

    /* === Layout === */
    .dashboard {
      display: flex;
      max-width: 1440px;
      margin: 0 auto;
      height: 100vh;
      overflow: hidden;
    }
    .dashboard__nav {
      width: 240px;
      padding: 1rem 0;

      position: sticky;
      top: 0;
      height: 100vh;
    }
    .dashboard__main {
      flex: 1;
      display: flex;
      flex-direction: column;
      overflow-y: auto;
      scrollbar-width: none;       /* Firefox */
      -ms-overflow-style: none;    /* IE 10+ */
    }
    .dashboard__main::-webkit-scrollbar {
      display: none;               /* Safari/WebKit */
    }
    .dashboard__topbar {
      padding: 1rem 2rem;
    }
    .dashboard__content {
      padding: 2rem;
      display: flex;
      flex-direction: column;
      gap: 2rem;
    }

    /* === Page Title === */
    .page-title {
      font-size: 1.75rem;
      font-weight: 600;
    }

    /* === Cards (stats & cart) === */
    .stats-overview,
    .cart-section {
      background: var(--bg-white);
      border-radius: var(--radius-lg);
      padding: 2rem;
      box-shadow: var(--shadow-md);
      display: flex;
      flex-direction: column;
      gap: 1.5rem;
    }
    .stats-overview__header h2,
    .cart-section__header h2 {
      font-size: 1.5rem;
      margin-bottom: 1rem;
    }

    /* --- Stats Cards --- */
    .stats-cards {
      display: grid;
      grid-template-columns: repeat(auto-fit, minmax(240px, 1fr));
      gap: 1.5rem;
    }
    .stats-card {
      background: var(--bg-white);
      border: 1px solid #ddd;
      border-radius: var(--radius-sm);
      padding: 1.25rem;
      box-shadow: var(--shadow-sm);
    }
    .stats-card__label {
      font-size: 0.85rem;
      color: var(--muted);
    }
    .stats-card__value {
      font-size: 1.25rem;
      font-weight: 600;
      margin-top: 0.5rem;
    }

    /* --- Cart Table --- */
    .cart-table-wrapper {
      overflow-x: auto;
    }
    .cart-table {
      width: 100%;
      border-collapse: collapse;
    }
    .cart-table th,
    .cart-table td {
      padding: 0.75rem 1rem;
      text-align: left;
      border-bottom: 1px solid #f0f0f0;
      font-size: 0.95rem;
    }
    .cart-table th {
      background: #fafafa;
      color: var(--muted);
      font-size: 0.85rem;
    }
    .cart-table tr:last-child td {
      border-bottom: none;
    }
    .no-data {
      text-align: center;
      color: var(--muted);
      padding: 2rem 0;
    }

    /* === Buttons === */
    .button {
      border: none;
      border-radius: var(--radius-sm);
      cursor: pointer;
      transition: background 0.2s;
    }
    .button--remove {
      background: #111;
      color: #fff;
      padding: 0.5rem 1rem;
      font-size: 0.95rem;
    }
    .button--remove:hover { background: #333; }
    .button--checkout {
      background: #111;
      color: #fff;
      padding: 0.75rem 1.5rem;
      font-size: 1rem;
    }
    .button--checkout:hover { background: #333; }

    /* === Cart Controls === */
    .cart-controls {
      display: flex;
      justify-content: space-between;
      align-items: center;
    }
    .terms {
      display: flex;
      align-items: center;
      font-size: 0.95rem;
      color: #444;
    }
    .terms input { margin-right: 0.5rem; }

    /* === Modals === */
    .modal-overlay {
      position: fixed; inset:0;
      background: rgba(0,0,0,0.5);
      display: none;
      align-items: center;
      justify-content: center;
      z-index: 1000;
    }
    .modal-overlay.show { display: flex; }
    .modal-box {
      background: var(--bg-white);
      padding: 2rem;
      border-radius: var(--radius-sm);
      width: 320px;
      text-align: center;
      box-shadow: 0 4px 12px rgba(0,0,0,0.2);
    }
    .modal-box p {
      margin-bottom: 1.5rem;
      font-size: 1rem;
      color: var(--text);
    }
    .modal-actions {
      display: flex;
      gap: 1rem;
    }
    .modal-actions button {
      flex: 1;
      padding: 0.5rem;
      border: none;
      border-radius: var(--radius-sm);
      cursor: pointer;
      font-size: 0.95rem;
      transition: background 0.2s;
    }
    .btn-cancel { background: #eee; color: #333; }
    .btn-cancel:hover   { background: #ddd; }
    .btn-confirm { background: #111; color: #fff; }
    .btn-confirm:hover { background: #333; }

    @media(max-width:800px) {
      .dashboard { flex-direction: column; }
      .dashboard__nav { width:100%; height:auto; position:relative; }
      .dashboard__content { padding:1rem; }
      .stats-cards { grid-template-columns:1fr; }
      .cart-table-wrapper { font-size:0.9rem; }
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
        <div class="page-title">My Cart</div>

        <!-- Cart Summary -->
        <section class="stats-overview">
          <div class="stats-overview__header">
            <h2>Cart Summary</h2>
          </div>
          <div class="stats-cards">
            <div class="stats-card">
              <p class="stats-card__label">Total Items</p>
              <h3 class="stats-card__value">
                <c:out value="${totalItems}" default="0"/>
              </h3>
            </div>
            <div class="stats-card">
              <p class="stats-card__label">Total Price</p>
              <h3 class="stats-card__value">
                $<c:out value="${totalPrice}" default="0.00"/>
              </h3>
            </div>
          </div>
        </section>

        <!-- Cart Items Table -->
        <section class="cart-section">
          <div class="cart-section__header">
            <h2>Cart Items</h2>
          </div>
          <div class="cart-table-wrapper">
            <table class="cart-table">
              <thead>
                <tr>
                  <th>SN</th>
                  <th>Model Name</th>
                  <th>Category</th>
                  <th>Price (USD)</th>
                  <th>Seller</th>
                  <th>Remove</th>
                </tr>
              </thead>
              <tbody>
                <c:forEach var="item" items="${cartList}" varStatus="st">
                  <tr>
                    <td>${st.index + 1}</td>
                    <td><c:out value="${item.modelName}"/></td>
                    <td><c:out value="${item.category}"/></td>
                    <td>$<c:out value="${item.price}"/></td>
                    <td>@<c:out value="${item.sellerUsername}"/></td>
                    <td>
                      <!-- absolute URL to hit your servlet -->
                      <form action="${ctx}/removeFromCart" method="post" style="margin:0;">
					  <input type="hidden" name="modelId" value="${item.modelId}"/>
					  <button type="submit" class="button button--remove">Remove</button>
					</form>
                    </td>
                  </tr>
                </c:forEach>
                <c:if test="${empty cartList}">
                  <tr><td colspan="6" class="no-data">No items in your cart.</td></tr>
                </c:if>
              </tbody>
            </table>
          </div>

          <!-- checkout -->
          <div class="cart-controls">
            <label class="terms">
              <input type="checkbox" id="agreeTerms"/> I agree to the terms of use
            </label>
            <button id="checkoutBtn" class="button button--checkout">
              Check Out
            </button>
          </div>
        </section>
      </div>

      <footer>
        <jsp:include page="/WEB-INF/pages/component/CopyRight.jsp"/>
      </footer>
    </div>
  </div>
  
  <!-- Warning Modal: “Please agree…” -->
<div id="warningModal" class="modal-overlay">
  <div class="modal-box">
    <p>Please agree to the terms of use before checking out.</p>
    <div class="modal-actions">
      <button id="warnOk" class="btn-confirm">OK</button>
    </div>
  </div>
</div>

<!-- Confirmation Modal: “Are you sure?” -->
<div id="confirmModal" class="modal-overlay">
  <div class="modal-box">
    <p>Are you sure you want to complete your purchase?</p>
    <div class="modal-actions">
      <button id="modalCancel" class="btn-cancel">Cancel</button>
      <button id="modalConfirm" class="btn-confirm">Yes</button>
    </div>
  </div>
</div>
  

  <!-- warning & confirm modals… (omitted for brevity) -->

<script>
  const ctx = '<%=ctx%>'; // in Cart JSP; in Models JSP use your ctx variable or hardcode contextPath

  document.addEventListener('DOMContentLoaded', () => {
    const checkoutBtn   = document.getElementById('checkoutBtn');
    const agreeCheckbox = document.getElementById('agreeTerms');
    const warningModal  = document.getElementById('warningModal');
    const warnOk        = document.getElementById('warnOk');
    const confirmModal  = document.getElementById('confirmModal');
    const btnCancel     = document.getElementById('modalCancel');
    const btnConfirm    = document.getElementById('modalConfirm');

    // 1) Click “Check Out”
    checkoutBtn.addEventListener('click', () => {
      if (!agreeCheckbox.checked) {
        // show existing centered warning modal
        warningModal.classList.add('show');
      } else {
        // show confirm Yes/No
        confirmModal.classList.add('show');
      }
    });

    // 2) Dismiss warning
    warnOk.addEventListener('click', () => {
      warningModal.classList.remove('show');
    });

    // 3) Cancel confirm
    btnCancel.addEventListener('click', () => {
      confirmModal.classList.remove('show');
    });

    // 4) Yes → actually checkout
    btnConfirm.addEventListener('click', () => {
      confirmModal.classList.remove('show');

      fetch(`${ctx}/checkout`, { method: 'POST' })
        .then(resp => {
          if (!resp.ok) throw new Error('Network error');
          // green success toast
          const toast = document.createElement('div');
          toast.textContent = '✅ Purchase successful!';
          Object.assign(toast.style, {
            position: 'fixed',
            bottom:  '2rem',
            right:   '2rem',
            background: '#4caf50',
            color:      '#fff',
            padding:    '0.75rem 1.25rem',
            borderRadius: '8px',
            fontSize:     '0.95rem',
            zIndex:       1001,
            boxShadow:    '0 2px 6px rgba(0,0,0,0.2)',
            fontFamily:   'sans-serif'
          });
          document.body.appendChild(toast);
          setTimeout(() => toast.remove(), 3000);

          // reload to reflect empty cart or updated data
          setTimeout(() => window.location = `${ctx}/BuyerOrder`, 500);
        })
        .catch(err => {
          // red error toast
          const toast = document.createElement('div');
          toast.textContent = '⚠️ Checkout failed';
          Object.assign(toast.style, {
            position: 'fixed',
            bottom:  '2rem',
            right:   '2rem',
            background: '#f44336',
            color:      '#fff',
            padding:    '0.75rem 1.25rem',
            borderRadius: '8px',
            fontSize:     '0.95rem',
            zIndex:       1001,
            boxShadow:    '0 2px 6px rgba(0,0,0,0.2)',
            fontFamily:   'sans-serif'
          });
          document.body.appendChild(toast);
          setTimeout(() => toast.remove(), 3000);
        });
    });
  });
</script>

</body>
</html>
