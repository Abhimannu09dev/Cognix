// src/main/java/com/cognix/DAO/UserDAO.java
package com.cognix.DAO;

import com.cognix.config.DbConfig;
import com.cognix.model.User;

import java.sql.*;

public class UserDAO {
    private final Connection conn;

    public UserDAO() {
        try {
            conn = DbConfig.getDbConnection();
        } catch (SQLException e) {
            throw new RuntimeException("Unable to connect to DB", e);
        }
    }

    public boolean save(User user) {
        String sql = "INSERT INTO User (Username, Password, Email, Role, Name, About, DOB, Profile_Picture, Cart_ID, Created_At) "
                   + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, NOW())";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, user.getUsername());
            ps.setString(2, user.getPassword());
            ps.setString(3, user.getEmail());
            ps.setString(4, user.getRole());
            ps.setString(5, user.getName());
            ps.setString(6, user.getAbout());
            if (user.getDob() != null) {
                ps.setDate(7, new java.sql.Date(user.getDob().getTime()));
            } else {
                ps.setNull(7, Types.DATE);
            }
            ps.setString(8, user.getProfilePicture());
            ps.setInt(9, user.getCartId());
            return ps.executeUpdate() == 1;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean updateUser(User user) {
        String sql = "UPDATE User SET Username=?, Name=?, Email=?, About=?, Password=?, DOB=?, Profile_Picture=? WHERE User_ID=?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, user.getUsername());
            ps.setString(2, user.getName());
            ps.setString(3, user.getEmail());
            ps.setString(4, user.getAbout());
            ps.setString(5, user.getPassword());
            if (user.getDob() != null) {
                ps.setDate(6, new java.sql.Date(user.getDob().getTime()));
            } else {
                ps.setNull(6, Types.DATE);
            }
            ps.setString(7, user.getProfilePicture());
            ps.setInt(8, user.getId());
            return ps.executeUpdate() == 1;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    /** Check if another user already has this username */
    public boolean isUsernameTaken(String username, int excludeUserId) {
        String sql = "SELECT 1 FROM User WHERE Username = ? AND User_ID <> ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, username);
            ps.setInt(2, excludeUserId);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

    /** Check if another user already has this email */
    public boolean isEmailTaken(String email, int excludeUserId) {
        String sql = "SELECT 1 FROM User WHERE Email = ? AND User_ID <> ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, email);
            ps.setInt(2, excludeUserId);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

    /** Legacy: find by email+rawPassword */
    public User findByEmailAndPassword(String email, String password) {
        String sql = "SELECT * FROM User WHERE Email = ? AND Password = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, email);
            ps.setString(2, password);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    User u = new User();
                    u.setId(rs.getInt("User_ID"));
                    u.setUsername(rs.getString("Username"));
                    u.setPassword(rs.getString("Password"));
                    u.setEmail(rs.getString("Email"));
                    u.setRole(rs.getString("Role"));
                    u.setName(rs.getString("Name"));
                    u.setAbout(rs.getString("About"));
                    u.setDob(rs.getDate("DOB"));
                    u.setProfilePicture(rs.getString("Profile_Picture"));
                    u.setCartId(rs.getInt("Cart_ID"));
                    u.setCreatedAt(rs.getTimestamp("Created_At"));
                    u.setLastLogin(rs.getTimestamp("Last_Login"));
                    return u;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    /** New: lookup by email only (for hashed-password login) */
    public User findByEmail(String email) {
        String sql = "SELECT * FROM User WHERE Email = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, email);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    User u = new User();
                    u.setId(rs.getInt("User_ID"));
                    u.setUsername(rs.getString("Username"));
                    u.setPassword(rs.getString("Password"));
                    u.setEmail(rs.getString("Email"));
                    u.setRole(rs.getString("Role"));
                    u.setName(rs.getString("Name"));
                    u.setAbout(rs.getString("About"));
                    u.setDob(rs.getDate("DOB"));
                    u.setProfilePicture(rs.getString("Profile_Picture"));
                    u.setCartId(rs.getInt("Cart_ID"));
                    u.setCreatedAt(rs.getTimestamp("Created_At"));
                    u.setLastLogin(rs.getTimestamp("Last_Login"));
                    u.setStatus(rs.getString("Status"));
                    return u;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    } 
}
