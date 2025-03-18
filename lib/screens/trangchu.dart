import 'package:shop_ban_dong_ho/screens/danhsachsanpham.dart';
import 'package:shop_ban_dong_ho/utils/app_colors.dart';
import 'package:shop_ban_dong_ho/widgets/headerparts.dart';
import 'package:flutter/material.dart';

class TrangChu extends StatefulWidget {
  const TrangChu({super.key});

  @override
  State<TrangChu> createState() => _HomePageState();
}

class _HomePageState extends State<TrangChu> {
  Widget cardItem() {
    return Padding(
      padding: EdgeInsets.all(10),
      child: Material(
        color: Colors.white,

        borderRadius: BorderRadius.all(Radius.circular(10)),
        child: InkWell(
          hoverColor: Colors.transparent,
          onTap: () {},
          child: Column(
            children: [
              Image.network(
                "https://cdn.tgdd.vn/Products/Images/7077/316004/s16/Apple%20Watch%20SE%202-650x650.png",

                fit: BoxFit.cover,
              ),
              Text(
                "Apple Watch SE 2 GPS 40mm viền nhôm dây vải",
                style: TextStyle(
                  // Chỉ hiển thị tối đa 2 dòng
                  overflow: TextOverflow.ellipsis,
                ),
                maxLines: 2,
                textAlign: TextAlign.center,
              ),
              Text(
                "190.000đ",
                style: TextStyle(
                  // Chỉ hiển thị tối đa 2 dòng
                  color: AppColors.primary,
                ),

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
              child: Column(
                children: [
                  cardItem(),
                  cardItem(),
                  cardItem(),
                  cardItem(),
                  cardItem(),
                ],
              ),
            ),

            Expanded(
              child: Column(
                children: [
                  SizedBox(height: 20),
                  cardItem(),
                  cardItem(),
                  cardItem(),
                  cardItem(),
                  cardItem(),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
