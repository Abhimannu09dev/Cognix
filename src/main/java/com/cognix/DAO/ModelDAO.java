package com.cognix.DAO;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

import com.cognix.model.Model;

public class ModelDAO {

    private Connection getConnection() throws SQLException {
        String url = "jdbc:mysql://localhost:3307/CogniX";
        String username = "root";
        String password = ""; // your password if any
        return DriverManager.getConnection(url, username, password);
    }

    public List<Model> getAllModels() {
        List<Model> models = new ArrayList<>();

        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement("SELECT * FROM Models");
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                Model model = new Model();
                model.setId(rs.getInt("ModelID"));
                model.setName(rs.getString("Name")); // Match exactly (capital N)
                model.setCategory(rs.getString("Catagory")); // Match spelling mistake in DB
                model.setListedDate(rs.getString("ListedDate")); // Match exactly (capital L and D)
                model.setPrice(rs.getDouble("Price")); // Match exactly (capital P)

                // 🔥 sales and revenue columns don't exist in database. Remove these two lines:
                // model.setSales(rs.getInt("sales"));
                // model.setRevenue(rs.getDouble("revenue"));

                models.add(model);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return models;
    }
}
