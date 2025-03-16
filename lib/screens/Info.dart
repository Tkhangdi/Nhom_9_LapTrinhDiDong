import 'package:flutter/material.dart';

void main() {
  runApp(Info());
}

class Info extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ProfileScreen(),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
        ),
        child: Column(
          children: [
            SizedBox(height: 20),
            CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage(
                'assets/profile_picture.png',
              ), // Thay đổi đường dẫn nếu cần
            ),
            SizedBox(height: 10),
            Text(
              'Tran Khang Di',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView(
                children: [
                  _buildListTile(context,'My Account', Icons.account_circle),
                  _buildListTile(context,'Notifications', Icons.notifications),
                  _buildListTile(context,'Settings', Icons.settings,isSettings: true),
                  _buildListTile(context,'Help Center', Icons.help),
                  _buildListTile(context,'Log Out', Icons.logout),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildListTile(BuildContext context, String title, IconData icon,{bool isSettings = false}) {
    return Container(
      margin: EdgeInsets.only(
        top: 30,
      ), // Khoảng cách giữa các ListTile
      decoration: BoxDecoration(
        color: Colors.grey[200], // Màu nền xám
        borderRadius: BorderRadius.circular(10), // Bo góc
      ),
      child: ListTile(
        leading: Icon(icon, color: Colors.orange[400],size: 38,), // Màu cam cho icon
        title: Text(title, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        onTap: () {
          if (isSettings) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SettingsScreen()),
            );
          }
        },
      ),
    );
  }
}



class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: ListView(
        children: [
          _buildListTile(context, 'Chat setting', Icons.chat),
          _buildListTile(context, 'Language', Icons.language),
          _buildListTile(context, 'Delivery Address', Icons.location_on),
          _buildListTile(context, 'Payment Methods', Icons.payment),
          _buildListTile(context, 'Privacy Policy', Icons.privacy_tip),
        ],
      ),
    );
  }

  Widget _buildListTile(BuildContext context, String title, IconData icon) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        leading: Icon(icon, color: Colors.orange),
        title: Text(title),
        onTap: () {
          // Thêm hàm để xử lý khi nhấn vào từng mục, ví dụ:
          // Navigator.push(...)
        },
      ),
    );
  }
}
