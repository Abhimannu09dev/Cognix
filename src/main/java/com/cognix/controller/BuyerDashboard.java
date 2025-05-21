package com.cognix.controller;

import com.cognix.DAO.ModelDAO;
import com.cognix.model.Model;
import com.cognix.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;



/**
 * @author - Sadhana Gautam
 */

@WebServlet("/BuyerDashboard")
public class BuyerDashboard extends HttpServlet {
    private static final int PAGE_SIZE = 9;    // 3×3 grid
    private final ModelDAO dao = new ModelDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        // 0) Require login
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            resp.sendRedirect(req.getContextPath() + "/Login");
            return;
        }
        User me = (User) session.getAttribute("user");
        int buyerId = me.getId();

        // 1) Read filters & page
        String search    = req.getParameter("search");
        String modelType = req.getParameter("modelType");
        String sortBy    = req.getParameter("sortBy");
        String ownedSearch     = req.getParameter("ownedSearch");
        String ownedCategory   = req.getParameter("ownedCategory");
        String purchasedFilter = req.getParameter("purchasedFilter");

        int currentPage = 1;
        try {
            String p = req.getParameter("page");
            if (p != null) currentPage = Math.max(1, Integer.parseInt(p));
        } catch (NumberFormatException ignored) {}

        try {
            // load dropdowns
            req.setAttribute("allCategories",   dao.findAllCategories());
            req.setAttribute("ownedCategories", dao.findOwnedCategories(buyerId));

            // 2) Fetch _all_ featured models (excludes purchased by this user)
            List<Model> allFeatured = dao.findFeaturedModels(
                buyerId, search, modelType, sortBy);

            // 3) Compute pagination
            int totalCount = allFeatured.size();
            int totalPages = (int)Math.ceil((double) totalCount / PAGE_SIZE);
            int startIndex = (currentPage - 1) * PAGE_SIZE;
            int endIndex   = Math.min(startIndex + PAGE_SIZE, totalCount);

            List<Model> pagedFeatured =
                allFeatured.subList(startIndex, endIndex);

            req.setAttribute("modelsList",  pagedFeatured);
            req.setAttribute("totalPages",  totalPages);
            req.setAttribute("currentPage", currentPage);

            // 4) Owned/purchased (no paging)
            req.setAttribute("purchasedList",
                dao.findPurchasedModels(
                    buyerId, ownedSearch, ownedCategory, purchasedFilter
                )
            );

            // 5) Keep filter values around
            req.setAttribute("search",    search);
            req.setAttribute("modelType", modelType);
            req.setAttribute("sortBy",    sortBy);
            req.setAttribute("ownedSearch",     ownedSearch);
            req.setAttribute("ownedCategory",   ownedCategory);
            req.setAttribute("purchasedFilter", purchasedFilter);

            // 6) Forward
            req.getRequestDispatcher(
              "/WEB-INF/pages/Buyer/BuyerDashboard.jsp"
            ).forward(req, resp);

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
