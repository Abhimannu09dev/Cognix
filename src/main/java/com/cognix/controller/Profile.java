package com.cognix.controller;

import com.cognix.DAO.AdminDAO;
import com.cognix.DAO.UserDAO;
import com.cognix.model.Admin;
import com.cognix.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;

import java.io.File;
import java.io.IOException;

@WebServlet("/Profile")
@MultipartConfig
public class Profile extends HttpServlet {
    private final UserDAO userDao   = new UserDAO();
    private final AdminDAO adminDao = new AdminDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        // if no user in session, redirect to login
        if (session == null || session.getAttribute("user") == null) {
            resp.sendRedirect(req.getContextPath() + "/Login");
            return;
        }

        // always pull the logged‑in object from "user" + its "role"
        Object profile = session.getAttribute("user");
        String  role    = (String) session.getAttribute("role");

        req.setAttribute("profile", profile);
        req.setAttribute("role", role);
        req.getRequestDispatcher("/WEB-INF/pages/Profile.jsp")
           .forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            resp.sendRedirect(req.getContextPath() + "/Login");
            return;
        }

        String role    = (String) session.getAttribute("role");
        Part   filePart = req.getPart("avatar");
        String ctx      = req.getServletContext().getRealPath("/");

        if ("admin".equals(role)) {
            // update Admin properties
            Admin admin = (Admin) session.getAttribute("user");
            admin.setUsername(req.getParameter("username"));
            admin.setName(req.getParameter("name"));
            admin.setEmail(req.getParameter("email"));
            admin.setAbout(req.getParameter("about"));

            String dob = req.getParameter("dob");
            if (dob != null && !dob.isEmpty()) {
                admin.setDob(java.sql.Date.valueOf(dob));
            }
            String pw = req.getParameter("password");
            if (pw != null && !pw.isEmpty()) {
                admin.setPassword(pw);
            }

            if (filePart != null && filePart.getSize() > 0) {
                String fn = System.currentTimeMillis() + "_" + filePart.getSubmittedFileName();
                String up = ctx + "uploads" + File.separator + fn;
                new File(up).getParentFile().mkdirs();
                filePart.write(up);
                admin.setProfilePicture("uploads/" + fn);
            }

            adminDao.updateAdmin(admin);
            session.setAttribute("user", admin);

        } else {
            // update Buyer or Seller properties
            User user = (User) session.getAttribute("user");
            user.setUsername(req.getParameter("username"));
            user.setName(req.getParameter("name"));
            user.setEmail(req.getParameter("email"));
            user.setAbout(req.getParameter("about"));

            String dob = req.getParameter("dob");
            if (dob != null && !dob.isEmpty()) {
                user.setDob(java.sql.Date.valueOf(dob));
            }
            String pw = req.getParameter("password");
            if (pw != null && !pw.isEmpty()) {
                user.setPassword(pw);
            }

            if (filePart != null && filePart.getSize() > 0) {
                String fn = System.currentTimeMillis() + "_" + filePart.getSubmittedFileName();
                String up = ctx + "uploads" + File.separator + fn;
                new File(up).getParentFile().mkdirs();
                filePart.write(up);
                user.setProfilePicture("uploads/" + fn);
            }

            userDao.updateUser(user);
            session.setAttribute("user", user);
        }

        // redirect back to GET with a success flag
        resp.sendRedirect(req.getContextPath() + "/Profile?success=1");
    }
}
