// src/main/java/com/cognix/controller/SellerOder.java
package com.cognix.controller;

import com.cognix.DAO.OrderDAO;
import com.cognix.DAO.ReportDAO;
import com.cognix.model.Order;
import com.cognix.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.List;

@WebServlet("/SellerOder")
public class SellerOder extends HttpServlet {
    private final ReportDAO reportDao = new ReportDAO();

    @Override
    protected void doGet(HttpServletRequest req,
                         HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            resp.sendRedirect(req.getContextPath() + "/Login");
            return;
        }
        User seller = (User) session.getAttribute("user");
        int sellerId = seller.getId();

        String search   = req.getParameter("search");
        String category = req.getParameter("modelType");
        String orderAt  = req.getParameter("orderAt");

        try {
            // 1) summary
            OrderDAO dao = new OrderDAO();
            int totalOrders         = dao.getTotalOrders(sellerId);
            double totalRevenue     = dao.getTotalRevenue(sellerId);
            java.util.Date latest   = dao.getLatestOrderDate(sellerId);

            // 2) fetch list
            List<Order> ordersList =
                dao.findOrders(sellerId, search, category, orderAt);

            // 3) fetch distinct categories for this seller
            List<String> categoriesList =
                reportDao.getDistinctCategoriesForSeller(sellerId);

            // 4) expose to JSP
            req.setAttribute("totalOrders",      totalOrders);
            req.setAttribute("totalRevenue",     totalRevenue);
            req.setAttribute("latestOrderDate",  latest);
            req.setAttribute("ordersList",       ordersList);
            req.setAttribute("categoriesList",   categoriesList);

            req.getRequestDispatcher(
              "/WEB-INF/pages/Seller/SellerOder.jsp"
            ).forward(req, resp);

        } catch (Exception e) {
            throw new ServletException("Unable to load orders", e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req,
                          HttpServletResponse resp)
            throws ServletException, IOException {
        doGet(req, resp);
    }
}
