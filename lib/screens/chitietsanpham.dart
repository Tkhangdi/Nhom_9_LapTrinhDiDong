import 'package:shop_ban_dong_ho/screens/gioHang.dart';
import 'package:flutter/material.dart';
import '../models/DongHo.dart';

class ChiTietSanPham extends StatefulWidget {
  final DongHo dh;

  const ChiTietSanPham({super.key, required this.dh});

  @override
  State<ChiTietSanPham> createState() => _ChiTietSanPhamState();
}

class _ChiTietSanPhamState extends State<ChiTietSanPham> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F6F9),
      body: ListView(
        children: [
          const SizedBox(height: 20),
          _buildHeader(),
          _buildProductImage(),
          _buildProductDetails(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.pop(context),
          ),
          const Spacer(),
          const Text(
            "Chi Tiết Sản Phẩm",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const Spacer(),
          IconButton(
            icon: const Icon(Icons.favorite_border, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildProductImage() {
    return Center(
      child: Container(
        height: 250,
        width: 250,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(250),
          boxShadow: [
            BoxShadow(
              color: Colors.orange.withOpacity(0.2),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(250),
          child: Image.network(widget.dh.hinhAnh, fit: BoxFit.cover),
        ),
      ),
    );
  }

  Widget _buildProductDetails() {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(35),
          topRight: Radius.circular(35),
        ),
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.dh.ten,
            style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
          ),
          Text(
            '\$${widget.dh.gia}',
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.orange,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              const Icon(Icons.access_time_filled, color: Colors.orange),
              const SizedBox(width: 4),
              Text(
                widget.dh.thuongHieu,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            widget.dh.moTa,
            style: const TextStyle(fontSize: 16, color: Colors.grey),
          ),
          const SizedBox(height: 25),
          _buildActionButtons(),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
            onPressed: () {
              GioHang.themVaoGio(widget.dh, () {});
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${widget.dh.ten} đã được thêm vào giỏ hàng!'),
                  backgroundColor: Colors.orange,
                ),
              );
            },
            child: const Text(
              "Thêm vào Giỏ Hàng",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
        const SizedBox(width: 15),
        Expanded(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text("Mua Ngay Thành Công"),
                    content: Text("Bạn đã mua sản phẩm: ${widget.dh.ten}"),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text("OK"),
                      ),
                    ],
                  );
                },
              );
            },
            child: const Text(
              "Mua Ngay",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ],
    );
  }
}
