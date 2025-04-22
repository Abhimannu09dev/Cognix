<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <title>Seller Dashboard with Search</title>
  <style>
    /* ---- Search Bar ---- */
    .search-container {
      display: flex;
      justify-content: space-between;
      max-width: 71.188rem;
      padding: 0.625rem 0.75rem;
      border-bottom: 2px solid #e0e0e0;
    }
    .search-bar {
      display: flex;
      align-items: center;
      width: 100%;
      gap: 0.5rem;
    }
    .search-bar input {
      border: none;
      background: transparent;
      color: #1a1a1a;
      font-size: 1rem;
      width: 100%;
    }
    .search-bar input::placeholder {
      color: #aaa;
    }
    .search-bar input:focus { outline: none; }
    .search-bar {
      background: transparent;
      cursor: pointer;
    }
    .search-btn {
      background-color: transparent;
      border: none;
      cursor: pointer;
    }
    .search-bar img {
    	width:1.5rem;
    }
    .search-btn img{
    	width:1.5rem;
    }
  </style>
</head>
<body>

  <!-- Search bar -->
  <div class="search-container">
    <div class="search-bar">
      <img src="${pageContext.request.contextPath}/nav-icons/search.svg" alt="Search" />
      <input type="text" placeholder="Search for anything..." />
    </div>
    <button class="search-btn">
      <img src="${pageContext.request.contextPath}/nav-icons/arrow-right.svg" alt="Go" />
    </button>
  </div>

</body>
</html>
