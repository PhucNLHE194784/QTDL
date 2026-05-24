<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
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
        body { font-family: 'Inter', sans-serif; background: linear-gradient(135deg, #fdfbfb 0%, #ebedee 100%); min-height: 100vh; }
        .form-card { 
            border: none; 
            border-radius: 20px; 
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(10px);
            box-shadow: 0 15px 35px rgba(0,0,0,0.05), 0 5px 15px rgba(0,0,0,0.03); 
            border: 1px solid rgba(255,255,255,0.4);
        }
        .form-control, .form-select { 
            border-radius: 12px; 
            padding: 14px; 
            background-color: #f8fafc; 
            border: 1px solid #e2e8f0; 
            transition: all 0.3s ease;
        }
        .form-control:focus, .form-select:focus { 
            box-shadow: 0 0 0 4px rgba(46, 125, 50, 0.1); 
            border-color: #2e7d32; 
            background-color: #fff; 
            transform: translateY(-1px);
        }
        .btn-create { 
            border-radius: 12px; 
            padding: 14px; 
            font-weight: 600; 
            font-size: 1.1rem; 
            background: linear-gradient(135deg, #2e7d32, #1b5e20); 
            border: none; 
            transition: all 0.3s ease;
            box-shadow: 0 4px 15px rgba(46, 125, 50, 0.3);
        }
        .btn-create:hover { 
            background: linear-gradient(135deg, #1b5e20, #144d18); 
            transform: translateY(-2px); 
            box-shadow: 0 8px 25px rgba(46, 125, 50, 0.4); 
        }
        .form-label { font-weight: 600; color: #475569; font-size: 0.9rem; margin-bottom: 8px; text-transform: uppercase; letter-spacing: 0.5px; }
        .section-title { font-size: 1.1rem; font-weight: 700; color: #1e293b; margin-bottom: 20px; border-bottom: 2px solid #e2e8f0; padding-bottom: 10px; }
    </style>
</head>
<body>
    <div class="container mt-5 mb-5">
        <div class="row justify-content-center">
            <div class="col-md-8 col-lg-7">
                <div class="d-flex justify-content-between align-items-center mb-4">
                    <h3 class="fw-bold text-success mb-0"><i class="fa-solid fa-file-signature me-2"></i>Tạo Hồ Sơ Vay Vốn Mới</h3>
                    <a href="dashboard.jsp" class="btn btn-outline-secondary btn-sm"><i class="fa-solid fa-arrow-left me-1"></i>Trở về</a>
                </div>
                
                <div class="card form-card">
                    <div class="card-body p-4 p-md-5">
                        <form action="profile" method="post">
                            <input type="hidden" name="action" value="create">
                            <div class="section-title"><i class="fa-solid fa-user me-2 text-success"></i>Thông Tin Khách Hàng</div>
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
                            </div>
                            <div class="section-title mt-2"><i class="fa-solid fa-map-location-dot me-2 text-success"></i>Địa Chỉ Thường Trú</div>
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
                            
                            <div class="section-title mt-4"><i class="fa-solid fa-sack-dollar me-2 text-success"></i>Thông Tin Khoản Vay</div>
                            <div class="mb-4">
                                <label class="form-label fw-semibold text-secondary">Số tiền đề nghị vay (VNĐ)</label>
                                <!-- Input hiển thị -->
                                <input type="text" id="amountDisplay" class="form-control fw-bold text-success" placeholder="Ví dụ: 50,000,000" required>
                                <!-- Input ẩn để gửi dữ liệu chuẩn cho Server -->
                                <input type="hidden" name="amount" id="amountHidden" required>
                            </div>
                            <div class="mb-5">
                                <label class="form-label">Mục đích vay vốn</label>
                                <textarea name="purpose" class="form-control" rows="3" placeholder="Nhập chi tiết mục đích sử dụng vốn..." required></textarea>
                            </div>
                            
                            <button type="submit" class="btn btn-success text-white w-100 btn-create">
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

    <script src="https://code.jquery.com/jquery-3.7.0.min.js"></script>
    <script>
        $(document).ready(function() {
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

            // Tải API Tỉnh/Thành
            let provincesData = [];
            $.ajax({
                url: 'https://provinces.open-api.vn/api/?depth=3',
                method: 'GET',
                success: function(data) {
                    provincesData = data;
                    let provinceHtml = '<option value="">-- Chọn Tỉnh/Thành --</option>';
                    data.forEach(p => {
                        provinceHtml += `<option value="${p.name}" data-code="${p.code}">${p.name}</option>`;
                    });
                    $('#province').html(provinceHtml);
                }
            });

            $('#province').on('change', function() {
                var code = $(this).find('option:selected').data('code');
                $('#district').html('<option value="">-- Chọn Quận/Huyện --</option>').prop('disabled', true);
                $('#ward').html('<option value="">-- Chọn Phường/Xã --</option>').prop('disabled', true);
                
                if (code) {
                    var province = provincesData.find(p => p.code === code);
                    if (province && province.districts) {
                        let districtHtml = '<option value="">-- Chọn Quận/Huyện --</option>';
                        province.districts.forEach(d => {
                            districtHtml += `<option value="${d.name}" data-code="${d.code}">${d.name}</option>`;
                        });
                        $('#district').html(districtHtml).prop('disabled', false);
                    }
                }
            });

            $('#district').on('change', function() {
                var provinceCode = $('#province').find('option:selected').data('code');
                var districtCode = $(this).find('option:selected').data('code');
                $('#ward').html('<option value="">-- Chọn Phường/Xã --</option>').prop('disabled', true);
                
                if (districtCode) {
                    var province = provincesData.find(p => p.code === provinceCode);
                    var district = province.districts.find(d => d.code === districtCode);
                    if (district && district.wards) {
                        let wardHtml = '<option value="">-- Chọn Phường/Xã --</option>';
                        district.wards.forEach(w => {
                            wardHtml += `<option value="${w.name}">${w.name}</option>`;
                        });
                        $('#ward').html(wardHtml).prop('disabled', false);
                    }
                }
            });
        });
    </script>
</body>
</html>
