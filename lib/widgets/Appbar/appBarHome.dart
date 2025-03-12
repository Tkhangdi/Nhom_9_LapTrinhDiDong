import 'package:flutter/material.dart';
import 'package:shop_ban_dong_ho/widgets/headerparts.dart';

class Appbarhome extends StatelessWidget implements PreferredSizeWidget {
  const Appbarhome({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return HeaderParts();
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
