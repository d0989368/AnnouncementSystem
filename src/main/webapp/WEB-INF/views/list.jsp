<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>公告管理系統</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        .status-badge {
            font-size: 0.75em;
        }
        .announcement-title {
            font-weight: 600;
            color: #333;
        }
        .announcement-title:hover {
            color: #0d6efd;
            text-decoration: none;
        }
        .search-form {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        }
        .stats-card {
            border: none;
            box-shadow: 0 0.125rem 0.25rem rgba(0, 0, 0, 0.075);
        }
    </style>
</head>
<body class="bg-light">
    <!-- 導航欄 -->
    <nav class="navbar navbar-expand-lg navbar-dark bg-primary shadow">
        <div class="container">
            <a class="navbar-brand" href="${pageContext.request.contextPath}/web/">
                <i class="fas fa-bullhorn me-2"></i>公告管理系統
            </a>
        </div>
    </nav>

    <div class="container mt-4">
        <!-- 頁面標題 -->
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h2><i class="fas fa-list me-2"></i>公告管理</h2>
            <a href="${pageContext.request.contextPath}/web/add" class="btn btn-success">
                <i class="fas fa-plus me-1"></i>新增公告
            </a>
        </div>

        <!-- 搜索欄 -->
        <div class="card mb-4 search-form">
            <div class="card-body">
                <form method="GET" action="${pageContext.request.contextPath}/web/">
                    <div class="row align-items-end">
                        <div class="col-md-10">
                            <label class="form-label text-white">
                                <i class="fas fa-search me-1"></i>搜索公告
                            </label>
                            <input type="text"
                                   class="form-control"
                                   name="search"
                                   value="${param.search}"
                                   placeholder="輸入標題或發佈者進行搜索...">
                        </div>
                        <div class="col-md-2">
                            <button type="submit" class="btn btn-light w-100">
                                <i class="fas fa-search me-1"></i>搜索
                            </button>
                        </div>
                    </div>
                    <c:if test="${not empty param.search}">
                        <div class="mt-2">
                            <a href="${pageContext.request.contextPath}/web/" class="btn btn-sm btn-outline-light">
                                <i class="fas fa-times me-1"></i>清除搜索
                            </a>
                        </div>
                    </c:if>
                </form>
            </div>
        </div>

        <!-- 統計信息 -->
        <div class="row mb-4">
            <div class="col-md-3">
                <div class="card stats-card text-center">
                    <div class="card-body">
                        <i class="fas fa-file-alt fa-2x text-primary mb-2"></i>
                        <h4 class="text-primary">${totalCount}</h4>
                        <small class="text-muted">總公告數</small>
                    </div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="card stats-card text-center">
                    <div class="card-body">
                        <i class="fas fa-eye fa-2x text-info mb-2"></i>
                        <h4 class="text-info">${currentPage}</h4>
                        <small class="text-muted">當前頁</small>
                    </div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="card stats-card text-center">
                    <div class="card-body">
                        <i class="fas fa-copy fa-2x text-success mb-2"></i>
                        <h4 class="text-success">${totalPages}</h4>
                        <small class="text-muted">總頁數</small>
                    </div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="card stats-card text-center">
                    <div class="card-body">
                        <i class="fas fa-list-ul fa-2x text-warning mb-2"></i>
                        <h4 class="text-warning">${fn:length(announcements)}</h4>
                        <small class="text-muted">當前頁數量</small>
                    </div>
                </div>
            </div>
        </div>

        <!-- 成功/錯誤消息 -->
        <c:if test="${not empty message}">
            <div class="alert alert-success alert-dismissible fade show" role="alert">
                <i class="fas fa-check-circle me-2"></i>
                ${message}
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>
        <c:if test="${not empty error}">
            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                <i class="fas fa-exclamation-triangle me-2"></i>
                ${error}
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>

        <!-- 公告列表 -->
        <div class="card shadow">
            <div class="card-header d-flex justify-content-between align-items-center">
                <h5 class="mb-0">
                    <i class="fas fa-list me-2"></i>公告列表
                    <c:if test="${not empty param.search}">
                        <span class="badge bg-info ms-2">搜索結果</span>
                    </c:if>
                </h5>
                <span class="text-muted">共 ${totalCount} 條記錄</span>
            </div>
            <div class="card-body p-0">
                <c:choose>
                    <c:when test="${not empty announcements}">
                        <div class="table-responsive">
                            <table class="table table-hover mb-0">
                                <thead class="table-light">
                                    <tr>
                                        <th width="5%">#</th>
                                        <th width="35%">標題</th>
                                        <th width="15%">發佈者</th>
                                        <th width="12%">發佈日期</th>
                                        <th width="12%">截止日期</th>
                                        <th width="8%">狀態</th>
                                        <th width="13%">操作</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="announcement" items="${announcements}" varStatus="status">
                                        <tr>
                                            <td>${(currentPage - 1) * pageSize + status.index + 1}</td>
                                            <td>
                                                <a href="${pageContext.request.contextPath}/web/view/${announcement.id}"
                                                   class="announcement-title text-decoration-none">
                                                    <c:out value="${announcement.title}"/>
                                                </a>
                                                <c:if test="${not empty announcement.attachmentName}">
                                                    <i class="fas fa-paperclip text-muted ms-1"
                                                       title="有附件：${announcement.attachmentName}"></i>
                                                </c:if>
                                            </td>
                                            <td><c:out value="${announcement.publisher}"/></td>
                                            <td>
                                                <fmt:formatDate value="${announcement.publishDate}" pattern="yyyy-MM-dd"/>
                                            </td>
                                            <td>
                                                <fmt:formatDate value="${announcement.endDate}" pattern="yyyy-MM-dd"/>
                                            </td>
                                            <td>
                                                <jsp:useBean id="now" class="java.util.Date"/>
                                                <c:choose>
                                                    <c:when test="${announcement.endDate lt now}">
                                                        <span class="badge bg-danger status-badge">已過期</span>
                                                    </c:when>
                                                    <c:when test="${announcement.publishDate gt now}">
                                                        <span class="badge bg-warning status-badge">未發佈</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="badge bg-success status-badge">進行中</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td>
                                                <div class="btn-group btn-group-sm" role="group">
                                                    <a href="${pageContext.request.contextPath}/web/view/${announcement.id}"
                                                       class="btn btn-outline-info"
                                                       title="查看詳情">
                                                        <i class="fas fa-eye"></i>
                                                    </a>
                                                    <a href="${pageContext.request.contextPath}/web/edit/${announcement.id}"
                                                       class="btn btn-outline-primary"
                                                       title="編輯">
                                                        <i class="fas fa-edit"></i>
                                                    </a>
                                                    <button type="button"
                                                            class="btn btn-outline-danger"
                                                            title="刪除"
                                                            onclick="confirmDelete(${announcement.id}, '${announcement.title}')">
                                                        <i class="fas fa-trash"></i>
                                                    </button>
                                                </div>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="text-center py-5">
                            <i class="fas fa-inbox fa-3x text-muted mb-3"></i>
                            <h5 class="text-muted">
                                <c:choose>
                                    <c:when test="${not empty param.search}">
                                        沒有找到匹配的公告
                                    </c:when>
                                    <c:otherwise>
                                        暫無公告
                                    </c:otherwise>
                                </c:choose>
                            </h5>
                            <c:if test="${empty param.search}">
                                <a href="${pageContext.request.contextPath}/web/add" class="btn btn-primary mt-2">
                                    <i class="fas fa-plus me-1"></i>立即新增公告
                                </a>
                            </c:if>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>

        <!-- 分頁導航 -->
        <c:if test="${totalPages > 1}">
            <nav class="mt-4" aria-label="分頁導航">
                <ul class="pagination justify-content-center">
                    <!-- 上一頁 -->
                    <c:if test="${currentPage > 1}">
                        <li class="page-item">
                            <a class="page-link"
                               href="${pageContext.request.contextPath}/web/?page=${currentPage - 1}<c:if test='${not empty param.search}'>&search=${param.search}</c:if>">
                                <i class="fas fa-chevron-left"></i> 上一頁
                            </a>
                        </li>
                    </c:if>

                    <!-- 頁碼 -->
                    <c:set var="startPage" value="${currentPage - 2 < 1 ? 1 : currentPage - 2}"/>
                    <c:set var="endPage" value="${currentPage + 2 > totalPages ? totalPages : currentPage + 2}"/>

                    <c:if test="${startPage > 1}">
                        <li class="page-item">
                            <a class="page-link"
                               href="${pageContext.request.contextPath}/web/?page=1<c:if test='${not empty param.search}'>&search=${param.search}</c:if>">1</a>
                        </li>
                        <c:if test="${startPage > 2}">
                            <li class="page-item disabled">
                                <span class="page-link">...</span>
                            </li>
                        </c:if>
                    </c:if>

                    <c:forEach var="i" begin="${startPage}" end="${endPage}">
                        <li class="page-item ${i == currentPage ? 'active' : ''}">
                            <a class="page-link"
                               href="${pageContext.request.contextPath}/web/?page=${i}<c:if test='${not empty param.search}'>&search=${param.search}</c:if>">${i}</a>
                        </li>
                    </c:forEach>

                    <c:if test="${endPage < totalPages}">
                        <c:if test="${endPage < totalPages - 1}">
                            <li class="page-item disabled">
                                <span class="page-link">...</span>
                            </li>
                        </c:if>
                        <li class="page-item">
                            <a class="page-link"
                               href="${pageContext.request.contextPath}/web/?page=${totalPages}<c:if test='${not empty param.search}'>&search=${param.search}</c:if>">${totalPages}</a>
                        </li>
                    </c:if>

                    <!-- 下一頁 -->
                    <c:if test="${currentPage < totalPages}">
                        <li class="page-item">
                            <a class="page-link"
                               href="${pageContext.request.contextPath}/web/?page=${currentPage + 1}<c:if test='${not empty param.search}'>&search=${param.search}</c:if>">
                                下一頁 <i class="fas fa-chevron-right"></i>
                            </a>
                        </li>
                    </c:if>
                </ul>
            </nav>

            <!-- 分頁信息 -->
            <div class="text-center text-muted mt-2">
                <small>
                    顯示第 ${(currentPage - 1) * pageSize + 1} - ${(currentPage - 1) * pageSize + fn:length(announcements)} 條，
                    共 ${totalCount} 條記錄
                </small>
            </div>
        </c:if>
    </div>

    <!-- 頁腳 -->
    <footer class="bg-light text-center py-3 mt-5">
        <div class="container">
            <small class="text-muted">
                © 2025 公告管理系統 |
                <i class="fas fa-code"></i> 基於Spring MVC + Bootstrap構建
            </small>
        </div>
    </footer>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function confirmDelete(id, title) {
            if (confirm('確定要刪除公告「' + title + '」嗎？\n\n此操作不可恢復！')) {
                window.location.href = '${pageContext.request.contextPath}/web/delete/' + id;
            }
        }

        // 自動隱藏消息提示
        document.addEventListener('DOMContentLoaded', function() {
            const alerts = document.querySelectorAll('.alert');
            alerts.forEach(function(alert) {
                setTimeout(function() {
                    const bsAlert = new bootstrap.Alert(alert);
                    bsAlert.close();
                }, 5000); // 5秒後自動隱藏
            });
        });

        // 搜索框回車提交
        document.querySelector('input[name="search"]').addEventListener('keypress', function(e) {
            if (e.key === 'Enter') {
                this.form.submit();
            }
        });
    </script>
</body>
</html>