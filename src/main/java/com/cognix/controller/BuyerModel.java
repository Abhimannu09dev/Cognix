package com.cognix.controller;

import com.cognix.DAO.ModelDAO;
import com.cognix.model.Model;
import com.cognix.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

@WebServlet("/BuyerModel")
public class BuyerModel extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private final ModelDAO modelDao = new ModelDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // 0) ensure logged in
        HttpSession session = request.getSession(false);
        User me = session != null ? (User) session.getAttribute("user") : null;
        if (me == null) {
            response.sendRedirect(request.getContextPath() + "/Login");
            return;
        }
        int buyerUserId = me.getId();

        // 1) Read filter parameters
        String search    = request.getParameter("search");
        String modelType = request.getParameter("modelType");
        String sortBy    = request.getParameter("sortBy");

        try {
            // 2) Load all distinct categories for the dropdown
            List<String> allCategories = modelDao.findAllCategories();
            request.setAttribute("allCategories", allCategories);

            // 3) Fetch featured models, excluding any already purchased by this user
            List<Model> modelsList = modelDao.findFeaturedModels(
                buyerUserId,
                search,
                modelType,
                sortBy
            );
            request.setAttribute("modelsList", modelsList);

        } catch (SQLException e) {
            throw new ServletException("Error loading models", e);
        }

        // 4) Forward to the JSP
        request.getRequestDispatcher("/WEB-INF/pages/Buyer/BuyerModel.jsp")
               .forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
