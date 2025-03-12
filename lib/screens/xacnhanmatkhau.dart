import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';

class XacThucOTP extends StatefulWidget {
  final String soDienThoai;
  final int thoiGianDemNguoc;

  XacThucOTP({required this.soDienThoai, this.thoiGianDemNguoc = 30});

  @override
  _XacThucOTPState createState() => _XacThucOTPState();
}

class _XacThucOTPState extends State<XacThucOTP> {
  List<TextEditingController> _controllers = List.generate(
    6,
    (index) => TextEditingController(),
  );
  int _demNguoc = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _batDauDemNguoc();
  }

  void _batDauDemNguoc() {
    setState(() {
      _demNguoc = widget.thoiGianDemNguoc;
    });
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_demNguoc > 0) {
        setState(() {
          _demNguoc--;
        });
      } else {
        timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _xacThucOTP() {
    String otp = _controllers.map((c) => c.text).join();
    // Thực hiện xác thực OTP tại đây
    print("Mã OTP đã nhập: $otp");
  }

  void _guiLaiOTP() {
    setState(() {
      _demNguoc = widget.thoiGianDemNguoc;
    });
    _batDauDemNguoc();
    // Thực hiện gửi lại OTP tại đây
    print("Yêu cầu gửi lại mã OTP");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Xác Thực OTP",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text("Chúng tôi đã gửi mã đến số ${widget.soDienThoai}"),
            SizedBox(height: 5),
            Text(
              "Mã sẽ hết hạn sau 00:${_demNguoc.toString().padLeft(2, '0')}",
              style: TextStyle(color: Colors.red),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(6, (index) {
                return SizedBox(
                  width: 40,
                  child: TextField(
                    controller: _controllers[index],
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    maxLength: 1,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    decoration: InputDecoration(
                      counterText: "",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onChanged: (value) {
                      if (value.isNotEmpty && index < 5) {
                        FocusScope.of(context).nextFocus();
                      }
                    },
                  ),
                );
              }),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _xacThucOTP,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text("Tiếp Tục", style: TextStyle(color: Colors.white)),
            ),
            SizedBox(height: 10),
            TextButton(
              onPressed: _demNguoc == 0 ? _guiLaiOTP : null,
              child: Text(
                "Gửi Lại Mã OTP",
                style: TextStyle(
                  color: _demNguoc == 0 ? Colors.blue : Colors.grey,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
