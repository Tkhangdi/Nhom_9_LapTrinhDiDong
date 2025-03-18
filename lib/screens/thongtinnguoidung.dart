import 'package:flutter/material.dart';

class MyAccountScreen extends StatefulWidget {
  const MyAccountScreen({super.key});

  @override
  _MyAccountScreenState createState() => _MyAccountScreenState();
}

class _MyAccountScreenState extends State<MyAccountScreen> {
  // Giả lập thông tin người dùng
  String userName = "Nguyễn Văn A";
  String userEmail = "nguyenvana@example.com";
  String userPhone = "0123 456 789";
  String userAddress = "123 Đường ABC, Quận 1, TP.HCM";
  String userGender = "Nam";
  String userPassword = "MatKhau123";

  bool isPasswordHidden = true;

  String obfuscate(String text) {
    if (text.length <= 2) return text; // Nếu quá ngắn thì không ẩn
    return "${text[0]}${'*' * (text.length - 2)}${text[text.length - 1]}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Thông tin cá nhân"),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const CircleAvatar(
                  radius: 40,
                  backgroundImage: AssetImage("assets/images/avatar.jpg"),
                ),
                const SizedBox(width: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      userName,
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      obfuscate(userEmail),
                      style: const TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
            buildUserInfo(Icons.person, "Tên", userName, () {
              _showEditDialog("Tên", userName, (newValue) {
                setState(() => userName = newValue);
              });
            }),
            buildUserInfo(Icons.phone, "Số điện thoại", userPhone, () {
              _showEditDialog("Số điện thoại", userPhone, (newValue) {
                setState(() => userPhone = newValue);
              });
            }),
            buildUserInfo(Icons.home, "Địa chỉ", userAddress, () {
              _showEditDialog("Địa chỉ", userAddress, (newValue) {
                setState(() => userAddress = newValue);
              });
            }),
            buildUserInfo(Icons.wc, "Giới tính", userGender, () {
              _showGenderSelection();
            }),
            buildUserInfo(Icons.email, "Email", obfuscate(userEmail), null),
            buildUserInfo(Icons.lock, "Mật khẩu", isPasswordHidden ? "********" : userPassword, () {
              setState(() {
                isPasswordHidden = !isPasswordHidden;
              });
            }),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                child: const Text("Quay lại"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildUserInfo(IconData icon, String title, String value, VoidCallback? onTap) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: InkWell(
        onTap: onTap,
        child: Row(
          children: [
            Icon(icon, color: Colors.blue),
            const SizedBox(width: 10),
            Text(
              title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const Spacer(),
            Text(
              value,
              style: const TextStyle(fontSize: 16, color: Colors.black87),
            ),
            if (onTap != null) const Icon(Icons.edit, color: Colors.grey, size: 18),
          ],
        ),
      ),
    );
  }

  void _showEditDialog(String title, String currentValue, Function(String) onSave) {
    TextEditingController controller = TextEditingController(text: currentValue);
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Chỉnh sửa $title"),
          content: TextField(controller: controller),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Hủy"),
            ),
            TextButton(
              onPressed: () {
                onSave(controller.text);
                Navigator.pop(context);
              },
              child: const Text("Lưu"),
            ),
          ],
        );
      },
    );
  }

  void _showGenderSelection() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Chọn giới tính"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text("Nam"),
                leading: Radio<String>(
                  value: "Nam",
                  groupValue: userGender,
                  onChanged: (value) {
                    setState(() => userGender = value!);
                    Navigator.pop(context);
                  },
                ),
              ),
              ListTile(
                title: const Text("Nữ"),
                leading: Radio<String>(
                  value: "Nữ",
                  groupValue: userGender,
                  onChanged: (value) {
                    setState(() => userGender = value!);
                    Navigator.pop(context);
                  },
                ),
              ),
              ListTile(
                title: const Text("Khác"),
                leading: Radio<String>(
                  value: "Khác",
                  groupValue: userGender,
                  onChanged: (value) {
                    setState(() => userGender = value!);
                    Navigator.pop(context);
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
