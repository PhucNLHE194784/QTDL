<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
    <title>Agribank Mobile App - Khoản Vay</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <style>
        body { background-color: #e9ecef; margin: 0; font-family: 'Inter', sans-serif; }
        .app-container {
            max-width: 414px;
            margin: 0 auto;
            background-color: #f5f7fa;
            min-height: 100vh;
            position: relative;
            box-shadow: 0 0 30px rgba(0,0,0,0.15);
            overflow-x: hidden;
            padding-bottom: 80px; /* space for bottom nav */
        }
        /* HEADER SECTION */
        .app-header {
            background: linear-gradient(135deg, #b01a2e 0%, #8E1521 100%);
            color: white;
            padding: 20px 20px 40px 20px;
            border-bottom-left-radius: 24px;
            border-bottom-right-radius: 24px;
            position: relative;
        }
        .header-top { display: flex; justify-content: space-between; align-items: center; margin-bottom: 25px; }
        .logo-box { display: flex; align-items: center; gap: 10px; font-weight: 700; font-size: 1.1rem; letter-spacing: 0.5px; }
        .logo-box i { color: #f1c40f; font-size: 1.5rem; }
        .header-icons i { font-size: 1.2rem; margin-left: 15px; position: relative; }
        .notification-dot { position: absolute; top: -3px; right: -3px; width: 8px; height: 8px; background: #f1c40f; border-radius: 50%; }
        
        .balance-title { font-size: 0.8rem; font-weight: 500; text-transform: uppercase; letter-spacing: 1px; margin-bottom: 5px; opacity: 0.9; display: flex; justify-content: space-between; }
        .balance-amount { font-size: 1.8rem; font-weight: 800; letter-spacing: 1px; display: flex; align-items: center; gap: 10px;}
        .eye-btn { font-size: 0.8rem; border: 1px solid rgba(255,255,255,0.4); border-radius: 20px; padding: 3px 10px; cursor: pointer; }
        
        .security-badge {
            background: rgba(40, 167, 69, 0.2);
            border: 1px solid rgba(40, 167, 69, 0.5);
            border-radius: 12px;
            padding: 10px 15px;
            margin-top: 20px;
            display: flex;
            align-items: center;
            justify-content: space-between;
        }
        .security-text { font-size: 0.75rem; line-height: 1.4; }
        .security-text strong { color: #4ade80; }
        
        /* QUICK ACTIONS */
        .quick-actions { display: flex; gap: 10px; padding: 0 20px; margin-top: -20px; position: relative; z-index: 10; }
        .action-btn {
            background: white; border-radius: 12px; padding: 15px 10px; text-align: center; flex: 1;
            box-shadow: 0 4px 15px rgba(0,0,0,0.05); font-size: 0.75rem; font-weight: 600; color: #333;
            border: 1px solid #f0f0f0; transition: 0.2s;
        }
        .action-btn:active { transform: scale(0.95); }
        .action-btn i { font-size: 1.5rem; color: #10b981; margin-bottom: 8px; display: block; }
        .action-btn.active-tab { border: 2px solid #10b981; background: #f0fdf4; }
        
        .assistant-banner {
            margin: 20px; background: #fff; border-radius: 12px; padding: 15px; display: flex; align-items: center; justify-content: space-between;
            box-shadow: 0 4px 15px rgba(0,0,0,0.05); border: 1px solid #f0f0f0;
        }
        .assistant-info { display: flex; align-items: center; gap: 15px; }
        .assistant-icon { width: 40px; height: 40px; background: #e0f2fe; color: #0284c7; border-radius: 50%; display: flex; align-items: center; justify-content: center; font-size: 1.2rem; }
        .assistant-text h6 { margin: 0; font-weight: 700; font-size: 0.9rem; color: #333; }
        .assistant-text p { margin: 0; font-size: 0.7rem; color: #666; }
        .btn-chat { background: #059669; color: white; border: none; border-radius: 20px; padding: 6px 15px; font-size: 0.75rem; font-weight: 600; }
        
        /* LIST SECTION */
        .section-header { padding: 0 20px; display: flex; justify-content: space-between; align-items: center; margin-bottom: 15px; }
        .section-title { font-size: 0.85rem; font-weight: 700; color: #666; letter-spacing: 0.5px; }
        .section-subtitle { font-size: 0.7rem; color: #999; font-style: italic; }
        
        .tabs { display: flex; margin: 0 20px 20px; border-bottom: 2px solid #e5e7eb; }
        .tab { flex: 1; text-align: center; padding-bottom: 10px; font-size: 0.85rem; font-weight: 600; color: #6b7280; position: relative; cursor: pointer; }
        .tab.active { color: #059669; }
        .tab.active::after { content: ''; position: absolute; bottom: -2px; left: 0; width: 100%; height: 2px; background: #059669; border-radius: 2px; }
        
        /* LOAN CARD */
        .loan-card { margin: 0 20px 20px; background: white; border-radius: 16px; box-shadow: 0 5px 20px rgba(0,0,0,0.06); border: 1px solid #f0f0f0; overflow: hidden; position: relative; }
        .loan-card-accent { position: absolute; top: 0; left: 0; width: 6px; height: 100%; background: #059669; }
        .loan-card-body { padding: 20px; padding-left: 26px; }
        .loan-title-row { display: flex; justify-content: space-between; align-items: flex-start; margin-bottom: 5px; }
        .loan-title { font-weight: 800; color: #b01a2e; font-size: 0.95rem; display: flex; align-items: center; gap: 8px; }
        .badge-safe { background: #d1fae5; color: #059669; padding: 4px 10px; border-radius: 20px; font-size: 0.65rem; font-weight: 700; }
        .loan-id { font-size: 0.75rem; color: #6b7280; margin-bottom: 15px; }
        
        .loan-purpose { background: #f8fafc; padding: 10px 15px; border-radius: 8px; font-size: 0.75rem; color: #475569; margin-bottom: 15px; line-height: 1.4; border-left: 2px solid #cbd5e1; }
        
        .data-row { display: flex; justify-content: space-between; margin-bottom: 8px; }
        .data-label { font-size: 0.75rem; color: #6b7280; }
        .data-val { font-size: 0.85rem; font-weight: 700; color: #1f2937; }
        .data-val.red { color: #b01a2e; font-size: 1rem;}
        .data-val.green { color: #059669; }
        
        .progress-box { margin-top: 15px; }
        .progress-label { display: flex; justify-content: space-between; font-size: 0.7rem; color: #6b7280; margin-bottom: 5px; }
        .progress { height: 6px; background-color: #e5e7eb; border-radius: 10px; }
        .progress-bar { background-color: #059669; border-radius: 10px; }
        
        .loan-footer { border-top: 1px dashed #e5e7eb; padding: 12px 20px; text-align: center; }
        .loan-footer a { color: #b01a2e; font-size: 0.75rem; font-weight: 700; text-decoration: none; }
        .loan-footer a i { margin-left: 5px; }
        
        /* BOTTOM NAV */
        .bottom-nav { position: absolute; bottom: 0; left: 0; width: 100%; background: white; display: flex; padding: 10px 0 15px; box-shadow: 0 -5px 20px rgba(0,0,0,0.05); border-top-left-radius: 20px; border-top-right-radius: 20px; }
        .nav-item { flex: 1; text-align: center; color: #9ca3af; font-size: 0.65rem; font-weight: 600; cursor: pointer; transition: 0.2s; }
        .nav-item i { font-size: 1.3rem; display: block; margin-bottom: 4px; }
        .nav-item.active { color: #b01a2e; }
        .nav-item.scan-btn { position: relative; top: -15px; }
        .nav-item.scan-btn .scan-circle { width: 50px; height: 50px; background: #059669; color: white; border-radius: 50%; display: flex; align-items: center; justify-content: center; margin: 0 auto 5px; box-shadow: 0 5px 15px rgba(5, 150, 105, 0.4); font-size: 1.5rem; }
    </style>
</head>
<body>
    <div class="app-container">
        <!-- HEADER -->
        <div class="app-header">
            <div class="header-top">
                <div class="logo-box">
                    <i class="fa-solid fa-leaf"></i> AGRIBANK
                </div>
                <div class="header-icons">
                    <i class="fa-solid fa-headset"></i>
                    <i class="fa-regular fa-bell"><div class="notification-dot"></div></i>
                </div>
            </div>
            
            <div class="balance-title">
                <span>TỔNG DƯ NỢ CỦA BẠN</span>
                <span class="eye-btn" onclick="toggleBalance()"><i class="fa-solid fa-eye-slash" id="eyeIcon"></i> Ẩn</span>
            </div>
            <div class="balance-amount" id="balanceAmount">
                <fmt:formatNumber value="${currentProfile.totalPayment > 0 ? currentProfile.totalPayment : currentProfile.amount}" type="number" groupingUsed="true"/> VND
            </div>
            <div class="balance-amount" id="balanceHidden" style="display: none;">
                ********* VND
            </div>
            
            <div class="security-badge">
                <div class="security-text">
                    <i class="fa-solid fa-shield-halved text-success me-1"></i> Sinh trắc học: <strong>Bảo mật cao nhất</strong><br>
                    Cập nhật: <fmt:formatDate value="${currentProfile.lastUpdated}" pattern="HH:mm dd/MM/yyyy"/>
                </div>
                <i class="fa-solid fa-fingerprint text-success" style="font-size:1.5rem; opacity:0.8;"></i>
            </div>
        </div>
        
        <!-- QUICK ACTIONS -->
        <div class="quick-actions">
            <div class="action-btn active-tab"><i class="fa-solid fa-file-invoice-dollar"></i>Khoản vay</div>
            <div class="action-btn" onclick="showInterestModal()"><i class="fa-solid fa-calculator text-primary"></i>Tính lãi</div>
            <div class="action-btn" onclick="showChatbot()"><i class="fa-solid fa-robot text-warning"></i>Robot AI</div>
        </div>
        
        <!-- AI ASSISTANT BANNER -->
        <div class="assistant-banner">
            <div class="assistant-info">
                <div class="assistant-icon"><i class="fa-solid fa-robot"></i></div>
                <div class="assistant-text">
                    <h6>Agribank AI Assistant</h6>
                    <p>Giải đáp thắc mắc 24/7</p>
                </div>
            </div>
            <button class="btn-chat" onclick="showChatbot()">Chat ngay</button>
        </div>

        <!-- TABS -->
        <div class="tabs">
            <div class="tab active">Đang vay (1)</div>
            <div class="tab">Đã tất toán (0)</div>
        </div>

        <!-- LOAN DETAIL CARD -->
        <div class="loan-card">
            <div class="loan-card-accent"></div>
            <div class="loan-card-body">
                <div class="loan-title-row">
                    <div class="loan-title"><i class="fa-solid fa-building-columns"></i> Hợp đồng tín dụng</div>
                    <div class="badge-safe"><i class="fa-solid fa-check-circle me-1"></i>An toàn</div>
                </div>
                <div class="loan-id">CIF: <c:out value="${empty currentProfile.cifNumber ? 'Không rõ' : currentProfile.cifNumber}"/> | Chi nhánh: <c:out value="${empty currentProfile.branchName ? 'Agribank' : currentProfile.branchName}"/></div>
                
                <div class="loan-purpose">
                    <strong>Mục đích:</strong> <c:out value="${currentProfile.purpose}"/><br>
                    <strong>Tài khoản vay:</strong> <c:out value="${empty currentProfile.loanAccount ? 'Đang cập nhật' : currentProfile.loanAccount}"/>
                </div>
                
                <div class="data-row">
                    <div class="data-label">Ngày giải ngân</div>
                    <div class="data-val"><c:out value="${empty currentProfile.disbursementDate ? 'Đang cập nhật' : currentProfile.disbursementDate}"/></div>
                </div>
                <div class="data-row">
                    <div class="data-label">Dư nợ gốc</div>
                    <div class="data-val"><fmt:formatNumber value="${currentProfile.amount}" type="number" groupingUsed="true"/> VND</div>
                </div>
                <div class="data-row">
                    <div class="data-label">Lãi phát sinh</div>
                    <div class="data-val text-warning"><fmt:formatNumber value="${currentProfile.accruedInterest}" type="number" groupingUsed="true"/> VND</div>
                </div>
                <div class="data-row mt-2" style="border-top: 1px solid #f0f0f0; padding-top: 10px;">
                    <div class="data-label fw-bold text-dark">Tổng tiền phải trả</div>
                    <div class="data-val red"><fmt:formatNumber value="${currentProfile.totalPayment > 0 ? currentProfile.totalPayment : currentProfile.amount}" type="number" groupingUsed="true"/> VND</div>
                </div>
                
                <div class="progress-box">
                    <div class="progress-label">
                        <span>Tiến độ thanh toán ước tính</span>
                        <span class="text-success fw-bold">35%</span>
                    </div>
                    <div class="progress">
                        <div class="progress-bar progress-bar-striped progress-bar-animated" role="progressbar" style="width: 35%;"></div>
                    </div>
                </div>
            </div>
            <div class="loan-footer">
                <a href="#">XEM CHI TIẾT LỊCH SỬ TRẢ NỢ <i class="fa-solid fa-chevron-right"></i></a>
            </div>
        </div>

        <div class="text-center mb-5 pb-4 text-muted small" style="font-size:0.65rem;">
            Dữ liệu được bảo vệ bằng mã hóa SSL 256-bit.<br>
            Bản quyền © 2026 Agribank LoanFlow.
        </div>

        <!-- BOTTOM NAV -->
        <div class="bottom-nav">
            <div class="nav-item"><i class="fa-solid fa-house"></i>Trang chủ</div>
            <div class="nav-item"><i class="fa-solid fa-clock-rotate-left"></i>Lịch sử</div>
            <div class="nav-item scan-btn">
                <div class="scan-circle"><i class="fa-solid fa-qrcode"></i></div>
                <span style="color:#059669;">QR Pay</span>
            </div>
            <div class="nav-item active"><i class="fa-solid fa-wallet"></i>Khoản vay</div>
            <div class="nav-item"><i class="fa-solid fa-gear"></i>Cài đặt</div>
        </div>
    </div>
    
    <script>
        function toggleBalance() {
            var amt = document.getElementById('balanceAmount');
            var hid = document.getElementById('balanceHidden');
            var icon = document.getElementById('eyeIcon');
            if(amt.style.display === 'none') {
                amt.style.display = 'flex';
                hid.style.display = 'none';
                icon.className = 'fa-solid fa-eye-slash';
            } else {
                amt.style.display = 'none';
                hid.style.display = 'flex';
                icon.className = 'fa-solid fa-eye';
            }
        }
        function showInterestModal() {
            Swal.fire({
                title: 'Công cụ tính lãi (Mô phỏng)',
                html: `
                    <div style="text-align:left; font-size: 0.9rem;">
                        <p><strong>Dư nợ gốc:</strong> <fmt:formatNumber value="${currentProfile.amount}" type="number" groupingUsed="true"/> VND</p>
                        <p><strong>Lãi suất ưu đãi:</strong> 8.5% / năm</p>
                        <p><strong>Kỳ hạn vay:</strong> 12 tháng</p>
                        <hr>
                        <p class="text-danger fw-bold">Dự kiến lãi phải trả tháng này: <br><span style="font-size: 1.2rem;"><fmt:formatNumber value="${currentProfile.amount * 0.085 / 12}" type="number" groupingUsed="true"/> VND</span></p>
                    </div>
                `,
                icon: 'info',
                confirmButtonText: 'Đóng',
                confirmButtonColor: '#059669'
            });
        }

        function showChatbot() {
            Swal.fire({
                title: 'Agribank AI Chatbot',
                text: 'Xin chào! Tôi là trợ lý ảo Agribank. Tính năng Chat AI đang trong quá trình nâng cấp hệ thống để phục vụ bạn tốt hơn. Vui lòng quay lại sau!',
                imageUrl: 'https://cdn-icons-png.flaticon.com/512/8943/8943377.png',
                imageWidth: 100,
                imageHeight: 100,
                confirmButtonText: 'Đã hiểu',
                confirmButtonColor: '#b01a2e'
            });
        }
    </script>
</body>
</html>
