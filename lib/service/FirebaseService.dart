import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Lấy danh sách dữ liệu từ Firestore, sử dụng kiểu dữ liệu generic
  Future<List<T>> fetchData<T>(
    String collectionPath,
    T Function(Map<String, dynamic>) fromJson,
  ) async {
    try {
      final querySnapshot = await _firestore.collection(collectionPath).get();

      // Chuyển các tài liệu thành danh sách đối tượng của kiểu dữ liệu generic
      final dataList =
          querySnapshot.docs.map((doc) {
            return fromJson(doc.data() as Map<String, dynamic>);
          }).toList();

      return dataList;
    } catch (e) {
      print('Error fetching data: $e');
      return [];
    }
  }

  // Thêm dữ liệu vào Firestore (dùng chung cho mọi loại dữ liệu)
  Future<void> addData<T>(
    String collectionPath,
    T data,
    Map<String, dynamic> Function(T) toJson,
  ) async {
    try {
      await _firestore.collection(collectionPath).add(toJson(data));
    } catch (e) {
      print('Error adding data: $e');
    }
  }

  // Cập nhật dữ liệu vào Firestore
  Future<void> updateData<T>(
    String collectionPath,
    String docId,
    T data,
    Map<String, dynamic> Function(T) toJson,
  ) async {
    try {
      await _firestore
          .collection(collectionPath)
          .doc(docId)
          .update(toJson(data));
    } catch (e) {
      print('Error updating data: $e');
    }
  }

  // Xóa dữ liệu khỏi Firestore
  Future<void> deleteData(String collectionPath, String docId) async {
    try {
      await _firestore.collection(collectionPath).doc(docId).delete();
    } catch (e) {
      print('Error deleting data: $e');
    }
  }
}
