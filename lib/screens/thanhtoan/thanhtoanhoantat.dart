import 'package:flutter/material.dart';
import 'package:shop_ban_dong_ho/utils/app_colors.dart';

void main() {
  runApp(const MaterialApp(home: Thanhtoanhoantat()));
}

class Thanhtoanhoantat extends StatelessWidget {
  const Thanhtoanhoantat({super.key});
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset("../../assets/images/success.png"),
          const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Thanh Toán Hoàn Tất",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
              Text(
                "Cảm ơn bạn đã mua hàng, đơn hàng sẽ sớm được xử lý.",
                style: TextStyle(fontSize: 12, color: AppColors.primary),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          ElevatedButton(
            onPressed: () {},
            child: Text("Quay lại trang chủ"),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              padding: EdgeInsets.all(20),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
