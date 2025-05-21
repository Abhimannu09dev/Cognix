// src/main/java/com/cognix/controller/Users.java
package com.cognix.controller;

import com.cognix.DAO.AdminPanelDAO;
import com.cognix.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.List;


/**
 * @author - Krishna Singh
 */

@WebServlet("/Users")
public class Users extends HttpServlet {
    private final AdminPanelDAO dao = new AdminPanelDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        // 1) Auth guard
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            resp.sendRedirect(req.getContextPath() + "/Login");
            return;
        }

        // 2) Pull all filters from query string
        String q      = req.getParameter("q");
        String role   = req.getParameter("role");
        String status = req.getParameter("status");
        String sort   = req.getParameter("sort");

        try {
            // 3) NOTE the correct order: search, role, status, sort
            List<User> users = dao.findNewUsers(q, role, status, sort);
            req.setAttribute("usersList", users);

            // 4) Re‑expose so your JSP can re‑select them
            req.setAttribute("q",      q);
            req.setAttribute("role",   role);
            req.setAttribute("status", status);
            req.setAttribute("sort",   sort);

            // 5) Forward to JSP
            req.getRequestDispatcher("/WEB-INF/pages/Admin/Users.jsp")
               .forward(req, resp);

        } catch (Exception e) {
            throw new ServletException("Error loading user management", e);
        }
    }
}
