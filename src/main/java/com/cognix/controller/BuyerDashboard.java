package com.cognix.controller;

import com.cognix.DAO.ModelDAO;
import com.cognix.model.Model;
import com.cognix.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/BuyerDashboard")
public class BuyerDashboard extends HttpServlet {
    private final ModelDAO dao = new ModelDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            resp.sendRedirect(req.getContextPath() + "/Login");
            return;
        }

        User me = (User) session.getAttribute("user");
        int buyerId       = me.getId();
        String search     = req.getParameter("search");
        String modelType  = req.getParameter("modelType");
        String sortBy     = req.getParameter("sortBy");
        String ownedSearch     = req.getParameter("ownedSearch");
        String ownedCategory   = req.getParameter("ownedCategory");
        String purchasedFilter = req.getParameter("purchasedFilter");

        try {
            // categories
            req.setAttribute("allCategories",    dao.findAllCategories());
            req.setAttribute("ownedCategories",  dao.findOwnedCategories(buyerId));
            // featured (excludes purchased)
            List<Model> featured = dao.findFeaturedModels(
                buyerId, search, modelType, sortBy);
            req.setAttribute("modelsList", featured);
            // owned
            req.setAttribute("purchasedList",
                dao.findPurchasedModels(buyerId, ownedSearch, ownedCategory, purchasedFilter));

            req.getRequestDispatcher("/WEB-INF/pages/Buyer/BuyerDashboard.jsp")
               .forward(req, resp);

        } catch (Exception e) {
            throw new ServletException("Error loading dashboard data", e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        doGet(req, resp);
    }
}
