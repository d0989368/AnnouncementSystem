// 列表页面脚本 - list.js

function confirmDelete(id, title) {
    if (confirm('確定要刪除公告「' + title + '」嗎？\n\n此操作不可恢復！')) {
        window.location.href = contextPath + '/web/delete/' + id;
    }
}

// DOM加载完成后执行
document.addEventListener('DOMContentLoaded', function() {
    // 自動隱藏消息提示
    const alerts = document.querySelectorAll('.alert');
    alerts.forEach(function(alert) {
        setTimeout(function() {
            const bsAlert = new bootstrap.Alert(alert);
            bsAlert.close();
        }, 5000); // 5秒後自動隱藏
    });

    // 添加表格行動畫
    const tableRows = document.querySelectorAll('tbody tr');
    tableRows.forEach((row, index) => {
        row.style.animationDelay = `${index * 50}ms`;
        row.classList.add('animate__fadeInUp');
    });

    // 搜索框功能增強
    const searchInput = document.querySelector('input[name="search"]');
    if (searchInput) {
        searchInput.addEventListener('keypress', function(e) {
            if (e.key === 'Enter') {
                this.form.submit();
            }
        });

        // 搜索框焦點效果
        searchInput.addEventListener('focus', function() {
            this.parentElement.classList.add('focused');
        });

        searchInput.addEventListener('blur', function() {
            this.parentElement.classList.remove('focused');
        });
    }

    // 統計卡片動畫
    const statsCards = document.querySelectorAll('.stats-card');
    const observerOptions = {
        threshold: 0.1,
        rootMargin: '0px 0px -50px 0px'
    };

    const observer = new IntersectionObserver(function(entries) {
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                entry.target.style.animation = 'fadeInUp 0.6s ease forwards';
            }
        });
    }, observerOptions);

    statsCards.forEach(card => {
        observer.observe(card);
    });
});