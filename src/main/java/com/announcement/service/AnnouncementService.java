package com.announcement.service;

import com.announcement.dao.AnnouncementDao;
import com.announcement.entity.Announcement;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import java.io.File;
import java.io.IOException;
import java.util.Date;
import java.util.List;
import java.util.UUID;

/**
 * 公告業務服務層
 * 提供業務邏輯處理和事務管理
 */
@Service
@Transactional
public class AnnouncementService {

    @Autowired
    private AnnouncementDao announcementDao;

    // 文件上傳目錄
    private static final String UPLOAD_DIR = "/opt/uploads/";


    /**
     * 簡單保存方法（不含文件）
     */
    public void save(Announcement announcement) {
        announcementDao.save(announcement);
    }

    /**
     * 簡單更新方法（不含文件）
     */
    public void update(Announcement announcement) {
        announcementDao.update(announcement);
    }

    /**
     * 刪除公告（含附件清理）
     */
    public void delete(Long id) {
        Announcement announcement = announcementDao.findById(id);
        if (announcement != null) {
            // 刪除附件文件
            if (announcement.getAttachmentPath() != null) {
                deleteFile(announcement.getAttachmentPath());
            }
            // 刪除公告記錄
            announcementDao.delete(id);
        }
    }

    /**
     * 根據ID查找公告
     */
    @Transactional(readOnly = true)
    public Announcement findById(Long id) {
        return announcementDao.findById(id);
    }

    /**
     * 分頁查詢公告
     */
    @Transactional(readOnly = true)
    public List<Announcement> findWithPagination(int page, int size) {
        return announcementDao.findWithPagination(page, size);
    }

    /**
     * 獲取公告總數
     */
    @Transactional(readOnly = true)
    public Long getTotalCount() {
        return announcementDao.getTotalCount();
    }

    /**
     * 計算總頁數
     */
    @Transactional(readOnly = true)
    public int getTotalPages(int size) {
        long totalCount = getTotalCount();
        return (int) Math.ceil((double) totalCount / size);
    }

    /**
     * 刪除文件
     */
    private void deleteFile(String fileName) {
        try {
            File file = new File(UPLOAD_DIR + fileName);
            if (file.exists()) {
                boolean deleted = file.delete();
                if (!deleted) {
                    System.err.println("無法刪除文件: " + fileName);
                }
            }
        } catch (Exception e) {
            // 記錄日誌但不拋出異常，避免影響主要業務流程
            System.err.println("刪除文件時發生錯誤: " + fileName + ", 錯誤: " + e.getMessage());
            e.printStackTrace();
        }
    }

    /**
     * 搜索公告（分頁）
     */
    @Transactional(readOnly = true)
    public List<Announcement> searchAnnouncements(String keyword, int page, int size) {
        return announcementDao.searchAnnouncements(keyword, page, size);
    }

    /**
     * 獲取搜索結果總數
     */
    @Transactional(readOnly = true)
    public long getSearchCount(String keyword) {
        return announcementDao.getSearchCount(keyword);
    }

}