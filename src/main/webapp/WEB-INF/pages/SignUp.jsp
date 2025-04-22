<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <title>Cognix - Sign Up</title>
    <link rel="stylesheet" href="signup.css" />
    <link
      href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css"
      rel="stylesheet"
    />
  </head>
  <style>
  *,
*::before,
*::after {
  box-sizing: border-box;
}
  html{
      height: 100%;
  }
    body {
    font-family: 'Helvetica Neue', sans-serif;
    margin: 0;
    padding: 0;
    background-color: #fefefe;
    height: 100%;
  }
  
  .main-container {
    display: flex;
    justify-content: center;
    align-items: flex-start;
    gap: 40px;
    padding: 60px 40px;
    height: 100vh;
      box-sizing: border-box; /* include padding in height */
    
  }
  
  .form-section {
    width: 400px;
  }
  
  .form-section h2 {
    font-size: 24px;
    font-weight: bold;
  }
  
  .subtext {
    margin-bottom: 30px;
    color: #666;
  }
  
  form {
    display: flex;
    flex-direction: column;
  }
  
  form label {
    margin-bottom: 5px;
    font-weight: 500;
  }
  
  form input {
    margin-bottom: 20px;
    padding: 10px;
    font-size: 15px;
    border: 1px solid #ccc;
    border-radius: 6px;
  }
  
  button[type="submit"] {
    background-color: #111;
    color: white;
    padding: 12px;
    border: none;
    border-radius: 6px;
    font-size: 16px;
    cursor: pointer;
  }
  
  button[type="submit"]:hover {
    background-color: #333;
  }
  
  .signin-text {
    margin-top: 15px;
    font-size: 14px;
  }
  
  .signin-text a {
    color: #111;
    text-decoration: underline;
  }
  
  .logo img{
    width: 32px;
    height: 32px;
    border-radius: 50%;
    margin-bottom: 10px;
  }
  
.right-section {
  width: 500px;
  background: #f9f9f9;
  height: 100vh;               /* Full viewport height */
  box-sizing: border-box;      /* Ensures padding is included in height */
  border-radius: 0px;
  padding: 40px;
  box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
  display: flex;
  flex-direction: column;
  justify-content: center;
  overflow: hidden;  /* Prevents unwanted scrolling; use overflow: auto if you need scroll */
}

  
  .chat-box {
    overflow-y: auto;
    margin-bottom: 20px;
  }
  
  .text-bubble {
    background-color: #e5e5e5;
    padding: 10px 14px;
    border-radius: 18px;
    display: inline-block;
    margin-bottom: 16px;
    max-width: 80%;
    font-size: 15px;
    color: #333;
  }
  
  .bot-bubble {
    background-color: white;
    padding: 14px 16px;
    border-radius: 12px;
    box-shadow: 0 1px 6px rgba(0,0,0,0.08);
    font-size: 15px;
    line-height: 1.6;
  }
  
  .search-bar {
    width: 100%;
    text-align: center;
  }
  .chat-actions {
    font-size: 13px;
    margin-top: 12px;
    color: #888;
    display: flex;
    gap: 12px;
    align-items: center;
  }
  
  .search-bar input {
    width: 90%;
    padding: 12px 16px;
    border-radius: 24px;
    border: 1px solid #ddd;
    font-size: 15px;
  }
  
  </style>
  <body>
    <div class="main-container">
      <!-- Left Side - Signup Form -->
      <div class="form-section">
        <h2>Create a free account</h2>
        <p class="subtext">CogniX Your best place to get any AI Model</p>
        <form>
          <label>Full Name</label>
          <input type="text" placeholder="Leonardo DiCaprio" />

          <label>Username</label>
          <input type="text" placeholder="leo_234" />

          <label>Email</label>
          <input type="email" placeholder="leo@gmail.com" />

          <label>Password</label>
          <input type="password" placeholder="********" />

          <button type="submit">Sign Up</button>
        </form>
        <p class="signin-text">
          Already Have an account ? <a href="#">Sign In</a>
        </p>
      </div>

      <!-- Right Side - animation Box -->
      <div class="right-section">
        <div class="chat-box"> 
         <div class="text-bubble">Hey, what is CogniX about?</div>
          <div class="bot-bubble">
            <div class="logo">
                <img src="Cognix.jpeg" alt="CogniX Logo" />
              </div>
            <p>
              Welcome to Cognix👋, a modern marketplace built just for AI
              models🧠✨.
            </p>
            <p>
              Whether you're an AI developer looking to share your creations, or
              someone searching for models to enhance your projects, you're in
              the right place.Sellers can easily list their AI models with descriptions,
              versions, performance stats, and supporting docs.
            </p>
            <p>
              Buyers can browse by category, check out model details, and make
              quick purchases — all in one smooth experience.
            </p>
            <p>Think of it like an app store, but for AI🚀.</p>
            <p>
              If you ever need help, just ask me anything. I'm here to guide
              you!
            </p>
            <div class="chat-actions">
                <i class="bi bi-hand-thumbs-up"></i>
                <i class="bi bi-hand-thumbs-down"></i>
                <i class="bi bi-copy ms-2"></i> Copy
              </div>
          </div> 
         </div>
        <div class="search-bar">
          <input type="text" placeholder="🔎Search for anything.." />
        </div>
      </div>
    </div>
  </body>
</html>
