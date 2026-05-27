<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ page import="com.qrcredit.dao.ProfileDAO" %>
<%@ page import="com.qrcredit.model.Profile" %>
<%@ page import="com.qrcredit.model.User" %>
<%@ page import="java.util.List" %>
<%
    User sessionUser = (User) session.getAttribute("user");
    if(sessionUser == null || (!"ADMIN".equals(sessionUser.getRole()) && !"LANH_DAO".equals(sessionUser.getRole()))) {
        response.sendRedirect("dashboard.jsp");
        return;
    }
    ProfileDAO dao = new ProfileDAO();
    List<Profile> deletedProfiles = dao.getDeletedProfiles();
    request.setAttribute("deletedProfiles", deletedProfiles);
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Thùng Rác Hồ Sơ - AgriQR LoanFlow</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.datatables.net/1.13.6/css/dataTables.bootstrap5.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        :root {
            --agri-red: #A51A29;
            --agri-red-dark: #8E1521;
            --agri-yellow: #f1c40f;
            --sidebar-width: 260px;
        }
        body { font-family: 'Inter', sans-serif; background: #f4f6f9; min-height: 100vh; overflow-x: hidden; }
        
        /* Sidebar */
        .sidebar {
            width: var(--sidebar-width);
            background: var(--agri-red-dark);
            color: white;
            position: fixed;
            height: 100vh;
            top: 0; left: 0;
            z-index: 1000;
            transition: all 0.3s;
            box-shadow: 2px 0 10px rgba(0,0,0,0.1);
        }
        .sidebar-brand {
            padding: 20px;
            font-size: 1.4rem;
            font-weight: 700;
            border-bottom: 1px solid rgba(255,255,255,0.1);
            display: flex;
            align-items: center;
            gap: 10px;
        }
        .sidebar-brand i { color: var(--agri-yellow); font-size: 1.6rem; }
        
        .sidebar-menu { list-style: none; padding: 20px 0; margin: 0; }
        .sidebar-menu li { padding: 0 15px; margin-bottom: 5px; }
        .sidebar-link {
            display: flex; align-items: center; gap: 12px;
            color: rgba(255,255,255,0.8);
            padding: 12px 20px;
            text-decoration: none;
            border-radius: 8px;
            font-weight: 500;
            transition: 0.3s;
        }
        .sidebar-link:hover, .sidebar-link.active {
            background: rgba(255,255,255,0.1);
            color: white;
        }
        .sidebar-link.active {
            border-left: 4px solid var(--agri-yellow);
        }
        
        /* Main Content */
        .main-content {
            margin-left: var(--sidebar-width);
            min-height: 100vh;
            display: flex;
            flex-direction: column;
        }
        
        /* Navbar */
        .top-navbar { 
            background: white; 
            padding: 15px 25px; 
            box-shadow: 0 2px 10px rgba(0,0,0,0.05); 
            display: flex;
            justify-content: flex-end;
            align-items: center;
            margin-bottom: 30px;
        }

        .card { 
            border: none; 
            border-radius: 12px; 
            background: white;
            box-shadow: 0 5px 20px rgba(0,0,0,0.05); 
            margin-bottom: 24px; 
        }
        .card-header { background-color: transparent; border-bottom: 1px solid #eee; font-weight: 700; padding: 16px 24px; font-size: 1.1rem; color: var(--agri-red); }
        .table { margin-bottom: 0; }
        .table th { background-color: #f8f9fa; color: #555; font-weight: 600; font-size: 0.8rem; text-transform: uppercase; border-bottom: 2px solid #eee; padding: 15px; }
        .table td { vertical-align: middle; padding: 15px; font-size: 0.95rem; border-color: #eee; }
        
        .badge { padding: 6px 12px; border-radius: 6px; font-weight: 600; }
        .badge-soft-danger { background: #fce8e6; color: #d93025; }
        .btn-action { border-radius: 8px; padding: 6px 15px; font-weight: 500; font-size: 0.85rem; }
        .money-text { font-family: 'Courier New', Courier, monospace; font-weight: 700; color: #198754; }

        @media (max-width: 768px) {
            .sidebar { transform: translateX(-100%); }
            .sidebar.show { transform: translateX(0); }
            .main-content { margin-left: 0; }
        }
    </style>
</head>
<body>
    <!-- Sidebar -->
    <div class="sidebar">
        <div class="sidebar-brand text-center d-block">
            <a href="index.jsp"><img src="assets/img/agribank_logo.png" alt="Agribank" style="height: 45px; background: white; padding: 5px; border-radius: 5px; max-width: 100%;"></a>
        </div>
        <ul class="sidebar-menu">
            <li><a href="dashboard.jsp" class="sidebar-link"><i class="fa-solid fa-chart-pie w-20px text-center"></i> Bảng điều khiển</a></li>
            <c:if test="${user.role eq 'GDV'}">
                <li><a href="create_profile.jsp" class="sidebar-link"><i class="fa-solid fa-plus w-20px text-center"></i> Tạo Hồ sơ mới</a></li>
            </c:if>
            <c:if test="${user.role eq 'ADMIN'}">
                <li class="mt-4 px-3 mb-2 text-uppercase" style="font-size: 0.75rem; opacity: 0.6; font-weight: 700;">Quản trị hệ thống</li>
                <li><a href="users" class="sidebar-link"><i class="fa-solid fa-users w-20px text-center"></i> Quản lý Nhân sự</a></li>
            </c:if>
            <c:if test="${user.role eq 'ADMIN' || user.role eq 'LANH_DAO'}">
                <li><a href="recycle_bin.jsp" class="sidebar-link active"><i class="fa-solid fa-trash-can w-20px text-center"></i> Thùng rác (Hồ sơ)</a></li>
            </c:if>
        </ul>
    </div>

    <!-- Main Content -->
    <div class="main-content">
        <!-- Top Navbar -->
        <div class="top-navbar">
            <div class="d-flex align-items-center w-100">
                <button class="btn btn-light d-md-none me-auto shadow-sm" id="sidebarToggle"><i class="fa-solid fa-bars"></i></button>
                <div class="text-end ms-auto me-3">
                    <div class="fw-bold text-dark" style="font-size: 0.95rem;">${user.fullname}</div>
                    <div class="text-muted" style="font-size: 0.8rem;"><i class="fa-solid fa-id-badge me-1 text-warning"></i>${user.role}</div>
                </div>
                <div class="dropdown">
                    <button class="btn btn-light rounded-circle shadow-sm" type="button" data-bs-toggle="dropdown" style="width: 45px; height: 45px;">
                        <i class="fa-solid fa-user text-primary" style="color: var(--agri-red);"></i>
                    </button>
                    <ul class="dropdown-menu dropdown-menu-end shadow border-0 mt-2">
                        <li><a class="dropdown-item text-danger fw-bold" href="auth?action=logout"><i class="fa-solid fa-power-off me-2"></i>Đăng xuất</a></li>
                    </ul>
                </div>
            </div>
        </div>

    <div class="container-fluid px-4 mb-5">
        <div class="d-flex justify-content-between align-items-end mb-4">
            <div>
                <h2 class="fw-bold text-danger mb-1"><i class="fa-solid fa-trash-can me-2"></i>Thùng Rác Hồ Sơ</h2>
                <p class="text-muted mb-0">Hồ sơ đã bị xóa có thể được khôi phục hoặc xóa vĩnh viễn</p>
            </div>
        </div>

        <!-- Bảng Dữ Liệu -->
        <div class="card">
            <div class="card-body p-0">
                <div class="table-responsive">
                    <table id="profileTable" class="table table-hover w-100">
                        <thead>
                            <tr>
                                <th style="width: 12%;">Mã Hồ Sơ</th>
                                <th style="width: 18%;">Khách Hàng</th>
                                <th style="width: 15%;">Liên Hệ</th>
                                <th style="width: 15%;">Số Tiền Vay</th>
                                <th style="width: 15%;">Trạng Thái Cũ</th>
                                <th style="width: 15%;">Ngày Xóa</th>
                                <th style="width: 10%; text-align: right;">Thao Tác</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="p" items="${deletedProfiles}">
                                <tr>
                                    <td><span class="fw-bold text-dark">${p.id}</span></td>
                                    <td>
                                        <div class="fw-bold text-primary text-capitalize">${p.customerName}</div>
                                        <div class="small text-muted"><i class="fa-regular fa-id-card me-1"></i>${p.cccd}</div>
                                    </td>
                                    <td>
                                        <div class="fw-semibold text-dark"><i class="fa-solid fa-phone me-1"></i>${not empty p.phone ? p.phone : 'Chưa có'}</div>
                                    </td>
                                    <td>
                                        <span class="money-text">
                                            <fmt:formatNumber value="${p.amount}" pattern="#,###" /> đ
                                        </span>
                                    </td>
                                    <td>
                                        <span class="badge badge-soft-danger"><i class="fa-solid fa-ban me-1"></i>${p.status}</span>
                                    </td>
                                    <td data-order="${p.lastUpdated.time}">
                                        <div class="fw-semibold text-dark"><fmt:formatDate value="${p.lastUpdated}" pattern="dd/MM/yyyy" /></div>
                                        <div class="small text-muted"><fmt:formatDate value="${p.lastUpdated}" pattern="HH:mm:ss" /></div>
                                    </td>
                                    <td class="text-end">
                                        <form action="profile" method="post" class="d-inline" onsubmit="return confirmRestore(event, this);">
                                            <input type="hidden" name="action" value="restore">
                                            <input type="hidden" name="id" value="${p.id}">
                                            <button type="submit" class="btn btn-outline-success btn-sm btn-action mb-1" title="Khôi phục"><i class="fa-solid fa-rotate-left"></i></button>
                                        </form>
                                        <c:if test="${user.role eq 'ADMIN'}">
                                            <form action="profile" method="post" class="d-inline" onsubmit="return confirmHardDelete(event, this);">
                                                <input type="hidden" name="action" value="hard_delete">
                                                <input type="hidden" name="id" value="${p.id}">
                                                <button type="submit" class="btn btn-outline-danger btn-sm btn-action mb-1" title="Xóa vĩnh viễn"><i class="fa-solid fa-fire"></i></button>
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

    <!-- Scripts -->
    <script src="https://code.jquery.com/jquery-3.7.0.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://cdn.datatables.net/1.13.6/js/jquery.dataTables.min.js"></script>
    <script src="https://cdn.datatables.net/1.13.6/js/dataTables.bootstrap5.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <script>
        $(document).ready(function() {
            $('#profileTable').DataTable({
                "language": {
                    "url": "//cdn.datatables.net/plug-ins/1.13.6/i18n/vi.json"
                },
                "order": [[ 5, "desc" ]],
                "pageLength": 10,
                "responsive": true
            });
        });

        function confirmRestore(event, form) {
            event.preventDefault();
            Swal.fire({
                title: 'Khôi phục hồ sơ?',
                text: "Hồ sơ này sẽ được khôi phục trở lại hệ thống.",
                icon: 'info',
                showCancelButton: true,
                confirmButtonColor: '#198754',
                cancelButtonColor: '#6c757d',
                confirmButtonText: 'Khôi phục',
                cancelButtonText: 'Hủy bỏ'
            }).then((result) => {
                if (result.isConfirmed) {
                    form.submit();
                }
            });
            return false;
        }

        function confirmHardDelete(event, form) {
            event.preventDefault();
            Swal.fire({
                title: 'CẢNH BÁO: Xóa Vĩnh Viễn?',
                text: "Hành động này sẽ XÓA VĨNH VIỄN hồ sơ và không thể khôi phục. Tiếp tục?",
                icon: 'error',
                showCancelButton: true,
                confirmButtonColor: '#d33',
                cancelButtonColor: '#6c757d',
                confirmButtonText: 'Xóa vĩnh viễn',
                cancelButtonText: 'Hủy bỏ'
            }).then((result) => {
                if (result.isConfirmed) {
                    form.submit();
                }
            });
            return false;
        }

        $('#sidebarToggle').on('click', function() {
            $('.sidebar').toggleClass('show');
        });
    </script>
    </div>
</body>
</html>
