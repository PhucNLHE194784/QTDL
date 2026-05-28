package com.qrcredit.controller;

import com.qrcredit.dao.ProfileDAO;
import com.qrcredit.model.Profile;
import com.qrcredit.util.EmailService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.Date;
import java.util.Random;

@WebServlet("/portal")
public class PortalServlet extends HttpServlet {
    private ProfileDAO profileDAO;

    @Override
    public void init() throws ServletException {
        profileDAO = new ProfileDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String token = request.getParameter("token");
        if (token == null || token.trim().isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Link không hợp lệ");
            return;
        }

        Profile p = profileDAO.getProfileByToken(token);
        if (p == null) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "Không tìm thấy hồ sơ");
            return;
        }

        com.qrcredit.dao.SettingDAO settingDAO = new com.qrcredit.dao.SettingDAO();
        String method = settingDAO.getSetting("OTP_METHOD");
        request.setAttribute("otpMethod", method);

        request.setAttribute("token", token);
        
        if (p.getOtpWrongAttempts() >= 3) {
            request.setAttribute("locked", true);
            request.setAttribute("error", "Bạn đã nhập sai quá 3 lần. Vui lòng bấm 'Yêu cầu cấp lại mã OTP' để nhận mã mới.");
        } else {
            if ("SMS".equals(method) && p.getPhone() != null && !p.getPhone().isEmpty()) {
                String maskedPhone = p.getPhone().replaceAll(".(?=.{3})", "*");
                request.setAttribute("maskedContact", maskedPhone);
            } else {
                String maskedEmail = p.getEmail() != null ? p.getEmail().replaceAll("(^[^@]{3}|(?!^)\\G)[^@]", "$1*") : "chưa cấu hình";
                request.setAttribute("maskedContact", maskedEmail);
            }
            request.setAttribute("locked", false);
        }

        if (p.getFaceDescriptor() != null && !p.getFaceDescriptor().trim().isEmpty()) {
            request.setAttribute("useFaceId", true);
        }

        request.getRequestDispatcher("portal.jsp").forward(request, response);
    }

    private float[] parseDescriptor(String jsonStr) {
        if (jsonStr == null || jsonStr.isEmpty()) return new float[0];
        String clean = jsonStr.replace("[", "").replace("]", "").trim();
        if (clean.isEmpty()) return new float[0];
        String[] parts = clean.split(",");
        float[] result = new float[parts.length];
        for (int i=0; i<parts.length; i++) {
            result[i] = Float.parseFloat(parts[i].trim());
        }
        return result;
    }

    private double calculateEuclideanDistance(float[] d1, float[] d2) {
        if (d1.length == 0 || d2.length == 0 || d1.length != d2.length) return 999.0;
        double sum = 0.0;
        for (int i = 0; i < d1.length; i++) {
            double diff = d1[i] - d2[i];
            sum += diff * diff;
        }
        return Math.sqrt(sum);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String token = request.getParameter("token");
        String action = request.getParameter("action");
        
        if (token == null || token.trim().isEmpty()) {
            response.sendRedirect("index.jsp");
            return;
        }

        Profile p = profileDAO.getProfileByToken(token);
        if (p == null) {
            response.sendRedirect("index.jsp");
            return;
        }

        com.qrcredit.dao.SettingDAO settingDAO = new com.qrcredit.dao.SettingDAO();
        String method = settingDAO.getSetting("OTP_METHOD");

        if ("verifyFace".equals(action)) {
            String liveDescStr = request.getParameter("liveDescriptor");
            float[] liveDesc = parseDescriptor(liveDescStr);
            float[] refDesc = parseDescriptor(p.getFaceDescriptor());
            
            double distance = calculateEuclideanDistance(liveDesc, refDesc);
            System.out.println("FACE ID DISTANCE: " + distance);
            
            if (distance < 0.55) { // Ngưỡng phù hợp với thực tế (0.55)
                java.util.List<Profile> results = profileDAO.getProfilesByCccd(p.getCccd());
                request.setAttribute("profiles", results);
                request.setAttribute("currentProfile", p);
                request.getRequestDispatcher("portal_detail.jsp").forward(request, response);
                return;
            } else {
                request.setAttribute("error", "Từ chối truy cập! Phát hiện khuôn mặt không khớp. Độ sai lệch: " + String.format("%.2f", distance) + " (Ngưỡng cho phép: < 0.55). Vui lòng thử lại trong điều kiện đủ sáng.");
                request.setAttribute("useFaceId", true);
                request.setAttribute("token", token);
                request.getRequestDispatcher("portal.jsp").forward(request, response);
                return;
            }
        } else if ("verify".equals(action)) {
            if (p.getOtpWrongAttempts() >= 3) {
                response.sendRedirect("portal?token=" + token);
                return;
            }

            String enteredOtp = request.getParameter("otp");
            Date now = new Date();

            if (p.getOtpCode() != null && enteredOtp != null && p.getOtpCode().equals(enteredOtp.trim())) {
                if (p.getOtpExpiry() != null && p.getOtpExpiry().after(now)) {
                    // OTP đúng và còn hạn
                    profileDAO.updateOtpWrongAttempts(p.getId(), 0); // Reset
                    
                    // Lấy tất cả hồ sơ của người này theo CCCD
                    java.util.List<Profile> results = profileDAO.getProfilesByCccd(p.getCccd());
                    request.setAttribute("profiles", results);
                    request.setAttribute("currentProfile", p); // Hồ sơ đang được link tới
                    
                    request.getRequestDispatcher("portal_detail.jsp").forward(request, response);
                    return;
                } else {
                    request.setAttribute("error", "Mã OTP đã hết hạn (quá 3 phút). Vui lòng yêu cầu cấp lại.");
                }
            } else {
                // Sai OTP
                int attempts = p.getOtpWrongAttempts() + 1;
                profileDAO.updateOtpWrongAttempts(p.getId(), attempts);
                if (attempts >= 3) {
                    request.setAttribute("error", "Bạn đã nhập sai 3 lần. Hệ thống đã khóa tạm thời. Vui lòng bấm 'Yêu cầu cấp lại mã OTP'.");
                    request.setAttribute("locked", true);
                } else {
                    request.setAttribute("error", "Mã OTP không đúng. Bạn còn " + (3 - attempts) + " lần thử.");
                    request.setAttribute("locked", false);
                }
            }
            
            request.setAttribute("otpMethod", method);
            if ("SMS".equals(method) && p.getPhone() != null && !p.getPhone().isEmpty()) {
                request.setAttribute("maskedContact", p.getPhone().replaceAll(".(?=.{3})", "*"));
            } else {
                request.setAttribute("maskedContact", p.getEmail() != null ? p.getEmail().replaceAll("(^[^@]{3}|(?!^)\\G)[^@]", "$1*") : "chưa cấu hình");
            }
            request.setAttribute("token", token);
            request.getRequestDispatcher("portal.jsp").forward(request, response);

        } else if ("resend".equals(action)) {
            // Cấp lại OTP
            String otp = String.format("%06d", new java.util.Random().nextInt(999999));
            profileDAO.updateOtpCode(p.getId(), otp, new Date(System.currentTimeMillis() + 180000));
            profileDAO.updateOtpWrongAttempts(p.getId(), 0);
            
            String domain = request.getRequestURL().toString().replace(request.getRequestURI(), request.getContextPath());
            
            if ("SMS".equals(method) && p.getPhone() != null && !p.getPhone().isEmpty()) {
                com.qrcredit.util.SmsService.sendPortalSms(p.getPhone(), otp, token, "Cấp lại mã OTP", domain);
                request.setAttribute("message", "Mã OTP mới đã được gửi qua SMS đến điện thoại của bạn.");
            } else if (p.getEmail() != null && !p.getEmail().isEmpty()) {
                com.qrcredit.util.EmailService.sendPortalEmail(p.getEmail(), otp, token, "Cấp lại mã OTP", domain);
                request.setAttribute("message", "Mã OTP mới đã được gửi đến email của bạn.");
            } else {
                request.setAttribute("error", "Hồ sơ chưa có Email/SĐT để gửi.");
            }
            
            response.sendRedirect("portal?token=" + token);
        }
    }
}
