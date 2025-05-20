import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shop_ban_dong_ho/screens/dangnhap.dart';
import 'package:shop_ban_dong_ho/utils/app_colors.dart';

class DangKy extends StatefulWidget {
  const DangKy({super.key});

  @override
  _DangKyState createState() => _DangKyState();
}

class _DangKyState extends State<DangKy> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController hotenkhController = TextEditingController();
  final TextEditingController TaiKhoanController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController ngaysinhController = TextEditingController();
  final TextEditingController sdtController = TextEditingController();
  final TextEditingController diachiController = TextEditingController();
  final TextEditingController emailController =
      TextEditingController(); // Thêm trường email
  String _selectedgioitinh = 'Nam';

  // Kiểm tra tài khoản
  bool _validateTaiKhoan(String value) {
    final regex = RegExp(r'^[a-zA-Z0-9]{6,}$');
    return regex.hasMatch(value);
  }

  // Kiểm tra số điện thoại hợp lệ
  bool _validateSDT(String value) {
    final regex = RegExp(r'^(0[3-9])\d{8}$');
    return regex.hasMatch(value);
  }

  // Kiểm tra mật khẩu
  bool _validatePassword(String value) {
    final regex = RegExp(r'^(?=.*[A-Z])(?=.*[a-z])(?=.*\d).{6,}$');
    return regex.hasMatch(value);
  }

  // Kiểm tra email hợp lệ
  bool _validateEmail(String value) {
    final regex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    return regex.hasMatch(value);
  }

  Future<void> _signUp() async {
    if (_formKey.currentState!.validate()) {
      String userId =
          'KH${DateTime.now().day.toString().padLeft(2, '0')}${DateTime.now().month.toString().padLeft(2, '0')}${DateTime.now().year.toString().substring(2)}01';

      try {
        // Kiểm tra xem tài khoản đã tồn tại chưa
        QuerySnapshot snapshot =
            await FirebaseFirestore.instance
                .collection('khachhang')
                .where('TaiKhoan', isEqualTo: TaiKhoanController.text)
                .get();

        if (snapshot.docs.isNotEmpty) {
          // Tài khoản đã tồn tại
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Tài khoản này đã tồn tại!')));
          return; // Dừng quá trình đăng ký
        }

        // Kiểm tra xem email đã tồn tại chưa
        QuerySnapshot emailSnapshot =
            await FirebaseFirestore.instance
                .collection('khachhang')
                .where('email', isEqualTo: emailController.text)
                .get();

        if (emailSnapshot.docs.isNotEmpty) {
          // Email đã tồn tại
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Email này đã được đăng ký!')));
          return; // Dừng quá trình đăng ký
        }

        // Nếu tài khoản và email chưa tồn tại, tiếp tục đăng ký
        await FirebaseFirestore.instance.collection('khachhang').doc().set({
          'id': userId,
          'hotenkh': hotenkhController.text,
          'TaiKhoan': TaiKhoanController.text,
          'matkhau': passwordController.text,
          'gioitinh': _selectedgioitinh,
          'ngaysinh': ngaysinhController.text,
          'sdt': sdtController.text,
          'diachi': diachiController.text,
          'email': emailController.text, // Lưu email vào Firestore
        });

        // Hiển thị thông báo thành công
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Đăng ký thành công!')));
      } catch (e) {
        print("Error during sign-up: $e");
        print("Error type: ${e.runtimeType}");

        // Kiểm tra lỗi nếu có lỗi liên quan đến Firestore
        if (e is FirebaseException) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Lỗi Firestore: ${e.message}')),
          );
        } else {
          // Xử lý các lỗi không xác định
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Lỗi không xác định: $e')));
          print("Detailed error: ${e.toString()}");
        }
      }
    }
  }

  // Reset form
  void _resetForm() {
    hotenkhController.clear();
    TaiKhoanController.clear();
    passwordController.clear();
    ngaysinhController.clear();
    sdtController.clear();
    diachiController.clear();
    emailController.clear(); // Reset trường email
    setState(() {
      _selectedgioitinh = 'Nam';
    });
  }

  Future<void> _selectngaysinh(BuildContext context) async {
    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (selectedDate != null) {
      setState(() {
        ngaysinhController.text = "${selectedDate.toLocal()}".split(' ')[0];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Đăng ký"),
        backgroundColor: AppColors.primary,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Center(
          child: Card(
            elevation: 8.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.0),
            ),
            child: Padding(
              padding: EdgeInsets.all(20.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Image.asset(
                      "assets/images/Logo.jpg",
                      width: MediaQuery.of(context).size.width / 2,
                      height: 150,
                      fit: BoxFit.contain,
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      controller: hotenkhController,
                      decoration: InputDecoration(
                        labelText: "Họ và tên",
                        prefixIcon: Icon(
                          Icons.person,
                          color: AppColors.primary,
                        ),
                        border: OutlineInputBorder(),
                      ),
                      validator:
                          (value) =>
                              value == null || value.isEmpty
                                  ? 'Vui lòng nhập họ và tên'
                                  : null,
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      controller: TaiKhoanController,
                      decoration: InputDecoration(
                        labelText: "Tài khoản",
                        prefixIcon: Icon(
                          Icons.person,
                          color: AppColors.primary,
                        ),
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Vui lòng nhập tài khoản';
                        } else if (!_validateTaiKhoan(value)) {
                          return 'Tài khoản phải có ít nhất 6 ký tự và chỉ chứa chữ cái và số';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      controller: passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: "Mật khẩu",
                        prefixIcon: Icon(Icons.lock, color: AppColors.primary),
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty)
                          return 'Vui lòng nhập mật khẩu';
                        else if (!_validatePassword(value))
                          return 'Mật khẩu phải có chữ hoa, chữ thường, số và ít nhất 6 ký tự';
                        return null;
                      },
                    ),
                    SizedBox(height: 10),
                    // Thêm trường email vào đây
                    TextFormField(
                      controller: emailController,
                      decoration: InputDecoration(
                        labelText: "Email",
                        prefixIcon: Icon(Icons.email, color: AppColors.primary),
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Vui lòng nhập email';
                        } else if (!_validateEmail(value)) {
                          return 'Email không hợp lệ';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 10),
                    DropdownButtonFormField<String>(
                      value: _selectedgioitinh,
                      decoration: InputDecoration(
                        labelText: 'Giới tính',
                        border: OutlineInputBorder(),
                      ),
                      items:
                          ['Nam', 'Nữ']
                              .map(
                                (gt) => DropdownMenuItem(
                                  value: gt,
                                  child: Text(gt),
                                ),
                              )
                              .toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedgioitinh = value!;
                        });
                      },
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      controller: sdtController,
                      decoration: InputDecoration(
                        labelText: "Số điện thoại",
                        prefixIcon: Icon(Icons.phone, color: AppColors.primary),
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty)
                          return 'Vui lòng nhập số điện thoại';
                        else if (!_validateSDT(value))
                          return 'Số điện thoại không hợp lệ';
                        return null;
                      },
                    ),
                    SizedBox(height: 10),
                    GestureDetector(
                      onTap: () => _selectngaysinh(context),
                      child: AbsorbPointer(
                        child: TextFormField(
                          controller: ngaysinhController,
                          decoration: InputDecoration(
                            labelText: "Ngày sinh",
                            prefixIcon: Icon(
                              Icons.calendar_today,
                              color: AppColors.primary,
                            ),
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty)
                              return 'Vui lòng chọn ngày sinh';
                            return null;
                          },
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      controller: diachiController,
                      decoration: InputDecoration(
                        labelText: "Địa chỉ",
                        prefixIcon: Icon(Icons.home, color: AppColors.primary),
                        border: OutlineInputBorder(),
                      ),
                      validator:
                          (value) =>
                              value == null || value.isEmpty
                                  ? 'Vui lòng nhập địa chỉ'
                                  : null,
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: _signUp,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                          ),
                          child: Text("ĐĂNG KÝ"),
                        ),
                        SizedBox(width: 20),
                        ElevatedButton(
                          onPressed: _resetForm,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.secondary,
                          ),
                          child: Text("ĐẶT LẠI"),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => DangNhap()),
                        );
                      },
                      child: Text(
                        "Đã có tài khoản? Đăng nhập ngay",
                        style: TextStyle(color: AppColors.primary),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
