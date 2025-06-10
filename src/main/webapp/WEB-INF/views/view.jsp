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
    <link href="${pageContext.request.contextPath}/static/css/view.css" rel="stylesheet">
</head>
<body class="bg-light">
    <!-- 導航欄 -->
    <nav class="navbar navbar-expand-lg navbar-dark" style="background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);" class="no-print">
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
        <!-- 成功/錯誤消息 -->
        <c:if test="${not empty message}">
            <div class="alert alert-success alert-dismissible fade show shadow-sm no-print" role="alert">
                <i class="fas fa-check-circle me-2"></i>
                <strong>成功！</strong> ${message}
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>

        <c:if test="${not empty error}">
            <div class="alert alert-danger alert-dismissible fade show shadow-sm no-print" role="alert">
                <i class="fas fa-exclamation-triangle me-2"></i>
                <strong>錯誤！</strong> ${error}
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>

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
                    <a href="${pageContext.request.contextPath}/web/" class="btn btn-outline-secondary btn-action">
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
            <div class="card shadow-lg border-0">
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
                                <span class="badge bg-warning text-dark status-badge">
                                    <i class="fas fa-hourglass-start me-1"></i>未發佈
                                </span>
                            </c:when>
                            <c:otherwise>
                                <span class="badge bg-success status-badge">
                                    <i class="fas fa-check-circle me-1"></i>進行中
                                </span>
                            </c:otherwise>
                        </c:choose>

                        <!-- 附件标识 -->
                        <c:if test="${not empty attachments and fn:length(attachments) > 0}">
                            <span class="badge bg-info status-badge ms-2">
                                <i class="fas fa-paperclip me-1"></i>
                                ${fn:length(attachments)} 個附件
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
                                    ${announcement.content}
                                </div>
                            </c:when>
                            <c:otherwise>
                                <div class="text-muted fst-italic text-center py-4">
                                    <i class="fas fa-file-alt fa-2x mb-2 text-muted"></i>
                                    <p>暫無詳細內容</p>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>

                    <!-- 多附件下載區域 -->
                    <c:if test="${not empty attachments and fn:length(attachments) > 0}">
                        <div class="mb-4">
                            <h5 class="mb-3">
                                <i class="fas fa-paperclip text-primary me-2"></i>
                                附件下載
                                <span class="badge bg-primary">${fn:length(attachments)}</span>
                            </h5>
                            <div class="row">
                                <c:forEach var="attachment" items="${attachments}" varStatus="status">
                                    <div class="col-md-6 col-lg-4 mb-3">
                                        <div class="attachment-item h-100">
                                            <div class="d-flex align-items-start">
                                                <div class="attachment-icon me-3 flex-shrink-0">
                                                    <c:set var="fileExt" value="${fn:toLowerCase(fn:substringAfter(attachment.originalName, '.'))}" />
                                                    <c:choose>
                                                        <c:when test="${fileExt eq 'pdf'}">
                                                            <i class="fas fa-file-pdf"></i>
                                                        </c:when>
                                                        <c:when test="${fileExt eq 'doc' or fileExt eq 'docx'}">
                                                            <i class="fas fa-file-word"></i>
                                                        </c:when>
                                                        <c:when test="${fileExt eq 'xls' or fileExt eq 'xlsx'}">
                                                            <i class="fas fa-file-excel"></i>
                                                        </c:when>
                                                        <c:when test="${fileExt eq 'ppt' or fileExt eq 'pptx'}">
                                                            <i class="fas fa-file-powerpoint"></i>
                                                        </c:when>
                                                        <c:when test="${fileExt eq 'jpg' or fileExt eq 'jpeg' or fileExt eq 'png' or fileExt eq 'gif'}">
                                                            <i class="fas fa-file-image"></i>
                                                        </c:when>
                                                        <c:when test="${fileExt eq 'zip' or fileExt eq 'rar'}">
                                                            <i class="fas fa-file-archive"></i>
                                                        </c:when>
                                                        <c:when test="${fileExt eq 'txt'}">
                                                            <i class="fas fa-file-alt"></i>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <i class="fas fa-file"></i>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </div>
                                                <div class="flex-grow-1">
                                                    <h6 class="mb-2 text-truncate" title="${attachment.originalName}">
                                                        <c:out value="${attachment.originalName}"/>
                                                    </h6>
                                                    <p class="text-muted small mb-2">
                                                        <i class="fas fa-weight me-1"></i>
                                                        <c:choose>
                                                            <c:when test="${attachment.fileSize > 1024*1024}">
                                                                ${Math.round(attachment.fileSize / 1024 / 1024 * 100) / 100} MB
                                                            </c:when>
                                                            <c:otherwise>
                                                                ${Math.round(attachment.fileSize / 1024)} KB
                                                            </c:otherwise>
                                                        </c:choose>
                                                        <br>
                                                        <i class="fas fa-clock me-1"></i>
                                                        <fmt:formatDate value="${attachment.uploadTime}" pattern="MM-dd HH:mm"/>
                                                    </p>
                                                    <div class="d-grid">
                                                        <a href="${pageContext.request.contextPath}/web/attachment/download/${attachment.id}"
                                                           class="btn btn-primary btn-sm no-print">
                                                            <i class="fas fa-download me-1"></i>下載
                                                        </a>
                                                        <span class="print-hidden text-muted text-center">
                                                            附件：<c:out value="${attachment.originalName}"/>
                                                        </span>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </c:forEach>
                            </div>

                            <!-- 批量下載操作 -->
                            <c:if test="${fn:length(attachments) > 1}">
                                <div class="mt-3 text-center no-print">
                                    <p class="text-muted mb-2">
                                        <i class="fas fa-info-circle me-1"></i>
                                        共 ${fn:length(attachments)} 個附件，可逐個下載
                                    </p>
                                </div>
                            </c:if>
                        </div>
                    </c:if>

                    <!-- 時間線信息 -->
                    <div class="mb-4">
                        <h5 class="mb-3">
                            <i class="fas fa-history text-primary me-2"></i>時間線
                        </h5>
                        <div class="row">
                            <div class="col-md-4 text-center mb-3">
                                <div class="card timeline-card border-success">
                                    <div class="card-body">
                                        <i class="fas fa-plus-circle fa-2x text-success mb-2"></i>
                                        <h6>創建時間</h6>
                                        <small class="text-muted">
                                            <fmt:formatDate value="${announcement.createTime}" pattern="yyyy-MM-dd HH:mm"/>
                                        </small>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-4 text-center mb-3">
                                <div class="card timeline-card border-primary">
                                    <div class="card-body">
                                        <i class="fas fa-calendar-check fa-2x text-primary mb-2"></i>
                                        <h6>發佈日期</h6>
                                        <small class="text-muted">
                                            <fmt:formatDate value="${announcement.publishDate}" pattern="yyyy-MM-dd"/>
                                        </small>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-4 text-center mb-3">
                                <div class="card timeline-card border-warning">
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
                                <c:if test="${not empty attachments and fn:length(attachments) > 0}">
                                    | 附件：${fn:length(attachments)} 個
                                </c:if>
                            </small>
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
                <i class="fas fa-code"></i> 基於Spring MVC + Bootstrap構建 |
                支援多附件管理
            </small>
        </div>
    </footer>

    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // 设置全局变量供JS文件使用
        var contextPath = '${pageContext.request.contextPath}';
        var announcementId = '${announcement.id}';
        var announcementTitle = '${fn:escapeXml(announcement.title)}';
    </script>
    <script src="${pageContext.request.contextPath}/static/js/view.js"></script>
</body>
</html>