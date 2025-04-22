package com.cognix.controller;

import com.cognix.DAO.AdminDAO;
import com.cognix.DAO.UserDAO;
import com.cognix.model.Admin;
import com.cognix.model.User;
import com.cognix.util.CookieUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;


public class Login extends HttpServlet {
    private final AdminDAO adminDao = new AdminDAO();
    private final UserDAO  userDao  = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.getRequestDispatcher("/WEB-INF/pages/Login.jsp")
           .forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String email    = req.getParameter("email");
        String password = req.getParameter("password");
        boolean remember= "on".equals(req.getParameter("rememberMe"));
        HttpSession session = req.getSession();

        try {
            // 1) Admin
            Admin admin = adminDao.findByEmailAndPassword(email, password);
            if (admin != null) {
                session.setAttribute("user", admin);
                session.setAttribute("role", "admin");

                if (remember) {
                    CookieUtil.addCookie(resp,
                                         "rememberedId",
                                         String.valueOf(admin.getAdminId()),
                                         7 * 24 * 60 * 60);
                }
                else {
                    CookieUtil.deleteCookie(resp, "rememberedId");
                }

                resp.sendRedirect(req.getContextPath()
                                 + "/AdminDash?currentPage=dashboard");
                return;
            }

            // 2) Regular user
            User user = userDao.findByEmailAndPassword(email, password);
            if (user != null) {
                session.setAttribute("user", user);
                session.setAttribute("role", user.getRole());

                if (remember) {
                    CookieUtil.addCookie(resp,
                                         "rememberedId",
                                         String.valueOf(user.getId()),
                                         7 * 24 * 60 * 60);
                }
                else {
                    CookieUtil.deleteCookie(resp, "rememberedId");
                }

                String dest = "seller".equalsIgnoreCase(user.getRole())
                              ? "/HomeSeller?currentPage=dashboard"
                              : "/BUyerDashboard?currentPage=dashboard";
                resp.sendRedirect(req.getContextPath() + dest);
                return;
            }

            // 3) no match
            req.setAttribute("error",
                "Invalid email or password. Please try again.");
            req.getRequestDispatcher("/WEB-INF/pages/Login.jsp")
               .forward(req, resp);

        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("error",
                "Something went wrong. Please try again later.");
            req.getRequestDispatcher("/WEB-INF/pages/Login.jsp")
               .forward(req, resp);
        }
    }
}
