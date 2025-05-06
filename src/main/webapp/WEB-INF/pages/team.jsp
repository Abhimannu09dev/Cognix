<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <title>Meet Our Team | Cognix</title>
     <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" 
     	integrity="sha512-..." 
     	crossorigin="anonymous" referrerpolicy="no-referrer" />
    <style>
        body {
            font-family: 'Segoe UI', sans-serif;
            margin: 0;
            padding: 0;
            background: #F2EEEB;
            max-width: 1440px; 
        }
        .layout {
            display: flex;
            min-height: 100vh;
            gap: 20px; /* space between sidebar and main content */
            background:#F2EEEB;
        }
        .nav {
            flex: 0 0 280px;
        }
        .main-content {
            flex: 1;
            padding: 30px;
            background: #f9f7f6;
            background-color:#F2EEEB;
            display: flex;
            line-height:1.6;
            flex-direction: column;
        }
        .page-header {
            display: flex;
            align-items: center;
            margin-bottom: 20px;
        }
        .toggle-btn {
           background: #fff;
            border: none;
            border-radius: 50%;
            width: 36px;
            height: 36px;
            display: flex;
            align-items: center;
            justify-content: center;
            cursor: pointer;
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);
            margin-right: 12px;
            font-size: 18px;
        }
        .search-wrapper {
            margin-bottom: 20px;
        }
        h1 {
            font-size: 36px;
            margin: 0;
            color: #333;
        }
        .intro {
            color: #444;
            margin-bottom: 30px;
        }
        .team-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 25px;
        }
        .card {
            background: white;
            border-radius: 10px;
            padding: 20px;
            box-shadow: 0 2px 6px rgba(0,0,0,0.1);
            line-height:1,6;
            text-align: center;
        }
        .initials {
            width: 60px;
            height: 60px;
            background: #333;
            color: white;
            font-weight: bold;
            border-radius: 50%;
            line-height: 60px;
            margin: 0 auto 15px;
            font-size: 18px;
        }
        .name {
            font-size: 18px;
            font-weight: bold;
            margin-bottom: 5px;
        }
        .role {
            font-size: 14px;
            color: #666;
            margin-bottom: 10px;
        }
        .desc {
            font-size: 14px;
            color: #555;
            margin: 10px 0;
        }
        .core-values {
            max-width: 1440px;
            margin: 40px auto 0;
            padding: 20px 30px;
            background: #fff;
            border-radius: 12px;
            line-height: 1.6;
            box-shadow: 0 2px 6px rgba(0,0,0,0.05);
        }
        .core-values h2 {
            font-size: 22px;
            margin-bottom: 20px;
        }
        .values {
            display: flex;
            flex-wrap: wrap;
            gap: 20px;
        }
        .value {
            flex: 1 1 200px;
        }
        .value h3 {
            margin-bottom: 5px;
            font-size: 16px;
        }
        .value p {
            font-size: 14px;
            color: #555;
        }
         .icons {
            margin-top: 15px;
        }
        .icons a {
            margin: 0 8px;
            color: #555;
            font-size: 18px;
            transition: color .2s;
        }
        .icons a:hover { color: #000; }
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

        <!-- Main Content -->
        <div class="main-content">
            <!-- Header with Toggle Button -->
           <div class="page-header">
			  <button class="toggle-btn" type="button" onclick="window.history.back();">
			    <i class="fas fa-arrow-left"></i>
			  </button>
			  <h1>Meet Our Team</h1>
			</div>


            <!-- Introduction -->
            <p class="intro">
                The talented individuals behind Cognix bring together diverse expertise in <strong>AI</strong>,
                <strong>product development</strong>, <strong>research</strong>, and <strong>business strategy</strong>
                to build the premier marketplace for artificial intelligence models.
            </p>

            <!-- Team Grid -->
            <div class="team-grid">
                <div class="card">
                    <div class="initials">AM</div>
                    <div class="name">Alex Morgan</div>
                    <div class="role">Founder & CEO</div>
                    <div class="desc">Machine learning researcher with 10+ years of experience in AI. Previously led AI teams at top tech companies before founding Cognix</div>
                	<div class="icons">
                        <a href="#" title="LinkedIn"><i class="fab fa-linkedin"></i></a>
                        <a href="#" title="GitHub"><i class="fab fa-github"></i></a>
                        <a href="mailto:alex@cognix.com" title="Email"><i class="fas fa-envelope"></i></a>
                    </div>
                </div>
                <div class="card">
                    <div class="initials">SC</div>
                    <div class="name">Sarah Chen</div>
                    <div class="role">Chief Technology Officer</div>
                    <div class="desc">PhD in NLP. Led development of groundbreaking AI models and platforms.</div>
                    <div class="icons">
                        <a href="#" title="LinkedIn"><i class="fab fa-linkedin"></i></a>
                        <a href="#" title="GitHub"><i class="fab fa-github"></i></a>
                        <a href="mailto:alex@cognix.com" title="Email"><i class="fas fa-envelope"></i></a>
                    </div>
                </div>
                <div class="card">
                    <div class="initials">MP</div>
                    <div class="name">Michael Park</div>
                    <div class="role">Head of Product</div>
                    <div class="desc">Strategist in AI product management. Passionate about intuitive UX for complex tech.</div>
                	<div class="icons">
                        <a href="#" title="LinkedIn"><i class="fab fa-linkedin"></i></a>
                        <a href="mailto:alex@cognix.com" title="Email"><i class="fas fa-envelope"></i></a>
                    </div>
                </div>
                <div class="card">
                    <div class="initials">PS</div>
                    <div class="name">Priya Sharma</div>
                    <div class="role">Lead AI Researcher</div>
                    <div class="desc">Focused on ethical and accessible AI. Author on transparency and fairness in AI.</div>
               		<div class="icons">
                        <a href="#" title="GitHub"><i class="fab fa-github"></i></a>
                        <a href="mailto:alex@cognix.com" title="Email"><i class="fas fa-envelope"></i></a>
                    </div>
                </div>
                <div class="card">
                    <div class="initials">DW</div>
                    <div class="name">David Wilson</div>
                    <div class="role">Business Development</div>
                    <div class="desc">Expert in strategic partnerships. Connects AI innovators with impactful organizations.</div>
                	<div class="icons">
                        <a href="#" title="LinkedIn"><i class="fab fa-linkedin"></i></a>
                        <a href="mailto:alex@cognix.com" title="Email"><i class="fas fa-envelope"></i></a>
                    </div>
                </div>
            </div>

            <!-- Core Values -->
            <div class="core-values">
                <h2>★ Our Core Values</h2>
                <div class="values">
                    <div class="value">
                        <h3>Innovation</h3>
                        <p>We continously push boundaries to develop new approaches to AI that are both powerful and accessible.</p>
                    </div>
                    <div class="value">
                        <h3>Collaboration</h3>
                        <p>We believe the best solution emerge when diverse perspectives and talents work together.</p>
                    </div>
                    <div class="value">
                        <h3>Integrity</h3>
                        <p>We are committed to ethical AI development and maintaining transaparency in all our operations.</p>
                    </div>
                </div>
            </div>
        </div>
    </div>
</body>
</html>