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
        
        .form-control, .form-select { border-radius: 8px; border: 1px solid #ddd; padding: 10px 15px; }
        .form-control:focus, .form-select:focus { border-color: var(--agri-red); box-shadow: 0 0 0 0.2rem rgba(165, 26, 41, 0.15); }
        .badge { padding: 6px 12px; border-radius: 6px; font-weight: 600; }
        .badge-soft-warning { background: #fef7e0; color: #b06000; }
        .badge-soft-danger { background: #fce8e6; color: #d93025; }
        
        .btn-primary { background-color: var(--agri-red); border-color: var(--agri-red); }
        .btn-primary:hover { background-color: var(--agri-red-dark); border-color: var(--agri-red-dark); }
        .text-primary { color: var(--agri-red) !important; }

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
                <li><a href="users" class="sidebar-link active"><i class="fa-solid fa-users w-20px text-center"></i> Quản lý Nhân sự</a></li>
            </c:if>
            <c:if test="${user.role eq 'ADMIN' || user.role eq 'LANH_DAO'}">
                <li><a href="recycle_bin.jsp" class="sidebar-link"><i class="fa-solid fa-trash-can w-20px text-center"></i> Thùng rác (Hồ sơ)</a></li>
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
                        <i class="fa-solid fa-user text-primary"></i>
                    </button>
                    <ul class="dropdown-menu dropdown-menu-end shadow border-0 mt-2">
                        <li><a class="dropdown-item text-danger fw-bold" href="auth?action=logout"><i class="fa-solid fa-power-off me-2"></i>Đăng xuất</a></li>
                    </ul>
                </div>
            </div>
        </div>

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
                    <div class="card-header text-primary border-bottom-0"><i class="fa-solid fa-list me-2"></i>Danh Sách Tài Khoản Hệ Thống</div>
                    <div class="card-body p-0">
                        <!-- Nav tabs -->
                        <ul class="nav nav-tabs px-3" id="userTabs" role="tablist">
                            <li class="nav-item" role="presentation">
                                <button class="nav-link active fw-bold text-success" id="active-tab" data-bs-toggle="tab" data-bs-target="#active" type="button" role="tab" aria-selected="true"><i class="fa-solid fa-user-check me-1"></i>Đang Hoạt Động</button>
                            </li>
                            <li class="nav-item" role="presentation">
                                <button class="nav-link fw-bold text-danger" id="locked-tab" data-bs-toggle="tab" data-bs-target="#locked" type="button" role="tab" aria-selected="false"><i class="fa-solid fa-user-lock me-1"></i>Đã Khóa / Xóa</button>
                            </li>
                        </ul>

                        <!-- Tab panes -->
                        <div class="tab-content" id="userTabsContent">
                            <div class="tab-pane fade show active" id="active" role="tabpanel" aria-labelledby="active-tab">
                                <div class="table-responsive">
                                    <table class="table table-hover mb-0">
                                        <thead>
                                            <tr>
                                                <th>ID</th>
                                                <th>Họ và Tên</th>
                                                <th>Tên Đăng Nhập</th>
                                                <th>Phân Quyền</th>
                                                <th class="text-end" style="width: 25%;">Thao Tác</th>
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
                                                            <c:when test="${u.role eq 'ADMIN'}"><span class="badge bg-danger">SUPER ADMIN</span></c:when>
                                                            <c:when test="${u.role eq 'LANH_DAO'}"><span class="badge bg-warning text-dark">LÃNH ĐẠO</span></c:when>
                                                            <c:when test="${u.role eq 'THAM_DINH'}"><span class="badge bg-info text-dark">THẨM ĐỊNH</span></c:when>
                                                            <c:otherwise><span class="badge bg-primary">GIAO DỊCH VIÊN</span></c:otherwise>
                                                        </c:choose>
                                                    </td>
                                                    <td class="text-end">
                                                        <c:if test="${u.role ne 'ADMIN'}">
                                                            <div class="btn-group" role="group">
                                                                <form action="users" method="post" class="d-inline" onsubmit="return confirmAction(event, this, 'lock_temp');">
                                                                    <input type="hidden" name="action" value="lock_temp">
                                                                    <input type="hidden" name="id" value="${u.id}">
                                                                    <button type="submit" class="btn btn-sm btn-outline-warning" title="Khóa tạm"><i class="fa-solid fa-lock"></i></button>
                                                                </form>
                                                                <form action="users" method="post" class="d-inline" onsubmit="return confirmAction(event, this, 'lock_perm');">
                                                                    <input type="hidden" name="action" value="lock_perm">
                                                                    <input type="hidden" name="id" value="${u.id}">
                                                                    <button type="submit" class="btn btn-sm btn-outline-secondary" title="Khóa vĩnh viễn"><i class="fa-solid fa-ban"></i></button>
                                                                </form>
                                                                <form action="users" method="post" class="d-inline" onsubmit="return confirmAction(event, this, 'soft_delete');">
                                                                    <input type="hidden" name="action" value="soft_delete">
                                                                    <input type="hidden" name="id" value="${u.id}">
                                                                    <button type="submit" class="btn btn-sm btn-outline-danger" title="Xóa"><i class="fa-solid fa-trash"></i></button>
                                                                </form>
                                                            </div>
                                                        </c:if>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                        </tbody>
                                    </table>
                                </div>
                            </div>
                            
                            <div class="tab-pane fade" id="locked" role="tabpanel" aria-labelledby="locked-tab">
                                <div class="table-responsive">
                                    <table class="table table-hover mb-0">
                                        <thead>
                                            <tr>
                                                <th>Họ và Tên</th>
                                                <th>Tên Đăng Nhập</th>
                                                <th>Trạng Thái</th>
                                                <th class="text-end">Thao Tác</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach var="u" items="${lockedUsers}">
                                                <tr>
                                                    <td class="fw-semibold text-dark">${u.fullname}</td>
                                                    <td><span class="badge bg-light text-dark border">${u.username}</span></td>
                                                    <td>
                                                        <c:choose>
                                                            <c:when test="${u.status eq 'LOCKED_TEMP'}"><span class="badge badge-soft-warning"><i class="fa-solid fa-lock me-1"></i>Khóa tạm</span></c:when>
                                                            <c:when test="${u.status eq 'LOCKED_PERM'}"><span class="badge badge-soft-danger"><i class="fa-solid fa-ban me-1"></i>Khóa vĩnh viễn</span></c:when>
                                                            <c:when test="${u.status eq 'DELETED'}"><span class="badge badge-soft-danger"><i class="fa-solid fa-trash me-1"></i>Đã xóa</span></c:when>
                                                        </c:choose>
                                                    </td>
                                                    <td class="text-end">
                                                        <form action="users" method="post" class="d-inline" onsubmit="return confirmAction(event, this, 'restore');">
                                                            <input type="hidden" name="action" value="restore">
                                                            <input type="hidden" name="id" value="${u.id}">
                                                            <button type="submit" class="btn btn-sm btn-outline-success"><i class="fa-solid fa-unlock me-1"></i>Mở khóa/Khôi phục</button>
                                                        </form>
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
        </div>
    </div>
    
    <script src="https://code.jquery.com/jquery-3.7.0.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <script>
        function confirmAction(event, form, actionType) {
            event.preventDefault();
            let title = '';
            let text = '';
            let icon = 'warning';
            let confirmBtn = '#3085d6';
            
            if (actionType === 'lock_temp') {
                title = 'Khóa tạm thời?';
                text = 'Tài khoản sẽ không thể đăng nhập cho đến khi mở khóa.';
                confirmBtn = '#ffc107';
            } else if (actionType === 'lock_perm') {
                title = 'Khóa vĩnh viễn?';
                text = 'Tài khoản sẽ bị cấm đăng nhập vĩnh viễn.';
                icon = 'error';
                confirmBtn = '#6c757d';
            } else if (actionType === 'soft_delete') {
                title = 'Đưa vào thùng rác?';
                text = 'Tài khoản sẽ bị xóa khỏi danh sách hoạt động.';
                icon = 'error';
                confirmBtn = '#d33';
            } else if (actionType === 'restore') {
                title = 'Mở khóa / Khôi phục?';
                text = 'Tài khoản sẽ hoạt động lại bình thường.';
                icon = 'info';
                confirmBtn = '#198754';
            }
            
            Swal.fire({
                title: title,
                text: text,
                icon: icon,
                showCancelButton: true,
                confirmButtonColor: confirmBtn,
                cancelButtonColor: '#6c757d',
                confirmButtonText: 'Đồng ý',
                cancelButtonText: 'Hủy bỏ'
            }).then((result) => {
                if (result.isConfirmed) {
                    form.submit();
                }
            });
            return false;
        }

        $(document).ready(function() {
            $('#sidebarToggle').on('click', function() {
                $('.sidebar').toggleClass('show');
            });
        });
    </script>
    </div>
</body>
</html>
