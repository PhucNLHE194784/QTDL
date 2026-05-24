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
    private Date lastUpdated;

    public Profile() {}

    public Profile(String id, String customerName, String cccd, double amount, String purpose, String status, String region, String ward, Date lastUpdated) {
        this.id = id;
        this.customerName = customerName;
        this.cccd = cccd;
        this.amount = amount;
        this.purpose = purpose;
        this.status = status;
        this.region = region;
        this.ward = ward;
        this.lastUpdated = lastUpdated;
    }

    public Profile(String id, String customerName, String cccd, double amount, String purpose, String status, Date lastUpdated) {
        this.id = id;
        this.customerName = customerName;
        this.cccd = cccd;
        this.amount = amount;
        this.purpose = purpose;
        this.status = status;
        this.region = "";
        this.ward = "";
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
    public Date getLastUpdated() { return lastUpdated; }
    public void setLastUpdated(Date lastUpdated) { this.lastUpdated = lastUpdated; }
}
