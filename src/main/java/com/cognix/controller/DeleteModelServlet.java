// src/main/java/com/cognix/controller/DeleteModelServlet.java
package com.cognix.controller;

import com.cognix.DAO.ModelDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/DeleteModel")
public class DeleteModelServlet extends HttpServlet {
    private final ModelDAO modelDao = new ModelDAO();

    @Override
    protected void doGet(HttpServletRequest req,
                         HttpServletResponse resp)
            throws ServletException, IOException {
        String idParam = req.getParameter("id");
        HttpSession session = req.getSession();

        if (idParam == null) {
            session.setAttribute("error", "Missing model ID");
            resp.sendRedirect(req.getContextPath() + "/SellerModel");
            return;
        }

        int modelId;
        try {
            modelId = Integer.parseInt(idParam);
        } catch (NumberFormatException e) {
            session.setAttribute("error", "Invalid model ID");
            resp.sendRedirect(req.getContextPath() + "/SellerModel");
            return;
        }

        try {
            boolean deleted = modelDao.deleteModel(modelId);
            if (deleted) {
                session.setAttribute("success", "Model deleted successfully.");
            } else {
                session.setAttribute("error", "Could not delete model.");
            }
        } catch (SQLException e) {
            throw new ServletException("Error deleting model", e);
        }

        // redirect back to your listing, flash message in session
        resp.sendRedirect(req.getContextPath() + "/SellerModel");
    }

    @Override
    protected void doPost(HttpServletRequest req,
                          HttpServletResponse resp)
            throws ServletException, IOException {
        doGet(req, resp);
    }
}
