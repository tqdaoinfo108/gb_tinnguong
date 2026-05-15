# Mobile Notification App

_Started 2026-05-15 05:22 UTC_

---

## User

Với chức năng hiện tại 
và dựa vào markdown style 
hãy tạo UI UX Cho mobile
Ứng dụng chủ yếu để hiển thị, thông báo, không có chức năng xoá sửa

## Assistant

_[tool: update_todos]_

Tôi sẽ tạo UI/UX mobile cho TinNguongGIS với phong cách tối giản, photography-first theo markdown style guide — nhưng tránh sao chép trực tiếp UI của bất kỳ thương hiệu nào. Tập trung vào các màn hình hiển thị + thông báo (read-only).

Sử dụng token màu của TinNguong (Primary #3B6FA0, Gold #C9A84C, Parchment #F4F2EC) với rhythm "tile-based" và typography Inter (thay thế mở cho SF Pro như markdown gợi ý).

_[tool: copy_starter_component]_

_[tool: copy_starter_component]_

_[tool: read_file]_

_[tool: read_file]_

_[tool: write_file]_

Tôi sẽ xây dựng các màn hình. Bắt đầu với design tokens và screen components.

_[tool: write_file]_

_[tool: write_file]_

_[tool: write_file]_

_[tool: write_file]_

_[tool: write_file]_

_[tool: write_file]_

_[tool: write_file]_

Bây giờ tạo file HTML chính kết hợp tất cả vào design canvas:

_[tool: grep]_

_[tool: show_html]_

_[tool: done]_

_[tool: fork_verifier_agent]_

_[tool: update_todos]_

Đã tạo xong **14 màn hình mobile** cho TinNguongGIS, sắp xếp trên design canvas thành 6 nhóm:

**Trang chính** — Trang chủ (hero tối + KPI + cảnh báo), Bản đồ GIS (full-bleed + bottom sheet), Bản đồ có popup cơ sở.

**Cơ sở & Chức sắc** — Danh sách cơ sở (filter chips + card có banner), Chi tiết cơ sở (hero ảnh, info table, album, hồ sơ, lịch sử sửa chữa), Chi tiết chức sắc (header dark).

**Lễ hội** — Danh sách sự kiện (toggle + alert chưa có phép), Lịch năm (grid 12 tháng), Chi tiết sự kiện (timeline chương trình).

**Tin tức & Thông báo** — Tin tức (featured + filter), Bài viết (pull-quote vàng), Thông báo (group theo thời gian + badge unread).

**Album & Thống kê** — Album ảnh (grid 3 cột), Dashboard (KPI hero + bar + donut + area chart).

### Hệ thống thiết kế đã áp dụng
- **Một accent duy nhất** `#3B6FA0` cho mọi tín hiệu hành động — pill CTA, link, focus
- **Gold** `#C9A84C` chỉ ở highlight nhỏ (border-left quote, badge "đã cấp phép")
- **Parchment** `#F4F2EC` làm nền sáng, **Ink dark** `#1E2D3D` cho tile editorial
- **Typography Inter** — 17px body, tracking âm trên display sizes, không có weight 500
- **Bottom tab bar 5 mục** (Trang chủ · Bản đồ · Sự kiện · Tin tức · Thông báo) với glass blur
- **Không có chức năng xoá/sửa** — mọi card chỉ có icon Xem, Chỉ đường, Tải về, Bookmark
- **Placeholder ảnh** dạng kẻ sọc + nhãn monospace để bạn tự thay ảnh thật

Bạn có thể kéo các artboard để sắp xếp lại hoặc bấm phóng to để xem fullscreen từng màn hình. Nếu muốn tinh chỉnh palette, đổi nhóm chức năng, hoặc thêm các state khác (loading, empty, error) cứ cho mình biết.

