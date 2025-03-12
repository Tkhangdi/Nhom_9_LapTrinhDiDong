import 'package:shop_ban_dong_ho/models/SanPhamGio.dart';
import 'package:flutter/material.dart';
import '../models/DongHo.dart'; // Giả sử lớp DongHo đã được định nghĩa ở nơi khác

class GioHang extends StatefulWidget {
  const GioHang({super.key});

  @override
  _GioHangState createState() => _GioHangState();

  static void themVaoGio(DongHo dh, Function update) {
    update(dh);
  }
}

class _GioHangState extends State<GioHang> {
  List<SanPhamGio> danhSachSanPham = [
    SanPhamGio(
      sanPham: DongHo(
        id: "SP001",
        ten: "Đồng Hồ Rolex",
        thuongHieu: "Rolex",
        gia: 5000.0,
        hinhAnh: "https://example.com/rolex.png",
        moTa: "Đồng hồ Rolex sang trọng, chất lượng cao.",
        soLuong: 10,
      ),
      soLuong: 1,
    ),
    SanPhamGio(
      sanPham: DongHo(
        id: "SP002",
        ten: "Đồng Hồ Omega",
        thuongHieu: "Omega",
        gia: 4000.0,
        hinhAnh: "https://example.com/omega.png",
        moTa: "Đồng hồ Omega bền bỉ, đẳng cấp.",
        soLuong: 5,
      ),
      soLuong: 1,
    ),
  ];

  bool isAllSelected = false; // Kiểm tra xem tất cả sản phẩm có được chọn không

  // Thêm sản phẩm vào giỏ
  void themVaoGio(DongHo sanPham) {
    setState(() {
      var sanPhamTonTai = danhSachSanPham.firstWhere(
        (item) => item.sanPham.id == sanPham.id,
        orElse: () => SanPhamGio(sanPham: sanPham, soLuong: 0),
      );

      if (sanPhamTonTai.soLuong == 0) {
        danhSachSanPham.add(SanPhamGio(sanPham: sanPham, soLuong: 1));
      } else {
        sanPhamTonTai.soLuong += 1;
      }
    });
  }

  // Xóa sản phẩm khỏi giỏ
  void xoaKhoiGio(SanPhamGio item) {
    setState(() {
      danhSachSanPham.remove(item);
    });
  }

  // Điều chỉnh số lượng sản phẩm trong giỏ
  void dieuChinhSoLuong(SanPhamGio item, int soLuongMoi) {
    setState(() {
      if (soLuongMoi <= 0) {
        danhSachSanPham.remove(item);
      } else {
        item.soLuong = soLuongMoi;
      }
    });
  }

  // Tính tổng tiền của giỏ hàng
  double tinhTongTien() {
    double tongTien = 0;
    for (var item in danhSachSanPham) {
      if (item.isSelected) {
        tongTien += item.sanPham.gia * item.soLuong;
      }
    }
    return tongTien;
  }

  // Chọn tất cả sản phẩm trong giỏ
  void chonTatCa() {
    setState(() {
      isAllSelected = !isAllSelected;
      for (var item in danhSachSanPham) {
        item.isSelected = isAllSelected;
      }
    });
  }

  // Xóa tất cả sản phẩm được chọn
  void xoaTatCa() {
    setState(() {
      danhSachSanPham.removeWhere((item) => item.isSelected);
    });
  }

  // Xử lý thanh toán
  void thanhToan() {
    double tongTien = tinhTongTien();
    if (tongTien > 0) {
      // Thực hiện hành động thanh toán (mô phỏng)
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Thanh Toán Thành Công"),
            content: Text("Tổng tiền: \$${tongTien.toStringAsFixed(2)}"),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("OK"),
              ),
            ],
          );
        },
      );
    } else {
      // Nếu không có sản phẩm nào được chọn
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Lỗi"),
            content: const Text("Giỏ hàng không có sản phẩm để thanh toán!"),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("OK"),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return danhSachSanPham.isEmpty
        ? Center(child: const Text("Giỏ hàng trống!"))
        : Column(
          children: [
            // Chọn tất cả sản phẩm
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Checkbox(
                        value: isAllSelected,
                        onChanged: (value) {
                          chonTatCa();
                        },
                      ),
                      const Text("Chọn tất cả"),
                    ],
                  ),
                  ElevatedButton(
                    onPressed: xoaTatCa,
                    child: const Text("Xóa tất cả"),
                    style: ElevatedButton.styleFrom(
                      textStyle: const TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),
            // Danh sách sản phẩm trong giỏ
            Expanded(
              child: ListView.builder(
                itemCount: danhSachSanPham.length,
                itemBuilder: (context, index) {
                  final sanPhamGio = danhSachSanPham[index];
                  return ListTile(
                    leading: Image.network(
                      sanPhamGio.sanPham.hinhAnh,
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                    ),
                    title: Text(sanPhamGio.sanPham.ten),
                    subtitle: Text("Giá: \$${sanPhamGio.sanPham.gia}"),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Checkbox(
                          value: sanPhamGio.isSelected,
                          onChanged: (value) {
                            setState(() {
                              sanPhamGio.isSelected = value!;
                              isAllSelected = danhSachSanPham.every(
                                (item) => item.isSelected,
                              );
                            });
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.remove),
                          onPressed: () {
                            dieuChinhSoLuong(
                              sanPhamGio,
                              sanPhamGio.soLuong - 1,
                            );
                          },
                        ),
                        Text("${sanPhamGio.soLuong}"),
                        IconButton(
                          icon: const Icon(Icons.add),
                          onPressed: () {
                            dieuChinhSoLuong(
                              sanPhamGio,
                              sanPhamGio.soLuong + 1,
                            );
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () {
                            xoaKhoiGio(sanPhamGio);
                          },
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            // Hiển thị tổng tiền
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Tổng tiền:",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "\$${tinhTongTien().toStringAsFixed(2)}",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
            ),
            // Nút thanh toán
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: ElevatedButton(
                onPressed: thanhToan,
                child: const Text("Thanh Toán"),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),

                  textStyle: const TextStyle(fontSize: 18),
                ),
              ),
            ),
          ],
        );
  }
}
