import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

enum NotificationType {
  orderArrived,
  orderSuccess,
  paymentConfirmed,
  orderCanceled,
  promotional,
  systemUpdate,
  personalized
}

class AppNotification {
  final String id;
  final String title;
  final String message;
  final DateTime time;
  final NotificationType type;
  final String? orderId;
  final bool isRead;
  final String userId;

  AppNotification({
    required this.id,
    required this.title,
    required this.message,
    required this.time,
    required this.type,
    this.orderId,
    this.isRead = false,
    required this.userId,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'message': message,
      'time': time,
      'type': type.toString().split('.').last,
      'orderId': orderId,
      'isRead': isRead,
      'userId': userId,
    };
  }

  factory AppNotification.fromMap(Map<String, dynamic> map) {
    return AppNotification(
      id: map['id'],
      title: map['title'],
      message: map['message'],
      time: (map['time'] as Timestamp).toDate(),
      type: NotificationType.values.firstWhere(
        (e) => e.toString().split('.').last == map['type'],
        orElse: () => NotificationType.systemUpdate,
      ),
      orderId: map['orderId'],
      isRead: map['isRead'] ?? false,
      userId: map['userId'],
    );
  }

  AppNotification copyWith({
    String? id,
    String? title,
    String? message,
    DateTime? time,
    NotificationType? type,
    String? orderId,
    bool? isRead,
    String? userId,
  }) {
    return AppNotification(
      id: id ?? this.id,
      title: title ?? this.title,
      message: message ?? this.message,
      time: time ?? this.time,
      type: type ?? this.type,
      orderId: orderId ?? this.orderId,
      isRead: isRead ?? this.isRead,
      userId: userId ?? this.userId,
    );
  }

  // Phương thức trích xuất biểu tượng dựa trên loại thông báo
  static IconData getIconForType(NotificationType type) {
    switch (type) {
      case NotificationType.orderArrived:
        return Icons.local_shipping;
      case NotificationType.orderSuccess:
        return Icons.check_circle_outline;
      case NotificationType.paymentConfirmed:
        return Icons.payment;
      case NotificationType.orderCanceled:
        return Icons.cancel;
      case NotificationType.promotional:
        return Icons.campaign;
      case NotificationType.personalized:
        return Icons.person_outline;
      case NotificationType.systemUpdate:
        return Icons.system_update;
    }
  }
}