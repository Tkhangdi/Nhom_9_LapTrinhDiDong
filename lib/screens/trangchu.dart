import 'package:shop_ban_dong_ho/screens/danhsachsanpham.dart';
import 'package:flutter/material.dart';

class TrangChu extends StatefulWidget {
  const TrangChu({super.key});

  @override
  State<TrangChu> createState() => _HomePageState();
}

class _HomePageState extends State<TrangChu> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 200),
        const Expanded(
          child: DanhSachSanPham(),
        ), // Expanded to take full available space
      ],
    );
  }
}

