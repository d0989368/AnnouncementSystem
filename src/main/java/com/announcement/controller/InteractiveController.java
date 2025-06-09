package com.announcement.controller;

import com.announcement.entity.Announcement;
import com.announcement.service.AnnouncementService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import javax.servlet.http.HttpServletResponse;
import java.io.*;
import java.net.URLEncoder;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import java.util.UUID;

/**
 * 公告管理控制器 - JSP版本
 */
@Controller
@RequestMapping("/web")
public class InteractiveController {

    @Autowired
    private AnnouncementService announcementService;

    private static final int PAGE_SIZE = 10;
    private static final String UPLOAD_DIR = "/opt/uploads/";

    /**
     * 公告列表頁面
     */
    @GetMapping("/")
    public String listPage(@RequestParam(defaultValue = "1") int page,
                           @RequestParam(defaultValue = "") String search,
                           Model model) {
        try {
            List<Announcement> announcements;
            long totalCount;
            int totalPages;

            if (!search.trim().isEmpty()) {
                announcements = announcementService.searchAnnouncements(search, page, PAGE_SIZE);
                totalCount = announcementService.getSearchCount(search);
                totalPages = (int) Math.ceil((double) totalCount / PAGE_SIZE);
            } else {
                announcements = announcementService.findWithPagination(page, PAGE_SIZE);
                totalCount = announcementService.getTotalCount();
                totalPages = announcementService.getTotalPages(PAGE_SIZE);
            }

            model.addAttribute("announcements", announcements);
            model.addAttribute("currentPage", page);
            model.addAttribute("totalPages", totalPages);
            model.addAttribute("totalCount", totalCount);
            model.addAttribute("pageSize", PAGE_SIZE);
            model.addAttribute("search", search);

            return "list";
        } catch (Exception e) {
            model.addAttribute("error", "加載公告列表失敗：" + e.getMessage());
            return "list";
        }
    }

    /**
     * 新增公告頁面
     */
    @GetMapping("/add")
    public String addPage(Model model) {
        // 不設置announcement屬性，讓JSP判斷為空
        return "form";
    }

    /**
     * 處理新增公告
     */
    @PostMapping("/add")
    public String handleAdd(@RequestParam String title,
                            @RequestParam String publisher,
                            @RequestParam String publishDate,
                            @RequestParam String endDate,
                            @RequestParam(required = false) String content,
                            @RequestParam(required = false) MultipartFile attachment,
                            RedirectAttributes redirectAttributes) {
        try {
            SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");

            Announcement announcement = new Announcement();
            announcement.setTitle(title);
            announcement.setPublisher(publisher);
            announcement.setPublishDate(dateFormat.parse(publishDate));
            announcement.setEndDate(dateFormat.parse(endDate));
            announcement.setContent(content);

            // 處理文件上傳
            if (attachment != null && !attachment.isEmpty()) {
                String fileName = saveFile(attachment);
                announcement.setAttachmentName(attachment.getOriginalFilename());
                announcement.setAttachmentPath(fileName);
            }

            announcementService.save(announcement, attachment);
            redirectAttributes.addFlashAttribute("message", "公告新增成功！");
            return "redirect:/web/";
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "新增失敗：" + e.getMessage());
            return "redirect:/web/add";
        }
    }

    /**
     * 編輯公告頁面
     */
    @GetMapping("/edit/{id}")
    public String editPage(@PathVariable Long id, Model model, RedirectAttributes redirectAttributes) {
        try {
            Announcement announcement = announcementService.findById(id);
            if (announcement == null) {
                redirectAttributes.addFlashAttribute("error", "公告不存在！");
                return "redirect:/web/";
            }

            model.addAttribute("announcement", announcement);
            return "form";
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "加載公告失敗：" + e.getMessage());
            return "redirect:/web/";
        }
    }

    /**
     * 處理編輯公告
     */
    @PostMapping("/edit/{id}")
    public String handleEdit(@PathVariable Long id,
                             @RequestParam String title,
                             @RequestParam String publisher,
                             @RequestParam String publishDate,
                             @RequestParam String endDate,
                             @RequestParam(required = false) String content,
                             @RequestParam(required = false) MultipartFile attachment,
                             RedirectAttributes redirectAttributes) {
        try {
            SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");

            // 創建新的對象而不是查詢現有對象
            Announcement announcement = new Announcement();
            announcement.setId(id);  // 設置ID用於更新
            announcement.setTitle(title);
            announcement.setPublisher(publisher);
            announcement.setPublishDate(dateFormat.parse(publishDate));
            announcement.setEndDate(dateFormat.parse(endDate));
            announcement.setContent(content);

            announcementService.update(announcement, attachment);
            redirectAttributes.addFlashAttribute("message", "公告更新成功！");
            return "redirect:/web/view/" + id;
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "更新失敗：" + e.getMessage());
            return "redirect:/web/edit/" + id;
        }
    }

    /**
     * 查看公告詳情頁面
     */
    @GetMapping("/view/{id}")
    public String viewPage(@PathVariable Long id, Model model, RedirectAttributes redirectAttributes) {
        try {
            Announcement announcement = announcementService.findById(id);
            if (announcement == null) {
                redirectAttributes.addFlashAttribute("error", "公告不存在！");
                return "redirect:/web/";
            }

            model.addAttribute("announcement", announcement);
            return "view";
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "加載公告失敗：" + e.getMessage());
            return "redirect:/web/";
        }
    }

    /**
     * 刪除公告
     */
    @GetMapping("/delete/{id}")
    public String deleteAnnouncement(@PathVariable Long id, RedirectAttributes redirectAttributes) {
        try {
            Announcement announcement = announcementService.findById(id);
            if (announcement == null) {
                redirectAttributes.addFlashAttribute("error", "公告不存在！");
                return "redirect:/web/";
            }

            announcementService.delete(id);
            redirectAttributes.addFlashAttribute("message", "公告刪除成功！");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "刪除失敗：" + e.getMessage());
        }
        return "redirect:/web/";
    }

    /**
     * 下載附件
     */
    @GetMapping("/download/{id}")
    public void downloadAttachment(@PathVariable Long id, HttpServletResponse response) throws IOException {
        try {
            Announcement announcement = announcementService.findById(id);
            if (announcement == null || announcement.getAttachmentPath() == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "附件不存在");
                return;
            }

            File file = new File(UPLOAD_DIR + announcement.getAttachmentPath());
            if (!file.exists()) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "附件文件不存在");
                return;
            }

            // 設置響應頭
            response.setContentType("application/octet-stream");
            response.setCharacterEncoding("UTF-8");

            String fileName = announcement.getAttachmentName();
            if (fileName == null) {
                fileName = announcement.getAttachmentPath();
            }

            // 處理中文文件名
            String encodedFileName = URLEncoder.encode(fileName, "UTF-8").replaceAll("\\+", "%20");
            response.setHeader("Content-Disposition", "attachment; filename*=UTF-8''" + encodedFileName);
            response.setContentLengthLong(file.length());

            // 輸出文件內容
            try (FileInputStream fis = new FileInputStream(file);
                 BufferedInputStream bis = new BufferedInputStream(fis);
                 OutputStream os = response.getOutputStream()) {

                byte[] buffer = new byte[8192];
                int bytesRead;
                while ((bytesRead = bis.read(buffer)) != -1) {
                    os.write(buffer, 0, bytesRead);
                }
                os.flush();
            }
        } catch (Exception e) {
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "下載失敗：" + e.getMessage());
        }
    }

    /**
     * 保存上傳的文件
     */
    private String saveFile(MultipartFile file) throws IOException {
        // 創建上傳目錄
        File uploadDir = new File(UPLOAD_DIR);
        if (!uploadDir.exists()) {
            uploadDir.mkdirs();
        }

        // 生成唯一文件名
        String originalFilename = file.getOriginalFilename();
        String extension = originalFilename != null && originalFilename.contains(".")
                ? originalFilename.substring(originalFilename.lastIndexOf("."))
                : "";
        String fileName = UUID.randomUUID().toString() + extension;

        // 保存文件
        File targetFile = new File(uploadDir, fileName);
        file.transferTo(targetFile);

        return fileName;
    }

    /**
     * 刪除文件
     */
    private void deleteFile(String fileName) {
        try {
            File file = new File(UPLOAD_DIR + fileName);
            if (file.exists()) {
                file.delete();
            }
        } catch (Exception e) {
            // 日誌記錄，但不影響主要流程
            System.err.println("刪除文件失敗：" + e.getMessage());
        }
    }
}