package com.cognix.DAO;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import com.cognix.config.DbConfig;
import com.cognix.model.User;

public class UserDAO {
    private final Connection conn;

    public UserDAO() {
        try {
            conn = DbConfig.getDbConnection();
        } catch (SQLException e) {
            throw new RuntimeException("Unable to connect to DB", e);
        }
    }

    // Save a new user (Registration)
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
                ps.setNull(7, java.sql.Types.DATE);
            }

            ps.setString(8, user.getProfilePicture());
            ps.setInt(9, user.getCartId());

            return ps.executeUpdate() == 1;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Update an existing user (Profile update)
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
                ps.setNull(6, java.sql.Types.DATE);
            }

            ps.setString(7, user.getProfilePicture());
            ps.setInt(8, user.getId());

            return ps.executeUpdate() == 1;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // Find user by email and password (Login)
    public User findByEmailAndPassword(String email, String password) {
        String sql = "SELECT * FROM User WHERE Email = ? AND Password = ?";

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, email);
            ps.setString(2, password);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    User user = new User();
                    user.setId(rs.getInt("User_ID"));
                    user.setUsername(rs.getString("Username"));
                    user.setPassword(rs.getString("Password"));
                    user.setEmail(rs.getString("Email"));
                    user.setRole(rs.getString("Role"));
                    user.setName(rs.getString("Name"));
                    user.setAbout(rs.getString("About"));
                    user.setDob(rs.getDate("DOB"));
                    user.setProfilePicture(rs.getString("Profile_Picture"));
                    user.setCartId(rs.getInt("Cart_ID"));
                    user.setCreatedAt(rs.getTimestamp("Created_At"));
                    user.setLastLogin(rs.getTimestamp("Last_Login"));
                    return user;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
}
