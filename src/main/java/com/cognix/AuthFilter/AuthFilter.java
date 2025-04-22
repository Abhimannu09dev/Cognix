package com.cognix.AuthFilter;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
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
        String uri = req.getRequestURI();
        String ctx = req.getContextPath();

        // 1) Always allow your login/signup pages and static resources:
        if (  uri.startsWith(ctx + "/Login")
           || uri.startsWith(ctx + "/SignUp")
           || uri.contains("/assets/")
           || uri.contains("/uploads/") ) {
            chain.doFilter(request, response);
            return;
        }

        // 2) Must have a session + role:
        HttpSession session = req.getSession(false);
        String role = session!=null ? (String)session.getAttribute("role") : null;
        if (session == null || role == null) {
            resp.sendRedirect(ctx + "/Login");
            return;
        }

        // 3) Lock down URL prefixes by role:
        if (uri.startsWith(ctx + "/Admin") && ! "admin".equals(role)) {
            resp.sendRedirect(ctx + "/Login");
            return;
        }
        if (uri.startsWith(ctx + "/HomeSeller") && ! "seller".equals(role)) {
            resp.sendRedirect(ctx + "/Login");
            return;
        }
        if (uri.startsWith(ctx + "/BuyerDashboard") && ! "buyer".equals(role)) {
            resp.sendRedirect(ctx + "/Login");
            return;
        }

        // 4) All good:
        chain.doFilter(request, response);
    }
}
