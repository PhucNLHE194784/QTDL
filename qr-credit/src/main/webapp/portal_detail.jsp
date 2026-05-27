<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chi Tiết Khoản Vay - Cổng Khách Hàng</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        body { background-color: #f4f6f9; color: #333; font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; }
        .header { background-color: #A51A29; color: white; padding: 20px 0; border-bottom: 5px solid #d4a373; }
        .card-custom { border: none; border-radius: 12px; box-shadow: 0 4px 15px rgba(0,0,0,0.05); margin-bottom: 25px; overflow: hidden; }
        .card-header-custom { background-color: #fff; border-bottom: 2px solid #f0f0f0; padding: 15px 20px; font-weight: 600; color: #A51A29; }
        .info-label { color: #6c757d; font-size: 0.9rem; font-weight: 500; text-transform: uppercase; letter-spacing: 0.5px; }
        .info-value { font-size: 1.1rem; font-weight: 600; color: #212529; }
        .table-custom { margin-bottom: 0; }
        .table-custom thead th { background-color: #f8f9fa; color: #495057; font-weight: 600; border-bottom: 2px solid #dee2e6; padding: 12px; }
        .table-custom tbody td { padding: 12px; vertical-align: middle; border-bottom: 1px solid #f0f0f0; }
        .amount-positive { color: #28a745; font-weight: 600; }
        .amount-negative { color: #dc3545; font-weight: 600; }
    </style>
</head>
<body>
    <div class="header">
        <div class="container d-flex justify-content-between align-items-center">
            <h4 class="mb-0"><i class="fas fa-university me-2"></i>Agribank LoanFlow</h4>
            <span><i class="fas fa-user-circle me-1"></i> ${currentProfile.customerName}</span>
        </div>
    </div>

    <div class="container mt-4">
        <h3 class="mb-4 text-center">BẢO MẬT & CHI TIẾT TÍN DỤNG</h3>
        
        <!-- Bảng Thông Tin Tổng Quan -->
        <div class="row">
            <div class="col-md-12">
                <div class="card card-custom">
                    <div class="card-header-custom">
                        <i class="fas fa-file-invoice-dollar me-2"></i>THÔNG TIN HỢP ĐỒNG KHOẢN VAY (${currentProfile.id})
                    </div>
                    <div class="card-body p-4">
                        <div class="row g-4">
                            <div class="col-md-4">
                                <div class="info-label">Khách hàng</div>
                                <div class="info-value text-uppercase">${currentProfile.customerName}</div>
                            </div>
                            <div class="col-md-4">
                                <div class="info-label">Số tiền vay vốn (Ban đầu)</div>
                                <div class="info-value text-danger">
                                    <fmt:formatNumber value="${currentProfile.amount}" type="number" groupingUsed="true"/> VNĐ
                                </div>
                            </div>
                            <div class="col-md-4">
                                <div class="info-label">Dư nợ hiện tại</div>
                                <div class="info-value text-danger">
                                    <!-- Giả lập dư nợ còn lại (ví dụ đã trả 30%) -->
                                    <fmt:formatNumber value="${currentProfile.amount * 0.7}" type="number" groupingUsed="true"/> VNĐ
                                </div>
                            </div>
                            <div class="col-md-4">
                                <div class="info-label">Ngày đến hạn HĐ</div>
                                <div class="info-value">
                                    <c:choose>
                                        <c:when test="${not empty currentProfile.maturityDate}">
                                            <fmt:formatDate value="${currentProfile.maturityDate}" pattern="dd/MM/yyyy"/>
                                        </c:when>
                                        <c:otherwise>27/05/2027</c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                            <div class="col-md-4">
                                <div class="info-label">Lãi suất (Ngắn/Dài hạn)</div>
                                <div class="info-value">
                                    <c:choose>
                                        <c:when test="${not empty currentProfile.interestRate}">
                                            ${currentProfile.interestRate}
                                        </c:when>
                                        <c:otherwise>10.5% / năm (Trung hạn)</c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                            <div class="col-md-4">
                                <div class="info-label">Cán bộ quản lý</div>
                                <div class="info-value">
                                    <c:choose>
                                        <c:when test="${not empty currentProfile.officerName}">
                                            ${currentProfile.officerName}
                                        </c:when>
                                        <c:otherwise>Nguyễn Lâm Phúc</c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Bảng Lịch Sử Trả Lãi (Giả lập để Demo) -->
        <div class="row">
            <div class="col-md-12">
                <div class="card card-custom">
                    <div class="card-header-custom d-flex justify-content-between align-items-center">
                        <div><i class="fas fa-history me-2"></i>LỊCH SỬ THU NỢ & TRẢ LÃI</div>
                        <span class="badge bg-success">Đã xác thực</span>
                    </div>
                    <div class="card-body p-0">
                        <div class="table-responsive">
                            <table class="table table-custom table-hover">
                                <thead>
                                    <tr>
                                        <th>Ngày GD</th>
                                        <th>Kỳ tính lãi</th>
                                        <th class="text-end">Gốc đã trả</th>
                                        <th class="text-end">Lãi đã trả</th>
                                        <th class="text-end">Phí GD</th>
                                        <th class="text-end">Tổng cộng</th>
                                        <th>Trạng thái</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <%
                                        // Sinh dữ liệu giả lập dựa trên số tiền vay
                                        com.qrcredit.model.Profile p = (com.qrcredit.model.Profile) request.getAttribute("currentProfile");
                                        double baseAmount = p != null ? p.getAmount() : 100000000;
                                        double principalPerMonth = baseAmount * 0.1; // Trả gốc 10%
                                        double interestPerMonth = baseAmount * 0.01; // Trả lãi 1%
                                        double fee = 22000;
                                        
                                        java.util.Calendar cal = java.util.Calendar.getInstance();
                                        cal.add(java.util.Calendar.MONTH, -3); // Lùi 3 tháng
                                        java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("dd/MM/yyyy");
                                        
                                        for(int i=0; i<3; i++) {
                                            String dateStr = sdf.format(cal.getTime());
                                            java.util.Calendar fromCal = (java.util.Calendar) cal.clone();
                                            fromCal.add(java.util.Calendar.MONTH, -1);
                                            String periodStr = sdf.format(fromCal.getTime()) + " - " + dateStr;
                                            double total = principalPerMonth + interestPerMonth + fee;
                                    %>
                                    <tr>
                                        <td><%= dateStr %></td>
                                        <td class="text-muted small"><%= periodStr %></td>
                                        <td class="text-end"><fmt:formatNumber value="<%= principalPerMonth %>" type="number" groupingUsed="true"/></td>
                                        <td class="text-end"><fmt:formatNumber value="<%= interestPerMonth %>" type="number" groupingUsed="true"/></td>
                                        <td class="text-end"><fmt:formatNumber value="<%= fee %>" type="number" groupingUsed="true"/></td>
                                        <td class="text-end amount-positive">+<fmt:formatNumber value="<%= total %>" type="number" groupingUsed="true"/></td>
                                        <td><span class="badge bg-success">Thành công</span></td>
                                    </tr>
                                    <%
                                            cal.add(java.util.Calendar.MONTH, 1);
                                        }
                                    %>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div class="text-center mb-5 text-muted small">
            Dữ liệu được bảo mật và truyền tải qua mã hóa SSL.<br>
            Bản quyền © 2026 Agribank LoanFlow.
        </div>
    </div>
</body>
</html>
