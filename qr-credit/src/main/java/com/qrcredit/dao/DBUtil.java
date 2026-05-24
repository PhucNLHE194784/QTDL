package com.qrcredit.dao;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.Statement;

public class DBUtil {

    // Đây là URL mặc định do bạn cung cấp trong ảnh. Render sẽ đọc từ biến môi trường.
    private static final String DEFAULT_DB_URL = "jdbc:postgresql://ep-hidden-hat-aq4a388c.c-8.us-east-1.aws.neon.tech/neondb?user=neondb_owner&password=*************&sslmode=require";

    static {
        try {
            Class.forName("org.postgresql.Driver");
            initDB();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public static Connection getConnection() throws Exception {
        // Trên Render, biến DATABASE_URL sẽ được tự động điền nếu liên kết Postgres.
        String dbUrl = System.getenv("DATABASE_URL");
        
        if (dbUrl != null && !dbUrl.isEmpty()) {
            // Neon cung cấp postgres:// nhưng JDBC cần jdbc:postgresql://
            if (dbUrl.startsWith("postgres://")) {
                dbUrl = dbUrl.replace("postgres://", "jdbc:postgresql://");
            } else if (dbUrl.startsWith("postgresql://")) {
                dbUrl = dbUrl.replace("postgresql://", "jdbc:postgresql://");
            }
        } else {
            // Nếu không có cấu hình, dùng đường link mặc định (Lưu ý: Nếu pass thật thì thay vào đây)
            dbUrl = DEFAULT_DB_URL;
        }

        return DriverManager.getConnection(dbUrl);
    }

    private static void initDB() {
        try (Connection conn = getConnection(); Statement stmt = conn.createStatement()) {
            // Tạo các bảng nếu chưa có (PostgreSQL dùng SERIAL thay vì AUTOINCREMENT)
            stmt.execute("CREATE TABLE IF NOT EXISTS users (id SERIAL PRIMARY KEY, username TEXT UNIQUE, password TEXT, role TEXT, fullname TEXT)");
            stmt.execute("CREATE TABLE IF NOT EXISTS profiles (id TEXT PRIMARY KEY, customer_name TEXT, cccd TEXT, amount REAL, purpose TEXT, status TEXT, region TEXT, ward TEXT, last_updated TIMESTAMP)");
            
            try { stmt.execute("ALTER TABLE profiles ADD COLUMN region TEXT"); } catch (Exception e) {}
            try { stmt.execute("ALTER TABLE profiles ADD COLUMN ward TEXT"); } catch (Exception e) {}
            try { stmt.execute("ALTER TABLE profiles ADD COLUMN phone TEXT"); } catch (Exception e) {}
            try { stmt.execute("ALTER TABLE profiles ADD COLUMN is_deleted BOOLEAN DEFAULT FALSE"); } catch (Exception e) {}
            try { stmt.execute("ALTER TABLE users ADD COLUMN status TEXT DEFAULT 'ACTIVE'"); } catch (Exception e) {}
            
            stmt.execute("CREATE TABLE IF NOT EXISTS audit_trail (id SERIAL PRIMARY KEY, profile_id TEXT, user_id INTEGER, old_status TEXT, new_status TEXT, updated_at TIMESTAMP)");
            
            // Thêm dữ liệu mẫu (PostgreSQL dùng ON CONFLICT thay vì INSERT OR IGNORE)
            stmt.execute("INSERT INTO users (username, password, role, fullname, status) VALUES ('admin', 'admin123', 'ADMIN', 'Super Admin', 'ACTIVE') ON CONFLICT (username) DO NOTHING");
            stmt.execute("INSERT INTO users (username, password, role, fullname) VALUES ('gdv1', '123456', 'GDV', 'Giao dịch viên 1') ON CONFLICT (username) DO NOTHING");
            stmt.execute("INSERT INTO users (username, password, role, fullname) VALUES ('thamdinh', '123456', 'THAM_DINH', 'Cán bộ Thẩm định') ON CONFLICT (username) DO NOTHING");
            stmt.execute("INSERT INTO users (username, password, role, fullname) VALUES ('lanhdao', '123456', 'LANH_DAO', 'Lãnh đạo Chi nhánh') ON CONFLICT (username) DO NOTHING");
            
            // Cập nhật lại status mặc định cho những user cũ (chưa có status)
            stmt.execute("UPDATE users SET status = 'ACTIVE' WHERE status IS NULL");
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
