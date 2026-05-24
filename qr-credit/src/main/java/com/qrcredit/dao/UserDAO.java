package com.qrcredit.dao;

import com.qrcredit.model.User;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class UserDAO {
    public User login(String username, String password) {
        String sql = "SELECT * FROM users WHERE username = ? AND password = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, username);
            ps.setString(2, password);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return new User(rs.getInt("id"), rs.getString("username"),
                                    rs.getString("password"), rs.getString("role"),
                                    rs.getString("fullname"), rs.getString("status"));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean createUser(User u) {
        String sql = "INSERT INTO users (username, password, role, fullname, status) VALUES (?, ?, ?, ?, 'ACTIVE')";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, u.getUsername());
            ps.setString(2, u.getPassword());
            ps.setString(3, u.getRole());
            ps.setString(4, u.getFullname());
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public java.util.List<User> getAllUsers() {
        java.util.List<User> list = new java.util.ArrayList<>();
        String sql = "SELECT * FROM users WHERE status = 'ACTIVE' OR status IS NULL ORDER BY id ASC";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(new User(rs.getInt("id"), rs.getString("username"),
                                  rs.getString("password"), rs.getString("role"),
                                  rs.getString("fullname"), rs.getString("status")));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public java.util.List<User> getLockedOrDeletedUsers() {
        java.util.List<User> list = new java.util.ArrayList<>();
        String sql = "SELECT * FROM users WHERE status IN ('LOCKED_TEMP', 'LOCKED_PERM', 'DELETED') ORDER BY id ASC";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(new User(rs.getInt("id"), rs.getString("username"),
                                  rs.getString("password"), rs.getString("role"),
                                  rs.getString("fullname"), rs.getString("status")));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public boolean updateStatus(int id, String newStatus) {
        String sql = "UPDATE users SET status = ? WHERE id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, newStatus);
            ps.setInt(2, id);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean deleteUser(int id) {
        // Chuyển thành Hard Delete (Hoặc giữ nguyên vì giờ đã có Soft Delete là status='DELETED')
        String sql = "DELETE FROM users WHERE id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }
}
