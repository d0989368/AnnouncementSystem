USE announcement_db;

CREATE TABLE announcements (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(200) NOT NULL,
    publisher VARCHAR(100) NOT NULL,
    publish_date DATE NOT NULL,
    end_date DATE NOT NULL,
    content TEXT,
    attachment_name VARCHAR(255),
    attachment_path VARCHAR(255),
    create_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    update_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO announcements (title, publisher, publish_date, end_date, content) VALUES
('歡迎使用公告系統', '系統管理員', CURDATE(), DATE_ADD(CURDATE(), INTERVAL 30 DAY), '系統啟動成功，功能正常運行！'),
('Docker部署完成', '技術團隊', CURDATE(), DATE_ADD(CURDATE(), INTERVAL 60 DAY), '容器化部署成功，數據庫連接正常。'),
('功能測試', '測試人員', CURDATE(), DATE_ADD(CURDATE(), INTERVAL 45 DAY), '請測試查看、刪除等功能。'),
('編碼測試', '開發團隊', CURDATE(), DATE_ADD(CURDATE(), INTERVAL 15 DAY), '中文字符顯示測試。'),
('部署確認', '項目經理', CURDATE(), DATE_ADD(CURDATE(), INTERVAL 7 DAY), '如果看到此消息，說明部署成功！');