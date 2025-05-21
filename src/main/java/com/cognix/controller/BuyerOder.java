package com.cognix.controller;

import com.cognix.DAO.CartDAO;
import com.cognix.model.Model;
import com.cognix.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;



/**
 * @author - Sadhana Gautam
 */

@WebServlet({"/BuyerOrder","/BuyerOder","/removeFromCart","/checkout"})
public class BuyerOder extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private final CartDAO cartDao = new CartDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        User u = session != null ? (User) session.getAttribute("user") : null;
        if (u == null) {
            resp.sendRedirect(req.getContextPath() + "/Login");
            return;
        }

        try {
            List<Model> cart = cartDao.findCartItems(u.getId());
            req.setAttribute("cartList",    cart);
            req.setAttribute("totalItems",  cart.size());
            req.setAttribute("totalPrice",  
                cart.stream()
                    .mapToDouble(Model::getPrice)
                    .sum()
            );
        } catch (SQLException e) {
            throw new ServletException("Failed to load cart", e);
        }

        // <-- add this so JSP's ${ctx} works -->
        req.setAttribute("ctx", req.getContextPath());

        // forward to exactly your existing JSP
        req.getRequestDispatcher("/WEB-INF/pages/Buyer/BuyerOrder.jsp")
           .forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String path = req.getServletPath();
        HttpSession session = req.getSession(false);
        User u = session != null ? (User) session.getAttribute("user") : null;
        if (u == null) {
            resp.sendRedirect(req.getContextPath() + "/Login");
            return;
        }

        try {
            if ("/removeFromCart".equals(path)) {
                int modelId = Integer.parseInt(req.getParameter("modelId"));
                cartDao.removeFromCart(u.getId(), modelId);

            } else if ("/checkout".equals(path)) {
                cartDao.checkout(u.getId());
            }
        } catch (SQLException e) {
            throw new ServletException("Cart operation failed", e);
        }

        // after either remove or checkout, reload the same page
        resp.sendRedirect(req.getContextPath() + "/BuyerOrder");
    }
}
