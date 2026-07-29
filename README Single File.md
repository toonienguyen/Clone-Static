# Fix_SingleFile_Links.ps1

Dọn dẹp các trang truyện đã lưu tay bằng extension SingleFile: đổi tên file theo đúng
thứ tự trang, và sửa link chuyển trang cho trỏ vào file local thay vì ra lại website gốc.

## Cấu trúc thư mục bắt buộc

```
KhoTruyen                          <- thư mục GỐC, trỏ vào đây khi chạy
├── Truyen_A                       <- 1 thư mục = 1 truyện
│   ├── (file SingleFile lưu, tên gì cũng được, ví dụ "Cứu Gái Đụng Xe.html")
│   ├── (file trang 2, tên gì cũng được)
│   └── (file trang 3, tên gì cũng được)
├── Truyen_B
│   └── ...
└── ...
```

**Phạm vi xử lý:** script chỉ quét các thư mục con nằm **ngay bên dưới** thư mục gốc
(1 cấp, không quét sâu hơn). Mỗi thư mục con đó = đúng 1 truyện, xử lý **hoàn toàn độc
lập** với các thư mục khác — không có chuyện file/link của truyện này ảnh hưởng sang
truyện kia. File nằm rải rác ngoài mọi thư mục con (trực tiếp trong `KhoTruyen`, ví dụ
`index.html`) sẽ không được đụng tới.

## Nó làm gì, theo đúng thứ tự

Với **mỗi thư mục con** (mỗi truyện), chạy tuần tự 2 bước:

### Bước 1 — Đổi tên file theo đúng thứ tự trang

Mọi file `.html` do SingleFile lưu đều có sẵn 1 dòng comment ở đầu file:
```
<!-- Page saved with SingleFile
 url: https://giaitri321.vip/doc-truyen/ten-bai.html/2
 ...
-->
```

Script đọc dòng `url:` này để tính số trang:
- URL kết thúc bằng `/<số>` (ví dụ `.../ten-bai.html/2`) → trang **2**
- URL không có số ở cuối (ví dụ `.../ten-bai.html`) → trang **1** (mặc định)

Sau đó đổi tên file thành `Trang_1.html`, `Trang_2.html`, `Trang_3.html`... theo đúng số
trang tính được — không quan tâm SingleFile đặt tên gốc là gì.

### Bước 2 — Sửa link chuyển trang

Đọc lại đúng dòng `url:` đó (giờ đã gắn với tên file mới), dựng bảng
`URL gốc -> Trang_N.html`, rồi quét toàn bộ nội dung từng file, thay mọi `href` trỏ tới
1 trong các URL đó bằng tên file local tương ứng. Xử lý URL dài trước, URL ngắn sau
(để URL không số `.../ten-bai.html` không bị khớp nhầm vào giữa URL có số
`.../ten-bai.html/2`).

## Chặn lỗi âm thầm

- **Trùng số trang** trong cùng 1 thư mục (ví dụ lỡ lưu trang 2 hai lần với 2 tên khác
  nhau): script **dừng ngay, báo lỗi rõ tên 2 file trùng nhau** — không tự ý ghi đè hay
  đoán mò.
- **Tên đích đã tồn tại sẵn** vì lý do khác (ví dụ đã có sẵn 1 file tên `Trang_2.html`
  không liên quan): PowerShell tự chặn ghi đè theo mặc định, script không ép buộc
  `-Force`, nên sẽ báo lỗi tự nhiên thay vì âm thầm mất dữ liệu.
- File nào **không có dòng `url:`** của SingleFile (không phải file SingleFile lưu ra):
  bị bỏ qua, không đổi tên, không tính vào bảng sửa link.

## Cách chạy

**Cách 1 — tải file .ps1 về máy, chạy trực tiếp:**
```powershell
.\Fix_SingleFile_Links.ps1
```
Nếu bị chặn ("execution policy"):
```powershell
powershell -ExecutionPolicy Bypass -File ".\Fix_SingleFile_Links.ps1"
```

**Cách 2 — chạy thẳng từ URL raw trên GitHub (không cần tải về):**
```powershell
irm https://raw.githubusercontent.com/<user>/<repo>/<branch>/Fix_SingleFile_Links.ps1 | iex
```
Lấy đúng URL dạng `raw.githubusercontent.com` (bấm nút "Raw" trên GitHub), repo phải để
Public. Cách này không bị chặn bởi execution policy vì không chạy file, chỉ chạy đoạn
text lấy về trong phiên PowerShell hiện tại.

## Đổi thư mục gốc

Mặc định trỏ vào `Desktop\KhoTruyen`. Muốn đổi, set biến môi trường **trước khi** chạy
lệnh (cùng 1 phiên PowerShell):
```powershell
$env:KHOTRUYEN_PATH = "D:\MyStories"
```

## Giả định / giới hạn

- Chỉ nhận diện đúng mẫu URL phân trang dạng `.../ten-bai.html/<số>` (đã xác nhận qua
  file thật của site giaitri321.vip, plugin WP-PageNavi). Site khác dùng mẫu URL phân
  trang khác thì cần chỉnh lại regex `-match '/(\d+)$'` trong script.
- Không đụng tới nội dung/hiển thị của trang, chỉ đổi tên file và sửa `href`.
