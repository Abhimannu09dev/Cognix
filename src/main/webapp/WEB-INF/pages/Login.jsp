<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <title>CogniX - Login</title>
    <link rel="stylesheet" href="login.css" />
    <link
      href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css"
      rel="stylesheet"
    />
  </head>
  <style>
    body {
    margin: 0;
    padding: 0;
    font-family: 'Helvetica Neue', sans-serif;
    background-color: #fefefe;
  }
  
  .main-container {
    display: flex;
    justify-content: center;
    align-items: flex-start;
    gap: 60px;
    padding: 60px 80px;
    height: 100vh;
    box-sizing: border-box;
  }
  
  /* Left - Login */
  .form-section {
    width: 360px;
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
    font-size: 14px;
    border: 1px solid #ccc;
    border-radius: 6px;
    margin-bottom: 18px;
    width: 100%;
    box-sizing: border-box;
  }
  
  button[type="submit"] {
    background-color: #1c1c1c;
    color: white;
    padding: 11px;
    border: none;
    border-radius: 6px;
    font-size: 15px;
    cursor: pointer;
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
  
  /* Right - Assistant */
  .assistant-section {
    flex: 1;
    min-width: 500px;
    background-color: #f9f9f9;
    border-radius: 12px;
    padding: 24px;
    box-shadow: 0 2px 10px rgba(0, 0, 0, 0.08);
    display: flex;
    flex-direction: column;
    justify-content: space-between;
    height: 100%;
  }
  
  .chat-box {
    overflow-y: auto;
    flex: 1;
    align-items: center;
  }
  
  .bot-bubble {
    background-color: #fff;
    padding: 16px;
    border-radius: 12px;
    box-shadow: 0 1px 6px rgba(0, 0, 0, 0.05);
    font-size: 15px;
    line-height: 1.6;
    color: #333;
  }
  
  .logo-chat img {
    width: 32px;
    height: 32px;
    border-radius: 50%;
    margin-bottom: 10px;
  }
  
  .chat-actions {
    font-size: 13px;
    margin-top: 12px;
    color: #888;
    display: flex;
    gap: 12px;
    align-items: center;
  }
  
  .search-bar {
    display: flex;
    align-items: center;
    gap: 10px;
    margin-top: 20px;
  }
  
  .search-bar input {
    flex: 1;
    padding: 12px 16px;
    border-radius: 24px;
    border: 1px solid #ddd;
    font-size: 14px;
    outline: none;
  }
  
  .search-bar button {
    background: #1c1c1c;
    color: white;
    border: none;
    border-radius: 50%;
    padding: 10px;
    cursor: pointer;
    font-size: 16px;
  }
  
  </style>
  <body>
    <div class="main-container">
      <!-- Left Side - Login Form -->
      <div class="form-section">
        <h2>Get into your account</h2>
        <p class="subtext">CogniX - Your best place to get any AI Model</p>
        <form>
          <label for="email">Email</label>
          <input type="text" id="email" placeholder="leod@gmail.com" />

          <label for="password">Password</label>
          <input type="password" id="password" placeholder="********" />

          <button type="submit">Sign In</button>
        </form>
        <p class="signin-text">
          Don’t have an account? <a href="#">Sign Up</a>
        </p>
      </div>

      <!-- Right Side - Assistant Section -->
      <div class="assistant-section">
        <div class="chat-box">
          <div class="bot-bubble">
            <div class="logo-chat">
              <img src="Cognix.jpeg" alt="CogniX Logo" />
            </div>
            <p>
              <strong>“Welcome back to Cognix 👋”</strong><br />
              Your AI model marketplace is just a login away.
            </p>
            <p>
              Manage your models, explore new ones, or check your activity — all in one place.<br />
              Let’s get you back in.
            </p>

            <div class="chat-actions">
              <i class="bi bi-hand-thumbs-up"></i>
              <i class="bi bi-hand-thumbs-down"></i>
              <i class="bi bi-copy ms-2"></i> Copy
            </div>
          </div>
        </div>
        <div class="search-bar">
          <input type="text" placeholder="🔍 Search for anything.." />
          <button><i class="bi bi-arrow-up-right"></i></button>
        </div>
      </div>
    </div>
  </body>
</html>
