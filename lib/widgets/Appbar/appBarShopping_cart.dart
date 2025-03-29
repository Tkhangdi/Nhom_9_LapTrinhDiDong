import 'package:flutter/material.dart';

class AppbarshoppingCart extends StatelessWidget
    implements PreferredSizeWidget {
  const AppbarshoppingCart({super.key});

  @override
  Widget build(BuildContext context) {
    // implement build
    return AppBar(
      title: Text(
        "Giỏ Hàng",
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
      ),
      centerTitle: true,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
