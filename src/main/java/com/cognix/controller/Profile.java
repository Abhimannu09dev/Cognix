package com.cognix.controller;

import com.cognix.DAO.UserDAO;
import com.cognix.model.User;
import com.cognix.util.PasswordUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.File;
import java.io.IOException;
import java.sql.Date;
import java.time.LocalDate;


/**
 * @author - Krishna Singh
 */

@WebServlet("/Profile")
@MultipartConfig
public class Profile extends HttpServlet {
    private final UserDAO userDao = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            resp.sendRedirect(req.getContextPath() + "/Login");
            return;
        }
        req.setAttribute("profile", session.getAttribute("user"));
        req.setAttribute("role", session.getAttribute("role"));
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

        User user = (User) session.getAttribute("user");
        int userId = user.getId();

        String username = req.getParameter("username").trim();
        String name     = req.getParameter("name").trim();
        String email    = req.getParameter("email").trim();
        String about    = req.getParameter("about").trim();
        String dobStr   = req.getParameter("dob");
        String rawPw    = req.getParameter("password");

        // 1) Validate username uniqueness
        if (!user.getUsername().equals(username)
            && userDao.isUsernameTaken(username, userId)) {
            req.setAttribute("error", "That username is already taken.");
            doGet(req, resp);
            return;
        }

        // 2) Validate email uniqueness
        if (!user.getEmail().equals(email)
            && userDao.isEmailTaken(email, userId)) {
            req.setAttribute("error", "That email address is already in use.");
            doGet(req, resp);
            return;
        }

        // 3) Handle avatar upload
        Part avatarPart = req.getPart("avatar");
        String uploadDir = req.getServletContext().getRealPath("/uploads");
        File uploads     = new File(uploadDir);
        if (!uploads.exists()) uploads.mkdirs();

        String newAvatarPath = null;
        if (avatarPart != null && avatarPart.getSize() > 0) {
            String submitted = avatarPart.getSubmittedFileName();
            String ext       = submitted.substring(submitted.lastIndexOf('.'));
            String fname     = "avatar_" + System.currentTimeMillis() + ext;
            File dest        = new File(uploads, fname);
            avatarPart.write(dest.getAbsolutePath());
            newAvatarPath = "uploads/" + fname;
        }

        // 4) Parse DOB
        Date dob = null;
        if (dobStr != null && !dobStr.isBlank()) {
            LocalDate ld = LocalDate.parse(dobStr);
            dob = Date.valueOf(ld);
        }

        // 5) Apply updates
        user.setUsername(username);
        user.setName(name);
        user.setEmail(email);
        user.setAbout(about);
        user.setDob(dob);
        if (newAvatarPath != null) {
            user.setProfilePicture(newAvatarPath);
        }
        if (rawPw != null && !rawPw.isEmpty()) {
            user.setPassword(PasswordUtil.hashPassword(rawPw.toCharArray()));
        }

        // 6) Persist
        boolean ok = userDao.updateUser(user);
        if (ok) {
            session.setAttribute("user", user);
            // redirect to show the success toast
            resp.sendRedirect(req.getContextPath() + "/Profile?success=1");
        } else {
            req.setAttribute("error", "Failed to save changes. Please try again.");
            doGet(req, resp);
        }
    }
}
