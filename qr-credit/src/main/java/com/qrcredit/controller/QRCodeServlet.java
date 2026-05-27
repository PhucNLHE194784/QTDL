package com.qrcredit.controller;

import com.google.zxing.BarcodeFormat;
import com.google.zxing.client.j2se.MatrixToImageWriter;
import com.google.zxing.common.BitMatrix;
import com.google.zxing.qrcode.QRCodeWriter;
import java.io.IOException;
import java.net.InetAddress;
import java.net.NetworkInterface;
import java.util.Enumeration;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/qr")
public class QRCodeServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String id = request.getParameter("id");
        String type = request.getParameter("type");
        if (id == null) return;
        
        String scheme = request.getScheme();
        String serverName = request.getServerName();
        int serverPort = request.getServerPort();
        String contextPath = request.getContextPath();
        
        try {
            // Tự động tìm IP LAN nếu người dùng đang dùng localhost
            if ("localhost".equals(serverName) || "127.0.0.1".equals(serverName)) {
                Enumeration<NetworkInterface> nienum = NetworkInterface.getNetworkInterfaces();
                while (nienum.hasMoreElements()) {
                    NetworkInterface ni = nienum.nextElement();
                    if (!ni.isUp() || ni.isLoopback() || ni.isVirtual()) continue;
                    Enumeration<InetAddress> iaenum = ni.getInetAddresses();
                    while (iaenum.hasMoreElements()) {
                        InetAddress ia = iaenum.nextElement();
                        // Chỉ lấy IPv4 (không chứa dấu :)
                        if (!ia.isLoopbackAddress() && ia.getHostAddress().indexOf(":") == -1) {
                            // Ưu tiên dải IP phổ biến như 192.168.x.x hoặc 10.x.x.x
                            if(ia.getHostAddress().startsWith("192.168.") || ia.getHostAddress().startsWith("10.")) {
                                serverName = ia.getHostAddress();
                                break;
                            }
                            serverName = ia.getHostAddress(); // Fallback to any IPv4
                        }
                    }
                }
                if ("localhost".equals(serverName)) {
                     serverName = InetAddress.getLocalHost().getHostAddress();
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        
        String url;
        if ("public".equals(type)) {
            url = scheme + "://" + serverName + ":" + serverPort + contextPath + "/search?id=" + id;
            String t = request.getParameter("t");
            if (t != null) {
                url += "&t=" + t;
            }
        } else {
            url = scheme + "://" + serverName + ":" + serverPort + contextPath + "/profile?id=" + id;
        }

        try {
            QRCodeWriter qrCodeWriter = new QRCodeWriter();
            BitMatrix bitMatrix = qrCodeWriter.encode(url, BarcodeFormat.QR_CODE, 200, 200);
            response.setContentType("image/png");
            MatrixToImageWriter.writeToStream(bitMatrix, "PNG", response.getOutputStream());
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
