import 'package:flutter/material.dart';

class AppbarshoppingCart extends StatelessWidget
    implements PreferredSizeWidget {
  const AppbarshoppingCart({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return AppBar(title: Text("App bar shop"));
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
