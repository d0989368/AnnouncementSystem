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
    <link href="${pageContext.request.contextPath}/static/css/list.css" rel="stylesheet">
</head>
<body class="bg-light">
    <!-- 導航欄 -->
    <nav class="navbar navbar-expand-lg navbar-dark navbar-custom shadow">
        <div class="container">
            <a class="navbar-brand" href="${pageContext.request.contextPath}/web/">
                <i class="fas fa-bullhorn me-2"></i>公告管理系統
            </a>
            <div class="navbar-nav ms-auto">
                <a class="nav-link" href="${pageContext.request.contextPath}/web/add">
                    <i class="fas fa-plus me-1"></i>新增公告
                </a>
            </div>
        </div>
    </nav>

    <div class="container">
        <!-- 搜索區域 -->
        <div class="card search-card mb-4">
            <div class="card-body p-4">
                <form method="GET" action="${pageContext.request.contextPath}/web/">
                    <div class="row align-items-end">
                        <div class="col-md-10">
                            <label class="form-label text-dark fw-bold mb-3">
                                <i class="fas fa-search me-2 text-primary"></i>搜索公告
                            </label>
                            <input type="text"
                                   class="form-control search-input"
                                   name="search"
                                   value="${param.search}"
                                   placeholder="輸入標題或發佈者進行搜索...">
                        </div>
                        <div class="col-md-2">
                            <button type="submit" class="btn btn-light w-100 fw-bold">
                                <i class="fas fa-search me-1"></i>搜索
                            </button>
                        </div>
                    </div>
                    <c:if test="${not empty param.search}">
                        <div class="mt-3">
                            <a href="${pageContext.request.contextPath}/web/" class="btn btn-outline-secondary btn-sm">
                                <i class="fas fa-times me-1"></i>清除搜索條件
                            </a>
                        </div>
                    </c:if>
                </form>
            </div>
        </div>

        <!-- 統計卡片 -->
        <div class="row mb-4">
            <div class="col-lg-3 col-md-6 mb-3">
                <div class="card stats-card text-center h-100">
                    <div class="card-body">
                        <div class="d-flex align-items-center justify-content-center mb-3">
                            <div class="rounded-circle bg-primary bg-opacity-10 p-3">
                                <i class="fas fa-file-alt fa-2x text-primary"></i>
                            </div>
                        </div>
                        <h3 class="text-primary mb-1">${totalCount}</h3>
                        <p class="text-muted mb-0">總公告數</p>
                    </div>
                </div>
            </div>
            <div class="col-lg-3 col-md-6 mb-3">
                <div class="card stats-card text-center h-100">
                    <div class="card-body">
                        <div class="d-flex align-items-center justify-content-center mb-3">
                            <div class="rounded-circle bg-info bg-opacity-10 p-3">
                                <i class="fas fa-eye fa-2x text-info"></i>
                            </div>
                        </div>
                        <h3 class="text-info mb-1">${currentPage}</h3>
                        <p class="text-muted mb-0">當前頁</p>
                    </div>
                </div>
            </div>
            <div class="col-lg-3 col-md-6 mb-3">
                <div class="card stats-card text-center h-100">
                    <div class="card-body">
                        <div class="d-flex align-items-center justify-content-center mb-3">
                            <div class="rounded-circle bg-success bg-opacity-10 p-3">
                                <i class="fas fa-copy fa-2x text-success"></i>
                            </div>
                        </div>
                        <h3 class="text-success mb-1">${totalPages}</h3>
                        <p class="text-muted mb-0">總頁數</p>
                    </div>
                </div>
            </div>
            <div class="col-lg-3 col-md-6 mb-3">
                <div class="card stats-card text-center h-100">
                    <div class="card-body">
                        <div class="d-flex align-items-center justify-content-center mb-3">
                            <div class="rounded-circle bg-warning bg-opacity-10 p-3">
                                <i class="fas fa-list-ul fa-2x text-warning"></i>
                            </div>
                        </div>
                        <h3 class="text-warning mb-1">${fn:length(announcements)}</h3>
                        <p class="text-muted mb-0">本頁數量</p>
                    </div>
                </div>
            </div>
        </div>

        <!-- 成功/錯誤消息 -->
        <c:if test="${not empty message}">
            <div class="alert alert-success alert-dismissible fade show shadow-sm" role="alert">
                <i class="fas fa-check-circle me-2"></i>
                <strong>成功！</strong> ${message}
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>
        <c:if test="${not empty error}">
            <div class="alert alert-danger alert-dismissible fade show shadow-sm" role="alert">
                <i class="fas fa-exclamation-triangle me-2"></i>
                <strong>錯誤！</strong> ${error}
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>

        <!-- 主要內容卡片 -->
        <div class="card main-card">
            <div class="card-header card-header-custom d-flex justify-content-between align-items-center py-3">
                <h5 class="mb-0">
                    <i class="fas fa-table me-2"></i>公告列表
                    <c:if test="${not empty param.search}">
                        <span class="badge bg-light text-dark ms-2">搜索結果</span>
                    </c:if>
                </h5>
                <span class="badge bg-light text-dark">共 ${totalCount} 條記錄</span>
            </div>
            <div class="card-body p-0">
                <c:choose>
                    <c:when test="${not empty announcements}">
                        <div class="table-responsive">
                            <table class="table table-hover mb-0">
                                <thead class="bg-light">
                                    <tr>
                                        <th width="5%" class="text-center">#</th>
                                        <th width="35%">標題</th>
                                        <th width="15%">發佈者</th>
                                        <th width="12%">發佈日期</th>
                                        <th width="12%">截止日期</th>
                                        <th width="8%" class="text-center">狀態</th>
                                        <th width="13%" class="text-center">操作</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="announcement" items="${announcements}" varStatus="status">
                                        <tr>
                                            <td class="text-center text-muted fw-bold">
                                                ${(currentPage - 1) * pageSize + status.index + 1}
                                            </td>
                                            <td>
                                                <div class="d-flex align-items-center">
                                                    <div>
                                                        <a href="${pageContext.request.contextPath}/web/view/${announcement.id}"
                                                           class="announcement-title text-decoration-none d-block">
                                                            <c:out value="${announcement.title}"/>
                                                        </a>
                                                        <c:if test="${not empty announcement.content}">
                                                            <small class="text-muted">
                                                                ${fn:substring(fn:replace(announcement.content, '<[^>]*>', ''), 0, 50)}
                                                                <c:if test="${fn:length(announcement.content) > 50}">...</c:if>
                                                            </small>
                                                        </c:if>
                                                    </div>
                                                    <!-- 检查是否有附件 -->
                                                    <c:if test="${not empty announcement.attachmentName}">
                                                        <i class="fas fa-paperclip attachment-indicator ms-2"
                                                           title="有附件：${announcement.attachmentName}"></i>
                                                    </c:if>
                                                </div>
                                            </td>
                                            <td>
                                                <div class="d-flex align-items-center">
                                                    <i class="fas fa-user text-muted me-2"></i>
                                                    <c:out value="${announcement.publisher}"/>
                                                </div>
                                            </td>
                                            <td>
                                                <small class="text-muted">
                                                    <i class="fas fa-calendar me-1"></i>
                                                    <fmt:formatDate value="${announcement.publishDate}" pattern="yyyy-MM-dd"/>
                                                </small>
                                            </td>
                                            <td>
                                                <small class="text-muted">
                                                    <i class="fas fa-calendar-times me-1"></i>
                                                    <fmt:formatDate value="${announcement.endDate}" pattern="yyyy-MM-dd"/>
                                                </small>
                                            </td>
                                            <td class="text-center">
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
                                            </td>
                                            <td>
                                                <div class="d-flex justify-content-center btn-group-custom">
                                                    <a href="${pageContext.request.contextPath}/web/view/${announcement.id}"
                                                       class="btn btn-outline-info btn-sm btn-action"
                                                       title="查看詳情">
                                                        <i class="fas fa-eye"></i>
                                                    </a>
                                                    <a href="${pageContext.request.contextPath}/web/edit/${announcement.id}"
                                                       class="btn btn-outline-primary btn-sm btn-action"
                                                       title="編輯">
                                                        <i class="fas fa-edit"></i>
                                                    </a>
                                                    <button type="button"
                                                            class="btn btn-outline-danger btn-sm btn-action"
                                                            title="刪除"
                                                            onclick="confirmDelete(${announcement.id}, '${fn:escapeXml(announcement.title)}')">
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
                        <div class="empty-state">
                            <i class="fas fa-inbox fa-4x"></i>
                            <h4 class="text-muted mb-3">
                                <c:choose>
                                    <c:when test="${not empty param.search}">
                                        沒有找到匹配的公告
                                    </c:when>
                                    <c:otherwise>
                                        暫無公告數據
                                    </c:otherwise>
                                </c:choose>
                            </h4>
                            <p class="text-muted mb-4">
                                <c:choose>
                                    <c:when test="${not empty param.search}">
                                        請嘗試使用其他關鍵詞進行搜索，或檢查搜索條件是否正確
                                    </c:when>
                                    <c:otherwise>
                                        系統中還沒有任何公告，立即創建第一個公告吧！
                                    </c:otherwise>
                                </c:choose>
                            </p>
                            <c:choose>
                                <c:when test="${not empty param.search}">
                                    <a href="${pageContext.request.contextPath}/web/" class="btn btn-primary">
                                        <i class="fas fa-list me-1"></i>查看所有公告
                                    </a>
                                </c:when>
                                <c:otherwise>
                                    <a href="${pageContext.request.contextPath}/web/add" class="btn btn-primary btn-lg">
                                        <i class="fas fa-plus me-2"></i>立即新增公告
                                    </a>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>

        <!-- 分頁導航 -->
        <c:if test="${totalPages > 1}">
            <nav class="mt-4" aria-label="分頁導航">
                <ul class="pagination pagination-custom justify-content-center">
                    <!-- 上一頁 -->
                    <c:if test="${currentPage > 1}">
                        <li class="page-item">
                            <a class="page-link"
                               href="${pageContext.request.contextPath}/web/?page=${currentPage - 1}<c:if test='${not empty param.search}'>&search=${param.search}</c:if>">
                                <i class="fas fa-chevron-left me-1"></i>上一頁
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
                                下一頁<i class="fas fa-chevron-right ms-1"></i>
                            </a>
                        </li>
                    </c:if>
                </ul>
            </nav>

            <!-- 分頁信息 -->
            <div class="text-center mt-3">
                <small class="text-muted">
                    <i class="fas fa-info-circle me-1"></i>
                    顯示第 <strong>${(currentPage - 1) * pageSize + 1}</strong> - <strong>${(currentPage - 1) * pageSize + fn:length(announcements)}</strong> 條，
                    共 <strong>${totalCount}</strong> 條記錄
                </small>
            </div>
        </c:if>
    </div>

    <!-- 頁腳 -->
    <footer class="footer-custom text-center py-4 mt-5">
        <div class="container">
            <div class="row">
                <div class="col-md-12">
                    <small class="text-muted">
                        © 2025 公告管理系統 |
                        <i class="fas fa-code text-primary"></i> 基於Spring MVC + Bootstrap構建 |
                        支援多附件與富文本編輯
                    </small>
                </div>
            </div>
        </div>
    </footer>

    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // 设置全局变量供JS文件使用
        var contextPath = '${pageContext.request.contextPath}';
    </script>
    <script src="${pageContext.request.contextPath}/static/js/list.js"></script>
</body>
</html>