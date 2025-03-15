import 'package:flutter/material.dart';
import 'package:shop_ban_dong_ho/utils/app_colors.dart';

class Thongtin extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.fmd_good_outlined, size: 20, color: AppColors.primary),
              const SizedBox(width: 4),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text("Nguyễn Ngọc Hải"),
                      const SizedBox(width: 4),
                      Text(
                        "(0374528455)",
                        style: TextStyle(
                          fontSize: 10,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                  Text("Số 21, Diệp Minh Châu", style: TextStyle(fontSize: 10)),
                  Text(
                    "Phường Tân Sơn Nhìn,Quận Tân Phú, TP.HCM",
                    style: TextStyle(fontSize: 10),
                  ),
                ],
              ),
            ],
          ),

          Icon(
            Icons.arrow_forward_ios_rounded,
            size: 18,
            color: AppColors.textSecondary,
          ),
        ],
      ),
    );
  }
}
