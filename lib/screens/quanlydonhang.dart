import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class QuanLyDonHangScreen extends StatefulWidget {
  const QuanLyDonHangScreen({super.key});

  @override
  State<QuanLyDonHangScreen> createState() => _QuanLyDonHangScreenState();
}

class _QuanLyDonHangScreenState extends State<QuanLyDonHangScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<Map<String, String>> _tabs = [
    {'title': 'Chờ xác nhận', 'status': 'pending'},
    {'title': 'Chờ giao hàng', 'status': 'delivering'},
    {'title': 'Đã giao', 'status': 'delivered'},
    {'title': 'Trả hàng', 'status': 'returned'},
    {'title': 'Đã hủy', 'status': 'cancelled'},
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
  }

  Stream<QuerySnapshot> getDonHangTheoTrangThai(String trangThai) {
    return FirebaseFirestore.instance
        .collection('orders')
        .where('trangThai', isEqualTo: trangThai)
        .snapshots();
  }

  Widget buildDonHangCard(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: ExpansionTile(
        title: Text("Mã đơn: ${data['orderId']}"),
        subtitle: Text("Khách: ${data['hoTen']}"),
        children: [
          ...List.generate((data['danhSachSanPham'] as List).length, (index) {
            final sp = data['danhSachSanPham'][index];
            return ListTile(
              title: Text(sp['ten']),
              subtitle: Text('Số lượng: ${sp['soLuong']}'),
              trailing: Text('${sp['gia']}đ'),
            );
          }),
          const Divider(),
          ListTile(
            title: const Text("Tổng cộng"),
            trailing: Text("${data['tongCong']}đ"),
          ),
          ListTile(
            title: const Text("Phương thức thanh toán"),
            trailing: Text(data['phuongThucThanhToan']),
          ),
          ListTile(
            title: const Text("Địa chỉ giao hàng"),
            subtitle: Text(data['diaChi']),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: _tabs.length,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Quản lý đơn hàng'),
          bottom: TabBar(
            controller: _tabController,
            isScrollable: true,
            tabs: _tabs.map((tab) => Tab(text: tab['title'])).toList(),
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children:
              _tabs.map((tab) {
                return StreamBuilder<QuerySnapshot>(
                  stream: getDonHangTheoTrangThai(tab['status']!),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return const Center(child: Text("Không có đơn hàng."));
                    }

                    final docs = snapshot.data!.docs;
                    return ListView.builder(
                      itemCount: docs.length,
                      itemBuilder:
                          (context, index) => buildDonHangCard(docs[index]),
                    );
                  },
                );
              }).toList(),
        ),
      ),
    );
  }
}
