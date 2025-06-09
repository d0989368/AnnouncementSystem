<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${empty announcement ? '新增公告' : '編輯公告'} - 公告管理系統</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        .form-container {
            max-width: 800px;
            margin: 0 auto;
        }
        .required {
            color: red;
        }
    </style>
</head>
<body class="bg-light">
    <!-- 導航欄 -->
    <nav class="navbar navbar-expand-lg navbar-dark bg-primary">
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
                <h2>
                    <i class="fas fa-${empty announcement ? 'plus' : 'edit'} me-2"></i>
                    ${empty announcement ? '新增公告' : '編輯公告'}
                </h2>
            </div>

            <!-- 表單卡片 -->
            <div class="card shadow">
                <div class="card-header bg-${empty announcement ? 'success' : 'primary'} text-white">
                    <h5 class="mb-0">
                        <i class="fas fa-form me-2"></i>
                        ${empty announcement ? '填寫公告信息' : '修改公告信息'}
                    </h5>
                </div>
                <div class="card-body">
                    <!-- 錯誤信息顯示 -->
                    <c:if test="${not empty error}">
                        <div class="alert alert-danger alert-dismissible fade show" role="alert">
                            <i class="fas fa-exclamation-triangle me-2"></i>
                            ${error}
                            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                        </div>
                    </c:if>

                    <!-- 表單 -->
                    <form method="POST"
                          action="${pageContext.request.contextPath}/web/<c:choose><c:when test='${empty announcement.id}'>add</c:when><c:otherwise>edit/${announcement.id}</c:otherwise></c:choose>"
                          enctype="multipart/form-data"
                          id="announcementForm">

                        <!-- 標題 -->
                        <div class="mb-3">
                            <label for="title" class="form-label">
                                <i class="fas fa-heading me-1"></i>
                                標題 <span class="required">*</span>
                            </label>
                            <input type="text"
                                   class="form-control"
                                   id="title"
                                   name="title"
                                   value="${announcement.title}"
                                   required
                                   maxlength="200"
                                   placeholder="請輸入公告標題">
                            <div class="form-text">最多200個字符</div>
                        </div>

                        <!-- 發佈者 -->
                        <div class="mb-3">
                            <label for="publisher" class="form-label">
                                <i class="fas fa-user me-1"></i>
                                發佈者 <span class="required">*</span>
                            </label>
                            <input type="text"
                                   class="form-control"
                                   id="publisher"
                                   name="publisher"
                                   value="${announcement.publisher}"
                                   required
                                   maxlength="100"
                                   placeholder="請輸入發佈者姓名">
                        </div>

                        <!-- 日期區域 -->
                        <div class="row mb-3">
                            <div class="col-md-6">
                                <label for="publishDate" class="form-label">
                                    <i class="fas fa-calendar me-1"></i>
                                    發佈日期 <span class="required">*</span>
                                </label>
                                <input type="date"
                                       class="form-control"
                                       id="publishDate"
                                       name="publishDate"
                                       value="<fmt:formatDate value='${announcement.publishDate}' pattern='yyyy-MM-dd'/>"
                                       required>
                            </div>
                            <div class="col-md-6">
                                <label for="endDate" class="form-label">
                                    <i class="fas fa-calendar-times me-1"></i>
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

                        <!-- 內容 -->
                        <div class="mb-3">
                            <label for="content" class="form-label">
                                <i class="fas fa-file-text me-1"></i>
                                公告內容
                            </label>
                            <textarea class="form-control"
                                      id="content"
                                      name="content"
                                      rows="6"
                                      placeholder="請輸入公告內容（可選）">${announcement.content}</textarea>
                            <div class="form-text">支持換行，詳細描述公告內容</div>
                        </div>

                        <!-- 附件 -->
                        <div class="mb-3">
                            <label for="attachment" class="form-label">
                                <i class="fas fa-paperclip me-1"></i>
                                附件
                            </label>

                            <!-- 當前附件信息 -->
                            <c:if test="${not empty announcement.attachmentName}">
                                <div class="alert alert-info mb-2">
                                    <i class="fas fa-file me-2"></i>
                                    當前附件：<strong>${announcement.attachmentName}</strong>
                                    <a href="${pageContext.request.contextPath}/web/download/${announcement.id}"
                                       class="btn btn-sm btn-outline-primary ms-2">
                                        <i class="fas fa-download"></i> 下載
                                    </a>
                                </div>
                            </c:if>

                            <input type="file"
                                   class="form-control"
                                   id="attachment"
                                   name="attachment"
                                   accept=".pdf,.doc,.docx,.xls,.xlsx,.ppt,.pptx,.txt,.jpg,.jpeg,.png,.gif">
                            <div class="form-text">
                                <c:choose>
                                    <c:when test="${not empty announcement.attachmentName}">
                                        選擇新文件將替換當前附件
                                    </c:when>
                                    <c:otherwise>
                                        支持文檔、圖片等格式，最大50MB
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>

                        <!-- 按鈕區域 -->
                        <div class="d-flex justify-content-between align-items-center">
                            <div>
                                <a href="${pageContext.request.contextPath}/web/"
                                   class="btn btn-secondary">
                                    <i class="fas fa-arrow-left me-1"></i>返回列表
                                </a>
                                <c:if test="${not empty announcement}">
                                    <a href="${pageContext.request.contextPath}/web/view/${announcement.id}"
                                       class="btn btn-info ms-2">
                                        <i class="fas fa-eye me-1"></i>查看詳情
                                    </a>
                                </c:if>
                            </div>
                            <div>
                                <button type="reset" class="btn btn-outline-secondary me-2">
                                    <i class="fas fa-undo me-1"></i>重置
                                </button>
                                <button type="submit" class="btn btn-${empty announcement ? 'success' : 'primary'}">
                                    <i class="fas fa-save me-1"></i>
                                    ${empty announcement ? '保存公告' : '更新公告'}
                                </button>
                            </div>
                        </div>
                    </form>
                </div>
            </div>

            <!-- 幫助信息 -->
            <div class="card mt-4">
                <div class="card-header">
                    <h6 class="mb-0"><i class="fas fa-info-circle me-2"></i>填寫說明</h6>
                </div>
                <div class="card-body">
                    <ul class="mb-0">
                        <li>標有 <span class="required">*</span> 的字段為必填項</li>
                        <li>發佈日期不能晚於截止日期</li>
                        <li>公告內容支持換行，可以詳細描述公告信息</li>
                        <li>附件支持常見的文檔和圖片格式</li>
                        <li>編輯時重新上傳附件將替換原有文件</li>
                    </ul>
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

            // 設置默認日期（僅新增時）
            <c:if test="${empty announcement}">
                const today = new Date().toISOString().split('T')[0];
                publishDate.value = today;

                const nextMonth = new Date();
                nextMonth.setMonth(nextMonth.getMonth() + 1);
                endDate.value = nextMonth.toISOString().split('T')[0];
            </c:if>

            // 日期驗證
            function validateDates() {
                if (publishDate.value && endDate.value) {
                    if (new Date(publishDate.value) > new Date(endDate.value)) {
                        endDate.setCustomValidity('截止日期不能早於發佈日期');
                    } else {
                        endDate.setCustomValidity('');
                    }
                }
            }

            publishDate.addEventListener('change', validateDates);
            endDate.addEventListener('change', validateDates);

            // 表單提交確認
            form.addEventListener('submit', function(e) {
                if (!form.checkValidity()) {
                    e.preventDefault();
                    e.stopPropagation();
                }
                form.classList.add('was-validated');
            });

            // 文件大小驗證
            document.getElementById('attachment').addEventListener('change', function(e) {
                const file = e.target.files[0];
                if (file && file.size > 50 * 1024 * 1024) { // 50MB
                    alert('文件大小不能超過50MB');
                    e.target.value = '';
                }
            });
        });
    </script>
</body>
</html>