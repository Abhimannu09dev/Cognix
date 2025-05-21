<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <title>CogniX - Sign Up</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet" />
  <style>
    /* Same Styles as Login */
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
    form input, form select {
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
    /* Toast */
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
  </style>
</head>

<body>

<div class="main-container">

  <!-- Left: Sign Up Form -->
  <div class="form-section">
    <h2>Create a free account</h2>
    <p class="subtext">CogniX - Your best place to get any AI Model</p>

    <form method="post" action="${pageContext.request.contextPath}/SignUp">
      <label for="name">Full Name</label>
      <input id="name" name="name" type="text" placeholder="Leonardo DiCaprio" required>

      <label for="username">Username</label>
      <input id="username" name="username" type="text" placeholder="leo_234" required>

      <label for="email">Email</label>
      <input id="email" name="email" type="email" placeholder="leo@gmail.com" required>

      <label for="password">Password</label>
      <input id="password" name="password" type="password" placeholder="********" required>

      <label for="role">Role</label>
      <select id="role" name="role" required>
        <option value="">Select role</option>
        <option value="buyer">Buyer</option>
        <option value="seller">Seller</option>
      </select>

      <button type="submit">Sign Up</button>
    </form>

    <p class="signin-text">
      Already have an account? <a href="${pageContext.request.contextPath}/Login">Sign In</a>
    </p>
  </div>

  <!-- Right: Assistant Section -->
  <div class="assistant-section">
    <div class="bot-bubble">
      <strong>“Start your journey with Cognix 👋”</strong><br/>
      Discover the world of AI models easily and securely.
      <p>Buy, sell, explore — and grow your projects faster with the best AI models 🚀.</p>
      <p>Ready to join?</p>
      <div class="chat-actions">
        <i class="bi bi-hand-thumbs-up"></i>
        <i class="bi bi-hand-thumbs-down"></i>
        <i class="bi bi-copy"></i>
      </div>
    </div>

    <div class="search-bar">
      <input type="text" placeholder="🔍 Search for anything..." />
      <button><i class="bi bi-arrow-up-right"></i></button>
    </div>
  </div>

</div>

<!-- Toast for Registration Errors -->
<c:if test="${not empty error}">
  <div class="toast" id="errorToast">
    ${error}
  </div>
</c:if>

<!-- Toast Script -->
<script>
  window.addEventListener('load', function() {
    const errorToast = document.getElementById('errorToast');
    if (errorToast) {
      errorToast.classList.add('show');
      setTimeout(() => errorToast.classList.remove('show'), 4000);
    }
  });
</script>

</body>
</html>
