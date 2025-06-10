// 查看页面脚本 - view.js

function confirmDelete() {
    if (confirm('確定要刪除這個公告嗎？\n\n標題：' + announcementTitle + '\n\n此操作不可恢復！')) {
        window.location.href = contextPath + '/web/delete/' + announcementId;
    }
}

// DOM加载完成后执行
document.addEventListener('DOMContentLoaded', function() {
    // 自動滾動到內容區域（如果從列表頁面跳轉）
    if (document.referrer.includes('/web/')) {
        // 從列表頁跳轉來的，不滾動
    } else {
        // 直接訪問，滾動到內容區域
        setTimeout(function() {
            const cardBody = document.querySelector('.card-body');
            if (cardBody) {
                cardBody.scrollIntoView({
                    behavior: 'smooth',
                    block: 'start'
                });
            }
        }, 300);
    }

    // 附件項目hover效果
    document.querySelectorAll('.attachment-item').forEach(item => {
        item.addEventListener('mouseenter', function() {
            this.style.transform = 'translateY(-3px)';
        });
        item.addEventListener('mouseleave', function() {
            this.style.transform = 'translateY(0)';
        });
    });
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
        window.location.href = contextPath + '/web/edit/' + announcementId;
    }
    // ESC 返回列表
    if (e.key === 'Escape') {
        window.location.href = contextPath + '/web/';
    }
});

// 打印樣式優化
window.addEventListener('beforeprint', function() {
    document.title = announcementTitle + ' - 公告詳情';
});

window.addEventListener('afterprint', function() {
    document.title = announcementTitle + ' - 公告管理系統';
});

// 附件下載追踪（可選）
document.querySelectorAll('a[href*="/attachment/download/"]').forEach(link => {
    link.addEventListener('click', function() {
        console.log('下載附件：', this.textContent.trim());
    });
});