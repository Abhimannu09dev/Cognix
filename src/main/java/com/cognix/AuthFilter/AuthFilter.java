package com.cognix.AuthFilter;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebFilter("/*")
public class AuthFilter implements Filter {

  @Override
  public void doFilter(ServletRequest request,
                       ServletResponse response,
                       FilterChain chain)
      throws IOException, ServletException {

    HttpServletRequest  req  = (HttpServletRequest) request;
    HttpServletResponse resp = (HttpServletResponse) response;
    String uri  = req.getRequestURI();
    String ctx  = req.getContextPath();

    // ── 0) GATE uploads: allow if logged-in, otherwise redirect ──
    if (uri.contains(ctx + "/uploads/")) {
      HttpSession sess = req.getSession(false);
      if (sess != null && sess.getAttribute("user") != null) {
        // authenticated → let Tomcat serve the image
        chain.doFilter(request, response);
      } else {
        // not logged-in → back to login
        resp.sendRedirect(ctx + "/Login");
      }
      return;
    }

    // ── 1) Public pages & static assets ──
    if (uri.startsWith(ctx + "/Login")
     || uri.startsWith(ctx + "/SignUp")
     || uri.startsWith(ctx + "/ContactUs")
     || uri.contains(ctx + "/assets/")
     || uri.contains(ctx + "/css/")
     || uri.contains(ctx + "/nav-icons/")
    ) {
      chain.doFilter(request, response);
      return;
    }

    // ── 2) Session + role/status ──
    HttpSession session = req.getSession(false);
    String role   = null;
    String status = null;
    if (session != null) {
      Object r = session.getAttribute("role");
      role   = (r != null ? r.toString().toLowerCase() : null);
      Object s = session.getAttribute("status");
      status = (s != null ? s.toString().toLowerCase() : null);
    }

    // ── 2a) Not logged in? ──
    if (role == null) {
      resp.sendRedirect(ctx + "/Login");
      return;
    }

    // ── 2b) Blocked users ──
    if ("blocked".equals(status)) {
      session.invalidate();
      resp.sendRedirect(ctx + "/Login?error=You+have+been+blocked");
      return;
    }

    // ── 3) Buyer cart/order shortcuts ──
    if (uri.startsWith(ctx + "/addToCart")
     || uri.startsWith(ctx + "/removeFromCart")
     || uri.startsWith(ctx + "/checkout")
     || uri.startsWith(ctx + "/BuyerOrder")
     || uri.startsWith(ctx + "/BuyerOder")) {
      chain.doFilter(request, response);
      return;
    }

    // ── 4) Role-based areas ──
    if (uri.startsWith(ctx + "/Admin") && !"admin".equals(role)) {
      resp.sendRedirect(ctx + "/Login");
      return;
    }
    if ((uri.startsWith(ctx + "/HomeSeller")
       || uri.startsWith(ctx + "/SellerModel"))
      && !"seller".equals(role)) {
      resp.sendRedirect(ctx + "/Login");
      return;
    }
    if (uri.startsWith(ctx + "/BuyerDashboard") && !"buyer".equals(role)) {
      resp.sendRedirect(ctx + "/Login");
      return;
    }

    // ── 5) Everything else OK ──
    chain.doFilter(request, response);
  }

  @Override
  public void init(FilterConfig filterConfig) throws ServletException { }

  @Override
  public void destroy() { }
}
