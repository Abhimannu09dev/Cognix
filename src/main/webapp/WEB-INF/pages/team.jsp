<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8"/>
  <title>Meet Our Team | Cognix</title>
  <link rel="stylesheet"
        href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css"
        crossorigin="anonymous" referrerpolicy="no-referrer"/>
  <style>
    /* === Reset & Base === */
    * { box-sizing: border-box; margin: 0; padding: 0; }
    html, body { height: 100%; overflow: hidden; }
    body {
      font-family: 'Segoe UI', sans-serif;
      background: #F2EEEB;
      color: #333;
    }

    /* === Layout Container === */
    .layout { display: flex; height: 100%; background: #F2EEEB; }

    /* === Fixed Sidebar === */
    .nav {
      flex: 0 0 280px;
      position: fixed; top: 0; left: 0; bottom: 0;
      overflow-y: auto; scrollbar-width: none;
    }
    .nav::-webkit-scrollbar { width: 0; }

    /* === Main Content (scrollable) === */
    .main-content {
      margin-left: 280px; flex: 1;
      display: flex; flex-direction: column; height: 100%;
      overflow-y: auto; scrollbar-width: none; padding: 30px;
    }
    .main-content::-webkit-scrollbar { width: 0; }

    /* === Page Header === */
    .page-header {
      display: flex; align-items: center; margin-bottom: 20px;
    }
    .toggle-btn {
      background: #fff; border: none; border-radius: 50%;
      width: 36px; height: 36px; display: flex;
      align-items: center; justify-content: center;
      cursor: pointer; box-shadow: 0 2px 5px rgba(0,0,0,0.1);
      margin-right: 12px; font-size: 18px;
    }
    h1 { font-size: 36px; color: #333; }

    /* === Introduction === */
    .intro { color: #444; margin-bottom: 30px; line-height: 1.6; }

    /* === Team Grid === */
    .team-grid {
      display: grid;
      grid-template-columns: repeat(3, minmax(250px, 1fr));
      gap: 25px;
    }

    /* --- Card styling --- */
    .card {
      display: flex;
      flex-direction: column;
      justify-content: space-between;
      align-items: center;
      padding: 40px 30px;      /* increased padding */
      min-height: 420px;       /* increased height */
      background: #fff;
      border-radius: 10px;
      box-shadow: 0 2px 6px rgba(0,0,0,0.1);
      text-align: center;
    }

    /* larger avatar */
    .avatar {
      width: 100px; height: 100px;
      border-radius: 50%;
      object-fit: cover; display: block;
      margin-bottom: 25px;
      box-shadow: 0 2px 6px rgba(0,0,0,0.1);
    }

    /* bumped up name */
    .name {
      font-size: 1.6rem;
      font-weight: bold;
      color: #222;
      margin-bottom: 10px;
    }

    /* slightly larger subtitle */
    .role {
      font-size: 1rem;
      color: #555;
      margin-bottom: 15px;
    }

    /* improved description */
    .desc {
      font-size: 0.95rem;
      line-height: 1.6;
      color: #444;
      margin-bottom: 25px;
      max-width: 320px;
    }

    /* --- Icon row --- */
    .icons {
      display: flex;
      justify-content: center;
      gap: 1.5rem;        /* a bit more space */
    }
    .icons a {
      color: #555;
      font-size: 1.25rem;
      transition: color .2s;
    }
    .icons a:hover { color: #000; }

    /* === Core Values === */
    .core-values {
      margin-top: 40px; background: #fff; border-radius: 12px;
      padding: 20px 30px; box-shadow: 0 2px 6px rgba(0,0,0,0.05);
      line-height: 1.6;
    }
    .core-values h2 { font-size: 22px; margin-bottom: 20px; }
    .values { display: flex; flex-wrap: wrap; gap: 20px; }
    .value { flex: 1 1 200px; }
    .value h3 { font-size: 16px; margin-bottom: 5px; }
    .value p { font-size: 14px; color: #555; }
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
      <div class="page-header">
        <button class="toggle-btn" type="button" onclick="window.history.back();">
          <i class="fas fa-arrow-left"></i>
        </button>
        <h1>Meet Our Team</h1>
      </div>

      <p class="intro">
        The talented individuals behind Cognix bring together diverse expertise in
        <strong>Frontend development</strong>, <strong>Backend development</strong>, <strong>research</strong>,
        and <strong>Report Writing</strong> to build the premier marketplace for AI models.
      </p>

      <div class="team-grid">
        <!-- Utpala Khatri -->
        <div class="card">
          <img class="avatar" src="${pageContext.request.contextPath}/team/utpala_khatri.jpg" alt="Utpala Khatri"/>
          <div class="name">Utpala Khatri</div>
          <div class="role"><strong>Aspiring Web Developer</strong></div>
          <div class="desc">
            Passionate about building responsive and user-friendly websites using HTML, CSS, JavaScript,
            and modern frameworks, while continuously learning and improving web development skills.
          </div>
          <div class="icons">
            <a href="https://www.linkedin.com/in/utpalakhatri/" target="_blank"><i class="fab fa-linkedin"></i></a>
            <a href="https://github.com/utpalogic" target="_blank"><i class="fab fa-github"></i></a>
            <a href="mailto:utpalakc3@gmail.com"><i class="fas fa-envelope"></i></a>
          </div>
        </div>

        <!-- Abhimannu Singh Kunwar -->
        <div class="card">
          <img class="avatar" src="${pageContext.request.contextPath}/team/abhimannu_kunwar.jpg" alt="Abhimannu Kunwar"/>
          <div class="name">Abhimannu Singh Kunwar</div>
          <div class="role"><strong>Full Stack Devloper</strong></div>
          <div class="desc">
            I am a college student who enjoys building websites and learning about software development.
            I'm currently learning JavaScript, JSP, React and NodeJS.
          </div>
          <div class="icons">
            <a href="https://www.linkedin.com/in/abhimannu-singh-kunwar/" target="_blank"><i class="fab fa-linkedin"></i></a>
            <a href="https://github.com/Abhimannu09dev" target="_blank"><i class="fab fa-github"></i></a>
            <a href="mailto:anmolkunwar07@gmail.com"><i class="fas fa-envelope"></i></a>
          </div>
        </div>

        <!-- Sadhana Gautam -->
        <div class="card">
          <img class="avatar" src="${pageContext.request.contextPath}/team/sadhana_gautam.jpg" alt="Sadhana Gautam"/>
          <div class="name">Sadhana Gautam</div>
          <div class="role"><strong>Student</strong></div>
          <div class="desc">Passionate about building responsive and user-friendly websites using HTML, CSS, JavaScript,
            and modern frameworks, while continuously learning and improving web development skills.</div>
          <div class="icons">
            <a href="https://www.linkedin.com/in/sadhana-gautam-727939344/" target="_blank"><i class="fab fa-linkedin"></i></a>
            <a href="https://github.com/sadhanagautam23" target="_blank"><i class="fab fa-github"></i></a>
            <a href="mailto:gautamsadhana2004@gmail.com"><i class="fas fa-envelope"></i></a>
          </div>
        </div>

        <!-- Krishna Singh -->
        <div class="card">
          <img class="avatar" src="${pageContext.request.contextPath}/team/krishna_singh.png" alt="Krishna Singh"/>
          <div class="name">Krishna Singh</div>
          <div class="role"><strong>Aspiring Backend Developer</strong></div>
          <div class="desc">
            <p style="font-size:14px;"><b>Alright, bet </b> from battling it out in three hackathons to vibing through an intern gig
            and trainee bootcamp, I even whipped up a super dope IoT project. <br><b>Ayo, chill</b> this is
            just the warm-up; I’m cooking up more hacks, more builds, and nonstop learning!<p>
          </div>
          <div class="icons">
            <a href="https://www.linkedin.com/in/krishnasingh09/" target="_blank"><i class="fab fa-linkedin"></i></a>
            <a href="https://github.com/krishna09-dev" target="_blank"><i class="fab fa-github"></i></a>
            <a href="mailto:officialkrishna009@gmail.com"><i class="fas fa-envelope"></i></a>
          </div>
        </div>

        <!-- Md Smain Rain -->
        <div class="card">
          <img class="avatar" src="${pageContext.request.contextPath}/team/smain_rain.jpg" alt="Md Smain Rain"/>
          <div class="name">MD Samim Rain</div>
          <div class="role">Student</div>
          <div class="desc">My name is MD Samim Rain, and I am from Janakpurdham, Nepal. I am currently studying BSc (Hons) Computing at Islington College.</div>
          <div class="icons">
            <a href="http://www.linkedin.com/in/samim-rain-6a3b9b267" target="_blank"><i class="fab fa-linkedin"></i></a>
            <a href="https://github.com/rainsamim07" target="_blank"><i class="fab fa-github"></i></a>
            <a href="mailto:samimrain330@gmail.com"><i class="fas fa-envelope"></i></a>
          </div>
        </div>
      </div>

      <div class="core-values">
        <h2>★ Our Core Values</h2>
        <div class="values">
          <div class="value">
            <h3>Innovation</h3>
            <p>We continuously push boundaries to develop new approaches to AI that are both powerful and accessible.</p>
          </div>
          <div class="value">
            <h3>Collaboration</h3>
            <p>We believe the best solutions emerge when diverse perspectives and talents work together.</p>
          </div>
          <div class="value">
            <h3>Integrity</h3>
            <p>We are committed to ethical AI development and maintaining transparency in all our operations.</p>
          </div>
        </div>
      </div>

      <footer>
        <jsp:include page="/WEB-INF/pages/component/CopyRight.jsp"/>
      </footer>
    </div>
  </div>
</body>
</html>
