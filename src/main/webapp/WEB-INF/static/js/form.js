$(document).ready(function() {
    var $form = $('#announcementForm');
    var $publishDate = $('#publishDate');
    var $endDate = $('#endDate');
    var $attachments = $('#attachments');
    var $filePreview = $('#filePreview');
    var $fileList = $('#fileList');
    var $fileUploadArea = $('#fileUploadArea');
    var $submitBtn = $('#submitBtn');
    var $resetBtn = $('#resetBtn');
    var $contentInput = $('#contentInput');
    var $richEditor = $('#richEditor');

    // 富文本編輯器功能
    function initRichEditor() {
        // 工具欄按鈕事件
        $('.toolbar-btn').on('click', function(e) {
            e.preventDefault();
            var command = $(this).data('command');
            if (command) {
                document.execCommand(command, false, null);
                $(this).toggleClass('active');
                $richEditor.focus();
            }
        });

        // 字體大小
        $('#fontSize').on('change', function() {
            document.execCommand('fontSize', false, '7');
            var fontSize = $(this).val();
            $richEditor.find('font[size="7"]').each(function() {
                $(this).removeAttr('size').css('font-size', fontSize);
            });
            $richEditor.focus();
        });

        // 文字顏色
        $('#textColor').on('change', function() {
            document.execCommand('foreColor', false, $(this).val());
            $richEditor.focus();
        });

        // 背景顏色
        $('#bgColor').on('change', function() {
            document.execCommand('backColor', false, $(this).val());
            $richEditor.focus();
        });

        // 更新工具欄狀態
        $richEditor.on('mouseup keyup', function() {
            updateToolbarState();
        });

        function updateToolbarState() {
            $('.toolbar-btn').each(function() {
                var command = $(this).data('command');
                if (command && document.queryCommandState(command)) {
                    $(this).addClass('active');
                } else {
                    $(this).removeClass('active');
                }
            });
        }
    }

    // 清除格式功能
    window.clearFormat = function() {
        document.execCommand('removeFormat', false, null);
        $richEditor.focus();
    };

    // 初始化富文本編輯器
    initRichEditor();

    // 設置默認日期（僅新增時）
    if (isNewAnnouncement) {
        var today = new Date().toISOString().split('T')[0];
        if (!$publishDate.val()) {
            $publishDate.val(today);
        }

        if (!$endDate.val()) {
            var nextMonth = new Date();
            nextMonth.setMonth(nextMonth.getMonth() + 1);
            $endDate.val(nextMonth.toISOString().split('T')[0]);
        }
    }

    // 日期驗證
    function validateDates() {
        var publishDateVal = $publishDate.val();
        var endDateVal = $endDate.val();

        if (publishDateVal && endDateVal) {
            if (new Date(publishDateVal) > new Date(endDateVal)) {
                $endDate[0].setCustomValidity('截止日期不能早於發佈日期');
                $endDate.addClass('is-invalid');
                return false;
            } else {
                $endDate[0].setCustomValidity('');
                $endDate.removeClass('is-invalid');
                return true;
            }
        }
        return true;
    }

    $publishDate.on('change', validateDates);
    $endDate.on('change', validateDates);

    // 文件拖拽處理
    $fileUploadArea.on('dragenter dragover dragleave drop', function(e) {
        e.preventDefault();
        e.stopPropagation();
    });

    $fileUploadArea.on('dragenter dragover', function(e) {
        $(this).addClass('dragover');
    });

    $fileUploadArea.on('dragleave drop', function(e) {
        $(this).removeClass('dragover');
    });

    $fileUploadArea.on('drop', function(e) {
        var files = e.originalEvent.dataTransfer.files;
        $attachments[0].files = files;
        handleFiles(files);
    });

    // 文件選擇處理
    $attachments.on('change', function() {
        handleFiles(this.files);
    });

    function handleFiles(files) {
        if (files.length > 0) {
            $filePreview.show();
            $fileList.empty();

            $.each(files, function(i, file) {
                // 檢查文件大小
                if (file.size > 50 * 1024 * 1024) {
                    alert('文件 "' + file.name + '" 大小超過50MB限制！');
                    $attachments.val('');
                    $filePreview.hide();
                    return false;
                }

                var fileSize = (file.size / 1024 / 1024).toFixed(2);
                var fileIcon = getFileIcon(file.name);

                var $fileItem = $('<div class="file-item d-flex justify-content-between align-items-center">');
                $fileItem.html(
                    '<div class="d-flex align-items-center">' +
                        '<i class="' + fileIcon + ' text-primary me-3 fa-lg"></i>' +
                        '<div>' +
                            '<div class="fw-bold">' + file.name + '</div>' +
                            '<small class="text-muted">' + fileSize + ' MB</small>' +
                        '</div>' +
                    '</div>' +
                    '<span class="badge bg-success">待上傳</span>'
                );

                $fileList.append($fileItem);
            });
        } else {
            $filePreview.hide();
        }
    }

    function getFileIcon(fileName) {
        var ext = fileName.split('.').pop().toLowerCase();
        var iconMap = {
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
    $resetBtn.on('click', function() {
        $filePreview.hide();
        $form.removeClass('was-validated');
        $richEditor.html('');
        // 重置工具欄狀態
        $('.toolbar-btn').removeClass('active');
        $('#fontSize').val('14px');
        $('#textColor').val('#000000');
        $('#bgColor').val('#ffffff');
    });

    // 表單提交
    $form.on('submit', function(e) {
        // 更新隱藏欄位的內容
        $contentInput.val($richEditor.html());

        if (!validateDates() || !this.checkValidity()) {
            e.preventDefault();
            e.stopPropagation();
            $form.addClass('was-validated');
            return;
        }

        // 顯示提交狀態
        $submitBtn.html('<i class="fas fa-spinner fa-spin me-2"></i>保存中...')
                  .prop('disabled', true);
        $resetBtn.prop('disabled', true);
    });
});