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

    <style>
        .form-container {
            max-width: 1000px;
            margin: 0 auto;
        }
        .required {
            color: #dc3545;
        }
        .attachment-item {
            border: 1px solid #dee2e6;
            border-radius: 0.5rem;
            padding: 1rem;
            margin-bottom: 0.75rem;
            background: linear-gradient(145deg, #f8f9fa, #e9ecef);
            transition: all 0.3s ease;
        }
        .attachment-item:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 8px rgba(0,0,0,0.1);
        }
        .file-upload-area {
            border: 2px dashed #6c757d;
            border-radius: 0.75rem;
            padding: 2.5rem;
            text-align: center;
            transition: all 0.3s ease;
            background: linear-gradient(145deg, #ffffff, #f8f9fa);
        }
        .file-upload-area:hover {
            border-color: #0d6efd;
            background: linear-gradient(145deg, #f0f8ff, #e6f3ff);
        }
        .file-upload-area.dragover {
            border-color: #198754;
            background: linear-gradient(145deg, #f0fff4, #e6ffed);
        }
        .file-preview {
            background: #f8f9fa;
            border-radius: 0.5rem;
            padding: 1rem;
            margin-top: 1rem;
        }
        .file-item {
            background: white;
            border: 1px solid #dee2e6;
            border-radius: 0.375rem;
            padding: 0.75rem;
            margin-bottom: 0.5rem;
            transition: all 0.2s ease;
        }
        .file-item:hover {
            border-color: #0d6efd;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }
        .btn-group-custom {
            gap: 0.5rem;
        }
        .card-header-custom {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
        }
        .card-header-success {
            background: linear-gradient(135deg, #28a745 0%, #20c997 100%);
            color: white;
        }
        .form-control:focus {
            border-color: #667eea;
            box-shadow: 0 0 0 0.2rem rgba(102, 126, 234, 0.25);
        }
        .btn-submit {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border: none;
            padding: 0.75rem 2rem;
            font-weight: 500;
        }
        .btn-submit:hover {
            background: linear-gradient(135deg, #5a6fd8 0%, #6b4190 100%);
            transform: translateY(-1px);
        }
        .help-section {
            background: linear-gradient(145deg, #f8f9fa, #e9ecef);
            border-radius: 0.75rem;
        }

        /* 富文本编辑器样式 */
        .rich-editor-container {
            border: 1px solid #ced4da;
            border-radius: 0.375rem;
            background: white;
        }
        .rich-editor-toolbar {
            background: #f8f9fa;
            border-bottom: 1px solid #dee2e6;
            padding: 0.75rem;
            border-radius: 0.375rem 0.375rem 0 0;
        }
        .rich-editor-content {
            min-height: 300px;
            padding: 1rem;
            border-radius: 0 0 0.375rem 0.375rem;
            overflow-y: auto;
            font-family: 'Microsoft YaHei', Arial, sans-serif;
            font-size: 14px;
            line-height: 1.6;
        }
        .rich-editor-content:focus {
            outline: none;
            box-shadow: 0 0 0 0.2rem rgba(102, 126, 234, 0.25);
        }
        .rich-editor-content:empty:before {
            content: "請輸入公告內容...";
            color: #6c757d;
            font-style: italic;
        }
        .toolbar-group {
            display: inline-flex;
            margin-right: 1rem;
            margin-bottom: 0.5rem;
        }
        .toolbar-btn {
            background: white;
            border: 1px solid #dee2e6;
            color: #495057;
            padding: 0.375rem 0.75rem;
            cursor: pointer;
            transition: all 0.2s ease;
            font-size: 14px;
        }
        .toolbar-btn:first-child {
            border-radius: 0.25rem 0 0 0.25rem;
        }
        .toolbar-btn:last-child {
            border-radius: 0 0.25rem 0.25rem 0;
            border-left: none;
        }
        .toolbar-btn:not(:first-child):not(:last-child) {
            border-left: none;
        }
        .toolbar-btn:hover {
            background: #e9ecef;
            color: #212529;
        }
        .toolbar-btn.active {
            background: #0d6efd;
            color: white;
            border-color: #0d6efd;
        }
        .toolbar-select {
            padding: 0.375rem 0.5rem;
            border: 1px solid #dee2e6;
            border-radius: 0.25rem;
            background: white;
            color: #495057;
            font-size: 14px;
            margin-right: 0.5rem;
            margin-bottom: 0.5rem;
        }
        .color-picker {
            width: 40px;
            height: 32px;
            padding: 2px;
            border: 1px solid #dee2e6;
            border-radius: 0.25rem;
            cursor: pointer;
            margin-right: 0.5rem;
            margin-bottom: 0.5rem;
        }
    </style>
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
        document.addEventListener('DOMContentLoaded', function() {
            const form = document.getElementById('announcementForm');
            const publishDate = document.getElementById('publishDate');
            const endDate = document.getElementById('endDate');
            const attachments = document.getElementById('attachments');
            const filePreview = document.getElementById('filePreview');
            const fileList = document.getElementById('fileList');
            const fileUploadArea = document.getElementById('fileUploadArea');
            const submitBtn = document.getElementById('submitBtn');
            const resetBtn = document.getElementById('resetBtn');
            const contentInput = document.getElementById('contentInput');
            const richEditor = document.getElementById('richEditor');

            // 富文本编辑器功能
            function initRichEditor() {
                // 工具栏按钮事件
                document.querySelectorAll('.toolbar-btn').forEach(btn => {
                    btn.addEventListener('click', function(e) {
                        e.preventDefault();
                        const command = this.dataset.command;
                        if (command) {
                            document.execCommand(command, false, null);
                            this.classList.toggle('active');
                            richEditor.focus();
                        }
                    });
                });

                // 字体大小
                document.getElementById('fontSize').addEventListener('change', function() {
                    document.execCommand('fontSize', false, '7');
                    const fontElements = richEditor.querySelectorAll('font[size="7"]');
                    fontElements.forEach(el => {
                        el.removeAttribute('size');
                        el.style.fontSize = this.value;
                    });
                    richEditor.focus();
                });

                // 文字颜色
                document.getElementById('textColor').addEventListener('change', function() {
                    document.execCommand('foreColor', false, this.value);
                    richEditor.focus();
                });

                // 背景颜色
                document.getElementById('bgColor').addEventListener('change', function() {
                    document.execCommand('backColor', false, this.value);
                    richEditor.focus();
                });

                // 更新工具栏状态
                richEditor.addEventListener('mouseup', updateToolbarState);
                richEditor.addEventListener('keyup', updateToolbarState);

                function updateToolbarState() {
                    document.querySelectorAll('.toolbar-btn').forEach(btn => {
                        const command = btn.dataset.command;
                        if (command && document.queryCommandState(command)) {
                            btn.classList.add('active');
                        } else {
                            btn.classList.remove('active');
                        }
                    });
                }
            }

            // 清除格式功能
            window.clearFormat = function() {
                document.execCommand('removeFormat', false, null);
                richEditor.focus();
            };

            // 初始化富文本编辑器
            initRichEditor();

            // 設置默認日期（僅新增時）
            <c:if test="${empty announcement.id}">
                const today = new Date().toISOString().split('T')[0];
                if (!publishDate.value) {
                    publishDate.value = today;
                }

                if (!endDate.value) {
                    const nextMonth = new Date();
                    nextMonth.setMonth(nextMonth.getMonth() + 1);
                    endDate.value = nextMonth.toISOString().split('T')[0];
                }
            </c:if>

            // 日期驗證
            function validateDates() {
                if (publishDate.value && endDate.value) {
                    if (new Date(publishDate.value) > new Date(endDate.value)) {
                        endDate.setCustomValidity('截止日期不能早於發佈日期');
                        endDate.classList.add('is-invalid');
                        return false;
                    } else {
                        endDate.setCustomValidity('');
                        endDate.classList.remove('is-invalid');
                        return true;
                    }
                }
                return true;
            }

            publishDate.addEventListener('change', validateDates);
            endDate.addEventListener('change', validateDates);

            // 文件拖拽處理
            ['dragenter', 'dragover', 'dragleave', 'drop'].forEach(eventName => {
                fileUploadArea.addEventListener(eventName, preventDefaults, false);
            });

            function preventDefaults(e) {
                e.preventDefault();
                e.stopPropagation();
            }

            ['dragenter', 'dragover'].forEach(eventName => {
                fileUploadArea.addEventListener(eventName, highlight, false);
            });

            ['dragleave', 'drop'].forEach(eventName => {
                fileUploadArea.addEventListener(eventName, unhighlight, false);
            });

            function highlight(e) {
                fileUploadArea.classList.add('dragover');
            }

            function unhighlight(e) {
                fileUploadArea.classList.remove('dragover');
            }

            fileUploadArea.addEventListener('drop', handleDrop, false);

            function handleDrop(e) {
                const dt = e.dataTransfer;
                const files = dt.files;
                attachments.files = files;
                handleFiles(files);
            }

            // 文件選擇處理
            attachments.addEventListener('change', function() {
                handleFiles(this.files);
            });

            function handleFiles(files) {
                if (files.length > 0) {
                    filePreview.style.display = 'block';
                    fileList.innerHTML = '';

                    for (let i = 0; i < files.length; i++) {
                        const file = files[i];

                        // 檢查文件大小
                        if (file.size > 50 * 1024 * 1024) {
                            alert(`文件 "${file.name}" 大小超過50MB限制！`);
                            attachments.value = '';
                            filePreview.style.display = 'none';
                            return;
                        }

                        const fileItem = document.createElement('div');
                        fileItem.className = 'file-item d-flex justify-content-between align-items-center';

                        const fileSize = (file.size / 1024 / 1024).toFixed(2);
                        const fileIcon = getFileIcon(file.name);

                        fileItem.innerHTML = `
                            <div class="d-flex align-items-center">
                                <i class="${fileIcon} text-primary me-3 fa-lg"></i>
                                <div>
                                    <div class="fw-bold">${file.name}</div>
                                    <small class="text-muted">${fileSize} MB</small>
                                </div>
                            </div>
                            <span class="badge bg-success">待上傳</span>
                        `;

                        fileList.appendChild(fileItem);
                    }
                } else {
                    filePreview.style.display = 'none';
                }
            }

            function getFileIcon(fileName) {
                const ext = fileName.split('.').pop().toLowerCase();
                const iconMap = {
                    'pdf': 'fas fa-file-pdf',
                    'doc': 'fas fa-file-word', 'docx': 'fas fa-file-word',
                    'xls': 'fas fa-file-excel', 'xlsx': 'fas fa-file-excel',
                    'ppt': 'fas fa-file-powerpoint', 'pptx': 'fas fa-file-powerpoint',
                    'jpg': 'fas fa-file-image', 'jpeg': 'fas fa-file-image', 'png': 'fas fa-file-image', 'gif': 'fas fa-file-image',
                    'zip': 'fas fa-file-archive', 'rar': 'fas fa-file-archive',
                    'txt': 'fas fa-file-alt'
                };
                return iconMap[ext] || 'fas fa-file';
            }

            // 表單重置
            resetBtn.addEventListener('click', function() {
                filePreview.style.display = 'none';
                form.classList.remove('was-validated');
                richEditor.innerHTML = '';
                // 重置工具栏状态
                document.querySelectorAll('.toolbar-btn').forEach(btn => btn.classList.remove('active'));
                document.getElementById('fontSize').value = '14px';
                document.getElementById('textColor').value = '#000000';
                document.getElementById('bgColor').value = '#ffffff';
            });

            // 表單提交
            form.addEventListener('submit', function(e) {
                // 更新隐藏字段的内容
                contentInput.value = richEditor.innerHTML;

                if (!validateDates() || !form.checkValidity()) {
                    e.preventDefault();
                    e.stopPropagation();
                    form.classList.add('was-validated');
                    return;
                }

                // 顯示提交狀態
                submitBtn.innerHTML = '<i class="fas fa-spinner fa-spin me-2"></i>保存中...';
                submitBtn.disabled = true;
                resetBtn.disabled = true;
            });
        });
    </script>
</body>
</html>