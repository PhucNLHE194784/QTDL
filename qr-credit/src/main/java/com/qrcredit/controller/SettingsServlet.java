package com.qrcredit.controller;

import com.qrcredit.dao.SettingDAO;
import com.qrcredit.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/settings")
public class SettingsServlet extends HttpServlet {
    private SettingDAO settingDAO;

    @Override
    public void init() throws ServletException {
        settingDAO = new SettingDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        
        if (user == null || (!"ADMIN".equals(user.getRole()) && !"LANH_DAO".equals(user.getRole()))) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Bạn không có quyền truy cập trang này");
            return;
        }

        String email = settingDAO.getSetting("SMTP_EMAIL");
        String password = settingDAO.getSetting("SMTP_PASSWORD");
        
        request.setAttribute("smtpEmail", email);
        request.setAttribute("smtpPassword", password);
        request.getRequestDispatcher("settings.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        
        if (user == null || (!"ADMIN".equals(user.getRole()) && !"LANH_DAO".equals(user.getRole()))) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Bạn không có quyền truy cập trang này");
            return;
        }

        String email = request.getParameter("smtpEmail");
        String password = request.getParameter("smtpPassword");

        if (email != null) settingDAO.updateSetting("SMTP_EMAIL", email.trim());
        if (password != null && !password.trim().isEmpty()) {
            settingDAO.updateSetting("SMTP_PASSWORD", password.trim());
        }

        request.setAttribute("message", "Đã lưu cấu hình thành công!");
        
        // Reload to show current values
        request.setAttribute("smtpEmail", settingDAO.getSetting("SMTP_EMAIL"));
        request.setAttribute("smtpPassword", settingDAO.getSetting("SMTP_PASSWORD"));
        request.getRequestDispatcher("settings.jsp").forward(request, response);
    }
}
