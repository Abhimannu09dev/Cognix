package com.cognix.controller;

import com.cognix.DAO.ReportDAO;
import com.cognix.model.ReportData;
import com.cognix.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.YearMonth;
import java.time.format.DateTimeFormatter;

@WebServlet("/SellerReport")
public class SellerReport extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final DateTimeFormatter DF = DateTimeFormatter.ofPattern("yyyy-MM-dd");

    private final ReportDAO dao = new ReportDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        User user = (User) session.getAttribute("user");
        int sellerId = user.getId();

        try {
            // --- summary cards ---
            req.setAttribute("totalModelsListed",
                dao.getTotalModelsListed(sellerId));
            req.setAttribute("totalOrdersReceived",
                dao.getTotalOrdersReceived(sellerId));
            BigDecimal rev = dao.getTotalRevenueGenerated(sellerId);
            req.setAttribute("totalRevenue", rev);
            req.setAttribute("bestSellingModel",
                dao.getBestSellingModel(sellerId));

            // --- revenue filters ---
            String revMonth = req.getParameter("revenueMonth");
            String revFrom  = req.getParameter("revenueFrom");
            String revTo    = req.getParameter("revenueTo");
            String revSort  = req.getParameter("revenueSort");

            LocalDate fromDate, toDate;
            if (revMonth != null && !revMonth.isBlank()) {
                YearMonth ym = YearMonth.parse(revMonth);
                fromDate = ym.atDay(1);
                toDate   = ym.atEndOfMonth();
            } else {
                fromDate = (revFrom != null && !revFrom.isBlank())
                         ? LocalDate.parse(revFrom, DF)
                         : LocalDate.now().minusMonths(6);
                toDate   = (revTo   != null && !revTo.isBlank())
                         ? LocalDate.parse(revTo, DF)
                         : LocalDate.now();
            }

            ReportData<BigDecimal> revenueReport =
                dao.getRevenueOverTime(sellerId, fromDate, toDate, revSort);
            req.setAttribute("revenueReport", revenueReport);

            // --- model-sales filters ---
            String modelName    = req.getParameter("modelName");
            String fromDateParam= req.getParameter("fromDate");
            String toDateParam  = req.getParameter("toDate");
            String sortParam    = req.getParameter("sort");

            // 1) Defaults for name & sort
            if (modelName == null) {
                modelName = "";              // no filter
            }
            if (sortParam == null || sortParam.isBlank()) {
                sortParam = "most-sold";     // default sort
            }

            // 2) Date range: default to last 6 months
            LocalDate salesFrom = (fromDateParam != null && !fromDateParam.isBlank())
                                ? LocalDate.parse(fromDateParam, DF)
                                : LocalDate.now().minusMonths(6);
            LocalDate salesTo   = (toDateParam   != null && !toDateParam.isBlank())
                                ? LocalDate.parse(toDateParam, DF)
                                : LocalDate.now();

            // 3) Fetch report
            ReportData<Integer> soldReport =
                dao.getUnitsSoldPerModel(
                    sellerId,
                    salesFrom,
                    salesTo,
                    modelName,
                    sortParam
                );
            req.setAttribute("soldReport", soldReport);

            // forward to JSP
            req.getRequestDispatcher("/WEB-INF/pages/Seller/SellerReport.jsp")
               .forward(req, resp);

        } catch (Exception e) {
            throw new ServletException(e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        doGet(req, resp);
    }
}
