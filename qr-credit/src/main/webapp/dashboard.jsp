<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ page import="com.qrcredit.dao.ProfileDAO" %>
<%@ page import="com.qrcredit.model.Profile" %>
<%@ page import="java.util.List" %>
<%
    if(session.getAttribute("user") == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    ProfileDAO dao = new ProfileDAO();
    List<Profile> recentProfiles = dao.getAllProfiles();
    request.setAttribute("recentProfiles", recentProfiles);
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Hệ thống Quản trị - AgriQR LoanFlow</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.datatables.net/1.13.6/css/dataTables.bootstrap5.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        body { background: linear-gradient(135deg, #fdfbfb 0%, #ebedee 100%); font-family: 'Inter', sans-serif; min-height: 100vh; }
        .navbar { background: rgba(30, 60, 114, 0.9); backdrop-filter: blur(10px); padding: 15px 0; border-bottom: 1px solid rgba(255,255,255,0.1); }
        .navbar-brand { font-size: 1.4rem; font-weight: 700; letter-spacing: 0.5px; }
        .card, .filter-panel { 
            background: rgba(255, 255, 255, 0.85); 
            backdrop-filter: blur(15px); 
            border: 1px solid rgba(255,255,255,0.5); 
            border-radius: 16px; 
            box-shadow: 0 10px 30px rgba(0,0,0,0.03); 
            margin-bottom: 24px; 
        }
        .card-header { background-color: rgba(255,255,255,0.5); border-bottom: 1px solid rgba(0,0,0,0.05); border-radius: 16px 16px 0 0 !important; font-weight: 600; padding: 16px 24px; font-size: 1.1rem; }
        
        .filter-panel { padding: 24px; }
        .form-label { font-size: 0.85rem; font-weight: 600; color: #475569; text-transform: uppercase; letter-spacing: 0.5px; }
        .form-control, .form-select { border-radius: 10px; padding: 10px 15px; border: 1px solid #e2e8f0; font-size: 0.95rem; background-color: rgba(255,255,255,0.9); }
        .form-control:focus, .form-select:focus { border-color: #0d6efd; box-shadow: 0 0 0 0.2rem rgba(13,110,253,.15); }
        
        .table { margin-bottom: 0; background: transparent; }
        .table th { background-color: rgba(248, 249, 250, 0.5); color: #475569; font-weight: 600; text-transform: uppercase; font-size: 0.75rem; letter-spacing: 0.5px; padding: 15px; border-bottom-width: 1px; }
        .table td { vertical-align: middle; color: #334155; padding: 15px; font-size: 0.95rem; border-color: rgba(0,0,0,0.05); background: transparent; }
        .table-hover tbody tr:hover td { background-color: rgba(255,255,255,0.95); }
        
        .badge { padding: 6px 12px; border-radius: 8px; font-weight: 600; font-size: 0.75rem; letter-spacing: 0.3px; }
        .badge-soft-success { background: linear-gradient(135deg, #d1f2e1, #a3e4d7); color: #0f5132; }
        .badge-soft-warning { background: linear-gradient(135deg, #fff3cd, #fdebd0); color: #856404; }
        .badge-soft-danger { background: linear-gradient(135deg, #f8d7da, #fadbd8); color: #842029; }
        .badge-soft-info { background: linear-gradient(135deg, #cff4fc, #d6eaf8); color: #055160; }
        
        .btn-action { border-radius: 8px; padding: 6px 15px; font-weight: 500; font-size: 0.85rem; }
        .money-text { font-family: 'Courier New', Courier, monospace; font-weight: 700; color: #198754; }
    </style>
</head>
<body>
    <nav class="navbar navbar-expand-lg navbar-dark mb-4">
        <div class="container-fluid px-4">
            <a class="navbar-brand" href="#"><i class="fa-solid fa-building-columns me-2 text-warning"></i>AgriQR LoanFlow</a>
            <div class="d-flex align-items-center text-white">
                <div class="me-4 text-end">
                    <div class="fw-bold" style="font-size: 0.95rem;">${user.fullname}</div>
                    <div style="font-size: 0.8rem; opacity: 0.8;"><i class="fa-solid fa-id-badge me-1"></i>${user.role}</div>
                </div>
                <c:if test="${user.role eq 'ADMIN'}">
                    <a href="users" class="btn btn-outline-light btn-sm fw-bold px-3 me-2" style="border-radius: 8px;"><i class="fa-solid fa-users me-1"></i>Nhân sự</a>
                </c:if>
                <c:if test="${user.role eq 'ADMIN' || user.role eq 'LANH_DAO'}">
                    <a href="recycle_bin.jsp" class="btn btn-outline-warning btn-sm fw-bold px-3 me-2" style="border-radius: 8px;"><i class="fa-solid fa-trash-can me-1"></i>Thùng rác</a>
                </c:if>
                <a href="auth?action=logout" class="btn btn-light btn-sm fw-bold text-primary px-3" style="border-radius: 8px;"><i class="fa-solid fa-power-off me-1"></i>Thoát</a>
            </div>
        </div>
    </nav>

    <div class="container-fluid px-4 mb-5">
        <div class="d-flex justify-content-between align-items-end mb-4">
            <div>
                <h2 class="fw-bold text-dark mb-1">Bảng Điều Khiển Quản Trị</h2>
                <p class="text-muted mb-0">Hệ thống theo dõi và giám sát hồ sơ tín dụng</p>
            </div>
            <c:if test="${user.role eq 'GDV'}">
                <a href="create_profile.jsp" class="btn btn-primary btn-lg shadow-sm" style="border-radius: 10px; font-weight: 600;">
                    <i class="fa-solid fa-plus me-2"></i>Tạo Hồ sơ Mới
                </a>
            </c:if>
        </div>

        <!-- Bộ Lọc Đa Chiều (Advanced Filters) -->
        <div class="filter-panel">
            <h6 class="mb-3 text-dark fw-bold"><i class="fa-solid fa-filter me-2 text-primary"></i>Bộ Lọc Dữ Liệu Nâng Cao</h6>
            <div class="row g-3">
                <div class="col-md-3">
                    <div class="d-flex align-items-center">
                        <i class="fa-solid fa-location-dot text-success me-2"></i>
                        <select id="filterRegion" class="form-select border-0 bg-transparent text-secondary filter-region" style="box-shadow: none;">
                            <option value="">Tất cả Tỉnh/Thành</option>
                            <optgroup label="Thành phố Trực thuộc TW">
                                <option value="Hà Nội">Hà Nội</option>
                                <option value="TP Hồ Chí Minh">TP Hồ Chí Minh</option>
                                <option value="Đà Nẵng">Đà Nẵng</option>
                                <option value="Hải Phòng">Hải Phòng</option>
                                <option value="Cần Thơ">Cần Thơ</option>
                            </optgroup>
                            <optgroup label="Miền Bắc">
                                <option value="Thái Nguyên">Thái Nguyên</option>
                                <option value="Quảng Ninh">Quảng Ninh</option>
                                <option value="Bắc Ninh">Bắc Ninh</option>
                                <option value="Hải Dương">Hải Dương</option>
                                <option value="Nam Định">Nam Định</option>
                                <option value="Ninh Bình">Ninh Bình</option>
                                <option value="Lào Cai">Lào Cai</option>
                                <option value="Sơn La">Sơn La</option>
                            </optgroup>
                            <optgroup label="Miền Trung">
                                <option value="Thanh Hóa">Thanh Hóa</option>
                                <option value="Nghệ An">Nghệ An</option>
                                <option value="Hà Tĩnh">Hà Tĩnh</option>
                                <option value="Thừa Thiên Huế">Thừa Thiên Huế</option>
                                <option value="Quảng Nam">Quảng Nam</option>
                                <option value="Khánh Hòa">Khánh Hòa</option>
                                <option value="Bình Thuận">Bình Thuận</option>
                            </optgroup>
                            <optgroup label="Tây Nguyên & Miền Nam">
                                <option value="Đắk Lắk">Đắk Lắk</option>
                                <option value="Lâm Đồng">Lâm Đồng</option>
                                <option value="Bình Dương">Bình Dương</option>
                                <option value="Đồng Nai">Đồng Nai</option>
                                <option value="Bà Rịa - Vũng Tàu">Bà Rịa - Vũng Tàu</option>
                                <option value="Long An">Long An</option>
                                <option value="Tiền Giang">Tiền Giang</option>
                                <option value="Kiên Giang">Kiên Giang</option>
                                <option value="Cà Mau">Cà Mau</option>
                            </optgroup>
                        </select>
                    </div>
                </div>
                <div class="col-md-3">
                    <label class="form-label">Trạng thái xử lý</label>
                    <select id="filterStatus" class="form-select">
                        <option value="">Tất cả trạng thái</option>
                        <option value="Đã tiếp nhận">Đã tiếp nhận</option>
                        <option value="Đang thẩm định">Đang thẩm định</option>
                        <option value="Chờ phê duyệt">Chờ phê duyệt</option>
                        <option value="Đã phê duyệt">Đã phê duyệt</option>
                        <option value="Đã giải ngân">Đã giải ngân</option>
                        <option value="Từ chối">Từ chối</option>
                    </select>
                </div>
                <div class="col-md-3">
                    <label class="form-label">Khoảng thời gian</label>
                    <input type="date" id="filterDate" class="form-control" title="Chọn ngày cập nhật">
                </div>
                <div class="col-md-3">
                    <label class="form-label">Khách hàng / CCCD</label>
                    <input type="text" id="filterText" class="form-control" placeholder="Nhập tên, số CCCD...">
                </div>
            </div>
            <div class="mt-3 text-end">
                <button id="btnResetFilter" class="btn btn-light border btn-sm fw-bold text-secondary px-3"><i class="fa-solid fa-rotate-right me-1"></i>Xóa lọc</button>
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
                                <th style="width: 15%;">Khu Vực</th>
                                <th style="width: 15%;">Số Tiền Vay</th>
                                <th style="width: 15%;">Trạng Thái</th>
                                <th style="width: 15%;">Cập Nhật Lúc</th>
                                <th style="width: 10%; text-align: right;">Thao Tác</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="p" items="${recentProfiles}">
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
                                        <div class="fw-semibold text-dark">${not empty p.region ? p.region : 'Chưa cập nhật'}</div>
                                        <div class="small text-muted">${p.ward}</div>
                                    </td>
                                    <td>
                                        <span class="money-text">
                                            <fmt:formatNumber value="${p.amount}" pattern="#,###" /> đ
                                        </span>
                                    </td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${p.status == 'Đã phê duyệt' || p.status == 'Đã giải ngân'}">
                                                <span class="badge badge-soft-success"><i class="fa-solid fa-check-circle me-1"></i>${p.status}</span>
                                            </c:when>
                                            <c:when test="${p.status == 'Từ chối'}">
                                                <span class="badge badge-soft-danger"><i class="fa-solid fa-circle-xmark me-1"></i>${p.status}</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge badge-soft-warning"><i class="fa-solid fa-spinner fa-spin-pulse me-1"></i>${p.status}</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td data-order="${p.lastUpdated.time}">
                                        <div class="fw-semibold text-dark"><fmt:formatDate value="${p.lastUpdated}" pattern="dd/MM/yyyy" /></div>
                                        <div class="small text-muted"><fmt:formatDate value="${p.lastUpdated}" pattern="HH:mm:ss" /></div>
                                    </td>
                                    <td class="text-end">
                                        <a href="profile?id=${p.id}" class="btn btn-outline-primary btn-sm btn-action mb-1"><i class="fa-regular fa-eye me-1"></i>Xem</a>
                                        <c:if test="${user.role eq 'ADMIN' || user.role eq 'LANH_DAO'}">
                                            <form action="profile" method="post" class="d-inline" onsubmit="return confirm('Bạn có chắc chắn muốn đưa hồ sơ này vào thùng rác?');">
                                                <input type="hidden" name="action" value="soft_delete">
                                                <input type="hidden" name="id" value="${p.id}">
                                                <button type="submit" class="btn btn-outline-danger btn-sm btn-action mb-1"><i class="fa-solid fa-trash me-1"></i>Xóa</button>
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
    
    <script>
        $(document).ready(function() {
            var table = $('#profileTable').DataTable({
                "language": {
                    "url": "//cdn.datatables.net/plug-ins/1.13.6/i18n/vi.json"
                },
                "dom": '<"top">rt<"bottom"ilp><"clear">', // Ẩn ô search mặc định để dùng bộ lọc custom
                "order": [[ 5, "desc" ]], // Sắp xếp theo cột Cập nhật lúc
                "pageLength": 10,
                "responsive": true
            });

            // Logic Bộ lọc Custom
            $('#filterRegion').on('change', function() {
                table.column(2).search(this.value).draw();
            });

            $('#filterStatus').on('change', function() {
                table.column(4).search(this.value).draw();
            });

            $('#filterText').on('keyup', function() {
                table.search(this.value).draw();
            });

            $('#filterDate').on('change', function() {
                var dateVal = this.value; // YYYY-MM-DD
                if (dateVal) {
                    // Chuyển YYYY-MM-DD thành DD/MM/YYYY để khớp với hiển thị
                    var parts = dateVal.split('-');
                    var formattedDate = parts[2] + '/' + parts[1] + '/' + parts[0];
                    table.column(5).search(formattedDate).draw();
                } else {
                    table.column(5).search('').draw();
                }
            });

            $('#btnResetFilter').on('click', function() {
                $('#filterRegion').val('');
                $('#filterStatus').val('');
                $('#filterDate').val('');
                $('#filterText').val('');
                table.search('').columns().search('').draw();
            });
        });
    </script>
</body>
</html>
