import 'package:flutter/material.dart';
import 'package:shop_ban_dong_ho/widgets/thanhtoan/appbarthanhtoan.dart';
import 'package:shop_ban_dong_ho/widgets/thanhtoan/ptthanhtoan.dart';
import 'package:shop_ban_dong_ho/widgets/thanhtoan/ttsanpham.dart';
import 'package:shop_ban_dong_ho/utils/app_colors.dart';

void main() {
  runApp(const MaterialApp(home: Thanhtoan()));
}

class Thanhtoan extends StatelessWidget {
  const Thanhtoan({super.key});
  Widget thongtin() {
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

  Widget ctThanhToan() {
    return Container(
      margin: EdgeInsets.only(top: 12),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Chi tiết thanh toán",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Tổng tiền sản phẩm",
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w300),
              ),
              Text(
                "195.000đ",
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w300),
              ),
            ],
          ),
          SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Phí vận chuyển",
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w300),
              ),
              Text(
                "20.000đ",
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w300),
              ),
            ],
          ),
          Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Tổng tiền",
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w300),
              ),
              Text(
                "1000.000đ",
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: Appbarthanhtoan(),
      body: ListView(
        padding: EdgeInsets.all(8),
        children: [thongtin(), Ttsanpham(), Ptthanhtoan(), ctThanhToan()],
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
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
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
