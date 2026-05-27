<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%
    if(session.getAttribute("user") == null) {
        response.sendRedirect("login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chi Tiết Hồ Sơ - AgriQR LoanFlow</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        body { font-family: 'Inter', sans-serif; background-color: #f4f6f9; }
        .detail-card, .timeline-card { border: none; border-radius: 16px; box-shadow: 0 5px 20px rgba(0,0,0,0.05); }
        .card-header { border-radius: 16px 16px 0 0 !important; font-weight: 600; }
        .qr-box { background: #fff; padding: 20px; border-radius: 15px; border: 1px dashed #ced4da; transition: all 0.3s; }
        .qr-box:hover { border-color: #0d6efd; background: #f8f9fa; }
        .info-row { display: flex; justify-content: space-between; padding: 12px 0; border-bottom: 1px solid #eee; }
        .info-label { color: #6c757d; font-weight: 500; }
        .info-value { font-weight: 600; color: #212529; text-align: right; }
        .timeline { list-style: none; padding: 0; position: relative; }
        .timeline:before { content: ''; position: absolute; top: 0; bottom: 0; left: 16px; width: 2px; background: #e9ecef; }
        .timeline-item { position: relative; padding-left: 45px; margin-bottom: 20px; }
        .timeline-icon { position: absolute; left: 0; top: 0; width: 34px; height: 34px; border-radius: 50%; background: #e9ecef; display: flex; align-items: center; justify-content: center; color: #6c757d; border: 3px solid #fff; box-shadow: 0 0 0 2px #e9ecef; }
        .timeline-content { background: #fff; padding: 15px; border-radius: 10px; border: 1px solid #eee; }
        .timeline-date { font-size: 0.8rem; color: #adb5bd; margin-bottom: 5px; }
    </style>
</head>
<body>
    <div class="container-fluid px-4 mt-4 mb-5">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h3 class="fw-bold text-dark mb-0"><i class="fa-regular fa-folder-open text-primary me-2"></i>Hồ sơ: <span class="text-primary">${profile.id}</span></h3>
            <a href="dashboard.jsp" class="btn btn-outline-secondary shadow-sm"><i class="fa-solid fa-arrow-left me-1"></i>Trở về Bảng điều khiển</a>
        </div>
        
        <div class="row">
            <!-- Cột trái: QR và Thông tin -->
            <div class="col-lg-7 mb-4">
                <div class="card detail-card mb-4">
                    <div class="card-header bg-white border-bottom pt-3 pb-3">
                        <h5 class="mb-0 text-dark"><i class="fa-solid fa-qrcode text-primary me-2"></i>Mã định danh (QR Code)</h5>
                    </div>
                    <div class="card-body p-4">
                        <div class="row text-center g-4">
                            <div class="col-md-6">
                                <div class="qr-box h-100">
                                    <h6 class="fw-bold text-dark">QR Nội Bộ (Cán bộ)</h6>
                                    <p class="text-muted small mb-3">Dán vào bìa hồ sơ vật lý để luân chuyển nội bộ.</p>
                                    <img src="qr?id=${profile.id}&type=internal" alt="QR Internal" class="img-fluid rounded mb-3" style="max-width: 180px;">
                                    <button onclick="window.print()" class="btn btn-sm btn-outline-dark w-100"><i class="fa-solid fa-print me-1"></i>In mã QR này</button>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="qr-box h-100 position-relative">
                                    <h6 class="fw-bold text-primary">QR Tra Cứu (Khách Hàng)</h6>
                                    <p class="text-muted small mb-3">Tự động làm mới sau <span id="qrCountdown" class="text-danger fw-bold">60</span>s để bảo mật.</p>
                                    <img id="qrPublicImg" src="qr?id=${profile.id}&type=public&t=<%=System.currentTimeMillis()%>" alt="QR Public" class="img-fluid rounded mb-3" style="max-width: 180px; box-shadow: 0 5px 15px rgba(0,0,0,0.1);">
                                    <button onclick="window.print()" class="btn btn-sm btn-primary w-100"><i class="fa-solid fa-print me-1"></i>In mã QR này</button>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="card detail-card">
                    <div class="card-header bg-white border-bottom pt-3 pb-3">
                        <h5 class="mb-0 text-dark"><i class="fa-solid fa-circle-info text-info me-2"></i>Chi tiết khoản vay</h5>
                    </div>
                    <div class="card-body p-4">
                        <div class="info-row"><span class="info-label">Khách hàng:</span><span class="info-value text-primary">${profile.customerName}</span></div>
                        <div class="info-row"><span class="info-label">Số CCCD:</span><span class="info-value">${profile.cccd}</span></div>
                        <div class="info-row"><span class="info-label">Khu vực:</span><span class="info-value">${profile.region}</span></div>
                        <div class="info-row"><span class="info-label">Xã/Phường:</span><span class="info-value">${profile.ward}</span></div>
                        <div class="info-row"><span class="info-label">Số tiền vay:</span><span class="info-value text-danger fs-5"><fmt:formatNumber value="${profile.amount}" pattern="#,###"/> VNĐ</span></div>
                        <div class="info-row border-bottom-0"><span class="info-label">Mục đích:</span><span class="info-value text-muted" style="max-width: 60%; text-align: right;">${profile.purpose}</span></div>
                    </div>
                </div>

                <div class="card detail-card">
                    <div class="card-header bg-white border-bottom pt-3 pb-3">
                        <h5 class="mb-0 text-dark"><i class="fa-solid fa-gauge-high text-success me-2"></i>Điểm tín dụng (Credit Score)</h5>
                    </div>
                    <div class="card-body p-4 text-center">
                        <h2 class="fw-bold mb-2 ${profile.creditScore >= 80 ? 'text-success' : (profile.creditScore >= 50 ? 'text-warning' : 'text-danger')}">
                            ${profile.creditScore} <span class="fs-5 text-muted">/ 100</span>
                        </h2>
                        <p class="text-muted mb-3">
                            <c:choose>
                                <c:when test="${profile.creditScore >= 80}">Rất Tốt - Rủi ro thấp, độ tin cậy cao.</c:when>
                                <c:when test="${profile.creditScore >= 50}">Khá - Rủi ro trung bình, cần cân nhắc.</c:when>
                                <c:otherwise>Kém - Rủi ro cao, có thể bị từ chối.</c:otherwise>
                            </c:choose>
                        </p>
                        <div class="progress shadow-sm" style="height: 15px; border-radius: 10px;">
                            <div class="progress-bar progress-bar-striped progress-bar-animated ${profile.creditScore >= 80 ? 'bg-success' : (profile.creditScore >= 50 ? 'bg-warning' : 'bg-danger')}" 
                                 role="progressbar" style="width: ${profile.creditScore}%" 
                                 aria-valuenow="${profile.creditScore}" aria-valuemin="0" aria-valuemax="100">
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Cột phải: Cập nhật Trạng thái và Lịch sử -->
            <div class="col-lg-5">
                <div class="card timeline-card mb-4 border-success border-top border-4">
                    <div class="card-body p-4">
                        <h5 class="fw-bold text-success mb-3"><i class="fa-solid fa-pen-to-square me-2"></i>Cập nhật trạng thái</h5>
                        <p class="text-muted small mb-3">Trạng thái hiện tại: <span class="badge bg-warning text-dark fs-6 ms-1">${profile.status}</span></p>
                        
                        <form action="profile" method="post">
                            <input type="hidden" name="action" value="updateStatus">
                            <input type="hidden" name="id" value="${profile.id}">
                            <div class="input-group">
                                <c:choose>
                                    <c:when test="${profile.status == 'Đã giải ngân' || profile.status == 'Từ chối'}">
                                        <select class="form-select border-secondary text-muted" disabled>
                                            <option selected>Hồ sơ đã đóng (${profile.status})</option>
                                        </select>
                                        <button type="button" class="btn btn-secondary px-4" disabled><i class="fa-solid fa-lock me-2"></i>Đã khóa</button>
                                    </c:when>
                                    <c:otherwise>
                                        <select name="newStatus" class="form-select border-success">
                                            <option value="${profile.status}" selected hidden>Trạng thái hiện tại: ${profile.status}</option>
                                            <c:choose>
                                                <c:when test="${user.role eq 'GDV'}">
                                                    <option value="Đã tiếp nhận">Đã tiếp nhận</option>
                                                    <option value="Đang thẩm định">Chuyển sang: Đang thẩm định</option>
                                                    <option value="Từ chối">Từ chối hồ sơ</option>
                                                </c:when>
                                                <c:when test="${user.role eq 'THAM_DINH'}">
                                                    <option value="Đang thẩm định">Đang thẩm định</option>
                                                    <option value="Chờ phê duyệt">Trình lên: Chờ phê duyệt</option>
                                                    <option value="Từ chối">Từ chối hồ sơ</option>
                                                </c:when>
                                                <c:when test="${user.role eq 'LANH_DAO'}">
                                                    <option value="Đã phê duyệt">Đồng ý: Đã phê duyệt</option>
                                                    <option value="Đã giải ngân">Xác nhận: Đã giải ngân</option>
                                                    <option value="Từ chối">Từ chối hồ sơ</option>
                                                </c:when>
                                                <c:otherwise>
                                                    <option value="${profile.status}">${profile.status}</option>
                                                </c:otherwise>
                                            </c:choose>
                                        </select>
                                        <button type="submit" class="btn btn-success fw-bold px-4">Lưu</button>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </form>
                    </div>
                <div class="card timeline-card mb-4">
                    <div class="card-header bg-success text-white border-bottom pt-3 pb-3">
                        <h5 class="mb-0 fw-bold"><i class="fa-solid fa-file-invoice-dollar me-2"></i>Lịch sử thu nợ (Hệ thống IPCAS)</h5>
                    </div>
                    <div class="card-body p-4">
                        <div class="row text-center mb-4 g-3">
                            <div class="col-md-4">
                                <div class="p-3 border rounded bg-light" style="border-left: 4px solid var(--agri-yellow) !important;">
                                    <div class="text-muted small mb-1">Số tiền Giải Ngân</div>
                                    <div class="fw-bold fs-5 text-dark"><fmt:formatNumber value="${profile.amount}" pattern="#,###"/> VNĐ</div>
                                </div>
                            </div>
                            <div class="col-md-4">
                                <div class="p-3 border rounded bg-light" style="border-left: 4px solid #198754 !important;">
                                    <div class="text-muted small mb-1">Đã trả (Luỹ kế)</div>
                                    <div class="fw-bold fs-5 text-success">63,000,000 VNĐ</div>
                                </div>
                            </div>
                            <div class="col-md-4">
                                <div class="p-3 border rounded bg-light" style="border-left: 4px solid #dc3545 !important;">
                                    <div class="text-muted small mb-1">Dư nợ hiện tại</div>
                                    <div class="fw-bold fs-5 text-danger"><fmt:formatNumber value="${profile.amount - 63000000}" pattern="#,###"/> VNĐ</div>
                                </div>
                            </div>
                        </div>

                        <div class="table-responsive">
                            <table class="table table-bordered table-striped table-hover text-center align-middle" style="font-size: 0.9rem;">
                                <thead class="table-dark">
                                    <tr>
                                        <th>Kỳ hạn</th>
                                        <th>Ngày trả</th>
                                        <th>Gốc đã thu</th>
                                        <th>Lãi đã thu</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr>
                                        <td>04/2026</td>
                                        <td>30/04/2026</td>
                                        <td class="text-success fw-bold">1,500,000</td>
                                        <td class="text-warning text-dark fw-bold">850,541</td>
                                    </tr>
                                    <tr>
                                        <td>03/2026</td>
                                        <td>31/03/2026</td>
                                        <td class="text-success fw-bold">1,500,000</td>
                                        <td class="text-warning text-dark fw-bold">886,630</td>
                                    </tr>
                                    <tr>
                                        <td>02/2026</td>
                                        <td>28/02/2026</td>
                                        <td class="text-success fw-bold">1,500,000</td>
                                        <td class="text-warning text-dark fw-bold">807,294</td>
                                    </tr>
                                    <tr>
                                        <td>01/2026</td>
                                        <td>31/01/2026</td>
                                        <td class="text-success fw-bold">1,500,000</td>
                                        <td class="text-warning text-dark fw-bold">900,192</td>
                                    </tr>
                                    <tr>
                                        <td>12/2025</td>
                                        <td>31/12/2025</td>
                                        <td class="text-success fw-bold">1,500,000</td>
                                        <td class="text-warning text-dark fw-bold">995,349</td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>

                <div class="card timeline-card">
                    <div class="card-header bg-white border-bottom pt-3 pb-3">
                        <h5 class="mb-0 text-dark"><i class="fa-solid fa-clock-rotate-left text-secondary me-2"></i>Lịch sử luân chuyển (Audit Trail)</h5>
                    </div>
                    <div class="card-body p-4" style="max-height: 500px; overflow-y: auto;">
                        <ul class="timeline">
                            <c:forEach var="log" items="${logs}">
                                <li class="timeline-item">
                                    <div class="timeline-icon"><i class="fa-solid fa-check"></i></div>
                                    <div class="timeline-content shadow-sm">
                                        <div class="timeline-date"><i class="fa-regular fa-clock me-1"></i>${log.updatedAt}</div>
                                        <p class="mb-1 fw-semibold text-dark"><i class="fa-regular fa-user me-1 text-muted"></i>${log.userFullName}</p>
                                        <div class="mt-2 p-2 bg-light rounded d-inline-block w-100">
                                            <small class="text-muted">${log.oldStatus}</small>
                                            <i class="fa-solid fa-arrow-right-long mx-2 text-secondary"></i>
                                            <span class="text-success fw-bold">${log.newStatus}</span>
                                        </div>
                                    </div>
                                </li>
                            </c:forEach>
                            <c:if test="${empty logs}">
                                <p class="text-muted text-center mt-3">Chưa có lịch sử cập nhật.</p>
                            </c:if>
                        </ul>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <script>
        // Kiểm tra xem URL có parameter sent=true không
        const urlParams = new URLSearchParams(window.location.search);
        if (urlParams.has('sent') && urlParams.get('sent') === 'true') {
            // Xóa parameter khỏi URL
            window.history.replaceState({}, document.title, window.location.pathname + "?id=" + urlParams.get('id'));
            
            // Hiện alert toast
            const alertBox = document.createElement('div');
            alertBox.className = 'alert alert-success position-fixed top-0 end-0 m-3 shadow d-flex align-items-center';
            alertBox.style.zIndex = '9999';
            alertBox.innerHTML = '<i class="fa-solid fa-paper-plane me-2"></i><span>Đã tự động gửi thông báo (Email/SMS) cho khách hàng thành công!</span>' +
                                 '<button type="button" class="btn-close ms-3" aria-label="Close"></button>';
            document.body.appendChild(alertBox);
            
            // Xử lý nút X
            alertBox.querySelector('.btn-close').addEventListener('click', function() {
                alertBox.remove();
            });
            
            // Tự ẩn sau 4s
            setTimeout(() => {
                if(document.body.contains(alertBox)) alertBox.remove();
            }, 4000);
        }

        // QR Code dynamic refresh
        let timeLeft = 60;
        setInterval(function() {
            timeLeft--;
            if (timeLeft <= 0) {
                timeLeft = 60;
                document.getElementById('qrPublicImg').src = 'qr?id=${profile.id}&type=public&t=' + Date.now();
            }
            document.getElementById('qrCountdown').innerText = timeLeft;
        }, 1000);
    </script>
</body>
</html>
