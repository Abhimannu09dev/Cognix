package com.cognix.controller;

import com.cognix.DAO.CartDAO;
import com.cognix.DAO.ModelDAO;
import com.cognix.model.Model;
import com.cognix.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;

/**
 * @author - Abhimannu Singh Kunwar
 */

@WebServlet("/addToCart")
public class AddToCartServlet extends HttpServlet {
    private final CartDAO cartDao   = new CartDAO();
    private final ModelDAO modelDao = new ModelDAO();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        // 1) Ensure user is logged in
        HttpSession session = req.getSession(false);
        User me = session != null ? (User) session.getAttribute("user") : null;
        if (me == null) {
            resp.sendRedirect(req.getContextPath() + "/Login");
            return;
        }

        int buyerId = me.getId();
        int modelId = Integer.parseInt(req.getParameter("modelId"));

        try {
            // 2) Fetch the real price from the DB
            Model m = modelDao.findById(modelId);
            if (m == null) {
                throw new ServletException("Model not found: " + modelId);
            }
            double price = m.getPrice();
            
            
         // 3) Add to cart
            boolean added = cartDao.addToCart(buyerId, modelId, price);
            
         // 4) Also record the purchase for “My Purchased Models”
         try {
              modelDao.insertPurchase(buyerId, modelId, price);
             } catch (SQLException e) {
             throw new ServletException("Error recording purchase", e);
            }

            // 4) Redirect back to wherever they were, appending the flag
            String redirect = req.getHeader("Referer");
            if (redirect == null) {
                redirect = req.getContextPath() + "/BuyerDashboard";
            }
            resp.sendRedirect(redirect + (redirect.contains("?") ? "&" : "?") + "added=" + added);

        } catch (SQLException e) {
            throw new ServletException("Failed to add to cart", e);
        }
    }
}