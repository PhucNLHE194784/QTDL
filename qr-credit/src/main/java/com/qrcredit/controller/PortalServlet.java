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

        request.setAttribute("token", token);
        
        if (p.getOtpWrongAttempts() >= 3) {
            request.setAttribute("locked", true);
            request.setAttribute("error", "Bạn đã nhập sai quá 3 lần. Vui lòng bấm 'Yêu cầu cấp lại mã OTP' để nhận mã mới.");
        } else {
            String maskedEmail = p.getEmail().replaceAll("(^[^@]{3}|(?!^)\\G)[^@]", "$1*");
            request.setAttribute("maskedEmail", maskedEmail);
            request.setAttribute("locked", false);
        }

        request.getRequestDispatcher("portal.jsp").forward(request, response);
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

        if ("verify".equals(action)) {
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
            
            String maskedEmail = p.getEmail().replaceAll("(^[^@]{3}|(?!^)\\G)[^@]", "$1*");
            request.setAttribute("maskedEmail", maskedEmail);
            request.setAttribute("token", token);
            request.getRequestDispatcher("portal.jsp").forward(request, response);

        } else if ("resend".equals(action)) {
            // Cấp lại OTP
            String otp = String.format("%06d", new Random().nextInt(999999));
            profileDAO.updateOtpCode(p.getId(), otp, new Date(System.currentTimeMillis() + 180000));
            profileDAO.updateOtpWrongAttempts(p.getId(), 0);
            
            String domain = request.getRequestURL().toString().replace(request.getRequestURI(), request.getContextPath());
            EmailService.sendPortalEmail(p.getEmail(), otp, token, "Cấp lại mã OTP", domain);
            
            request.setAttribute("message", "Mã OTP mới đã được gửi đến email của bạn.");
            response.sendRedirect("portal?token=" + token);
        }
    }
}
