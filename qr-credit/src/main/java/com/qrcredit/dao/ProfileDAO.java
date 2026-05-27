package com.qrcredit.dao;

import com.qrcredit.model.Profile;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.Date;

public class ProfileDAO {
    private Profile mapRowToProfile(ResultSet rs) throws Exception {
        Profile p = new Profile();
        p.setId(rs.getString("id"));
        p.setCustomerName(rs.getString("customer_name"));
        p.setCccd(rs.getString("cccd"));
        p.setAmount(rs.getDouble("amount"));
        p.setPurpose(rs.getString("purpose"));
        p.setStatus(rs.getString("status"));
        p.setRegion(rs.getString("region"));
        p.setWard(rs.getString("ward"));
        p.setPhone(rs.getString("phone"));
        p.setEmail(rs.getString("email"));
        p.setCreditScore(rs.getInt("credit_score"));
        p.setCreatedBy(rs.getString("created_by"));
        p.setDeleted(rs.getBoolean("is_deleted"));
        p.setLastUpdated(new Date(rs.getTimestamp("last_updated").getTime()));
        try { p.setOtpCount(rs.getInt("otp_count")); } catch (Exception e) {}
        try { if(rs.getTimestamp("last_otp_date") != null) p.setLastOtpDate(new Date(rs.getTimestamp("last_otp_date").getTime())); } catch (Exception e) {}
        return p;
    }
    public boolean addProfile(Profile p) {
        String sql = "INSERT INTO profiles (id, customer_name, cccd, amount, purpose, status, region, ward, phone, email, credit_score, created_by, is_deleted, last_updated) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, p.getId());
            ps.setString(2, p.getCustomerName());
            ps.setString(3, p.getCccd());
            ps.setDouble(4, p.getAmount());
            ps.setString(5, p.getPurpose());
            ps.setString(6, p.getStatus());
            ps.setString(7, p.getRegion());
            ps.setString(8, p.getWard());
            ps.setString(9, p.getPhone());
            ps.setString(10, p.getEmail());
            ps.setInt(11, p.getCreditScore());
            ps.setString(12, p.getCreatedBy());
            ps.setBoolean(13, false);
            ps.setTimestamp(14, new java.sql.Timestamp(p.getLastUpdated().getTime()));
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public Profile getProfileById(String id) {
        String sql = "SELECT * FROM profiles WHERE id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapRowToProfile(rs);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean updateOtpInfo(String id, int count, Date lastDate) {
        String sql = "UPDATE profiles SET otp_count = ?, last_otp_date = ? WHERE id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, count);
            ps.setTimestamp(2, lastDate != null ? new java.sql.Timestamp(lastDate.getTime()) : null);
            ps.setString(3, id);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public java.util.List<Profile> getAllProfiles(com.qrcredit.model.User user) {
        java.util.List<Profile> list = new java.util.ArrayList<>();
        String sql = "SELECT * FROM profiles WHERE (is_deleted = FALSE OR is_deleted IS NULL)";
        if (user != null && "GDV".equals(user.getRole())) {
            sql += " AND created_by = ?";
        }
        sql += " ORDER BY last_updated DESC";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            if (user != null && "GDV".equals(user.getRole())) {
                ps.setString(1, user.getUsername());
            }
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapRowToProfile(rs));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public java.util.List<Profile> getDeletedProfiles(com.qrcredit.model.User user) {
        java.util.List<Profile> list = new java.util.ArrayList<>();
        String sql = "SELECT * FROM profiles WHERE is_deleted = TRUE";
        if (user != null && "GDV".equals(user.getRole())) {
            sql += " AND created_by = ?";
        }
        sql += " ORDER BY last_updated DESC";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            if (user != null && "GDV".equals(user.getRole())) {
                ps.setString(1, user.getUsername());
            }
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapRowToProfile(rs));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public java.util.List<Profile> getProfilesByCccd(String cccd) {
        java.util.List<Profile> list = new java.util.ArrayList<>();
        String sql = "SELECT * FROM profiles WHERE cccd = ? AND (is_deleted = FALSE OR is_deleted IS NULL) ORDER BY last_updated DESC";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, cccd);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapRowToProfile(rs));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public boolean updateStatus(String id, String newStatus) {
        String sql = "UPDATE profiles SET status = ?, last_updated = ? WHERE id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, newStatus);
            ps.setTimestamp(2, new java.sql.Timestamp(new Date().getTime()));
            ps.setString(3, id);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean softDeleteProfile(String id) {
        String sql = "UPDATE profiles SET is_deleted = TRUE, last_updated = ? WHERE id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setTimestamp(1, new java.sql.Timestamp(new Date().getTime()));
            ps.setString(2, id);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean restoreProfile(String id) {
        String sql = "UPDATE profiles SET is_deleted = FALSE, last_updated = ? WHERE id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setTimestamp(1, new java.sql.Timestamp(new Date().getTime()));
            ps.setString(2, id);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean hardDeleteProfile(String id) {
        String sql = "DELETE FROM profiles WHERE id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, id);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }
}

