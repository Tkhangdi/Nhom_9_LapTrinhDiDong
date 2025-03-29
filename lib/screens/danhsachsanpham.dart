import 'package:shop_ban_dong_ho/models/CartItem.dart';
import 'package:flutter/material.dart';
import 'Chitietsanpham.dart';
import 'package:shop_ban_dong_ho/models/Cart.dart';

class DanhSachSanPham extends StatefulWidget {
  const DanhSachSanPham({super.key});

  @override
  State<DanhSachSanPham> createState() => _DanhSachSanPhamState();
}

class _DanhSachSanPhamState extends State<DanhSachSanPham> {
  final Cart gioHang = Cart(); // Thêm biến giỏ hàng

  List<CartItem> danhSachDongHo = [
    CartItem(
      id: '1',
      ten: 'Rolex Submariner',
      thuongHieu: 'Rolex',
      gia: 8500000.00,
      hinhAnh: 'assets/product/dong_ho_Rolex_Submariner.jpg',
      moTa: 'Đồng hồ thể thao sang trọng.',
      soLuong: 1,
    ),
    CartItem(
      id: '2',
      ten: 'Casio G-Shock',
      thuongHieu: 'Casio',
      gia: 1200000.00,
      hinhAnh: 'assets/product/dong_ho_casioG-Shock.jpg',
      moTa: 'Đồng hồ thể thao bền bỉ.',
      soLuong: 1,
    ),
    CartItem(
      id: '3',
      ten: 'Đồng Hồ Omega Seamaster',
      thuongHieu: 'Omega',
      gia: 5300000.00,
      hinhAnh: 'assets/product/dong_ho_Omega_Seamaster.jpg',
      moTa: 'Omega Seamaster là chiếc đồng hồ lặn cao cấp.',
      soLuong: 1,
    ),
    CartItem(
      id: '4',
      ten: 'Đồng Hồ Omega',
      thuongHieu: 'Omega',
      gia: 5500000.00,
      hinhAnh: 'assets/product/dong_ho_Omega_lan_cao_cap.jpg',
      moTa: 'Omega là chiếc đồng hồ lặn cao cấp.',
      soLuong: 1,
    ),
  ];
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Danh Sách Sản Phẩm'),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: GridView.builder(
          itemCount: danhSachDongHo.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 15,
            crossAxisSpacing: 15,
            mainAxisExtent: 280,
          ),
          itemBuilder: (context, index) {
            CartItem dongHo = danhSachDongHo[index];
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) =>
                            ChiTietSanPham(dh: dongHo, gioHang: gioHang),
                  ),
                );
              },
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                elevation: 4,
                child: Column(
                  children: [
                    // Hình ảnh đồng hồ
                    ClipRRect(
                      borderRadius: BorderRadius.circular(125),
                      child:
                          dongHo.hinhAnh.startsWith('http')
                              ? Image.network(
                                dongHo.hinhAnh,
                                height: 120,
                                width: 120,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Icon(
                                    Icons.error,
                                    size: 50,
                                    color: Colors.red,
                                  );
                                },
                              )
                              : Image.asset(
                                dongHo.hinhAnh,
                                height: 120,
                                width: 120,
                                fit: BoxFit.cover,
                              ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            dongHo.ten,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            dongHo.thuongHieu,
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            '\ ${dongHo.gia} VNĐ',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: Colors.redAccent,
                            ),
                          ),
                          const SizedBox(height: 10),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  side: const BorderSide(
                                    color: Colors.deepOrange,
                                  ),
                                ),
                              ),
                              child: const Text(
                                'Mua ngay',
                                style: TextStyle(color: Colors.deepOrange),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
