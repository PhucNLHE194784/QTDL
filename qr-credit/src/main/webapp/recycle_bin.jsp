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
        .badge { padding: 6px 12px; border-radius: 8px; font-weight: 600; font-size: 0.75rem; letter-spacing: 0.3px; }
        .badge-soft-danger { background: linear-gradient(135deg, #f8d7da, #fadbd8); color: #842029; }
        .btn-action { border-radius: 8px; padding: 6px 15px; font-weight: 500; font-size: 0.85rem; }
        .money-text { font-family: 'Courier New', Courier, monospace; font-weight: 700; color: #198754; }
    </style>
</head>
<body>
    <nav class="navbar navbar-expand-lg navbar-dark mb-4">
        <div class="container-fluid px-4">
            <a class="navbar-brand" href="dashboard.jsp"><i class="fa-solid fa-building-columns me-2 text-warning"></i>AgriQR LoanFlow</a>
            <div class="d-flex align-items-center text-white">
                <div class="me-4 text-end">
                    <div class="fw-bold" style="font-size: 0.95rem;">${user.fullname}</div>
                    <div style="font-size: 0.8rem; opacity: 0.8;"><i class="fa-solid fa-id-badge me-1"></i>${user.role}</div>
                </div>
                <a href="dashboard.jsp" class="btn btn-outline-light btn-sm fw-bold px-3 me-2" style="border-radius: 8px;"><i class="fa-solid fa-house me-1"></i>Về trang chủ</a>
            </div>
        </div>
    </nav>

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
    </script>
</body>
</html>
