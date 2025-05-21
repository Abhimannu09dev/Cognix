package com.cognix.controller;

import com.cognix.DAO.AdminPanelDAO;
import com.cognix.model.ReportData;
import com.cognix.model.User;
import com.cognix.model.Model;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.time.LocalDate;
import java.time.format.DateTimeParseException;


/**
 * @author - Krishna Singh
 */

@WebServlet("/AdminReport")
public class AdminReport extends HttpServlet {
    private final AdminPanelDAO dao = new AdminPanelDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        // parse user‐growth filters
        LocalDate userFrom = parseDateOrDefault(req.getParameter("userFrom"), LocalDate.now().minusDays(30));
        LocalDate userTo   = parseDateOrDefault(req.getParameter("userTo"),   LocalDate.now());
        String    userRole = req.getParameter("userRole");

        // parse model‐sales filters
        LocalDate modelFrom = parseDateOrDefault(req.getParameter("modelFrom"), LocalDate.now().minusDays(30));
        LocalDate modelTo   = parseDateOrDefault(req.getParameter("modelTo"),   LocalDate.now());
        String    modelSort = req.getParameter("modelSort");

        try {
            ReportData<Long> userReport  = dao.userGrowth(userFrom, userTo, userRole);
            ReportData<Long> modelReport = dao.modelSales(modelFrom, modelTo, modelSort);

            req.setAttribute("userReport",  userReport);
            req.setAttribute("modelReport", modelReport);

            req.getRequestDispatcher("/WEB-INF/pages/Admin/AdminReport.jsp")
               .forward(req, resp);

        } catch (Exception e) {
            throw new ServletException("Error loading reports", e);
        }
    }

    private LocalDate parseDateOrDefault(String s, LocalDate def) {
        if (s == null || s.isBlank()) return def;
        try {
            return LocalDate.parse(s);
        } catch (DateTimeParseException ex) {
            return def;
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        doGet(req, resp);
    }
}
