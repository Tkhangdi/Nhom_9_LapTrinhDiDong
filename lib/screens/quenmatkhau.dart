import 'package:flutter/material.dart';
import 'package:shop_ban_dong_ho/utils/app_colors.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class QuenMatKhau extends StatefulWidget {
  const QuenMatKhau({super.key});

  @override
  State<QuenMatKhau> createState() => _QuenMatKhauState();
}

class _QuenMatKhauState extends State<QuenMatKhau> {
  final TextEditingController _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldMessengerState> _scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();

  Future<Database> _openDatabase() async {
    return openDatabase(
      join(await getDatabasesPath(), 'khachhang.db'),
      version: 1,
    );
  }

  Future<bool> _isEmailExist(String email) async {
    final db = await _openDatabase();
    final List<Map<String, dynamic>> result = await db.query(
      'users',
      where: 'email = ?',
      whereArgs: [email],
    );
    return result.isNotEmpty;
  }

  Future<void> _resetPassword() async {
    final email = _emailController.text.trim();
    if (await _isEmailExist(email)) {
      _scaffoldMessengerKey.currentState?.showSnackBar(
        SnackBar(
          content: Text(
            'Email khôi phục mật khẩu đã được gửi!',
            style: TextStyle(fontSize: 18.0),
          ),
        ),
      );
    } else {
      _scaffoldMessengerKey.currentState?.showSnackBar(
        SnackBar(
          content: Text(
            'Không tìm thấy tài khoản với email này.',
            style: TextStyle(fontSize: 18.0),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldMessengerKey,
      backgroundColor: AppColors.background,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          children: [
            const SizedBox(height: 70.0),
            const Text(
              'Khôi phục mật khẩu',
              style: TextStyle(
                color: Colors.white,
                fontSize: 30.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10.0),
            const Text(
              'Nhập email của bạn',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20.0),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          spreadRadius: 1,
                          blurRadius: 5,
                        ),
                      ],
                    ),
                    child: TextFormField(
                      controller: _emailController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Vui lòng nhập email';
                        }
                        return null;
                      },
                      style: const TextStyle(color: Colors.black),
                      decoration: const InputDecoration(
                        hintText: 'Email',
                        hintStyle: TextStyle(
                          fontSize: 18.0,
                          color: AppColors.primary,
                        ),
                        prefixIcon: Icon(
                          Icons.email,
                          color: AppColors.primary,
                          size: 30.0,
                        ),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 40.0),
                  GestureDetector(
                    onTap: () {
                      if (_formKey.currentState!.validate()) {
                        _resetPassword();
                      }
                    },
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(15.0),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary,
                            spreadRadius: 2,
                            blurRadius: 6,
                          ),
                        ],
                      ),
                      child: const Center(
                        child: Text(
                          'Gửi email',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 50.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Chưa có tài khoản?',
                        style: TextStyle(fontSize: 18.0, color: Colors.white),
                      ),
                      const SizedBox(width: 5.0),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, '/dangky');
                        },
                        child: const Text(
                          'Tạo tài khoản',
                          style: TextStyle(
                            color: AppColors.primary,
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
          ],
        ),
      ),
    );
  }
}
