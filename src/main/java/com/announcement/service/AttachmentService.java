package com.announcement.service;

import com.announcement.dao.AttachmentDao;
import com.announcement.entity.Attachment;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

/**
 * 附件服務類
 */
@Service
@Transactional
public class AttachmentService {

    @Autowired
    private AttachmentDao attachmentDao;

    private static final String UPLOAD_DIR = "/opt/uploads/";

    /**
     * 保存單個附件
     */
    public Attachment saveAttachment(Long announcementId, MultipartFile file) throws IOException {
        // 保存文件到磁盤
        String fileName = saveFileToSystem(file);

        // 創建附件記錄
        Attachment attachment = new Attachment();
        attachment.setFileName(fileName);
        attachment.setOriginalName(file.getOriginalFilename());
        attachment.setFilePath(fileName);
        attachment.setFileSize(file.getSize());
        attachment.setContentType(file.getContentType());
        attachment.setAnnouncementId(announcementId);

        // 保存到數據庫
        attachmentDao.save(attachment);

        return attachment;
    }

    /**
     * 根據公告ID獲取所有附件
     */
    @Transactional(readOnly = true)
    public List<Attachment> getAttachmentsByAnnouncementId(Long announcementId) {
        return attachmentDao.findByAnnouncementId(announcementId);
    }

    /**
     * 根據ID獲取附件
     */
    @Transactional(readOnly = true)
    public Attachment getAttachmentById(Long id) {
        return attachmentDao.findById(id);
    }

    /**
     * 刪除附件
     */
    public void deleteAttachment(Long id) {
        Attachment attachment = attachmentDao.findById(id);
        if (attachment != null) {
            // 刪除物理文件
            deleteFileFromSystem(attachment.getFilePath());
            // 刪除數據庫記錄
            attachmentDao.delete(id);
        }
    }

    /**
     * 刪除公告的所有附件
     */
    public void deleteAttachmentsByAnnouncementId(Long announcementId) {
        List<Attachment> attachments = attachmentDao.findByAnnouncementId(announcementId);

        // 刪除物理文件
        for (Attachment attachment : attachments) {
            deleteFileFromSystem(attachment.getFilePath());
        }

        // 刪除數據庫記錄
        attachmentDao.deleteByAnnouncementId(announcementId);
    }

    /**
     * 保存文件到系統
     */
    private String saveFileToSystem(MultipartFile file) throws IOException {
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
     * 從系統刪除文件
     */
    private void deleteFileFromSystem(String fileName) {
        try {
            File file = new File(UPLOAD_DIR + fileName);
            if (file.exists()) {
                boolean deleted = file.delete();
                if (!deleted) {
                    System.err.println("無法刪除文件: " + fileName);
                }
            }
        } catch (Exception e) {
            System.err.println("刪除文件時發生錯誤: " + fileName + ", 錯誤: " + e.getMessage());
        }
    }
}