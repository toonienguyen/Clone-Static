# Static Site Cloner for Windows

## Giới thiệu

Static Site Cloner là bộ script PowerShell sử dụng GNU Wget để tải và lưu trữ website tĩnh phục vụ mục đích:

* Lưu trữ website offline
* Nghiên cứu cấu trúc frontend
* Sao lưu website tĩnh
* Phân tích HTML/CSS/JS
* Tạo bản snapshot website

Các script được tối ưu cho:

* Windows 10
* Windows 11
* PowerShell
* Cloudflare Pages
* GitHub Pages
* Hugo
* Jekyll
* Astro
* WordPress Public
* Landing Page
* Documentation Site

---

## Các phiên bản

### 4.5 Daily Edition

Phiên bản sử dụng hằng ngày.

Tính năng:

* Auto Install Wget
* Auto Create Output Folder
* Retry Connection
* Resume Download
* Timestamp Update
* Logging

Phù hợp:

* Blog
* Portfolio
* Landing Page
* Docs Site
* Website tĩnh thông thường

---

### 4.6 CDN Edition

Nâng cấp từ 4.5.

Bổ sung:

* CDN Support
* Multi Host Support
* Common Static Domain Support

Ví dụ:

```text
example.com
cdn.example.com
img.example.com
static.example.com
assets.example.com
```

Phù hợp:

* Cloudflare Pages
* Modern Static Sites
* Static Sites sử dụng CDN

---

### 4.9 Archive Edition

Phiên bản mạnh nhất trong dòng Wget.

Bổ sung:

* DNS Timeout
* Connect Timeout
* Read Timeout
* Compression Support
* Detailed Logging
* Download Statistics
* Archive Report
* Session History

Phù hợp:

* Long-Term Backup
* Website Archiving
* Research
* Digital Preservation

---

## Yêu cầu hệ thống

* Windows 10 hoặc Windows 11
* PowerShell
* Internet Connection
* Winget

Không cần cài Wget thủ công.

Script sẽ tự động cài đặt khi cần.

---

## Cách sử dụng

Mở PowerShell:

```powershell
.\clone-4.9.ps1
```

Nhập URL:

```text
https://example.com
```

Script sẽ tự động:

1. Kiểm tra Wget
2. Cài Wget nếu thiếu
3. Tạo thư mục lưu trữ
4. Clone website
5. Sinh log
6. Sinh báo cáo

---

## Kết quả

Ví dụ:

```text
Desktop/
└── example.com/
    ├── index.html
    ├── assets/
    ├── images/
    ├── css/
    ├── js/
    ├── wget.log
    └── _logs/
```

---

## Các loại website hoạt động tốt

* HTML Site
* CSS Site
* Static JavaScript Site
* GitHub Pages
* Cloudflare Pages
* Hugo
* Jekyll
* Astro SSR
* Docusaurus
* MkDocs
* WordPress Public

---

## Hạn chế

Wget không phải trình duyệt.

Một số website hiện đại có thể không clone đầy đủ:

* React SPA
* Vue SPA
* Angular SPA
* Next.js Client Side
* Dashboard
* Website Login Required

---

## Khi nào dùng 4.5

Nếu muốn:

* Nhanh
* Gọn
* Dễ sử dụng

---

## Khi nào dùng 4.6

Nếu website:

* Có CDN
* Có nhiều host tài nguyên

---

## Khi nào dùng 4.9

Nếu muốn:

* Lưu trữ lâu dài
* Backup website
* Tỷ lệ thành công cao nhất trong họ Wget

---

## Giấy phép

Sử dụng GNU Wget.

Tuân thủ điều khoản sử dụng của website được tải về.

Người dùng chịu trách nhiệm đảm bảo việc sao chép nội dung phù hợp với pháp luật, bản quyền và điều khoản của website đích.
