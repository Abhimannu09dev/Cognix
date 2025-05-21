package com.cognix.controller;

import com.cognix.DAO.ModelDAO;
import com.cognix.model.Model;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/ProductDes")
public class ProductDes extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private final ModelDAO dao = new ModelDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String idParam = req.getParameter("id");
        if (idParam == null) {
            resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "Missing id");
            return;
        }

        int id;
        try {
            id = Integer.parseInt(idParam);
        } catch (NumberFormatException e) {
            resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid id");
            return;
        }

        try {
            Model model = dao.findById(id);
            if (model == null) {
                resp.sendError(HttpServletResponse.SC_NOT_FOUND, "Model not found");
                return;
            }
            req.setAttribute("model", model);
            req.getRequestDispatcher("/WEB-INF/pages/Buyer/ProductDes.jsp")
               .forward(req, resp);
        } catch (Exception e) {
            throw new ServletException("Unable to load product", e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        doGet(req, resp);
    }
}
