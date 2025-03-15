//Dùng cho thẻ sản phẩn của hai page trang chủ và yêu thích

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shop_ban_dong_ho/utils/app_colors.dart';

class Carditem extends StatelessWidget {
  final int index;
  const Carditem({required this.index});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      height: index % 2 == 0 ? 250 : 200, // Item đầu cao hơn
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Color.fromRGBO(149, 157, 165, 0.2),
            blurRadius: 24,
            spreadRadius: 0,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 10),
          Expanded(
            child: Image.network(
              "https://shopdunk.com/images/thumbs/0026813_apple-watch-s6-gps-chinh-hang-cu-dep.png",
              fit: BoxFit.cover, // Đảm bảo ảnh không bị méo
            ),
          ),
          SizedBox(height: 8),
          Text(
            "Sản phẩm $index",
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            maxLines: 2,
          ),
          SizedBox(height: 4),
          Text(
            "\$${(index + 1) * 10}.00",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }
}
