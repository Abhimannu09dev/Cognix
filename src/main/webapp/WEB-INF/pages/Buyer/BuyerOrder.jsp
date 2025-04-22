<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core"       %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"        %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <title>My Cart – Cognix</title>

  <!-- Font Awesome -->
  <link
    rel="stylesheet"
    href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css"
    crossorigin="anonymous"
    referrerpolicy="no-referrer"
  />

  <style>
    /* === Reset & Base === */
    * { box-sizing: border-box; margin: 0; padding: 0; }
	body {
	  margin: 0;
	  font-family: 'Helvetica Neue', sans-serif;
	  background: #F1EDE9;
	  color: #222;
	}
	
	/* Center the whole dashboard at max‑width */
	.dashboard {
	  display: flex;
	  max-width: 1440px;
	  margin: 0 auto;      /* center horizontally */
	  min-height: 100vh;
	}
    .dashboard__nav {
      width: 240px;
    }
	.dashboard__main {
	  flex: 1;
	  display: flex;
	  flex-direction: column;
	}
	.dashboard__topbar {
	  padding: 1rem 2rem;
	}
	.dashboard__content {
	  flex: 1;
	  padding: 2rem;
	  display: flex;
	  flex-direction: column;
	  gap: 2rem;
	}

    /* === Page Title === */
    .page-title {
      font-size: 1.5rem;
      margin-bottom: 1rem;
    }

    /* === Stats Overview === */
    .stats-overview {
      background: #fff;
      border: 1px solid #e0e0e0;
      border-radius: 16px;
      padding: 1.5rem;
      max-width: 72rem;
    }
    .stats-overview__header {
      display: flex;
      align-items: center;
      margin-bottom: 1rem;
    }
    .stats-overview__header h2 {
      font-size: 1.25rem;
      color: #222;
    }
    .stats-cards {
      display: grid;
      grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
      gap: 1rem;
    }
    .stats-card {
      background: #f9f9f9;
      border: 1px solid #e0e0e0;
      border-radius: 8px;
      padding: 1rem;
    }
    .stats-card__label {
      font-size: .75rem;
      color: #666;
    }
    .stats-card__value {
      font-size: .875rem;
      color: #222;
      margin-top: .5rem;
    }

    /* === Cart Section === */
    .cart-section {
      background: #fff;
      border: 1px solid #e0e0e0;
      border-radius: 16px;
      padding: 1.5rem;
      max-width: 72rem;
      margin: 0 auto;
      display: flex;
      flex-direction: column;
      gap: 1rem;
    }
    .cart-section__header {
      display: flex;
      align-items: center;
    }
    .cart-section__header h2 {
      font-size: 1.25rem;
      color: #222;
    }

    /* === Cart Table === */
    .cart-table-wrapper {
      overflow-x: auto;
    }
    .cart-table {
      width: 100%;
      border-collapse: collapse;
      table-layout: fixed;
    }
    .cart-table th,
    .cart-table td {
      padding: .75rem 1rem;
      text-align: left;
      vertical-align: middle;
      border-bottom: 1px solid #f5f5f5;
      font-size: .95rem;
    }
    .cart-table th {
      font-size: .85rem;
      color: #666;
      border-bottom: 1px solid #e0e0e0;
    }
    .cart-table tr:last-child td {
      border-bottom: none;
    }
    .cart-table td.no-data {
      text-align: center;
      color: #666;
      padding: 2rem 0;
    }

    /* === Buttons === */
    .button {
      border: none;
      border-radius: 8px;
      cursor: pointer;
      transition: background .2s;
    }
    .button--remove {
      background: #111;
      color: #fff;
      padding: .5rem 1rem;
      font-size: .95rem;
    }
    .button--remove:hover {
      background: #333;
    }
    .button--checkout {
      background: #111;
      color: #fff;
      padding: .75rem 1.5rem;
      font-size: 1rem;
    }
    .button--checkout:hover {
      background: #333;
    }

    /* === Bottom Controls === */
    .cart-controls {
      display: flex;
      justify-content: space-between;
      align-items: center;
      margin-top: 1rem;
    }
    .terms {
      display: flex;
      align-items: center;
      font-size: .95rem;
      color: #444;
    }
    .terms input {
      margin-right: .5rem;
    }
  </style>
</head>
<body>
  <div class="dashboard">
    <aside class="dashboard__nav">
      <jsp:include page="/WEB-INF/pages/component/BuyerNav.jsp"/>
    </aside>

    <div class="dashboard__main">
      <header class="dashboard__topbar">
        <jsp:include page="/WEB-INF/pages/component/SerachBar.jsp"/>
      </header>

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
                $<c:out value="${totalPrice}" default="0"/>
              </h3>
            </div>
          </div>
        </section>

        <!-- Cart Items -->
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
                <c:forEach var="item" items="${cartList}">
                  <tr>
                    <td><c:out value="${item.sn}"/></td>
                    <td><c:out value="${item.modelName}"/></td>
                    <td><c:out value="${item.category}"/></td>
                    <td>$<c:out value="${item.price}"/></td>
                    <td>@<c:out value="${item.sellerUsername}"/></td>
                    <td>
                      <form action="removeFromCart" method="post" style="margin:0;">
                        <input type="hidden" name="modelId" value="${item.modelId}"/>
                        <button type="submit" class="button button--remove">
                          Remove
                        </button>
                      </form>
                    </td>
                  </tr>
                </c:forEach>
                <c:if test="${empty cartList}">
                  <tr>
                    <td colspan="6" class="no-data">No items in your cart.</td>
                  </tr>
                </c:if>
              </tbody>
            </table>
          </div>

          <div class="cart-controls">
            <label class="terms">
              <input type="checkbox" name="agreeTerms" id="agreeTerms"/>
              I agree to the platform’s terms of use
            </label>
            <form action="checkout" method="post" style="margin:0;">
              <button type="submit" class="button button--checkout">
                Check Out
              </button>
            </form>
          </div>
        </section>
      </div>
    </div>
  </div>
</body>
</html>
