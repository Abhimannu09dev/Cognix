package com.cognix.controller;

import com.cognix.DAO.ModelDAO;
import com.cognix.model.Model;
import com.cognix.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.sql.SQLException;
import java.util.Comparator;
import java.util.Date;
import java.util.List;

@WebServlet("/BuyerMyModel")
public class BuyerMyModel extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private final ModelDAO modelDao = new ModelDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        User user = session != null ? (User) session.getAttribute("user") : null;
        if (user == null) {
            resp.sendRedirect(req.getContextPath() + "/Login");
            return;
        }
        int buyerId = user.getId();

        // read any filter params
        String category   = req.getParameter("category");
        String fromDate   = req.getParameter("fromDate");
        String toDate     = req.getParameter("toDate");

        try {
            // 1) Owned categories for dropdown
            List<String> ownedCategories = modelDao.findOwnedCategories(buyerId);
            req.setAttribute("ownedCategories", ownedCategories);

            // 2) Purchased list (you may extend DAO to take the 3 filters above)
            List<Model> purchasedList = modelDao.findPurchasedModels(
                buyerId, /*search*/ null, category, /*purchasedFilter*/ null);
            req.setAttribute("purchasedList", purchasedList);

            // 3) Summary stats
            int totalPurchased = purchasedList.size();
            double totalSpent   = purchasedList.stream()
                                               .mapToDouble(Model::getPrice)
                                               .sum();
            // most recent purchase date
            Date mostRecentDate = purchasedList.stream()
                .map(Model::getPurchaseDate)
                .max(Comparator.naturalOrder())
                .orElse(null);

            req.setAttribute("totalPurchased", totalPurchased);
            req.setAttribute("totalSpent", totalSpent);
            req.setAttribute("mostRecentDate", mostRecentDate);

        } catch (SQLException e) {
            throw new ServletException("Error loading your purchased models", e);
        }

        // forward to JSP
        req.getRequestDispatcher("/WEB-INF/pages/Buyer/BuyerMyModel.jsp")
           .forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        doGet(req, resp);
    }
}
