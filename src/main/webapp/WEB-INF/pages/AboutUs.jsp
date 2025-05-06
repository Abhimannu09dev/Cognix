<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8" />
    <title>About Us - Cognix</title>
    <style>
        * {
            box-sizing: border-box;
            margin: 0;
            padding: 0;
            line-height:1.6;
        }

        body {
            font-family: Arial, sans-serif;
            background-color: #f9f6f3;
            color: #333;
        }

        .Layout {
            display: flex;
            min-height: 100vh;
        }

        .nav {
            width: 220px;
            background-color: #fff;
            border-right: 1px solid #eee;
            padding: 20px 0;
        }

        .main-content {
            flex: 1;
            padding: 40px 30px;
        }

        .container {
            max-width: 1000px;
            margin: 0 auto;
        }

        h1 {
            font-size: 36px;
            color: #000;
            margin-bottom: 10px;
        }

        p.lead {
            font-size: 18px;
            margin-bottom: 30px;
            line-height: 1.6;
        }

        .section-title {
            font-size: 24px;
            font-weight: bold;
            margin-top: 40px;
            margin-bottom: 10px;
        }

        .card-container {
            display: flex;
            gap: 20px;
            margin-top: 15px;
            flex-wrap: wrap;
        }

        .card {
            flex: 1;
            min-width: 250px;
            padding: 20px;
            background-color: #fff;
            border-radius: 8px;
            box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);
        }

        .button {
            margin-top: 20px;
            padding: 10px 18px;
            background-color: black;
            color: white;
            border: none;
            cursor: pointer;
            text-decoration: none;
            display: inline-block;
            border-radius: 4px;
        }

        .button:hover {
            background-color: #333;
        }

        hr {
            border: none;
            height: 2px;
            background-color: black;
            width: 80px;
            margin: 20px 0;
        }
    </style>
</head>

<body>
    <div class="Layout">
        <!-- DYNAMIC NAVIGATION -->
        <c:choose>
            <c:when test="${sessionScope.role == 'seller'}">
                <jsp:include page="/WEB-INF/pages/component/SellerNav.jsp"/>
            </c:when>
            <c:otherwise>
                <jsp:include page="/WEB-INF/pages/component/BuyerNav.jsp"/>
            </c:otherwise>
        </c:choose>

        <!-- MAIN CONTENT -->
        <div class="main-content">
            <div class="container">
                <h1>About Cognix</h1>
                <p class="lead">
                    The premier <span style="color:#3B82F6;">marketplace</span> for discovering and deploying cutting-edge AI models
                    that transform how businesses and individuals harness artificial intelligence.
                </p>

                <div class="section-title">ⓘ Our Mission</div>
                <div class="card">
                    At Cognix, we're dedicated to democratizing access to artificial intelligence. We believe in creating a seamless bridge
                    between AI innovators and those who can benefit from their breakthroughs. Our platform enables the discovery, evaluation,
                    and implementation of AI models in a secure, transparent marketplace environment.
                </div>

                <div class="section-title">⚙️ What We Do</div>
                <div class="card-container">
                    <div class="card">
                        <strong>Curate</strong>
                        <p>We carefully select and showcase the most innovative and effective AI models across various domains.</p>
                    </div>
                    <div class="card">
                        <strong>Connect</strong>
                        <p>We bring together AI creators and organizations seeking powerful AI solutions to solve real-world problems.</p>
                    </div>
                    <div class="card">
                        <strong>Empower</strong>
                        <p>We provide the tools, documentation, and support needed to successfully implement AI models in diverse environments.</p>
                    </div>
                </div>

                <div class="section-title">👥 Our Team</div>
                <div class="card">
                    Cognix was founded by a team of AI researchers, engineers, and business strategists united by the vision of making
                    advanced AI accessible to everyone. Our diverse team brings together expertise in machine learning, platform development,
                    security, and user experience design.
                </div>
                <a href="${pageContext.request.contextPath}/team" class="button">
				  Meet Our Team
				</a>
                

                <div class="section-title">📬 Connect With Us</div>
                <div class="card">
                    Have questions about Cognix or interested in listing your AI model on our marketplace? We’d love to hear from you.
                </div>
                <a href="${pageContext.request.contextPath}/ContactUs" class="button">Contact Us</a>
            </div>
        </div>
    </div>
</body>

</html>