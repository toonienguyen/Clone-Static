# STATIC SITE CLONER COLLECTION

10 bản script PowerShell clone website tĩnh bằng Wget, từ đơn giản nhất đến đầy đủ tính năng nhất. Mỗi bản chấm điểm riêng và ghi rõ dùng khi nào.

---

# 3.0 ORIGINAL EDITION

### Mô tả

Bản khai sinh của cả collection. Cực đơn giản: sửa URL và thư mục ngay trong code, chạy, xong.

### Tính năng

* URL và thư mục viết cứng trong code
* Tự cài Wget qua winget nếu máy chưa có
* Dùng bộ flag mirror chuẩn: `--mirror --convert-links --adjust-extension --page-requisites --no-parent`

### Điểm đánh giá

**8.5/10**

### Nên dùng khi

* Chỉ cào một lần rồi thôi, không cần chạy lại
* Site nhỏ, ít trang
* Muốn hiểu nhanh Wget hoạt động ra sao trước khi dùng bản phức tạp hơn
* Không cần log, không cần resume

---

# 3.1 ENHANCED EDITION

### Mô tả

Nâng cấp phần tìm `wget.exe` trên máy — dò qua 3 lớp (PATH hệ thống → WinGet Links → quét đệ quy WinGet Packages) thay vì chỉ tin vào PATH như 3.0.

### Tính năng

* Function `Get-WgetBinaryPath` dò 3 lớp
* Tự cài qua `GNU.Wget` nếu thiếu, rồi refresh PATH ngay trong session hiện tại
* Cấu hình tách riêng thành biến (`$TargetURL`, `$OutputDir`, `$UserAgent`) ở đầu file, dễ sửa hơn 3.0

### Điểm đánh giá

**8.8/10**

### Nên dùng khi

* Máy cài Wget qua winget nhưng hay gặp lỗi "không tìm thấy wget" ở các bản đơn giản hơn
* Muốn một bản sạch sẽ, dễ đọc, dễ sửa lại theo ý mình
* Chưa cần resume/retry — chỉ cần dò-wget đáng tin cậy hơn 3.0

---

# 3.1R REFINED EDITION

### Mô tả

Bản refine của 3.1 — giữ nguyên phần dò-wget 3 lớp, thêm khả năng phục hồi khi mạng chập chờn.

### Tính năng mới so với 3.1

* `--continue` — chạy lại không tải từ đầu
* `--retry-connrefused --tries=10` — tự thử lại khi bị từ chối kết nối
* `--timestamping` — chỉ tải file mới hơn bản đã có
* Log riêng ghi lại toàn bộ quá trình (`-o $LogFile`)

### Điểm đánh giá

**9.4/10**

### Nên dùng khi

* Site dung lượng lớn, cào một lần không xong
* Mạng nhà/wifi hay rớt giữa chừng, cần chạy lại nhiều lần mà không muốn tải lại từ đầu
* Muốn có log để xem lại đã tải được gì

---

# 3.6 ADVANCED EDITION

### Mô tả

Tập trung vào việc "cào được" trên internet thực tế — nhiều site chặn bot, có SSL lỗi, hoặc chặn qua robots.txt.

### Tính năng

* `--wait=1 --random-wait` — trễ ngẫu nhiên giữa các request, tránh bị site tự động chặn IP vì cào quá nhanh
* `--no-check-certificate` — vẫn cào được site có SSL tự ký hoặc chứng chỉ hết hạn
* `-e robots=off` — bỏ qua robots.txt khi cần lưu trữ toàn bộ

### Điểm đánh giá

**8.9/10**

### Nên dùng khi

* Site cũ, hosting rẻ, SSL hay bị lỗi
* Từng bị chặn 403 khi dùng các bản không có `--wait`
* Cần cào cả những trang bị robots.txt chặn (lưu trữ cá nhân, không phải để phát tán lại)

---

# 3.6 ULTIMATE EDITION

### Mô tả

Bản hội tụ — gộp toàn bộ tính năng đã phân mảnh ở 3.1R (resume/retry/log) và 3.6 Advanced (rate-limit/no-check-cert/robots-off) vào một file duy nhất.

### Tính năng

* Tất cả tính năng của 3.6 Advanced
* Resume, Retry, Timestamping, Log file như 3.1R
* Thêm `--timeout=30` tổng thể

### Điểm đánh giá

**9.6/10**

### Nên dùng khi

* Cần một bản "được việc" duy nhất, không muốn nhớ phải dùng bản nào cho tình huống nào trong dòng 3.x
* Sao lưu định kỳ, chạy lại nhiều lần theo thời gian
* Đỉnh cao của dòng 3.x — nếu chỉ chọn 1 bản trong dòng 3.x thì chọn bản này

---

# 4.0 INTERACTIVE EDITION

### Mô tả

Bước ngoặt lớn: bỏ hẳn việc sửa URL trong code, chuyển sang hỏi trực tiếp khi chạy. Tự đặt tên thư mục theo domain luôn, không cần tự nghĩ tên.

### Tính năng

* `Read-Host "Nhap URL website"` — nhập URL mỗi lần chạy
* Validate URL bằng `[System.Uri]` — nhập sai định dạng thì báo lỗi ngay, không chạy tiếp cào linh tinh
* Tự tạo thư mục theo hostname (`example.com` → thư mục `example.com`)

### Điểm đánh giá

**8.7/10**

### Nên dùng khi

* Dùng thường xuyên, mỗi lần một site khác nhau
* Lười mở editor sửa URL mỗi lần
* Không cần domain discovery (CDN) — nếu cần thì dùng 4.5/4.6/4.9 thay vì bản này

---

# 4.5 DAILY EDITION

### Mô tả

Kế thừa toàn bộ ưu điểm interactive của 4.0, cộng thêm đầy đủ resume/retry/log của dòng 3.6 Ultimate — bản "dùng hằng ngày" đúng nghĩa.

### Tính năng

* Interactive như 4.0
* Resume, Retry, Logging, Timeout như 3.6 Ultimate
* Auto folder theo domain

### Điểm đánh giá

**9.3/10**

### Nên dùng khi

* Dùng mỗi ngày, không muốn nhớ phải chỉnh gì
* Cân bằng giữa dễ dùng và đầy đủ tính năng
* Chưa cần domain discovery cho CDN

---

# 4.6 CDN EDITION

### Mô tả

Vá đúng lỗ hổng lớn nhất của 4.5: nhiều site hiện đại (build bằng Astro, Vite, Docusaurus, hoặc host trên Cloudflare Pages/GitHub Pages) tách ảnh/CSS/JS ra subdomain CDN riêng — nếu không khai báo thêm, Wget sẽ bỏ sót vì `--no-parent` mặc định chỉ cào trong đúng domain gốc.

### Tính năng mới so với 4.5

* Tự thêm `www.`, `cdn.`, `static.`, `img.`, `images.`, `assets.` vào danh sách domain được phép cào
* `-H --domains=...` — cho phép Wget nhảy sang các subdomain đó khi cào

### Điểm đánh giá

**9.5/10**

### Nên dùng khi

* Site trông "thiếu ảnh, thiếu style" khi cào bằng bản 4.5
* Site build bằng framework JS hiện đại (dù bản thân trang là site tĩnh, không phải SPA)
* Documentation site, landing page, Jamstack

---

# 4.9 ARCHIVE EDITION

### Mô tả

Bản đầy đủ nhất về phạm vi tính năng — mở rộng domain discovery, chia nhỏ timeout theo từng giai đoạn kết nối, và đặc biệt là tự sinh báo cáo tổng kết sau khi chạy xong.

### Tính năng mới so với 4.6

* Domain discovery mở rộng thêm `media.`, `files.` (tổng 7 subdomain)
* Timeout tách riêng: `--dns-timeout --connect-timeout --read-timeout` thay vì chỉ một `--timeout` chung
* Tự sinh file `summary_TIMESTAMP.txt` — bao nhiêu file, bao nhiêu MB, chạy mất bao lâu
* Log tách vào thư mục `_logs` riêng, không lẫn với file site đã cào

### Điểm đánh giá

**9.7/10**

### Nên dùng khi

* Cần lưu trữ nghiêm túc, có bằng chứng/báo cáo để xem lại sau này
* Digital archivist, backup định kỳ
* Cần domain discovery rộng nhất trong cả collection

---

# 5.0 HYBRID LITE ⭐ MỚI NHẤT

### Mô tả

Vá đúng khoảng trống cuối cùng của 4.9: **biết được kết quả cào có đáng tin hay không**, thay vì chỉ đếm số file/dung lượng rồi tự suy ra "chắc là ổn".

### Tính năng mới so với 4.9

* **Bước Validate riêng sau khi cào xong:**
  * Đọc log tìm các dòng lỗi HTTP (`ERROR 404`, `ERROR 500`...) và in mẫu tối đa 10 dòng thẳng ra màn hình
  * Kiểm tra `index.html`/`index.htm` có thực sự tồn tại ở thư mục gốc — dấu hiệu rõ nhất cho biết trang chủ có tải được hay không
* **Báo trạng thái 3 màu ngay khi chạy xong:**
  * 🔴 Đỏ — không tìm thấy trang chủ (nghiêm trọng, cần xem lại ngay)
  * 🟡 Vàng — có lỗi HTTP nhưng trang chủ vẫn tồn tại (nên xem log kỹ hơn)
  * 🟢 Xanh — sạch, không phát hiện vấn đề
* Summary report bổ sung 3 trường: Validation, Index page, HTTP errors

### Điểm đánh giá

**9.8/10** — điểm cao nhất trong collection hiện tại

### Nên dùng khi

* Cần chắc chắn 100%, không muốn tải xong rồi mới phát hiện site lỗi giữa chừng mà không biết
* Đã quen dùng 4.9 và muốn thêm một lớp an tâm mà không cần đổi cách dùng
* Mặc định nên dùng bản này nếu không chắc chọn bản nào

### Lưu ý quan trọng

Bước validate chỉ kiểm tra **sự tồn tại** của file `index.html`, không kiểm tra **nội dung bên trong** file đó. Nếu site đích là SPA (React/Vue/Next.js...) và HTML gốc chỉ là vỏ rỗng chờ JavaScript render, bản này vẫn báo 🟢 "OK" vì file có tồn tại — dù nội dung thực tế trống rỗng. Xem mục roadmap bên dưới.

---

# BẢNG TRA NHANH

| Tình huống | Bản nên dùng | Điểm |
|---|---|---|
| Chỉ cào 1 lần, xong luôn, không cầu kỳ | 3.0 | 8.5 |
| Hay lỗi "không tìm thấy wget" | 3.1 | 8.8 |
| Site to, mạng yếu, cần chạy lại nhiều lần | 3.1R | 9.4 |
| Hay bị chặn 403, SSL lỗi | 3.6 Advanced | 8.9 |
| Cần 1 bản "được việc" duy nhất trong dòng 3.x | 3.6 Ultimate | 9.6 |
| Dùng thường xuyên, lười sửa code | 4.0 | 8.7 |
| Dùng hằng ngày, cân bằng đủ thứ | 4.5 | 9.3 |
| Site thiếu ảnh/style do CDN riêng | 4.6 | 9.5 |
| Lưu trữ nghiêm túc, cần báo cáo | 4.9 | 9.7 |
| Cần chắc chắn 100% site tải đúng | **5.0 Hybrid Lite** | **9.8** |

Không chắc chọn gì → dùng **5.0 Hybrid Lite**, nó gần như bao trọn tính năng các bản 4.x còn lại, chỉ đánh đổi là phải nhập URL mỗi lần chạy (không tự động hoá theo lịch được).

---

# 🔮 GHI CHÚ — 5.0 HYBRID NẶNG (Project Phoenix), CHƯA CÓ CODE

Khác hẳn 5.0 Hybrid Lite ở trên (đã chạy được), đây là hướng phát triển xa hơn, hiện **vẫn chỉ là ý tưởng roadmap**, chưa có một dòng code nào.

### Mục tiêu

Xử lý được cả site dạng SPA (React, Vue, Next.js, Svelte...) — thứ mà Wget không bao giờ làm được, vì Wget chỉ tải HTML gốc từ server chứ không chạy JavaScript. Với site SPA, HTML gốc thường chỉ là một shell rỗng (`<div id="root"></div>`), toàn bộ nội dung thật được JS dựng lên sau khi trang chạy trong trình duyệt.

### Cần thêm gì

Không thể chỉ dùng PowerShell/Wget để làm việc này — bắt buộc phải có một trình duyệt thật (hoặc giả lập trình duyệt) đứng ra render trang trước, rồi mới chụp lại HTML đã hoàn chỉnh. Về công cụ, thực chất là chọn 1 trong 2 cặp:

* **Playwright (qua Node.js hoặc Python)** — khuyến nghị, vì tự quản lý trình duyệt khi cài, có sẵn cách chờ trang render xong (`waitForLoadState('networkidle')`) mà không phải tự đoán thời gian chờ.
* **Selenium + ChromeDriver** — vẫn dùng được nhưng phải tự đồng bộ version ChromeDriver khớp Chrome cài trên máy, dễ lỗi lệch version hơn.

Cách render-rồi-chụp-lại này về kỹ thuật hoạt động **chung cho mọi framework** (React/Vue/Next.js/Svelte đều xử lý như nhau) — không phải 4 việc riêng biệt cần code 4 lần, dù nhìn danh sách roadmap ban đầu có thể tưởng vậy.

### Việc thực sự cần làm

1. **SPA Detection** — bước tự động nhận biết một site có phải SPA hay không trước khi quyết định dùng Wget hay Playwright
2. **Script render riêng bằng Node.js/Playwright** — PowerShell gọi ra ngoài (`node crawl.js <url>`), nhận lại HTML đã hoàn chỉnh
3. **Smart Asset Discovery** — sau khi có HTML đã render, vẫn cần tải các asset con (CSS/JS/ảnh) xuống đĩa theo cấu trúc mirror, việc mà Playwright tự nó không làm sẵn
4. Tích hợp lại vào luồng PowerShell hiện có, tận dụng phần dò-wget/domain-discovery/validate đã có sẵn ở 5.0 Lite cho phần asset còn lại

### Kết luận

Đây là dự án riêng, khối lượng công việc lớn hơn nhiều so với bước từ 4.9 lên 5.0 Lite — không phải một bản nâng cấp nhỏ. Khi nào triển khai thật, nên đánh số **6.0** thay vì dùng chung số 5.0 với bản Lite, để tránh nhầm giữa "cái đã chạy ổn định" và "cái đang trong giai đoạn ý tưởng".

irm "link_raw" | iex
