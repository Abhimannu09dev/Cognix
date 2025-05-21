package com.cognix.controller;

import com.cognix.DAO.MessageDAO;
import com.cognix.model.Message;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/AdminMessages")
public class AdminMessage extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
        throws ServletException, IOException {

        String q    = req.getParameter("q");
        String sort = req.getParameter("sort");

        try {
            MessageDAO dao = new MessageDAO();
            List<Message> msgs = dao.findMessages(q, sort);

            int total   = msgs.size();
            int read    = (int) msgs.stream()
                                     .filter(m -> "read".equalsIgnoreCase(m.getStatus()))
                                     .count();
            int unread  = total - read;

            req.setAttribute("messagesList", msgs);
            req.setAttribute("totalMessages", total);
            req.setAttribute("readMessages",   read);
            req.setAttribute("unreadMessages", unread);
        } catch (Exception e) {
            throw new ServletException("Unable to load messages", e);
        }

        // forward back to your JSP under WEB-INF
        req.getRequestDispatcher("/WEB-INF/pages/Admin/AdminMessages.jsp")
           .forward(req, resp);
    }

    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
        throws ServletException, IOException {
        // handle "Mark Read" button
        String id = req.getParameter("markChecked");
        if (id != null) {
            try {
                new MessageDAO().markChecked(Integer.parseInt(id));
            } catch (Exception e) {
                throw new ServletException("Unable to mark message", e);
            }
        }
        // reload the list
        doGet(req, resp);
    }
}
