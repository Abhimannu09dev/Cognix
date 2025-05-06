// src/main/java/com/cognix/DAO/ModelDAO.java
package com.cognix.DAO;

import com.cognix.model.Model;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ModelDAO {

    private Connection getConnection() throws SQLException {
        String url  = "jdbc:mysql://localhost:3307/CogniX";
        String user = "root";
        String pass = "";
        return DriverManager.getConnection(url, user, pass);
    }

    /** 0) all distinct categories for the “Featured” filter */
    public List<String> findAllCategories() throws SQLException {
        String sql = "SELECT DISTINCT Catagory FROM Models ORDER BY Catagory";
        List<String> cats = new ArrayList<>();
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                cats.add(rs.getString("Catagory"));
            }
        }
        return cats;
    }

    /** 1) categories this buyer already owns */
    public List<String> findOwnedCategories(int buyerUserId) throws SQLException {
        String sql =
            "SELECT DISTINCT m.Catagory " +
            "  FROM Purchases p " +
            "  JOIN Models    m ON p.ModelID = m.ModelID " +
            " WHERE p.BuyerUserID = ? " +
            " ORDER BY m.Catagory";
        List<String> cats = new ArrayList<>();
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, buyerUserId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    cats.add(rs.getString("Catagory"));
                }
            }
        }
        return cats;
    }

    /** 2) Featured Models—but exclude those already purchased by this buyer */
    public List<Model> findFeaturedModels(int buyerUserId,
                                          String search,
                                          String modelType,
                                          String sortBy) throws SQLException {
        List<Model> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
            "SELECT m.ModelID, m.Name, m.Catagory, m.ListedDate, m.Price, m.Image_Path AS imagePath, " +
            "       u.Username AS sellerUsername " +
            "  FROM Models m " +
            "  JOIN User   u ON m.SellerUserID = u.User_ID " +
            " WHERE NOT EXISTS (" +
            "     SELECT 1 FROM Purchases p " +
            "      WHERE p.ModelID = m.ModelID AND p.BuyerUserID = ?" +
            " )"
        );

        if (search != null && !search.isBlank()) {
            sql.append(" AND m.Name LIKE ?");
        }
        if (modelType != null && !modelType.isBlank()) {
            sql.append(" AND LOWER(m.Catagory)=?");
        }
        switch (sortBy == null ? "" : sortBy) {
            case "priceAsc":  sql.append(" ORDER BY m.Price   ASC");   break;
            case "priceDesc": sql.append(" ORDER BY m.Price   DESC");  break;
            case "dateDesc":  sql.append(" ORDER BY m.ListedDate DESC");break;
            default:          sql.append(" ORDER BY m.ModelID  ASC");
        }

        try (Connection conn = getConnection();
             PreparedStatement pst = conn.prepareStatement(sql.toString())) {

            int idx = 1;
            pst.setInt(idx++, buyerUserId);

            if (search != null && !search.isBlank()) {
                pst.setString(idx++, "%" + search.trim() + "%");
            }
            if (modelType != null && !modelType.isBlank()) {
                pst.setString(idx++, modelType.toLowerCase());
            }

            try (ResultSet rs = pst.executeQuery()) {
                int sn = 1;
                while (rs.next()) {
                    Model m = new Model();
                    m.setSn(sn++);
                    m.setModelId(rs.getInt("ModelID"));
                    m.setName(rs.getString("Name"));
                    m.setCategory(rs.getString("Catagory"));
                    m.setListedDate(rs.getDate("ListedDate"));
                    m.setPrice(rs.getDouble("Price"));
                    m.setImagePath(rs.getString("imagePath"));
                    m.setSellerUsername(rs.getString("sellerUsername"));
                    list.add(m);
                }
            }
        }
        return list;
    }

    /** 3) Models Owned */
    public List<Model> findPurchasedModels(int buyerUserId,
                                           String search,
                                           String category,
                                           String purchasedFilter) throws SQLException {
        List<Model> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
            "SELECT p.PurchaseDate    AS purchaseDate, " +
            "       m.ModelID         AS modelId,      " +
            "       m.Name            AS name,         " +
            "       m.Catagory        AS category,     " +
            "       m.ListedDate      AS listedDate,   " +
            "       m.Price           AS price,        " +
            "       m.Image_Path      AS imagePath,    " +
            "       u.Username        AS sellerUsername " +
            "  FROM Purchases p " +
            "  JOIN Models m ON p.ModelID = m.ModelID " +
            "  JOIN User   u ON m.SellerUserID = u.User_ID " +
            " WHERE p.BuyerUserID = ?"
        );

        if (search != null && !search.isBlank()) {
            sql.append(" AND m.Name LIKE ?");
        }
        if (category != null && !category.isBlank()) {
            sql.append(" AND LOWER(m.Catagory)=?");
        }
        if ("7d".equals(purchasedFilter)) {
            sql.append(" AND p.PurchaseDate >= DATE_SUB(CURDATE(), INTERVAL 7 DAY)");
        } else if ("30d".equals(purchasedFilter)) {
            sql.append(" AND p.PurchaseDate >= DATE_SUB(CURDATE(), INTERVAL 30 DAY)");
        } else if ("365d".equals(purchasedFilter)) {
            sql.append(" AND p.PurchaseDate >= DATE_SUB(CURDATE(), INTERVAL 1 YEAR)");
        }
        sql.append(" ORDER BY p.PurchaseDate DESC");

        try (Connection conn = getConnection();
             PreparedStatement pst = conn.prepareStatement(sql.toString())) {
            int idx = 1;
            pst.setInt(idx++, buyerUserId);
            if (search   != null && !search.isBlank())   pst.setString(idx++, "%" + search.trim() + "%");
            if (category != null && !category.isBlank()) pst.setString(idx++, category.toLowerCase());

            try (ResultSet rs = pst.executeQuery()) {
                int sn = 1;
                while (rs.next()) {
                    Model m = new Model();
                    m.setSn(sn++);
                    m.setModelId(rs.getInt("modelId"));
                    m.setName(rs.getString("name"));
                    m.setCategory(rs.getString("category"));
                    m.setListedDate(rs.getDate("listedDate"));
                    m.setPrice(rs.getDouble("price"));
                    m.setImagePath(rs.getString("imagePath"));
                    m.setSellerUsername(rs.getString("sellerUsername"));
                    m.setPurchaseDate(rs.getDate("purchaseDate"));
                    list.add(m);
                }
            }
        }
        return list;
    }
    
    
    /**
     * 4) Lookup a single model by its ID.
     */
    public Model findById(int modelId) throws SQLException {
        String sql =
          "SELECT m.ModelID, m.Name, m.Catagory, m.ListedDate, m.Price, " +
          "       m.Image_Path AS imagePath, " +
          "       u.Username  AS sellerUsername " +
          "  FROM Models m " +
          "  JOIN User   u ON m.SellerUserID = u.User_ID " +
          " WHERE m.ModelID = ?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, modelId);
            try (ResultSet rs = ps.executeQuery()) {
                if (!rs.next()) return null;
                Model m = new Model();
                m.setModelId(      rs.getInt("ModelID"));
                m.setName(         rs.getString("Name"));
                m.setCategory(     rs.getString("Catagory"));
                m.setListedDate(   rs.getDate("ListedDate"));
                m.setPrice(        rs.getDouble("Price"));
                m.setImagePath(    rs.getString("imagePath"));
                m.setSellerUsername(rs.getString("sellerUsername"));
                return m;
            }
        }
    }

    
    
}
