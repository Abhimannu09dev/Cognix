// src/main/java/com/cognix/controller/Login.java
package com.cognix.controller;

import com.cognix.DAO.AdminDAO;
import com.cognix.DAO.UserDAO;
import com.cognix.model.Admin;
import com.cognix.model.User;
import com.cognix.util.CookieUtil;
import com.cognix.util.PasswordUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

/**
 * @author - Utpala Khatri
 */

@WebServlet(name="Login", urlPatterns={"/Login"})
public class Login extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private final AdminDAO adminDao = new AdminDAO();
    private final UserDAO  userDao  = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        // Render the login page
        req.getRequestDispatcher("/WEB-INF/pages/Login.jsp")
           .forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String email     = req.getParameter("email");
        String password  = req.getParameter("password");
        boolean remember = "on".equals(req.getParameter("remember-me"));
        HttpSession session = req.getSession(true);

        // 1) Try admin login first
        Admin admin = adminDao.findByEmail(email);
        if (admin != null) {
            String stored = admin.getPassword();
            // Migrate raw‐text to bcrypt if necessary
            if (!stored.startsWith("$2a$") && password.equals(stored)) {
                String bcrypt = PasswordUtil.hashPassword(password.toCharArray());
                admin.setPassword(bcrypt);
                adminDao.updateAdmin(admin);
                stored = bcrypt;
            }
            // Verify
            if (PasswordUtil.verifyPassword(password.toCharArray(), stored)) {
                session.setAttribute("user",   admin);
                session.setAttribute("role",   "admin");
                // ← new session key for your servlet to read
                session.setAttribute("userId", admin.getAdminId());

                if (remember) {
                    CookieUtil.addCookie(resp, "rememberedId",
                                         String.valueOf(admin.getAdminId()),
                                         7*24*3600);
                } else {
                    CookieUtil.deleteCookie(resp, "rememberedId");
                }
                resp.sendRedirect(req.getContextPath()
                              + "/AdminDash?currentPage=dashboard");
                return;
            }
        }

        // 2) Then regular user login
        User user = userDao.findByEmail(email);
        if (user != null 
         && PasswordUtil.verifyPassword(password.toCharArray(), user.getPassword())) {

            // Blocked?
            if ("blocked".equalsIgnoreCase(user.getStatus())) {
                req.setAttribute("blocked", true);
                req.getRequestDispatcher("/WEB-INF/pages/Login.jsp")
                   .forward(req, resp);
                return;
            }

            // Proceed
            session.setAttribute("user",   user);
            session.setAttribute("role",   user.getRole());
            // ← new session key for your servlet to read
            session.setAttribute("userId", user.getId());

            if (remember) {
                CookieUtil.addCookie(resp, "rememberedId",
                                     String.valueOf(user.getId()),
                                     7*24*3600);
            } else {
                CookieUtil.deleteCookie(resp, "rememberedId");
            }

            String dest = "seller".equalsIgnoreCase(user.getRole())
                          ? "/HomeSeller?currentPage=dashboard"
                          : "/BuyerDashboard?currentPage=dashboard";
            resp.sendRedirect(req.getContextPath() + dest);
            return;
        }

        // 3) Login failed
        req.setAttribute("error", "Invalid email or password. Please try again.");
        req.getRequestDispatcher("/WEB-INF/pages/Login.jsp")
           .forward(req, resp);
    }
}
