package com.cognix.DAO;

import com.cognix.config.DbConfig;
import com.cognix.model.Model;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class CartDAO {

    public List<Model> findCartItems(int buyerUserId) throws SQLException {
        String sql =
          "SELECT m.ModelID AS modelId, m.Name AS name, m.Catagory AS category, " +
          "       m.Price AS price, m.Image_Path AS imagePath, " +
          "       u.Username AS sellerUsername " +
          "  FROM CartItems c " +
          "  JOIN Models    m ON c.ModelID = m.ModelID " +
          "  JOIN User      u ON m.SellerUserID = u.User_ID " +
          " WHERE c.BuyerUserID = ?";
        List<Model> items = new ArrayList<>();
        try (Connection conn = DbConfig.getDbConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, buyerUserId);
            try (ResultSet rs = ps.executeQuery()) {
                int sn = 1;
                while (rs.next()) {
                    Model m = new Model();
                    m.setSn(sn++);
                    m.setModelId(rs.getInt("modelId"));
                    m.setName(rs.getString("name"));
                    m.setCategory(rs.getString("category"));
                    m.setPrice(rs.getDouble("price"));
                    m.setImagePath(rs.getString("imagePath"));
                    m.setSellerUsername(rs.getString("sellerUsername"));
                    items.add(m);
                }
            }
        }
        return items;
    }
    
    
    /**
     * Attempts to add the given model to the buyer's cart.
     * @return true if inserted, false if already in cart.
     */
    public boolean addToCart(int buyerUserId, int modelId, double price) throws SQLException {
        String existsSql = 
            "SELECT 1 FROM CartItems WHERE BuyerUserID = ? AND ModelID = ?";
        try (Connection conn = DbConfig.getDbConnection();
             PreparedStatement psEx = conn.prepareStatement(existsSql)) {
            psEx.setInt(1, buyerUserId);
            psEx.setInt(2, modelId);
            try (ResultSet rs = psEx.executeQuery()) {
                if (rs.next()) {
                    return false;  // already in cart
                }
            }
        }

        String insertSql = 
            "INSERT INTO CartItems (BuyerUserID, ModelID, Price) VALUES (?,?,?)";
        try (Connection conn = DbConfig.getDbConnection();
             PreparedStatement psIns = conn.prepareStatement(insertSql)) {
            psIns.setInt(1, buyerUserId);
            psIns.setInt(2, modelId);
            psIns.setDouble(3, price);
            psIns.executeUpdate();
            return true;
        }
    }

    public void removeFromCart(int buyerUserId, int modelId) throws SQLException {
        String sql = "DELETE FROM CartItems WHERE BuyerUserID = ? AND ModelID = ?";
        try (Connection conn = DbConfig.getDbConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, buyerUserId);
            ps.setInt(2, modelId);
            ps.executeUpdate();
        }
    }

    public void checkout(int buyerUserId) throws SQLException {
        String insertSql =
          "INSERT INTO Purchases (BuyerUserID, ModelID, PurchaseDate, Price) " +
          "SELECT c.BuyerUserID, c.ModelID, NOW(), m.Price " +
          "  FROM CartItems c " +
          "  JOIN Models    m ON c.ModelID = m.ModelID " +
          " WHERE c.BuyerUserID = ?";
        String deleteSql = "DELETE FROM CartItems WHERE BuyerUserID = ?";

        try (Connection conn = DbConfig.getDbConnection()) {
            conn.setAutoCommit(false);
            try (PreparedStatement psIns = conn.prepareStatement(insertSql);
                 PreparedStatement psDel = conn.prepareStatement(deleteSql)) {
                psIns.setInt(1, buyerUserId);
                psIns.executeUpdate();
                psDel.setInt(1, buyerUserId);
                psDel.executeUpdate();
                conn.commit();
            } catch (SQLException e) {
                conn.rollback();
                throw e;
            } finally {
                conn.setAutoCommit(true);
            }
        }
    }
}
