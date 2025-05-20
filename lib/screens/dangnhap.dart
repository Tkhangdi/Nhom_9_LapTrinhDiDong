import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shop_ban_dong_ho/screens/dangky.dart';
import 'package:shop_ban_dong_ho/screens/doimatkhau.dart'; // Import DoiMatKhau
import 'package:shop_ban_dong_ho/screens/quenmatkhau.dart';
import 'package:shop_ban_dong_ho/screens/trangchu.dart';
import 'package:shop_ban_dong_ho/utils/app_colors.dart'; // Import AppColors
import 'package:google_sign_in/google_sign_in.dart';

class DangNhap extends StatefulWidget {
  const DangNhap({super.key});

  @override
  State<DangNhap> createState() => _LogInState();
}

class _LogInState extends State<DangNhap> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController TaiKhoanController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool _obscureText = true;

  @override
  void dispose() {
    TaiKhoanController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> _logIn() async {
    if (_formKey.currentState!.validate()) {
      String taiKhoan = TaiKhoanController.text.trim();
      String matKhau = passwordController.text;

      try {
        QuerySnapshot snapshot =
            await FirebaseFirestore.instance
                .collection('khachhang')
                .where('TaiKhoan', isEqualTo: taiKhoan)
                .where('matkhau', isEqualTo: matKhau)
                .get();

        if (snapshot.docs.isNotEmpty) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Đăng nhập thành công!')));

          // Lấy email của người dùng đã đăng nhập từ FirebaseAuth
          User? firebaseUser = FirebaseAuth.instance.currentUser;
          String userEmail = firebaseUser?.email ?? '';

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => TrangChu()),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Tài khoản hoặc mật khẩu không đúng')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Lỗi khi đăng nhập: $e')));
      }
    }
  }

  Future<void> signInWithGoogle(BuildContext context) async {
    try {
      GoogleSignIn googleSignIn = GoogleSignIn();
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

      if (googleUser == null) {
        return; // Nếu người dùng không đăng nhập qua Google, thoát.
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Đăng nhập Firebase với thông tin từ Google
      await FirebaseAuth.instance.signInWithCredential(credential);

      // Lấy thông tin người dùng từ FirebaseAuth
      User? firebaseUser = FirebaseAuth.instance.currentUser;
      if (firebaseUser != null) {
        // Kiểm tra xem tài khoản đã tồn tại trong Firestore chưa
        QuerySnapshot snapshot =
            await FirebaseFirestore.instance
                .collection('khachhang')
                .where(
                  'email',
                  isEqualTo: firebaseUser.email,
                ) // Dùng email làm tài khoản trong Firestore
                .get();

        if (snapshot.docs.isEmpty) {
          // Nếu chưa có tài khoản trong Firestore, tạo mới
          String userId =
              'KH${DateTime.now().day.toString().padLeft(2, '0')}${DateTime.now().month.toString().padLeft(2, '0')}${DateTime.now().year.toString().substring(2)}01';

          await FirebaseFirestore.instance.collection('khachhang').doc().set({
            'id': userId,
            'hotenkh': firebaseUser.displayName ?? 'Chưa có tên',
            'TaiKhoan': firebaseUser.email, // Lưu email làm tài khoản
            'matkhau': '', // Mật khẩu không cần thiết khi đăng nhập qua Google
            'gioitinh': 'Nam', // Giới tính mặc định
            'ngaysinh': '', // Ngày sinh mặc định
            'sdt': '', // Số điện thoại mặc định
            'diachi': '', // Địa chỉ mặc định
            'email': firebaseUser.email,
          });
        }
      }

      // Lấy email từ firebaseUser sau khi đăng nhập
      String userEmail = firebaseUser?.email ?? '';

      // Điều hướng tới trang chủ sau khi đăng nhập thành công
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => TrangChu()),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Lỗi đăng nhập Google: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Đăng nhập"),
        backgroundColor: AppColors.primary,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo hoặc hình nền
                  Image.asset(
                    'assets/images/Logo.jpg', // Thay thế bằng logo của bạn
                    height: 120.0,
                    width: 120.0,
                  ),
                  const SizedBox(height: 20),

                  // Đăng nhập với Google
                  ElevatedButton.icon(
                    onPressed: () => signInWithGoogle(context),
                    icon: Icon(Icons.g_mobiledata),
                    label: Text("Đăng nhập với Google"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(
                        horizontal: 30,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),

                  // Nhập Tài khoản
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: TextFormField(
                      controller: TaiKhoanController,
                      decoration: InputDecoration(
                        labelText: "Tài khoản",
                        prefixIcon: Icon(Icons.person),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        filled: true,
                        fillColor: Colors.grey[200],
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Vui lòng nhập Tài khoản';
                        }
                        return null;
                      },
                    ),
                  ),

                  // Nhập mật khẩu
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: TextFormField(
                      controller: passwordController,
                      obscureText: _obscureText,
                      decoration: InputDecoration(
                        labelText: "Mật khẩu",
                        prefixIcon: Icon(Icons.lock_outline),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscureText
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscureText = !_obscureText;
                            });
                          },
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        filled: true,
                        fillColor: Colors.grey[200],
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Vui lòng nhập mật khẩu';
                        }
                        return null;
                      },
                    ),
                  ),

                  // Nút đăng nhập
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: ElevatedButton(
                      onPressed: _logIn,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        padding: EdgeInsets.symmetric(
                          horizontal: 50,
                          vertical: 15,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        textStyle: TextStyle(fontSize: 18),
                      ),
                      child: Text('Đăng nhập'),
                    ),
                  ),

                  // Đăng ký và quên mật khẩu
                  Column(
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => DangKy()),
                          );
                        },
                        child: Text(
                          "Chưa có tài khoản? Đăng ký",
                          style: TextStyle(
                            color: AppColors.primary,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => QuenMatKhau(),
                            ),
                          );
                        },
                        child: Text(
                          "Quên mật khẩu?",
                          style: TextStyle(
                            color: AppColors.primary,
                            fontSize: 16,
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
      ),
    );
  }
}
