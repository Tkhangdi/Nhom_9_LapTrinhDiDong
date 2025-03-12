import 'package:shop_ban_dong_ho/DongHo.dart';
import 'package:flutter/material.dart';

import 'chitietsanpham.dart';

class DanhSachSanPham extends StatefulWidget {
  const DanhSachSanPham({super.key});

  @override
  State<DanhSachSanPham> createState() => _DanhSachSanPhamState();
}

class _DanhSachSanPhamState extends State<DanhSachSanPham> {
  // Giả sử bạn đã có một danh sách các đồng hồ
  List<DongHo> danhSachDongHo = [
    DongHo(
      id: '1',
      ten: 'Đồng Hồ Rolex Submariner',
      thuongHieu: 'Rolex',
      gia: 8500.00,
      hinhAnh:
          'https://www.dangquangwatch.vn/lib/ckfinder/images/1725e0259fa778f921b6.jpg',
      moTa: 'Rolex Submariner là một chiếc đồng hồ thể thao sang trọng.',
      soLuong: 34,
    ),
    DongHo(
      id: '2',
      ten: 'Đồng Hồ Casio G-Shock',
      thuongHieu: 'Casio',
      gia: 120.00,
      hinhAnh:
          'https://demoda.vn/wp-content/uploads/2022/01/xu-huong-dong-ho-nu-duoc-ua-chuong.jpg',
      moTa: 'Casio G-Shock là chiếc đồng hồ thể thao bền bỉ.',
      soLuong: 34,
    ),
    DongHo(
      id: '3',
      ten: 'Đồng Hồ Omega Seamaster',
      thuongHieu: 'Omega',
      gia: 5300.00,
      hinhAnh:
          'https://www.omegawatches.com/media/12258/seamaster-diver-300m-steel.jpg',
      moTa: 'Omega Seamaster là chiếc đồng hồ lặn cao cấp.',
      soLuong: 33,
    ),
    DongHo(
      id: '4',
      ten: 'Đồng Hồ Omega',
      thuongHieu: 'Omega',
      gia: 5300.00,
      hinhAnh:
          'https://toigingiuvedep.vn/wp-content/uploads/2021/08/dong-ho-dien-tu-deo-tay-nam.jpg',
      moTa: 'Omega là chiếc đồng hồ lặn cao cấp.',
      soLuong: 300,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Danh Sách Đồng Hồ'),
        backgroundColor: const Color.fromARGB(
          255,
          218,
          240,
          241,
        ), // Màu đen cho thanh appBar tạo cảm giác sang trọng
        elevation: 0,
      ),
      body: GridView.builder(
        shrinkWrap: true,
        itemCount: danhSachDongHo.length,
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // Sử dụng 2 cột trong lưới
          mainAxisSpacing: 16, // Khoảng cách dọc giữa các mục
          crossAxisSpacing: 16, // Khoảng cách ngang giữa các mục
          mainAxisExtent: 300, // Chiều cao của mỗi item trong lưới
        ),
        itemBuilder: (context, index) {
          DongHo dongHo = danhSachDongHo[index]; // Lấy đồng hồ từ danh sách
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChiTietSanPham(dh: dongHo),
                ),
              ); // Chuyển đến chi tiết đồng hồ khi người dùng nhấn vào item
            },
            child: Container(
              height: 300,
              decoration: BoxDecoration(
                color: const Color.fromARGB(
                  255,
                  180,
                  221,
                  224,
                ), // Màu tối cho nền item
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: const Color.fromARGB(
                      255,
                      124,
                      124,
                      150,
                    ), // Tạo bóng cho item
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 15),
                  // Hình ảnh đồng hồ
                  ClipRRect(
                    borderRadius: BorderRadius.circular(125),
                    child: Image.network(
                      dongHo.hinhAnh, // Hiển thị hình ảnh đồng hồ
                      height: 120,
                      width: 120,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(height: 15),
                  // Tên đồng hồ
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Text(
                      dongHo.ten,
                      maxLines: 1,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                  // Thương hiệu đồng hồ
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Text(
                      dongHo.thuongHieu,
                      style: const TextStyle(color: Colors.amberAccent),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 15,
                      vertical: 10,
                    ),
                    child: Text(
                      '\$${dongHo.soLuong}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color:
                            Colors.amber, // Màu vàng cho giá để tạo sự nổi bật
                      ),
                    ),
                  ),
                  const Spacer(),
                  // Giá đồng hồ
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 15,
                      vertical: 10,
                    ),
                    child: Text(
                      '\$${dongHo.gia}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color:
                            Colors.amber, // Màu vàng cho giá để tạo sự nổi bật
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
