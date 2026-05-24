package com.qrcredit.dao;

import com.qrcredit.model.AuditLog;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

public class AuditLogDAO {
    public boolean logAction(String profileId, int userId, String oldStatus, String newStatus) {
        String sql = "INSERT INTO audit_trail (profile_id, user_id, old_status, new_status, updated_at) VALUES (?, ?, ?, ?, ?)";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, profileId);
            ps.setInt(2, userId);
            ps.setString(3, oldStatus);
            ps.setString(4, newStatus);
            ps.setTimestamp(5, new java.sql.Timestamp(new Date().getTime()));
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public List<AuditLog> getLogsByProfileId(String profileId) {
        List<AuditLog> list = new ArrayList<>();
        String sql = "SELECT a.*, u.fullname FROM audit_trail a JOIN users u ON a.user_id = u.id WHERE a.profile_id = ? ORDER BY a.updated_at DESC";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, profileId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    AuditLog log = new AuditLog();
                    log.setId(rs.getInt("id"));
                    log.setProfileId(rs.getString("profile_id"));
                    log.setUserId(rs.getInt("user_id"));
                    log.setUserFullName(rs.getString("fullname"));
                    log.setOldStatus(rs.getString("old_status"));
                    log.setNewStatus(rs.getString("new_status"));
                    log.setUpdatedAt(new Date(rs.getTimestamp("updated_at").getTime()));
                    list.add(log);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
}
