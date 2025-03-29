import 'package:flutter/material.dart';
import 'package:shop_ban_dong_ho/utils/app_colors.dart';

class Favorite extends StatelessWidget {
  const Favorite({super.key});

  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Expanded(
          flex: 1,

          child: Container(
            width: double.infinity,
            height: 100,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,

              children: [
                Text(
                  "Bạn muốn xóa sản phẩm danh mục yêu thích",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                ),
                Container(
                  padding: EdgeInsets.only(
                    left: 100,
                    right: 100,
                    top: 5,
                    bottom: 5,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    color: Colors.red,
                  ),
                  child: InkWell(
                    onTap: () {},
                    child: Text(
                      "Xóa",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget cardItem(int index) {
    return Container(
      // Item đầu cao hơn
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
            "Sảnvv  fdsnff f df sf sf f sf s fs f fs f  phẩm $index",
            style: TextStyle(fontSize: 14),
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
        return GestureDetector(
          onTap:
              () => showDialog(
                context: context,
                builder:
                    (context) => AlertDialog(
                      title: Text("Thông báo"),
                      content: Text("Test"),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text("OK"),
                        ),
                      ],
                    ),
              ),
          onLongPress: () => _showBottomSheet(context),
          child: cardItem(index),
        );
      },
    );
  }
}
