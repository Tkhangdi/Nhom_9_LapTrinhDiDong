import 'package:flutter/material.dart';

class _sanpham extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Image.network(
          "https://cdnv2.tgdd.vn/mwg-static/tgdd/Products/Images/7264/333115/citizen-bi5127-51h-nam-1-638702014664181835-750x500.jpg",
          width: 70,
          height: 70,
          fit: BoxFit.cover,
        ),
        Expanded(
          flex: 1,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                child: Text(
                  "Đồng hồ Citizen 40 mm Nam BI5127-51H",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  softWrap: true,
                ),
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,

                children: [
                  Text("145.000 đ", style: TextStyle(fontSize: 14)),

                  Text("x1", style: TextStyle(fontSize: 14)),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class Ttsanpham extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
      width: double.infinity,
      padding: EdgeInsets.all(8),
      margin: EdgeInsets.only(top: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,

        children: [_sanpham(), _sanpham(), _sanpham()],
      ),
    );
  }
}
