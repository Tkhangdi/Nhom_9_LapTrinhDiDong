import 'package:flutter/material.dart';
import 'package:shop_ban_dong_ho/utils/app_colors.dart';

class Appbarfavorite extends StatelessWidget implements PreferredSizeWidget {
  const Appbarfavorite({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return AppBar(
      title: Text(
        "Sản phẩm đã thích",
        style: TextStyle(
          color: AppColors.primary,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      centerTitle: true,
      backgroundColor: AppColors.background,
      scrolledUnderElevation: 0,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
