<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đăng nhập Nội bộ - AgriQR LoanFlow</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        body {
            font-family: 'Inter', sans-serif;
            margin: 0;
            padding: 0;
            height: 100vh;
            overflow: hidden;
            background-color: #ffffff;
        }
        
        .left-panel {
            background-color: #8E1521;
            color: white;
            height: 100vh;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
        }
        
        .bank-title {
            font-family: 'Times New Roman', Times, serif;
            font-size: 1.8rem;
            font-weight: 700;
            text-align: center;
            margin-top: 50px;
            text-transform: uppercase;
            letter-spacing: 1px;
            line-height: 1.4;
        }
        
        .hero-image {
            width: 80%;
            max-width: 400px;
            margin: 0 auto;
            border-radius: 5px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.3);
        }
        
        .icon-menu {
            display: flex;
            justify-content: space-around;
            padding: 20px;
            margin-bottom: 20px;
        }
        
        .icon-item {
            text-align: center;
            font-size: 0.75rem;
            cursor: pointer;
            transition: 0.3s;
            width: 70px;
        }
        
        .icon-item:hover {
            color: #f1c40f;
        }
        
        .icon-item i {
            font-size: 1.5rem;
            margin-bottom: 10px;
            display: block;
        }
        
        .right-panel {
            height: 100vh;
            display: flex;
            flex-direction: column;
            position: relative;
        }
        
        .top-right-menu {
            position: absolute;
            top: 20px;
            right: 30px;
            display: flex;
            align-items: center;
            gap: 15px;
        }
        
        .lang-badge {
            border: 1px solid #ccc;
            padding: 4px 10px;
            border-radius: 4px;
            font-size: 0.85rem;
            font-weight: 600;
            color: #333;
            cursor: pointer;
        }
        
        .contact-link {
            color: #8E1521;
            text-decoration: none;
            font-weight: 600;
            font-size: 0.9rem;
        }
        
        .login-container {
            flex-grow: 1;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        
        .login-box {
            width: 100%;
            max-width: 420px;
            padding: 20px;
        }
        
        .logo-agri {
            color: #8E1521;
            font-size: 1.8rem;
            font-weight: 700;
            margin-bottom: 15px;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 10px;
        }
        
        .welcome-text {
            color: #333;
            font-weight: 600;
            font-size: 0.9rem;
            margin-bottom: 5px;
        }
        
        .system-text {
            color: #000;
            font-weight: 700;
            font-size: 1.1rem;
            margin-bottom: 30px;
        }
        
        .form-label {
            font-weight: 700;
            font-size: 0.85rem;
            color: #333;
        }
        
        .input-custom {
            border-radius: 4px;
            border: 1px solid #ccc;
            padding: 10px 15px;
        }
        
        .input-custom:focus {
            border-color: #8E1521;
            box-shadow: none;
        }
        
        .input-red-border {
            border-color: #8E1521;
        }
        
        .btn-submit {
            background-color: #9c1c2b;
            color: white;
            border: none;
            border-radius: 4px;
            padding: 12px;
            font-weight: 600;
            transition: 0.3s;
        }
        
        .btn-submit:hover {
            background-color: #7a1116;
            color: white;
        }
    </style>
</head>
<body>
    <div class="row g-0">
        <!-- Left Panel -->
        <div class="col-md-5 d-none d-md-flex left-panel">
            <div>
                <h1 class="bank-title">Ngân hàng Nông nghiệp<br>và Phát triển Nông thôn Việt Nam</h1>
                <div class="text-center mt-5">
                    <img src="https://images.unsplash.com/photo-1573164713988-8665fc963095?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80" alt="Agribank" class="hero-image">
                </div>
            </div>
            
            <div>
                <div class="icon-menu">
                    <div class="icon-item">
                        <i class="fa-solid fa-lock"></i>
                        Quên mật khẩu
                    </div>
                    <div class="icon-item">
                        <i class="fa-solid fa-money-bill-transfer"></i>
                        Truy vấn tỷ giá
                    </div>
                    <div class="icon-item">
                        <i class="fa-solid fa-chart-line"></i>
                        Truy vấn lãi suất
                    </div>
                    <div class="icon-item">
                        <i class="fa-solid fa-circle-info"></i>
                        Truy vấn tài khoản
                    </div>
                    <div class="icon-item">
                        <i class="fa-solid fa-file-invoice-dollar"></i>
                        Biểu phí
                    </div>
                </div>
                <div class="text-center pb-3" style="font-size: 0.75rem; opacity: 0.7;">
                    © 2026 Bản quyền thuộc về Ngân hàng Nông nghiệp và Phát triển Nông thôn Việt Nam.
                </div>
            </div>
        </div>
        
        <!-- Right Panel -->
        <div class="col-md-7 right-panel">
            <div class="top-right-menu d-none d-sm-flex">
                <div class="dropdown">
                    <div class="lang-badge" data-bs-toggle="dropdown" aria-expanded="false" id="langBadge">
                        VIE <i class="fa-solid fa-caret-down ms-1"></i>
                    </div>
                    <ul class="dropdown-menu dropdown-menu-end shadow border-0" style="min-width: 100px;">
                        <li><a class="dropdown-item fw-bold" href="#" onclick="switchLang('VIE')">Tiếng Việt</a></li>
                        <li><a class="dropdown-item fw-bold" href="#" onclick="switchLang('ENG')">English</a></li>
                    </ul>
                </div>
                <a href="#" class="contact-link" id="contactLink" onclick="alertContact(event)">Liên hệ</a>
            </div>
            
            <div class="login-container">
                <div class="login-box text-center">
                    <div class="logo-agri">
                        <img src="assets/img/agribank_logo.png" alt="Agribank Logo" style="height: 50px; margin-right: 10px;">
                    </div>
                    <div class="welcome-text" id="txtWelcome">Chào mừng đến với</div>
                    <div class="system-text" id="txtSystem">Hệ thống Khởi tạo Tín dụng - Khách hàng cá nhân</div>
                    
                    <form action="auth" method="post" class="text-start mt-4" onsubmit="return validateForm(event)">
                        <input type="hidden" name="action" value="login">
                        
                        <div class="mb-3">
                            <label class="form-label" id="lblUser">Tên đăng nhập <span class="text-danger">*</span></label>
                            <input type="text" name="username" class="form-control input-custom input-red-border" required>
                        </div>
                        
                        <div class="mb-3">
                            <label class="form-label" id="lblPass">Mật khẩu <span class="text-danger">*</span></label>
                            <div class="input-group">
                                <input type="password" name="password" id="pwd" class="form-control input-custom border-end-0" required>
                                <span class="input-group-text bg-white" style="border-radius: 0 4px 4px 0; cursor: pointer; color: #8E1521;" onclick="togglePwd()">
                                    <i class="fa-solid fa-eye" id="eyeIcon"></i>
                                </span>
                            </div>
                        </div>
                        
                        <div class="mb-4">
                            <label class="form-label" id="lblCaptcha">Mã ngẫu nhiên <span class="text-danger">*</span></label>
                            <div class="input-group">
                                <input type="text" id="captchaInput" class="form-control input-custom border-end-0" placeholder="Nhập mã bên phải" required>
                                <span class="input-group-text p-0 bg-white" style="border-radius: 0 4px 4px 0; overflow: hidden; cursor: pointer;" onclick="generateCaptcha()" title="Bấm để đổi mã mới">
                                    <canvas id="captchaCanvas" width="120" height="42"></canvas>
                                </span>
                            </div>
                        </div>
                        
                        <button type="submit" class="btn btn-submit w-100" id="btnLogin">
                            <i class="fa-solid fa-right-to-bracket me-2"></i>Đăng nhập
                        </button>
                    </form>
                    
                    <% if(request.getAttribute("error") != null) { %>
                        <div class="alert alert-danger mt-3 py-2 text-start" style="font-size: 0.85rem;"><i class="fa-solid fa-circle-exclamation me-2"></i><%= request.getAttribute("error") %></div>
                    <% } %>
                </div>
            </div>
        </div>
    </div>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        const dict = {
            'VIE': {
                'welcome': 'Chào mừng đến với',
                'system': 'Hệ thống Khởi tạo Tín dụng - Khách hàng cá nhân',
                'userLabel': 'Tên đăng nhập',
                'passLabel': 'Mật khẩu',
                'captchaLabel': 'Mã ngẫu nhiên',
                'loginBtn': '<i class="fa-solid fa-right-to-bracket me-2"></i>Đăng nhập',
                'contact': 'Liên hệ'
            },
            'ENG': {
                'welcome': 'Welcome to',
                'system': 'Retail Credit Origination System',
                'userLabel': 'Username',
                'passLabel': 'Password',
                'captchaLabel': 'Captcha code',
                'loginBtn': '<i class="fa-solid fa-right-to-bracket me-2"></i>Login',
                'contact': 'Contact'
            }
        };

        function switchLang(lang) {
            document.getElementById('langBadge').innerHTML = lang + ' <i class="fa-solid fa-caret-down ms-1"></i>';
            document.getElementById('txtWelcome').innerText = dict[lang].welcome;
            document.getElementById('txtSystem').innerText = dict[lang].system;
            document.getElementById('lblUser').innerHTML = dict[lang].userLabel + ' <span class="text-danger">*</span>';
            document.getElementById('lblPass').innerHTML = dict[lang].passLabel + ' <span class="text-danger">*</span>';
            document.getElementById('lblCaptcha').innerHTML = dict[lang].captchaLabel + ' <span class="text-danger">*</span>';
            document.getElementById('btnLogin').innerHTML = dict[lang].loginBtn;
            document.getElementById('contactLink').innerText = dict[lang].contact;
        }

        function alertContact(e) {
            e.preventDefault();
            alert("Hotline: 1900558818\nEmail: cskh@agribank.com.vn\nĐịa chỉ: Số 2 Láng Hạ, Ba Đình, Hà Nội");
        }

        function togglePwd() {
            var pwd = document.getElementById("pwd");
            var icon = document.getElementById("eyeIcon");
            if (pwd.type === "password") {
                pwd.type = "text";
                icon.classList.remove("fa-eye");
                icon.classList.add("fa-eye-slash");
            } else {
                pwd.type = "password";
                icon.classList.remove("fa-eye-slash");
                icon.classList.add("fa-eye");
            }
        }

        let captchaCode = "";
        function generateCaptcha() {
            const chars = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ";
            captchaCode = "";
            for (let i = 0; i < 5; i++) {
                captchaCode += chars.charAt(Math.floor(Math.random() * chars.length));
            }
            const canvas = document.getElementById("captchaCanvas");
            const ctx = canvas.getContext("2d");
            ctx.clearRect(0, 0, canvas.width, canvas.height);
            ctx.fillStyle = "#f4f4f4";
            ctx.fillRect(0, 0, canvas.width, canvas.height);
            
            for(let i=0; i<5; i++){
                ctx.strokeStyle = "#ccc";
                ctx.beginPath();
                ctx.moveTo(Math.random() * canvas.width, Math.random() * canvas.height);
                ctx.lineTo(Math.random() * canvas.width, Math.random() * canvas.height);
                ctx.stroke();
            }
            
            ctx.font = "bold 24px 'Courier New', Courier, monospace";
            ctx.fillStyle = "#8E1521";
            ctx.fillText(captchaCode, 20, 30);
        }

        document.addEventListener("DOMContentLoaded", generateCaptcha);

        function validateForm(e) {
            const userInput = document.getElementById("captchaInput").value.toUpperCase();
            if (userInput !== captchaCode) {
                e.preventDefault();
                alert("Mã ngẫu nhiên không chính xác. Vui lòng nhập lại!");
                generateCaptcha();
                document.getElementById("captchaInput").value = "";
                return false;
            }
            return true;
        }
    </script>
</body>
</html>
