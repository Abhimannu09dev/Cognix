package com.cognix.controller;

import com.cognix.DAO.CartDAO;
import com.cognix.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/addToCart")
public class AddToCartServlet extends HttpServlet {
    private final CartDAO cartDao = new CartDAO();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        User me = session != null ? (User)session.getAttribute("user") : null;
        if (me == null) {
            resp.sendRedirect(req.getContextPath() + "/Login");
            return;
        }

        int buyerId = me.getId();
        int modelId = Integer.parseInt(req.getParameter("modelId"));
        double price = Double.parseDouble(req.getParameter("price"));

        boolean added;
        try {
            added = cartDao.addToCart(buyerId, modelId, price);
        } catch (SQLException e) {
            throw new ServletException("Failed to add to cart", e);
        }

        String redirect = req.getHeader("Referer");
        if (redirect == null) redirect = req.getContextPath() + "/BuyerDashboard";
        // append flag so your toast knows whether it was a new insert
        resp.sendRedirect(redirect + (redirect.contains("?") ? "&" : "?") + "added=" + added);
    }
}
