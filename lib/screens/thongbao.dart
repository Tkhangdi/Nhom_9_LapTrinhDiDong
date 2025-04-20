import 'package:flutter/material.dart';
import 'package:shop_ban_dong_ho/models/Notification.dart';
import 'package:shop_ban_dong_ho/service/NotificationService.dart';
import 'package:intl/intl.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final NotificationService _notificationService = NotificationService();
  bool _isLoading = true;
  List<AppNotification> _notifications = [];

  @override
  void initState() {
    super.initState();
    // Thiết lập stream để lắng nghe thay đổi thông báo
    _loadNotifications();
  }

  void _loadNotifications() {
    // Lấy thông báo từ Firestore
    _notificationService.getUserNotifications().listen((notifications) {
      setState(() {
        _notifications = notifications;
        _isLoading = false;
      });
    }, onError: (error) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi khi tải thông báo: $error')),
      );
    });
  }

  String _formatNotificationDate(DateTime date) {
    // Định dạng thời gian
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = DateTime(now.year, now.month, now.day - 1);
    final dateToCheck = DateTime(date.year, date.month, date.day);

    if (dateToCheck == today) {
      return "Hôm nay (${DateFormat('HH:mm').format(date)})";
    } else if (dateToCheck == yesterday) {
      return "Hôm qua (${DateFormat('HH:mm').format(date)})";
    } else {
      return DateFormat('dd/MM/yyyy (HH:mm)').format(date);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Thông báo"),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          PopupMenuButton(
            icon: const Icon(Icons.more_vert, color: Colors.black),
            onSelected: (value) {
              if (value == 'settings') {
                _showNotificationSettings();
              } else if (value == 'read_all') {
                _markAllAsRead();
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'settings',
                child: Text('Cài đặt thông báo'),
              ),
              const PopupMenuItem(
                value: 'read_all',
                child: Text('Đánh dấu đã đọc tất cả'),
              ),
            ],
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _notifications.isEmpty
              ? _buildEmptyNotifications()
              : _buildNotificationsList(),
    );
  }

  Widget _buildEmptyNotifications() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.notifications_off_outlined, size: 80, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'Bạn chưa có thông báo nào',
            style: TextStyle(fontSize: 18, color: Colors.grey[600]),
          ),
          const SizedBox(height: 8),
          Text(
            'Thông báo mới sẽ xuất hiện ở đây',
            style: TextStyle(fontSize: 14, color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationsList() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Hoạt động của bạn",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              itemCount: _notifications.length,
              itemBuilder: (context, index) {
                final notification = _notifications[index];
                return Dismissible(
                  key: Key(notification.id),
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 20),
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  direction: DismissDirection.endToStart,
                  onDismissed: (_) {
                    _notificationService.deleteNotification(notification.id);
                    setState(() {
                      _notifications.removeAt(index);
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Đã xóa thông báo')),
                    );
                  },
                  child: GestureDetector(
                    onTap: () {
                      if (!notification.isRead) {
                        _notificationService.markNotificationAsRead(notification.id);
                        // Tình huống thực tế thì không cần setState vì stream sẽ tự cập nhật UI
                        // nhưng để hiệu ứng tức thì tốt hơn, ta setState ở đây
                        setState(() {
                          _notifications[index] = notification.copyWith(isRead: true);
                        });
                      }
                    },
                    child: buildNotificationItem(notification),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget buildNotificationItem(AppNotification notification) {
    final IconData icon = AppNotification.getIconForType(notification.type);
    final bool isRead = notification.isRead;
    
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      decoration: BoxDecoration(
        color: isRead ? null : Colors.blue[50],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            child: Icon(icon, color: Colors.orange, size: 30),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 10, right: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        notification.title,
                        style: TextStyle(
                          fontSize: 16, 
                          fontWeight: isRead ? FontWeight.normal : FontWeight.bold,
                        ),
                      ),
                      if (!isRead)
                        Container(
                          width: 10,
                          height: 10,
                          decoration: const BoxDecoration(
                            color: Colors.blue,
                            shape: BoxShape.circle,
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 4),
                Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: Text(
                    notification.message,
                    style: TextStyle(
                      fontSize: 14,
                      color: isRead ? Colors.black54 : Colors.black87,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Padding(
                  padding: const EdgeInsets.only(bottom: 10, right: 10),
                  child: Text(
                    _formatNotificationDate(notification.time),
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showNotificationSettings() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => StatefulBuilder(
        builder: (BuildContext context, StateSetter setModalState) {
          return NotificationSettingsBottomSheet(
            notificationService: _notificationService,
            onUpdate: () {
              // Cập nhật lại danh sách thông báo (nếu cần)
              setState(() {});
            },
          );
        },
      ),
    );
  }

  void _markAllAsRead() async {
    // Đánh dấu tất cả thông báo đã đọc
    try {
      for (var notification in _notifications) {
        if (!notification.isRead) {
          await _notificationService.markNotificationAsRead(notification.id);
        }
      }
      // Sau khi đánh dấu xong, stream sẽ tự động cập nhật UI
      // Nhưng để UX tốt hơn, ta cập nhật state luôn
      setState(() {
        _notifications = _notifications.map(
          (notification) => notification.copyWith(isRead: true)
        ).toList();
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Đã đánh dấu tất cả thông báo là đã đọc')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi khi đánh dấu thông báo: $e')),
      );
    }
  }
}

class NotificationSettingsBottomSheet extends StatefulWidget {
  final NotificationService notificationService;
  final VoidCallback onUpdate;

  const NotificationSettingsBottomSheet({
    required this.notificationService,
    required this.onUpdate,
    Key? key,
  }) : super(key: key);

  @override
  _NotificationSettingsBottomSheetState createState() =>
      _NotificationSettingsBottomSheetState();
}

class _NotificationSettingsBottomSheetState
    extends State<NotificationSettingsBottomSheet> {
  late Map<NotificationType, bool> _preferences;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  void _loadPreferences() async {
    // Giả lập tải cài đặt (trong thực tế, lấy từ service)
    _preferences = {
      NotificationType.orderArrived: true,
      NotificationType.orderSuccess: true,
      NotificationType.paymentConfirmed: true,
      NotificationType.orderCanceled: true,
      NotificationType.promotional: true,
      NotificationType.systemUpdate: true,
      NotificationType.personalized: true,
    };
    
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Center(
            child: Text(
              'Cài đặt thông báo',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 20),
          if (_isLoading)
            const Center(child: CircularProgressIndicator())
          else
            Column(
              children: [
                _buildNotificationSetting(
                  'Giao hàng thành công',
                  NotificationType.orderArrived,
                  Icons.local_shipping,
                ),
                _buildNotificationSetting(
                  'Đặt hàng thành công',
                  NotificationType.orderSuccess,
                  Icons.check_circle_outline,
                ),
                _buildNotificationSetting(
                  'Thanh toán đã xác nhận',
                  NotificationType.paymentConfirmed,
                  Icons.payment,
                ),
                _buildNotificationSetting(
                  'Đơn hàng đã hủy',
                  NotificationType.orderCanceled,
                  Icons.cancel,
                ),
                _buildNotificationSetting(
                  'Khuyến mãi',
                  NotificationType.promotional,
                  Icons.campaign,
                ),
                _buildNotificationSetting(
                  'Cập nhật hệ thống',
                  NotificationType.systemUpdate,
                  Icons.system_update,
                ),
                _buildNotificationSetting(
                  'Thông báo cá nhân hóa',
                  NotificationType.personalized,
                  Icons.person_outline,
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildNotificationSetting(String title, NotificationType type, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.orange),
          const SizedBox(width: 16),
          Expanded(
            child: Text(title, style: const TextStyle(fontSize: 16)),
          ),
          Switch(
            value: _preferences[type] ?? true,
            activeColor: Colors.orange,
            onChanged: (value) async {
              setState(() {
                _preferences[type] = value;
              });
              
              try {
                await widget.notificationService.updateNotificationPreference(type, value);
                widget.onUpdate();
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Lỗi khi cập nhật: $e')),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
