<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${empty announcement.id ? '新增公告' : '編輯公告'} - 公告管理系統</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/static/css/form.css" rel="stylesheet">
</head>
<body class="bg-light">
    <!-- 導航欄 -->
    <nav class="navbar navbar-expand-lg navbar-dark" style="background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);">
        <div class="container">
            <a class="navbar-brand" href="${pageContext.request.contextPath}/web/">
                <i class="fas fa-bullhorn me-2"></i>公告管理系統
            </a>
            <div class="navbar-nav ms-auto">
                <a class="nav-link" href="${pageContext.request.contextPath}/web/">
                    <i class="fas fa-list me-1"></i>公告列表
                </a>
            </div>
        </div>
    </nav>

    <div class="container mt-4">
        <div class="form-container">
            <!-- 頁面標題 -->
            <div class="d-flex align-items-center mb-4">
                <div class="me-3">
                    <div class="bg-primary rounded-circle d-flex align-items-center justify-content-center"
                         style="width: 60px; height: 60px;">
                        <i class="fas fa-${empty announcement.id ? 'plus' : 'edit'} text-white fa-2x"></i>
                    </div>
                </div>
                <div>
                    <h2 class="mb-1">${empty announcement.id ? '新增公告' : '編輯公告'}</h2>
                    <p class="text-muted mb-0">
                        ${empty announcement.id ? '建立新的公告信息' : '修改現有公告內容'}
                    </p>
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

            <!-- 表單卡片 -->
            <div class="card shadow-lg border-0">
                <div class="card-header ${empty announcement.id ? 'card-header-success' : 'card-header-custom'} py-3">
                    <h5 class="mb-0 d-flex align-items-center">
                        <i class="fas fa-file-text me-2"></i>
                        ${empty announcement.id ? '公告信息填寫' : '公告信息修改'}
                    </h5>
                </div>
                <div class="card-body p-4">
                    <!-- 表單 -->
                    <form method="POST"
                          action="${pageContext.request.contextPath}/web/<c:choose><c:when test='${empty announcement.id}'>add</c:when><c:otherwise>edit/${announcement.id}</c:otherwise></c:choose>"
                          enctype="multipart/form-data"
                          id="announcementForm">

                        <div class="row">
                            <!-- 左側欄位 -->
                            <div class="col-lg-8">
                                <!-- 標題 -->
                                <div class="mb-4">
                                    <label for="title" class="form-label fw-bold">
                                        <i class="fas fa-heading text-primary me-2"></i>
                                        公告標題 <span class="required">*</span>
                                    </label>
                                    <input type="text"
                                           class="form-control form-control-lg"
                                           id="title"
                                           name="title"
                                           value="${announcement.title}"
                                           required
                                           maxlength="200"
                                           placeholder="請輸入引人注目的公告標題">
                                    <div class="form-text">
                                        <i class="fas fa-info-circle text-muted me-1"></i>
                                        最多200個字符，建議簡潔明瞭
                                    </div>
                                </div>

                                <!-- 發佈者 -->
                                <div class="mb-4">
                                    <label for="publisher" class="form-label fw-bold">
                                        <i class="fas fa-user text-success me-2"></i>
                                        發佈者 <span class="required">*</span>
                                    </label>
                                    <input type="text"
                                           class="form-control"
                                           id="publisher"
                                           name="publisher"
                                           value="${announcement.publisher}"
                                           required
                                           maxlength="100"
                                           placeholder="請輸入發佈者姓名或部門">
                                </div>

                                <!-- 公告內容 - 富文本编辑器 -->
                                <div class="mb-4">
                                    <label class="form-label fw-bold">
                                        <i class="fas fa-edit text-info me-2"></i>
                                        公告內容
                                    </label>

                                    <div class="rich-editor-container">
                                        <!-- 工具栏 -->
                                        <div class="rich-editor-toolbar">
                                            <!-- 字体大小 -->
                                            <select class="toolbar-select" id="fontSize">
                                                <option value="12px">小字</option>
                                                <option value="14px" selected>正常</option>
                                                <option value="16px">中字</option>
                                                <option value="18px">大字</option>
                                                <option value="24px">特大</option>
                                            </select>

                                            <!-- 文字样式 -->
                                            <div class="toolbar-group">
                                                <button type="button" class="toolbar-btn" data-command="bold" title="粗體">
                                                    <i class="fas fa-bold"></i>
                                                </button>
                                                <button type="button" class="toolbar-btn" data-command="italic" title="斜體">
                                                    <i class="fas fa-italic"></i>
                                                </button>
                                                <button type="button" class="toolbar-btn" data-command="underline" title="底線">
                                                    <i class="fas fa-underline"></i>
                                                </button>
                                            </div>

                                            <!-- 颜色 -->
                                            <input type="color" class="color-picker" id="textColor" value="#000000" title="文字顏色">
                                            <input type="color" class="color-picker" id="bgColor" value="#ffffff" title="背景顏色">

                                            <!-- 对齐 -->
                                            <div class="toolbar-group">
                                                <button type="button" class="toolbar-btn" data-command="justifyLeft" title="左對齊">
                                                    <i class="fas fa-align-left"></i>
                                                </button>
                                                <button type="button" class="toolbar-btn" data-command="justifyCenter" title="居中">
                                                    <i class="fas fa-align-center"></i>
                                                </button>
                                                <button type="button" class="toolbar-btn" data-command="justifyRight" title="右對齊">
                                                    <i class="fas fa-align-right"></i>
                                                </button>
                                            </div>

                                            <!-- 列表 -->
                                            <div class="toolbar-group">
                                                <button type="button" class="toolbar-btn" data-command="insertUnorderedList" title="項目符號">
                                                    <i class="fas fa-list-ul"></i>
                                                </button>
                                                <button type="button" class="toolbar-btn" data-command="insertOrderedList" title="編號列表">
                                                    <i class="fas fa-list-ol"></i>
                                                </button>
                                            </div>

                                            <!-- 其他功能 -->
                                            <div class="toolbar-group">
                                                <button type="button" class="toolbar-btn" data-command="indent" title="增加縮進">
                                                    <i class="fas fa-indent"></i>
                                                </button>
                                                <button type="button" class="toolbar-btn" data-command="outdent" title="減少縮進">
                                                    <i class="fas fa-outdent"></i>
                                                </button>
                                            </div>

                                            <button type="button" class="toolbar-btn" onclick="clearFormat()" title="清除格式">
                                                <i class="fas fa-eraser"></i>
                                            </button>
                                        </div>

                                        <!-- 编辑区域 -->
                                        <div id="richEditor"
                                             class="rich-editor-content"
                                             contenteditable="true">${announcement.content}</div>
                                    </div>

                                    <!-- 隐藏的内容字段 -->
                                    <input type="hidden" name="content" id="contentInput">

                                    <div class="form-text mt-2">
                                        <i class="fas fa-lightbulb text-muted me-1"></i>
                                        支援文字格式化、顏色設定、對齊方式和列表功能
                                    </div>
                                </div>
                            </div>

                            <!-- 右側欄位 -->
                            <div class="col-lg-4">
                                <!-- 日期設定 -->
                                <div class="card bg-light border-0 mb-4">
                                    <div class="card-header bg-warning text-dark">
                                        <h6 class="mb-0">
                                            <i class="fas fa-calendar-alt me-2"></i>日期設定
                                        </h6>
                                    </div>
                                    <div class="card-body">
                                        <div class="mb-3">
                                            <label for="publishDate" class="form-label fw-bold">
                                                發佈日期 <span class="required">*</span>
                                            </label>
                                            <input type="date"
                                                   class="form-control"
                                                   id="publishDate"
                                                   name="publishDate"
                                                   value="<fmt:formatDate value='${announcement.publishDate}' pattern='yyyy-MM-dd'/>"
                                                   required>
                                        </div>
                                        <div class="mb-0">
                                            <label for="endDate" class="form-label fw-bold">
                                                截止日期 <span class="required">*</span>
                                            </label>
                                            <input type="date"
                                                   class="form-control"
                                                   id="endDate"
                                                   name="endDate"
                                                   value="<fmt:formatDate value='${announcement.endDate}' pattern='yyyy-MM-dd'/>"
                                                   required>
                                        </div>
                                    </div>
                                </div>

                                <!-- 格式化功能说明 -->
                                <div class="card bg-light border-0">
                                    <div class="card-header bg-info text-white">
                                        <h6 class="mb-0">
                                            <i class="fas fa-info-circle me-2"></i>格式化功能
                                        </h6>
                                    </div>
                                    <div class="card-body">
                                        <small>
                                            <i class="fas fa-check text-success me-1"></i> 字體大小調整<br>
                                            <i class="fas fa-check text-success me-1"></i> 粗體、斜體、底線<br>
                                            <i class="fas fa-check text-success me-1"></i> 文字和背景顏色<br>
                                            <i class="fas fa-check text-success me-1"></i> 左右居中對齊<br>
                                            <i class="fas fa-check text-success me-1"></i> 項目符號和編號<br>
                                            <i class="fas fa-check text-success me-1"></i> 縮進和格式清除
                                        </small>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- 現有附件區域 -->
                        <c:if test="${not empty attachments}">
                            <div class="mb-4">
                                <h5 class="mb-3">
                                    <i class="fas fa-paperclip text-primary me-2"></i>
                                    現有附件
                                    <span class="badge bg-primary rounded-pill">${attachments.size()}</span>
                                </h5>
                                <div class="row">
                                    <c:forEach var="attachment" items="${attachments}" varStatus="status">
                                        <div class="col-md-6 mb-3">
                                            <div class="attachment-item">
                                                <div class="d-flex align-items-center mb-2">
                                                    <i class="fas fa-file-alt text-primary me-3 fa-2x"></i>
                                                    <div class="flex-grow-1">
                                                        <h6 class="mb-1 text-truncate" title="${attachment.originalName}">
                                                            ${attachment.originalName}
                                                        </h6>
                                                        <small class="text-muted">
                                                            <i class="fas fa-weight me-1"></i>
                                                            ${Math.round(attachment.fileSize / 1024)} KB |
                                                            <i class="fas fa-clock me-1"></i>
                                                            <fmt:formatDate value="${attachment.uploadTime}" pattern="MM-dd HH:mm"/>
                                                        </small>
                                                    </div>
                                                </div>
                                                <div class="btn-group-custom d-flex">
                                                    <a href="${pageContext.request.contextPath}/web/attachment/download/${attachment.id}"
                                                       class="btn btn-outline-primary btn-sm flex-fill">
                                                        <i class="fas fa-download me-1"></i>下載
                                                    </a>
                                                    <a href="${pageContext.request.contextPath}/web/attachment/delete/${attachment.id}?announcementId=${announcement.id}"
                                                       class="btn btn-outline-danger btn-sm flex-fill"
                                                       onclick="return confirm('確定要刪除附件「${attachment.originalName}」嗎？此操作無法撤銷！')">
                                                        <i class="fas fa-trash me-1"></i>刪除
                                                    </a>
                                                </div>
                                            </div>
                                        </div>
                                    </c:forEach>
                                </div>
                            </div>
                        </c:if>

                        <!-- 檔案上傳區域 -->
                        <div class="mb-4">
                            <h5 class="mb-3">
                                <i class="fas fa-cloud-upload-alt text-success me-2"></i>
                                ${empty attachments ? '附件上傳' : '新增附件'}
                            </h5>

                            <div class="file-upload-area" id="fileUploadArea">
                                <div class="mb-3">
                                    <i class="fas fa-cloud-upload-alt fa-3x text-muted mb-3"></i>
                                    <h6>拖拽文件到此處或點擊選擇</h6>
                                    <p class="text-muted mb-3">支持多個文件同時上傳</p>
                                </div>

                                <input type="file"
                                       class="form-control"
                                       id="attachments"
                                       name="attachments"
                                       multiple
                                       accept=".pdf,.doc,.docx,.xls,.xlsx,.ppt,.pptx,.txt,.jpg,.jpeg,.png,.gif,.zip,.rar">

                                <div class="mt-3">
                                    <small class="text-muted">
                                        <i class="fas fa-info-circle me-1"></i>
                                        支持格式：PDF、Word、Excel、PowerPoint、圖片、壓縮包等 |
                                        單個文件最大 50MB
                                    </small>
                                </div>
                            </div>

                            <!-- 文件預覽區域 -->
                            <div id="filePreview" class="file-preview" style="display: none;">
                                <h6 class="mb-3">
                                    <i class="fas fa-list text-info me-2"></i>待上傳文件
                                </h6>
                                <div id="fileList"></div>
                            </div>
                        </div>

                        <!-- 操作按鈕 -->
                        <div class="row">
                            <div class="col-12">
                                <div class="d-flex justify-content-between align-items-center pt-4 border-top">
                                    <div class="btn-group-custom d-flex">
                                        <a href="${pageContext.request.contextPath}/web/"
                                           class="btn btn-outline-secondary">
                                            <i class="fas fa-arrow-left me-2"></i>返回列表
                                        </a>
                                    </div>

                                    <div class="btn-group-custom d-flex">
                                        <button type="reset" class="btn btn-outline-secondary" id="resetBtn">
                                            <i class="fas fa-undo me-2"></i>重置表單
                                        </button>
                                        <button type="submit" class="btn btn-primary btn-submit" id="submitBtn">
                                            <i class="fas fa-save me-2"></i>
                                            ${empty announcement.id ? '創建公告' : '更新公告'}
                                        </button>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // 设置全局变量供JS文件使用
        var contextPath = '${pageContext.request.contextPath}';
        var isNewAnnouncement = ${empty announcement.id};
    </script>
    <script src="${pageContext.request.contextPath}/static/js/form.js"></script>
</body>
</html>