<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <title>CogniX - Login</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet" />
  <style>
    /* --- Basic Page Styling --- */
    body {
      margin: 0;
      padding: 0;
      font-family: 'Helvetica Neue', sans-serif;
      background: #f1ede9;
      display: flex;
      justify-content: center;
      align-items: center;
      height: 100vh;
    }
    .main-container {
      display: flex;
      width: 100%;
      max-width: 75rem;
      justify-content: center;
      align-items: center;
      gap: 60px;
      padding: 20px;
      box-sizing: border-box;
    }
    /* --- Left Section: Form --- */
    .form-section {
      width: 24rem;
      background: #fff;
      padding: 2rem;
      border-radius: 12px;
      box-shadow: 0 2px 8px rgba(0,0,0,0.1);
    }
    .form-section h2 {
      font-size: 24px;
      font-weight: bold;
      margin-bottom: 6px;
    }
    .subtext {
      font-size: 13px;
      color: #666;
      margin-bottom: 30px;
    }
    form {
      display: flex;
      flex-direction: column;
    }
    form label {
      font-size: 14px;
      margin-bottom: 6px;
      font-weight: 500;
    }
    form input {
      padding: 10px;
      border: 1px solid #ccc;
      border-radius: 6px;
      margin-bottom: 18px;
      font-size: 15px;
      color: #333;
    }
    button[type="submit"] {
      background-color: #1c1c1c;
      color: white;
      border: none;
      border-radius: 6px;
      padding: 10px;
      font-size: 15px;
      cursor: pointer;
      transition: background-color 0.3s ease;
    }
    button[type="submit"]:hover {
      background-color: #333;
    }
    .signin-text {
      margin-top: 18px;
      font-size: 13px;
    }
    .signin-text a {
      color: #111;
      text-decoration: underline;
    }
    /* --- Right Section: Assistant / Banner --- */
    .assistant-section {
      width: 40rem;
      background-color: #f9f9f9;
      border-radius: 12px;
      padding: 20px;
      box-shadow: 0 2px 8px rgba(0,0,0,0.1);
      display: flex;
      flex-direction: column;
      justify-content: space-between;
      position: relative;
    }
    .bot-bubble {
      background: #fff;
      padding: 20px;
      border-radius: 12px;
      font-size: 15px;
      box-shadow: 0 1px 4px rgba(0,0,0,0.1);
    }
    .bot-bubble strong {
      font-size: 16px;
      color: #111;
    }
    .chat-actions {
      margin-top: 10px;
      display: flex;
      gap: 10px;
      font-size: 18px;
      color: #666;
    }
    .search-bar {
      margin-top: 20px;
      background: #fff;
      padding: 8px 12px;
      border-radius: 12px;
      display: flex;
      align-items: center;
    }
    .search-bar input {
      border: none;
      flex: 1;
      padding: 10px;
      font-size: 14px;
      background: transparent;
    }
    .search-bar button {
      background: #1c1c1c;
      color: #fff;
      border: none;
      padding: 10px;
      border-radius: 8px;
      cursor: pointer;
    }
    /* --- Toast (error and session expired) --- */
    .toast {
      position: fixed;
      top: 20px;
      right: 20px;
      background: #e74c3c;
      color: white;
      padding: 12px 20px;
      border-radius: 8px;
      font-size: 14px;
      z-index: 9999;
      opacity: 0;
      transform: translateY(-20px);
      transition: opacity 0.4s, transform 0.4s;
    }
    .toast.show {
      opacity: 1;
      transform: translateY(0);
    }
    
        /* --- BLOCKED‐ACCOUNT MODAL STYLES --- */
    .modal {
      position: fixed;
      top: 0; left: 0; right: 0; bottom: 0;
      background: rgba(0,0,0,0.5);
      display: none;           /* hidden by default */
      align-items: center;
      justify-content: center;
      z-index: 10000;
    }
    .modal.show { display: flex; }
    .modal-content {
      background: #fff;
      padding: 1.5rem;
      border-radius: 12px;
      max-width: 360px;
      width: 90%;
      text-align: center;
      box-shadow: 0 2px 10px rgba(0,0,0,0.2);
    }
    .modal-content h3 {
      margin-top: 0;
      margin-bottom: 1rem;
      font-size: 1.25rem;
    }
    .modal-content p {
      font-size: 1rem;
      margin-bottom: 1.5rem;
      line-height: 1.4;
    }
    .modal-content button {
      background: #111;
      color: #fff;
      border: none;
      border-radius: 6px;
      padding: 0.5rem 1rem;
      cursor: pointer;
      font-size: .95rem;
    }
    .modal-content button:hover {
      background: #333;
    }
  </style>
</head>

<body>

<div class="main-container">

  <!-- Left: Form -->
  <div class="form-section">
    <h2>Get into your account</h2>
    <p class="subtext">CogniX - Your best place to get any AI Model</p>

    <form method="post" action="${pageContext.request.contextPath}/Login">
      <label for="email">Email</label>
      <input type="text" id="email" name="email" placeholder="john@example.com" required />

      <label for="password">Password</label>
      <input type="password" id="password" name="password" placeholder="********" required />
      
      <label for="remember-me">
        <input type="checkbox" id="remember-me" name="remember-me" />
        Remember me
        </label>

      <button type="submit">Sign In</button>
    </form>

    <p class="signin-text">
      Don’t have an account? <a href="${pageContext.request.contextPath}/SignUp?currentPage=Signup">Sign Up</a>
    </p>
  </div>

  <!-- Right: Assistant Section -->
  <div class="assistant-section">
    <div class="bot-bubble">
      <strong>“Welcome back to Cognix 👋”</strong><br/>
      Your AI model marketplace is just a login away.
      <p>Manage your models, explore new ones, or check your activity — all in one place.<br/>Let’s get you back in.</p>
      <div class="chat-actions">
        <i class="bi bi-hand-thumbs-up"></i>
        <i class="bi bi-hand-thumbs-down"></i>
        <i class="bi bi-copy"></i>
      </div>
    </div>

    <div class="search-bar">
      <input type="text" placeholder="🔍 Search for anything.." />
      <button><i class="bi bi-arrow-up-right"></i></button>
    </div>
  </div>

</div>

<!-- Toast for Errors (Invalid login) -->
<c:if test="${not empty error}">
  <div class="toast" id="errorToast">
    ${error}
  </div>
</c:if>

<!-- Toast for Session Expired -->
<c:if test="${not empty sessionScope.expired}">
  <div class="toast" id="expiredToast">
    Session expired. Please login again.
  </div>
  <c:remove var="expired" scope="session"/>
</c:if>

  <!--  BLOCKED‐ACCOUNT MODAL  -->
  <c:if test="${blocked}">
    <div id="blockedModal" class="modal show">
      <div class="modal-content">
        <h3>Account Temporarily Blocked</h3>
        <p>
          Your account has been temporarily blocked.<br/>
          Please <a href="${pageContext.request.contextPath}/ContactUs">contact us</a>
          to resolve this.
        </p>
        <button id="blockedOk">OK</button>
      </div>
    </div>
  </c:if>



<!-- Toast Script -->
<script>
  window.addEventListener('load', function() {
    const errorToast = document.getElementById('errorToast');
    const expiredToast = document.getElementById('expiredToast');

    if (errorToast) {
      errorToast.classList.add('show');
      setTimeout(() => errorToast.classList.remove('show'), 4000);
    }

    if (expiredToast) {
      expiredToast.classList.add('show');
      setTimeout(() => expiredToast.classList.remove('show'), 4000);
    }
  });
  
  // close the blocked‐modal when “OK” is clicked
  document.addEventListener('DOMContentLoaded', () => {
    const blk = document.getElementById('blockedModal');
    if (!blk) return;
    blk.querySelector('#blockedOk')
       .addEventListener('click', () => blk.classList.remove('show'));
  });
</script>

</body>
</html>
