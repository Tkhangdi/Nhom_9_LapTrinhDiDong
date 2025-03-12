import 'package:flutter/material.dart';

class Appbarinfo extends StatelessWidget implements PreferredSizeWidget {
  const Appbarinfo({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return AppBar(title: Text("App bar info"));
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
