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
        body { font-family: 'Inter', sans-serif; background-color: #f4f6f9; }
        .form-card { border: none; border-radius: 20px; box-shadow: 0 10px 40px rgba(0,0,0,0.05); }
        .form-control, .form-select { border-radius: 10px; padding: 12px; background-color: #f8f9fa; border: 1px solid #e9ecef; }
        .form-control:focus, .form-select:focus { box-shadow: 0 0 0 0.25rem rgba(46, 125, 50, 0.2); border-color: #2e7d32; background-color: #fff; }
        .btn-create { border-radius: 10px; padding: 12px; font-weight: 600; font-size: 1.1rem; background: linear-gradient(45deg, #2e7d32, #43a047); border: none; }
        .btn-create:hover { background: linear-gradient(45deg, #1b5e20, #2e7d32); transform: translateY(-2px); box-shadow: 0 8px 20px rgba(46, 125, 50, 0.4); }
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
                            <div class="row">
                                <div class="col-md-6 mb-4">
                                    <label class="form-label fw-semibold text-secondary">Tên khách hàng</label>
                                    <input type="text" name="customerName" class="form-control" placeholder="Ví dụ: Nguyễn Văn A" required>
                                </div>
                                <div class="col-md-6 mb-4">
                                    <label class="form-label fw-semibold text-secondary">Số CCCD / CMND</label>
                                    <input type="text" name="cccd" class="form-control" placeholder="Nhập đầy đủ 12 số" required>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-md-6 mb-4">
                                    <label class="form-label fw-semibold text-secondary">Tỉnh / Thành phố</label>
                                    <select name="region" class="form-select" required>
                                        <option value="">-- Chọn Tỉnh/Thành --</option>
                                        <optgroup label="Thành phố Trực thuộc TW">
                                            <option value="Hà Nội">Hà Nội</option>
                                            <option value="TP Hồ Chí Minh">TP Hồ Chí Minh</option>
                                            <option value="Đà Nẵng">Đà Nẵng</option>
                                            <option value="Hải Phòng">Hải Phòng</option>
                                            <option value="Cần Thơ">Cần Thơ</option>
                                        </optgroup>
                                        <optgroup label="Miền Bắc">
                                            <option value="Thái Nguyên">Thái Nguyên</option>
                                            <option value="Quảng Ninh">Quảng Ninh</option>
                                            <option value="Bắc Ninh">Bắc Ninh</option>
                                            <option value="Hải Dương">Hải Dương</option>
                                            <option value="Nam Định">Nam Định</option>
                                            <option value="Ninh Bình">Ninh Bình</option>
                                            <option value="Lào Cai">Lào Cai</option>
                                            <option value="Sơn La">Sơn La</option>
                                        </optgroup>
                                        <optgroup label="Miền Trung">
                                            <option value="Thanh Hóa">Thanh Hóa</option>
                                            <option value="Nghệ An">Nghệ An</option>
                                            <option value="Hà Tĩnh">Hà Tĩnh</option>
                                            <option value="Thừa Thiên Huế">Thừa Thiên Huế</option>
                                            <option value="Quảng Nam">Quảng Nam</option>
                                            <option value="Khánh Hòa">Khánh Hòa</option>
                                            <option value="Bình Thuận">Bình Thuận</option>
                                        </optgroup>
                                        <optgroup label="Tây Nguyên & Miền Nam">
                                            <option value="Đắk Lắk">Đắk Lắk</option>
                                            <option value="Lâm Đồng">Lâm Đồng</option>
                                            <option value="Bình Dương">Bình Dương</option>
                                            <option value="Đồng Nai">Đồng Nai</option>
                                            <option value="Bà Rịa - Vũng Tàu">Bà Rịa - Vũng Tàu</option>
                                            <option value="Long An">Long An</option>
                                            <option value="Tiền Giang">Tiền Giang</option>
                                            <option value="Kiên Giang">Kiên Giang</option>
                                            <option value="Cà Mau">Cà Mau</option>
                                        </optgroup>
                                    </select>
                                </div>
                                <div class="col-md-6 mb-4">
                                    <label class="form-label fw-semibold text-secondary">Địa chỉ cụ thể (Quận/Huyện, Phường/Xã)</label>
                                    <input type="text" name="ward" class="form-control" placeholder="VD: Số 12, Phường Bến Nghé, Quận 1" required>
                                </div>
                            </div>
                            <div class="mb-4">
                                <label class="form-label fw-semibold text-secondary">Số tiền đề nghị vay (VNĐ)</label>
                                <!-- Input hiển thị -->
                                <input type="text" id="amountDisplay" class="form-control fw-bold text-success" placeholder="Ví dụ: 50,000,000" required>
                                <!-- Input ẩn để gửi dữ liệu chuẩn cho Server -->
                                <input type="hidden" name="amount" id="amountHidden" required>
                            </div>
                            <div class="mb-5">
                                <label class="form-label fw-semibold text-secondary">Mục đích vay vốn</label>
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
                return true;
            });
        });
    </script>
</body>
</html>
