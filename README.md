# shop_ban_dong_ho
#Nhóm 9 - Lập Trình Di Động HUIT K13
```lib/
│── screens/         # Chứa các màn hình chính của ứng dụng
│   │── trangchu.dart      # Màn hình Trang chủ
│   │── favorite.dart      # Màn hình Sản phẩm yêu thích
│   │── giohang.dart       # Màn hình Giỏ hàng
│   │── info.dart          # Màn hình Thông tin cá nhân
│   └── (các file màn hình khác do lập trình viên tự tạo)
│
│── widgets/         # Chứa các widget không phải Scaffold
│   │── appbar/            # Chứa AppBar cho từng màn hình chính
│   │   │── trangchu_appbar.dart
│   │   │── favorite_appbar.dart
│   │   │── giohang_appbar.dart
│   │   └── info_appbar.dart
│   └── (các widget khác do lập trình viên tự tạo)
│
│── util/            # Chứa các tiện ích hỗ trợ (hàm, cấu hình, v.v.)
│   └── (các file helper, format, constants, v.v.)
│
└── main.dart        # File khởi chạy ứng dụng 
```
## 🚀 Hướng dẫn làm việc

### 🔹 Phân chia màn hình
- Các màn hình chính (`trangchu.dart`, `favorite.dart`, `giohang.dart`, `info.dart`) đã được tạo sẵn.  
- Nếu bạn được giao một trong các màn hình này, hãy **code trực tiếp trong file tương ứng**.  
- Nếu cần tạo màn hình mới, hãy **tạo file mới trong `screens/` và phát triển độc lập**.  

### 🔹 Phân chia widget
- Các **AppBar** cho từng màn hình chính đã được tách riêng vào `widgets/appbar/`.  
- Các **widget chung** khác cũng nên đặt vào `widgets/` để tái sử dụng.  

### 🔹 Code hỗ trợ
- Các tiện ích (`helpers`, `format`, `constants`) nên được đặt trong thư mục `util/`.  

---

📢 **Khi merge code lại, tất cả các màn hình sẽ được liên kết bởi nhóm trưởng.**  
Vì vậy, hãy đảm bảo **code chạy độc lập, không ảnh hưởng đến các phần khác**. 🚀  


