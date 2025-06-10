package com.announcement.controller;

import com.announcement.entity.Announcement;
import com.announcement.entity.Attachment;
import com.announcement.service.AnnouncementService;
import com.announcement.service.AttachmentService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import javax.servlet.http.HttpServletResponse;
import java.io.*;
import java.net.URLEncoder;
import java.text.SimpleDateFormat;
import java.util.List;

/**
 * 公告管理控制器
 */
@Controller
@RequestMapping("/web")
public class InteractiveController {

    @Autowired
    private AnnouncementService announcementService;

    @Autowired
    private AttachmentService attachmentService;

    private static final int PAGE_SIZE = 5;
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
            e.printStackTrace();
            model.addAttribute("error", "加載公告列表失敗：" + e.getMessage());
            return "list";
        }
    }

    /**
     * 新增公告頁面
     */
    @GetMapping("/add")
    public String addPage(Model model) {
        try {
            System.out.println("=== 進入新增頁面 ===");
            return "form";
        } catch (Exception e) {
            System.err.println("新增頁面錯誤: " + e.getMessage());
            e.printStackTrace();
            model.addAttribute("error", "加載新增頁面失敗：" + e.getMessage());
            return "redirect:/web/";
        }
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
                            @RequestParam(required = false) MultipartFile[] attachments,
                            RedirectAttributes redirectAttributes) {
        try {
            System.out.println("=== 處理新增公告 ===");
            System.out.println("標題: " + title);
            System.out.println("發布者: " + publisher);

            SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");

            Announcement announcement = new Announcement();
            announcement.setTitle(title);
            announcement.setPublisher(publisher);
            announcement.setPublishDate(dateFormat.parse(publishDate));
            announcement.setEndDate(dateFormat.parse(endDate));
            announcement.setContent(content);

            // 保存公告
            announcementService.save(announcement);
            System.out.println("公告保存成功，ID: " + announcement.getId());

            // 保存附件
            if (attachments != null && attachments.length > 0) {
                System.out.println("處理 " + attachments.length + " 個附件");
                for (MultipartFile file : attachments) {
                    if (!file.isEmpty()) {
                        System.out.println("保存附件: " + file.getOriginalFilename());
                        attachmentService.saveAttachment(announcement.getId(), file);
                    }
                }
            }

            redirectAttributes.addFlashAttribute("message", "公告新增成功！");
            return "redirect:/web/";
        } catch (Exception e) {
            System.err.println("新增失败: " + e.getMessage());
            e.printStackTrace();
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
            System.out.println("=== 進入編輯頁面，ID: " + id + " ===");

            Announcement announcement = announcementService.findById(id);
            if (announcement == null) {
                redirectAttributes.addFlashAttribute("error", "公告不存在！");
                return "redirect:/web/";
            }

            model.addAttribute("announcement", announcement);

            // 獲取附件列表
            try {
                List<Attachment> attachments = attachmentService.getAttachmentsByAnnouncementId(id);
                model.addAttribute("attachments", attachments);
                System.out.println("附件数量: " + (attachments != null ? attachments.size() : 0));
            } catch (Exception attachmentError) {
                System.err.println("查詢附件失敗: " + attachmentError.getMessage());
                attachmentError.printStackTrace();
                // 不中斷執行，繼續顯示編輯頁面，但附件為空
            }

            System.out.println("編輯頁面加載成功");
            return "form";
        } catch (Exception e) {
            System.err.println("編輯頁面錯誤: " + e.getMessage());
            e.printStackTrace();
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
                             @RequestParam(required = false) MultipartFile[] attachments,
                             RedirectAttributes redirectAttributes) {
        try {
            System.out.println("=== 處理編輯公告，ID: " + id + " ===");

            SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");

            // 獲取現有公告
            Announcement existingAnnouncement = announcementService.findById(id);
            if (existingAnnouncement == null) {
                redirectAttributes.addFlashAttribute("error", "公告不存在！");
                return "redirect:/web/";
            }

            // 更新公告信息
            existingAnnouncement.setTitle(title);
            existingAnnouncement.setPublisher(publisher);
            existingAnnouncement.setPublishDate(dateFormat.parse(publishDate));
            existingAnnouncement.setEndDate(dateFormat.parse(endDate));
            existingAnnouncement.setContent(content);

            // 更新公告
            announcementService.update(existingAnnouncement);

            // 保存新附件
            if (attachments != null && attachments.length > 0) {
                System.out.println("添加 " + attachments.length + " 個新附件");
                for (MultipartFile file : attachments) {
                    if (!file.isEmpty()) {
                        System.out.println("保存新附件: " + file.getOriginalFilename());
                        attachmentService.saveAttachment(id, file);
                    }
                }
            }

            redirectAttributes.addFlashAttribute("message", "公告更新成功！");
            return "redirect:/web/view/" + id;
        } catch (Exception e) {
            System.err.println("更新失败: " + e.getMessage());
            e.printStackTrace();
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
            System.out.println("=== 查看公告詳情，ID: " + id + " ===");

            Announcement announcement = announcementService.findById(id);
            if (announcement == null) {
                redirectAttributes.addFlashAttribute("error", "公告不存在！");
                return "redirect:/web/";
            }

            model.addAttribute("announcement", announcement);

            // 獲取附件列表
            try {
                List<Attachment> attachments = attachmentService.getAttachmentsByAnnouncementId(id);
                model.addAttribute("attachments", attachments);
                System.out.println("附件數量: " + (attachments != null ? attachments.size() : 0));
            } catch (Exception e) {
                System.err.println("查詢附件失敗: " + e.getMessage());
                e.printStackTrace();
            }

            return "view";
        } catch (Exception e) {
            System.err.println("查看詳情失敗: " + e.getMessage());
            e.printStackTrace();
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
            System.out.println("=== 刪除公告，ID: " + id + " ===");

            // 刪除附件
            attachmentService.deleteAttachmentsByAnnouncementId(id);
            // 刪除公告
            announcementService.delete(id);

            redirectAttributes.addFlashAttribute("message", "公告刪除成功！");
        } catch (Exception e) {
            System.err.println("删除失敗: " + e.getMessage());
            e.printStackTrace();
            redirectAttributes.addFlashAttribute("error", "刪除失敗：" + e.getMessage());
        }
        return "redirect:/web/";
    }

    /**
     * 刪除單個附件
     */
    @GetMapping("/attachment/delete/{attachmentId}")
    public String deleteAttachment(@PathVariable Long attachmentId,
                                   @RequestParam Long announcementId,
                                   RedirectAttributes redirectAttributes) {
        try {
            System.out.println("=== 删除附件，ID: " + attachmentId + " ===");

            Attachment attachment = attachmentService.getAttachmentById(attachmentId);
            if (attachment == null) {
                redirectAttributes.addFlashAttribute("error", "附件不存在！");
                return "redirect:/web/edit/" + announcementId;
            }

            if (!attachment.getAnnouncementId().equals(announcementId)) {
                redirectAttributes.addFlashAttribute("error", "操作權限不足！");
                return "redirect:/web/edit/" + announcementId;
            }

            attachmentService.deleteAttachment(attachmentId);
            redirectAttributes.addFlashAttribute("message", "附件刪除成功！");
        } catch (Exception e) {
            System.err.println("删除附件失败: " + e.getMessage());
            e.printStackTrace();
            redirectAttributes.addFlashAttribute("error", "刪除附件失敗：" + e.getMessage());
        }
        return "redirect:/web/edit/" + announcementId;
    }

    /**
     * 下載附件
     */
    @GetMapping("/attachment/download/{attachmentId}")
    public void downloadAttachment(@PathVariable Long attachmentId, HttpServletResponse response) throws IOException {
        try {
            System.out.println("=== 下载附件，ID: " + attachmentId + " ===");

            Attachment attachment = attachmentService.getAttachmentById(attachmentId);
            if (attachment == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "附件不存在");
                return;
            }

            File file = new File(UPLOAD_DIR + attachment.getFilePath());
            if (!file.exists()) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "附件文件不存在");
                return;
            }

            // 設置 response
            response.setContentType("application/octet-stream");
            response.setCharacterEncoding("UTF-8");

            String encodedFileName = URLEncoder.encode(attachment.getOriginalName(), "UTF-8").replaceAll("\\+", "%20");
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
            System.err.println("下载附件失敗: " + e.getMessage());
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "下載失敗：" + e.getMessage());
        }
    }
}