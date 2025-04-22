package com.cognix.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;
import com.cognix.DAO.ModelDAO;
import com.cognix.model.Model;

@WebServlet("/SellerModel")
public class SellerModel extends HttpServlet {
    private static final long serialVersionUID = 1L;

    public SellerModel() {
        super();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            ModelDAO modelDAO = new ModelDAO();
            List<Model> modelsList = modelDAO.getAllModels();

            int totalSales = 0;
            double totalRevenue = 0;
            String mostPopularModelName = "None";
            int maxSales = 0; // Initially 0 not -1

            for (Model m : modelsList) {
                totalSales += (m.getSales() != 0) ? m.getSales() : 0;
                totalRevenue += (m.getRevenue() != 0) ? m.getRevenue() : 0;

                if (m.getSales() > maxSales) {
                    maxSales = m.getSales();
                    mostPopularModelName = (m.getName() != null && !m.getName().isEmpty()) ? m.getName() : "None";
                }
            }

            // Important: if maxSales is still 0, no model is popular
            if (maxSales == 0) {
                mostPopularModelName = "None";
            }

            request.setAttribute("modelsList", modelsList);
            request.setAttribute("totalSales", totalSales);
            request.setAttribute("totalRevenue", totalRevenue);
            request.setAttribute("mostPopularModelName", mostPopularModelName);

            request.getRequestDispatcher("/WEB-INF/pages/Seller/SellerModel.jsp")
                    .forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Something went wrong fetching models.");
        }
    }

    
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doGet(request, response);
    }
}
