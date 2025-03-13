import 'package:flutter/material.dart';
import 'package:shop_ban_dong_ho/models/Cart.dart';
import 'package:shop_ban_dong_ho/models/CartItem.dart';

class GioHang extends StatefulWidget {
  final Cart gioHang;
  final List<CartItem> danhSachSanPham; // <-- Bắt buộc truyền giá trị

  const GioHang({
    Key? key,
    required this.gioHang,
    required this.danhSachSanPham,
  }) : super(key: key);

  @override
  State<GioHang> createState() => _GioHangState();
}

class _GioHangState extends State<GioHang> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Giỏ Hàng")),
      body: Column(
        children: [Expanded(child: _buildCartItems()), _buildCartSummary()],
      ),
    );
  }

  Widget _buildCartItems() {
    return ListView.builder(
      itemCount:
          widget.gioHang.items.length, // Dùng widget.gioHang thay vì gioHang
      itemBuilder: (context, index) {
        final item = widget.gioHang.items[index];
        return ListTile(
          leading:
              item.hinhAnh.startsWith('http')
                  ? Image.network(
                    item.hinhAnh,
                    height: 250,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(
                        Icons.broken_image,
                        size: 50,
                        color: Colors.red,
                      );
                    },
                  )
                  : Image.asset(
                    item.hinhAnh,
                    height: 250,
                    width: 60,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(
                        Icons.image_not_supported,
                        size: 50,
                        color: Colors.grey,
                      );
                    },
                  ),

          title: Text(item.ten),
          subtitle: Text("${item.gia} x ${item.soLuong}"),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.remove),
                onPressed: () {
                  setState(() {
                    widget.gioHang.updateQuantity(item.id, item.soLuong - 1);
                  });
                },
              ),
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: () {
                  setState(() {
                    widget.gioHang.updateQuantity(item.id, item.soLuong + 1);
                  });
                },
              ),
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () {
                  setState(() {
                    //widget.gioHang.removeItem(item.id);
                    _showDeleteConfirmationDialog(context, item.id);
                  });
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCartSummary() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 5)],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Tổng tiền:",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                "${widget.gioHang.totalPrice} VND",
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.symmetric(vertical: 15),
            ),
            onPressed: () {
              // Xử lý khi bấm nút thanh toán
            },
            child: const Center(
              child: Text(
                "Thanh Toán",
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  ///Hàm xác nhận xóa sản phẩm khỏi giỏ hàng
  void _showDeleteConfirmationDialog(BuildContext context, String itemId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Xác nhận "),
          content: const Text(
            "Bạn có chắc chắn muốn xóa sản phẩm này khỏi giỏ hàng không?",
          ),
          actions: [
            TextButton(
              onPressed:
                  () =>
                      Navigator.of(
                        context,
                      ).pop(), // Đóng hộp thoại nếu chọn "Không"
              child: const Text("Không"),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  widget.gioHang.removeItem(itemId);
                });
                Navigator.of(context).pop(); // Đóng hộp thoại sau khi xóa
              },
              child: const Text("Có", style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }
}
