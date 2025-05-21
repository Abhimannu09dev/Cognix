// src/main/java/com/cognix/controller/ContactUs.java
package com.cognix.controller;

import com.cognix.DAO.MessageDAO;
import com.cognix.model.Message;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;

/**
 * @author - Utpala Khatri
 */

@WebServlet("/ContactUs")
public class ContactUs extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/WEB-INF/pages/ContactUs.jsp")
               .forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // gather form fields
        String name    = request.getParameter("name");
        String email   = request.getParameter("email");
        String subject = request.getParameter("subject");
        String body    = request.getParameter("body");

        // build our model
        Message msg = new Message();
        msg.setName(name);
        msg.setEmail(email);
        msg.setSubject(subject);
        msg.setBody(body);

        // attempt to pull a logged-in user ID
        HttpSession session = request.getSession(false);
        Integer uid = null;
        if (session != null) {
            // adjust this to whatever key you store the user’s ID under
            uid = (Integer) session.getAttribute("userId");
        }
        msg.setUserId(uid != null ? uid : 0);

        // save & report success/failure back to JSP
        try {
            new MessageDAO().save(msg);
            request.setAttribute("success", "Thanks! We’ve received your message.");
        } catch (SQLException e) {
            log("Error saving contact message", e);
            request.setAttribute("error", "Sorry, we were unable to save your message.");
        }

        request.getRequestDispatcher("/WEB-INF/pages/ContactUs.jsp")
               .forward(request, response);
    }
}
