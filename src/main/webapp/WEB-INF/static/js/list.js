function confirmDelete(id, title) {
    if (confirm('確定要刪除公告「' + title + '」嗎？\n\n此操作不可恢復！')) {
        window.location.href = contextPath + '/web/delete/' + id;
    }
}

// DOM加載完成後執行
$(document).ready(function() {
    // 自動隱藏消息提示
    $('.alert').each(function() {
        var $alert = $(this);
        setTimeout(function() {
            $alert.alert('close');
        }, 5000); // 5秒後自動隱藏
    });

    // 添加表格行動畫
    $('tbody tr').each(function(index) {
        $(this).css('animation-delay', (index * 50) + 'ms')
              .addClass('animate__fadeInUp');
    });

    // 搜索框功能增強
    var $searchInput = $('input[name="search"]');
    if ($searchInput.length) {
        // Enter鍵提交搜索
        $searchInput.on('keypress', function(e) {
            if (e.which === 13) { // Enter key
                $(this).closest('form').submit();
            }
        });

        // 搜索框焦點效果
        $searchInput.on('focus', function() {
            $(this).parent().addClass('focused');
        }).on('blur', function() {
            $(this).parent().removeClass('focused');
        });
    }

    // 統計卡片動畫
    var $statsCards = $('.stats-card');

    // 使用 Intersection Observer (如果支援) 或 scroll 事件
    if ('IntersectionObserver' in window) {
        var observer = new IntersectionObserver(function(entries) {
            entries.forEach(function(entry) {
                if (entry.isIntersecting) {
                    $(entry.target).css('animation', 'fadeInUp 0.6s ease forwards');
                }
            });
        }, {
            threshold: 0.1,
            rootMargin: '0px 0px -50px 0px'
        });

        $statsCards.each(function() {
            observer.observe(this);
        });
    } else {
        // 降級到簡單的淡入效果
        $statsCards.css('animation', 'fadeInUp 0.6s ease forwards');
    }
});