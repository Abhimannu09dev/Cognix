<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"/>
    <title>About Us – Cognix</title>
    <style>
        /* === Reset & Base === */
        * { box-sizing: border-box; margin: 0; padding: 0; line-height: 1.6; }
        html, body { height: 100%; }
        body {
            font-family: 'Helvetica Neue', sans-serif;
            background: #F1EDE9;
            color: #222;
        }

        /* === Layout Container === */
        .layout {
            display: flex;
            max-width: 1440px;
            margin: 0 auto;
            height: 100vh;
            overflow: hidden;
        }

        .sidebarinner {
		  height: 100vh;
		  overflow-y: auto;
		  overflow-x: hidden;       /* hide any horizontal overflow */
		}
		
		/* optional: hide the y‐scrollbar thumb if you don’t want to show it */
		.sidebar::-webkit-scrollbar {
		  width: 0;
		  background: transparent;
		}
        

        /* === Main Content === */
        .main-content {
            flex: 1;
            display: flex;
            flex-direction: column;
            overflow-y: auto;
            scrollbar-width: none;
            -ms-overflow-style: none;
            padding: 2rem;
            background: #F1EDE9;
        }
        .main-content::-webkit-scrollbar { display: none; }

        /* === Inner Container === */
        .container {
            max-width: 1000px;
            margin: 0 auto;
        }

        /* === Typography === */
        h1 {
            font-size: 2rem;
            margin-bottom: 0.5rem;
        }
        p.lead {
            font-size: 1.125rem;
            margin-bottom: 2rem;
        }
        .section-title {
            font-size: 1.5rem;
            font-weight: 600;
            margin-top: 2rem;
            margin-bottom: 1rem;
        }
        hr {
            border: none;
            height: 2px;
            background: #111;
            width: 80px;
            margin: 1.5rem 0;
        }

        /* === Cards === */
        .card, .card-container .card {
            background: #fff;
            border-radius: 8px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.05);
            padding: 1.5rem;
            margin-bottom: 1.5rem;
        }
        .card-container {
            display: flex;
            flex-wrap: wrap;
            gap: 1rem;
        }
        .card-container .card {
            flex: 1;
            min-width: 250px;
        }

        /* === Buttons === */
        .button {
            display: inline-block;
            margin-top: 1.5rem;
            padding: 0.75rem 1.5rem;
            background: #111;
            color: #fff;
            text-decoration: none;
            border-radius: 4px;
            transition: background .2s;
        }
        .button:hover { background: #333; }
    </style>
</head>
<body>
    <div class="layout">
        <!-- Sidebar -->
        <c:choose>
            <c:when test="${sessionScope.role == 'seller'}">
                <aside class="sidebarinner">
                    <jsp:include page="/WEB-INF/pages/component/SellerNav.jsp"/>
                </aside>
            </c:when>
            <c:otherwise>
                <aside class="sidebar">
                    <jsp:include page="/WEB-INF/pages/component/BuyerNav.jsp"/>
                </aside>
            </c:otherwise>
        </c:choose>

        <!-- Main Content -->
        <div class="main-content">
            <div class="container">
                <h1>About Cognix</h1>
                <p class="lead">
                    The premier <span style="color:#3B82F6;">marketplace</span> for discovering and deploying cutting-edge AI models
                    that transform how businesses and individuals harness artificial intelligence.
                </p>

                <hr/>
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
                <a href="${pageContext.request.contextPath}/team" class="button">Meet Our Team</a>

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
