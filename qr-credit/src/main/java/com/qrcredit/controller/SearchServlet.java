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
        
        if (t != null) {
            try {
                long timestamp = Long.parseLong(t);
                long diff = System.currentTimeMillis() - timestamp;
                // Nếu quét mã trễ hơn 60s hoặc lấy mã của tương lai quá 10s (chống sai lệch giờ)
                if (diff > 60000 || diff < -10000) {
                    request.setAttribute("error", "Mã QR đã hết hạn (chỉ có hiệu lực trong 60 giây vì lý do bảo mật). Vui lòng yêu cầu cấp lại mã mới.");
                    request.getRequestDispatcher("search.jsp").forward(request, response);
                    return;
                }
            } catch (Exception e) {}
        }

        if (id != null && !id.trim().isEmpty()) {
            Profile p = profileDAO.getProfileById(id.trim());
            if (p != null) {
                // Khi quét QR (có ID), tự động lấy ra tất cả hồ sơ của người đó luôn
                List<Profile> results = profileDAO.getProfilesByCccd(p.getCccd());
                maskNames(results);
                request.setAttribute("profiles", results);
                // Che luôn ô nhập CCCD trên giao diện để mượt hơn
                request.setAttribute("autoSearch", true); 
            } else {
                request.setAttribute("error", "Mã QR không hợp lệ hoặc hồ sơ không tồn tại.");
            }
        }
        request.getRequestDispatcher("search.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String id = request.getParameter("id");
        String cccdInput = request.getParameter("cccdInput");

        List<Profile> results = new ArrayList<>();

        if (id != null && !id.trim().isEmpty()) {
            Profile p = profileDAO.getProfileById(id.trim());
            if (p != null && p.getCccd().endsWith(cccdInput.trim())) {
                results = profileDAO.getProfilesByCccd(p.getCccd());
            }
        } else {
            results = profileDAO.getProfilesByCccd(cccdInput.trim());
        }

        if (!results.isEmpty()) {
            maskNames(results);
            request.setAttribute("profiles", results);
        } else {
            request.setAttribute("error", "Không tìm thấy hồ sơ. Vui lòng kiểm tra lại số CCCD.");
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
