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
            background: linear-gradient(135deg, #1e3c72 0%, #2a5298 100%);
            min-height: 100vh;
        }
        .login-card {
            border: none;
            border-radius: 20px;
            box-shadow: 0 15px 50px rgba(0,0,0,0.3);
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(10px);
            overflow: hidden;
        }
        .login-header {
            background: linear-gradient(45deg, #f86230, #ff8c00);
            padding: 30px 20px;
            color: white;
            text-align: center;
        }
        .form-control {
            border-radius: 12px;
            padding: 14px 15px;
            background-color: #f8f9fa;
        }
        .form-control:focus {
            box-shadow: 0 0 0 0.25rem rgba(248, 98, 48, 0.25);
            border-color: #f86230;
        }
        .btn-login {
            background: linear-gradient(45deg, #f86230, #ff8c00);
            border: none;
            border-radius: 12px;
            padding: 14px;
            font-weight: 600;
            font-size: 1.1rem;
            transition: all 0.3s;
        }
        .btn-login:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 20px rgba(248, 98, 48, 0.4);
        }
    </style>
</head>
<body class="d-flex align-items-center">
    <div class="container">
        <div class="row justify-content-center">
            <div class="col-md-5 col-lg-4">
                <div class="card login-card">
                    <div class="login-header">
                        <h3 class="fw-bold mb-0"><i class="fa-solid fa-shield-halved me-2"></i>AgriQR LoanFlow</h3>
                        <p class="mb-0 mt-2 opacity-75">Hệ thống Quản lý Vay vốn Nội bộ</p>
                    </div>
                    <div class="card-body p-4 p-md-5">
                        <form action="auth" method="post">
                            <input type="hidden" name="action" value="login">
                            <div class="mb-4">
                                <label class="form-label fw-semibold text-secondary">Tên đăng nhập</label>
                                <div class="input-group">
                                    <span class="input-group-text bg-light border-end-0"><i class="fa-solid fa-user text-muted"></i></span>
                                    <input type="text" name="username" class="form-control border-start-0 ps-0" placeholder="Nhập tài khoản" required>
                                </div>
                            </div>
                            <div class="mb-4">
                                <label class="form-label fw-semibold text-secondary">Mật khẩu</label>
                                <div class="input-group">
                                    <span class="input-group-text bg-light border-end-0"><i class="fa-solid fa-lock text-muted"></i></span>
                                    <input type="password" name="password" class="form-control border-start-0 ps-0" placeholder="Nhập mật khẩu" required>
                                </div>
                            </div>
                            <button type="submit" class="btn btn-primary w-100 btn-login text-white">Đăng nhập hệ thống</button>
                        </form>
                        <% if(request.getAttribute("error") != null) { %>
                            <div class="alert alert-danger mt-4 rounded-3 shadow-sm border-0"><i class="fa-solid fa-circle-exclamation me-2"></i><%= request.getAttribute("error") %></div>
                        <% } %>
                    </div>
                </div>
                <div class="text-center text-white-50 mt-4">
                    <small>&copy; 2026 Agribank Hackathon</small>
                </div>
            </div>
        </div>
    </div>
</body>
</html>
