package com.cognix.DAO;

import com.cognix.config.DbConfig;
import com.cognix.model.Message;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class MessageDAO {
    private final Connection conn;

    public MessageDAO() {
        try {
            this.conn = DbConfig.getDbConnection();
        } catch (SQLException e) {
            throw new RuntimeException("Unable to connect to DB", e);
        }
    }

    /**
     * Insert a new contact message.
     */
    public void save(Message m) throws SQLException {
        String sql = """
            INSERT INTO Contact_Message
              (User_ID, Name, Email, Subject, Body, Created_At, Status)
            VALUES (?, ?, ?, ?, ?, NOW(), 'unread')
            """;
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            // 1) if no valid userId, bind NULL
            if (m.getUserId() > 0) {
                ps.setInt(1, m.getUserId());
            } else {
                ps.setNull(1, Types.INTEGER);
            }
            // 2) the rest are mandatory
            ps.setString(2, m.getName());
            ps.setString(3, m.getEmail());
            ps.setString(4, m.getSubject());
            ps.setString(5, m.getBody());
            ps.executeUpdate();
        }
    }

    /**
     * Fetches messages, optionally filtering by name/email and sorting by date.
     *
     * @param q    optional search term for name/email
     * @param sort either "newest" or "oldest"
     */
    public List<Message> findMessages(String q, String sort) throws SQLException {
        StringBuilder sql = new StringBuilder()
            .append("SELECT Message_ID, User_ID, Name, Email, Subject, Body, Created_At, Status ")
            .append("FROM Contact_Message ");

        boolean hasSearch = (q != null && !q.trim().isEmpty());
        if (hasSearch) {
            sql.append("WHERE Name LIKE ? OR Email LIKE ? ");
        }

        sql.append("ORDER BY Created_At ")
           .append("oldest".equals(sort) ? "ASC" : "DESC");

        List<Message> list = new ArrayList<>();
        try (PreparedStatement ps = conn.prepareStatement(sql.toString())) {

            if (hasSearch) {
                String like = "%" + q.trim() + "%";
                ps.setString(1, like);
                ps.setString(2, like);
            }

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Message m = new Message();
                    m.setId(         rs.getInt(   "Message_ID"));
                    m.setUserId(     rs.getInt(   "User_ID"));
                    m.setName(       rs.getString("Name"));
                    m.setEmail(      rs.getString("Email"));
                    m.setSubject(    rs.getString("Subject"));
                    m.setBody(       rs.getString("Body"));
                    m.setCreatedAt(  rs.getTimestamp("Created_At"));
                    m.setStatus(     rs.getString("Status"));
                    list.add(m);
                }
            }
        }

        return list;
    }

    /**
     * Mark a message as read.
     */
    public void markChecked(int messageId) throws SQLException {
        String sql = "UPDATE Contact_Message SET Status='read' WHERE Message_ID=?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, messageId);
            ps.executeUpdate();
        }
    }
}
