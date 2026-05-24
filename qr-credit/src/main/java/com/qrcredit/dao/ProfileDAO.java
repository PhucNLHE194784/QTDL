package com.qrcredit.dao;

import com.qrcredit.model.Profile;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.Date;

public class ProfileDAO {
    public boolean addProfile(Profile p) {
        String sql = "INSERT INTO profiles (id, customer_name, cccd, amount, purpose, status, region, ward, phone, last_updated) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
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
            ps.setTimestamp(10, new java.sql.Timestamp(p.getLastUpdated().getTime()));
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
                    return new Profile(
                        rs.getString("id"),
                        rs.getString("customer_name"),
                        rs.getString("cccd"),
                        rs.getDouble("amount"),
                        rs.getString("purpose"),
                        rs.getString("status"),
                        rs.getString("region"),
                        rs.getString("ward"),
                        rs.getString("phone"),
                        new Date(rs.getTimestamp("last_updated").getTime())
                    );
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public java.util.List<Profile> getAllProfiles() {
        java.util.List<Profile> list = new java.util.ArrayList<>();
        String sql = "SELECT * FROM profiles ORDER BY last_updated DESC";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(new Profile(
                    rs.getString("id"),
                    rs.getString("customer_name"),
                    rs.getString("cccd"),
                    rs.getDouble("amount"),
                    rs.getString("purpose"),
                    rs.getString("status"),
                    rs.getString("region"),
                    rs.getString("ward"),
                    rs.getString("phone"),
                    new Date(rs.getTimestamp("last_updated").getTime())
                ));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public java.util.List<Profile> getProfilesByCccd(String cccd) {
        java.util.List<Profile> list = new java.util.ArrayList<>();
        String sql = "SELECT * FROM profiles WHERE cccd = ? ORDER BY last_updated DESC";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, cccd);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(new Profile(
                        rs.getString("id"),
                        rs.getString("customer_name"),
                        rs.getString("cccd"),
                        rs.getDouble("amount"),
                        rs.getString("purpose"),
                        rs.getString("status"),
                        rs.getString("region"),
                        rs.getString("ward"),
                        rs.getString("phone"),
                        new Date(rs.getTimestamp("last_updated").getTime())
                    ));
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
}
