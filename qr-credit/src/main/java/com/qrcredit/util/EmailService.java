package com.qrcredit.util;

import java.util.Properties;
import javax.mail.Message;
import javax.mail.MessagingException;
import javax.mail.PasswordAuthentication;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;

public class EmailService {
    // Thay thế bằng Email và App Password của bạn
    private static final String SENDER_EMAIL = "nhuthao92a@gmail.com";
    private static final String SENDER_PASSWORD = "tbsl gtwz fghs jkhk"; // App Password

    public static boolean sendOtpEmail(String recipientEmail, String otpCode) {
        Properties props = new Properties();
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");
        props.put("mail.smtp.host", "smtp.gmail.com");
        props.put("mail.smtp.port", "587");

        Session session = Session.getInstance(props, new javax.mail.Authenticator() {
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(SENDER_EMAIL, SENDER_PASSWORD);
            }
        });

        try {
            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress(SENDER_EMAIL));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(recipientEmail));
            message.setSubject("Mã Xác Thực (OTP) - Agribank LoanFlow");
            
            String htmlContent = "<div style=\"font-family: Arial, sans-serif; max-width: 600px; margin: auto; padding: 20px; border: 1px solid #ddd; border-radius: 10px;\">"
                    + "<div style=\"text-align: center; margin-bottom: 20px;\">"
                    + "<h2 style=\"color: #A51A29; margin: 0;\">AGRIBANK LOANFLOW</h2>"
                    + "</div>"
                    + "<p>Chào quý khách,</p>"
                    + "<p>Bạn vừa yêu cầu truy cập vào Bảng Sao kê Khoản vay. Để bảo mật thông tin, vui lòng nhập mã xác thực (OTP) dưới đây:</p>"
                    + "<div style=\"text-align: center; margin: 30px 0;\">"
                    + "<span style=\"font-size: 32px; font-weight: bold; letter-spacing: 5px; color: #A51A29; background: #f8f9fa; padding: 15px 30px; border-radius: 5px; border: 1px dashed #A51A29;\">" + otpCode + "</span>"
                    + "</div>"
                    + "<p style=\"color: #777; font-size: 0.9em;\">Mã OTP này chỉ có hiệu lực trong 3 phút. Tuyệt đối không chia sẻ mã này cho bất kỳ ai, kể cả nhân viên ngân hàng.</p>"
                    + "<hr style=\"border: none; border-top: 1px solid #eee; margin: 20px 0;\">"
                    + "<p style=\"font-size: 0.8em; color: #999; text-align: center;\">© 2026 Agribank. Email này được gửi tự động, vui lòng không trả lời.</p>"
                    + "</div>";

            message.setContent(htmlContent, "text/html; charset=utf-8");
            Transport.send(message);
            return true;
        } catch (MessagingException e) {
            e.printStackTrace();
            return false;
        }
    }
}
