<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
    <title>Xác Thực - Agribank Mobile App</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <style>
        body { background-color: #e9ecef; margin: 0; font-family: 'Inter', sans-serif; display: flex; align-items: center; justify-content: center; min-height: 100vh;}
        .app-container {
            width: 100%; max-width: 414px; background-color: #fff; min-height: 100vh;
            position: relative; box-shadow: 0 0 30px rgba(0,0,0,0.15); overflow-x: hidden;
            display: flex; flex-direction: column;
        }
        .auth-header {
            background: linear-gradient(135deg, #b01a2e 0%, #8E1521 100%);
            color: white; padding: 40px 20px 60px 20px; text-align: center;
            border-bottom-left-radius: 30px; border-bottom-right-radius: 30px;
        }
        .logo-box { font-weight: 800; font-size: 1.5rem; letter-spacing: 1px; display: flex; align-items: center; justify-content: center; gap: 10px; margin-bottom: 10px;}
        .logo-box i { color: #f1c40f; font-size: 2rem; }
        .auth-header p { opacity: 0.9; font-size: 0.9rem; }
        
        .auth-card {
            background: white; border-radius: 20px; padding: 30px 20px; margin: -40px 20px 20px;
            box-shadow: 0 10px 25px rgba(0,0,0,0.08); position: relative; z-index: 10;
        }
        
        .auth-title { font-weight: 700; color: #b01a2e; margin-bottom: 20px; text-align: center; display: flex; align-items: center; justify-content: center; gap: 10px;}
        .auth-desc { font-size: 0.85rem; color: #666; text-align: center; margin-bottom: 25px; line-height: 1.5; }
        
        .otp-input { width: 45px; height: 50px; font-size: 1.5rem; text-align: center; border: 2px solid #e5e7eb; border-radius: 10px; font-weight: 700; color: #b01a2e; }
        .otp-input:focus { border-color: #059669; outline: none; box-shadow: 0 0 0 3px rgba(5,150,105,0.2); }
        
        .btn-auth { background: #059669; color: white; font-weight: 700; padding: 14px; border-radius: 12px; width: 100%; border: none; font-size: 1rem; transition: 0.2s; }
        .btn-auth:hover { background: #047857; }
        
        .camera-box { position: relative; width: 100%; border-radius: 16px; overflow: hidden; border: 3px solid #e5e7eb; box-shadow: inset 0 0 20px rgba(0,0,0,0.1); background: #f8fafc; }
        .camera-box video { width: 100%; display: block; transform: scaleX(-1); -webkit-transform: scaleX(-1); }
        .camera-box canvas { position: absolute; top: 0; left: 0; width: 100%; height: 100%; transform: scaleX(-1); -webkit-transform: scaleX(-1); }
        .scan-overlay { position: absolute; top: 0; left: 0; width: 100%; height: 100%; pointer-events: none; border: 4px solid rgba(5,150,105,0.3); border-radius: 16px; }
        
        .face-status { font-size: 0.8rem; font-weight: 600; text-align: center; margin-top: 15px; min-height: 20px; }
    </style>
</head>
<body>
    <div class="app-container">
        <div class="auth-header">
            <div class="logo-box">
                <i class="fa-solid fa-leaf"></i> AGRIBANK
            </div>
            <p>Ứng dụng quản lý tín dụng & sinh trắc học</p>
        </div>

        <div class="auth-card">
            <c:if test="${not empty error}">
                <div class="alert alert-danger" style="font-size: 0.8rem; border-radius: 10px;"><i class="fa-solid fa-circle-exclamation"></i> ${error}</div>
            </c:if>
            <c:if test="${not empty param.message}">
                <div class="alert alert-success" style="font-size: 0.8rem; border-radius: 10px;"><i class="fa-solid fa-circle-check"></i> ${param.message}</div>
            </c:if>

            <c:choose>
                <c:when test="${useFaceId}">
                    <h5 class="auth-title"><i class="fa-solid fa-face-viewfinder"></i> Xác thực sinh trắc học</h5>
                    <p class="auth-desc">Vui lòng đưa khuôn mặt vào khung hình để xác minh danh tính trước khi truy cập tài khoản.</p>
                    
                    <div class="mb-4 text-center">
                        <div class="camera-box">
                            <video id="videoElement" autoplay muted playsinline></video>
                            <canvas id="canvasElement"></canvas>
                            <div class="scan-overlay"></div>
                        </div>
                        <div class="mt-4">
                            <button type="button" id="startCameraBtn" class="btn-auth"><i class="fa-solid fa-camera me-2"></i>BẬT CAMERA XÁC THỰC</button>
                        </div>
                        <div id="faceStatus" class="face-status text-muted"></div>
                    </div>

                    <form action="portal" method="post" id="faceForm">
                        <input type="hidden" name="action" value="verifyFace">
                        <input type="hidden" name="token" value="${token}">
                        <input type="hidden" name="liveDescriptor" id="liveDescriptorHidden">
                    </form>
                    
                    <script src="https://code.jquery.com/jquery-3.7.0.min.js"></script>
                    <script src="js/face-api.min.js"></script>
                    <script>
                        $(document).ready(function() {
                            Promise.all([
                                faceapi.nets.ssdMobilenetv1.loadFromUri('models'),
                                faceapi.nets.faceLandmark68Net.loadFromUri('models'),
                                faceapi.nets.faceRecognitionNet.loadFromUri('models')
                            ]).then(() => {
                                $('#faceStatus').html("<span class='text-success'>Hệ thống AI đã sẵn sàng. Vui lòng bấm Bật Camera.</span>");
                            }).catch(err => {
                                $('#faceStatus').html("<span class='text-danger'>Lỗi khởi động AI. Vui lòng làm mới trang.</span>");
                            });

                            const video = document.getElementById('videoElement');
                            const canvas = document.getElementById('canvasElement');
                            const faceStatus = document.getElementById('faceStatus');
                            const faceForm = document.getElementById('faceForm');
                            const faceDescriptorHidden = document.getElementById('liveDescriptorHidden');
                            let cameraStream = null;
                            let faceScanInterval = null;

                            $('#startCameraBtn').click(async function() {
                                try {
                                    cameraStream = await navigator.mediaDevices.getUserMedia({ video: { facingMode: 'user' } });
                                    video.srcObject = cameraStream;
                                    $(this).addClass('d-none');
                                    faceStatus.innerHTML = "<span class='text-primary'><i class='fas fa-spinner fa-spin'></i> Đang quét nhận diện khuôn mặt...</span>";
                                    
                                    video.addEventListener('play', () => {
                                        const displaySize = { width: video.videoWidth, height: video.videoHeight };
                                        faceapi.matchDimensions(canvas, displaySize);
                                        
                                        faceScanInterval = setInterval(async () => {
                                            const detections = await faceapi.detectSingleFace(video, new faceapi.SsdMobilenetv1Options({ minConfidence: 0.5 })).withFaceLandmarks().withFaceDescriptor();
                                            
                                            if (detections) {
                                                const resizedDetections = faceapi.resizeResults(detections, displaySize);
                                                canvas.getContext('2d').clearRect(0, 0, canvas.width, canvas.height);
                                                faceapi.draw.drawDetections(canvas, resizedDetections);
                                                
                                                clearInterval(faceScanInterval);
                                                cameraStream.getTracks().forEach(track => track.stop());
                                                faceStatus.innerHTML = "<span class='text-success fw-bold'><i class='fas fa-check-circle'></i> Đã lấy sinh trắc học! Đang đối chiếu...</span>";
                                                
                                                faceDescriptorHidden.value = JSON.stringify(Array.from(detections.descriptor));
                                                faceForm.submit();
                                            }
                                        }, 500);
                                    });
                                } catch (err) {
                                    faceStatus.innerHTML = "<span class='text-danger fw-bold'>Lỗi: Vui lòng cấp quyền Camera!</span>";
                                }
                            });
                        });
                    </script>
                </c:when>
                <c:when test="${locked}">
                    <div class="text-center text-danger mb-4">
                        <i class="fas fa-lock fa-3x mb-3"></i>
                        <h5 class="fw-bold">Phiên đăng nhập bị khóa</h5>
                        <p class="small">Bạn đã nhập sai quá số lần quy định.</p>
                    </div>
                    <form action="portal" method="post">
                        <input type="hidden" name="action" value="resend">
                        <input type="hidden" name="token" value="${token}">
                        <button type="submit" class="btn-auth"><i class="fas fa-sync-alt me-2"></i>YÊU CẦU CẤP LẠI MÃ</button>
                    </form>
                </c:when>
                <c:otherwise>
                    <h5 class="auth-title"><i class="fa-solid fa-message"></i> Xác thực mã OTP</h5>
                    <p class="auth-desc">
                        <c:choose>
                            <c:when test="${otpMethod == 'SMS'}">
                                Mã 6 số đã được gửi qua SMS đến SDT <strong>${maskedContact}</strong>.
                            </c:when>
                            <c:otherwise>
                                Mã 6 số đã được gửi đến email <strong>${maskedContact}</strong>.
                            </c:otherwise>
                        </c:choose>
                    </p>

                    <form action="portal" method="post" id="otpForm">
                        <input type="hidden" name="action" value="verify">
                        <input type="hidden" name="token" value="${token}">
                        <div class="d-flex justify-content-center gap-2 mb-4">
                            <input type="text" class="otp-input" maxlength="1" pattern="[0-9]" required>
                            <input type="text" class="otp-input" maxlength="1" pattern="[0-9]" required>
                            <input type="text" class="otp-input" maxlength="1" pattern="[0-9]" required>
                            <input type="text" class="otp-input" maxlength="1" pattern="[0-9]" required>
                            <input type="text" class="otp-input" maxlength="1" pattern="[0-9]" required>
                            <input type="text" class="otp-input" maxlength="1" pattern="[0-9]" required>
                        </div>
                        <input type="hidden" name="otp" id="fullOtp">
                        <button type="submit" class="btn-auth"><i class="fa-solid fa-unlock-keyhole me-2"></i>XÁC NHẬN</button>
                    </form>
                    
                    <script>
                        const inputs = document.querySelectorAll('.otp-input');
                        const form = document.getElementById('otpForm');
                        const fullOtp = document.getElementById('fullOtp');
                        if (inputs.length > 0) {
                            inputs.forEach((input, index) => {
                                input.addEventListener('input', (e) => {
                                    if (e.target.value.length === 1 && index < inputs.length - 1) inputs[index + 1].focus();
                                });
                                input.addEventListener('keydown', (e) => {
                                    if (e.key === 'Backspace' && e.target.value === '' && index > 0) inputs[index - 1].focus();
                                });
                            });
                            form.addEventListener('submit', () => {
                                let otp = ''; inputs.forEach(input => otp += input.value); fullOtp.value = otp;
                            });
                        }
                    </script>
                </c:otherwise>
            </c:choose>
        </div>
        
        <div style="flex-grow: 1;"></div>
        <div class="text-center p-3 text-muted" style="font-size: 0.7rem;">
            Dữ liệu được mã hóa SSL chuẩn NHNN.<br>
            © 2026 Agribank LoanFlow
        </div>
    </div>
</body>
</html>
