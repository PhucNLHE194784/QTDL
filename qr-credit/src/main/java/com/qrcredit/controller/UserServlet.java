package com.qrcredit.controller;

import com.qrcredit.dao.UserDAO;
import com.qrcredit.model.User;
import java.io.IOException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/users")
public class UserServlet extends HttpServlet {
    private UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        User user = (User) request.getSession().getAttribute("user");
        if (user == null || !"ADMIN".equals(user.getRole())) {
            response.sendRedirect("dashboard.jsp");
            return;
        }
        
        List<User> users = userDAO.getAllUsers();
        List<User> lockedUsers = userDAO.getLockedOrDeletedUsers();
        request.setAttribute("users", users);
        request.setAttribute("lockedUsers", lockedUsers);
        request.getRequestDispatcher("users.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        User user = (User) request.getSession().getAttribute("user");
        if (user == null || !"ADMIN".equals(user.getRole())) {
            response.sendRedirect("dashboard.jsp");
            return;
        }

        String action = request.getParameter("action");
        if ("create".equals(action)) {
            User newUser = new User(0, 
                request.getParameter("username"),
                request.getParameter("password"),
                request.getParameter("role"),
                request.getParameter("fullname"),
                "ACTIVE"
            );
            userDAO.createUser(newUser);
        } else if ("delete".equals(action)) {
            int id = Integer.parseInt(request.getParameter("id"));
            userDAO.deleteUser(id);
        } else if ("lock_temp".equals(action)) {
            int id = Integer.parseInt(request.getParameter("id"));
            userDAO.updateStatus(id, "LOCKED_TEMP");
        } else if ("lock_perm".equals(action)) {
            int id = Integer.parseInt(request.getParameter("id"));
            userDAO.updateStatus(id, "LOCKED_PERM");
        } else if ("soft_delete".equals(action)) {
            int id = Integer.parseInt(request.getParameter("id"));
            userDAO.updateStatus(id, "DELETED");
        } else if ("unlock".equals(action) || "restore".equals(action)) {
            int id = Integer.parseInt(request.getParameter("id"));
            userDAO.updateStatus(id, "ACTIVE");
        }
        
        response.sendRedirect("users");
    }
}
