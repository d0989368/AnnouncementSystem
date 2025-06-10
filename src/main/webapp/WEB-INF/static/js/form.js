// 表单页面脚本 - form.js

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
    if (isNewAnnouncement) {
        const today = new Date().toISOString().split('T')[0];
        if (!publishDate.value) {
            publishDate.value = today;
        }

        if (!endDate.value) {
            const nextMonth = new Date();
            nextMonth.setMonth(nextMonth.getMonth() + 1);
            endDate.value = nextMonth.toISOString().split('T')[0];
        }
    }

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