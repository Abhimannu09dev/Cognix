// src/main/java/com/cognix/util/SessionUtil.java
package com.cognix.util;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;

/**
 * Utility for storing/retrieving session attributes.
 */
public class SessionUtil {

    /** Store an attribute in session, creating one if needed. */
    public static void set(HttpServletRequest request, String name, Object value) {
        HttpSession session = request.getSession(true);
        session.setAttribute(name, value);
    }

    /** Retrieve an attribute from session, or null. */
    @SuppressWarnings("unchecked")
    public static <T> T get(HttpServletRequest request, String name) {
        HttpSession session = request.getSession(false);
        if (session == null) return null;
        return (T) session.getAttribute(name);
    }

    /** Remove a single attribute from session. */
    public static void remove(HttpServletRequest request, String name) {
        HttpSession session = request.getSession(false);
        if (session != null) {
            session.removeAttribute(name);
        }
    }

    /** Invalidate the entire session. */
    public static void invalidate(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session != null) {
            session.invalidate();
        }
    }
}
