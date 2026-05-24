<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%
    if(session.getAttribute("user") == null) {
        response.sendRedirect("login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản lý Nhân sự - AgriQR LoanFlow</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        body { background: linear-gradient(135deg, #fdfbfb 0%, #ebedee 100%); font-family: 'Inter', sans-serif; min-height: 100vh; }
        .navbar { background: rgba(30, 60, 114, 0.9); backdrop-filter: blur(10px); padding: 15px 0; border-bottom: 1px solid rgba(255,255,255,0.1); }
        .navbar-brand { font-size: 1.4rem; font-weight: 700; letter-spacing: 0.5px; }
        .card { 
            background: rgba(255, 255, 255, 0.85); 
            backdrop-filter: blur(15px); 
            border: 1px solid rgba(255,255,255,0.5); 
            border-radius: 16px; 
            box-shadow: 0 10px 30px rgba(0,0,0,0.03); 
            margin-bottom: 24px; 
        }
        .card-header { background-color: rgba(255,255,255,0.5); border-bottom: 1px solid rgba(0,0,0,0.05); border-radius: 16px 16px 0 0 !important; font-weight: 600; padding: 16px 24px; font-size: 1.1rem; }
        .table { margin-bottom: 0; background: transparent; }
        .table th { background-color: rgba(248, 249, 250, 0.5); color: #475569; font-weight: 600; text-transform: uppercase; font-size: 0.75rem; letter-spacing: 0.5px; padding: 15px; border-bottom-width: 1px; }
        .table td { vertical-align: middle; color: #334155; padding: 15px; font-size: 0.95rem; border-color: rgba(0,0,0,0.05); background: transparent; }
        .table-hover tbody tr:hover td { background-color: rgba(255,255,255,0.95); }
        .form-control, .form-select { border-radius: 10px; padding: 10px 15px; border: 1px solid #e2e8f0; font-size: 0.95rem; background-color: rgba(255,255,255,0.9); }
        .form-control:focus, .form-select:focus { border-color: #0d6efd; box-shadow: 0 0 0 0.2rem rgba(13,110,253,.15); }
        .badge { padding: 6px 12px; border-radius: 8px; font-weight: 600; font-size: 0.75rem; letter-spacing: 0.3px; }
    </style>
</head>
<body>
    <nav class="navbar navbar-expand-lg navbar-dark mb-4">
        <div class="container-fluid px-4">
            <a class="navbar-brand" href="#"><i class="fa-solid fa-users-gear me-2 text-warning"></i>Quản Lý Nhân Sự</a>
            <div class="d-flex align-items-center text-white">
                <a href="dashboard.jsp" class="btn btn-outline-light btn-sm fw-bold px-3 me-2" style="border-radius: 8px;"><i class="fa-solid fa-chart-pie me-1"></i>Bảng Điều Khiển</a>
                <a href="auth?action=logout" class="btn btn-light btn-sm fw-bold text-primary px-3" style="border-radius: 8px;"><i class="fa-solid fa-power-off me-1"></i>Thoát</a>
            </div>
        </div>
    </nav>

    <div class="container px-4 mb-5">
        <div class="row">
            <div class="col-md-4">
                <div class="card">
                    <div class="card-header text-primary"><i class="fa-solid fa-user-plus me-2"></i>Thêm Mới Cán Bộ</div>
                    <div class="card-body">
                        <form action="users" method="post">
                            <input type="hidden" name="action" value="create">
                            <div class="mb-3">
                                <label class="form-label fw-semibold text-secondary">Tên đăng nhập</label>
                                <input type="text" name="username" class="form-control" required>
                            </div>
                            <div class="mb-3">
                                <label class="form-label fw-semibold text-secondary">Mật khẩu</label>
                                <input type="password" name="password" class="form-control" required>
                            </div>
                            <div class="mb-3">
                                <label class="form-label fw-semibold text-secondary">Họ và tên hiển thị</label>
                                <input type="text" name="fullname" class="form-control" required>
                            </div>
                            <div class="mb-4">
                                <label class="form-label fw-semibold text-secondary">Phân quyền</label>
                                <select name="role" class="form-select" required>
                                    <option value="GDV">Giao Dịch Viên (GDV)</option>
                                    <option value="THAM_DINH">Cán bộ Thẩm Định</option>
                                    <option value="LANH_DAO">Lãnh Đạo</option>
                                </select>
                            </div>
                            <button type="submit" class="btn btn-primary w-100 fw-bold"><i class="fa-solid fa-check me-2"></i>Tạo Tài Khoản</button>
                        </form>
                    </div>
                </div>
            </div>
            <div class="col-md-8">
                <div class="card">
                    <div class="card-header text-primary"><i class="fa-solid fa-list me-2"></i>Danh Sách Tài Khoản Hệ Thống</div>
                    <div class="card-body p-0">
                        <div class="table-responsive">
                            <table class="table table-hover mb-0">
                                <thead>
                                    <tr>
                                        <th>ID</th>
                                        <th>Họ và Tên</th>
                                        <th>Tên Đăng Nhập</th>
                                        <th>Phân Quyền</th>
                                        <th class="text-end">Thao Tác</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="u" items="${users}">
                                        <tr>
                                            <td class="fw-bold">${u.id}</td>
                                            <td class="fw-semibold text-dark">${u.fullname}</td>
                                            <td><span class="badge bg-light text-dark border">${u.username}</span></td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${u.role eq 'LANH_DAO'}"><span class="badge bg-danger">LÃNH ĐẠO</span></c:when>
                                                    <c:when test="${u.role eq 'THAM_DINH'}"><span class="badge bg-warning text-dark">THẨM ĐỊNH</span></c:when>
                                                    <c:otherwise><span class="badge bg-primary">GIAO DỊCH VIÊN</span></c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td class="text-end">
                                                <c:if test="${u.username ne user.username}">
                                                    <form action="users" method="post" class="d-inline" onsubmit="return confirm('Bạn có chắc chắn muốn xóa tài khoản này?');">
                                                        <input type="hidden" name="action" value="delete">
                                                        <input type="hidden" name="id" value="${u.id}">
                                                        <button type="submit" class="btn btn-sm btn-outline-danger"><i class="fa-solid fa-trash"></i> Xóa</button>
                                                    </form>
                                                </c:if>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</body>
</html>
