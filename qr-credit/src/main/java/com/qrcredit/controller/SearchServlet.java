package com.qrcredit.controller;

import com.qrcredit.dao.ProfileDAO;
import com.qrcredit.model.Profile;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/search")
public class SearchServlet extends HttpServlet {
    private ProfileDAO profileDAO = new ProfileDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String id = request.getParameter("id");
        String t = request.getParameter("t");
        
        if (t != null && id != null) {
            try {
                long timestamp = Long.parseLong(t);
                long diff = System.currentTimeMillis() - timestamp;
                if (diff > 60000 || diff < -10000) {
                    request.setAttribute("error", "Mã QR đã hết hạn. Vui lòng yêu cầu cấp lại mã mới hoặc Tự nhập Số CCCD để tra cứu tại nhà.");
                    request.getRequestDispatcher("search.jsp").forward(request, response);
                    return;
                } else {
                    // Quét QR trực tiếp tại quầy -> Hợp lệ -> Đánh dấu xác thực luôn
                    request.getSession().setAttribute("verified_profile_" + id.trim(), true);
                }
            } catch (Exception e) {}
        }

        if (id != null && !id.trim().isEmpty()) {
            Profile p = profileDAO.getProfileById(id.trim());
            if (p != null) {
                javax.servlet.http.HttpSession session = request.getSession();
                Boolean verified = (Boolean) session.getAttribute("verified_profile_" + p.getId());
                
                if (verified != null && verified) {
                    List<Profile> results = profileDAO.getProfilesByCccd(p.getCccd());
                    request.setAttribute("profiles", results);
                    request.setAttribute("autoSearch", true); 
                } else {
                    // Tới link ID nhưng chưa xác thực (VD lưu link cũ) -> Đẩy ra màn nhập CCCD hoặc chuyển sang OTP
                    response.sendRedirect("otp?id=" + p.getId());
                    return;
                }
            } else {
                request.setAttribute("error", "Mã QR không hợp lệ hoặc hồ sơ không tồn tại.");
            }
        }
        request.getRequestDispatcher("search.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String cccdInput = request.getParameter("cccdInput");

        if (cccdInput != null && !cccdInput.trim().isEmpty()) {
            List<Profile> results = profileDAO.getProfilesByCccd(cccdInput.trim());
            
            if (!results.isEmpty()) {
                Profile firstProfile = results.get(0);
                javax.servlet.http.HttpSession session = request.getSession();
                Boolean verified = (Boolean) session.getAttribute("verified_profile_" + firstProfile.getId());
                
                if (verified != null && verified) {
                    request.setAttribute("profiles", results);
                } else {
                    // Chưa xác thực OTP -> Bắt buộc gửi OTP qua email
                    response.sendRedirect("otp?id=" + firstProfile.getId());
                    return;
                }
            } else {
                request.setAttribute("error", "Không tìm thấy hồ sơ. Vui lòng kiểm tra lại số CCCD.");
            }
        }
        
        request.getRequestDispatcher("search.jsp").forward(request, response);
    }

    private void maskNames(List<Profile> results) {
        for (Profile p : results) {
            String[] parts = p.getCustomerName().split(" ");
            StringBuilder maskedName = new StringBuilder();
            for (String part : parts) {
                if (part.length() > 0) {
                    maskedName.append(part.charAt(0));
                    for (int i = 1; i < part.length(); i++) maskedName.append("*");
                    maskedName.append(" ");
                }
            }
            p.setCustomerName(maskedName.toString().trim());
        }
    }
}
