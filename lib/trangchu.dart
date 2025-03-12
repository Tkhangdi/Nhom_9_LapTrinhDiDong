import 'package:shop_ban_dong_ho/danhsachsanpham.dart';
import 'package:shop_ban_dong_ho/headerparts.dart';
import 'package:flutter/material.dart';

class TrangChu extends StatefulWidget {
  const TrangChu({super.key});

  @override
  State<TrangChu> createState() => _HomePageState();
}

class _HomePageState extends State<TrangChu> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // For BottomNavigationBar
      bottomNavigationBar: BottomNavigationBar(
        showSelectedLabels: false,

        unselectedItemColor: Colors.green[200],
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home, size: 30),
            label: 'Home',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'Chat'),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Cart',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Notification',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favorite',
          ),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 15),
          const HeaderParts(), // Assuming HeaderParts widget is also part of the layout
          const SizedBox(height: 15),
          const Expanded(
            child: DanhSachSanPham(),
          ), // Expanded to take full available space
        ],
      ),
    );
  }
}
