import 'package:flutter/material.dart';

class Appbarfavorite extends StatelessWidget implements PreferredSizeWidget {
  const Appbarfavorite({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return AppBar(title: Text("App bar fabotie"));
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
