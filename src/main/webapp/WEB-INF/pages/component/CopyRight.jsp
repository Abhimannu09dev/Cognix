<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%-- A tiny footer that shows the current year and your company name --%>
<div class="footer-copyright">
  <p>&copy; <%= java.time.Year.now().getValue() %> Cognix. All rights reserved.</p>
</div>

<style>
  /* --- Footer / Copyright Component --- */
  .footer-copyright {
    background: transparent;
    padding: 1.5rem;
    text-align: center;
  }
  .footer-copyright p {
    margin: 0;
    color: #888;
    font-size: .85rem;
    font-family: 'Helvetica Neue', sans-serif;
  }
</style>
