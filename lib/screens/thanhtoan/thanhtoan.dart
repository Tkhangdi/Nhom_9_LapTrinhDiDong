import 'package:flutter/material.dart';
import 'package:shop_ban_dong_ho/firebase_options.dart';
import 'VnpayWebviewPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

class CartItem {
  String id;
  String ten;
  String thuongHieu;
  double gia;
  String hinhAnh;
  String moTa;
  int soLuong;

  CartItem({
    required this.id,
    required this.ten,
    required this.thuongHieu,
    required this.gia,
    required this.hinhAnh,
    required this.moTa,
    required this.soLuong,
  });
}

final List<CartItem> gioHang = [
  CartItem(
    id: 'sp001',
    ten: 'Đồng hồ Citizen 40 mm Nam BI5127-51H',
    thuongHieu: 'Citizen',
    gia: 145000,
    hinhAnh:
        "https://cdnv2.tgdd.vn/mwg-static/tgdd/Products/Images/7264/333115/citizen-bi5127-51h-nam-1-638702014664181835-750x500.jpg",
    moTa: 'Đồng hồ năng lượng ánh sáng',
    soLuong: 2,
  ),
  CartItem(
    id: 'sp002',
    ten: 'Đồng hồ Casio nữ dây kim loại',
    thuongHieu: 'Casio',
    gia: 195000,
    hinhAnh:
        "https://cdnv2.tgdd.vn/mwg-static/tgdd/Products/Images/7264/333115/citizen-bi5127-51h-nam-1-638702014664181835-750x500.jpg",
    moTa: 'Dây kim loại cao cấp',
    soLuong: 2,
  ),
];

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MaterialApp(home: Thanhtoan()));
}

class Thanhtoan extends StatefulWidget {
  const Thanhtoan({super.key});

  @override
  State<Thanhtoan> createState() => _ThanhtoanState();
}

class _ThanhtoanState extends State<Thanhtoan> {
  int _ptThanhToan = 1;

  void _capNhatPhuongThuc(int value) {
    setState(() {
      _ptThanhToan = value;
    });
  }

  Widget thongTinNguoiNhan() {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Icon(Icons.fmd_good_outlined, size: 20, color: Colors.red),
          const SizedBox(width: 4),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text("Nguyễn Ngọc Hải"),
                    SizedBox(width: 4),
                    Text(
                      "(0374528455)",
                      style: TextStyle(fontSize: 10, color: Colors.grey),
                    ),
                  ],
                ),
                Text("Số 21, Diệp Minh Châu", style: TextStyle(fontSize: 10)),
                Text(
                  "P. Tân Sơn Nhì, Q. Tân Phú, TP.HCM",
                  style: TextStyle(fontSize: 10),
                ),
              ],
            ),
          ),
          Icon(Icons.arrow_forward_ios_rounded, size: 18, color: Colors.grey),
        ],
      ),
    );
  }

  Widget danhSachSanPham() {
    return Container(
      margin: EdgeInsets.only(top: 12),
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children:
            gioHang.map((item) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  children: [
                    Image.network(
                      item.hinhAnh,
                      width: 70,
                      height: 70,
                      fit: BoxFit.cover,
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.ten,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontSize: 14),
                          ),
                          SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "${item.gia.toStringAsFixed(0)} đ",
                                style: TextStyle(fontSize: 14),
                              ),
                              Text(
                                "x${item.soLuong}",
                                style: TextStyle(fontSize: 14),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
      ),
    );
  }

  Widget chiTietThanhToan() {
    double tongTien = gioHang.fold(
      0,
      (sum, item) => sum + item.gia * item.soLuong,
    );
    double phiShip = 20000;
    double tongCong = tongTien + phiShip;

    return Container(
      margin: EdgeInsets.only(top: 12),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Chi tiết thanh toán",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
          SizedBox(height: 10),
          rowChiTiet("Tổng tiền sản phẩm", "${tongTien.toStringAsFixed(0)} đ"),
          rowChiTiet("Phí vận chuyển", "${phiShip.toStringAsFixed(0)} đ"),
          Divider(),
          rowChiTiet(
            "Tổng cộng",
            "${tongCong.toStringAsFixed(0)} đ",
            bold: true,
          ),
        ],
      ),
    );
  }

  Widget rowChiTiet(String label, String value, {bool bold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w300),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 12,
              fontWeight: bold ? FontWeight.bold : FontWeight.w300,
            ),
          ),
        ],
      ),
    );
  }

  void _datHang() async {
    String orderId = DateTime.now().millisecondsSinceEpoch.toString();
    double tongTien = gioHang.fold(
      0,
      (sum, item) => sum + item.gia * item.soLuong,
    );
    double phiShip = 20000;
    double tongCong = tongTien + phiShip;

    try {
      // Lưu đơn hàng lên Firestore
      await FirebaseFirestore.instance.collection('orders').doc(orderId).set({
        'orderId': orderId,
        'hoTen': "Nguyễn Ngọc Hải",
        'soDienThoai': "0374528455",
        'diaChi': "Số 21, Diệp Minh Châu, P. Tân Sơn Nhì, Q. Tân Phú, TP.HCM",
        'danhSachSanPham':
            gioHang
                .map(
                  (item) => {
                    'id': item.id,
                    'ten': item.ten,
                    'gia': item.gia,
                    'soLuong': item.soLuong,
                  },
                )
                .toList(),
        'tongTien': tongTien,
        'phiVanChuyen': phiShip,
        'tongCong': tongCong,
        'phuongThucThanhToan': _ptThanhToan == 1 ? "COD" : "Online",
        'trangThai': _ptThanhToan == 1 ? "pending" : "awaiting_payment",
        'ngayDat': Timestamp.now(),
      });

      if (_ptThanhToan == 1) {
        // Hiển thị thông báo đặt hàng thành công
        showDialog(
          context: context,
          builder:
              (_) => AlertDialog(
                title: Text("Thành công"),
                content: Text("Đơn hàng đã được ghi nhận!"),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text("OK"),
                  ),
                ],
              ),
        );
      } else {
        // Chuyển sang trang thanh toán VNPAY
        String returnUrl = "https://sandbox.vnpayment.vn/return";

        Navigator.push(
          context,
          MaterialPageRoute(
            builder:
                (context) => VnpayPaymentPage(
                  orderId: orderId,
                  amount: tongCong.toInt(),
                  returnUrl: returnUrl,
                ),
          ),
        );
      }
    } catch (e) {
      print("Lỗi đặt hàng: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Lỗi khi đặt hàng: $e"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Thanh toán")),
      body: ListView(
        padding: EdgeInsets.all(8),
        children: [
          thongTinNguoiNhan(),
          danhSachSanPham(),
          PtThanhToan(onChanged: _capNhatPhuongThuc),
          chiTietThanhToan(),
        ],
      ),
      backgroundColor: Color(0xFFF5F5F5),
      bottomNavigationBar: Container(
        height: 60,
        color: Colors.white,
        padding: EdgeInsets.all(12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            ElevatedButton(
              onPressed: _datHang,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text("Đặt hàng", style: TextStyle(fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }
}

// Widget con trong cùng file
class PtThanhToan extends StatefulWidget {
  final Function(int) onChanged;

  const PtThanhToan({super.key, required this.onChanged});

  @override
  State<PtThanhToan> createState() => _PtThanhToanState();
}

class _PtThanhToanState extends State<PtThanhToan> {
  int _chonpttt = 1;

  void _chon(int value) {
    setState(() {
      _chonpttt = value;
    });
    widget.onChanged(value);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 12),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Phương thức thanh toán",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
          Column(
            children: [
              ListTile(
                title: Text("Thanh toán tại nhà"),
                leading: Icon(Icons.payments_outlined, color: Colors.green),
                trailing: Radio(
                  value: 1,
                  groupValue: _chonpttt,
                  onChanged: (val) => _chon(val!),
                ),
              ),
              ListTile(
                title: Text("Thanh toán online"),
                leading: Icon(Icons.payment, color: Colors.blueAccent),
                trailing: Radio(
                  value: 2,
                  groupValue: _chonpttt,
                  onChanged: (val) => _chon(val!),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
