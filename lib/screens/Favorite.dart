import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:shop_ban_dong_ho/widgets/cardItem.dart';

class Favorite extends StatelessWidget {
  const Favorite({super.key});
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 20,
        mainAxisSpacing: 20,
        childAspectRatio: 0.7, // Đảm bảo tỷ lệ hợp lý
      ),
      itemCount: 10,
      padding: EdgeInsets.all(20),
      itemBuilder: (context, index) {
        double height = (index % 2 == 0) ? 250 : 200; // Item đầu cao hơn
        return Container(
          height: height, // Đặt chiều cao động cho item

          child: Carditem(index: index),
        );
      },
    );
  }
}
