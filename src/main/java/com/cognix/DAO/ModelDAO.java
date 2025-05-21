// src/main/java/com/cognix/DAO/ModelDAO.java
package com.cognix.DAO;

import com.cognix.model.Model;

import jakarta.servlet.http.Part;

import java.io.File;
import java.io.IOException;
import java.nio.file.Paths;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.Objects;
import java.util.UUID;

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
    
    /** NEW!  Fetch distinct categories *this* seller has used */
    public List<String> findSellerCategories(int sellerId) throws SQLException {
        String sql =
          "SELECT DISTINCT Catagory " +
          "  FROM Models " +
          " WHERE SellerUserID = ? " +
          " ORDER BY Catagory";
        List<String> cats = new ArrayList<>();
        try (Connection c = getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, sellerId);
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
        // 1) Build the base query
        StringBuilder sql = new StringBuilder("""
            SELECT
              p.PurchaseDate      AS purchaseDate,
              m.ModelID           AS modelId,
              m.Name              AS name,
              m.Catagory          AS category,
              m.ListedDate        AS listedDate,
              m.Price             AS price,
              m.Image_Path        AS imagePath,
              m.Description       AS description,
              m.Precision         AS modelPrecision,
              m.Recall            AS modelRecall,
              m.F1Score           AS modelF1Score,
              m.Parameters        AS parameters,
              m.InferenceTime     AS inferenceTime,
              m.DocsURL           AS docsUrl,
              m.github_url        AS githubUrl,
              u.Username          AS sellerUsername
            FROM Purchases p
            JOIN Models m ON p.ModelID = m.ModelID
            JOIN User   u ON m.SellerUserID = u.User_ID
            WHERE p.BuyerUserID = ?
            """);

        // 2) Add optional filters
        if (search != null && !search.isBlank()) {
            sql.append(" AND m.Name LIKE ?");
        }
        if (category != null && !category.isBlank()) {
            sql.append(" AND m.Catagory = ?");
        }
        if (purchasedFilter != null && !purchasedFilter.isBlank()) {
            switch (purchasedFilter) {
                case "7d"  -> sql.append(" AND p.PurchaseDate >= DATE_SUB(CURDATE(), INTERVAL 7 DAY)");
                case "30d" -> sql.append(" AND p.PurchaseDate >= DATE_SUB(CURDATE(), INTERVAL 30 DAY)");
                case "365d"-> sql.append(" AND p.PurchaseDate >= DATE_SUB(CURDATE(), INTERVAL 365 DAY)");
                // you can add more cases here if needed
            }
        }

        // 3) Finish with ordering
        sql.append(" ORDER BY p.PurchaseDate DESC");

        try (Connection conn = getConnection();
             PreparedStatement pst = conn.prepareStatement(sql.toString())) {

            // 4) Bind parameters in the same order we appended them
            int idx = 1;
            pst.setInt(idx++, buyerUserId);

            if (search != null && !search.isBlank()) {
                pst.setString(idx++, "%" + search.trim() + "%");
            }
            if (category != null && !category.isBlank()) {
                pst.setString(idx++, category);
            }
            // Note: purchasedFilter doesn't need a placeholder above

            try (ResultSet rs = pst.executeQuery()) {
                List<Model> list = new ArrayList<>();
                int sn = 1;
                while (rs.next()) {
                    Model m = new Model();
                    m.setSn             (sn++);
                    m.setModelId        (rs.getInt   ("modelId"));
                    m.setName           (rs.getString("name"));
                    m.setCategory       (rs.getString("category"));
                    m.setListedDate     (rs.getDate  ("listedDate"));
                    m.setPrice          (rs.getDouble("price"));
                    m.setImagePath      (rs.getString("imagePath"));
                    m.setDescription    (rs.getString("description"));
                    m.setSellerUsername (rs.getString("sellerUsername"));
                    m.setPurchaseDate   (rs.getDate  ("purchaseDate"));
                    m.setDocsUrl        (rs.getString("docsUrl"));
                    m.setGithubUrl      (rs.getString("githubUrl"));

                    m.setAccuracy   (parsePercent(rs.getString("modelPrecision")));
                    m.setPrecision  (0);
                    m.setRecall     (parsePercent(rs.getString("modelRecall")));
                    m.setF1Score    (parsePercent(rs.getString("modelF1Score")));

                    m.setParameters    (parseLong(rs.getString("parameters")));
                    m.setInferenceTime((int) parseLong(rs.getString("inferenceTime")));

                    list.add(m);
                }
                return list;
            }
        }
    }

    
    


    /** 4) Lookup a single model by its ID. */
    public Model findById(int modelId) throws SQLException {
        String sql = """
            SELECT
              m.ModelID,
              m.Name,
              m.Catagory      AS category,
              m.ListedDate,
              m.Price,
              m.Image_Path    AS imagePath,
              m.Description,
              m.Precision     AS modelPrecision,
              m.Recall        AS modelRecall,
              m.F1Score       AS modelF1Score,
              m.Parameters,
              m.InferenceTime AS inferenceTime,
              m.DocsURL       AS docsUrl,
              m.github_url    AS githubUrl,
              u.Username      AS sellerUsername
            FROM Models m
            JOIN User   u ON m.SellerUserID = u.User_ID
            WHERE m.ModelID = ?
            """;
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, modelId);
            try (ResultSet rs = ps.executeQuery()) {
                if (!rs.next()) return null;

                Model m = new Model();
                m.setModelId       (rs.getInt   ("ModelID"));
                m.setName          (rs.getString("Name"));
                m.setCategory      (rs.getString("category"));
                m.setListedDate    (rs.getDate  ("ListedDate"));
                m.setPrice         (rs.getDouble("Price"));
                m.setImagePath     (rs.getString("imagePath"));
                m.setDescription   (rs.getString("Description"));
                m.setSellerUsername(rs.getString("sellerUsername"));
                m.setDocsUrl       (rs.getString("docsUrl"));
                m.setGithubUrl     (rs.getString("githubUrl"));

                // strip "%" and parse
                m.setAccuracy(  parsePercent(rs.getString("modelPrecision")) );
                m.setPrecision(0);
                m.setRecall(    parsePercent(rs.getString("modelRecall"))    );
                m.setF1Score(   parsePercent(rs.getString("modelF1Score"))   );

                // strip non-digits and parse
                m.setParameters(    parseLong(rs.getString("parameters"))      );
                m.setInferenceTime( (int)parseLong(rs.getString("inferenceTime")) );

                return m;
            }
        }
    }

    //---------------------------------------
    //  Helper methods to normalize your VARCHAR stats
    //---------------------------------------
    private double parsePercent(String s) {
        if (s == null) return 0;
        try {
            return Double.parseDouble(s.replace("%","").trim());
        } catch (NumberFormatException e) {
            return 0;
        }
    }

    private long parseLong(String s) {
        if (s == null) return 0;
        // strip everything except digits
        String digits = s.replaceAll("[^0-9]", "").trim();
        if (digits.isEmpty()) return 0;
        try {
            return Long.parseLong(digits);
        } catch (NumberFormatException e) {
            return 0;
        }
    }

    /**
     *  Fetch this seller’s models (with optional filters)
     *  plus total units sold & total revenue per model.
     */
    
    public List<Model> findSellerModelsWithStats(int sellerId,
            String nameFilter,
            String categoryFilter,
            Date postedAt) throws SQLException {

			String sql = """
			SELECT
			m.ModelID             AS modelId,
			m.Name                AS name,
			m.Version             AS version,
			m.Catagory            AS category,
			m.ListedDate          AS listedDate,
			m.Price               AS price,
			m.Image_Path          AS imagePath,
			m.DocsURL             AS docsUrl,
			m.github_url          AS githubUrl,
			m.Description         AS description,
			m.Precision           AS modelPrecision,
			m.Recall              AS modelRecall,
			m.F1Score             AS modelF1Score,
			m.Parameters          AS parameters,
			m.InferenceTime       AS inferenceTime,
			COUNT(o.OrderID)      AS sold,
			COALESCE(SUM(o.Price),0) AS revenue
			FROM Models m
			LEFT JOIN OrdersReceived o
			ON m.ModelID = o.ModelID
			WHERE m.SellerUserID = ?
			AND (? IS NULL OR m.Name     LIKE ?)
			AND (? IS NULL OR LOWER(m.Catagory)=LOWER(?))
			AND (? IS NULL OR DATE(m.ListedDate)=?)
			GROUP BY m.ModelID
			ORDER BY m.ListedDate DESC
			""";
			
			try (Connection conn = getConnection();
			PreparedStatement ps = conn.prepareStatement(sql)) {
				
					int idx = 1;
					ps.setInt(idx++, sellerId);
					
					// nameFilter
					if (nameFilter == null || nameFilter.isBlank()) {
							ps.setNull(idx++, Types.VARCHAR);
							ps.setNull(idx++, Types.VARCHAR);
						} else {
							String like = "%" + nameFilter.trim() + "%";
							ps.setString(idx++, like);
							ps.setString(idx++, like);
					}
					
					// categoryFilter
					if (categoryFilter == null || categoryFilter.isBlank()) {
						ps.setNull(idx++, Types.VARCHAR);
						ps.setNull(idx++, Types.VARCHAR);
						} else {
							ps.setString(idx++, categoryFilter);
							ps.setString(idx++, categoryFilter);
					}
					
					// postedAt
					if (postedAt == null) {
						ps.setNull(idx++, Types.DATE);
						ps.setNull(idx++, Types.DATE);
						} else {
							ps.setDate(idx++, postedAt);
							ps.setDate(idx++, postedAt);
					}
				
					try (ResultSet rs = ps.executeQuery()) {
						List<Model> list = new ArrayList<>();
						while (rs.next()) {
							Model m = new Model();
							m.setSn            (rs.getRow());
							m.setModelId       (rs.getInt   ("modelId"));
							m.setName          (rs.getString("name"));
							m.setVersion       (rs.getString("version"));      // <— use alias "version"
							m.setCategory      (rs.getString("category"));
							m.setListedDate    (rs.getDate  ("listedDate"));
							m.setPrice         (rs.getDouble("price"));
							m.setImagePath     (rs.getString("imagePath"));
							m.setDocsUrl       (rs.getString("docsUrl"));      // <— use alias "docsUrl"
							m.setGithubUrl     (rs.getString("githubUrl"));    // <— use alias "githubUrl"
							m.setDescription   (rs.getString("description"));
							
							// strip “%” and parse doubles
							m.setAccuracy      (parsePercent(rs.getString("modelPrecision")));
							m.setPrecision     (parsePercent(rs.getString("modelPrecision")));
							m.setRecall        (parsePercent(rs.getString("modelRecall")));
							m.setF1Score       (parsePercent(rs.getString("modelF1Score")));
							
							// strip non-digits and parse longs/ints
							m.setParameters    (parseLong(rs.getString("parameters")));
							m.setInferenceTime ((int)parseLong(rs.getString("inferenceTime")));
							
							m.setSales         (rs.getInt       ("sold"));
							m.setRevenue       (rs.getBigDecimal("revenue"));
							
							list.add(m);
						}
						return list;
					}
				}
			}

    
    
    /**
     * Inserts a new model into the database and writes its image to disk.
     *
     * @param m            the Model bean (without imagePath set)
     * @param imagePart    the uploaded image Part
     * @param uploadFolder the absolute filesystem path to your webapp's /uploads folder
     * @return true if the insert succeeded
     */
    
 // src/main/java/com/cognix/DAO/ModelDAO.java
    public boolean addModel(Model m) throws SQLException {
        String sql = """
          INSERT INTO Models
            (Name, Version, Catagory, ListedDate, Price, Image_Path,
             Description, Accuracy, `Precision`, Recall, F1Score,
             Parameters, InferenceTime, DocsURL, github_url, SellerUserID)
          VALUES (?, ?, ?, NOW(), ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
          """;
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            int i = 1;
            ps.setString(i++, m.getName());
            ps.setString(i++, m.getVersion());
            ps.setString(i++, m.getCategory());
            ps.setDouble(i++, m.getPrice());
            ps.setString(i++, m.getImagePath());
            ps.setString(i++, m.getDescription());
            ps.setDouble(i++, m.getAccuracy());
            ps.setDouble(i++, m.getPrecision());
            ps.setDouble(i++, m.getRecall());
            ps.setDouble(i++, m.getF1Score());
            ps.setLong(i++, m.getParameters());
            ps.setInt(i++, m.getInferenceTime());
            ps.setString(i++, m.getDocsUrl());
            ps.setString(i++, m.getGithubUrl());
            ps.setInt(i++, m.getSellerUserId());

            return ps.executeUpdate() == 1;
        }
    }



    
    
 // in src/main/java/com/cognix/DAO/ModelDAO.java
    public boolean updateModel(Model m) throws SQLException {
        String sql = """
            UPDATE Models
               SET Name           = ?,
                   Version        = ?,
                   Catagory       = ?,
                   DocsURL        = ?,
                   github_url     = ?,
                   Description    = ?,
                   Image_Path     = ?,
                   Price          = ?,
                   Accuracy       = ?,
                   `Precision`    = ?,
                   Recall         = ?,
                   F1Score        = ?,
                   Parameters     = ?,
                   InferenceTime  = ?
             WHERE ModelID        = ?
            """;

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            int i = 1;
            ps.setString(i++, m.getName());
            ps.setString(i++, m.getVersion());
            ps.setString(i++, m.getCategory());
            ps.setString(i++, m.getDocsUrl());
            ps.setString(i++, m.getGithubUrl());
            ps.setString(i++, m.getDescription());
            ps.setString(i++, m.getImagePath());
            ps.setDouble(i++, m.getPrice());
            ps.setDouble(i++, m.getAccuracy());
            ps.setDouble(i++, m.getPrecision());
            ps.setDouble(i++, m.getRecall());
            ps.setDouble(i++, m.getF1Score());
            ps.setLong(i++,   m.getParameters());
            ps.setInt(i++,    m.getInferenceTime());
            ps.setInt(i++,    m.getModelId());
            
            return ps.executeUpdate() == 1;
        }
    }
    
    
    
    /**
	 * Deletes a model from the database.
	 *
	 * @param modelId the ID of the model to delete
	 * @return true if the delete succeeded
	 */
    /** Delete the model itself (returns true if exactly one row removed) */
    public boolean deleteModel(int modelId) throws SQLException {
        String sqlDeletePurchases =
          "DELETE FROM Purchases WHERE ModelID = ?";
        String sqlDeleteOrdersReceived =
          "DELETE FROM OrdersReceived WHERE ModelID = ?";
        String sqlDeleteModel =
          "DELETE FROM Models WHERE ModelID = ?";

        try (Connection conn = getConnection()) {
            conn.setAutoCommit(false);
            try (
                PreparedStatement psDelPurchases     = conn.prepareStatement(sqlDeletePurchases);
                PreparedStatement psDelOrders        = conn.prepareStatement(sqlDeleteOrdersReceived);
                PreparedStatement psDelModel         = conn.prepareStatement(sqlDeleteModel)
            ) {
                // 1) delete any purchase history
                psDelPurchases.setInt(1, modelId);
                psDelPurchases.executeUpdate();

                // 2) delete any orders‐received entries
                psDelOrders.setInt(1, modelId);
                psDelOrders.executeUpdate();

                // 3) delete the model itself
                psDelModel.setInt(1, modelId);
                int count = psDelModel.executeUpdate();

                conn.commit();
                return count == 1;
            } catch (SQLException ex) {
                conn.rollback();
                throw ex;
            } finally {
                conn.setAutoCommit(true);
            }
        }
    }





    
    
}
