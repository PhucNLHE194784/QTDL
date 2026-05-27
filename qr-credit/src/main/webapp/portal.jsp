<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Xác thực bảo mật - Cổng thông tin khách hàng</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        body { background-color: #f8f9fa; }
        .auth-card {
            max-width: 450px;
            margin: 50px auto;
            border: none;
            border-radius: 15px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.1);
        }
        .brand-header {
            background-color: #A51A29;
            color: white;
            padding: 20px;
            border-radius: 15px 15px 0 0;
            text-align: center;
        }
        .otp-input {
            width: 45px;
            height: 55px;
            font-size: 24px;
            text-align: center;
            border: 2px solid #ddd;
            border-radius: 8px;
            margin: 0 4px;
        }
        .otp-input:focus {
            border-color: #A51A29;
            box-shadow: 0 0 0 0.2rem rgba(165,26,41,0.25);
            outline: none;
        }
        .btn-primary { background-color: #A51A29; border-color: #A51A29; }
        .btn-primary:hover { background-color: #8a1522; border-color: #8a1522; }
    </style>
</head>
<body>
    <div class="container">
        <div class="card auth-card">
            <div class="brand-header">
                <h4 class="mb-0"><i class="fas fa-shield-alt me-2"></i>BẢO MẬT KHOẢN VAY</h4>
            </div>
            <div class="card-body p-4 text-center">
                <c:if test="${not empty error}">
                    <div class="alert alert-danger">${error}</div>
                </c:if>
                <c:if test="${not empty param.message}">
                    <div class="alert alert-success">${param.message}</div>
                </c:if>

                <c:choose>
                    <c:when test="${locked}">
                        <div class="mb-4 text-danger">
                            <i class="fas fa-lock fa-4x mb-3"></i>
                            <h5>Phiên đăng nhập bị khóa</h5>
                            <p>Bạn đã nhập sai quá số lần quy định.</p>
                        </div>
                        <form action="portal" method="post">
                            <input type="hidden" name="action" value="resend">
                            <input type="hidden" name="token" value="${token}">
                            <button type="submit" class="btn btn-primary w-100 py-2">
                                <i class="fas fa-sync-alt me-2"></i>YÊU CẦU CẤP LẠI MÃ OTP
                            </button>
                        </form>
                    </c:when>
                    <c:otherwise>
                        <h5 class="mb-3">Xác thực mã OTP</h5>
                        <p class="text-muted small mb-4">
                            <c:choose>
                                <c:when test="${otpMethod == 'SMS'}">
                                    Mã xác thực 6 số đã được gửi qua SMS đến số điện thoại <strong>${maskedContact}</strong>.<br>
                                </c:when>
                                <c:otherwise>
                                    Mã xác thực 6 số đã được gửi đến email <strong>${maskedContact}</strong>.<br>
                                </c:otherwise>
                            </c:choose>
                            Vui lòng nhập mã để xem hồ sơ.
                        </p>

                        <form action="portal" method="post" id="otpForm">
                            <input type="hidden" name="action" value="verify">
                            <input type="hidden" name="token" value="${token}">
                            <div class="d-flex justify-content-center mb-4">
                                <input type="text" class="form-control otp-input" maxlength="1" pattern="[0-9]" required>
                                <input type="text" class="form-control otp-input" maxlength="1" pattern="[0-9]" required>
                                <input type="text" class="form-control otp-input" maxlength="1" pattern="[0-9]" required>
                                <input type="text" class="form-control otp-input" maxlength="1" pattern="[0-9]" required>
                                <input type="text" class="form-control otp-input" maxlength="1" pattern="[0-9]" required>
                                <input type="text" class="form-control otp-input" maxlength="1" pattern="[0-9]" required>
                            </div>
                            <input type="hidden" name="otp" id="fullOtp">
                            <button type="submit" class="btn btn-primary w-100 py-2 fw-bold">XÁC NHẬN</button>
                        </form>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>

    <script>
        const inputs = document.querySelectorAll('.otp-input');
        const form = document.getElementById('otpForm');
        const fullOtp = document.getElementById('fullOtp');

        if (inputs.length > 0) {
            inputs.forEach((input, index) => {
                input.addEventListener('input', (e) => {
                    if (e.target.value.length === 1 && index < inputs.length - 1) {
                        inputs[index + 1].focus();
                    }
                });
                input.addEventListener('keydown', (e) => {
                    if (e.key === 'Backspace' && e.target.value === '' && index > 0) {
                        inputs[index - 1].focus();
                    }
                });
            });

            form.addEventListener('submit', (e) => {
                let otp = '';
                inputs.forEach(input => otp += input.value);
                fullOtp.value = otp;
            });
        }
    </script>
</body>
</html>
