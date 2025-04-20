import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shop_ban_dong_ho/models/Notification.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shop_ban_dong_ho/screens/thongbao.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin = 
      FlutterLocalNotificationsPlugin();
  
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Cài đặt thông báo của người dùng
  Map<NotificationType, bool> _notificationPreferences = {
    NotificationType.orderArrived: true,
    NotificationType.orderSuccess: true,
    NotificationType.paymentConfirmed: true,
    NotificationType.orderCanceled: true,
    NotificationType.promotional: true,
    NotificationType.systemUpdate: true,
    NotificationType.personalized: true,
  };

  // Khởi tạo dịch vụ
  Future<void> initialize(BuildContext context) async {
    // Cấu hình thông báo Firebase
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: false,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('Quyền thông báo đã được cấp');
      
      // Cấu hình thông báo local
      const AndroidInitializationSettings initializationSettingsAndroid =
          AndroidInitializationSettings('@mipmap/ic_launcher');
          
      const InitializationSettings initializationSettings =
          InitializationSettings(android: initializationSettingsAndroid);
          
      await _flutterLocalNotificationsPlugin.initialize(
        initializationSettings,
        onDidReceiveNotificationResponse: (NotificationResponse details) {
          // Xử lý khi người dùng nhấp vào thông báo
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => NotificationScreen()),
          );
        },
      );

      // Xử lý tin nhắn nền
      FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
      
      // Xử lý tin nhắn khi ứng dụng đang mở
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        _showNotification(message);
        _saveNotificationToFirestore(message);
      });
      
      // Xử lý khi nhấn vào thông báo để mở ứng dụng từ nền
      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => NotificationScreen()),
        );
      });
      
      // Lấy FCM token
      String? token = await _firebaseMessaging.getToken();
      if (token != null) {
        _saveFcmToken(token);
      }
      
      // Lắng nghe khi token được làm mới
      _firebaseMessaging.onTokenRefresh.listen(_saveFcmToken);
      
      // Tải tùy chọn thông báo
      await _loadNotificationPreferences();
    }
  }

  // Xử lý thông báo khi ứng dụng ở nền
  static Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
    print("Nhận thông báo nền: ${message.notification?.title}");
  }

  // Hiển thị thông báo local
  Future<void> _showNotification(RemoteMessage message) async {
    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification?.android;

    if (notification != null && android != null) {
      // Kiểm tra xem loại thông báo có được người dùng cho phép không
      String notificationType = message.data['type'] ?? 'systemUpdate';
      NotificationType type = NotificationType.values.firstWhere(
        (e) => e.toString().split('.').last == notificationType,
        orElse: () => NotificationType.systemUpdate,
      );
      
      if (_notificationPreferences[type] == true) {
        await _flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              'shop_dong_ho_channel',
              'Thông báo từ Shop Đồng Hồ',
              channelDescription: 'Thông báo từ ứng dụng Shop Đồng Hồ',
              importance: Importance.max,
              priority: Priority.high,
              icon: '@mipmap/ic_launcher',
            ),
          ),
          payload: json.encode(message.data),
        );
      }
    }
  }

  // Lưu thông báo vào Firestore
  Future<void> _saveNotificationToFirestore(RemoteMessage message) async {
    if (_auth.currentUser == null) return;
    
    String userId = _auth.currentUser!.uid;
    String notificationType = message.data['type'] ?? 'systemUpdate';
    
    try {
      await _firestore.collection('notifications').add({
        'id': DateTime.now().millisecondsSinceEpoch.toString(),
        'userId': userId,
        'title': message.notification?.title ?? 'Thông báo mới',
        'message': message.notification?.body ?? '',
        'time': Timestamp.now(),
        'type': notificationType,
        'orderId': message.data['orderId'],
        'isRead': false,
      });
    } catch (e) {
      print('Lỗi khi lưu thông báo: $e');
    }
  }

  // Lưu FCM token vào Firestore
  Future<void> _saveFcmToken(String token) async {
    if (_auth.currentUser == null) return;
    
    String userId = _auth.currentUser!.uid;
    
    try {
      await _firestore.collection('users').doc(userId).set({
        'fcmToken': token,
        'lastUpdated': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
      
      print('FCM Token đã được lưu: $token');
    } catch (e) {
      print('Lỗi khi lưu FCM token: $e');
    }
  }

  // Lấy danh sách thông báo của người dùng
  Stream<List<AppNotification>> getUserNotifications() {
    if (_auth.currentUser == null) {
      return Stream.value([]);
    }
    
    String userId = _auth.currentUser!.uid;
    
    return _firestore
        .collection('notifications')
        .where('userId', isEqualTo: userId)
        .orderBy('time', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map((doc) => AppNotification.fromMap(doc.data()))
              .toList();
        });
  }

  // Đánh dấu thông báo đã đọc
  Future<void> markNotificationAsRead(String notificationId) async {
    try {
      // Tìm document với id tương ứng
      QuerySnapshot querySnapshot = await _firestore
          .collection('notifications')
          .where('id', isEqualTo: notificationId)
          .get();
      
      if (querySnapshot.docs.isNotEmpty) {
        await _firestore
            .collection('notifications')
            .doc(querySnapshot.docs.first.id)
            .update({'isRead': true});
      }
    } catch (e) {
      print('Lỗi khi đánh dấu đã đọc: $e');
    }
  }

  // Xóa thông báo
  Future<void> deleteNotification(String notificationId) async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('notifications')
          .where('id', isEqualTo: notificationId)
          .get();
      
      if (querySnapshot.docs.isNotEmpty) {
        await _firestore
            .collection('notifications')
            .doc(querySnapshot.docs.first.id)
            .delete();
      }
    } catch (e) {
      print('Lỗi khi xóa thông báo: $e');
    }
  }

  // Cập nhật tùy chọn nhận thông báo
  Future<void> updateNotificationPreference(NotificationType type, bool enabled) async {
    _notificationPreferences[type] = enabled;
    await _saveNotificationPreferences();
  }

  // Lưu tùy chọn thông báo
  Future<void> _saveNotificationPreferences() async {
    if (_auth.currentUser == null) return;
    
    try {
      final prefs = await SharedPreferences.getInstance();
      Map<String, bool> prefsMap = {};
      
      _notificationPreferences.forEach((key, value) {
        prefsMap[key.toString().split('.').last] = value;
      });
      
      await prefs.setString('notification_preferences', json.encode(prefsMap));
      
      // Đồng bộ với Firestore
      await _firestore.collection('users').doc(_auth.currentUser!.uid).set({
        'notificationPreferences': prefsMap,
        'lastUpdated': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
      
    } catch (e) {
      print('Lỗi khi lưu tùy chọn thông báo: $e');
    }
  }

  // Tải tùy chọn thông báo
  Future<void> _loadNotificationPreferences() async {
    if (_auth.currentUser == null) return;
    
    try {
      // Thử lấy từ SharedPreferences trước (nhanh hơn)
      final prefs = await SharedPreferences.getInstance();
      String? prefsString = prefs.getString('notification_preferences');
      
      if (prefsString != null) {
        Map<String, dynamic> prefsMap = json.decode(prefsString);
        prefsMap.forEach((key, value) {
          NotificationType type = NotificationType.values.firstWhere(
            (e) => e.toString().split('.').last == key,
            orElse: () => NotificationType.systemUpdate,
          );
          _notificationPreferences[type] = value;
        });
      } else {
        // Nếu không có trong SharedPreferences, lấy từ Firestore
        DocumentSnapshot doc = await _firestore
            .collection('users')
            .doc(_auth.currentUser!.uid)
            .get();
        
        if (doc.exists && doc.data() != null) {
          Map<String, dynamic> userData = doc.data() as Map<String, dynamic>;
          if (userData.containsKey('notificationPreferences')) {
            Map<String, dynamic> prefsMap = userData['notificationPreferences'];
            prefsMap.forEach((key, value) {
              NotificationType type = NotificationType.values.firstWhere(
                (e) => e.toString().split('.').last == key,
                orElse: () => NotificationType.systemUpdate,
              );
              _notificationPreferences[type] = value;
            });
          }
        }
      }
    } catch (e) {
      print('Lỗi khi tải tùy chọn thông báo: $e');
    }
  }
  
  // Gửi thông báo cá nhân hóa dựa trên hành vi người dùng
  Future<void> sendPersonalizedNotification({
    required String userId,
    required String title,
    required String message,
    String? productId,
  }) async {
    try {
      // Kiểm tra xem người dùng có cho phép thông báo cá nhân hóa không
      if (_notificationPreferences[NotificationType.personalized] == true) {
        // Trong thực tế, bạn sẽ gọi API Cloud Functions để gửi thông báo
        // Tại đây, chúng ta giả lập bằng cách tạo thông báo local
        
        // Lưu thông báo vào Firestore
        await _firestore.collection('notifications').add({
          'id': DateTime.now().millisecondsSinceEpoch.toString(),
          'userId': userId,
          'title': title,
          'message': message,
          'time': Timestamp.now(),
          'type': 'personalized',
          'productId': productId,
          'isRead': false,
        });
        
        // Hiển thị thông báo local
        await _flutterLocalNotificationsPlugin.show(
          DateTime.now().millisecondsSinceEpoch.hashCode,
          title,
          message,
          NotificationDetails(
            android: AndroidNotificationDetails(
              'shop_dong_ho_personalized',
              'Thông báo cá nhân hóa',
              channelDescription: 'Thông báo cá nhân hóa từ Shop Đồng Hồ',
              importance: Importance.max,
              priority: Priority.high,
              icon: '@mipmap/ic_launcher',
            ),
          ),
        );
      }
    } catch (e) {
      print('Lỗi khi gửi thông báo cá nhân hóa: $e');
    }
  }
}