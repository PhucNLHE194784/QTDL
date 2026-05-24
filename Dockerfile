# Build stage
FROM maven:3.8.6-openjdk-8 AS build
WORKDIR /app
# Sao chép file cấu hình Maven và mã nguồn
COPY qr-credit/pom.xml .
COPY qr-credit/src ./src
# Biên dịch dự án
RUN mvn clean package -DskipTests

# Run stage
FROM tomcat:9.0-jre8-alpine
# Xóa các ứng dụng mặc định của Tomcat để dọn chỗ
RUN rm -rf /usr/local/tomcat/webapps/*

# Đổi cổng mặc định của Tomcat từ 8080 sang cổng Render cấp phát thông qua biến $PORT (Thường Render dùng cổng 10000)
# Render thường gán port thông qua biến môi trường PORT, Tomcat mặc định chạy cổng 8080.
# Render Web Service Docker mặc định hỗ trợ EXPOSE hoặc mapping nên không cần đổi cổng server.xml, chỉ cần EXPOSE 8080.

# Sao chép file war đã biên dịch vào thư mục ROOT để chạy ở trang chủ (/) thay vì /qr-credit
COPY --from=build /app/target/qr-credit.war /usr/local/tomcat/webapps/ROOT.war

EXPOSE 8080
CMD ["catalina.sh", "run"]
