// src/main/java/com/cognix/controller/EditModelServlet.java
package com.cognix.controller;

import com.cognix.DAO.ModelDAO;
import com.cognix.model.Model;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.*;
import java.nio.file.Paths;

/**
 * @author - Abhimannu Singh Kunwar
 */

@WebServlet("/EditModel")
@MultipartConfig
public class EditModelServlet extends HttpServlet {
    private final ModelDAO dao = new ModelDAO();

    @Override
    protected void doPost(HttpServletRequest req,
                          HttpServletResponse resp)
            throws ServletException, IOException {
        // 1) parse all form fields
        int modelId       = Integer.parseInt(req.getParameter("modelId"));
        String name       = req.getParameter("name");
        String version    = req.getParameter("version");
        String category   = req.getParameter("category");
        String docsUrl    = req.getParameter("docsUrl");
        String githubUrl  = req.getParameter("modelUrl");
        String desc       = req.getParameter("description");
        double price      = parseDouble(req.getParameter("price"));
        double accuracy   = parseDouble(req.getParameter("accuracy"));
        double precision  = parseDouble(req.getParameter("precision"));
        double recall     = parseDouble(req.getParameter("recall"));
        double f1Score    = parseDouble(req.getParameter("f1Score"));
        long   params     = parseLong(req.getParameter("parameters"));
        int    inferTime  = (int) parseLong(req.getParameter("inferenceTime"));

        // 2) start with the old image filename
        String imagePath = req.getParameter("existingImagePath");

        // 3) if user uploaded a new file, save it to /uploads
        Part imgPart = req.getPart("image");
        if (imgPart != null && imgPart.getSize() > 0) {
            // where Tomcat thinks /uploads is:
            String uploadDir = req.getServletContext().getRealPath("/uploads");
            System.out.println(">>> EditModelServlet: uploadDir=" + uploadDir);

            File uploads = new File(uploadDir);
            if (!uploads.exists() && !uploads.mkdirs()) {
                throw new ServletException("Could not create uploads dir: " + uploadDir);
            }

            // unique filename
            String fn = System.currentTimeMillis() + "_" +
                        Paths.get(imgPart.getSubmittedFileName()).getFileName();
            File dest = new File(uploads, fn);
            System.out.println(">>> Writing new image to: " + dest.getAbsolutePath());

            // manual copy
            try (InputStream in = imgPart.getInputStream();
                 OutputStream out = new FileOutputStream(dest)) {
                byte[] buffer = new byte[4096];
                int read;
                while ((read = in.read(buffer)) != -1) {
                    out.write(buffer, 0, read);
                }
            }

            // store just the filename; JSP will prefix /uploads/
            imagePath = fn;
        }

        // 4) build your Model bean
        Model m = new Model();
        m.setModelId(modelId);
        m.setName(name);
        m.setVersion(version);
        m.setCategory(category);
        m.setDocsUrl(docsUrl);
        m.setGithubUrl(githubUrl);
        m.setDescription(desc);
        m.setImagePath(imagePath);
        m.setPrice(price);
        m.setAccuracy(accuracy);
        m.setPrecision(precision);
        m.setRecall(recall);
        m.setF1Score(f1Score);
        m.setParameters(params);
        m.setInferenceTime(inferTime);

        // 5) persist and redirect
        try {
            if (!dao.updateModel(m)) {
                throw new ServletException("DAO.updateModel returned false");
            }
            resp.sendRedirect(req.getContextPath() + "/SellerModel");
        } catch (Exception e) {
            throw new ServletException("Error updating model", e);
        }
    }

    private double parseDouble(String s) {
        try { return Double.parseDouble(s); }
        catch (Exception e) { return 0; }
    }

    private long parseLong(String s) {
        try { return Long.parseLong(s); }
        catch (Exception e) { return 0; }
    }
}
