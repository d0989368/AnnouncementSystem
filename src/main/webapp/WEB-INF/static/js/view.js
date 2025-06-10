function confirmDelete() {
    if (confirm('確定要刪除這個公告嗎？\n\n標題：' + announcementTitle + '\n\n此操作不可恢復！')) {
        window.location.href = contextPath + '/web/delete/' + announcementId;
    }
}

// DOM加載完成後執行
$(document).ready(function() {
    // 自動滾動到內容區域（如果從列表頁面跳轉）
    if (document.referrer.includes('/web/')) {
        // 從列表頁跳轉來的，不滾動
    } else {
        // 直接訪問，滾動到內容區域
        setTimeout(function() {
            var $cardBody = $('.card-body').first();
            if ($cardBody.length) {
                $('html, body').animate({
                    scrollTop: $cardBody.offset().top
                }, 300);
            }
        }, 300);
    }

    // 附件項目hover效果
    $('.attachment-item').hover(
        function() {
            $(this).css('transform', 'translateY(-3px)');
        },
        function() {
            $(this).css('transform', 'translateY(0)');
        }
    );

    // 自動隱藏消息提示
    $('.alert').each(function() {
        var $alert = $(this);
        setTimeout(function() {
            $alert.alert('close');
        }, 5000);
    });
});

// 鍵盤快捷鍵
$(document).on('keydown', function(e) {
    // Ctrl+P 打印
    if (e.ctrlKey && e.which === 80) { // P key
        e.preventDefault();
        window.print();
    }
    // Ctrl+E 編輯
    if (e.ctrlKey && e.which === 69) { // E key
        e.preventDefault();
        window.location.href = contextPath + '/web/edit/' + announcementId;
    }
    // ESC 返回列表
    if (e.which === 27) { // ESC key
        window.location.href = contextPath + '/web/';
    }
});

// 打印樣式優化
$(window).on('beforeprint', function() {
    document.title = announcementTitle + ' - 公告詳情';
});

$(window).on('afterprint', function() {
    document.title = announcementTitle + ' - 公告管理系統';
});

// 附件下載追踪（可選）
$(document).on('click', 'a[href*="/attachment/download/"]', function() {
    console.log('下載附件：', $(this).text().trim());
});