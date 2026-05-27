<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Xác Thực OTP - Agribank LoanFlow</title>
    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@300;400;500;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        :root { --agri-red: #A51A29; --agri-red-dark: #8E1521; --agri-yellow: #f1c40f; }
        body { font-family: 'Roboto', sans-serif; background-color: #f8f9fa; min-height: 100vh; display: flex; flex-direction: column; }
        .main-header { background-color: var(--agri-red); padding: 15px 0; color: white; box-shadow: 0 2px 10px rgba(0,0,0,0.1); }
        .logo-text { font-size: 1.5rem; font-weight: 700; display: flex; align-items: center; gap: 10px; text-decoration: none; color: white; }
        .logo-text i { color: var(--agri-yellow); font-size: 1.8rem; }
        .otp-container { max-width: 450px; margin: 60px auto; flex: 1; width: 100%; padding: 0 15px; }
        .otp-card { border: none; border-radius: 15px; box-shadow: 0 10px 30px rgba(0,0,0,0.1); overflow: hidden; }
        .otp-header { background: var(--agri-red); color: white; padding: 25px; text-align: center; }
        .otp-header i { font-size: 3rem; color: var(--agri-yellow); margin-bottom: 10px; }
        .otp-inputs { display: flex; gap: 10px; justify-content: center; margin: 20px 0; }
        .otp-input { width: 50px; height: 60px; font-size: 24px; text-align: center; font-weight: bold; border: 2px solid #ddd; border-radius: 8px; }
        .otp-input:focus { border-color: var(--agri-red); box-shadow: 0 0 0 0.25rem rgba(165, 26, 41, 0.25); outline: none; }
        .btn-verify { background: var(--agri-red); color: white; font-weight: bold; padding: 12px; border-radius: 8px; width: 100%; transition: 0.3s; }
        .btn-verify:hover { background: var(--agri-red-dark); color: white; }
    </style>
</head>
<body>
    <header class="main-header">
        <div class="container d-flex justify-content-center">
            <a href="index.jsp" class="logo-text"><img src="assets/img/agribank_logo.png" alt="Agribank" style="height: 35px; background: white; padding: 3px; border-radius: 3px;"> AGRIBANK LOANFLOW</a>
        </div>
    </header>

    <div class="otp-container">
        <div class="card otp-card">
            <div class="otp-header">
                <i class="fa-solid fa-shield-halved"></i>
                <h4 class="fw-bold mb-0">XÁC THỰC BẢO MẬT 2FA</h4>
            </div>
            <div class="card-body p-4 text-center">
                <p class="text-muted mb-4">Mã OTP gồm 6 chữ số đã được gửi tới email <strong>${maskedEmail}</strong>. Vui lòng kiểm tra hộp thư (kể cả thư rác) và nhập mã để xem Sao Kê.</p>
                
                <c:if test="${not empty error}">
                    <div class="alert alert-danger py-2"><i class="fa-solid fa-triangle-exclamation me-2"></i>${error}</div>
                </c:if>

                <form action="otp" method="post" id="otpForm">
                    <input type="hidden" name="id" value="${id}">
                    <input type="hidden" name="otp" id="fullOtp">
                    
                    <div class="otp-inputs" id="inputs">
                        <input class="otp-input" type="text" inputmode="numeric" maxlength="1" required>
                        <input class="otp-input" type="text" inputmode="numeric" maxlength="1" required>
                        <input class="otp-input" type="text" inputmode="numeric" maxlength="1" required>
                        <input class="otp-input" type="text" inputmode="numeric" maxlength="1" required>
                        <input class="otp-input" type="text" inputmode="numeric" maxlength="1" required>
                        <input class="otp-input" type="text" inputmode="numeric" maxlength="1" required>
                    </div>

                    <button type="submit" class="btn btn-verify mt-3">
                        <i class="fa-solid fa-unlock-keyhole me-2"></i> XÁC NHẬN MÃ OTP
                    </button>
                </form>
                
                <div class="mt-4 small text-muted">
                    Chưa nhận được mã? 
                    <span id="countdownWrapper">Gửi lại sau (<span id="countdown" class="fw-bold text-danger">120</span>s)</span>
                    <a href="otp?id=${id}" id="resendLink" class="text-decoration-none text-danger fw-bold" style="display: none;">Gửi lại mã OTP qua Email</a>
                </div>
            </div>
        </div>
    </div>

    <script>
        const inputs = document.querySelectorAll('.otp-input');
        const form = document.getElementById('otpForm');
        const fullOtp = document.getElementById('fullOtp');

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

        // Đếm ngược gửi lại
        let timeLeft = 120;
        const countdownEl = document.getElementById('countdown');
        const countdownWrapper = document.getElementById('countdownWrapper');
        const resendLink = document.getElementById('resendLink');
        
        let timer = setInterval(() => {
            if (timeLeft > 0) {
                timeLeft--;
                countdownEl.innerText = timeLeft;
            } else {
                clearInterval(timer);
                countdownWrapper.style.display = 'none';
                resendLink.style.display = 'inline';
            }
        }, 1000);
    </script>
</body>
</html>
