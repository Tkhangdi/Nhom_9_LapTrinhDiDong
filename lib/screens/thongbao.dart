import 'package:flutter/material.dart';
import 'package:shop_ban_dong_ho/models/ThongBao.dart';
import 'package:shop_ban_dong_ho/service/ThongBaoService.dart';
import 'package:shop_ban_dong_ho/utils/app_colors.dart';
import 'package:intl/intl.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> with SingleTickerProviderStateMixin {
  final ThongBaoService _thongBaoService = ThongBaoService();
  List<ThongBao> _danhSachThongBao = [];
  bool _isLoading = true;
  late TabController _tabController;
  int _selectedTab = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      setState(() {
        _selectedTab = _tabController.index;
      });
      _loadThongBao();
    });
    _loadThongBao();
    
    // Demo: Thêm thông báo mẫu nếu không có dữ liệu
    _checkAndAddDemoData();
  }

  Future<void> _checkAndAddDemoData() async {
    List<ThongBao> thongBaos = await _thongBaoService.getAllThongBao();
    if (thongBaos.isEmpty) {
      await _themThongBaoDemo();
    }
  }

  Future<void> _themThongBaoDemo() async {
    // Thêm mẫu thông báo đơn hàng
    await _thongBaoService.insertThongBao(
      ThongBao(
        title: "Đơn hàng đã giao",
        message: "Đơn hàng 24089794727000824 đã hoàn thành và đến địa chỉ nhận hàng (Vui lòng đánh giá đơn hàng).",
        date: DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now().subtract(const Duration(hours: 2))),
        type: 1,
      )
    );
    
    await _thongBaoService.insertThongBao(
      ThongBao(
        title: "Đơn hàng thành công",
        message: "Đơn hàng 24089794727000824 đã được xác nhận. Vui lòng đợi sản phẩm được gửi đi.",
        date: DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now().subtract(const Duration(days: 1))),
        type: 1,
      )
    );

    // Thêm mẫu thông báo khuyến mãi
    await _thongBaoService.insertThongBao(
      ThongBao(
        title: "Khuyến mãi hè rực rỡ!",
        message: "Giảm đến 30% cho tất cả các mẫu đồng hồ Casio trong tháng 5. Mua ngay!",
        date: DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now().subtract(const Duration(days: 2))),
        type: 2,
      )
    );

    await _thongBaoService.insertThongBao(
      ThongBao(
        title: "Flash Sale sắp diễn ra",
        message: "Đồng hồ Rolex Submariner giảm 15% vào ngày mai. Đừng bỏ lỡ cơ hội!",
        date: DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now().subtract(const Duration(days: 3))),
        type: 2,
      )
    );
  }

  Future<void> _loadThongBao() async {
    setState(() {
      _isLoading = true;
    });

    try {
      List<ThongBao> thongBaos;
      
      if (_selectedTab == 0) {
        thongBaos = await _thongBaoService.getAllThongBao();
      } else if (_selectedTab == 1) {
        thongBaos = await _thongBaoService.getThongBaoByType(1); // Đơn hàng
      } else {
        thongBaos = await _thongBaoService.getThongBaoByType(2); // Khuyến mãi
      }
      
      // Sắp xếp thông báo mới nhất lên đầu
      thongBaos.sort((a, b) => DateTime.parse(b.date).compareTo(DateTime.parse(a.date)));
      
      setState(() {
        _danhSachThongBao = thongBaos;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi khi tải thông báo: $e')),
      );
    }
  }

  Future<void> _xoaThongBao(int id) async {
    await _thongBaoService.deleteThongBao(id);
    _loadThongBao();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Thông Báo",
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline, color: Colors.black),
            onPressed: () {
              showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: const Text('Xóa tất cả thông báo?'),
                  content: const Text('Bạn có chắc chắn muốn xóa tất cả thông báo không?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(ctx),
                      child: const Text('Hủy'),
                    ),
                    TextButton(
                      onPressed: () {
                        _thongBaoService.deleteAllThongBao().then((_) {
                          Navigator.pop(ctx);
                          _loadThongBao();
                        });
                      },
                      child: const Text('Xóa', style: TextStyle(color: Colors.red)),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.primary,
          unselectedLabelColor: Colors.grey,
          indicatorColor: AppColors.primary,
          tabs: const [
            Tab(text: "Tất cả"),
            Tab(text: "Đơn hàng"),
            Tab(text: "Khuyến mãi"),
          ],
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _loadThongBao,
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _danhSachThongBao.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.notifications_off_outlined, size: 50, color: Colors.grey),
                        const SizedBox(height: 16),
                        const Text('Không có thông báo nào', style: TextStyle(fontSize: 16, color: Colors.grey)),
                        TextButton(
                          onPressed: _loadThongBao,
                          child: const Text('Tải lại'),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    itemCount: _danhSachThongBao.length,
                    itemBuilder: (context, index) {
                      final thongBao = _danhSachThongBao[index];
                      return _buildNotificationItem(thongBao);
                    },
                  ),
      ),
    );
  }

  Widget _buildNotificationItem(ThongBao thongBao) {
    // Chọn icon dựa vào loại thông báo và tiêu đề
    IconData icon;
    if (thongBao.type == 1) { // Đơn hàng
      if (thongBao.title.contains('giao')) {
        icon = Icons.local_shipping;
      } else if (thongBao.title.contains('thành công')) {
        icon = Icons.check_circle_outline;
      } else if (thongBao.title.contains('thanh toán') || thongBao.title.contains('Thanh toán')) {
        icon = Icons.payment;
      } else if (thongBao.title.contains('hủy') || thongBao.title.contains('Hủy')) {
        icon = Icons.cancel;
      } else {
        icon = Icons.shopping_bag;
      }
    } else { // Khuyến mãi
      if (thongBao.title.contains('Sale') || thongBao.title.contains('sale')) {
        icon = Icons.flash_on;
      } else {
        icon = Icons.discount;
      }
    }

    // Format datetime from "yyyy-MM-dd HH:mm:ss" to "dd/MM/yyyy (HH:mm)"
    final dateTime = DateTime.parse(thongBao.date);
    final formattedDate = DateFormat('dd/MM/yyyy (HH:mm)').format(dateTime);

    return Dismissible(
      key: Key(thongBao.id.toString()),
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction) async {
        return await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Xóa thông báo?'),
            content: const Text('Bạn có chắc chắn muốn xóa thông báo này không?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('Hủy'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text('Xóa', style: TextStyle(color: Colors.red)),
              ),
            ],
          ),
        );
      },
      onDismissed: (direction) {
        if (thongBao.id != null) {
          _xoaThongBao(thongBao.id!);
        }
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 2),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: thongBao.isRead ? Colors.white : Colors.orange.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: thongBao.type == 1 ? Colors.blue.withOpacity(0.1) : Colors.orange.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                color: thongBao.type == 1 ? Colors.blue : Colors.orange,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    thongBao.title,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    thongBao.message,
                    style: const TextStyle(fontSize: 14, color: Colors.black54),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    formattedDate,
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ),
            if (!thongBao.isRead)
              GestureDetector(
                onTap: () async {
                  if (thongBao.id != null) {
                    await _thongBaoService.markAsRead(thongBao.id!);
                    _loadThongBao();
                  }
                },
                child: Container(
                  width: 10,
                  height: 10,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.orange,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
