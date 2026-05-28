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
        <div class="text-center mb-5 text-muted small">
            Dữ liệu được bảo mật và truyền tải qua mã hóa SSL.<br>
            Bản quyền © 2026 Agribank LoanFlow.
        </div>
    </div>
</body>
</html>
