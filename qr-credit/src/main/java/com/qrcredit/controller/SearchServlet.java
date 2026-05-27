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
        
        if (id != null && !id.trim().isEmpty()) {
            Profile p = profileDAO.getProfileById(id.trim());
            if (p != null) {
                // Luôn chuyển hướng mã QR sang Cổng khách hàng mới (bảo mật bằng Khuôn mặt hoặc OTP)
                response.sendRedirect("portal?token=" + p.getSecretLinkToken());
                return;
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
                    // Chưa xác thực -> Bắt buộc qua cổng bảo mật Portal (FaceID / OTP)
                    response.sendRedirect("portal?token=" + firstProfile.getSecretLinkToken());
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
