package com.announcement.entity;

import javax.persistence.*;
import java.util.Date;

/**
 * 附件實體類
 */
@Entity
@Table(name = "attachments")
public class Attachment {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "file_name", nullable = false)
    private String fileName;

    @Column(name = "original_name", nullable = false)
    private String originalName;

    @Column(name = "file_path", nullable = false)
    private String filePath;

    @Column(name = "file_size")
    private Long fileSize;

    @Column(name = "content_type")
    private String contentType;

    @Column(name = "announcement_id", nullable = false)
    private Long announcementId;

    @Column(name = "upload_time", nullable = false)
    @Temporal(TemporalType.TIMESTAMP)
    private Date uploadTime;

    // 構造方法
    public Attachment() {
        this.uploadTime = new Date();
    }

    public Attachment(String fileName, String originalName, String filePath, Long announcementId) {
        this();
        this.fileName = fileName;
        this.originalName = originalName;
        this.filePath = filePath;
        this.announcementId = announcementId;
    }

    // Getter和Setter
    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getFileName() {
        return fileName;
    }

    public void setFileName(String fileName) {
        this.fileName = fileName;
    }

    public String getOriginalName() {
        return originalName;
    }

    public void setOriginalName(String originalName) {
        this.originalName = originalName;
    }

    public String getFilePath() {
        return filePath;
    }

    public void setFilePath(String filePath) {
        this.filePath = filePath;
    }

    public Long getFileSize() {
        return fileSize;
    }

    public void setFileSize(Long fileSize) {
        this.fileSize = fileSize;
    }

    public String getContentType() {
        return contentType;
    }

    public void setContentType(String contentType) {
        this.contentType = contentType;
    }

    public Long getAnnouncementId() {
        return announcementId;
    }

    public void setAnnouncementId(Long announcementId) {
        this.announcementId = announcementId;
    }

    public Date getUploadTime() {
        return uploadTime;
    }

    public void setUploadTime(Date uploadTime) {
        this.uploadTime = uploadTime;
    }

    @Override
    public String toString() {
        return "Attachment{" +
                "id=" + id +
                ", fileName='" + fileName + '\'' +
                ", originalName='" + originalName + '\'' +
                ", announcementId=" + announcementId +
                ", uploadTime=" + uploadTime +
                '}';
    }
}