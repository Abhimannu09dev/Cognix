<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>Contact Us - COGNIX</title>
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" 
        crossorigin="anonymous" referrerpolicy="no-referrer" />
        
  <style>
body {
    font-family: Arial, sans-serif;
    background-color: #f4f0eb;
    margin: 0;
    padding: 0;
}
.layout {
    display: flex;
    min-height: 100vh;
    gap: 20px;
    line-height:1.6;
    
}
.nav {
    flex: 0 0 280px;
}
.main-content {
    flex: 1;
    padding: 30px;
    background-color: #f4f0eb;
    display: flex;
    flex-direction: column;
}
h1 {
    font-size: 32px;
    font-family: 'Georgia', serif;
}
form {
    display: grid;
    grid-template-columns: 1fr 1fr 1fr;
    gap: 15px;
    margin-top: 20px;
}
input, textarea {
    width: 100%;
    padding: 10px;
    border: none;
    border-bottom: 1px solid #ccc;
    font-size: 14px;
    background-color: transparent;
}
textarea {
    grid-column: span 3;
    height: 100px;
}
.submit-btn {
    margin-top: 20px;
    background-color: #b28b57;
    color: white;
    padding: 10px 25px;
    border: none;
    cursor: pointer;
    border-radius: 5px;
}
.footer {
    margin-top: 40px;
    padding-top: 20px;
    border-top: 1px solid #ccc;
    display: flex;
    justify-content: space-between;
}
.footer div {
    flex: 1;
    padding: 0 10px;
}
.footer h3 {
    font-family: 'Georgia', serif;
}
</style>
</head>
<body>
<div class="layout">
  <div class="nav">
    <c:choose>
      <c:when test="${sessionScope.role == 'seller'}">
        <jsp:include page="/WEB-INF/pages/component/SellerNav.jsp"/>
      </c:when>
      <c:otherwise>
        <jsp:include page="/WEB-INF/pages/component/BuyerNav.jsp"/>
      </c:otherwise>
    </c:choose>
  </div>

  <div class="main-content">
    <h1>Get in touch with us.<br>We're here to assist you.</h1>

    <form action="${pageContext.request.contextPath}/ContactUs" method="post">
      <!-- if you have a logged‑in user object in session -->
      <input type="hidden" name="userId" value="${sessionScope.user.id}" />

      <input type="text"    name="name"    placeholder="Your Name"     required />
      <input type="email"   name="email"   placeholder="Email Address" required />
      <input type="text"    name="subject" placeholder="Subject"       required />
      <textarea name="body"  placeholder="Message"         required></textarea>
      <input type="submit" class="submit-btn" value="Leave us a Message →" />
    </form>

    <c:if test="${not empty success}">
      <p style="color:green">${success}</p>
    </c:if>
    <c:if test="${not empty error}">
      <p style="color:red">${error}</p>
    </c:if>

    <div class="footer">
      <!-- … -->
    </div>
  </div>
</div>
</body>
</html>
