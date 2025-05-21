package com.cognix.controller;

import com.cognix.DAO.AdminPanelDAO;
import com.cognix.model.Model;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/Models")
public class ModelsServlet extends HttpServlet {
    private final AdminPanelDAO dao = new AdminPanelDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            resp.sendRedirect(req.getContextPath() + "/Login");
            return;
        }

        String q        = req.getParameter("q");
        String category = req.getParameter("category");
        String sort     = req.getParameter("sort");

        try {
            List<Model> modelsList       = dao.findModels(q, category, sort);
            List<String> modelCategories = dao.findAllCategories();

            req.setAttribute("modelsList", modelsList);
            req.setAttribute("modelCategories", modelCategories);

            req.getRequestDispatcher("/WEB-INF/pages/Admin/Models.jsp")
               .forward(req, resp);      // ← forward to Models.jsp
        } catch (Exception e) {
            throw new ServletException("Error loading model management", e);
        }
    }
}
