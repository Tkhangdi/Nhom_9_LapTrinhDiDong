import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shop_ban_dong_ho/firebase_options.dart';
<<<<<<< HEAD
import 'package:shop_ban_dong_ho/models/Cart.dart';
import 'package:shop_ban_dong_ho/models/CartItem.dart';
=======

>>>>>>> hongha
import 'package:shop_ban_dong_ho/screens/Favorite.dart';
import 'package:shop_ban_dong_ho/screens/GioHang.dart';
import 'package:shop_ban_dong_ho/screens/Info.dart';
import 'package:shop_ban_dong_ho/screens/dangky.dart';
import 'package:shop_ban_dong_ho/screens/dangnhap.dart';
import 'package:shop_ban_dong_ho/screens/faq.dart';
import 'package:shop_ban_dong_ho/screens/trangchu.dart';
import 'package:shop_ban_dong_ho/screens/XacThucOTP.dart';

import 'package:shop_ban_dong_ho/utils/app_colors.dart';
import 'package:shop_ban_dong_ho/widgets/Appbar/appBarFavorite.dart';
import 'package:shop_ban_dong_ho/widgets/Appbar/appBarHome.dart';
import 'package:shop_ban_dong_ho/widgets/Appbar/appBarInfo.dart';
import 'package:shop_ban_dong_ho/widgets/Appbar/appBarShopping_cart.dart';
import 'package:provider/provider.dart';

// void main() {
//   runApp(const MyApp());
// }

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
<<<<<<< HEAD
  runApp(ChangeNotifierProvider(create: (context) => Cart(), child: MyApp()));
=======
  runApp(const MyApp());
>>>>>>> hongha
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "APP BAN DONG HO",
      debugShowCheckedModeBanner: false,
      //home: MyButtonNavigationBar(),
      home: DangKy(),
      //home: XacThucOTP(soDienThoai: '122332233'),
<<<<<<< HEAD
      home: MyButtonNavigationBar(),
      theme: ThemeData(
        primaryColor: Colors.orange,
        scaffoldBackgroundColor: AppColors.background,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.orange, // Sử dụng màu cam làm màu chủ đạo
          brightness: Brightness.light, // Chế độ sáng
        ),
        textTheme: TextTheme(
          bodyMedium: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 13,
            fontFamily: "Ganh",
            fontWeight: FontWeight.normal,
          ),
          bodyLarge: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 16,
            fontFamily: "Ganh",
            fontWeight: FontWeight.normal,
          ),
        ),
      ),
      darkTheme: ThemeData(
        scaffoldBackgroundColor: Colors.black,
        primaryColor: Colors.orange,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.orange,
          brightness: Brightness.dark, // Chế độ tối
        ),
        textTheme: TextTheme(
          bodyMedium: TextStyle(
            color: const Color.fromARGB(255, 255, 255, 255),
            fontSize: 13,
            fontFamily: "Ganh",
            fontWeight: FontWeight.normal,
          ),
          bodyLarge: TextStyle(
            color: const Color.fromARGB(255, 255, 255, 255),
            fontSize: 16,
            fontFamily: "Ganh",
            fontWeight: FontWeight.normal,
          ),
        ),
      ),
      themeMode: ThemeMode.light,
=======
      // home: DangNhap(),
>>>>>>> hongha
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
  final List<CartItem> danhSachSanPham = []; // Thêm danh sách sản phẩm

  late final List<Widget> _widgetOptions;

  @override
  void initState() {
    super.initState();
    _widgetOptions = [
      TrangChu(),
      Favorite(),
      GioHang(
        gioHang: Provider.of<Cart>(context, listen: false),
        danhSachSanPham: danhSachSanPham,
      ),
      Info(),
    ];
  }

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
        unselectedItemColor:
            Theme.of(context).brightness == Brightness.dark
                ? Colors.white
                : Colors.black,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        onTap: _onItemTapped,
        currentIndex: _selectedIndex,
      ),
    );
  }
}
