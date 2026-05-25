<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>AgriQR LoanFlow - Nền Tảng Khởi Tạo Tín Dụng</title>
    <!-- Fonts & Icons -->
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Animation -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/animate.css/4.1.1/animate.min.css"/>
    
    <style>
        :root {
            --agri-red: #a3171e;
            --agri-red-dark: #7a1116;
            --agri-yellow: #f1c40f;
            --agri-yellow-hover: #f39c12;
            --text-light: #ffffff;
            --glass-bg: rgba(255, 255, 255, 0.1);
            --glass-border: rgba(255, 255, 255, 0.2);
        }

        body {
            font-family: 'Inter', sans-serif;
            margin: 0;
            padding: 0;
            background-color: #f8f9fa;
            overflow-x: hidden;
        }

        /* Navbar */
        .navbar {
            background: rgba(163, 23, 30, 0.95);
            backdrop-filter: blur(10px);
            padding: 15px 0;
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.1);
            position: fixed;
            width: 100%;
            top: 0;
            z-index: 1000;
            transition: all 0.3s ease;
        }

        .navbar-brand {
            font-size: 1.5rem;
            font-weight: 800;
            color: var(--text-light) !important;
            letter-spacing: 0.5px;
        }

        .navbar-brand i {
            color: var(--agri-yellow);
        }

        .nav-link {
            color: var(--text-light) !important;
            font-weight: 500;
            margin: 0 10px;
            position: relative;
            transition: 0.3s;
        }

        .nav-link::after {
            content: '';
            position: absolute;
            width: 0;
            height: 2px;
            background: var(--agri-yellow);
            bottom: -5px;
            left: 0;
            transition: width 0.3s;
        }

        .nav-link:hover::after {
            width: 100%;
        }

        .btn-login {
            background-color: var(--agri-yellow);
            color: var(--agri-red-dark) !important;
            font-weight: 700;
            padding: 10px 25px;
            border-radius: 30px;
            border: none;
            transition: all 0.3s;
            box-shadow: 0 4px 15px rgba(241, 196, 15, 0.3);
        }

        .btn-login:hover {
            background-color: var(--agri-yellow-hover);
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(241, 196, 15, 0.4);
        }

        /* Hero Section */
        .hero-section {
            background: linear-gradient(135deg, rgba(163, 23, 30, 0.9) 0%, rgba(122, 17, 22, 0.95) 100%), 
                        url('https://images.unsplash.com/photo-1556761175-5973dc0f32d7?ixlib=rb-4.0.3&auto=format&fit=crop&w=1920&q=80') center/cover no-repeat;
            height: 100vh;
            display: flex;
            align-items: center;
            position: relative;
            padding-top: 80px;
        }

        .hero-content {
            color: var(--text-light);
            z-index: 2;
        }

        .hero-title {
            font-size: 4rem;
            font-weight: 800;
            line-height: 1.2;
            margin-bottom: 20px;
            text-shadow: 0 2px 10px rgba(0,0,0,0.2);
        }

        .hero-title span {
            color: var(--agri-yellow);
        }

        .hero-subtitle {
            font-size: 1.2rem;
            font-weight: 300;
            margin-bottom: 40px;
            opacity: 0.9;
            line-height: 1.6;
        }

        .glass-card {
            background: var(--glass-bg);
            backdrop-filter: blur(12px);
            -webkit-backdrop-filter: blur(12px);
            border: 1px solid var(--glass-border);
            border-radius: 20px;
            padding: 30px;
            box-shadow: 0 8px 32px 0 rgba(0, 0, 0, 0.2);
            color: white;
            transition: transform 0.3s;
        }

        .glass-card:hover {
            transform: translateY(-5px);
        }

        .glass-icon {
            font-size: 2.5rem;
            color: var(--agri-yellow);
            margin-bottom: 15px;
        }

        .btn-start {
            background: transparent;
            color: var(--text-light);
            border: 2px solid var(--agri-yellow);
            padding: 12px 30px;
            font-weight: 600;
            border-radius: 30px;
            font-size: 1.1rem;
            transition: all 0.3s;
            text-decoration: none;
            display: inline-block;
        }

        .btn-start:hover {
            background: var(--agri-yellow);
            color: var(--agri-red-dark);
        }

        /* Features Section */
        .features {
            padding: 100px 0;
            background: #ffffff;
        }

        .section-title {
            color: var(--agri-red-dark);
            font-weight: 800;
            text-transform: uppercase;
            position: relative;
            display: inline-block;
            margin-bottom: 50px;
        }

        .section-title::after {
            content: '';
            position: absolute;
            width: 50%;
            height: 4px;
            background: var(--agri-yellow);
            bottom: -10px;
            left: 25%;
            border-radius: 2px;
        }

        .feature-box {
            padding: 40px 30px;
            border-radius: 20px;
            background: #fff;
            box-shadow: 0 10px 40px rgba(0,0,0,0.05);
            transition: all 0.3s ease;
            height: 100%;
            border: 1px solid rgba(0,0,0,0.02);
            position: relative;
            overflow: hidden;
        }

        .feature-box::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 4px;
            background: linear-gradient(90deg, var(--agri-red), var(--agri-yellow));
            transform: scaleX(0);
            transition: transform 0.3s ease;
            transform-origin: left;
        }

        .feature-box:hover {
            transform: translateY(-10px);
            box-shadow: 0 20px 40px rgba(163, 23, 30, 0.1);
        }

        .feature-box:hover::before {
            transform: scaleX(1);
        }

        .feature-icon {
            width: 70px;
            height: 70px;
            border-radius: 50%;
            background: rgba(163, 23, 30, 0.05);
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.8rem;
            color: var(--agri-red);
            margin-bottom: 25px;
            transition: all 0.3s;
        }

        .feature-box:hover .feature-icon {
            background: var(--agri-red);
            color: white;
            transform: rotateY(360deg);
        }

        /* Footer */
        .footer {
            background: var(--agri-red-dark);
            color: rgba(255,255,255,0.7);
            padding: 40px 0 20px;
        }

        .footer-logo {
            font-size: 1.5rem;
            font-weight: 800;
            color: white;
            margin-bottom: 20px;
        }
    </style>
</head>
<body>

    <!-- Navbar -->
    <nav class="navbar navbar-expand-lg">
        <div class="container">
            <a class="navbar-brand" href="#"><i class="fa-solid fa-leaf me-2"></i>AgriQR LoanFlow</a>
            <button class="navbar-toggler text-white border-0" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
                <i class="fa-solid fa-bars fs-3"></i>
            </button>
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav mx-auto">
                    <li class="nav-item"><a class="nav-link" href="#">Trang chủ</a></li>
                    <li class="nav-item"><a class="nav-link" href="#features">Tính năng</a></li>
                    <li class="nav-item"><a class="nav-link" href="#">Về chúng tôi</a></li>
                    <li class="nav-item"><a class="nav-link" href="#">Hỗ trợ</a></li>
                </ul>
                <a href="login.jsp" class="btn btn-login"><i class="fa-solid fa-right-to-bracket me-2"></i>Đăng nhập</a>
            </div>
        </div>
    </nav>

    <!-- Hero Section -->
    <section class="hero-section">
        <div class="container">
            <div class="row align-items-center">
                <div class="col-lg-6 hero-content animate__animated animate__fadeInLeft">
                    <h1 class="hero-title">Khởi Tạo Tín Dụng <span>Thông Minh</span></h1>
                    <p class="hero-subtitle">Giải pháp số hóa toàn diện quy trình cấp tín dụng. Tạo hồ sơ, định danh khách hàng qua QR Code và duyệt vay nhanh chóng, bảo mật tuyệt đối dành riêng cho hệ thống ngân hàng.</p>
                    <div class="d-flex gap-3">
                        <a href="login.jsp" class="btn btn-login px-4 py-3 fs-5"><i class="fa-solid fa-rocket me-2"></i>Truy cập ngay</a>
                        <a href="#features" class="btn btn-start"><i class="fa-solid fa-play me-2"></i>Tìm hiểu thêm</a>
                    </div>
                </div>
                <div class="col-lg-6 mt-5 mt-lg-0 animate__animated animate__fadeInRight animate__delay-1s">
                    <div class="row g-4">
                        <div class="col-sm-6">
                            <div class="glass-card text-center">
                                <i class="fa-solid fa-qrcode glass-icon"></i>
                                <h4>Mã QR Động</h4>
                                <p class="mb-0 text-white-50">Tích hợp dữ liệu khách hàng vào mã QR bảo mật cao.</p>
                            </div>
                        </div>
                        <div class="col-sm-6 mt-sm-4">
                            <div class="glass-card text-center">
                                <i class="fa-solid fa-bolt glass-icon"></i>
                                <h4>Tốc Độ</h4>
                                <p class="mb-0 text-white-50">Giảm 80% thời gian xử lý hồ sơ tín dụng truyền thống.</p>
                            </div>
                        </div>
                        <div class="col-sm-6">
                            <div class="glass-card text-center">
                                <i class="fa-solid fa-shield-halved glass-icon"></i>
                                <h4>Bảo Mật</h4>
                                <p class="mb-0 text-white-50">Dữ liệu mã hóa SHA-256 an toàn tuyệt đối.</p>
                            </div>
                        </div>
                        <div class="col-sm-6 mt-sm-4">
                            <div class="glass-card text-center">
                                <i class="fa-solid fa-chart-pie glass-icon"></i>
                                <h4>Quản Trị</h4>
                                <p class="mb-0 text-white-50">Hệ thống phân quyền thông minh, kiểm soát rủi ro chặt chẽ.</p>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        
        <!-- Wave shape divider -->
        <div style="position: absolute; bottom: 0; left: 0; width: 100%; overflow: hidden; line-height: 0;">
            <svg viewBox="0 0 1200 120" preserveAspectRatio="none" style="position: relative; display: block; width: calc(135% + 1.3px); height: 80px;">
                <path d="M321.39,56.44c58-10.79,114.16-30.13,172-41.86,82.39-16.72,168.19-17.73,250.45-.39C823.78,31,906.67,72,985.66,92.83c70.05,18.48,146.53,26.09,214.34,3V120H0V95.8C59.71,118,137.96,128.7,208.62,118.2,247.96,112.33,285.87,83.9,321.39,56.44Z" style="fill: #ffffff;"></path>
            </svg>
        </div>
    </section>

    <!-- Features Section -->
    <section id="features" class="features">
        <div class="container text-center">
            <h2 class="section-title">Nền tảng vượt trội</h2>
            <div class="row g-4 mt-2 text-start">
                <div class="col-lg-4 col-md-6">
                    <div class="feature-box">
                        <div class="feature-icon"><i class="fa-solid fa-id-card"></i></div>
                        <h4 class="fw-bold mb-3">Định danh eKYC</h4>
                        <p class="text-muted">Hỗ trợ trích xuất thông tin khách hàng từ CCCD/CMND nhanh chóng, tích hợp công nghệ QR an toàn.</p>
                    </div>
                </div>
                <div class="col-lg-4 col-md-6">
                    <div class="feature-box">
                        <div class="feature-icon"><i class="fa-solid fa-code-branch"></i></div>
                        <h4 class="fw-bold mb-3">Luồng Duyệt Phân Cấp</h4>
                        <p class="text-muted">Phân chia rõ ràng quyền hạn Giao dịch viên, Thẩm định viên và Lãnh đạo với độ chính xác cao.</p>
                    </div>
                </div>
                <div class="col-lg-4 col-md-6">
                    <div class="feature-box">
                        <div class="feature-icon"><i class="fa-solid fa-database"></i></div>
                        <h4 class="fw-bold mb-3">Lưu trữ Đám mây</h4>
                        <p class="text-muted">Triển khai trên hệ thống Neon PostgreSQL, đảm bảo dữ liệu luôn sẵn sàng 24/7 và an toàn tuyệt đối.</p>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- Footer -->
    <footer class="footer">
        <div class="container text-center">
            <div class="footer-logo"><i class="fa-solid fa-leaf text-warning me-2"></i>AgriQR LoanFlow</div>
            <p class="mb-0">Hệ thống mô phỏng Quy trình Tín dụng Ngân hàng. Phát triển phục vụ mục đích nghiên cứu & học tập.</p>
            <p class="mt-2 mb-0" style="font-size: 0.85rem; opacity: 0.5;">&copy; 2026 Bản quyền thuộc về Dự án AgriQR.</p>
        </div>
    </footer>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Navbar scroll effect
        window.addEventListener('scroll', function() {
            if (window.scrollY > 50) {
                document.querySelector('.navbar').style.padding = '10px 0';
                document.querySelector('.navbar').style.background = 'rgba(163, 23, 30, 1)';
            } else {
                document.querySelector('.navbar').style.padding = '15px 0';
                document.querySelector('.navbar').style.background = 'rgba(163, 23, 30, 0.95)';
            }
        });
    </script>
</body>
</html>
