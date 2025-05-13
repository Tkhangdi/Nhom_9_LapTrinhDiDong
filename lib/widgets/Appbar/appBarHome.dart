import 'package:flutter/material.dart';
import 'package:shop_ban_dong_ho/screens/loc_san_pham/bo_loc_san_pham.dart';
import 'package:shop_ban_dong_ho/screens/trangchu.dart';

class Appbarhome extends StatelessWidget implements PreferredSizeWidget {
  final Function(String) onSearch;

  const Appbarhome({super.key, required this.onSearch});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor:
          Theme.of(context).brightness == Brightness.dark
              ? Colors.black
              : Colors.white,
      elevation: 0,
      title: Row(
        children: [
          Expanded(
            child: SizedBox(
              height: 40,
              child: TextField(
                onSubmitted: onSearch,
                decoration: InputDecoration(
                  hintText: "Tìm kiếm...",
                  prefixIcon: const Icon(Icons.search, color: Colors.grey),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(width: 1, color: Colors.black),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 10),
                ),
              ),
            ),
          ),
          IconButton(
            onPressed: () {
              showModalBottomSheet(
                context: context,
                builder:
                    (_) => BoLocSanPham(
                      onFilter: (brand, gia) {
                        trangChuKey.currentState?.filterSanPham(
                          brand,
                          gia.start * 1000000,
                          gia.end * 1000000,
                        );
                      },
                    ),
              );
            },
            icon: const Icon(Icons.filter_list, color: Colors.grey),
          ),

          const SizedBox(width: 10),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.notifications, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
