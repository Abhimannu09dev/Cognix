// src/main/java/com/cognix/controller/SellerModel.java
package com.cognix.controller;

import com.cognix.DAO.ModelDAO;
import com.cognix.DAO.ReportDAO;
import com.cognix.model.Model;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.math.BigDecimal;
import java.sql.Date;
import java.util.List;

@WebServlet("/SellerModel")
public class SellerModel extends HttpServlet {
    private final ReportDAO reportDao = new ReportDAO();
    private final ModelDAO   modelDao  = new ModelDAO();

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        Integer sellerId = (session != null)
                         ? (Integer) session.getAttribute("userId")
                         : null;

        if (sellerId == null) {
            response.sendRedirect(request.getContextPath() + "/Login");
            return;
        }

        // pull filters
        String search    = request.getParameter("search");
        String modelType = request.getParameter("modelType");
        Date   postedAt  = null;
        String posted    = request.getParameter("postedAt");
        if (posted != null && !posted.isBlank()) {
            postedAt = Date.valueOf(posted);
        }

        try {
            // 1) seller summary stats
            int totalListings       = reportDao.getTotalModelsListed(sellerId);
            int totalSales          = reportDao.getTotalOrdersReceived(sellerId);
            BigDecimal totalRevenue = reportDao.getTotalRevenueGenerated(sellerId);
            String mostPopular      = reportDao.getBestSellingModel(sellerId);

            // 2) this seller’s models + per-model stats
            List<Model> modelsList = modelDao.findSellerModelsWithStats(
                sellerId, search, modelType, postedAt
            );

            // 3) distinct categories for this seller
            List<String> categoriesList =
                reportDao.getDistinctCategoriesForSeller(sellerId);

            // 4) expose everything to the JSP
            request.setAttribute("totalListings",        totalListings);
            request.setAttribute("totalSales",           totalSales);
            request.setAttribute("totalRevenue",         totalRevenue);
            request.setAttribute("mostPopularModelName", mostPopular);
            request.setAttribute("modelsList",           modelsList);
            request.setAttribute("categoriesList",       categoriesList);

            request.getRequestDispatcher(
                "/WEB-INF/pages/Seller/SellerModel.jsp"
            ).forward(request, response);

        } catch (Exception e) {
            throw new ServletException("Unable to load seller models", e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req,
                          HttpServletResponse resp)
            throws ServletException, IOException {
        doGet(req, resp);
    }
}
