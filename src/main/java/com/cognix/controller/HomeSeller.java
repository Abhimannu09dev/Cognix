package com.cognix.controller;

import com.cognix.DAO.ReportDAO;
import com.cognix.model.Model;
import com.cognix.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.time.LocalDate;
import java.util.List;

@WebServlet("/HomeSeller")
public class HomeSeller extends HttpServlet {
    private final ReportDAO reportDao = new ReportDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            resp.sendRedirect(req.getContextPath() + "/Login");
            return;
        }

        User seller = (User) session.getAttribute("user");
        int sellerId = seller.getId();

        try {
            // summary cards
            req.setAttribute("totalListings",
                    reportDao.getTotalModelsListed(sellerId));
            req.setAttribute("totalSales",
                    reportDao.getTotalOrdersReceived(sellerId));
            req.setAttribute("totalEarnings",
                    reportDao.getTotalRevenueGenerated(sellerId));
            req.setAttribute("mostPopularModel",
                    reportDao.getBestSellingModel(sellerId));

            // fetch distinct categories for this seller
            List<String> categories =
                reportDao.getDistinctCategoriesForSeller(sellerId);
            req.setAttribute("categories", categories);

            // “Most Sold Models” table
            String category = req.getParameter("category");
            String sortBy   = req.getParameter("sortBy");
            List<Model> topModels = reportDao.getTopModels(
                    sellerId,
                    category,
                    sortBy
            );
            req.setAttribute("topModels", topModels);

        } catch (Exception e) {
            throw new ServletException("Unable to load seller dashboard", e);
        }

        req.getRequestDispatcher("/WEB-INF/pages/Seller/HomeSeller.jsp")
           .forward(req, resp);
    }
}
