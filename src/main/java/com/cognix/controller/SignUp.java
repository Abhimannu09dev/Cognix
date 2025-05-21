package com.cognix.controller;

import com.cognix.DAO.UserDAO;
import com.cognix.model.User;
import com.cognix.util.PasswordUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet("/SignUp")
public class SignUp extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private UserDAO userDAO;

    @Override
    public void init() throws ServletException {
        super.init();
        userDAO = new UserDAO(); // Initialize UserDAO once
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.getRequestDispatcher("/WEB-INF/pages/Signup.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String fullName = request.getParameter("name");
        String username = request.getParameter("username");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String role = request.getParameter("role");

        if (fullName == null || username == null || email == null || password == null || role == null ||
            fullName.isEmpty() || username.isEmpty() || email.isEmpty() || password.isEmpty() || role.isEmpty()) {

            request.setAttribute("error", "All fields are required!");
            request.getRequestDispatcher("/WEB-INF/pages/Signup.jsp").forward(request, response);
            return;
        }

        User user = new User();
        user.setName(fullName);
        user.setUsername(username);
        user.setEmail(email);
        user.setPassword( PasswordUtil.hashPassword(password.toCharArray()) );
        user.setRole(role);
        user.setAbout("New user at Cognix.");

        boolean saved = userDAO.save(user);

        if (saved) {
            response.sendRedirect(request.getContextPath() + "/Login");
        } else {
            request.setAttribute("error", "Registration failed! Please try again.");
            request.getRequestDispatcher("/WEB-INF/pages/Signup.jsp").forward(request, response);
        }
    }
}
