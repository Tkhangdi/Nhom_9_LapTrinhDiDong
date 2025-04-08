import 'package:flutter/material.dart';
import 'package:shop_ban_dong_ho/widgets/headerparts.dart';

class Appbarhome extends StatelessWidget implements PreferredSizeWidget {
  const Appbarhome({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return AppBar(
      backgroundColor:
          Theme.of(context).brightness == Brightness.dark
              ? Colors.black
              : Colors.white,
      scrolledUnderElevation: 0,
      elevation: 0,
      title: Row(
        children: [
          Expanded(
            flex: 1,
            // Để TextField chiếm hết không gian có thể
            child: Container(
              height: 40, // Giới hạn chiều cao để không vượt quá AppBar
              child: TextField(
                cursorColor: Color.fromARGB(255, 120, 120, 120),
                cursorWidth: 1,
                decoration: InputDecoration(
                  hintText: "Tìm kiếm...",

                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(width: 1, color: Colors.black),
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    vertical: 10,
                  ), // Canh giữa nội dung
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(8),
                    ), // Bo góc nhẹ
                  ),
                  prefixIcon: Icon(
                    Icons.search,
                    color: const Color.fromARGB(255, 120, 120, 120),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.notifications,
              color: const Color.fromARGB(255, 120, 120, 120),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
