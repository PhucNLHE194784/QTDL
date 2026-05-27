package com.qrcredit.util;

import java.util.Properties;
import javax.mail.Message;
import javax.mail.MessagingException;
import javax.mail.PasswordAuthentication;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;

import com.qrcredit.dao.SettingDAO;

public class EmailService {
    
    private static String[] getCredentials() {
        SettingDAO dao = new SettingDAO();
        String email = dao.getSetting("SMTP_EMAIL");
        String pass = dao.getSetting("SMTP_PASSWORD");
        // Fallback for demo if not configured
        if (email == null || email.isEmpty()) email = "p4112k5@gmail.com";
        if (pass == null || pass.isEmpty()) pass = "pues flmr qreg gkwk";
        pass = pass.replace(" ", ""); // Loại bỏ khoảng trắng nếu người dùng lỡ copy thừa
        return new String[]{email, pass};
    }

    public static boolean sendOtpEmail(String recipientEmail, String otpCode) {
        Properties props = new Properties();
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");
        props.put("mail.smtp.host", "smtp.gmail.com");
        props.put("mail.smtp.port", "587");

        String[] creds = getCredentials();
        String senderEmail = creds[0];
        String senderPass = creds[1];

        Session session = Session.getInstance(props, new javax.mail.Authenticator() {
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(senderEmail, senderPass);
            }
        });

        try {
            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress(senderEmail));
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

    public static boolean sendPortalEmail(String recipientEmail, String otpCode, String token, String action, String domainUrl) {
        Properties props = new Properties();
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");
        props.put("mail.smtp.host", "smtp.gmail.com");
        props.put("mail.smtp.port", "587");

        String[] creds = getCredentials();
        String senderEmail = creds[0];
        String senderPass = creds[1];

        Session session = Session.getInstance(props, new javax.mail.Authenticator() {
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(senderEmail, senderPass);
            }
        });

        try {
            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress(senderEmail));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(recipientEmail));
            message.setSubject("Thông báo Hồ sơ Tín dụng - Agribank LoanFlow");
            
            String link = domainUrl + "/portal?token=" + token;
            String statusText = action != null && !action.isEmpty() ? "<p>Trạng thái hồ sơ của bạn vừa được cập nhật thành: <strong>" + action + "</strong></p>" : "";

            String htmlContent = "<div style=\"font-family: Arial, sans-serif; max-width: 600px; margin: auto; padding: 20px; border: 1px solid #ddd; border-radius: 10px;\">"
                    + "<div style=\"text-align: center; margin-bottom: 20px;\">"
                    + "<h2 style=\"color: #A51A29; margin: 0;\">AGRIBANK LOANFLOW</h2>"
                    + "</div>"
                    + "<p>Chào quý khách,</p>"
                    + statusText
                    + "<p>Để xem chi tiết Bảng Sao kê và Lịch sử thu nợ của khoản vay, vui lòng truy cập vào Cổng thông tin Khách hàng theo đường dẫn an toàn dưới đây:</p>"
                    + "<div style=\"text-align: center; margin: 20px 0;\">"
                    + "<a href=\"" + link + "\" style=\"background-color: #A51A29; color: white; padding: 12px 25px; text-decoration: none; border-radius: 5px; font-weight: bold; display: inline-block;\">TRUY CẬP CỔNG THÔNG TIN</a>"
                    + "</div>"
                    + "<p>Hoặc copy đường dẫn này dán vào trình duyệt: <a href=\"" + link + "\">" + link + "</a></p>"
                    + "<p>Sau khi bấm vào link, hệ thống sẽ yêu cầu mã Xác thực (OTP). Mã của bạn là:</p>"
                    + "<div style=\"text-align: center; margin: 20px 0;\">"
                    + "<span style=\"font-size: 32px; font-weight: bold; letter-spacing: 5px; color: #A51A29; background: #f8f9fa; padding: 15px 30px; border-radius: 5px; border: 1px dashed #A51A29;\">" + otpCode + "</span>"
                    + "</div>"
                    + "<p style=\"color: #777; font-size: 0.9em;\">Vui lòng nhập chính xác. Bạn được nhập sai tối đa 3 lần. Tuyệt đối không chia sẻ mã và đường link này cho bất kỳ ai.</p>"
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
