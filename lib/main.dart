import 'package:flutter/material.dart';
import 'package:shop_ban_dong_ho/screens/Favorite.dart';
import 'package:shop_ban_dong_ho/screens/GioHang.dart';
import 'package:shop_ban_dong_ho/screens/Info.dart';
import 'package:shop_ban_dong_ho/screens/trangchu.dart';
import 'package:shop_ban_dong_ho/utils/app_colors.dart';
import 'package:shop_ban_dong_ho/widgets/Appbar/appBarFavorite.dart';
import 'package:shop_ban_dong_ho/widgets/Appbar/appBarHome.dart';
import 'package:shop_ban_dong_ho/widgets/Appbar/appBarInfo.dart';
import 'package:shop_ban_dong_ho/widgets/Appbar/appBarShopping_cart.dart';
import 'package:shop_ban_dong_ho/widgets/headerparts.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "APP BAN DONG HO",
      debugShowCheckedModeBanner: false,
      home: MyButtonNavigationBar(),
    );
  }
}

class MyButtonNavigationBar extends StatefulWidget {
  const MyButtonNavigationBar({super.key});
  @override
  State<StatefulWidget> createState() {
    return _MyButtonNavigationBar();
  }
}

class _MyButtonNavigationBar extends State<MyButtonNavigationBar> {
  int _selectedIndex = 0;
  static const List<Widget> _widgetOptions = <Widget>[
    TrangChu(),
    Favorite(),
    GioHang(),
    Info(),
  ];
  static const List<PreferredSizeWidget> _widgetAppbar = <PreferredSizeWidget>[
    Appbarhome(),
    Appbarfavorite(),
    AppbarshoppingCart(),
    Appbarinfo(),
  ];
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _widgetAppbar.elementAt(_selectedIndex),
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.favorite_border), label: ''),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart_outlined),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_2_outlined),
            label: '',
          ),
        ],
        backgroundColor: AppColors.background,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.secondary,
        showSelectedLabels: false, // Ẩn label khi chọn
        showUnselectedLabels: false, // Ẩn label khi chưa chọn
        onTap: _onItemTapped,
        currentIndex: _selectedIndex,
      ),
    );
  }
}
