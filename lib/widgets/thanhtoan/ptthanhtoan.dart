import 'package:flutter/material.dart';
import 'package:shop_ban_dong_ho/utils/app_colors.dart';

class Ptthanhtoan extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _Ptthanhtoan();
  }
}

class _Ptthanhtoan extends State<Ptthanhtoan> {
  int _chonpttt = 1;
  void _luachon(int index) {
    setState(() {
      _chonpttt = index; // Cập nhật giá trị được chọn
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      margin: EdgeInsets.only(top: 12),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Phương thức thanh toán",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
          Column(
            children: [
              ListTile(
                title: Text("Thanh toán tại nhà"),
                leading: Icon(Icons.payments_outlined, color: Colors.green),
                trailing: Radio(
                  value: 1,
                  groupValue: _chonpttt,
                  onChanged: (value) => {_luachon(value!)},

                  fillColor: WidgetStatePropertyAll(AppColors.primary),
                ),
              ),
              ListTile(
                title: Text("Thanh toán online"),
                leading: Icon(Icons.payment, color: Colors.blueAccent),
                trailing: Radio(
                  value: 2,
                  groupValue: _chonpttt,
                  onChanged: (value) => {_luachon(value!)},
                  
                  fillColor: WidgetStatePropertyAll(AppColors.primary),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
