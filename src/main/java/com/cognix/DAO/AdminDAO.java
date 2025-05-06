// src/main/java/com/cognix/DAO/AdminDAO.java
package com.cognix.DAO;

import com.cognix.config.DbConfig;
import com.cognix.model.Admin;

import java.sql.*;

public class AdminDAO {
    private final Connection conn;

    public AdminDAO() {
        try {
            conn = DbConfig.getDbConnection();
        } catch (SQLException e) {
            throw new RuntimeException("Unable to connect to DB", e);
        }
    }

    /** Legacy: find by email+rawPassword */
    public Admin findByEmailAndPassword(String email, String password) {
        String sql = "SELECT * FROM admin WHERE Email = ? AND Password = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, email);
            ps.setString(2, password);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Admin a = new Admin();
                    a.setAdminId(rs.getInt("Admin_ID"));
                    a.setUsername(rs.getString("Username"));
                    a.setPassword(rs.getString("Password"));
                    a.setEmail(rs.getString("Email"));
                    a.setName(rs.getString("Name"));
                    a.setAbout(rs.getString("About"));
                    a.setDob(rs.getDate("DOB"));
                    a.setProfilePicture(rs.getString("Profile_Picture"));
                    a.setCreatedAt(rs.getTimestamp("Created_At"));
                    return a;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    /** New: lookup by email only (for hashed-password login) */
    public Admin findByEmail(String email) {
        String sql = "SELECT * FROM admin WHERE Email = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, email);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Admin a = new Admin();
                    a.setAdminId(rs.getInt("Admin_ID"));
                    a.setUsername(rs.getString("Username"));
                    a.setPassword(rs.getString("Password"));
                    a.setEmail(rs.getString("Email"));
                    a.setName(rs.getString("Name"));
                    a.setAbout(rs.getString("About"));
                    a.setDob(rs.getDate("DOB"));
                    a.setProfilePicture(rs.getString("Profile_Picture"));
                    a.setCreatedAt(rs.getTimestamp("Created_At"));
                    return a;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

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
                ps.setNull(6, Types.DATE);
            }
            ps.setString(7, admin.getProfilePicture());
            ps.setInt(8, admin.getAdminId());
            return ps.executeUpdate() == 1;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
}
