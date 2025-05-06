// src/main/java/com/cognix/controller/AdminDash.java
package com.cognix.controller;

import com.cognix.DAO.AdminPanelDAO;
import com.cognix.model.Model;
import com.cognix.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.List;

@WebServlet("/AdminDash")
public class AdminDash extends HttpServlet {
    private final AdminPanelDAO dao = new AdminPanelDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        // 1) Auth check
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            resp.sendRedirect(req.getContextPath() + "/Login");
            return;
        }

        // 2) Read all filters (note: statusFilter, not status)
        String userSearch     = req.getParameter("userSearch");
        String roleFilter     = req.getParameter("roleFilter");
        String statusFilter   = req.getParameter("statusFilter");  // ← fixed
        String sortUsers      = req.getParameter("sortUsers");
        String modelSearch    = req.getParameter("modelSearch");
        String categoryFilter = req.getParameter("categoryFilter");
        String sortModels     = req.getParameter("sortModels");

        try {
            // 3) Fetch “new users” with the correct 4‑arg order
            List<User> newUsers = dao.findNewUsers(
                userSearch,
                roleFilter,
                statusFilter,
                sortUsers
            );
            req.setAttribute("newUsersList",  newUsers);
            req.setAttribute("statusFilter",  statusFilter);  // so JSP can read it

            // 4) Fetch top models (unchanged)
            List<Model> topModels = dao.findTopModels(
                modelSearch,
                categoryFilter,
                sortModels
            );
            req.setAttribute("topModelsList", topModels);

            // 5) Category list for dropdown
            List<String> modelCategories = dao.findAllCategories();
            req.setAttribute("modelCategories", modelCategories);

            // 6) Forward
            req.getRequestDispatcher("/WEB-INF/pages/Admin/AdminDash.jsp")
               .forward(req, resp);

        } catch (Exception e) {
            throw new ServletException("Error loading admin dashboard", e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        doGet(req, resp);
    }
}
