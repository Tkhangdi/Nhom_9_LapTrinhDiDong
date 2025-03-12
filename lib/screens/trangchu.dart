import 'package:shop_ban_dong_ho/screens/danhsachsanpham.dart';
import 'package:shop_ban_dong_ho/widgets/headerparts.dart';
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
        // Assuming HeaderParts widget is also part of the layout
        const SizedBox(height: 15),
        const Expanded(
          child: DanhSachSanPham(),
        ), // Expanded to take full available space
      ],
    );
  }
}
