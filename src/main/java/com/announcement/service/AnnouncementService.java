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
     * 保存公告（含附件處理）
     */
    public void save(Announcement announcement, MultipartFile file) throws IOException {
        // 處理附件上傳
        if (file != null && !file.isEmpty()) {
            String fileName = saveFile(file);
            announcement.setAttachmentName(file.getOriginalFilename());
            announcement.setAttachmentPath(fileName);
        }

        // 保存公告
        announcementDao.save(announcement);
    }

    /**
     * 更新公告（含附件處理）- 修復Session衝突
     */
    public void update(Announcement announcement, MultipartFile file) throws IOException {
        // 先獲取現有公告信息（在不同的查詢中）
        Announcement existingAnnouncement = announcementDao.findById(announcement.getId());
        if (existingAnnouncement == null) {
            throw new RuntimeException("公告不存在");
        }

        // 處理新附件
        if (file != null && !file.isEmpty()) {
            // 刪除舊附件
            if (existingAnnouncement.getAttachmentPath() != null) {
                deleteFile(existingAnnouncement.getAttachmentPath());
            }

            // 上傳新附件
            String fileName = saveFile(file);
            announcement.setAttachmentName(file.getOriginalFilename());
            announcement.setAttachmentPath(fileName);
        } else {
            // 如果沒有新附件，保留原有附件信息
            announcement.setAttachmentName(existingAnnouncement.getAttachmentName());
            announcement.setAttachmentPath(existingAnnouncement.getAttachmentPath());
        }

        // 保留創建時間
        announcement.setCreateTime(existingAnnouncement.getCreateTime());
        // 設置更新時間
        announcement.setUpdateTime(new Date());

        // 使用merge而不是update，避免Session衝突
        announcementDao.merge(announcement);
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
     * 查詢所有公告
     */
    @Transactional(readOnly = true)
    public List<Announcement> findAll() {
        return announcementDao.findAll();
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
     * 根據標題搜索公告
     */
    @Transactional(readOnly = true)
    public List<Announcement> searchByTitle(String title) {
        return announcementDao.findByTitleLike(title);
    }

    /**
     * 根據發佈者查詢公告
     */
    @Transactional(readOnly = true)
    public List<Announcement> findByPublisher(String publisher) {
        return announcementDao.findByPublisher(publisher);
    }

    /**
     * 查詢有效公告
     */
    @Transactional(readOnly = true)
    public List<Announcement> findValidAnnouncements() {
        return announcementDao.findValidAnnouncements();
    }

    /**
     * 查詢已過期公告
     */
    @Transactional(readOnly = true)
    public List<Announcement> findExpiredAnnouncements() {
        return announcementDao.findExpiredAnnouncements();
    }

    /**
     * 批量刪除公告
     */
    public int batchDelete(List<Long> ids) {
        if (ids == null || ids.isEmpty()) {
            return 0;
        }

        // 先刪除相關的附件文件
        for (Long id : ids) {
            Announcement announcement = findById(id);
            if (announcement != null && announcement.getAttachmentPath() != null) {
                deleteFile(announcement.getAttachmentPath());
            }
        }

        // 批量刪除數據庫記錄
        return announcementDao.deleteByIds(ids);
    }

    /**
     * 保存上傳的文件
     */
    private String saveFile(MultipartFile file) throws IOException {
        // 創建上傳目錄
        File uploadDir = new File(UPLOAD_DIR);
        if (!uploadDir.exists()) {
            uploadDir.mkdirs();
        }

        // 生成唯一文件名
        String originalFilename = file.getOriginalFilename();
        String extension = "";
        if (originalFilename != null && originalFilename.contains(".")) {
            extension = originalFilename.substring(originalFilename.lastIndexOf("."));
        }
        String fileName = UUID.randomUUID().toString() + extension;

        // 保存文件
        File destFile = new File(uploadDir, fileName);
        file.transferTo(destFile);

        return fileName;
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
     * 驗證公告數據
     */
    public boolean validateAnnouncement(Announcement announcement) {
        if (announcement == null) {
            return false;
        }

        // 檢查必填字段
        if (announcement.getTitle() == null || announcement.getTitle().trim().isEmpty()) {
            return false;
        }

        if (announcement.getPublisher() == null || announcement.getPublisher().trim().isEmpty()) {
            return false;
        }

        if (announcement.getPublishDate() == null || announcement.getEndDate() == null) {
            return false;
        }

        // 檢查日期邏輯
        if (announcement.getEndDate().before(announcement.getPublishDate())) {
            return false;
        }

        return true;
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
}