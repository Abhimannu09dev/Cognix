// src/com/cognix/controller/Logout.java
package com.cognix.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

@WebServlet("/logout")
public class Logout extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        
        // 1. Invalidate current session (remove user/admin session)
        HttpSession session = req.getSession(false);
        if (session != null) {
            session.invalidate();
        }

        // 2. Redirect to login page
        resp.sendRedirect(req.getContextPath() + "/Login");
    }
}
