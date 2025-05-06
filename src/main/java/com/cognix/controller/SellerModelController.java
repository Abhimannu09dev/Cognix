package com.Cognix_m.controller;

import com.Cognix_m.DAO.ModelDAO;
import com.Cognix_m.config.DBconfig;
import com.Cognix_m.model.Model;


import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

/**
 * Servlet implementation class SellerModelController
 */
@WebServlet(asyncSupported = true, urlPatterns = { "/SellerModel" })
public class SellerModelController extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    private ModelDAO modelDAO;
    
    @Override
    public void init() throws ServletException {
        super.init();
        modelDAO = new ModelDAO(); // Initialize ModelDAO once
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userID") == null) {
            // If not logged in, redirect to login
            response.sendRedirect("Login.jsp");
            return;
        }

        // Decide which page to forward to
        if ("addModel".equals(action)) {
            request.getRequestDispatcher("WEB-INF/pages/seller/AddModel.jsp").forward(request, response);
        } else {
            request.getRequestDispatcher("WEB-INF/pages/seller/SellerModel.jsp").forward(request, response);
        }
    }



    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Get model details from the form
        String modelName = request.getParameter("name");
        String category = request.getParameter("category");
        String price = request.getParameter("price");
        String description = request.getParameter("description");
        String version = request.getParameter("version");
       
        // Create model and set details
        Model model = new Model();
        model.setName(modelName);
        model.setCategory(category);
        model.setPrice(price);
        model.setDescription(description);
        model.setVersion(version);
        model.setListedDate(new java.sql.Date(System.currentTimeMillis())); 

        // Save model using ModelDAO
        boolean saved = modelDAO.save(model);

        if (saved) {
            response.sendRedirect(request.getContextPath() + "/SellerModel");
        } else {
            request.setAttribute("error", "Entry failed! Please try again.");
            request.getRequestDispatcher("/WEB-INF/pages/seller/SellerModel.jsp").forward(request, response);
        }
    }

}
