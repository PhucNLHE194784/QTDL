package com.qrcredit.util;

import com.qrcredit.dao.SettingDAO;

import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.nio.charset.StandardCharsets;
import java.util.Base64;

public class SmsService {
    
    private static String getApiKey() {
        SettingDAO dao = new SettingDAO();
        String apiKey = dao.getSetting("SMS_API_KEY");
        if (apiKey == null || apiKey.trim().isEmpty()) {
            apiKey = "a4qb1qOdIRM9xFRkHjYzhHOnuiClSsu5";
        }
        return apiKey;
    }

    public static boolean sendPortalSms(String recipientPhone, String otpCode, String token, String action, String domainUrl) {
        String apiKey = getApiKey();
        if (apiKey == null || apiKey.trim().isEmpty()) {
            System.out.println("Lỗi: Chưa cấu hình SMS_API_KEY");
            return false;
        }

        try {
            // Định dạng lại sđt (VD: 0912345678 -> 84912345678)
            if (recipientPhone.startsWith("0")) {
                recipientPhone = "84" + recipientPhone.substring(1);
            } else if (recipientPhone.startsWith("+84")) {
                recipientPhone = recipientPhone.substring(1);
            }

            String link = domainUrl + "/portal?token=" + token;
            String message = "AGRIBANK LOANFLOW: Ma xac thuc (OTP) cua ban la " + otpCode + ". Link xem ho so: " + link;
            
            // Xây dựng JSON payload
            String jsonPayload = String.format(
                "{\"to\": [\"%s\"], \"content\": \"%s\", \"sms_type\": 2, \"sender\": \"Speedsms\"}",
                recipientPhone, message
            );

            URL url = new URL("https://api.speedsms.vn/index.php/sms/send");
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();
            conn.setRequestMethod("POST");
            conn.setRequestProperty("Content-Type", "application/json");
            
            // Basic Auth với API Key (Username = API Key, Password = rỗng hoặc 'x')
            String auth = apiKey + ":x";
            String encodedAuth = Base64.getEncoder().encodeToString(auth.getBytes(StandardCharsets.UTF_8));
            conn.setRequestProperty("Authorization", "Basic " + encodedAuth);
            
            conn.setDoOutput(true);
            try(OutputStream os = conn.getOutputStream()) {
                byte[] input = jsonPayload.getBytes(StandardCharsets.UTF_8);
                os.write(input, 0, input.length);
            }

            int responseCode = conn.getResponseCode();
            System.out.println("SpeedSMS Response Code: " + responseCode);
            
            return responseCode == 200 || responseCode == 201;

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
}
