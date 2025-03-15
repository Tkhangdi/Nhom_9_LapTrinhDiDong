import 'package:flutter/material.dart';
import 'package:shop_ban_dong_ho/screens/thongbao.dart';// Import màn hình thông báo

class Info extends StatelessWidget {
  const Info({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20),
            Center(
              child: Column(
                children: [
                  Stack(
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.grey[300],
                        backgroundImage: AssetImage("assets/images/avatar.jpg"),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: CircleAvatar(
                          radius: 15,
                          backgroundColor: Colors.white,
                          child: Icon(Icons.camera_alt, color: Colors.grey),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Profile",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView(
                children: [
                  buildMenuItem(
                    context,
                    icon: Icons.person_outline,
                    text: "My Account",
                  ),
                  buildMenuItem(
                    context,
                    icon: Icons.notifications_outlined,
                    text: "Notifications",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const NotificationScreen()),
                      );
                    },
                  ),
                  buildMenuItem(
                    context,
                    icon: Icons.settings,
                    text: "Settings",
                  ),
                  buildMenuItem(
                    context,
                    icon: Icons.help_outline,
                    text: "Help Center",
                  ),
                  buildMenuItem(
                    context,
                    icon: Icons.logout,
                    text: "Log Out",
                    color: Colors.red,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildMenuItem(BuildContext context,
      {required IconData icon, required String text, Color color = Colors.black, VoidCallback? onTap}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: InkWell(
        onTap: onTap ??
            () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("$text chưa được phát triển.")),
              );
            },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              Icon(icon, color: color),
              const SizedBox(width: 15),
              Expanded(
                child: Text(
                  text,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: color),
                ),
              ),
              const Icon(Icons.lock, size: 16, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}
