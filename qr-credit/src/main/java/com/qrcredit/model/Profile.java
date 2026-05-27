package com.qrcredit.model;

import java.util.Date;

public class Profile {
    private String id;
    private String customerName;
    private String cccd;
    private double amount;
    private String purpose;
    private String status;
    private String region;
    private String ward;
    private String phone;
    private String email;
    private String createdBy;
    private int creditScore;
    private boolean isDeleted;
    private Date lastUpdated;
    private int otpCount;
    private Date lastOtpDate;

    public Profile() {}

    public Profile(String id, String customerName, String cccd, double amount, String purpose, String status, String region, String ward, String phone, String email, int creditScore, boolean isDeleted, Date lastUpdated, String createdBy) {
        this.id = id;
        this.customerName = customerName;
        this.cccd = cccd;
        this.amount = amount;
        this.purpose = purpose;
        this.status = status;
        this.region = region;
        this.ward = ward;
        this.phone = phone;
        this.email = email;
        this.creditScore = creditScore;
        this.isDeleted = isDeleted;
        this.lastUpdated = lastUpdated;
        this.createdBy = createdBy;
    }

    public Profile(String id, String customerName, String cccd, double amount, String purpose, String status, String phone, String createdBy, Date lastUpdated) {
        this.id = id;
        this.customerName = customerName;
        this.cccd = cccd;
        this.amount = amount;
        this.purpose = purpose;
        this.status = status;
        this.region = "";
        this.ward = "";
        this.phone = phone;
        this.creditScore = 0;
        this.createdBy = createdBy;
        this.lastUpdated = lastUpdated;
    }

    // Getters and Setters
    public String getId() { return id; }
    public void setId(String id) { this.id = id; }
    public String getCustomerName() { return customerName; }
    public void setCustomerName(String customerName) { this.customerName = customerName; }
    public String getCccd() { return cccd; }
    public void setCccd(String cccd) { this.cccd = cccd; }
    public double getAmount() { return amount; }
    public void setAmount(double amount) { this.amount = amount; }
    public String getPurpose() { return purpose; }
    public void setPurpose(String purpose) { this.purpose = purpose; }
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    public String getRegion() { return region; }
    public void setRegion(String region) { this.region = region; }
    public String getWard() { return ward; }
    public void setWard(String ward) { this.ward = ward; }
    public String getPhone() { return phone; }
    public void setPhone(String phone) { this.phone = phone; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public int getCreditScore() { return creditScore; }
    public void setCreditScore(int creditScore) { this.creditScore = creditScore; }
    public String getCreatedBy() { return createdBy; }
    public void setCreatedBy(String createdBy) { this.createdBy = createdBy; }
    public boolean isDeleted() { return isDeleted; }
    public void setDeleted(boolean isDeleted) { this.isDeleted = isDeleted; }
    public Date getLastUpdated() { return lastUpdated; }
    public void setLastUpdated(Date lastUpdated) { this.lastUpdated = lastUpdated; }
    public int getOtpCount() { return otpCount; }
    public void setOtpCount(int otpCount) { this.otpCount = otpCount; }
    public Date getLastOtpDate() { return lastOtpDate; }
    public void setLastOtpDate(Date lastOtpDate) { this.lastOtpDate = lastOtpDate; }
}
