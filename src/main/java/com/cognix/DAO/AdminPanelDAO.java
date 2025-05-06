// src/main/java/com/cognix/DAO/AdminPanelDAO.java
package com.cognix.DAO;

import com.cognix.model.Model;
import com.cognix.model.User;

import java.sql.*;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;
import com.cognix.model.ReportData;


public class AdminPanelDAO {

    private Connection getConnection() throws SQLException {
        String url  = "jdbc:mysql://localhost:3307/CogniX";
        String user = "root", pass = "";
        return DriverManager.getConnection(url, user, pass);
    }
    
 // src/main/java/com/cognix/DAO/AdminPanelDAO.java
    public List<User> findNewUsers(String userSearch,
                                   String roleFilter,
                                   String statusFilter,
                                   String sortUsers) throws SQLException {
        List<User> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
            "SELECT User_ID AS id, Username AS username, Name AS fullName, " +
            "       Created_At AS createdAt, Role AS role, Email AS email, Status AS status " +
            "  FROM User WHERE 1=1"
        );

        if (userSearch != null && !userSearch.isBlank()) {
            sql.append(" AND Username LIKE ?");
        }
        if (roleFilter != null && !roleFilter.isBlank()) {
            sql.append(" AND Role = ?");
        }
        if ("blocked".equalsIgnoreCase(statusFilter)) {
            sql.append(" AND Status = 'blocked'");
        } else if ("unblocked".equalsIgnoreCase(statusFilter)) {
            sql.append(" AND (Status <> 'blocked' OR Status IS NULL)");
        }

        // sort
        if ("date-asc".equals(sortUsers)) {
          sql.append(" ORDER BY Created_At ASC");
        } else {
          sql.append(" ORDER BY Created_At DESC");
        }

        try (Connection c = getConnection();
             PreparedStatement p = c.prepareStatement(sql.toString())) {
          int idx = 1;
          if (userSearch != null && !userSearch.isBlank()) {
            p.setString(idx++, "%" + userSearch.trim() + "%");
          }
          if (roleFilter != null && !roleFilter.isBlank()) {
            p.setString(idx++, roleFilter);
          }
          try (ResultSet rs = p.executeQuery()) {
            while (rs.next()) {
              User u = new User();
              u.setId(rs.getInt("id"));
              u.setUsername(rs.getString("username"));
              u.setName(rs.getString("fullName"));
              u.setCreatedAt(rs.getTimestamp("createdAt"));
              u.setRole(rs.getString("role"));
              u.setEmail(rs.getString("email"));
              u.setStatus(rs.getString("status"));
              list.add(u);
            }
          }
        }
        return list;
    }


    /** Fetch “Top Models” applying optional search, category & sort. */
    public List<Model> findTopModels(String modelSearch,
                                     String categoryFilter,
                                     String sortModels) throws SQLException {
        List<Model> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
            "SELECT m.ModelID       AS id,         " +
            "       m.Name          AS name,       " +
            "       m.Catagory      AS category,   " +
            "       m.Price         AS price,      " +
            "       m.ListedDate    AS listedDate, " +
            "       u.Username      AS sellerUsername, " +
            "       COUNT(o.OrderID) AS sales       " +
            "  FROM Models m                   " +
            "  JOIN User u ON m.SellerUserID = u.User_ID  " +
            "  LEFT JOIN OrdersReceived o ON m.ModelID = o.ModelID " +
            " WHERE 1=1                     "
        );

        if (modelSearch != null && !modelSearch.isBlank()) {
            sql.append(" AND m.Name LIKE ?");
        }
        if (categoryFilter != null && !categoryFilter.isBlank()) {
            sql.append(" AND LOWER(m.Catagory)=?");
        }

        sql.append(
            " GROUP BY m.ModelID, m.Name, m.Catagory, m.Price, m.ListedDate, u.Username"
        );

        switch (sortModels == null ? "" : sortModels) {
            case "sales-asc":  sql.append(" ORDER BY sales ASC");      break;
            case "date-asc":   sql.append(" ORDER BY m.ListedDate ASC"); break;
            case "date-desc":  sql.append(" ORDER BY m.ListedDate DESC"); break;
            case "sales-desc":
            default:           sql.append(" ORDER BY sales DESC");
        }

        try (Connection conn = getConnection();
             PreparedStatement pst = conn.prepareStatement(sql.toString())) {

            int idx = 1;
            if (modelSearch != null && !modelSearch.isBlank()) {
                pst.setString(idx++, "%" + modelSearch.trim() + "%");
            }
            if (categoryFilter != null && !categoryFilter.isBlank()) {
                pst.setString(idx++, categoryFilter.toLowerCase());
            }

            try (ResultSet rs = pst.executeQuery()) {
                int sn = 1;
                while (rs.next()) {
                    Model m = new Model();
                    m.setSn(sn++);
                    m.setModelId(rs.getInt("id"));
                    m.setName(rs.getString("name"));
                    m.setCategory(rs.getString("category"));
                    m.setPrice(rs.getDouble("price"));
                    m.setListedDate(rs.getDate("listedDate"));
                    m.setSellerUsername(rs.getString("sellerUsername"));
                    m.setSn(rs.getInt("sales"));
                    list.add(m);
                }
            }
        }
        return list;
    }
    
    /** Fetch all distinct model categories. */
    public List<String> findAllCategories() throws SQLException {
        List<String> categories = new ArrayList<>();
        String sql = "SELECT DISTINCT Catagory FROM Models ORDER BY Catagory";
        try (Connection conn = getConnection();
             PreparedStatement pst = conn.prepareStatement(sql);
             ResultSet rs = pst.executeQuery()) {
            while (rs.next()) {
                categories.add(rs.getString("Catagory"));
            }
        }
        return categories;
    }
    
    
    /** Fetch users with optional search, role & sort. */
    public List<User> findUsers(String search, String roleFilter, String sort) throws SQLException {
        List<User> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
          "SELECT User_ID AS id, Username AS username, Name AS fullName, " +
          "       Created_At AS createdAt, Role AS role, Email AS email, Status AS status " +
          "  FROM User WHERE 1=1"
        );

        if (search != null && !search.isBlank()) {
            sql.append(" AND (Username LIKE ? OR Name LIKE ? OR Email LIKE ?)");
        }
        if (roleFilter != null && !roleFilter.isBlank()) {
            sql.append(" AND Role = ?");
        }
        switch (sort == null ? "" : sort) {
            case "oldest":
                sql.append(" ORDER BY Created_At ASC"); break;
            default:
                sql.append(" ORDER BY Created_At DESC"); break;
        }

        try (Connection conn = getConnection();
             PreparedStatement pst = conn.prepareStatement(sql.toString())) {

            int idx = 1;
            if (search != null && !search.isBlank()) {
                String like = "%" + search.trim() + "%";
                pst.setString(idx++, like);
                pst.setString(idx++, like);
                pst.setString(idx++, like);
            }
            if (roleFilter != null && !roleFilter.isBlank()) {
                pst.setString(idx++, roleFilter);
            }

            try (ResultSet rs = pst.executeQuery()) {
                while (rs.next()) {
                    User u = new User();
                    u.setId(rs.getInt("id"));
                    u.setUsername(rs.getString("username"));
                    u.setName(rs.getString("fullName"));
                    u.setCreatedAt(rs.getTimestamp("createdAt"));
                    u.setRole(rs.getString("role"));
                    u.setEmail(rs.getString("email"));
                    u.setStatus(rs.getString("status"));
                    list.add(u);
                }
            }
        }
        return list;
    }
    
    /** Fetch models applying optional search, category & sort. */
    public List<Model> findModels(String search,
                                  String categoryFilter,
                                  String sort) throws SQLException {
        List<Model> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
            "SELECT m.ModelID    AS id,        " +
            "       m.Name       AS name,      " +
            "       m.Catagory   AS category,  " +
            "       m.Price      AS price,     " +
            "       m.ListedDate AS listedDate," +
            "       u.Username   AS sellerUsername, " +
            "       COUNT(o.OrderID) AS sales   " +
            "  FROM Models m                   " +
            "  JOIN User u ON m.SellerUserID = u.User_ID  " +
            "  LEFT JOIN OrdersReceived o ON m.ModelID = o.ModelID " +
            " WHERE 1=1                        "
        );

        if (search != null && !search.isBlank()) {
            sql.append(" AND m.Name LIKE ?");
        }
        if (categoryFilter != null && !categoryFilter.isBlank()) {
            sql.append(" AND LOWER(m.Catagory)=?");
        }

        sql.append(
            " GROUP BY m.ModelID, m.Name, m.Catagory, m.Price, m.ListedDate, u.Username"
        );

        switch (sort == null ? "" : sort) {
            case "sales-asc":  sql.append(" ORDER BY sales ASC");        break;
            case "sales-desc": sql.append(" ORDER BY sales DESC");       break;
            case "date-asc":   sql.append(" ORDER BY m.ListedDate ASC"); break;
            case "date-desc":  sql.append(" ORDER BY m.ListedDate DESC");break;
            default:           sql.append(" ORDER BY m.ModelID ASC");
        }

        try (Connection conn = getConnection();
             PreparedStatement pst = conn.prepareStatement(sql.toString())) {

            int idx = 1;
            if (search != null && !search.isBlank()) {
                pst.setString(idx++, "%" + search.trim() + "%");
            }
            if (categoryFilter != null && !categoryFilter.isBlank()) {
                pst.setString(idx++, categoryFilter.toLowerCase());
            }

            try (ResultSet rs = pst.executeQuery()) {
                int sn = 1;
                while (rs.next()) {
                    Model m = new Model();
                    m.setSn(sn++);
                    m.setModelId(rs.getInt("id"));
                    m.setName(rs.getString("name"));
                    m.setCategory(rs.getString("category"));
                    m.setPrice(rs.getDouble("price"));
                    m.setListedDate(rs.getDate("listedDate"));
                    m.setSellerUsername(rs.getString("sellerUsername"));
                    m.setSn(rs.getInt("sales"));
                    list.add(m);
                }
            }
        }
        return list;
    }
    
    /**
     * Returns daily new‑user counts between from/to (inclusive)
     * and optionally filtered by role.
     */
    public ReportData<Long> userGrowth(LocalDate from, LocalDate to, String roleFilter)
            throws SQLException {
        List<String> labels = new ArrayList<>();
        List<Long> data     = new ArrayList<>();

        StringBuilder sql = new StringBuilder(
          "SELECT DATE(Created_At) AS day, COUNT(*) AS cnt\n" +
          "  FROM User\n" +
          " WHERE Created_At BETWEEN ? AND ?"
        );
        if (roleFilter != null && !roleFilter.isBlank()) {
            sql.append(" AND Role = ?");
        }
        sql.append(" GROUP BY day ORDER BY day");

        try (Connection c = getConnection();
             PreparedStatement p = c.prepareStatement(sql.toString())) {
            p.setDate(1, Date.valueOf(from));
            p.setDate(2, Date.valueOf(to));
            if (roleFilter != null && !roleFilter.isBlank()) {
                p.setString(3, roleFilter);
            }
            try (ResultSet rs = p.executeQuery()) {
                while (rs.next()) {
                    labels.add(rs.getDate("day").toString());
                    data .add(rs.getLong("cnt"));
                }
            }
        }
        return new ReportData<>(labels, data);
    }

    /**
     * Returns total units sold per model between from/to (inclusive),
     * sorted by the sortKey (“most-sold”, “least-sold”, “latest”, “oldest”).
     */
    public ReportData<Long> modelSales(LocalDate from, LocalDate to, String sortKey)
            throws SQLException {
        List<String> labels = new ArrayList<>();
        List<Long>   data   = new ArrayList<>();

        StringBuilder sql = new StringBuilder(
          "SELECT m.Name     AS label,\n" +
          "       COUNT(o.OrderID) AS cnt,\n" +
          "       MAX(o.OrderDate) AS lastSold,\n" +
          "       MIN(o.OrderDate) AS firstSold\n" +
          "  FROM OrdersReceived o\n" +
          "  JOIN Models m ON o.ModelID = m.ModelID\n" +
          " WHERE o.OrderDate BETWEEN ? AND ?\n" +
          " GROUP BY m.Name\n"
        );

        switch (sortKey == null ? "" : sortKey) {
          case "least-sold":
            sql.append(" ORDER BY cnt ASC"); break;
          case "latest":
            sql.append(" ORDER BY lastSold DESC"); break;
          case "oldest":
            sql.append(" ORDER BY firstSold ASC"); break;
          case "most-sold":
          default:
            sql.append(" ORDER BY cnt DESC");
        }

        try (Connection c = getConnection();
             PreparedStatement p = c.prepareStatement(sql.toString())) {
            p.setDate(1, Date.valueOf(from));
            p.setDate(2, Date.valueOf(to));
            try (ResultSet rs = p.executeQuery()) {
                while (rs.next()) {
                    labels.add(rs.getString("label"));
                    data .add(rs.getLong("cnt"));
                }
            }
        }
        return new ReportData<>(labels, data);
    }
    
    /** Generic status‐update helper */
    private void updateUserStatus(int userId, String status) throws SQLException {
        String sql = "UPDATE User SET Status = ? WHERE User_ID = ?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setInt   (2, userId);
            ps.executeUpdate();
        }
    }
    
    public void blockUser(int userId) throws SQLException {
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(
               "UPDATE User SET Status='blocked' WHERE User_ID=?")) {
          ps.setInt(1, userId);
          ps.executeUpdate();
        }
    }

    public void unblockUser(int userId) throws SQLException {
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(
               "UPDATE User SET Status='active' WHERE User_ID=?")) {
          ps.setInt(1, userId);
          ps.executeUpdate();
        }
    }


}
