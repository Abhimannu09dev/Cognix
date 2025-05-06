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

@WebServlet({"/BuyerOrder","/BuyerOder","/removeFromCart","/checkout"})
public class BuyerOder extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private final CartDAO cartDao = new CartDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        loadCartPage(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String path = req.getServletPath();
        HttpSession session = req.getSession(false);
        User loggedIn = session != null ? (User) session.getAttribute("user") : null;
        if (loggedIn == null) {
            resp.sendRedirect(req.getContextPath() + "/Login");
            return;
        }
        int buyerUserId = loggedIn.getId();

        try {
            if ("/removeFromCart".equals(path)) {
                int modelId = Integer.parseInt(req.getParameter("modelId"));
                cartDao.removeFromCart(buyerUserId, modelId);
                resp.sendRedirect(req.getContextPath() + "/BuyerOrder");
                return;

            } else if ("/checkout".equals(path)) {
                cartDao.checkout(buyerUserId);
                // redirect with success flag
                resp.sendRedirect(req.getContextPath() + "/BuyerOrder?checkoutSuccess=true");
                return;
            }
        } catch (SQLException e) {
            throw new ServletException("Cart operation failed", e);
        }

        resp.sendRedirect(req.getContextPath() + "/BuyerOrder");
    }

    private void loadCartPage(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        User loggedIn = session != null ? (User) session.getAttribute("user") : null;
        if (loggedIn == null) {
            resp.sendRedirect(req.getContextPath() + "/Login");
            return;
        }
        int buyerUserId = loggedIn.getId();

        try {
            List<Model> cartList = cartDao.findCartItems(buyerUserId);
            int totalItems = cartList.size();
            double totalPrice = cartList.stream()
                                        .mapToDouble(Model::getPrice)
                                        .sum();

            req.setAttribute("cartList", cartList);
            req.setAttribute("totalItems", totalItems);
            req.setAttribute("totalPrice", totalPrice);

        } catch (SQLException e) {
            throw new ServletException("Failed to load cart", e);
        }

        req.getRequestDispatcher("/WEB-INF/pages/Buyer/BuyerOrder.jsp")
           .forward(req, resp);
    }
}
