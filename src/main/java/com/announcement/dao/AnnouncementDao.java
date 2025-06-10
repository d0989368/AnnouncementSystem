package com.announcement.dao;

import com.announcement.entity.Announcement;
import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.query.Query;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import java.util.List;

/**
 * 公告數據訪問層
 * 提供基本的CRUD操作和分頁查詢功能
 */
@Repository
public class AnnouncementDao {

    @Autowired
    private SessionFactory sessionFactory;

    /**
     * 獲取當前Session
     */
    private Session getCurrentSession() {
        return sessionFactory.getCurrentSession();
    }

    /**
     * 保存公告
     */
    public void save(Announcement announcement) {
        getCurrentSession().save(announcement);
    }

    /**
     * 更新公告
     */
    public void update(Announcement announcement) {
        getCurrentSession().update(announcement);
    }

    /**
     * 根據ID刪除公告
     */
    public void delete(Long id) {
        Announcement announcement = findById(id);
        if (announcement != null) {
            getCurrentSession().delete(announcement);
        }
    }

    /**
     * 根據ID查找公告
     */
    public Announcement findById(Long id) {
        return getCurrentSession().get(Announcement.class, id);
    }

    /**
     * 分頁查詢公告
     * @param page 頁碼（從1開始）
     * @param size 每頁大小
     * @return 公告列表
     */
    @SuppressWarnings("unchecked")
    public List<Announcement> findWithPagination(int page, int size) {
        Query<Announcement> query = getCurrentSession().createQuery(
                "FROM Announcement ORDER BY publishDate DESC, createTime DESC",
                Announcement.class
        );
        query.setFirstResult((page - 1) * size);
        query.setMaxResults(size);
        return query.list();
    }

    /**
     * 獲取公告總數
     */
    public Long getTotalCount() {
        Query<Long> query = getCurrentSession().createQuery(
                "SELECT COUNT(*) FROM Announcement",
                Long.class
        );
        return query.uniqueResult();
    }

    /**
     * 搜索公告（支持標題和發佈者搜索，分頁）
     */
    public List<Announcement> searchAnnouncements(String keyword, int page, int size) {
        String hql = "FROM Announcement a WHERE a.title LIKE :keyword OR a.publisher LIKE :keyword ORDER BY a.createTime DESC";
        Query<Announcement> query = getCurrentSession().createQuery(hql, Announcement.class);
        query.setParameter("keyword", "%" + keyword + "%");
        query.setFirstResult((page - 1) * size);
        query.setMaxResults(size);
        return query.getResultList();
    }

    /**
     * 獲取搜索結果總數
     */
    public long getSearchCount(String keyword) {
        String hql = "SELECT COUNT(a) FROM Announcement a WHERE a.title LIKE :keyword OR a.publisher LIKE :keyword";
        Query<Long> query = getCurrentSession().createQuery(hql, Long.class);
        query.setParameter("keyword", "%" + keyword + "%");
        return query.getSingleResult();
    }
}