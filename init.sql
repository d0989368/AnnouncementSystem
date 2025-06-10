SET sql_mode = '';
SET FOREIGN_KEY_CHECKS = 0;
SET NAMES utf8mb4;
SET CHARACTER SET utf8mb4;

CREATE DATABASE IF NOT EXISTS announcement_db
CHARACTER SET utf8mb4
COLLATE utf8mb4_unicode_ci;

USE announcement_db;

DROP TRIGGER IF EXISTS announcement_update_log;
DROP PROCEDURE IF EXISTS CleanExpiredAttachments;
DROP VIEW IF EXISTS announcement_stats;
DROP TABLE IF EXISTS announcement_logs;
DROP TABLE IF EXISTS attachments;
DROP TABLE IF EXISTS announcements;

-- 創建公告表
CREATE TABLE announcements (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '公告標題',
    publisher VARCHAR(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '發佈者',
    publish_date DATE NOT NULL COMMENT '發佈日期',
    end_date DATE NOT NULL COMMENT '截止日期',
    content TEXT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci COMMENT '公告內容',
    create_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '創建時間',
    update_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新時間',

    -- 索引
    INDEX idx_publish_date (publish_date),
    INDEX idx_end_date (end_date),
    INDEX idx_publisher (publisher),
    INDEX idx_create_time (create_time),
    INDEX idx_title (title),

    -- 约束
    CONSTRAINT chk_date_order CHECK (publish_date <= end_date)
) ENGINE=InnoDB
  DEFAULT CHARSET=utf8mb4
  COLLATE=utf8mb4_unicode_ci
  COMMENT='公告表';

-- 創建附件表
CREATE TABLE attachments (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    file_name VARCHAR(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '存儲文件名',
    original_name VARCHAR(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '原始文件名',
    file_path VARCHAR(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '文件路徑',
    file_size BIGINT COMMENT '文件大小（字節）',
    content_type VARCHAR(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci COMMENT '文件MIME類型',
    announcement_id BIGINT NOT NULL COMMENT '關聯的公告ID',
    upload_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '上傳時間',

    -- 索引
    INDEX idx_announcement_id (announcement_id),
    INDEX idx_upload_time (upload_time),
    INDEX idx_file_name (file_name),

    -- 外键约束（明确命名）
    CONSTRAINT fk_attachments_announcement
        FOREIGN KEY (announcement_id) REFERENCES announcements(id) ON DELETE CASCADE
) ENGINE=InnoDB
  DEFAULT CHARSET=utf8mb4
  COLLATE=utf8mb4_unicode_ci
  COMMENT='附件表';

-- 創建日志表
CREATE TABLE announcement_logs (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    announcement_id BIGINT NOT NULL,
    action_type ENUM('CREATE', 'UPDATE', 'DELETE') NOT NULL,
    old_title VARCHAR(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
    new_title VARCHAR(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
    operator VARCHAR(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
    action_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    INDEX idx_announcement_id (announcement_id),
    INDEX idx_action_time (action_time),
    INDEX idx_action_type (action_type)
) ENGINE=InnoDB
  DEFAULT CHARSET=utf8mb4
  COLLATE=utf8mb4_unicode_ci
  COMMENT='公告操作日志表';

-- 插入假資料
INSERT INTO announcements (title, publisher, publish_date, end_date, content) VALUES
('歡迎使用公告管理系統', '系統管理員', CURDATE(), DATE_ADD(CURDATE(), INTERVAL 6 MONTH),
'這是一個功能完整的公告管理系統，支持多附件上傳、在線查看、編輯和刪除等功能。系統採用Spring MVC架構，具有良好的擴展性和維護性。'),

('系統功能說明', '技術團隊', CURDATE(), DATE_ADD(CURDATE(), INTERVAL 3 MONTH),
'公告管理系統主要功能：
- 公告的增删改查操作
- 多附件上傳和管理
- 分頁查詢和搜索
- 響應式Web界面
- Docker容器化部署'),

('使用注意事項', '產品經理', CURDATE(), DATE_ADD(CURDATE(), INTERVAL 1 MONTH),
'系統使用注意事項：
✅ 支持同時上傳多個文件
✅ 單個文件最大50MB
✅ 支持常見文档和圖片格式
✅ 附件可以獨立删除和下載
✅ 公告支持富文本内容

如有問題請聯系技術支持。');

-- 創建視圖：公告統計信息
CREATE VIEW announcement_stats AS
SELECT
    a.id,
    a.title,
    a.publisher,
    a.publish_date,
    a.end_date,
    a.create_time,
    COUNT(att.id) as attachment_count,
    CASE
        WHEN a.end_date < CURDATE() THEN '已過期'
        WHEN a.publish_date > CURDATE() THEN '未發佈'
        ELSE '進行中'
    END as status
FROM announcements a
LEFT JOIN attachments att ON a.id = att.announcement_id
GROUP BY a.id, a.title, a.publisher, a.publish_date, a.end_date, a.create_time
ORDER BY a.create_time DESC;

-- 創建存儲過程：清理過期附件
DELIMITER //
CREATE PROCEDURE CleanExpiredAttachments()
BEGIN
    DECLARE done INT DEFAULT FALSE;
    DECLARE attach_id BIGINT;
    DECLARE file_path VARCHAR(500);
    DECLARE deleted_count INT DEFAULT 0;

    DECLARE cur CURSOR FOR
        SELECT att.id, att.file_path
        FROM attachments att
        JOIN announcements a ON att.announcement_id = a.id
        WHERE a.end_date < DATE_SUB(CURDATE(), INTERVAL 30 DAY);

    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    START TRANSACTION;

    OPEN cur;

    read_loop: LOOP
        FETCH cur INTO attach_id, file_path;
        IF done THEN
            LEAVE read_loop;
        END IF;

        -- 删除附件紀錄
        DELETE FROM attachments WHERE id = attach_id;
        SET deleted_count = deleted_count + 1;

    END LOOP;

    CLOSE cur;

    COMMIT;

    SELECT CONCAT('清理完成，共清理 ', deleted_count, ' 個過期附件') as result;
END //
DELIMITER ;

-- 創建觸發器：紀錄公告修改日誌
DELIMITER //
CREATE TRIGGER announcement_update_log
    AFTER UPDATE ON announcements
    FOR EACH ROW
BEGIN
    INSERT INTO announcement_logs (announcement_id, action_type, old_title, new_title, operator)
    VALUES (NEW.id, 'UPDATE', OLD.title, NEW.title, 'system');
END //
DELIMITER ;

CREATE TRIGGER announcement_create_log
    AFTER INSERT ON announcements
    FOR EACH ROW
BEGIN
    INSERT INTO announcement_logs (announcement_id, action_type, new_title, operator)
    VALUES (NEW.id, 'CREATE', NEW.title, 'system');
END //
DELIMITER ;

CREATE TRIGGER announcement_delete_log
    BEFORE DELETE ON announcements
    FOR EACH ROW
BEGIN
    INSERT INTO announcement_logs (announcement_id, action_type, old_title, operator)
    VALUES (OLD.id, 'DELETE', OLD.title, 'system');
END //
DELIMITER ;

-- 恢復設置
SET FOREIGN_KEY_CHECKS = 1;

-- 插入完成標記
INSERT INTO announcements (title, publisher, publish_date, end_date, content) VALUES
('數據庫初始化完成', 'SYSTEM', CURDATE(), DATE_ADD(CURDATE(), INTERVAL 1 YEAR),
CONCAT('數據庫初始化完成時間：', NOW(), '\n',
'- 公告表：announcements\n',
'- 附件表：attachments\n',
'- 日誌表：announcement_logs\n',
'- 統計視圖：announcement_stats\n',
'- 清理存儲過程：CleanExpiredAttachments\n',
'- 觸發器：記錄操作日誌\n',
'系統就緒，可以正常使用！'));

-- 顯示初始化結果
SELECT '=== 數據庫初始化完成 ===' as status;
SELECT COUNT(*) as announcement_count FROM announcements;
SELECT COUNT(*) as attachment_count FROM attachments;
SELECT '多附件功能已啟用，系統就緒' as feature_info;