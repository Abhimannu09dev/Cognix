// src/main/java/com/cognix/DAO/OrderDAO.java
package com.cognix.DAO;

import com.cognix.model.Order;
import java.sql.*;
import java.time.Duration;
import java.util.ArrayList;
import java.util.List;

public class OrderDAO {
    private Connection getConnection() throws SQLException {
        return DriverManager.getConnection(
          "jdbc:mysql://localhost:3307/CogniX", "root", ""
        );
    }

    /**
     * Fetches summary + filtered list of orders for a given seller.
     */
    public List<Order> findOrders(int sellerId,
                                  String search,
                                  String category,
                                  String orderAt) throws SQLException {
        StringBuilder sql = new StringBuilder(
          "SELECT o.OrderID, m.Name AS modelName, u.Username AS buyerUsername, "
        + "       m.Catagory AS category, o.OrderDate AS purchaseDate, o.Price "
        + "FROM OrdersReceived o "
        + "JOIN Models m ON o.ModelID = m.ModelID "
        + "JOIN User u   ON o.BuyerUserID = u.User_ID "
        + "WHERE m.SellerUserID = ?"
        );
        if (category != null && !category.isBlank()) {
            sql.append(" AND LOWER(m.Catagory)=LOWER(?)");
        }
        if (search != null && !search.isBlank()) {
            sql.append(" AND m.Name LIKE ?");
        }
        if (orderAt != null && !orderAt.isBlank()) {
            sql.append(" AND o.OrderDate >= ?");
        }
        sql.append(" ORDER BY o.OrderDate DESC");

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {

            int idx = 1;
            ps.setInt(idx++, sellerId);

            if (category != null && !category.isBlank()) {
                ps.setString(idx++, category);
            }
            if (search != null && !search.isBlank()) {
                ps.setString(idx++, "%" + search.trim() + "%");
            }
            if (orderAt != null && !orderAt.isBlank()) {
                long millisAgo;
                switch (orderAt) {
                  case "24h": millisAgo = Duration.ofHours(24).toMillis(); break;
                  case "7d":  millisAgo = Duration.ofDays(7).toMillis();   break;
                  case "30d": millisAgo = Duration.ofDays(30).toMillis();  break;
                  default:    millisAgo = 0;
                }
                ps.setTimestamp(idx++,
                  new Timestamp(System.currentTimeMillis() - millisAgo)
                );
            }

            List<Order> list = new ArrayList<>();
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Order o = new Order();
                    o.setOrderId(      rs.getInt("OrderID"));
                    o.setModelName(    rs.getString("modelName"));
                    o.setBuyerUsername(rs.getString("buyerUsername"));
                    o.setCategory(     rs.getString("category"));
                    o.setPurchaseDate( rs.getTimestamp("purchaseDate"));
                    o.setPrice(        rs.getDouble("Price"));
                    list.add(o);
                }
            }
            return list;
        }
    }

    /** Total orders count */
    public int getTotalOrders(int sellerId) throws SQLException {
        String sql = "SELECT COUNT(*) FROM OrdersReceived o "
                   + "JOIN Models m ON o.ModelID=m.ModelID "
                   + "WHERE m.SellerUserID=?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, sellerId);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? rs.getInt(1) : 0;
            }
        }
    }

    /** Total revenue */
    public double getTotalRevenue(int sellerId) throws SQLException {
        String sql = "SELECT COALESCE(SUM(o.Price),0) FROM OrdersReceived o "
                   + "JOIN Models m ON o.ModelID=m.ModelID "
                   + "WHERE m.SellerUserID=?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, sellerId);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? rs.getDouble(1) : 0.0;
            }
        }
    }

    /** Date of the latest order */
    public Date getLatestOrderDate(int sellerId) throws SQLException {
        String sql = "SELECT MAX(o.OrderDate) FROM OrdersReceived o "
                   + "JOIN Models m ON o.ModelID=m.ModelID "
                   + "WHERE m.SellerUserID=?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, sellerId);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? rs.getDate(1) : null;
            }
        }
    }
}
