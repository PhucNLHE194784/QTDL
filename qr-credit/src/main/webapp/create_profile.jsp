<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%
    if(session.getAttribute("user") == null) {
        response.sendRedirect("login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Tạo Hồ Sơ Mới - AgriQR LoanFlow</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        :root {
            --agri-red: #A51A29;
            --agri-red-dark: #8E1521;
            --agri-yellow: #f1c40f;
            --sidebar-width: 260px;
        }
        body { font-family: 'Inter', sans-serif; background: #f4f6f9; min-height: 100vh; overflow-x: hidden; }
        
        /* Sidebar */
        .sidebar {
            width: var(--sidebar-width);
            background: var(--agri-red-dark);
            color: white;
            position: fixed;
            height: 100vh;
            top: 0; left: 0;
            z-index: 1000;
            transition: all 0.3s;
            box-shadow: 2px 0 10px rgba(0,0,0,0.1);
        }
        .sidebar-brand {
            padding: 20px;
            font-size: 1.4rem;
            font-weight: 700;
            border-bottom: 1px solid rgba(255,255,255,0.1);
            display: flex;
            align-items: center;
            gap: 10px;
        }
        .sidebar-brand i { color: var(--agri-yellow); font-size: 1.6rem; }
        
        .sidebar-menu { list-style: none; padding: 20px 0; margin: 0; }
        .sidebar-menu li { padding: 0 15px; margin-bottom: 5px; }
        .sidebar-link {
            display: flex; align-items: center; gap: 12px;
            color: rgba(255,255,255,0.8);
            padding: 12px 20px;
            text-decoration: none;
            border-radius: 8px;
            font-weight: 500;
            transition: 0.3s;
        }
        .sidebar-link:hover, .sidebar-link.active {
            background: rgba(255,255,255,0.1);
            color: white;
        }
        .sidebar-link.active {
            border-left: 4px solid var(--agri-yellow);
        }
        
        /* Main Content */
        .main-content {
            margin-left: var(--sidebar-width);
            min-height: 100vh;
            display: flex;
            flex-direction: column;
        }
        
        /* Navbar */
        .top-navbar { 
            background: white; 
            padding: 15px 25px; 
            box-shadow: 0 2px 10px rgba(0,0,0,0.05); 
            display: flex;
            justify-content: flex-end;
            align-items: center;
            margin-bottom: 30px;
        }

        .form-card { 
            border: none; 
            border-radius: 12px; 
            background: white;
            box-shadow: 0 5px 20px rgba(0,0,0,0.05); 
        }
        .form-control, .form-select { 
            border-radius: 8px; 
            padding: 12px 14px; 
            background-color: #f8fafc; 
            border: 1px solid #e2e8f0; 
            transition: all 0.3s ease;
        }
        .form-control:focus, .form-select:focus { 
            box-shadow: 0 0 0 4px rgba(165, 26, 41, 0.1); 
            border-color: var(--agri-red); 
            background-color: #fff; 
        }
        .btn-create { 
            border-radius: 8px; 
            padding: 14px; 
            font-weight: 600; 
            font-size: 1.1rem; 
            background: var(--agri-red); 
            border: none; 
            transition: all 0.3s ease;
        }
        .btn-create:hover { 
            background: var(--agri-red-dark); 
            transform: translateY(-2px); 
            box-shadow: 0 5px 15px rgba(165, 26, 41, 0.3); 
        }
        .form-label { font-weight: 600; color: #555; font-size: 0.85rem; margin-bottom: 8px; text-transform: uppercase; }
        .section-title { font-size: 1.1rem; font-weight: 700; color: var(--agri-red); margin-bottom: 20px; border-bottom: 2px solid #eee; padding-bottom: 10px; }
        .text-primary-custom { color: var(--agri-red) !important; }

        @media (max-width: 768px) {
            .sidebar { transform: translateX(-100%); }
            .sidebar.show { transform: translateX(0); }
            .main-content { margin-left: 0; }
        }
    </style>
</head>
<body>
    <!-- Sidebar -->
    <div class="sidebar">
        <div class="sidebar-brand text-center d-block">
            <a href="index.jsp"><img src="assets/img/agribank_logo.png" alt="Agribank" style="height: 45px; background: white; padding: 5px; border-radius: 5px; max-width: 100%;"></a>
        </div>
        <ul class="sidebar-menu">
            <li><a href="dashboard.jsp" class="sidebar-link"><i class="fa-solid fa-chart-pie w-20px text-center"></i> Bảng điều khiển</a></li>
            <c:if test="${user.role eq 'GDV'}">
                <li><a href="create_profile.jsp" class="sidebar-link active"><i class="fa-solid fa-plus w-20px text-center"></i> Tạo Hồ sơ mới</a></li>
            </c:if>
            <c:if test="${user.role eq 'ADMIN'}">
                <li class="mt-4 px-3 mb-2 text-uppercase" style="font-size: 0.75rem; opacity: 0.6; font-weight: 700;">Quản trị hệ thống</li>
                <li><a href="users" class="sidebar-link"><i class="fa-solid fa-users w-20px text-center"></i> Quản lý Nhân sự</a></li>
            </c:if>
            <c:if test="${user.role eq 'ADMIN' || user.role eq 'LANH_DAO'}">
                <li><a href="recycle_bin.jsp" class="sidebar-link"><i class="fa-solid fa-trash-can w-20px text-center"></i> Thùng rác (Hồ sơ)</a></li>
            </c:if>
        </ul>
    </div>

    <!-- Main Content -->
    <div class="main-content">
        <!-- Top Navbar -->
        <div class="top-navbar">
            <div class="d-flex align-items-center w-100">
                <button class="btn btn-light d-md-none me-auto shadow-sm" id="sidebarToggle"><i class="fa-solid fa-bars"></i></button>
                <div class="text-end ms-auto me-3">
                    <div class="fw-bold text-dark" style="font-size: 0.95rem;">${user.fullname}</div>
                    <div class="text-muted" style="font-size: 0.8rem;"><i class="fa-solid fa-id-badge me-1 text-warning"></i>${user.role}</div>
                </div>
                <div class="dropdown">
                    <button class="btn btn-light rounded-circle shadow-sm" type="button" data-bs-toggle="dropdown" style="width: 45px; height: 45px;">
                        <i class="fa-solid fa-user text-primary-custom"></i>
                    </button>
                    <ul class="dropdown-menu dropdown-menu-end shadow border-0 mt-2">
                        <li><a class="dropdown-item text-danger fw-bold" href="auth?action=logout"><i class="fa-solid fa-power-off me-2"></i>Đăng xuất</a></li>
                    </ul>
                </div>
            </div>
        </div>

        <div class="container-fluid px-4 mb-5">
            <div class="row justify-content-center">
                <div class="col-md-10 col-lg-8">
                    <div class="d-flex justify-content-between align-items-center mb-4">
                        <h3 class="fw-bold text-primary-custom mb-0"><i class="fa-solid fa-file-signature me-2"></i>Tạo Hồ Sơ Vay Vốn Mới</h3>
                        <a href="dashboard.jsp" class="btn btn-outline-secondary btn-sm"><i class="fa-solid fa-arrow-left me-1"></i>Trở về</a>
                    </div>
                
                <div class="card form-card">
                    <div class="card-body p-4 p-md-5">
                        <form action="profile" method="post">
                            <input type="hidden" name="action" value="create">
                            <div class="section-title"><i class="fa-solid fa-user me-2 text-primary-custom"></i>Thông Tin Khách Hàng</div>
                            <div class="row">
                                <div class="col-md-4 mb-4">
                                    <label class="form-label">Họ và Tên</label>
                                    <input type="text" id="customerName" name="customerName" class="form-control" placeholder="Ví dụ: Nguyễn Văn A" required>
                                </div>
                                <div class="col-md-4 mb-4">
                                    <label class="form-label">Số CCCD / CMND</label>
                                    <input type="text" name="cccd" class="form-control" placeholder="Nhập đầy đủ 12 số" pattern="[0-9]{9,12}" title="CCCD phải từ 9 đến 12 chữ số" required>
                                </div>
                                <div class="col-md-4 mb-4">
                                    <label class="form-label">Số điện thoại</label>
                                    <input type="tel" name="phone" class="form-control" placeholder="Ví dụ: 0987654321" pattern="^(0|\+84)[3|5|7|8|9][0-9]{8}$" title="Vui lòng nhập đúng định dạng số điện thoại Việt Nam" required>
                                </div>
                                <div class="col-md-12 mb-4">
                                    <label class="form-label">Email (Dùng để nhận OTP bảo mật)</label>
                                    <input type="email" name="email" class="form-control" placeholder="khachhang@gmail.com" required>
                                </div>
                            </div>
                            <div class="section-title mt-2"><i class="fa-solid fa-map-location-dot me-2 text-primary-custom"></i>Địa Chỉ Thường Trú</div>
                                <div class="row">
                                <div class="col-md-4 mb-4">
                                    <label class="form-label">Tỉnh / Thành phố</label>
                                    <select id="province" name="region" class="form-select" required>
                                        <option value="">-- Chọn Tỉnh/Thành --</option>
                                    </select>
                                </div>
                                <div class="col-md-4 mb-4">
                                    <label class="form-label">Quận / Huyện</label>
                                    <select id="district" class="form-select" disabled required>
                                        <option value="">-- Chọn Quận/Huyện --</option>
                                    </select>
                                </div>
                                <div class="col-md-4 mb-4">
                                    <label class="form-label">Phường / Xã</label>
                                    <select id="ward" class="form-select" disabled required>
                                        <option value="">-- Chọn Phường/Xã --</option>
                                    </select>
                                </div>
                            </div>
                            <div class="mb-4">
                                <label class="form-label">Địa chỉ chi tiết (Số nhà, Tên đường)</label>
                                <input type="text" id="street" class="form-control" placeholder="VD: Số 12, Đường Lê Lợi" required>
                                <input type="hidden" name="ward" id="fullAddressHidden" required>
                            </div>
                            
                            <div class="section-title mt-4"><i class="fa-solid fa-sack-dollar me-2 text-primary-custom"></i>Thông Tin Khoản Vay</div>
                            <div class="mb-4">
                                <label class="form-label fw-semibold text-secondary">Số tiền đề nghị vay (VNĐ)</label>
                                <!-- Input hiển thị -->
                                <input type="text" id="amountDisplay" class="form-control fw-bold text-primary-custom" placeholder="Ví dụ: 50,000,000" required>
                                <!-- Input ẩn để gửi dữ liệu chuẩn cho Server -->
                                <input type="hidden" name="amount" id="amountHidden" required>
                            </div>
                            <div class="mb-5">
                                <label class="form-label">Mục đích vay vốn</label>
                                <textarea name="purpose" class="form-control" rows="3" placeholder="Nhập chi tiết mục đích sử dụng vốn..." required></textarea>
                            </div>
                            
                            <div class="section-title mt-4"><i class="fa-solid fa-camera me-2 text-primary-custom"></i>Đăng Ký Khuôn Mặt Khách Hàng</div>
                            <div class="mb-4 text-center">
                                <div id="videoContainer" style="position: relative; display: inline-block; width: 100%; max-width: 400px;">
                                    <video id="videoElement" autoplay muted style="width: 100%; border-radius: 8px; border: 2px solid #ddd;"></video>
                                    <canvas id="canvasElement" style="position: absolute; top: 0; left: 0; width: 100%; height: 100%; pointer-events: none;"></canvas>
                                </div>
                                <div class="mt-3">
                                    <button type="button" id="startCameraBtn" class="btn btn-outline-primary"><i class="fa-solid fa-video me-1"></i>Bật Camera</button>
                                    <button type="button" id="captureFaceBtn" class="btn btn-success d-none"><i class="fa-solid fa-camera-retro me-1"></i>Chụp & Trích xuất</button>
                                </div>
                                <div id="faceStatus" class="mt-2 text-muted small"></div>
                                <input type="hidden" name="faceDescriptor" id="faceDescriptorHidden">
                            </div>
                            
                            <button type="submit" class="btn btn-primary-custom text-white w-100 btn-create">
                                <i class="fa-solid fa-qrcode me-2"></i>Khởi tạo & Sinh mã QR định danh
                            </button>
                        </form>
                        <% if(request.getAttribute("error") != null) { %>
                            <div class="alert alert-danger mt-4 rounded-3 shadow-sm border-0"><i class="fa-solid fa-triangle-exclamation me-2"></i><%= request.getAttribute("error") %></div>
                        <% } %>
                    </div>
                </div>
            </div>
        </div>
            </div>
        </div>
    </div>
    
    <script src="https://code.jquery.com/jquery-3.7.0.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script src="js/face-api.min.js"></script>
    <script>
        $(document).ready(function() {
            // Sidebar toggle for mobile
            $('#sidebarToggle').on('click', function() {
                $('.sidebar').toggleClass('show');
            });

            // Tự động thêm dấu phân cách hàng nghìn khi nhập số tiền
            $('#amountDisplay').on('input', function(e) {
                // Xóa mọi ký tự không phải là số
                let value = $(this).val().replace(/\D/g, '');
                
                if (value !== '') {
                    // Cập nhật giá trị thật (số nguyên thủy) vào thẻ hidden
                    $('#amountHidden').val(value);
                    
                    // Định dạng hiển thị bằng dấu chấm (.) theo chuẩn VN
                    // Thay vì dùng Intl.NumberFormat phụ thuộc locale, tự replace bằng Regex cho chắc chắn có dấu chấm
                    let formatted = value.replace(/\B(?=(\d{3})+(?!\d))/g, ".");
                    $(this).val(formatted);
                } else {
                    $('#amountHidden').val('');
                    $(this).val('');
                }
            });
            
            // Xử lý trước khi submit đảm bảo dữ liệu chuẩn
            $('form').on('submit', function() {
                var value = $('#amountDisplay').val().replace(/\D/g, '');
                $('#amountHidden').val(value);
                
                // Gom địa chỉ
                var street = $('#street').val();
                var wardText = $('#ward option:selected').text();
                var districtText = $('#district option:selected').text();
                var fullAddress = street + ", " + wardText + ", " + districtText;
                $('#fullAddressHidden').val(fullAddress);
                
                return true;
            });
            
            // Format Tên Tiếng Việt
            $('#customerName').on('input', function() {
                var val = $(this).val();
                // Xóa ký tự không phải chữ cái và dấu cách
                val = val.replace(/[^a-zA-ZÀÁÂÃÈÉÊÌÍÒÓÔÕÙÚĂĐĨŨƠàáâãèéêìíòóôõùúăđĩũơƯĂẠẢẤẦẨẪẬẮẰẲẴẶẸẺẼỀỀỂưăạảấầẩẫậắằẳẵặẹẻẽềềểỄỆỈỊỌỎỐỒỔỖỘỚỜỞỠỢỤỦỨỪễệỉịọỏốồổỗộớờởỡợụủứừỮỰỲỴÝỶỸửữựỳỵỷỹ\s]/g, '');
                
                // Auto Capitalize First Letter of each word
                val = val.replace(/(^\w{1}|(\s+\w{1}))/g, letter => letter.toUpperCase());
                $(this).val(val);
            });

            // Tải API Tỉnh/Thành từ nguồn cực kỳ nhanh và ổn định (esgoo.net)
            $.ajax({
                url: 'https://esgoo.net/api-tinhthanh/1/0.htm',
                method: 'GET',
                dataType: 'json',
                success: function(response) {
                    if (response.error == 0) {
                        let provinceHtml = '<option value="">-- Chọn Tỉnh/Thành --</option>';
                        response.data.forEach(function(p) {
                            provinceHtml += '<option value="' + p.full_name + '" data-id="' + p.id + '">' + p.full_name + '</option>';
                        });
                        $('#province').html(provinceHtml);
                    }
                },
                error: function(err) {
                    console.error("Lỗi tải Tỉnh/Thành", err);
                }
            });

            $('#province').on('change', function() {
                var code = $(this).find('option:selected').data('id');
                $('#district').html('<option value="">-- Chọn Quận/Huyện --</option>').prop('disabled', true);
                $('#ward').html('<option value="">-- Chọn Phường/Xã --</option>').prop('disabled', true);
                
                if (code) {
                    $.ajax({
                        url: 'https://esgoo.net/api-tinhthanh/2/' + code + '.htm',
                        method: 'GET',
                        dataType: 'json',
                        success: function(response) {
                            if (response.error == 0) {
                                let districtHtml = '<option value="">-- Chọn Quận/Huyện --</option>';
                                response.data.forEach(function(d) {
                                    districtHtml += '<option value="' + d.full_name + '" data-id="' + d.id + '">' + d.full_name + '</option>';
                                    districtHtml += '<option value="' + d.id + '" data-id="' + d.id + '">' + d.full_name + '</option>';
                                });
                                $('#district').html(districtHtml).prop('disabled', false);
                            }
                        }
                    });
                }
            });

            $('#district').on('change', function() {
                var districtCode = $(this).find('option:selected').data('id');
                $('#ward').html('<option value="">-- Chọn Phường/Xã --</option>').prop('disabled', true);
                
                if (districtCode) {
                    $.ajax({
                        url: 'https://esgoo.net/api-tinhthanh/3/' + districtCode + '.htm',
                        method: 'GET',
                        dataType: 'json',
                        success: function(response) {
                            if (response.error == 0) {
                                let wardHtml = '<option value="">-- Chọn Phường/Xã --</option>';
                                response.data.forEach(function(w) {
                                    wardHtml += '<option value="' + w.full_name + '">' + w.full_name + '</option>';
                                });
                                $('#ward').html(wardHtml).prop('disabled', false);
                            }
                        }
                    });
                }
            });
        });
        // --- FACE API LOGIC ---
        Promise.all([
            faceapi.nets.tinyFaceDetector.loadFromUri('models'),
            faceapi.nets.faceLandmark68Net.loadFromUri('models'),
            faceapi.nets.faceRecognitionNet.loadFromUri('models')
        ]).then(() => {
            console.log("Face API models loaded.");
        }).catch(err => {
            console.error("Error loading models:", err);
            $('#faceStatus').html("<span class='text-danger'>Lỗi tải mô hình AI. Vui lòng kiểm tra thư mục models.</span>");
        });

        const video = document.getElementById('videoElement');
        const canvas = document.getElementById('canvasElement');
        const faceStatus = document.getElementById('faceStatus');
        const faceDescriptorHidden = document.getElementById('faceDescriptorHidden');
        let cameraStream = null;

        $('#startCameraBtn').click(async function() {
            try {
                cameraStream = await navigator.mediaDevices.getUserMedia({ video: {} });
                video.srcObject = cameraStream;
                $(this).addClass('d-none');
                $('#captureFaceBtn').removeClass('d-none');
                faceStatus.innerHTML = "<span class='text-primary'>Camera đã bật. Vui lòng căn chỉnh khuôn mặt khách hàng.</span>";
            } catch (err) {
                faceStatus.innerHTML = "<span class='text-danger'>Không thể truy cập Camera. Vui lòng cấp quyền!</span>";
            }
        });

        $('#captureFaceBtn').click(async function() {
            faceStatus.innerHTML = "<span class='text-warning'><i class='fas fa-spinner fa-spin'></i> Đang phân tích khuôn mặt...</span>";
            try {
                const detections = await faceapi.detectSingleFace(video, new faceapi.TinyFaceDetectorOptions()).withFaceLandmarks().withFaceDescriptor();
                
                if (detections) {
                    const displaySize = { width: video.videoWidth, height: video.videoHeight };
                    faceapi.matchDimensions(canvas, displaySize);
                    const resizedDetections = faceapi.resizeResults(detections, displaySize);
                    canvas.getContext('2d').clearRect(0, 0, canvas.width, canvas.height);
                    faceapi.draw.drawDetections(canvas, resizedDetections);
                    
                    faceDescriptorHidden.value = JSON.stringify(Array.from(detections.descriptor));
                    faceStatus.innerHTML = "<span class='text-success fw-bold'><i class='fas fa-check-circle'></i> Đã lưu khuôn mặt thành công!</span>";
                    
                    if (cameraStream) {
                        cameraStream.getTracks().forEach(track => track.stop());
                    }
                    $(this).addClass('d-none');
                    $('#startCameraBtn').removeClass('d-none').html('<i class="fa-solid fa-redo me-1"></i>Chụp lại');
                } else {
                    faceStatus.innerHTML = "<span class='text-danger fw-bold'><i class='fas fa-exclamation-triangle'></i> Không nhận diện được khuôn mặt. Thử lại!</span>";
                }
            } catch (e) {
                faceStatus.innerHTML = "<span class='text-danger fw-bold'>Lỗi xử lý AI! Thử lại.</span>";
            }
        });
    </script>
</body>
</html>
