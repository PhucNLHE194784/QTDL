<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Tra cứu khoản vay - Agribank</title>
    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@300;400;500;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        :root { --agri-red: #A51A29; --agri-red-dark: #8E1521; --agri-yellow: #f1c40f; }
        body { font-family: 'Roboto', sans-serif; background-color: #f8f9fa; min-height: 100vh; display: flex; flex-direction: column; }
        .main-header { background-color: var(--agri-red); padding: 15px 0; color: white; box-shadow: 0 2px 10px rgba(0,0,0,0.1); }
        .logo-text { font-size: 1.5rem; font-weight: 700; letter-spacing: 1px; display: flex; align-items: center; gap: 10px; text-decoration: none; color: white; }
        .logo-text i { color: var(--agri-yellow); font-size: 1.8rem; }
        .search-container { max-width: 800px; margin: 40px auto; flex: 1; width: 100%; padding: 0 15px; }
        .search-card { border: none; border-radius: 12px; box-shadow: 0 5px 20px rgba(0,0,0,0.05); overflow: hidden; }
        .search-header { background: var(--agri-red); color: white; padding: 20px; text-align: center; font-weight: 600; font-size: 1.2rem; }
        .btn-search { background: var(--agri-yellow); color: var(--agri-red-dark); font-weight: bold; border: none; padding: 12px 25px; }
        .btn-search:hover { background: #d4ac0d; color: white; }
        .result-card { border-left: 4px solid var(--agri-red); margin-bottom: 15px; transition: 0.3s; }
        .result-card:hover { transform: translateY(-3px); box-shadow: 0 5px 15px rgba(0,0,0,0.1); }
        .status-badge { font-weight: bold; padding: 8px 15px; border-radius: 50px; }
        .footer { background: var(--agri-red-dark); color: white; padding: 20px 0; text-align: center; font-size: 0.9rem; margin-top: auto; }
    </style>
</head>
<body>
    <header class="main-header">
        <div class="container d-flex justify-content-between align-items-center">
            <a href="index.jsp" class="logo-text"><i class="fa-solid fa-leaf"></i> AGRIBANK</a>
            <a href="login.jsp" class="btn btn-sm btn-light fw-bold text-danger px-3 rounded-pill"><i class="fa-solid fa-user-lock me-1"></i> Nội bộ</a>
        </div>
    </header>

    <div class="search-container">
        <div class="search-card card mb-4">
            <div class="search-header">
                <i class="fa-solid fa-magnifying-glass me-2"></i>Tra Cứu Thông Tin Khoản Vay
            </div>
            <div class="card-body p-4">
                <c:if test="${empty autoSearch || autoSearch == false}">
                    <form action="search" method="post" class="mb-2">
                        <div class="mb-3">
                            <label class="form-label text-muted fw-bold">Nhập số CCCD/CMND của bạn:</label>
                            <div class="input-group">
                                <span class="input-group-text bg-light"><i class="fa-solid fa-id-card"></i></span>
                                <input type="text" name="cccdInput" class="form-control form-control-lg" placeholder="Nhập ít nhất 6 số cuối CCCD..." required>
                                <button type="submit" class="btn btn-search"><i class="fa-solid fa-paper-plane me-1"></i> Tra cứu</button>
                            </div>
                        </div>
                    </form>
                </c:if>
                <c:if test="${autoSearch == true}">
                    <div class="alert alert-success"><i class="fa-solid fa-circle-check me-2"></i>Mã định danh hợp lệ. Dưới đây là thông tin các hồ sơ của bạn.</div>
                    <div class="text-center mt-3">
                        <a href="search.jsp" class="btn btn-outline-secondary btn-sm"><i class="fa-solid fa-rotate-right me-1"></i>Tra cứu hồ sơ khác</a>
                    </div>
                </c:if>
                
                <c:if test="${not empty error}">
                    <div class="alert alert-danger mb-0"><i class="fa-solid fa-triangle-exclamation me-2"></i>${error}</div>
                    <div class="text-center mt-3">
                        <a href="search.jsp" class="btn btn-outline-secondary btn-sm"><i class="fa-solid fa-rotate-right me-1"></i>Thử lại</a>
                    </div>
                </c:if>
            </div>
        </div>

        <c:if test="${not empty profiles}">
            <h5 class="fw-bold mb-3 text-dark">Kết Quả Hồ Sơ Của Bạn (${profiles.size()})</h5>
            <c:forEach var="p" items="${profiles}">
                <div class="card result-card">
                    <div class="card-body">
                        <div class="d-flex justify-content-between align-items-start mb-3">
                            <div>
                                <h5 class="fw-bold text-dark mb-1">${p.customerName}</h5>
                                <span class="text-muted small"><i class="fa-solid fa-hashtag me-1"></i>Mã HS: <strong>${p.id}</strong></span>
                            </div>
                            <span class="badge bg-warning text-dark status-badge fs-6">${p.status}</span>
                        </div>
                        <div class="row g-2">
                            <div class="col-sm-4">
                                <div class="text-muted small">Điểm tín dụng</div>
                                <c:choose>
                                    <c:when test="${p.creditScore >= 80}">
                                        <div class="fw-bold text-success fs-5">${p.creditScore}/100 (Tốt)</div>
                                    </c:when>
                                    <c:when test="${p.creditScore >= 50}">
                                        <div class="fw-bold text-warning fs-5">${p.creditScore}/100 (Khá)</div>
                                    </c:when>
                                    <c:otherwise>
                                        <div class="fw-bold text-danger fs-5">${p.creditScore}/100 (Xấu)</div>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                            <div class="col-sm-4">
                                <div class="text-muted small">Số tiền đề nghị vay</div>
                                <div class="fw-bold text-danger fs-5"><fmt:formatNumber value="${p.amount}" pattern="#,###"/> VNĐ</div>
                            </div>
                            <div class="col-sm-4 text-sm-end">
                                <div class="text-muted small">Cập nhật lần cuối</div>
                                <div class="fw-medium text-dark"><i class="fa-regular fa-clock me-1 text-secondary"></i>${p.lastUpdated}</div>
                            </div>
                        </div>
                    </div>
                </div>
            </c:forEach>
        </c:if>
    </div>

    <footer class="footer">
        <div class="container">
            <p class="mb-0">© 2026 Agribank LoanFlow - Hệ thống tra cứu minh bạch khoản vay.</p>
        </div>
    </footer>
</body>
</html>
