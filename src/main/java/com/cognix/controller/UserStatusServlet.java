// src/main/java/com/cognix/controller/UserStatusServlet.java
package com.cognix.controller;

import com.cognix.DAO.AdminPanelDAO;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;


/**
 * @author - Krishna Singh
 */

@WebServlet("/UserStatus")
public class UserStatusServlet extends HttpServlet {
    private final AdminPanelDAO dao = new AdminPanelDAO();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String idParam = req.getParameter("id");
        String action  = req.getParameter("action");  // “block” or “unblock”

        try {
            int userId = Integer.parseInt(idParam);
            if ("unblock".equalsIgnoreCase(action)) {
                dao.unblockUser(userId);
            } else {
                dao.blockUser(userId);
            }
        } catch (Exception e) {
            throw new ServletException("Unable to change user status", e);
        }

        // Always redirect back to where the request came from:
        String referer = req.getHeader("Referer");
        if (referer != null) {
            resp.sendRedirect(referer);
        } else {
            // fallback to Users list preserving filters
            resp.sendRedirect(req.getContextPath() + "/Users" + buildQueryString(req));
        }
    }

    /** Preserve ?q=&role=&sort=&status= on fallback redirect */
    private String buildQueryString(HttpServletRequest req) {
        StringBuilder qs = new StringBuilder("?");
        for (String p : new String[]{"q", "role", "status", "sort"}) {
            String v = req.getParameter(p);
            if (v != null && !v.isBlank()) {
                qs.append(p).append("=").append(v).append("&");
            }
        }
        // remove trailing &
        if (qs.length() > 1) {
            qs.setLength(qs.length() - 1);
            return qs.toString();
        }
        return "";
    }
}
