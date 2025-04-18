import 'package:intl/intl.dart';
import 'package:shop_ban_dong_ho/models/SanPham.dart';
import 'package:shop_ban_dong_ho/screens/danhsachsanpham.dart';
import 'package:shop_ban_dong_ho/service/FirebaseService.dart';
import 'package:shop_ban_dong_ho/utils/app_colors.dart';
import 'package:shop_ban_dong_ho/widgets/headerparts.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TrangChu extends StatefulWidget {
  const TrangChu({super.key});

  @override
  State<TrangChu> createState() => _HomePageState();
}

class _HomePageState extends State<TrangChu> {
  final firebaseService = FirebaseService();

  List<SanPham> list1 = [];
  List<SanPham> list2 = [];
  Future<List<SanPham>> fetchSanPhamList() {
    return firebaseService.fetchData(
      "SanPham",
      (json) => SanPham.fromJson(json),
    );
  }

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    final data = await fetchSanPhamList();
    final half = (data.length / 2).ceil();

    setState(() {
      list1 = data.sublist(0, half);
      list2 = data.sublist(half);
    });
  }

  Widget cardItem(SanPham sp) {
    return Padding(
      padding: EdgeInsets.all(10),
      child: Material(
        color:
            Theme.of(context).brightness == Brightness.dark
                ? const Color.fromARGB(255, 85, 84, 84)
                : Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(10)),
        child: InkWell(
          hoverColor: Colors.transparent,
          onTap: () {},
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(
                  6,
                ), // hoặc EdgeInsets.symmetric(...) nếu muốn chỉ theo chiều ngang/dọc
                child: Image.network(
                  "https://res.cloudinary.com/dpckj5n6n/image/upload/${sp.hinhAnh}.png",
                  fit: BoxFit.fill,
                ),
              ),
              Text(
                sp.tenSanPham,
                style: Theme.of(context).textTheme.bodyMedium,
                maxLines: 2,
                textAlign: TextAlign.center,
              ),
              Text(
                NumberFormat.currency(
                  locale: 'vi_VN',
                  symbol: '₫',
                ).format(sp.gia),
                style: TextStyle(color: AppColors.primary),

                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        SizedBox(height: 10),
        Container(
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(20)),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(20)),
            child: Image.network(
              "https://cdnv2.tgdd.vn/mwg-static/topzone/Banner/85/56/8556772b83e9bd7198500df457f00498.png",
              fit: BoxFit.cover,
            ),
          ),
        ),
        Text(
          "Sản Phẩm Mới Nhất 2025",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 18,
            color: AppColors.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
        Divider(
          color: AppColors.primary, // Màu của đường chỉ
          thickness: 2, // Độ dày của đường chỉ
          indent: 20, // Khoảng cách từ mép trái
          endIndent: 20, // Khoảng cách từ mép phải
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(children: list1.map((sp) => cardItem(sp)).toList()),
              //child: Column(children: []),
            ),

            Expanded(
              //child: Column(children: []),
              child: Column(
                children: [
                  SizedBox(height: 20),
                  ...list2.map((toElement) => cardItem(toElement)),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
