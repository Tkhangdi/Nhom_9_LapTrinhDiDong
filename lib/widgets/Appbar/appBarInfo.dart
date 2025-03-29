import 'package:flutter/material.dart';

class Appbarinfo extends StatelessWidget implements PreferredSizeWidget {
  const Appbarinfo({super.key});

  @override
  Widget build(BuildContext context) {
    // implement build
    return AppBar(
      title: Container(
        alignment: Alignment.center,
        child: Text("Thông tin cá nhân", style: TextStyle(color: Colors.black)),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
