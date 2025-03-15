import 'package:flutter/material.dart';
import 'package:shop_ban_dong_ho/widgets/thanhtoan/appbarthanhtoan.dart';
import 'package:shop_ban_dong_ho/widgets/thanhtoan/ctThanhToan.dart';
import 'package:shop_ban_dong_ho/widgets/thanhtoan/ptthanhtoan.dart';
import 'package:shop_ban_dong_ho/widgets/thanhtoan/thongtin.dart';
import 'package:shop_ban_dong_ho/widgets/thanhtoan/ttsanpham.dart';
import 'package:shop_ban_dong_ho/utils/app_colors.dart';

void main() {
  runApp(const MaterialApp(home: Thanhtoan()));
}

class Thanhtoan extends StatelessWidget {
  const Thanhtoan({super.key});
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: Appbarthanhtoan(),
      body: ListView(
        padding: EdgeInsets.all(8),
        children: [Thongtin(), Ttsanpham(), Ptthanhtoan(), Ctthanhtoan()],
      ),
      backgroundColor: AppColors.background,

      bottomNavigationBar: Container(
        height: 60,
        color: Colors.white,
        padding: EdgeInsets.all(12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary, 
                foregroundColor: Colors.white, 
                padding: EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ), 
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8), 
                ),
              ),
              child: Text("Đặt hàng", style: TextStyle(fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }
}
