import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shop_ban_dong_ho/models/DongHo.dart';
import 'package:shop_ban_dong_ho/service/NotificationService.dart';

class UserBehaviorService {
  static final UserBehaviorService _instance = UserBehaviorService._internal();
  factory UserBehaviorService() => _instance;
  UserBehaviorService._internal();

  final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final NotificationService _notificationService = NotificationService();

  // Theo dõi xem sản phẩm
  Future<void> trackProductView(DongHo product) async {
    if (_auth.currentUser == null) return;
    
    try {
      // Ghi log phân tích
      await _analytics.logViewItem(
        currency: 'VND',
        value: product.gia.toDouble(),
        items: [
          AnalyticsEventItem(
            itemId: product.id,
            itemName: product.ten,
            itemCategory: product.thuongHieu,
            price: product.gia.toDouble(),
          ),
        ],
      );

      // Lưu vào Firestore
      await _firestore.collection('user_behaviors').add({
        'userId': _auth.currentUser!.uid,
        'type': 'product_view',
        'productId': product.id,
        'timestamp': FieldValue.serverTimestamp(),
      });

      // Kiểm tra và gửi thông báo cá nhân hóa
      _checkForPersonalizedNotification('product_view', product.id);
    } catch (e) {
      print('Lỗi khi theo dõi xem sản phẩm: $e');
    }
  }

  // Theo dõi thêm vào giỏ hàng
  Future<void> trackAddToCart(DongHo product, int quantity) async {
    if (_auth.currentUser == null) return;
    
    try {
      // Ghi log phân tích
      await _analytics.logAddToCart(
        currency: 'VND',
        value: product.gia.toDouble() * quantity,
        items: [
          AnalyticsEventItem(
            itemId: product.id,
            itemName: product.ten,
            itemCategory: product.thuongHieu,
            price: product.gia.toDouble(),
            quantity: quantity,
          ),
        ],
      );

      // Lưu vào Firestore
      await _firestore.collection('user_behaviors').add({
        'userId': _auth.currentUser!.uid,
        'type': 'add_to_cart',
        'productId': product.id,
        'quantity': quantity,
        'timestamp': FieldValue.serverTimestamp(),
      });

      // Kiểm tra và gửi thông báo cá nhân hóa
      _checkForPersonalizedNotification('add_to_cart', product.id);
    } catch (e) {
      print('Lỗi khi theo dõi thêm vào giỏ hàng: $e');
    }
  }

  // Theo dõi hoàn thành đơn hàng
  Future<void> trackPurchase(List<DongHo> products, double totalValue) async {
    if (_auth.currentUser == null) return;
    
    try {
      List<AnalyticsEventItem> items = products.map((product) {
        return AnalyticsEventItem(
          itemId: product.id,
          itemName: product.ten,
          itemCategory: product.thuongHieu,
          price: product.gia.toDouble(),
        );
      }).toList();

      // Ghi log phân tích
      await _analytics.logPurchase(
        currency: 'VND',
        value: totalValue,
        items: items,
      );

      // Lưu vào Firestore
      await _firestore.collection('user_behaviors').add({
        'userId': _auth.currentUser!.uid,
        'type': 'purchase',
        'products': products.map((p) => p.id).toList(),
        'totalValue': totalValue,
        'timestamp': FieldValue.serverTimestamp(),
      });

      // Sau khi mua hàng, tìm kiếm sản phẩm tương tự để đề xuất
      _suggestSimilarProducts(products);
    } catch (e) {
      print('Lỗi khi theo dõi mua hàng: $e');
    }
  }

  // Theo dõi tìm kiếm
  Future<void> trackSearch(String searchTerm) async {
    if (_auth.currentUser == null) return;
    
    try {
      // Ghi log phân tích
      await _analytics.logSearch(searchTerm: searchTerm);

      // Lưu vào Firestore
      await _firestore.collection('user_behaviors').add({
        'userId': _auth.currentUser!.uid,
        'type': 'search',
        'searchTerm': searchTerm,
        'timestamp': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('Lỗi khi theo dõi tìm kiếm: $e');
    }
  }

  // Theo dõi thêm vào yêu thích
  Future<void> trackAddToFavorite(DongHo product) async {
    if (_auth.currentUser == null) return;
    
    try {
      // Lưu vào Firestore
      await _firestore.collection('user_behaviors').add({
        'userId': _auth.currentUser!.uid,
        'type': 'add_to_favorite',
        'productId': product.id,
        'timestamp': FieldValue.serverTimestamp(),
      });

      // Kiểm tra và gửi thông báo cá nhân hóa
      _checkForPersonalizedNotification('add_to_favorite', product.id);
    } catch (e) {
      print('Lỗi khi theo dõi thêm vào yêu thích: $e');
    }
  }

  // Kiểm tra xem có nên gửi thông báo cá nhân hóa không
  Future<void> _checkForPersonalizedNotification(String actionType, String productId) async {
    if (_auth.currentUser == null) return;
    
    try {
      // Lấy thông tin sản phẩm
      DocumentSnapshot productDoc = await _firestore
          .collection('products')
          .doc(productId)
          .get();

      if (!productDoc.exists || productDoc.data() == null) return;

      Map<String, dynamic> productData = productDoc.data() as Map<String, dynamic>;
      String productName = productData['ten'] ?? 'sản phẩm';
      
      // Kiểm tra hành vi
      if (actionType == 'add_to_cart') {
        // Nếu người dùng thêm vào giỏ hàng nhưng không mua trong 24h
        await _checkAbandonedCart(productId, productName);
      } 
      else if (actionType == 'add_to_favorite') {
        // Kiểm tra xem có khuyến mãi cho sản phẩm không
        await _checkPromotionForFavorite(productId, productName);
      }
    } catch (e) {
      print('Lỗi khi kiểm tra thông báo cá nhân hóa: $e');
    }
  }

  // Kiểm tra giỏ hàng bị bỏ quên
  Future<void> _checkAbandonedCart(String productId, String productName) async {
    if (_auth.currentUser == null) return;
    
    try {
      // Kiểm tra lịch sử mua hàng trong 24h qua
      DateTime yesterday = DateTime.now().subtract(const Duration(hours: 24));
      Timestamp yesterdayTimestamp = Timestamp.fromDate(yesterday);
      
      // Đếm số lần thêm vào giỏ không mua
      QuerySnapshot addToCartQuery = await _firestore
          .collection('user_behaviors')
          .where('userId', isEqualTo: _auth.currentUser!.uid)
          .where('type', isEqualTo: 'add_to_cart')
          .where('productId', isEqualTo: productId)
          .where('timestamp', isGreaterThan: yesterdayTimestamp)
          .get();
      
      QuerySnapshot purchaseQuery = await _firestore
          .collection('user_behaviors')
          .where('userId', isEqualTo: _auth.currentUser!.uid)
          .where('type', isEqualTo: 'purchase')
          .where('products', arrayContains: productId)
          .where('timestamp', isGreaterThan: yesterdayTimestamp)
          .get();
      
      // Nếu có trong giỏ nhưng chưa mua
      if (addToCartQuery.docs.isNotEmpty && purchaseQuery.docs.isEmpty) {
        // Gửi thông báo nhắc nhở sau 2 giờ
        await _notificationService.sendPersonalizedNotification(
          userId: _auth.currentUser!.uid,
          title: 'Bạn còn quên gì trong giỏ hàng?',
          message: 'Đồng hồ "$productName" vẫn đang chờ bạn trong giỏ hàng. Hoàn tất đặt hàng ngay!',
          productId: productId,
        );
      }
    } catch (e) {
      print('Lỗi khi kiểm tra giỏ hàng bị bỏ quên: $e');
    }
  }

  // Kiểm tra khuyến mãi cho sản phẩm yêu thích
  Future<void> _checkPromotionForFavorite(String productId, String productName) async {
    if (_auth.currentUser == null) return;
    
    try {
      // Kiểm tra xem có khuyến mãi nào cho sản phẩm này không
      QuerySnapshot promotionQuery = await _firestore
          .collection('promotions')
          .where('productIds', arrayContains: productId)
          .where('active', isEqualTo: true)
          .get();
      
      if (promotionQuery.docs.isNotEmpty) {
        Map<String, dynamic> promotionData = promotionQuery.docs.first.data() as Map<String, dynamic>;
        String discountValue = promotionData['discountValue']?.toString() ?? '';
        
        // Gửi thông báo về khuyến mãi
        await _notificationService.sendPersonalizedNotification(
          userId: _auth.currentUser!.uid,
          title: 'Ưu đãi đặc biệt cho sản phẩm yêu thích của bạn!',
          message: 'Đồng hồ "$productName" đang có chương trình giảm giá $discountValue. Mua ngay kẻo lỡ!',
          productId: productId,
        );
      }
    } catch (e) {
      print('Lỗi khi kiểm tra khuyến mãi cho sản phẩm yêu thích: $e');
    }
  }

  // Gợi ý sản phẩm tương tự sau khi mua hàng
  Future<void> _suggestSimilarProducts(List<DongHo> purchasedProducts) async {
    if (_auth.currentUser == null || purchasedProducts.isEmpty) return;
    
    try {
      // Lấy loại sản phẩm đã mua
      List<String> purchasedCategories = purchasedProducts.map((p) => p.thuongHieu).toSet().toList();
      
      // Tìm sản phẩm cùng loại nhưng khác ID
      List<String> purchasedIds = purchasedProducts.map((p) => p.id).toList();
      
      QuerySnapshot similarProductsQuery = await _firestore
          .collection('products')
          .where('thuongHieu', whereIn: purchasedCategories)
          .where(FieldPath.documentId, whereNotIn: purchasedIds)
          .limit(3)
          .get();
      
      if (similarProductsQuery.docs.isNotEmpty) {
        DocumentSnapshot firstSimilar = similarProductsQuery.docs.first;
        Map<String, dynamic> productData = firstSimilar.data() as Map<String, dynamic>;
        String productName = productData['ten'] ?? 'sản phẩm tương tự';
        
        // Gửi thông báo gợi ý
        await _notificationService.sendPersonalizedNotification(
          userId: _auth.currentUser!.uid,
          title: 'Bạn có thể quan tâm',
          message: 'Dựa vào lịch sử mua hàng, chúng tôi nghĩ bạn sẽ thích "$productName"',
          productId: firstSimilar.id,
        );
      }
    } catch (e) {
      print('Lỗi khi gợi ý sản phẩm tương tự: $e');
    }
  }

  // Phân tích hành vi người dùng để đưa ra đề xuất cá nhân hóa
  Future<void> analyzeUserBehaviorForRecommendations() async {
    if (_auth.currentUser == null) return;
    
    try {
      // Lấy mẫu hành vi của người dùng trong 30 ngày qua
      DateTime thirtyDaysAgo = DateTime.now().subtract(const Duration(days: 30));
      Timestamp thirtyDaysAgoTimestamp = Timestamp.fromDate(thirtyDaysAgo);
      
      QuerySnapshot userBehaviorsQuery = await _firestore
          .collection('user_behaviors')
          .where('userId', isEqualTo: _auth.currentUser!.uid)
          .where('timestamp', isGreaterThan: thirtyDaysAgoTimestamp)
          .orderBy('timestamp', descending: true)
          .get();
      
      Map<String, int> categoryInterests = {};
      Map<String, int> productViews = {};
      
      // Phân tích dữ liệu hành vi
      for (var doc in userBehaviorsQuery.docs) {
        Map<String, dynamic> behaviorData = doc.data() as Map<String, dynamic>;
        String type = behaviorData['type'];
        
        if (['product_view', 'add_to_cart', 'add_to_favorite'].contains(type)) {
          String productId = behaviorData['productId'];
          
          // Tăng điểm cho sản phẩm đã xem
          productViews[productId] = (productViews[productId] ?? 0) + 1;
          
          // Lấy thông tin loại sản phẩm
          try {
            DocumentSnapshot productDoc = await _firestore
                .collection('products')
                .doc(productId)
                .get();
                
            if (productDoc.exists && productDoc.data() != null) {
              Map<String, dynamic> productData = productDoc.data() as Map<String, dynamic>;
              String category = productData['thuongHieu'] ?? '';
              
              if (category.isNotEmpty) {
                // Tăng điểm cho danh mục sản phẩm
                categoryInterests[category] = (categoryInterests[category] ?? 0) + 1;
              }
            }
          } catch (e) {
            print('Lỗi khi lấy thông tin sản phẩm: $e');
          }
        }
      }
      
      // Lưu mối quan tâm vào hồ sơ người dùng
      if (categoryInterests.isNotEmpty) {
        await _firestore.collection('users').doc(_auth.currentUser!.uid).set({
          'categoryInterests': categoryInterests,
          'lastAnalyzed': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));
        
        // Tìm danh mục được quan tâm nhất
        String? topCategory;
        int maxInterest = 0;
        
        categoryInterests.forEach((category, interest) {
          if (interest > maxInterest) {
            maxInterest = interest;
            topCategory = category;
          }
        });
        
        if (topCategory != null) {
          // Gửi thông báo cá nhân hóa về danh mục quan tâm
          await _notificationService.sendPersonalizedNotification(
            userId: _auth.currentUser!.uid,
            title: 'Bộ sưu tập dành cho bạn',
            message: 'Khám phá bộ sưu tập đồng hồ $topCategory mới nhất chúng tôi đã chọn lọc cho bạn',
            productId: null,
          );
        }
      }
    } catch (e) {
      print('Lỗi khi phân tích hành vi người dùng: $e');
    }
  }
}