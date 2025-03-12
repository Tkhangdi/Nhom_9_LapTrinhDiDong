import 'package:shop_ban_dong_ho/models/KhachHang.dart';
import 'package:shop_ban_dong_ho/screens/dangnhap.dart';
import 'package:shop_ban_dong_ho/utils/app_colors.dart';
import 'package:shop_ban_dong_ho/utils/data.dart';
import 'package:flutter/material.dart';

class DangKy extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<DangKy> {
  final _formkey = GlobalKey<FormState>();
  final TextEditingController namecontroller = TextEditingController();
  final TextEditingController mailcontroller = TextEditingController();
  final TextEditingController passwordcontroller = TextEditingController();
  final TextEditingController birthdatecontroller = TextEditingController();
  final TextEditingController phonecontroller = TextEditingController();
  final TextEditingController addresscontroller = TextEditingController();
  String _selectedGender = 'Nam'; // Default gender

  // Validations

  bool isValidEmail(String email) {
    final regex = RegExp(r'^[a-zA-Z0-9._%+-]+@gmail\.com$');
    return regex.hasMatch(email);
  }

  bool isValidPhone(String phone) {
    final regex = RegExp(r'^(0[3-9])\d{8}$');
    return regex.hasMatch(phone);
  }

  bool isValidPassword(String password) {
    final regex = RegExp(r'^(?=.*[A-Z])(?=.*[a-z])(?=.*\d).{6,}$');
    return regex.hasMatch(password);
  }

  bool isValidBirthdate(String birthdate) {
    try {
      DateTime birthDateTime = DateTime.parse(birthdate);
      DateTime today = DateTime.now();
      int age = today.year - birthDateTime.year;
      if (today.month < birthDateTime.month ||
          (today.month == birthDateTime.month &&
              today.day < birthDateTime.day)) {
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

  void _signUp() async {
    if (_formkey.currentState!.validate()) {
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
        name: namecontroller.text,
        email: mailcontroller.text,
        password: passwordcontroller.text,
        gender: _selectedGender,
        birthdate: birthdatecontroller.text,
        phone: phonecontroller.text,
        address: addresscontroller.text,
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
    if (!isValidEmail(mailcontroller.text)) {
      return 'Email phải có định dạng đúng, ví dụ: abc@gmail.com';
    }

    bool emailUnique = await isEmailUnique(mailcontroller.text);
    if (!emailUnique) {
      return 'Email này đã được sử dụng! Vui lòng chọn email khác';
    }

    if (!isValidPassword(passwordcontroller.text)) {
      return 'Mật khẩu phải có ít nhất 6 ký tự, bao gồm ít nhất 1 chữ hoa, 1 chữ thường và 1 số.';
    }

    if (!isValidBirthdate(birthdatecontroller.text)) {
      return 'Bạn phải ít nhất 16 tuổi để đăng ký!';
    }

    if (!isValidPhone(phonecontroller.text)) {
      return 'Số điện thoại không hợp lệ. Vui lòng nhập đủ 10 chữ số.';
    }

    return null;
  }

  Future<void> _selectBirthdate(BuildContext context) async {
    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (selectedDate != null) {
      setState(() {
        birthdatecontroller.text = "${selectedDate.toLocal()}".split(' ')[0];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            children: [
              SizedBox(height: MediaQuery.of(context).size.height / 10),

              Center(
                child: Image.asset(
                  "assets/logo.jpg",
                  width: MediaQuery.of(context).size.width / 2,
                  height: 150,
                  fit: BoxFit.contain,
                ),
              ),
              SizedBox(height: 50.0),
              Material(
                elevation: 10.0,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height / 1.8,
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    // Removed borderRadius
                  ),
                  child: Form(
                    key: _formkey,
                    child: Column(
                      children: [
                        SizedBox(height: 30.0),
                        Text(
                          "Sign up",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                        SizedBox(height: 30.0),
                        _buildTextField(
                          namecontroller,
                          'Tên',
                          Icons.person_outlined,
                        ),
                        _buildTextField(
                          mailcontroller,
                          'Email',
                          Icons.email_outlined,
                        ),
                        _buildTextField(
                          passwordcontroller,
                          'Mật khẩu',
                          Icons.lock_outline,
                          obscureText: true,
                        ),
                        _buildDropdown(),
                        _buildTextField(
                          phonecontroller,
                          'Số điện thoại',
                          Icons.phone,
                        ),
                        _buildBirthdateField(),
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
      ),
    );
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
        value: _selectedGender,
        decoration: InputDecoration(
          labelText: 'Giới tính',
          labelStyle: TextStyle(color: AppColors.primary),
          border: OutlineInputBorder(
            borderSide: BorderSide(color: AppColors.primary, width: 1),
          ),
        ),
        onChanged: (String? newValue) {
          setState(() {
            _selectedGender = newValue!;
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

  Widget _buildBirthdateField() {
    return GestureDetector(
      onTap: () => _selectBirthdate(context),
      child: AbsorbPointer(
        child: TextFormField(
          controller: birthdatecontroller,
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
              "Đăng Ký",
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
}
