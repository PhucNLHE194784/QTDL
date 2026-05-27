package com.qrcredit.controller;

import com.qrcredit.dao.ProfileDAO;
import com.qrcredit.model.Profile;
import com.qrcredit.util.EmailService;
import java.io.IOException;
import java.util.Random;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/otp")
public class OtpServlet extends HttpServlet {
    private ProfileDAO profileDAO = new ProfileDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String id = request.getParameter("id");
        if (id == null || id.trim().isEmpty()) {
            response.sendRedirect("search.jsp");
            return;
        }

        Profile p = profileDAO.getProfileById(id);
        if (p == null || p.getEmail() == null || p.getEmail().isEmpty()) {
            request.setAttribute("error", "Hồ sơ không tồn tại hoặc chưa đăng ký Email nhận OTP.");
            request.getRequestDispatcher("search.jsp").forward(request, response);
            return;
        }

        // Logic giới hạn 3 lần / ngày
        java.util.Date now = new java.util.Date();
        java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("yyyy-MM-dd");
        String todayStr = sdf.format(now);
        String lastOtpDateStr = p.getLastOtpDate() != null ? sdf.format(p.getLastOtpDate()) : "";

        int count = p.getOtpCount();
        if (!todayStr.equals(lastOtpDateStr)) {
            // Ngày mới -> Reset đếm
            count = 0;
        }

        if (count >= 3) {
            request.setAttribute("error", "Bạn đã vượt quá giới hạn nhận mã OTP (tối đa 3 lần/ngày). Vui lòng thử lại vào ngày mai.");
            request.getRequestDispatcher("search.jsp").forward(request, response);
            return;
        }

        // Tạo mã OTP 6 số
        String otp = String.format("%06d", new Random().nextInt(999999));
        
        // Lưu vào session
        HttpSession session = request.getSession();
        session.setAttribute("otp_" + id, otp);
        session.setAttribute("otp_time_" + id, System.currentTimeMillis());

        // Cập nhật CSDL
        profileDAO.updateOtpInfo(id, count + 1, now);

        // Gửi qua Email
        boolean sent = EmailService.sendOtpEmail(p.getEmail(), otp);
        if (sent) {
            String email = p.getEmail();
            String maskedEmail = email.replaceAll("(^[^@]{3}|(?!^)\\G)[^@]", "$1*");
            request.setAttribute("maskedEmail", maskedEmail);
            request.setAttribute("id", id);
            request.getRequestDispatcher("otp_verify.jsp").forward(request, response);
        } else {
            // Rollback count if failed (optional, but keep it simple here)
            request.setAttribute("error", "Lỗi hệ thống khi gửi Email OTP. Vui lòng liên hệ Giao dịch viên.");
            request.getRequestDispatcher("search.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String id = request.getParameter("id");
        String enteredOtp = request.getParameter("otp");
        
        HttpSession session = request.getSession();
        String savedOtp = (String) session.getAttribute("otp_" + id);
        Long otpTime = (Long) session.getAttribute("otp_time_" + id);

        if (savedOtp != null && otpTime != null && enteredOtp != null) {
            long diff = System.currentTimeMillis() - otpTime;
            if (diff > 120000) { // 2 phút
                request.setAttribute("error", "Mã OTP đã hết hạn (quá 2 phút). Vui lòng yêu cầu Gửi lại mã.");
                request.setAttribute("id", id);
                request.getRequestDispatcher("otp_verify.jsp").forward(request, response);
                return;
            }

            if (savedOtp.equals(enteredOtp.trim())) {
                // Hợp lệ, cho phép xem chi tiết tất cả hồ sơ
                session.setAttribute("verified_profile_" + id, true);
                response.sendRedirect("search?id=" + id);
                return;
            }
        }
        
        request.setAttribute("error", "Mã OTP không hợp lệ.");
        request.setAttribute("id", id);
        request.getRequestDispatcher("otp_verify.jsp").forward(request, response);
    }
}
