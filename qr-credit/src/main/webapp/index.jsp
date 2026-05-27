<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Agribank - Ngân hàng Nông nghiệp và Phát triển Nông thôn Việt Nam</title>
    <!-- Fonts & Icons -->
    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@300;400;500;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    
    <style>
        :root {
            --agri-red: #A51A29;
            --agri-red-dark: #8E1521;
            --agri-hover: #b92b3a;
            --agri-yellow: #f1c40f;
            --text-dark: #333;
        }

        body {
            font-family: 'Roboto', sans-serif;
            margin: 0;
            padding: 0;
            background-color: #f8f9fa;
        }

        /* Top Bar */
        .top-bar {
            background-color: var(--agri-red-dark);
            color: white;
            font-size: 0.8rem;
            padding: 5px 0;
        }
        .top-bar a {
            color: white;
            text-decoration: none;
            margin-left: 20px;
            font-weight: 500;
        }
        .top-bar a:hover {
            color: var(--agri-yellow);
        }

        /* Main Header */
        .main-header {
            background-color: var(--agri-red);
            padding: 15px 0;
            color: white;
            position: sticky;
            top: 0;
            z-index: 1000;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        
        .header-container {
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .header-left {
            display: flex;
            align-items: center;
            gap: 20px;
        }
        
        .menu-btn {
            background: none;
            border: none;
            color: white;
            font-size: 1.2rem;
            cursor: pointer;
        }

        .header-center {
            position: absolute;
            left: 50%;
            transform: translateX(-50%);
        }

        .logo-img {
            height: 45px;
            object-fit: contain;
        }

        .header-right {
            display: flex;
            align-items: center;
            gap: 20px;
        }
        
        .header-right .contact {
            font-weight: 500;
            font-size: 0.9rem;
        }

        .icon-btn {
            color: white;
            text-decoration: none;
            font-size: 1.1rem;
            transition: 0.3s;
        }
        .icon-btn:hover {
            color: var(--agri-yellow);
        }

        /* Hero Image */
        .hero-banner {
            width: 100%;
            height: 400px;
            background: url('https://images.unsplash.com/photo-1542744173-8e7e53415bb0?ixlib=rb-4.0.3&auto=format&fit=crop&w=1920&q=80') center/cover;
            position: relative;
        }
        .hero-overlay {
            position: absolute;
            top: 0; left: 0; right: 0; bottom: 0;
            background: rgba(0,0,0,0.4);
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 2.5rem;
            font-weight: 700;
            text-shadow: 0 2px 4px rgba(0,0,0,0.5);
        }

        /* Tabs Section */
        .tabs-section {
            background: white;
            padding: 30px 0;
            border-bottom: 1px solid #eee;
        }

        .custom-nav-tabs {
            display: flex;
            justify-content: center;
            flex-wrap: wrap;
            gap: 15px;
            list-style: none;
            padding: 0;
            margin: 0;
        }

        .custom-nav-link {
            display: flex;
            flex-direction: column;
            align-items: center;
            text-decoration: none;
            color: var(--agri-red);
            padding: 15px 25px;
            border-radius: 10px;
            transition: all 0.3s;
            background: transparent;
            border: none;
            width: 150px;
            text-align: center;
        }

        .custom-nav-link i {
            font-size: 2rem;
            margin-bottom: 10px;
        }

        .custom-nav-link span {
            font-size: 0.85rem;
            font-weight: 500;
            line-height: 1.2;
        }

        .custom-nav-link:hover, .custom-nav-link.active {
            background: var(--agri-red);
            color: white;
            box-shadow: 0 5px 15px rgba(165, 26, 41, 0.2);
        }

        /* Content Section */
        .content-section {
            padding: 50px 0;
            background: white;
        }

        .section-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 30px;
            border-bottom: 1px solid #ddd;
            padding-bottom: 15px;
        }
        
        .section-header h2 {
            font-size: 1.5rem;
            font-weight: 700;
            color: var(--text-dark);
            margin: 0;
        }

        .news-card {
            border: none;
            transition: transform 0.3s;
            cursor: pointer;
            height: 100%;
        }
        .news-card:hover {
            transform: translateY(-5px);
        }
        
        .news-img {
            height: 180px;
            object-fit: cover;
            border-radius: 8px;
        }

        .news-title {
            font-size: 0.95rem;
            font-weight: 600;
            color: #222;
            margin-top: 15px;
            display: -webkit-box;
            -webkit-line-clamp: 3;
            -webkit-box-orient: vertical;
            overflow: hidden;
        }

        /* Footer */
        .footer {
            background: var(--agri-red-dark);
            color: white;
            padding: 30px 0;
            text-align: center;
            font-size: 0.9rem;
        }
    </style>
</head>
<body>

    <!-- Top Bar -->
    <div class="top-bar d-none d-lg-block">
        <div class="container d-flex justify-content-end">
            <a href="#">Khách hàng cá nhân</a>
            <a href="#">Khách hàng doanh nghiệp</a>
            <a href="#">Định chế tài chính</a>
            <a href="#">Về Agribank</a>
            <a href="#">Tin tức</a>
            <a href="#">Tuyển dụng</a>
            <a href="#">Hỏi đáp</a>
            <a href="#">Liên hệ</a>
            <a href="#">English</a>
        </div>
    </div>

    <!-- Main Header -->
    <header class="main-header">
        <div class="container header-container">
            <div class="header-left">
                <button class="menu-btn"><i class="fa-solid fa-bars"></i></button>
                <span class="d-none d-md-inline fw-medium">Về Agribank</span>
            </div>
            
            <div class="header-center">
            <a href="index.jsp"><img src="assets/img/agribank_logo.png" alt="Agribank" class="logo-img"></a>
        </div>

            <div class="header-right">
                <div class="contact d-none d-xl-block">
                    <i class="fa-solid fa-phone me-1"></i> 1900558818 / 02432053205
                </div>
                <a href="search.jsp" class="icon-btn" title="Tra cứu hồ sơ"><i class="fa-solid fa-magnifying-glass"></i></a>
                <!-- Link tới trang Đăng nhập hệ thống nội bộ -->
                <a href="login.jsp" class="btn btn-sm btn-light fw-bold text-danger px-3 rounded-pill" style="margin: 0 10px;">
                    <i class="fa-solid fa-user-lock me-1"></i> Đăng nhập hệ thống
                </a>
                <a href="#" class="icon-btn"><i class="fa-solid fa-globe"></i></a>
            </div>
        </div>
    </header>

    <!-- Hero Banner -->
    <div class="hero-banner">
        <div class="hero-overlay">
            Chào mừng đến với Agribank
        </div>
    </div>

    <!-- Tabs Section -->
    <section class="tabs-section">
        <div class="container">
            <ul class="custom-nav-tabs nav" role="tablist">
                <li class="nav-item" role="presentation">
                    <button class="custom-nav-link active" data-bs-toggle="tab" data-bs-target="#tab1" type="button" role="tab">
                        <i class="fa-solid fa-seedling"></i>
                        <span>Đồng hành cùng Tam Nông</span>
                    </button>
                </li>
                <li class="nav-item" role="presentation">
                    <button class="custom-nav-link" data-bs-toggle="tab" data-bs-target="#tab2" type="button" role="tab">
                        <i class="fa-solid fa-money-bill-transfer"></i>
                        <span>Tài chính ngân hàng</span>
                    </button>
                </li>
                <li class="nav-item" role="presentation">
                    <button class="custom-nav-link" data-bs-toggle="tab" data-bs-target="#tab3" type="button" role="tab">
                        <i class="fa-regular fa-newspaper"></i>
                        <span>Tin về Agribank</span>
                    </button>
                </li>
                <li class="nav-item" role="presentation">
                    <button class="custom-nav-link" data-bs-toggle="tab" data-bs-target="#tab4" type="button" role="tab">
                        <i class="fa-solid fa-hand-holding-heart"></i>
                        <span>Hoạt động cộng đồng</span>
                    </button>
                </li>
                <li class="nav-item" role="presentation">
                    <button class="custom-nav-link" data-bs-toggle="tab" data-bs-target="#tab5" type="button" role="tab">
                        <i class="fa-solid fa-shield-halved"></i>
                        <span>Phòng, chống rửa tiền</span>
                    </button>
                </li>
            </ul>
        </div>
    </section>

    <!-- Tab Content Area -->
    <section class="content-section">
        <div class="container">
            <div class="tab-content">
                <!-- TAB 1 CONTENT -->
                <div class="tab-pane fade show active" id="tab1" role="tabpanel">
                    <div class="section-header">
                        <h2>Đồng hành cùng Tam Nông</h2>
                        <select class="form-select w-auto border-0 bg-light">
                            <option>Xem tất cả</option>
                        </select>
                    </div>
                    <div class="row g-4">
                        <div class="col-md-3">
                            <div class="news-card">
                                <img src="https://images.unsplash.com/photo-1500382017468-9049fed747ef?auto=format&fit=crop&w=500&q=80" class="img-fluid news-img" alt="News">
                                <h3 class="news-title">Agribank hỗ trợ nông dân vay vốn phát triển kinh tế vùng sâu vùng xa</h3>
                            </div>
                        </div>
                        <div class="col-md-3">
                            <div class="news-card">
                                <img src="https://images.unsplash.com/photo-1500382017468-9049fed747ef?auto=format&fit=crop&w=500&q=80" class="img-fluid news-img" alt="News">
                                <h3 class="news-title">Chính sách tín dụng ưu đãi phục vụ phát triển nông nghiệp, nông thôn</h3>
                            </div>
                        </div>
                        <div class="col-md-3">
                            <div class="news-card">
                                <img src="https://images.unsplash.com/photo-1586771107445-d3ca888129ff?auto=format&fit=crop&w=500&q=80" class="img-fluid news-img" alt="News">
                                <h3 class="news-title">Ứng dụng công nghệ cao vào sản xuất nông nghiệp sạch tại ĐBSCL</h3>
                            </div>
                        </div>
                        <div class="col-md-3">
                            <div class="news-card">
                                <img src="https://images.unsplash.com/photo-1586771107445-d3ca888129ff?auto=format&fit=crop&w=500&q=80" class="img-fluid news-img" alt="News">
                                <h3 class="news-title">Agribank trao tặng hệ thống nước sạch cho bà con miền Trung</h3>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- TAB 2 CONTENT -->
                <div class="tab-pane fade" id="tab2" role="tabpanel">
                    <div class="section-header">
                        <h2>Tài chính ngân hàng</h2>
                    </div>
                    <div class="row g-4">
                        <div class="col-md-3">
                            <div class="news-card">
                                <img src="https://images.unsplash.com/photo-1611162617213-7d7a39e9b1d7?auto=format&fit=crop&w=500&q=80" class="img-fluid news-img" alt="News">
                                <h3 class="news-title">Biến động lãi suất huy động những tháng cuối năm 2026</h3>
                            </div>
                        </div>
                        <div class="col-md-3">
                            <div class="news-card">
                                <img src="https://images.unsplash.com/photo-1556742049-0cfed4f6a45d?auto=format&fit=crop&w=500&q=80" class="img-fluid news-img" alt="News">
                                <h3 class="news-title">Đẩy mạnh chuyển đổi số trong dịch vụ tài chính ngân hàng</h3>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- TAB 3 CONTENT -->
                <div class="tab-pane fade" id="tab3" role="tabpanel">
                    <div class="section-header">
                        <h2>Tin về Agribank</h2>
                    </div>
                    <div class="row g-4">
                        <div class="col-md-3">
                            <div class="news-card">
                                <img src="https://images.unsplash.com/photo-1542744173-8e7e53415bb0?auto=format&fit=crop&w=500&q=80" class="img-fluid news-img" alt="News">
                                <h3 class="news-title">Agribank đạt giải thưởng Ngân hàng Số xuất sắc năm 2026</h3>
                            </div>
                        </div>
                    </div>
                </div>
                
                <!-- TAB 4 CONTENT -->
                <div class="tab-pane fade" id="tab4" role="tabpanel">
                    <div class="section-header">
                        <h2>Hoạt động cộng đồng</h2>
                    </div>
                    <p class="text-muted">Nội dung đang được cập nhật...</p>
                </div>

                <!-- TAB 5 CONTENT -->
                <div class="tab-pane fade" id="tab5" role="tabpanel">
                    <div class="section-header">
                        <h2>Phòng, chống rửa tiền</h2>
                    </div>
                    <p class="text-muted">Nội dung đang được cập nhật...</p>
                </div>
            </div>
        </div>
    </section>

    <!-- Footer -->
    <footer class="footer">
        <div class="container">
            <h5 class="fw-bold mb-3"><i class="fa-solid fa-leaf text-warning me-2"></i>AGRIBANK LOANFLOW</h5>
            <p class="mb-0">Dự án Mô phỏng Quy trình Tín dụng Ngân hàng</p>
        </div>
    </footer>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
