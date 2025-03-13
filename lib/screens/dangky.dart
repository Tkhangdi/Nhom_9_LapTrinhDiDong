import 'package:shop_ban_dong_ho/models/KhachHang.dart';
import 'package:shop_ban_dong_ho/screens/dangnhap.dart';
import 'package:shop_ban_dong_ho/utils/app_colors.dart';
import 'package:shop_ban_dong_ho/utils/data.dart';
import 'package:flutter/material.dart';

class DangKy extends StatefulWidget {
  @override
  _DangKyState createState() => _DangKyState();
}

class _DangKyState extends State<DangKy> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController hotenkhController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController ngaysinhController = TextEditingController();
  final TextEditingController sdtController = TextEditingController();
  final TextEditingController diachiController = TextEditingController();
  String _selectedgioitinh = 'Nam';

  bool KiemTraEmail(String email) {
    final regex = RegExp(r'^[a-zA-Z0-9._%+-]+@gmail\.com$');
    return regex.hasMatch(email);
  }

  bool KiemTraSDT(String sdt) {
    final regex = RegExp(r'^(0[3-9])\d{8}$');
    return regex.hasMatch(sdt);
  }

  bool KiemTraMatKhau(String password) {
    final regex = RegExp(r'^(?=.*[A-Z])(?=.*[a-z])(?=.*\d).{6,}$');
    return regex.hasMatch(password);
  }

  bool KiemTraNgaySinh(String ngaysinh) {
    try {
      DateTime ngaysinhTime = DateTime.parse(ngaysinh);
      DateTime today = DateTime.now();
      int age = today.year - ngaysinhTime.year;
      if (today.month < ngaysinhTime.month ||
          (today.month == ngaysinhTime.month && today.day < ngaysinhTime.day)) {
        age--;
      }
      return age >= 16;
    } catch (e) {
      return false;
    }
  }

  Future<bool> isEmailUnique(String email) async {
    DuLieu db = DuLieu();
    var existingUsers = await db.getUsersByEmail(email);
    return existingUsers.isEmpty;
  }

  Future<void> _signUp() async {
    if (_formKey.currentState!.validate()) {
      String? validationMessage = await _validateFields();
      if (validationMessage != null) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(validationMessage)));
        return;
      }

      String userId =
          'KH${DateTime.now().day.toString().padLeft(2, '0')}${DateTime.now().month.toString().padLeft(2, '0')}${DateTime.now().year.toString().substring(2)}01';

      KhachHang user = KhachHang(
        id: userId,
        hotenkh: hotenkhController.text,
        email: emailController.text,
        password: passwordController.text,
        gioitinh: _selectedgioitinh,
        ngaysinh: ngaysinhController.text,
        sdt: sdtController.text,
        diachi: diachiController.text,
      );

      try {
        DuLieu db = DuLieu();
        await db.insertUser(user.toMap());
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Đăng ký thành công! Bạn có thể đăng nhập ngay'),
          ),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => DangNhap()),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Đã có lỗi xảy ra khi đăng ký. Vui lòng thử lại sau!',
            ),
          ),
        );
        print("Error during user registration: $e");
      }
    }
  }

  Future<String?> _validateFields() async {
    if (!KiemTraEmail(emailController.text)) {
      return 'Email phải có định dạng đúng, ví dụ: abc@gmail.com';
    }

    bool emailUnique = await isEmailUnique(emailController.text);
    if (!emailUnique) {
      return 'Email này đã được sử dụng! Vui lòng chọn email khác';
    }

    if (!KiemTraMatKhau(passwordController.text)) {
      return 'Mật khẩu phải có ít nhất 6 ký tự, bao gồm ít nhất 1 chữ hoa, 1 chữ thường và 1 số.';
    }

    if (!KiemTraNgaySinh(ngaysinhController.text)) {
      return 'Bạn phải ít nhất 16 tuổi để đăng ký!';
    }

    if (!KiemTraSDT(sdtController.text)) {
      return 'Số điện thoại không hợp lệ. Vui lòng nhập đủ 10 chữ số.';
    }

    return null;
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

  Widget _buildTextField(
    TextEditingController controller,
    String hintText,
    IconData icon, {
    bool obscureText = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: TextFormField(
        controller: controller,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Vui lòng nhập $hintText';
          }
          return null;
        },
        obscureText: obscureText,
        decoration: InputDecoration(
          hintText: hintText,
          labelText: hintText,
          prefixIcon: Icon(icon, color: AppColors.primary),
          border: OutlineInputBorder(
            borderSide: BorderSide(color: AppColors.primary, width: 1),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: AppColors.primary, width: 2),
          ),
        ),
      ),
    );
  }

  Widget _buildDropdown() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: DropdownButtonFormField<String>(
        value: _selectedgioitinh,
        decoration: InputDecoration(
          labelText: 'Giới tính',
          labelStyle: TextStyle(color: AppColors.primary),
          border: OutlineInputBorder(
            borderSide: BorderSide(color: AppColors.primary, width: 1),
          ),
        ),
        onChanged: (String? newValue) {
          setState(() {
            _selectedgioitinh = newValue!;
          });
        },
        items:
            <String>['Nam', 'Nữ', 'Khác'].map<DropdownMenuItem<String>>((
              String value,
            ) {
              return DropdownMenuItem<String>(value: value, child: Text(value));
            }).toList(),
      ),
    );
  }

  Widget _buildngaysinhField() {
    return GestureDetector(
      onTap: () => _selectngaysinh(context),
      child: AbsorbPointer(
        child: TextFormField(
          controller: ngaysinhController,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Vui lòng nhập ngày sinh';
            }
            return null;
          },
          decoration: InputDecoration(
            hintText: 'Ngày sinh',
            prefixIcon: Icon(Icons.calendar_today, color: AppColors.primary),
            border: OutlineInputBorder(
              borderSide: BorderSide(color: AppColors.primary, width: 1),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSignUpButton() {
    return GestureDetector(
      onTap: _signUp,
      child: Material(
        elevation: 5.0,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 12.0),
          width: 200,
          decoration: BoxDecoration(color: AppColors.primary),
          child: Center(
            child: Text(
              "ĐĂNG KÝ",
              style: TextStyle(
                color: Colors.white,
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Stack(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height / 2.5,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [AppColors.primary, AppColors.primary],
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(
                top: MediaQuery.of(context).size.height / 3,
              ),
              height: MediaQuery.of(context).size.height / 2,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 60.0, left: 20.0, right: 20.0),
              child: Column(
                children: [
                  Center(
                    child: Image.asset(
                      "assets/images/Logo.jpg",
                      width: MediaQuery.of(context).size.width / 2,
                      height: 150,
                      fit: BoxFit.contain,
                    ),
                  ),
                  SizedBox(height: 50.0),
                  Material(
                    elevation: 5.0,
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      padding: EdgeInsets.only(left: 20.0, right: 20.0),
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height / 2,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            SizedBox(height: 30.0),
                            Text(
                              "ĐĂNG KÝ",
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: AppColors.secondary,
                              ),
                            ),
                            SizedBox(height: 30.0),
                            _buildTextField(
                              hotenkhController,
                              'Tên',
                              Icons.person_outlined,
                            ),
                            _buildTextField(
                              emailController,
                              'Email',
                              Icons.email_outlined,
                            ),
                            _buildTextField(
                              passwordController,
                              'Mật khẩu',
                              Icons.lock_outline,
                              obscureText: true,
                            ),
                            _buildDropdown(),
                            _buildTextField(
                              sdtController,
                              'Số điện thoại',
                              Icons.phone,
                            ),
                            _buildngaysinhField(),
                            SizedBox(height: 40.0),
                            _buildSignUpButton(),
                            SizedBox(height: 20.0),
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
                                "Đã có tài khoản? Đăng nhập",
                                style: TextStyle(
                                  color: AppColors.textSecondary,
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
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
