<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Cấu hình Hệ thống - Agribank LoanFlow</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        body { background-color: #f8f9fa; }
        .sidebar { background-color: #A51A29; min-height: 100vh; color: white; padding-top: 20px; }
        .sidebar a { color: rgba(255,255,255,0.8); text-decoration: none; display: block; padding: 12px 20px; border-radius: 5px; margin: 5px 15px; transition: 0.3s; }
        .sidebar a:hover, .sidebar a.active { background-color: rgba(255,255,255,0.2); color: white; }
        .main-content { padding: 30px; }
        .card-custom { border: none; box-shadow: 0 4px 6px rgba(0,0,0,0.05); border-radius: 10px; }
        .card-header-custom { background-color: #fff; border-bottom: 2px solid #f0f0f0; padding: 15px 20px; font-weight: bold; border-radius: 10px 10px 0 0; }
        .btn-agri { background-color: #A51A29; color: white; border: none; }
        .btn-agri:hover { background-color: #8a1522; color: white; }
    </style>
</head>
<body>
    <div class="container-fluid p-0">
        <div class="row g-0">
            <!-- Sidebar -->
            <div class="col-md-2 sidebar d-none d-md-block">
                <div class="text-center mb-4">
                    <i class="fas fa-university fa-3x mb-2"></i>
                    <h5>LOAN FLOW</h5>
                </div>
                <a href="dashboard.jsp"><i class="fas fa-home me-2"></i> Trang chủ</a>
                <c:if test="${sessionScope.user.role == 'ADMIN' || sessionScope.user.role == 'LANH_DAO'}">
                    <a href="settings" class="active"><i class="fas fa-cog me-2"></i> Cấu hình HT</a>
                </c:if>
                <a href="auth?action=logout" class="text-white mt-5"><i class="fas fa-sign-out-alt me-2"></i> Đăng xuất</a>
            </div>

            <!-- Main Content -->
            <div class="col-md-10 main-content">
                <div class="d-flex justify-content-between align-items-center mb-4">
                    <h3 class="text-dark">Cài Đặt Hệ Thống</h3>
                    <div class="d-flex align-items-center">
                        <span class="me-3"><i class="fas fa-user-circle me-1"></i> Xin chào, ${sessionScope.user.fullname}</span>
                    </div>
                </div>

                <div class="row">
                    <div class="col-md-6">
                        <div class="card card-custom">
                            <div class="card-header-custom text-dark">
                                <i class="fas fa-envelope me-2"></i>Cấu hình Tổng đài Email (SMTP)
                            </div>
                            <div class="card-body p-4">
                                <c:if test="${not empty message}">
                                    <div class="alert alert-success alert-dismissible fade show" role="alert">
                                        <i class="fas fa-check-circle me-2"></i>${message}
                                        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                                    </div>
                                </c:if>
                                
                                <form action="settings" method="post">
                                    <div class="mb-4">
                                        <label class="form-label fw-bold"><i class="fas fa-paper-plane me-2 text-primary"></i>Phương thức gửi OTP & Link</label>
                                        <div class="d-flex gap-4">
                                            <div class="form-check">
                                                <input class="form-check-input" type="radio" name="otpMethod" id="methodEmail" value="EMAIL" ${empty otpMethod || otpMethod == 'EMAIL' ? 'checked' : ''}>
                                                <label class="form-check-label" for="methodEmail">
                                                    Gửi qua Email (Miễn phí)
                                                </label>
                                            </div>
                                            <div class="form-check">
                                                <input class="form-check-input" type="radio" name="otpMethod" id="methodSms" value="SMS" ${otpMethod == 'SMS' ? 'checked' : ''}>
                                                <label class="form-check-label" for="methodSms">
                                                    Gửi qua SMS (SpeedSMS)
                                                </label>
                                            </div>
                                        </div>
                                    </div>
                                    
                                    <hr class="text-muted">

                                    <h6 class="fw-bold mt-4 mb-3 text-secondary">CẤU HÌNH EMAIL GMAIL</h6>
                                    <div class="mb-3">
                                        <label class="form-label fw-bold">Email gửi tự động (Gmail)</label>
                                        <input type="email" name="smtpEmail" class="form-control" value="${smtpEmail}" placeholder="VD: agribank.loanflow@gmail.com">
                                        <div class="form-text text-muted small"><i class="fas fa-info-circle me-1"></i>Địa chỉ email dùng để gửi mã OTP và link báo cáo cho khách hàng.</div>
                                    </div>
                                    <div class="mb-4">
                                        <label class="form-label fw-bold">Mật khẩu ứng dụng (App Password)</label>
                                        <input type="password" name="smtpPassword" class="form-control" placeholder="Nhập để thay đổi (Bỏ trống nếu giữ nguyên)">
                                        <div class="form-text text-muted small"><i class="fas fa-info-circle me-1"></i>Chuỗi 16 ký tự do Google cấp. Tuyệt đối không dùng mật khẩu đăng nhập Gmail thường.</div>
                                    </div>

                                    <hr class="text-muted">

                                    <h6 class="fw-bold mt-4 mb-3 text-secondary">CẤU HÌNH SMS (SPEEDSMS.VN)</h6>
                                    <div class="mb-4">
                                        <label class="form-label fw-bold">Access Token API</label>
                                        <input type="text" name="smsApiKey" class="form-control" value="${smsApiKey}" placeholder="Nhập mã Access Token lấy từ SpeedSMS">
                                        <div class="form-text text-muted small"><i class="fas fa-info-circle me-1"></i>Dùng cho tùy chọn gửi SMS. Đăng ký tại speedsms.vn để lấy mã.</div>
                                    </div>

                                    <div class="text-end mt-4">
                                        <button type="submit" class="btn btn-agri px-4"><i class="fas fa-save me-2"></i>Lưu Cấu Hình</button>
                                    </div>
                                </form>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
