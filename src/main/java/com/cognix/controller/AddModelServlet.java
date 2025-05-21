// src/main/java/com/cognix/controller/AddModelServlet.java
package com.cognix.controller;

import com.cognix.DAO.ModelDAO;
import com.cognix.model.Model;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;

@WebServlet("/AddModel")
@MultipartConfig
public class AddModelServlet extends HttpServlet {
    private final ModelDAO dao = new ModelDAO();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            resp.sendRedirect(req.getContextPath() + "/Login");
            return;
        }

        // 1) Populate Model from form
        Model m = new Model();
        m.setName(        req.getParameter("name"));
        m.setVersion(     req.getParameter("version"));
        m.setCategory(    req.getParameter("category"));
        m.setDocsUrl(     req.getParameter("docsUrl"));
        m.setGithubUrl(   req.getParameter("modelUrl"));
        m.setDescription( req.getParameter("description"));
        m.setPrice(       safeParseDouble(req.getParameter("price")));
        m.setPrecision(   safeParseDouble(req.getParameter("precision")));
        m.setRecall(      safeParseDouble(req.getParameter("recall")));
        m.setF1Score(     safeParseDouble(req.getParameter("f1Score")));
        m.setParameters(  safeParseLong(req.getParameter("parameters")));
        m.setInferenceTime(safeParseInt(req.getParameter("inferenceTime")));
        m.setSellerUserId((Integer) session.getAttribute("userId"));

        // 2) Handle the image upload into the deployed /uploads folder
        Part imagePart = req.getPart("image");
        String submitted = imagePart.getSubmittedFileName();
        String ext = "";
        int idx = submitted.lastIndexOf('.');
        if (idx > 0) ext = submitted.substring(idx);

        // real filesystem path to <webapp>/uploads
        String uploadDir = req.getServletContext().getRealPath("/uploads");
        File uploads = new File(uploadDir);
        if (!uploads.exists()) uploads.mkdirs();

        String filename = "model_" + System.currentTimeMillis() + ext;
        Path target = Path.of(uploadDir, filename);
        try (var in = imagePart.getInputStream()) {
            Files.copy(in, target);
        }

        // 3) store just the filename in the bean
        m.setImagePath(filename);

        // 4) Persist via DAO
        boolean added;
        try {
            added = dao.addModel(m);
        } catch (Exception e) {
            throw new ServletException("Error saving model", e);
        }

        // 5) Redirect back to seller page
        if (added) {
            resp.sendRedirect(req.getContextPath() + "/SellerModel?added=1");
        } else {
            req.setAttribute("error", "Could not add model; try again.");
            req.getRequestDispatcher("/WEB-INF/pages/Seller/SellerModel.jsp")
               .forward(req, resp);
        }
    }

    // ── Safe parsing helpers ──

    /** parse a double, default to 0.0 if null/blank/invalid */
    private double safeParseDouble(String s) {
        if (s == null || s.isBlank()) return 0.0;
        try { return Double.parseDouble(s); }
        catch (NumberFormatException e) { return 0.0; }
    }

    /** parse a long, default to 0 if null/blank/invalid */
    private long safeParseLong(String s) {
        if (s == null || s.isBlank()) return 0;
        try { return Long.parseLong(s); }
        catch (NumberFormatException e) { return 0; }
    }

    /** parse an int, default to 0 if null/blank/invalid */
    private int safeParseInt(String s) {
        if (s == null || s.isBlank()) return 0;
        try { return Integer.parseInt(s); }
        catch (NumberFormatException e) { return 0; }
    }
}
