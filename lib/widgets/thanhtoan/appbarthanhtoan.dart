import 'package:flutter/material.dart';
import 'package:shop_ban_dong_ho/utils/app_colors.dart';

class Appbarthanhtoan extends StatelessWidget implements PreferredSizeWidget {
  const Appbarthanhtoan({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return AppBar(
      elevation: 0,
      scrolledUnderElevation: 0,
      backgroundColor: Colors.white,
      centerTitle: true,
      title: Column(
        children: [
          const SizedBox(height: 25),
          const Row(
            mainAxisAlignment: MainAxisAlignment.start,

            children: [
              IconButton(
                icon: Icon(
                  Icons.arrow_back_ios,
                  color: AppColors.textSecondary, // Màu icon
                  size: 14, // Kích thước
                ),
                onPressed: null,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Thanh Toán",
                    style: TextStyle(
                      fontFamily: "San Francisco",
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
