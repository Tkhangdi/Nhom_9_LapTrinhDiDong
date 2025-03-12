import 'package:shop_ban_dong_ho/screens/dangnhap.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart'; // Dùng thư viện SQLite
import 'package:path/path.dart'; // Dùng để tạo đường dẫn cho cơ sở dữ liệu

class QuenMatKhau extends StatefulWidget {
  const QuenMatKhau({super.key});

  @override
  State<QuenMatKhau> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<QuenMatKhau> {
  TextEditingController mailcontroller = TextEditingController();

  String email = "";

  // Khóa toàn cục để xác nhận form
  final _formkey = GlobalKey<FormState>();

  // Khóa toàn cục cho ScaffoldMessenger để quản lý thông báo
  final GlobalKey<ScaffoldMessengerState> _scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();

  // Hàm giả lập gửi email reset mật khẩu và kiểm tra xem email có tồn tại không
  resetPassword() async {
    // Giả lập độ trễ khi xử lý reset mật khẩu
    await Future.delayed(Duration(seconds: 2));

    // Mở kết nối với cơ sở dữ liệu SQLite
    var database = await openDatabase(
      join(await getDatabasesPath(), 'khachhang.db'), // Đường dẫn cơ sở dữ liệu
      version: 1, // Phiên bản cơ sở dữ liệu
    );

    // Kiểm tra xem email có tồn tại trong bảng 'users' không
    List<Map> result = await database.query(
      'users',
      where: 'email = ?', // Lọc theo email
      whereArgs: [email],
    );

    if (result.isNotEmpty) {
      // Nếu email tồn tại trong cơ sở dữ liệu, gửi email reset mật khẩu
      _scaffoldMessengerKey.currentState?.showSnackBar(
        SnackBar(
          content: Text(
            "Email reset mật khẩu đã được gửi!",
            style: TextStyle(fontSize: 18.0),
          ),
        ),
      );
    } else {
      // Nếu không tìm thấy email trong cơ sở dữ liệu, thông báo lỗi
      _scaffoldMessengerKey.currentState?.showSnackBar(
        SnackBar(
          content: Text(
            "Không tìm thấy tài khoản với email này.",
            style: TextStyle(fontSize: 18.0),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldMessengerKey, // Thêm key cho ScaffoldMessenger
      backgroundColor: const Color.fromARGB(255, 131, 207, 226), // Màu nền nhẹ
      body: Container(
        child: Column(
          children: [
            SizedBox(height: 70.0),
            // Tiêu đề màn hình
            Container(
              alignment: Alignment.topCenter,
              child: Text(
                "Khôi phục mật khẩu",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 30.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 10.0),
            // Mô tả yêu cầu nhập email
            Text(
              "Nhập email của bạn",
              style: TextStyle(
                color: Colors.white,
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            Expanded(
              child: Form(
                key: _formkey,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 20.0,
                  ), // Padding nhẹ
                  child: ListView(
                    children: [
                      // Trường nhập email
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 15.0),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(
                            0.8,
                          ), // Màu nền nhẹ cho input
                          borderRadius: BorderRadius.circular(30), // Bo góc
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              spreadRadius: 1,
                              blurRadius: 5,
                            ),
                          ], // Thêm hiệu ứng shadow
                        ),
                        child: TextFormField(
                          controller: mailcontroller,
                          // Kiểm tra email có hợp lệ không
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Vui lòng nhập email';
                            }
                            return null;
                          },
                          style: TextStyle(color: Colors.black),
                          decoration: InputDecoration(
                            hintText: "Email",
                            hintStyle: TextStyle(
                              fontSize: 18.0,
                              color: Colors.grey,
                            ),
                            prefixIcon: Icon(
                              Icons.person,
                              color: Colors.grey,
                              size: 30.0,
                            ),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      SizedBox(height: 40.0),
                      // Nút gửi email reset mật khẩu
                      GestureDetector(
                        onTap: () {
                          if (_formkey.currentState!.validate()) {
                            setState(() {
                              email = mailcontroller.text;
                            });
                            resetPassword(); // Gọi hàm gửi email reset mật khẩu
                          }
                        },
                        child: Container(
                          width: 140,
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Color.fromARGB(
                              255,
                              124,
                              168,
                              194,
                            ), // Màu nền nút đẹp hơn
                            borderRadius: BorderRadius.circular(
                              10,
                            ), // Bo góc nút
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.3),
                                spreadRadius: 2,
                                blurRadius: 6,
                              ),
                            ],
                          ),
                          child: Center(
                            child: Text(
                              "Gửi email",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 50.0),
                      // Liên kết đăng ký tài khoản mới
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Chưa có tài khoản?",
                            style: TextStyle(
                              fontSize: 18.0,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(width: 5.0),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => DangNhap(),
                                ),
                              );
                            },
                            child: Text(
                              "Tạo tài khoản",
                              style: TextStyle(
                                color: Color.fromARGB(225, 184, 166, 6),
                                fontSize: 20.0,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
