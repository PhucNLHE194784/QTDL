<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Tra cứu Hồ sơ Tín dụng</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        body {
            font-family: 'Inter', sans-serif;
            background: linear-gradient(135deg, #fdfbfb 0%, #ebedee 100%);
            min-height: 100vh;
        }
        .search-card {
            border: none;
            border-radius: 20px;
            box-shadow: 0 10px 40px rgba(0,0,0,0.08);
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(10px);
        }
        .header-title {
            color: #2e7d32;
            font-weight: 700;
            letter-spacing: -0.5px;
        }
        .result-card {
            border: none;
            border-radius: 16px;
            box-shadow: 0 6px 20px rgba(0,0,0,0.04);
            transition: transform 0.2s, box-shadow 0.2s;
            border-left: 6px solid #2e7d32;
        }
        .result-card:hover {
            transform: translateY(-4px);
            box-shadow: 0 12px 30px rgba(0,0,0,0.1);
        }
        .badge-status {
            font-size: 0.9rem;
            padding: 8px 16px;
            border-radius: 30px;
            letter-spacing: 0.5px;
        }
        .form-control {
            border-radius: 12px;
            padding: 14px 15px;
            border: 1px solid #e0e0e0;
            background-color: #f9fafb;
        }
        .form-control:focus {
            box-shadow: 0 0 0 0.25rem rgba(46, 125, 50, 0.2);
            border-color: #2e7d32;
            background-color: #ffffff;
        }
        .input-group-text {
            border-radius: 12px 0 0 12px;
            border: 1px solid #e0e0e0;
            background-color: #f9fafb;
        }
        .btn-search {
            border-radius: 12px;
            padding: 14px;
            font-weight: 600;
            font-size: 1.1rem;
            background: linear-gradient(45deg, #2e7d32, #43a047);
            border: none;
            box-shadow: 0 4px 15px rgba(46, 125, 50, 0.3);
            transition: all 0.3s;
        }
        .btn-search:hover {
            background: linear-gradient(45deg, #1b5e20, #2e7d32);
            box-shadow: 0 6px 20px rgba(46, 125, 50, 0.4);
            transform: translateY(-1px);
        }
    </style>
</head>
<body>
    <div class="container mt-5 mb-5">
        <div class="row justify-content-center">
            <div class="col-md-7 col-lg-6">
                <div class="text-center mb-4">
                    <h2 class="header-title"><i class="fa-solid fa-shield-halved me-2"></i>Tra cứu Hồ sơ Tín dụng</h2>
                    <p class="text-muted">Nhanh chóng, An toàn và Bảo mật</p>
                </div>

                <c:if test="${empty autoSearch}">
                    <div class="card search-card">
                        <div class="card-body p-4 p-md-5">
                            <form action="search" method="post">
                                <div class="mb-4">
                                    <label class="form-label fw-semibold text-secondary">Mã hồ sơ (Không bắt buộc):</label>
                                    <div class="input-group">
                                        <span class="input-group-text border-end-0"><i class="fa-solid fa-barcode text-muted"></i></span>
                                        <input type="text" name="id" class="form-control border-start-0 ps-0" placeholder="Để trống nếu không nhớ mã" value="${param.id != null ? param.id : ''}" ${(not empty param.id) ? 'readonly' : ''}>
                                    </div>
                                </div>
                                <div class="mb-4">
                                    <label class="form-label fw-semibold text-secondary">Số CCCD (4 số cuối hoặc toàn bộ):</label>
                                    <div class="input-group">
                                        <span class="input-group-text border-end-0"><i class="fa-regular fa-id-card text-muted"></i></span>
                                        <input type="tel" name="cccdInput" class="form-control border-start-0 ps-0" inputmode="numeric" placeholder="Ví dụ: 0123456789" required>
                                    </div>
                                </div>
                                <button type="submit" class="btn btn-success w-100 btn-search text-white mt-2">
                                    <i class="fa-solid fa-magnifying-glass me-2"></i>Tra cứu tiến độ
                                </button>
                            </form>
                        </div>
                    </div>
                </c:if>
                <c:if test="${not empty autoSearch}">
                    <div class="text-center mt-2 mb-4">
                        <a href="index.jsp" class="btn btn-outline-success rounded-pill px-4"><i class="fa-solid fa-rotate-left me-2"></i>Tra cứu bằng CCCD khác</a>
                    </div>
                </c:if>

                <c:if test="${not empty error}">
                    <div class="alert alert-danger mt-4 rounded-3 shadow-sm border-0"><i class="fa-solid fa-circle-exclamation me-2"></i>${error}</div>
                </c:if>

                <c:if test="${not empty profiles}">
                    <h5 class="mt-5 mb-3 fw-bold text-secondary"><i class="fa-solid fa-list-check me-2"></i>Kết quả tra cứu (${profiles.size()} hồ sơ)</h5>
                    <c:forEach var="p" items="${profiles}">
                        <div class="card mt-3 result-card">
                            <div class="card-body p-4">
                                <div class="d-flex justify-content-between align-items-center mb-3">
                                    <h5 class="mb-0 fw-bold text-dark"><i class="fa-regular fa-folder-open text-success me-2"></i>${p.id}</h5>
                                    <span class="badge bg-warning text-dark badge-status fw-semibold shadow-sm"><i class="fa-solid fa-spinner fa-spin-pulse me-1" style="--fa-animation-duration: 2s;"></i>${p.status}</span>
                                </div>
                                <hr class="text-muted opacity-25">
                                <div class="row mb-2">
                                    <div class="col-5 text-secondary"><i class="fa-regular fa-user me-2"></i>Khách hàng</div>
                                    <div class="col-7 fw-semibold">${p.customerName}</div>
                                </div>
                                <div class="row mb-2">
                                    <div class="col-5 text-secondary"><i class="fa-solid fa-money-bill-wave me-2"></i>Số tiền vay</div>
                                    <div class="col-7 fw-semibold text-danger">${p.amount} VNĐ</div>
                                </div>
                                <div class="row mb-2">
                                    <div class="col-5 text-secondary"><i class="fa-regular fa-file-lines me-2"></i>Mục đích</div>
                                    <div class="col-7 fw-semibold text-dark">${p.purpose}</div>
                                </div>
                                <div class="row mt-3 pt-3 border-top border-light">
                                    <div class="col-12 text-end text-muted" style="font-size: 0.85rem;">
                                        <i class="fa-regular fa-clock me-1"></i>Cập nhật lần cuối: ${p.lastUpdated}
                                    </div>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </c:if>
            </div>
        </div>
    </div>
</body>
</html>
