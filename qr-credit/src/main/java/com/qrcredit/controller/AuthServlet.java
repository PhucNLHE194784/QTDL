package com.qrcredit.controller;

import com.qrcredit.dao.UserDAO;
import com.qrcredit.model.User;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/auth")
public class AuthServlet extends HttpServlet {
    private UserDAO userDAO = new UserDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        if ("login".equals(action)) {
            User user = userDAO.login(request.getParameter("username"), request.getParameter("password"));
            if (user != null) {
                if ("ACTIVE".equals(user.getStatus())) {
                    request.getSession().setAttribute("user", user);
                    String redirect = (String) request.getSession().getAttribute("redirectAfterLogin");
                    if (redirect != null) {
                        request.getSession().removeAttribute("redirectAfterLogin");
                        response.sendRedirect(redirect);
                    } else {
                        response.sendRedirect("dashboard.jsp");
                    }
                } else if ("DELETED".equals(user.getStatus())) {
                    request.setAttribute("error", "Tài khoản của bạn đã bị xóa khỏi hệ thống.");
                    request.getRequestDispatcher("login.jsp").forward(request, response);
                } else {
                    request.setAttribute("error", "Tài khoản của bạn đã bị khóa. Vui lòng liên hệ Admin!");
                    request.getRequestDispatcher("login.jsp").forward(request, response);
                }
            } else {
                request.setAttribute("error", "Sai tên đăng nhập hoặc mật khẩu!");
                request.getRequestDispatcher("login.jsp").forward(request, response);
            }
        } else if ("logout".equals(action)) {
            request.getSession().invalidate();
            response.sendRedirect("login.jsp");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doPost(request, response);
    }
}
