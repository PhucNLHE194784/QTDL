package com.qrcredit.model;
import java.util.Date;

public class AuditLog {
    private int id;
    private String profileId;
    private int userId;
    private String userFullName;
    private String oldStatus;
    private String newStatus;
    private Date updatedAt;

    public AuditLog() {}

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public String getProfileId() { return profileId; }
    public void setProfileId(String profileId) { this.profileId = profileId; }
    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }
    public String getUserFullName() { return userFullName; }
    public void setUserFullName(String userFullName) { this.userFullName = userFullName; }
    public String getOldStatus() { return oldStatus; }
    public void setOldStatus(String oldStatus) { this.oldStatus = oldStatus; }
    public String getNewStatus() { return newStatus; }
    public void setNewStatus(String newStatus) { this.newStatus = newStatus; }
    public Date getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(Date updatedAt) { this.updatedAt = updatedAt; }
}
