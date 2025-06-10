package com.announcement.dao;

import com.announcement.entity.Attachment;
import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.query.Query;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import java.util.List;

/**
 * 附件數據訪問層
 */
@Repository
public class AttachmentDao {

    @Autowired
    private SessionFactory sessionFactory;

    private Session getCurrentSession() {
        return sessionFactory.getCurrentSession();
    }

    /**
     * 保存附件
     */
    public void save(Attachment attachment) {
        getCurrentSession().save(attachment);
    }

    /**
     * 根據ID查找附件
     */
    public Attachment findById(Long id) {
        return getCurrentSession().get(Attachment.class, id);
    }

    /**
     * 根據公告ID查找所有附件
     */
    public List<Attachment> findByAnnouncementId(Long announcementId) {
        String hql = "FROM Attachment WHERE announcementId = :announcementId ORDER BY uploadTime ASC";
        Query<Attachment> query = getCurrentSession().createQuery(hql, Attachment.class);
        query.setParameter("announcementId", announcementId);
        return query.getResultList();
    }

    /**
     * 刪除附件
     */
    public void delete(Long id) {
        Attachment attachment = findById(id);
        if (attachment != null) {
            getCurrentSession().delete(attachment);
        }
    }

    /**
     * 根據公告ID刪除所有附件
     */
    public int deleteByAnnouncementId(Long announcementId) {
        String hql = "DELETE FROM Attachment WHERE announcementId = :announcementId";
        Query query = getCurrentSession().createQuery(hql);
        query.setParameter("announcementId", announcementId);
        return query.executeUpdate();
    }

    /**
     * 統計公告的附件數量
     */
    public long countByAnnouncementId(Long announcementId) {
        String hql = "SELECT COUNT(a) FROM Attachment a WHERE a.announcementId = :announcementId";
        Query<Long> query = getCurrentSession().createQuery(hql, Long.class);
        query.setParameter("announcementId", announcementId);
        return query.getSingleResult();
    }
}