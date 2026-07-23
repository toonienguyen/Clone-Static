# STATIC SITE CLONER COLLECTION

## The Complete Evolution (3.0 → 4.9)

---

# 3.0 ORIGINAL EDITION

### Mục tiêu

Tạo một script PowerShell cực đơn giản để clone website tĩnh bằng GNU Wget.

### Đặc điểm

* URL viết cứng trong code
* Thư mục lưu viết cứng trong code
* Tự cài Wget nếu thiếu
* Dùng bộ flag mirror chuẩn của Wget

### Ưu điểm

* Ngắn gọn
* Dễ hiểu
* Rất ổn định
* Ít lỗi

### Nhược điểm

* Phải sửa URL thủ công
* Phải sửa thư mục thủ công
* Không log
* Không resume

### Điểm đánh giá

8.8/10

### Phù hợp

* Người mới học Wget
* Clone blog đơn giản
* Website HTML/CSS truyền thống

---

# 3.1 ENHANCED EDITION

### Mục tiêu

Nâng cấp khả năng phát hiện Wget trên Windows.

### Đặc điểm

* Dò PATH
* Dò WinGet Links
* Dò WinGet Packages
* Tự động cài đặt nếu thiếu

### Ưu điểm

* Chuyên nghiệp hơn 3.0
* Khả năng chạy trên nhiều máy cao hơn
* Quản lý cấu hình tốt hơn

### Nhược điểm

* Vẫn sửa URL thủ công
* Chưa có log
* Chưa có retry

### Điểm đánh giá

9.2/10

### Phù hợp

* Người dùng Windows 10
* Người muốn một script sạch sẽ

---

# 3.1R REFINED EDITION

### Mục tiêu

Hoàn thiện 3.1 mà vẫn giữ nguyên triết lý tối giản.

### Tính năng mới

* Resume
* Retry
* Timestamping
* Log file

### Ưu điểm

* Chạy lại không tải từ đầu
* Khả năng phục hồi lỗi mạng cao
* Có lịch sử hoạt động

### Nhược điểm

* Chưa có chống rate-limit
* Chưa có robots off

### Điểm đánh giá

9.4/10

### Phù hợp

* Clone website dung lượng lớn
* Kết nối mạng không ổn định

---

# 3.6 ADVANCED EDITION

### Mục tiêu

Tăng tỷ lệ clone thành công trên Internet thực tế.

### Tính năng mới

* --wait=1
* --random-wait
* --no-check-certificate
* robots=off

### Ưu điểm

* Ít bị chặn hơn
* Hỗ trợ website SSL lỗi
* Vượt robots.txt

### Nhược điểm

* Chưa có resume
* Chưa có log
* Chưa có retry

### Điểm đánh giá

9.3/10

### Phù hợp

* Website cũ
* Shared Hosting
* Blog cá nhân

---

# 3.6 ULTIMATE EDITION

### Mục tiêu

Phiên bản mạnh nhất của dòng 3.x.

### Bao gồm

* Tất cả tính năng 3.6
* Resume
* Retry
* Timestamping
* Log file
* Timeout

### Ưu điểm

* Rất ổn định
* Tỷ lệ thành công cao
* Không phụ thuộc công cụ khác

### Nhược điểm

* Vẫn sửa URL thủ công

### Điểm đánh giá

9.5/10

### Phù hợp

* Người dùng chuyên nghiệp
* Sao lưu website định kỳ

---

# 4.0 INTERACTIVE EDITION

### Mục tiêu

Biến script thành công cụ thực thụ.

### Tính năng mới

* Nhập URL khi chạy
* Tự tạo thư mục theo domain
* Không cần sửa code

### Ví dụ

Nhập:

https://example.com

Tự tạo:

Desktop\example.com

### Ưu điểm

* Dễ sử dụng
* Không cần mở editor

### Nhược điểm

* Chưa tối ưu CDN

### Điểm đánh giá

9.5/10

### Phù hợp

* Người dùng phổ thông
* Sử dụng hằng ngày

---

# 4.5 DAILY EDITION

### Mục tiêu

Bản sử dụng hằng ngày.

### Tính năng

* Resume
* Retry
* Logging
* Auto Folder
* Timeout

### Ưu điểm

* Cân bằng
* Nhanh
* Đơn giản

### Nhược điểm

* Chưa tối ưu CDN lớn

### Điểm đánh giá

9.6/10

### Phù hợp

* Blogger
* Webmaster
* Nhà phát triển Frontend

---

# 4.6 CDN EDITION

### Mục tiêu

Tối ưu website hiện đại.

### Tính năng mới

* Hỗ trợ CDN
* Cloudflare Pages
* GitHub Pages
* Astro
* Vite
* Docusaurus

### Ưu điểm

* Clone asset đầy đủ hơn
* Hợp với website hiện đại

### Nhược điểm

* Phức tạp hơn 4.5

### Điểm đánh giá

9.8/10

### Phù hợp

* Documentation Site
* Landing Page
* Jamstack

### Danh hiệu

Best Overall Edition

---

# 4.9 ARCHIVE EDITION

### Mục tiêu

Lưu trữ website lâu dài.

### Tính năng

* Logging nâng cao
* Resume mạnh
* Timestamping
* Archive Friendly
* Long-Term Backup

### Ưu điểm

* Đáng tin cậy nhất
* Tối ưu cho mirror lâu dài

### Nhược điểm

* Nhiều tùy chọn hơn mức cần thiết với người mới

### Điểm đánh giá

9.9/10

### Phù hợp

* Digital Archivist
* Backup Website
* Long-Term Storage

### Danh hiệu

Most Powerful Edition

---

# HALL OF FAME

🥉 3.0 ORIGINAL

Bản khai sinh.

---

🥈 3.6 ULTIMATE

Đỉnh cao của dòng 3.x.

---

🥇 4.6 CDN EDITION

Phiên bản cân bằng nhất.

---

👑 4.9 ARCHIVE EDITION

Phiên bản mạnh nhất toàn bộ bộ sưu tập.

---

# FUTURE ROADMAP

5.0 HYBRID EDITION (Ý tưởng)

Wget
+
Headless Browser
+
Dynamic Rendering Detection
+
Asset Discovery

Mục tiêu:

* Hỗ trợ tốt hơn website SPA
* React
* Vue
* Angular
* Svelte
* Next.js

Trạng thái:

Concept / Experimental
::

Muốn vui vẻ hơn nữa thì bộ README này còn có thể làm kiểu "lịch sử tiến hóa Pokémon" từ 3.0 → 4.9 với changelog từng đời, ngày phát hành giả lập và bảng so sánh tính năng đầy đủ như một dự án GitHub thật. 😆
