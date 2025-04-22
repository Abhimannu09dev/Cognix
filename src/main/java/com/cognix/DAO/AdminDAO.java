package com.cognix.DAO;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import com.cognix.config.DbConfig;
import com.cognix.model.Admin;

public class AdminDAO {
    private final Connection conn;

    public AdminDAO() {
        try {
            conn = DbConfig.getDbConnection();
        } catch (SQLException e) {
            throw new RuntimeException("Unable to connect to DB", e);
        }
    }

    // Find admin by email and password
    public Admin findByEmailAndPassword(String email, String password) {
        String sql = "SELECT * FROM admin WHERE Email = ? AND Password = ?";

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, email);
            ps.setString(2, password);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Admin admin = new Admin();
                    admin.setAdminId(rs.getInt("Admin_ID"));
                    admin.setUsername(rs.getString("Username"));
                    admin.setPassword(rs.getString("Password"));
                    admin.setEmail(rs.getString("Email"));
                    admin.setName(rs.getString("Name"));
                    admin.setAbout(rs.getString("About"));
                    admin.setDob(rs.getDate("DOB"));
                    admin.setProfilePicture(rs.getString("Profile_Picture"));
                    admin.setCreatedAt(rs.getTimestamp("Created_At"));
                    return admin;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    // Update admin profile
    public boolean updateAdmin(Admin admin) {
        String sql = "UPDATE admin SET Username=?, Name=?, Email=?, About=?, Password=?, DOB=?, Profile_Picture=? WHERE Admin_ID=?";

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, admin.getUsername());
            ps.setString(2, admin.getName());
            ps.setString(3, admin.getEmail());
            ps.setString(4, admin.getAbout());
            ps.setString(5, admin.getPassword());

            if (admin.getDob() != null) {
                ps.setDate(6, new java.sql.Date(admin.getDob().getTime()));
            } else {
                ps.setNull(6, java.sql.Types.DATE);
            }

            ps.setString(7, admin.getProfilePicture());
            ps.setInt(8, admin.getAdminId());

            return ps.executeUpdate() == 1;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
}
