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
        :root {
            --agri-red: #A51A29;
            --agri-red-dark: #8E1521;
            --agri-yellow: #f1c40f;
            --sidebar-width: 260px;
        }
        body { background: #f4f6f9; font-family: 'Inter', sans-serif; min-height: 100vh; overflow-x: hidden; }
        
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
        
        .card, .filter-panel { 
            background: white; 
            border: none; 
            border-radius: 12px; 
            box-shadow: 0 5px 20px rgba(0,0,0,0.05); 
            margin-bottom: 24px; 
        }
        .card-header { background-color: transparent; border-bottom: 1px solid #eee; font-weight: 700; padding: 16px 24px; font-size: 1.1rem; color: var(--agri-red); }
        
        .filter-panel { padding: 24px; }
        .form-label { font-size: 0.85rem; font-weight: 600; color: #555; text-transform: uppercase; }
        .form-control, .form-select { border-radius: 8px; border: 1px solid #ddd; }
        .form-control:focus, .form-select:focus { border-color: var(--agri-red); box-shadow: 0 0 0 0.2rem rgba(165, 26, 41, 0.15); }
        
        .table { margin-bottom: 0; }
        .table th { background-color: #f8f9fa; color: #555; font-weight: 600; font-size: 0.8rem; text-transform: uppercase; border-bottom: 2px solid #eee; padding: 15px; }
        .table td { vertical-align: middle; padding: 15px; font-size: 0.95rem; border-color: #eee; }
        
        .badge-soft-success { background: #e6f4ea; color: #1e8e3e; padding: 6px 12px; border-radius: 6px; font-weight: 600; }
        .badge-soft-warning { background: #fef7e0; color: #b06000; padding: 6px 12px; border-radius: 6px; font-weight: 600; }
        .badge-soft-danger { background: #fce8e6; color: #d93025; padding: 6px 12px; border-radius: 6px; font-weight: 600; }
        
        .btn-primary-custom { background-color: var(--agri-red); border-color: var(--agri-red); color: white; }
        .btn-primary-custom:hover { background-color: var(--agri-red-dark); border-color: var(--agri-red-dark); color: white; }
        .text-primary-custom { color: var(--agri-red); }
        
        .money-text { font-family: 'Courier New', Courier, monospace; font-weight: 700; color: var(--agri-red); }
    </style>
</head>
<body>
    <!-- Sidebar -->
    <div class="sidebar">
        <div class="sidebar-brand">
            <i class="fa-solid fa-leaf"></i> AGRIBANK
        </div>
        <ul class="sidebar-menu">
            <li><a href="dashboard.jsp" class="sidebar-link active"><i class="fa-solid fa-chart-pie w-20px text-center"></i> <span data-i18n="dashboard_menu">Bảng điều khiển</span></a></li>
            <c:if test="${user.role eq 'GDV'}">
                <li><a href="create_profile.jsp" class="sidebar-link"><i class="fa-solid fa-plus w-20px text-center"></i> <span data-i18n="create_menu">Tạo Hồ sơ mới</span></a></li>
            </c:if>
            <c:if test="${user.role eq 'ADMIN'}">
                <li class="mt-4 px-3 mb-2 text-uppercase" style="font-size: 0.75rem; opacity: 0.6; font-weight: 700;" data-i18n="admin_header">Quản trị hệ thống</li>
                <li><a href="users" class="sidebar-link"><i class="fa-solid fa-users w-20px text-center"></i> <span data-i18n="users_menu">Quản lý Nhân sự</span></a></li>
            </c:if>
            <c:if test="${user.role eq 'ADMIN' || user.role eq 'LANH_DAO'}">
                <li><a href="recycle_bin.jsp" class="sidebar-link"><i class="fa-solid fa-trash-can w-20px text-center"></i> <span data-i18n="trash_menu">Thùng rác (Hồ sơ)</span></a></li>
            </c:if>
        </ul>
    </div>

    <!-- Main Content -->
    <div class="main-content">
        <!-- Top Navbar -->
        <div class="top-navbar">
            <div class="d-flex align-items-center">
                <div class="dropdown me-4">
                    <div class="fw-bold text-dark" data-bs-toggle="dropdown" aria-expanded="false" id="langBadge" style="cursor:pointer; font-size: 0.9rem;">
                        VIE <i class="fa-solid fa-caret-down ms-1"></i>
                    </div>
                    <ul class="dropdown-menu shadow border-0" style="min-width: 100px;">
                        <li><a class="dropdown-item fw-bold" href="#" onclick="switchLangDashboard('VIE')">Tiếng Việt</a></li>
                        <li><a class="dropdown-item fw-bold" href="#" onclick="switchLangDashboard('ENG')">English</a></li>
                    </ul>
                </div>
                
                <div class="text-end me-3">
                    <div class="fw-bold text-dark" style="font-size: 0.95rem;">${user.fullname}</div>
                    <div class="text-muted" style="font-size: 0.8rem;"><i class="fa-solid fa-id-badge me-1 text-warning"></i>${user.role}</div>
                </div>
                <div class="dropdown">
                    <button class="btn btn-light rounded-circle shadow-sm" type="button" data-bs-toggle="dropdown" style="width: 45px; height: 45px;">
                        <i class="fa-solid fa-user text-primary-custom"></i>
                    </button>
                    <ul class="dropdown-menu dropdown-menu-end shadow border-0 mt-2">
                        <li><a class="dropdown-item text-danger fw-bold" href="auth?action=logout"><i class="fa-solid fa-power-off me-2"></i><span data-i18n="logout">Đăng xuất</span></a></li>
                    </ul>
                </div>
            </div>
        </div>

        <div class="container-fluid px-4 mb-5">
            <div class="mb-4">
                <h2 class="fw-bold text-dark mb-1" data-i18n="main_title">Hệ Thống Quản Trị Tín Dụng</h2>
                <p class="text-muted mb-0" data-i18n="main_desc">Theo dõi, giám sát và quản lý hồ sơ khoản vay</p>
            </div>

            <!-- Bộ Lọc Đa Chiều (Advanced Filters) -->
            <div class="filter-panel">
                <h6 class="mb-3 text-dark fw-bold"><i class="fa-solid fa-filter me-2 text-primary-custom"></i><span data-i18n="filter_title">Bộ Lọc Dữ Liệu</span></h6>
                <div class="row g-3">
                    <div class="col-md-3">
                        <label class="form-label" data-i18n="filter_region">Khu vực</label>
                        <select id="filterRegion" class="form-select">
                            <option value="" data-i18n="filter_region_all">Tất cả Tỉnh/Thành</option>
                            <!-- API will populate this -->
                        </select>
                    </div>
                    <div class="col-md-3">
                        <label class="form-label" data-i18n="filter_status">Trạng thái xử lý</label>
                        <select id="filterStatus" class="form-select">
                            <option value="" data-i18n="filter_status_all">Tất cả trạng thái</option>
                            <option value="Đã tiếp nhận" data-i18n="status_received">Đã tiếp nhận</option>
                            <option value="Đang thẩm định" data-i18n="status_appraising">Đang thẩm định</option>
                            <option value="Chờ phê duyệt" data-i18n="status_pending">Chờ phê duyệt</option>
                            <option value="Đã phê duyệt" data-i18n="status_approved">Đã phê duyệt</option>
                            <option value="Đã giải ngân" data-i18n="status_disbursed">Đã giải ngân</option>
                            <option value="Từ chối" data-i18n="status_rejected">Từ chối</option>
                        </select>
                    </div>
                    <div class="col-md-3">
                        <label class="form-label" data-i18n="filter_date">Khoảng thời gian</label>
                        <input type="date" id="filterDate" class="form-control" title="Chọn ngày cập nhật">
                    </div>
                    <div class="col-md-3">
                        <label class="form-label" data-i18n="filter_search">Khách hàng / CCCD</label>
                        <input type="text" id="filterText" class="form-control" placeholder="Nhập tên, số CCCD...">
                    </div>
                </div>
                <div class="mt-3 text-end">
                    <button id="btnResetFilter" class="btn btn-light border btn-sm fw-bold text-secondary px-3"><i class="fa-solid fa-rotate-right me-1"></i><span data-i18n="btn_reset">Xóa lọc</span></button>
                </div>
            </div>

            <!-- Bảng Dữ Liệu -->
            <div class="card border-0">
                <div class="card-header bg-white">
                    <i class="fa-solid fa-list me-2"></i><span data-i18n="table_title">Danh Sách Hồ Sơ Khách Hàng</span>
                </div>
                <div class="card-body p-0">
                    <div class="table-responsive">
                        <table id="profileTable" class="table table-hover w-100">
                            <thead>
                                <tr>
                                    <th style="width: 12%;" data-i18n="col_id">Mã Hồ Sơ</th>
                                    <th style="width: 18%;" data-i18n="col_customer">Khách Hàng</th>
                                    <th style="width: 15%;" data-i18n="col_contact">Liên Hệ</th>
                                    <th style="width: 15%;" data-i18n="col_region">Khu Vực</th>
                                    <th style="width: 15%;" data-i18n="col_amount">Số Tiền Vay</th>
                                    <th style="width: 15%;" data-i18n="col_status">Trạng Thái</th>
                                    <th style="width: 15%;" data-i18n="col_updated">Cập Nhật Lúc</th>
                                    <th style="width: 10%; text-align: right;" data-i18n="col_action">Thao Tác</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="p" items="${recentProfiles}">
                                    <tr>
                                        <td><span class="fw-bold text-dark">${p.id}</span></td>
                                        <td>
                                            <div class="fw-bold text-primary-custom text-capitalize">${p.customerName}</div>
                                            <div class="small text-muted"><i class="fa-regular fa-id-card me-1"></i>${p.cccd}</div>
                                        </td>
                                        <td>
                                            <div class="fw-semibold text-dark"><i class="fa-solid fa-phone me-1 text-muted"></i>${not empty p.phone ? p.phone : 'Chưa có'}</div>
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
                                            <a href="profile?id=${p.id}" class="btn btn-outline-dark btn-sm mb-1"><i class="fa-regular fa-eye"></i></a>
                                            <c:if test="${user.role eq 'ADMIN' || user.role eq 'LANH_DAO'}">
                                                <form action="profile" method="post" class="d-inline" onsubmit="return confirmDelete(event, this);">
                                                    <input type="hidden" name="action" value="soft_delete">
                                                    <input type="hidden" name="id" value="${p.id}">
                                                    <button type="submit" class="btn btn-outline-danger btn-sm mb-1"><i class="fa-solid fa-trash"></i></button>
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

    <!-- Scripts -->
    <script src="https://code.jquery.com/jquery-3.7.0.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://cdn.datatables.net/1.13.6/js/jquery.dataTables.min.js"></script>
    <script src="https://cdn.datatables.net/1.13.6/js/dataTables.bootstrap5.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    
    <script>
        $(document).ready(function() {
            var table = $('#profileTable').DataTable({
                "language": {
                    "url": "//cdn.datatables.net/plug-ins/1.13.6/i18n/vi.json"
                },
                "dom": '<"top">rt<"bottom"ilp><"clear">', 
                "order": [[ 6, "desc" ]], 
                "pageLength": 10,
                "responsive": true
            });

            // Tải API Tỉnh/Thành
            $.ajax({
                url: 'https://esgoo.net/api-tinhthanh/1/0.htm',
                method: 'GET',
                dataType: 'json',
                success: function(response) {
                    if (response.error === 0) {
                        var select = $('#filterRegion');
                        $.each(response.data, function(index, item) {
                            select.append('<option value="' + item.full_name + '">' + item.full_name + '</option>');
                        });
                    }
                }
            });

            // Logic Bộ lọc Custom
            $('#filterRegion').on('change', function() { 
                var val = this.value;
                if (val) {
                    val = val.replace(/^(Tỉnh |Thành phố |Thủ đô )/i, '');
                }
                table.column(3).search(val, true, false).draw(); 
            });
            $('#filterStatus').on('change', function() { table.column(5).search(this.value).draw(); });
            $('#filterText').on('keyup', function() { table.search(this.value).draw(); });
            $('#filterDate').on('change', function() {
                var dateVal = this.value; 
                if (dateVal) {
                    var parts = dateVal.split('-');
                    var formattedDate = parts[2] + '/' + parts[1] + '/' + parts[0];
                    table.column(6).search(formattedDate).draw();
                } else {
                    table.column(6).search('').draw();
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

        function confirmDelete(event, form) {
            event.preventDefault();
            Swal.fire({
                title: 'Đưa vào thùng rác?',
                text: "Hồ sơ này sẽ bị đưa vào thùng rác. Bạn có thể khôi phục lại sau.",
                icon: 'warning',
                showCancelButton: true,
                confirmButtonColor: '#A51A29',
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

        const dictDash = {
            'VIE': {
                'dashboard_menu': 'Bảng điều khiển', 'create_menu': 'Tạo Hồ sơ mới', 'admin_header': 'Quản trị hệ thống', 'users_menu': 'Quản lý Nhân sự', 'trash_menu': 'Thùng rác (Hồ sơ)',
                'main_title': 'Hệ Thống Quản Trị Tín Dụng', 'main_desc': 'Theo dõi, giám sát và quản lý hồ sơ khoản vay',
                'filter_title': 'Bộ Lọc Dữ Liệu', 'filter_region': 'Khu vực', 'filter_region_all': 'Tất cả Tỉnh/Thành', 'filter_status': 'Trạng thái xử lý', 'filter_status_all': 'Tất cả trạng thái',
                'status_received': 'Đã tiếp nhận', 'status_appraising': 'Đang thẩm định', 'status_pending': 'Chờ phê duyệt', 'status_approved': 'Đã phê duyệt', 'status_disbursed': 'Đã giải ngân', 'status_rejected': 'Từ chối',
                'filter_date': 'Khoảng thời gian', 'filter_search': 'Khách hàng / CCCD', 'btn_reset': 'Xóa lọc',
                'table_title': 'Danh Sách Hồ Sơ Khách Hàng',
                'col_id': 'Mã Hồ Sơ', 'col_customer': 'Khách Hàng', 'col_contact': 'Liên Hệ', 'col_region': 'Khu Vực', 'col_amount': 'Số Tiền Vay', 'col_status': 'Trạng Thái', 'col_updated': 'Cập Nhật Lúc', 'col_action': 'Thao Tác',
                'logout': 'Đăng xuất'
            },
            'ENG': {
                'dashboard_menu': 'Dashboard', 'create_menu': 'Create Profile', 'admin_header': 'System Admin', 'users_menu': 'Manage Users', 'trash_menu': 'Recycle Bin',
                'main_title': 'Credit Administration System', 'main_desc': 'Monitor and manage loan profiles',
                'filter_title': 'Data Filters', 'filter_region': 'Region', 'filter_region_all': 'All Regions', 'filter_status': 'Processing Status', 'filter_status_all': 'All Statuses',
                'status_received': 'Received', 'status_appraising': 'Appraising', 'status_pending': 'Pending', 'status_approved': 'Approved', 'status_disbursed': 'Disbursed', 'status_rejected': 'Rejected',
                'filter_date': 'Date Range', 'filter_search': 'Customer / ID', 'btn_reset': 'Reset',
                'table_title': 'Customer Profile List',
                'col_id': 'Profile ID', 'col_customer': 'Customer', 'col_contact': 'Contact', 'col_region': 'Region', 'col_amount': 'Amount', 'col_status': 'Status', 'col_updated': 'Last Updated', 'col_action': 'Action',
                'logout': 'Logout'
            }
        };

        function switchLangDashboard(lang) {
            document.getElementById('langBadge').innerHTML = lang + ' <i class="fa-solid fa-caret-down ms-1"></i>';
            document.querySelectorAll('[data-i18n]').forEach(el => {
                let key = el.getAttribute('data-i18n');
                if (dictDash[lang][key]) {
                    el.innerText = dictDash[lang][key];
                }
            });
        }
    </script>
</body>
</html>
