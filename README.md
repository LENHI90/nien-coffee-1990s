# ☕ NIÊN COFFEE — Thập Niên 1990s
> *"Một ngụm cà phê – Một mảnh ký ức"*  
> Không gian lưu giữ thanh xuân, hoài niệm thập niên 90s và trải nghiệm kết nối chân thật (O2O).

---

## 🌟 Giới Thiệu Dự Án
**NIÊN COFFEE** là ứng dụng web kết hợp mô hình quán cà phê hoài niệm thập niên 1990s (Online-to-Offline):
- **Khách hàng tại quán (In-store)**: Quét mã QR tại bàn (`/ban/03`), gọi món hoài niệm, tham gia thử thách detox công nghệ "Góc Không Wifi" (đồng hồ cơ tích tắc 30 phút), viết bưu thiếp gửi bưu điện thực tế.
- **Sổ Niên Kỷ (Loyalty)**: Tích điểm theo số điện thoại (10.000đ = 20 Điểm Niên, tích lũy vĩnh viễn không hết hạn, đổi voucher 15.000đ từ 500 điểm).
- **Bộ Phận Pha Chế & Quản Lý (Admin KDS)**: Màn hình Barista KDS Kanban 3 cột trực quan (`/admin`), chuông báo ting-ting âm thanh thực khi có đơn mới, kiểm duyệt Bức Tường Ký Ức, và hàng đợi gửi bưu thiếp với cơ chế tự động xóa dữ liệu địa chỉ bảo mật (privacy purge).

---

## 📁 Cấu Trúc Dự Án
```text
BAI _ 1/
├── index.html              # Trang chủ khách hàng (Menu 22 món, Đồng hồ cơ 30m, Sổ Niên Kỷ, Bức tường ký ức)
├── admin.html              # Bảng điều khiển Barista KDS, Quản lý Bưu thiếp & Duyệt bài ký ức
├── stitch.html             # Màn hình trình diễn & đối chiếu giao diện Stitch
├── vercel.json             # Cấu hình routing Edge CDN & Clean URLs cho Vercel
├── supabase_schema.sql     # Schema cơ sở dữ liệu PostgreSQL cho Supabase (kèm trigger tự động xóa địa chỉ)
├── assets/                 # Thư mục hình ảnh món ăn hoài niệm thực tế & logo quán
│   └── menu/               # Ảnh chụp chân thực 22 món tuổi thơ
├── stitch_export/          # Bộ 4 màn hình Stitch nguyên bản
└── README.md               # Giới thiệu dự án
```

---

## 🚀 Triển Khai Lên Vercel (Production)
Dự án đã được cấu hình sẵn tệp `vercel.json` tối ưu cho Vercel Edge Network:
1. Đưa mã nguồn lên GitHub repository.
2. Đăng nhập vào [vercel.com](https://vercel.com) bằng GitHub.
3. Bấm **"Import"** repo `nien-coffee-1990s` ➔ Chọn Framework: **Other** ➔ Bấm **"Deploy"**.
4. Website sẽ online ngay lập tức với SSL miễn phí toàn cầu: `https://nien-coffee-1990s.vercel.app`.

---

## 🎯 Các Đường Dẫn Chính
- **Trang chủ quán**: `/`
- **KDS Pha chế & Quản lý**: `/admin`
- **Giao diện thiết kế Stitch**: `/stitch.html`
- **Gọi món tại bàn qua QR**: `/ban/01`, `/ban/02`, `/ban/03`...

---
*© 2026 NIÊN COFFEE. Bản quyền thuộc về Niên Quán.*
