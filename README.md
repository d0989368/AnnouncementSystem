# 公告管理系統

基於 Spring MVC 開發的簡易公告管理系統，支援富文本編輯和多附件上傳功能。

## 功能特色

- 公告 CRUD 操作（新增、查看、編輯、刪除）
- 富文本編輯器（支援格式化、顏色、對齊、列表）
- 多附件上傳（拖拽上傳、檔案類型驗證）
- 搜索功能（按標題或發佈者搜索）
- 分頁顯示
- 響應式設計
- 公告狀態管理（進行中/未發佈/已過期）

## 技術架構

**後端**
- Spring MVC 5.x
- JSP + JSTL
- MySQL 8.0
- Maven

**前端**
- Bootstrap 5.1.3
- FontAwesome 6.0
- 原生 JavaScript
- CSS3

## 專案結構

```
webapp/
├── WEB-INF/views/
│   ├── list.jsp        # 公告列表
│   ├── form.jsp        # 新增/編輯表單
│   └── view.jsp        # 公告詳情
└── static/
    ├── css/
    │   ├── list.css
    │   ├── form.css
    │   └── view.css
    └── js/
        ├── list.js
        ├── form.js
        └── view.js
```

## 快速開始

### 環境要求

- JDK 8+
- Maven 3.6+
- MySQL 8.0+
- Tomcat 9.0+

### 安裝步驟

1. 建立資料庫
```sql
CREATE DATABASE announcement_system CHARACTER SET utf8mb4;
```

2. 配置資料庫連線
   編輯 `src/main/resources/database.properties`：
```properties
db.driver=com.mysql.cj.jdbc.Driver
db.url=jdbc:mysql://localhost:3306/announcement_system
db.username=your_username
db.password=your_password
```

3. 編譯部署
```bash
mvn clean package
cp target/announcement-system.war $TOMCAT_HOME/webapps/
```

4. 啟動應用
```bash
$TOMCAT_HOME/bin/startup.sh
```

5. 訪問系統
```
http://localhost:8080/announcement-system
```

## 使用說明

### 新增公告
1. 點擊「新增公告」
2. 填寫標題、發佈者、發佈日期、截止日期
3. 使用富文本編輯器編寫內容
4. 上傳附件（可選）
5. 儲存公告

### 編輯公告
1. 在列表中點擊「編輯」
2. 修改公告信息
3. 管理附件（新增/刪除）
4. 儲存變更

### 搜索公告
- 在搜索框輸入關鍵字
- 支援按標題或發佈者搜索
- 點擊「清除搜索條件」重置

## 配置說明

### 靜態資源配置
在 `spring-mvc.xml` 中配置：
```xml
<mvc:resources mapping="/static/**" location="/static/" />
```

### 檔案上傳配置
```xml
<bean id="multipartResolver" class="org.springframework.web.multipart.commons.CommonsMultipartResolver">
    <property name="maxUploadSize" value="52428800" /> <!-- 50MB -->
    <property name="defaultEncoding" value="UTF-8" />
</bean>
```

## 注意事項

- 確保靜態資源路徑 `/static/` 可正常訪問
- 上傳檔案大小限制為 50MB
- 支援檔案格式：PDF、Word、Excel、PowerPoint、圖片、壓縮包
- 建議在生產環境中壓縮 CSS 和 JS 檔案