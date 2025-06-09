<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><c:out value="${announcement.title}"/> - 公告管理系統</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        .announcement-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
        }
        .info-item {
            border-bottom: 1px solid #eee;
            padding: 0.75rem 0;
        }
        .info-item:last-child {
            border-bottom: none;
        }
        .info-label {
            font-weight: 600;
            color: #495057;
            width: 120px;
            display: inline-block;
        }
        .content-area {
            background-color: #f8f9fa;
            border-radius: 0.375rem;
            padding: 1.5rem;
            line-height: 1.8;
            white-space: pre-wrap;
        }
        .status-badge {
            font-size: 0.9em;
            padding: 0.5em 1em;
        }
        .attachment-card {
            border: 2px dashed #dee2e6;
            transition: all 0.3s ease;
        }
        .attachment-card:hover {
            border-color: #0d6efd;
            background-color: rgba(13, 110, 253, 0.05);
        }
        .btn-action {
            margin: 0 0.25rem;
        }
        .print-hidden {
            display: none;
        }
        @media print {
            .no-print {
                display: none !important;
            }
            .print-hidden {
                display: block !important;
            }
            .card {
                border: none !important;
                box-shadow: none !important;
            }
        }
    </style>
</head>
<body class="bg-light">
    <!-- 導航欄 -->
    <nav class="navbar navbar-expand-lg navbar-dark bg-primary shadow no-print">
        <div class="container">
            <a class="navbar-brand" href="${pageContext.request.contextPath}/web/">
                <i class="fas fa-bullhorn me-2"></i>公告管理系統
            </a>
            <div class="navbar-nav ms-auto">
                <a class="nav-link" href="${pageContext.request.contextPath}/web/">
                    <i class="fas fa-list me-1"></i>公告列表
                </a>
                <a class="nav-link" href="${pageContext.request.contextPath}/web/add">
                    <i class="fas fa-plus me-1"></i>新增公告
                </a>
            </div>
        </div>
    </nav>

    <div class="container mt-4">
        <!-- 錯誤處理 -->
        <c:if test="${empty announcement}">
            <div class="alert alert-danger text-center">
                <i class="fas fa-exclamation-triangle fa-2x mb-3"></i>
                <h4>公告不存在</h4>
                <p>您查看的公告可能已被刪除或不存在</p>
                <a href="${pageContext.request.contextPath}/web/" class="btn btn-primary">
                    <i class="fas fa-arrow-left me-1"></i>返回列表
                </a>
            </div>
        </c:if>

        <!-- 公告詳情 -->
        <c:if test="${not empty announcement}">
            <!-- 操作按鈕區域 -->
            <div class="d-flex justify-content-between align-items-center mb-4 no-print">
                <div>
                    <a href="${pageContext.request.contextPath}/web/" class="btn btn-secondary btn-action">
                        <i class="fas fa-arrow-left me-1"></i>返回列表
                    </a>
                </div>
                <div>
                    <button onclick="window.print()" class="btn btn-info btn-action">
                        <i class="fas fa-print me-1"></i>打印
                    </button>
                    <a href="${pageContext.request.contextPath}/web/edit/${announcement.id}"
                       class="btn btn-primary btn-action">
                        <i class="fas fa-edit me-1"></i>編輯
                    </a>
                    <button onclick="confirmDelete()" class="btn btn-danger btn-action">
                        <i class="fas fa-trash me-1"></i>刪除
                    </button>
                </div>
            </div>

            <!-- 主要內容卡片 -->
            <div class="card shadow-lg">
                <!-- 標題區域 -->
                <div class="card-header announcement-header">
                    <h2 class="mb-2">
                        <i class="fas fa-bullhorn me-2"></i>
                        <c:out value="${announcement.title}"/>
                    </h2>

                    <!-- 狀態標識 -->
                    <div class="mt-3">
                        <jsp:useBean id="now" class="java.util.Date"/>
                        <c:choose>
                            <c:when test="${announcement.endDate lt now}">
                                <span class="badge bg-danger status-badge">
                                    <i class="fas fa-clock me-1"></i>已過期
                                </span>
                            </c:when>
                            <c:when test="${announcement.publishDate gt now}">
                                <span class="badge bg-warning status-badge">
                                    <i class="fas fa-hourglass-start me-1"></i>未發佈
                                </span>
                            </c:when>
                            <c:otherwise>
                                <span class="badge bg-success status-badge">
                                    <i class="fas fa-check-circle me-1"></i>進行中
                                </span>
                            </c:otherwise>
                        </c:choose>

                        <c:if test="${not empty announcement.attachmentName}">
                            <span class="badge bg-info status-badge ms-2">
                                <i class="fas fa-paperclip me-1"></i>有附件
                            </span>
                        </c:if>
                    </div>
                </div>

                <div class="card-body">
                    <!-- 基本信息 -->
                    <div class="row mb-4">
                        <div class="col-md-6">
                            <div class="info-item">
                                <span class="info-label">
                                    <i class="fas fa-user text-primary me-1"></i>發佈者：
                                </span>
                                <c:out value="${announcement.publisher}"/>
                            </div>
                            <div class="info-item">
                                <span class="info-label">
                                    <i class="fas fa-calendar text-success me-1"></i>發佈日期：
                                </span>
                                <fmt:formatDate value="${announcement.publishDate}" pattern="yyyy年MM月dd日"/>
                            </div>
                            <div class="info-item">
                                <span class="info-label">
                                    <i class="fas fa-calendar-times text-warning me-1"></i>截止日期：
                                </span>
                                <fmt:formatDate value="${announcement.endDate}" pattern="yyyy年MM月dd日"/>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="info-item">
                                <span class="info-label">
                                    <i class="fas fa-clock text-info me-1"></i>創建時間：
                                </span>
                                <fmt:formatDate value="${announcement.createTime}" pattern="yyyy-MM-dd HH:mm:ss"/>
                            </div>
                            <c:if test="${announcement.updateTime ne announcement.createTime}">
                                <div class="info-item">
                                    <span class="info-label">
                                        <i class="fas fa-edit text-secondary me-1"></i>更新時間：
                                    </span>
                                    <fmt:formatDate value="${announcement.updateTime}" pattern="yyyy-MM-dd HH:mm:ss"/>
                                </div>
                            </c:if>
                            <div class="info-item">
                                <span class="info-label">
                                    <i class="fas fa-hashtag text-muted me-1"></i>公告編號：
                                </span>
                                #${announcement.id}
                            </div>
                        </div>
                    </div>

                    <!-- 公告內容 -->
                    <div class="mb-4">
                        <h5 class="mb-3">
                            <i class="fas fa-file-text text-primary me-2"></i>公告內容
                        </h5>
                        <c:choose>
                            <c:when test="${not empty announcement.content}">
                                <div class="content-area">
                                    <c:out value="${announcement.content}" escapeXml="false"/>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <div class="text-muted fst-italic text-center py-4">
                                    <i class="fas fa-file-alt fa-2x mb-2"></i>
                                    <p>暫無詳細內容</p>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>

                    <!-- 附件下載 -->
                    <c:if test="${not empty announcement.attachmentName}">
                        <div class="mb-4">
                            <h5 class="mb-3">
                                <i class="fas fa-paperclip text-primary me-2"></i>附件下載
                            </h5>
                            <div class="attachment-card card p-3">
                                <div class="d-flex align-items-center">
                                    <div class="me-3">
                                        <i class="fas fa-file-download fa-2x text-primary"></i>
                                    </div>
                                    <div class="flex-grow-1">
                                        <h6 class="mb-1">
                                            <c:out value="${announcement.attachmentName}"/>
                                        </h6>
                                        <small class="text-muted">點擊下載附件文件</small>
                                    </div>
                                    <div>
                                        <a href="${pageContext.request.contextPath}/web/download/${announcement.id}"
                                           class="btn btn-primary no-print">
                                            <i class="fas fa-download me-1"></i>下載
                                        </a>
                                        <span class="print-hidden text-muted">
                                            附件：<c:out value="${announcement.attachmentName}"/>
                                        </span>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </c:if>

                    <!-- 時間線信息 -->
                    <div class="mb-4">
                        <h5 class="mb-3">
                            <i class="fas fa-history text-primary me-2"></i>時間線
                        </h5>
                        <div class="row">
                            <div class="col-md-4 text-center">
                                <div class="card border-success">
                                    <div class="card-body">
                                        <i class="fas fa-plus-circle fa-2x text-success mb-2"></i>
                                        <h6>創建時間</h6>
                                        <small class="text-muted">
                                            <fmt:formatDate value="${announcement.createTime}" pattern="yyyy-MM-dd HH:mm"/>
                                        </small>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-4 text-center">
                                <div class="card border-primary">
                                    <div class="card-body">
                                        <i class="fas fa-calendar-check fa-2x text-primary mb-2"></i>
                                        <h6>發佈日期</h6>
                                        <small class="text-muted">
                                            <fmt:formatDate value="${announcement.publishDate}" pattern="yyyy-MM-dd"/>
                                        </small>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-4 text-center">
                                <div class="card border-warning">
                                    <div class="card-body">
                                        <i class="fas fa-flag-checkered fa-2x text-warning mb-2"></i>
                                        <h6>截止日期</h6>
                                        <small class="text-muted">
                                            <fmt:formatDate value="${announcement.endDate}" pattern="yyyy-MM-dd"/>
                                        </small>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- 頁腳操作 -->
                <div class="card-footer bg-light no-print">
                    <div class="d-flex justify-content-between align-items-center">
                        <div>
                            <small class="text-muted">
                                <i class="fas fa-info-circle me-1"></i>
                                公告ID：${announcement.id} |
                                創建於：<fmt:formatDate value="${announcement.createTime}" pattern="yyyy-MM-dd HH:mm"/>
                            </small>
                        </div>
                        <div>
                            <a href="${pageContext.request.contextPath}/web/" class="btn btn-sm btn-outline-secondary me-2">
                                <i class="fas fa-list me-1"></i>返回列表
                            </a>
                            <a href="${pageContext.request.contextPath}/web/edit/${announcement.id}"
                               class="btn btn-sm btn-outline-primary me-2">
                                <i class="fas fa-edit me-1"></i>編輯
                            </a>
                            <button onclick="confirmDelete()" class="btn btn-sm btn-outline-danger">
                                <i class="fas fa-trash me-1"></i>刪除
                            </button>
                        </div>
                    </div>
                </div>
            </div>

            <!-- 相關操作建議 -->
            <div class="row mt-4 no-print">
                <div class="col-md-4">
                    <div class="card text-center">
                        <div class="card-body">
                            <i class="fas fa-edit fa-2x text-primary mb-2"></i>
                            <h6>編輯公告</h6>
                            <p class="text-muted small">修改公告內容或附件</p>
                            <a href="${pageContext.request.contextPath}/web/edit/${announcement.id}"
                               class="btn btn-sm btn-primary">立即編輯</a>
                        </div>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="card text-center">
                        <div class="card-body">
                            <i class="fas fa-plus fa-2x text-success mb-2"></i>
                            <h6>新增公告</h6>
                            <p class="text-muted small">創建一個新的公告</p>
                            <a href="${pageContext.request.contextPath}/web/add"
                               class="btn btn-sm btn-success">立即新增</a>
                        </div>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="card text-center">
                        <div class="card-body">
                            <i class="fas fa-list fa-2x text-info mb-2"></i>
                            <h6>瀏覽列表</h6>
                            <p class="text-muted small">查看所有公告列表</p>
                            <a href="${pageContext.request.contextPath}/web/"
                               class="btn btn-sm btn-info">瀏覽列表</a>
                        </div>
                    </div>
                </div>
            </div>
        </c:if>
    </div>

    <!-- 頁腳 -->
    <footer class="bg-light text-center py-3 mt-5 no-print">
        <div class="container">
            <small class="text-muted">
                © 2025 公告管理系統 |
                <i class="fas fa-code"></i> 基於Spring MVC + Bootstrap構建
            </small>
        </div>
    </footer>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function confirmDelete() {
            if (confirm('確定要刪除這個公告嗎？\n\n標題：${announcement.title}\n\n此操作不可恢復！')) {
                window.location.href = '${pageContext.request.contextPath}/web/delete/${announcement.id}';
            }
        }

        // 自動滾動到內容區域（如果從列表頁面跳轉）
        document.addEventListener('DOMContentLoaded', function() {
            if (document.referrer.includes('/web/')) {
                // 從列表頁跳轉來的，不滾動
            } else {
                // 直接訪問，滾動到內容區域
                setTimeout(function() {
                    document.querySelector('.card-body').scrollIntoView({
                        behavior: 'smooth',
                        block: 'start'
                    });
                }, 300);
            }
        });

        // 鍵盤快捷鍵
        document.addEventListener('keydown', function(e) {
            // Ctrl+P 打印
            if (e.ctrlKey && e.key === 'p') {
                e.preventDefault();
                window.print();
            }
            // Ctrl+E 編輯
            if (e.ctrlKey && e.key === 'e') {
                e.preventDefault();
                window.location.href = '${pageContext.request.contextPath}/web/edit/${announcement.id}';
            }
            // ESC 返回列表
            if (e.key === 'Escape') {
                window.location.href = '${pageContext.request.contextPath}/web/';
            }
        });

        // 打印樣式優化
        window.addEventListener('beforeprint', function() {
            document.title = '${announcement.title} - 公告詳情';
        });

        window.addEventListener('afterprint', function() {
            document.title = '${announcement.title} - 公告管理系統';
        });
    </script>
</body>
</html>