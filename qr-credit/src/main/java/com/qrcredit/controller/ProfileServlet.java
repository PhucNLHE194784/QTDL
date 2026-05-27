package com.qrcredit.controller;

import com.qrcredit.dao.AuditLogDAO;
import com.qrcredit.dao.ProfileDAO;
import com.qrcredit.model.AuditLog;
import com.qrcredit.model.Profile;
import com.qrcredit.model.User;
import java.io.IOException;
import java.util.Date;
import java.util.List;
import java.util.UUID;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/profile")
public class ProfileServlet extends HttpServlet {
    private ProfileDAO profileDAO = new ProfileDAO();
    private AuditLogDAO auditLogDAO = new AuditLogDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String id = request.getParameter("id");
        if (id != null) {
            Profile p = profileDAO.getProfileById(id);
            List<AuditLog> logs = auditLogDAO.getLogsByProfileId(id);
            request.setAttribute("profile", p);
            request.setAttribute("logs", logs);
            
            User user = (User) request.getSession().getAttribute("user");
            if (user == null) {
                // Not logged in, save url and ask for login
                request.getSession().setAttribute("redirectAfterLogin", "profile?id=" + id);
                response.sendRedirect("login.jsp");
                return;
            }
            request.getRequestDispatcher("profile_detail.jsp").forward(request, response);
        } else {
            response.sendRedirect("dashboard.jsp");
        }
    }

    private String capitalizeWords(String str) {
        if (str == null || str.trim().isEmpty()) return "";
        String[] words = str.trim().split("\\s+");
        StringBuilder sb = new StringBuilder();
        for (String word : words) {
            if (word.length() > 0) {
                sb.append(Character.toUpperCase(word.charAt(0))).append(word.substring(1).toLowerCase()).append(" ");
            }
        }
        return sb.toString().trim();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        User user = (User) request.getSession().getAttribute("user");
        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String action = request.getParameter("action");
        if ("create".equals(action)) {
            String username = user.getUsername();
            Profile p = new Profile();
            String uniqueID = UUID.randomUUID().toString().substring(0, 8).toUpperCase();
            p.setId("HS-" + uniqueID);
            p.setCustomerName(capitalizeWords(request.getParameter("customerName")));
            p.setCccd(request.getParameter("cccd"));
            p.setAmount(Double.parseDouble(request.getParameter("amount")));
            p.setPurpose(request.getParameter("purpose"));
            p.setStatus("Đã tiếp nhận");
            p.setRegion(request.getParameter("region") != null ? request.getParameter("region") : "");
            p.setWard(request.getParameter("ward") != null ? request.getParameter("ward") : "");
            p.setPhone(request.getParameter("phone") != null ? request.getParameter("phone") : "");
            p.setEmail(request.getParameter("email") != null ? request.getParameter("email") : "");
            p.setCreditScore((int)(Math.random() * 81) + 20); // Random 20 to 100
            p.setCreatedBy(user.getUsername());
            p.setLastUpdated(new Date());

            // Thiết lập các trường mới cho Cổng Khách hàng
            String token = UUID.randomUUID().toString();
            p.setSecretLinkToken(token);
            p.setMaturityDate(new Date(System.currentTimeMillis() + 31536000000L)); // +1 year (giả lập)
            p.setInterestRate("10.5% / năm"); // (giả lập)
            p.setOfficerName("Nguyễn Lâm Phúc"); // Tên cán bộ mặc định hoặc lấy từ user
            p.setOtpWrongAttempts(0);
            
            String otp = String.format("%06d", new java.util.Random().nextInt(999999));
            p.setOtpCode(otp);
            p.setOtpExpiry(new Date(System.currentTimeMillis() + 180000)); // 3 mins

            if (profileDAO.addProfile(p)) {
                auditLogDAO.logAction(p.getId(), user.getId(), "", "Đã tiếp nhận");
                
                // Lấy cấu hình phương thức gửi
                com.qrcredit.dao.SettingDAO settingDAO = new com.qrcredit.dao.SettingDAO();
                String method = settingDAO.getSetting("OTP_METHOD");
                String domain = request.getRequestURL().toString().replace(request.getRequestURI(), request.getContextPath());

                // Chạy gửi Email/SMS ở background (Asynchronous) để không làm đơ trang web
                new Thread(() -> {
                    if ("SMS".equals(method) && p.getPhone() != null && !p.getPhone().isEmpty()) {
                        com.qrcredit.util.SmsService.sendPortalSms(p.getPhone(), otp, token, "Đã tiếp nhận", domain);
                    } else if (p.getEmail() != null && !p.getEmail().isEmpty()) {
                        com.qrcredit.util.EmailService.sendPortalEmail(p.getEmail(), otp, token, "Đã tiếp nhận", domain);
                    }
                }).start();

                response.sendRedirect("profile?id=" + p.getId() + "&sent=true");
            } else {
                request.setAttribute("error", "Lỗi tạo hồ sơ!");
                request.getRequestDispatcher("create_profile.jsp").forward(request, response);
            }
        } else if ("updateStatus".equals(action)) {
            String id = request.getParameter("id");
            String newStatus = request.getParameter("newStatus");
            Profile p = profileDAO.getProfileById(id);
            if (p != null) {
                String oldStatus = p.getStatus();
                if (profileDAO.updateStatus(id, newStatus)) {
                    auditLogDAO.logAction(id, user.getId(), oldStatus, newStatus);
                    
                    // Sinh OTP mới và Gửi Email/SMS khi cập nhật trạng thái
                    com.qrcredit.dao.SettingDAO settingDAO = new com.qrcredit.dao.SettingDAO();
                    String method = settingDAO.getSetting("OTP_METHOD");

                    if (p.getEmail() != null || p.getPhone() != null) {
                        String otp = String.format("%06d", new java.util.Random().nextInt(999999));
                        profileDAO.updateOtpCode(id, otp, new Date(System.currentTimeMillis() + 180000)); // 3 mins
                        profileDAO.updateOtpWrongAttempts(id, 0); // Reset attempts
                        
                        String domain = request.getRequestURL().toString().replace(request.getRequestURI(), request.getContextPath());
                        
                        // Chạy nền
                        new Thread(() -> {
                            if ("SMS".equals(method) && p.getPhone() != null && !p.getPhone().isEmpty()) {
                                com.qrcredit.util.SmsService.sendPortalSms(p.getPhone(), otp, p.getSecretLinkToken(), newStatus, domain);
                            } else if (p.getEmail() != null && !p.getEmail().isEmpty()) {
                                com.qrcredit.util.EmailService.sendPortalEmail(p.getEmail(), otp, p.getSecretLinkToken(), newStatus, domain);
                            }
                        }).start();
                    }
                }
            }
            response.sendRedirect("profile?id=" + id + "&sent=true");
        } else if ("soft_delete".equals(action)) {
            if ("ADMIN".equals(user.getRole()) || "LANH_DAO".equals(user.getRole())) {
                String id = request.getParameter("id");
                profileDAO.softDeleteProfile(id);
                auditLogDAO.logAction(id, user.getId(), "Đang hoạt động", "Đã xóa (Thùng rác)");
            }
            response.sendRedirect("dashboard.jsp");
        } else if ("restore".equals(action)) {
            if ("ADMIN".equals(user.getRole()) || "LANH_DAO".equals(user.getRole())) {
                String id = request.getParameter("id");
                profileDAO.restoreProfile(id);
                auditLogDAO.logAction(id, user.getId(), "Đã xóa (Thùng rác)", "Khôi phục");
            }
            response.sendRedirect("recycle_bin.jsp");
        } else if ("hard_delete".equals(action)) {
            if ("ADMIN".equals(user.getRole())) {
                String id = request.getParameter("id");
                profileDAO.hardDeleteProfile(id);
            }
            response.sendRedirect("recycle_bin.jsp");
        }
    }
}
