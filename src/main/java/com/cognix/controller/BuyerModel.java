// src/main/java/com/cognix/controller/BuyerModel.java
package com.cognix.controller;

import com.cognix.DAO.ModelDAO;
import com.cognix.model.Model;
import com.cognix.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.sql.SQLException;
import java.util.Collections;
import java.util.List;

@WebServlet("/BuyerModel")
public class BuyerModel extends HttpServlet {
    private final ModelDAO modelDao = new ModelDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User me = session != null ? (User) session.getAttribute("user") : null;
        if (me == null) {
            response.sendRedirect(request.getContextPath() + "/Login");
            return;
        }
        int buyerUserId = me.getId();

        // 1) paging params
        int pageSize    = 9;
        int currentPage = 1;
        String pageParam = request.getParameter("page");
        if (pageParam != null) {
            try {
                currentPage = Math.max(1, Integer.parseInt(pageParam));
            } catch (NumberFormatException ignored) {}
        }

        String search    = request.getParameter("search");
        String modelType = request.getParameter("modelType");
        String sortBy    = request.getParameter("sortBy");

        try {
            // load categories
            request.setAttribute("allCategories", modelDao.findAllCategories());

            // fetch full list
            List<Model> fullList = modelDao.findFeaturedModels(
                buyerUserId, search, modelType, sortBy
            );

            // compute paging
            int totalItems = fullList.size();
            int totalPages = (int)Math.ceil(totalItems / (double)pageSize);
            int fromIndex = (currentPage - 1) * pageSize;
            int toIndex   = Math.min(fromIndex + pageSize, totalItems);

            List<Model> paged = Collections.emptyList();
            if (fromIndex < totalItems) {
                paged = fullList.subList(fromIndex, toIndex);
            }

            // expose to JSP
            request.setAttribute("pagedModelsList", paged);
            request.setAttribute("totalPages", totalPages);
            request.setAttribute("currentPage", currentPage);

        } catch (SQLException e) {
            throw new ServletException("Error loading models", e);
        }

        request.getRequestDispatcher(
          "/WEB-INF/pages/Buyer/BuyerModel.jsp"
        ).forward(request, response);
    }


    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
