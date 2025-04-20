import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shop_ban_dong_ho/service/NotificationService.dart';
import 'package:shop_ban_dong_ho/models/Notification.dart';
import 'package:shop_ban_dong_ho/utils/app_colors.dart';

class MyAccountScreen extends StatefulWidget {
  const MyAccountScreen({super.key});

  @override
  _MyAccountScreenState createState() => _MyAccountScreenState();
}

class _MyAccountScreenState extends State<MyAccountScreen> with SingleTickerProviderStateMixin {
  // Thông tin người dùng
  String userName = "Nguyễn Văn A";
  String userEmail = "nguyenvana@example.com";
  String userPhone = "0123 456 789";
  String userAddress = "123 Đường ABC, Quận 1, TP.HCM";
  String userGender = "Nam";
  String userPassword = "MatKhau123";
  bool isPasswordHidden = true;
  bool isLoading = true;
  bool _isSaving = false;
  
  // TabController cho các tab thông tin
  late TabController _tabController;
  
  // Preferences cho thông báo
  bool receivePromotionalNotifications = true;
  bool receiveOrderUpdates = true;
  bool receivePersonalizedNotifications = true;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final NotificationService _notificationService = NotificationService();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadUserData();
  }
  
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadUserData() async {
    setState(() {
      isLoading = true;
    });

    try {
      User? currentUser = _auth.currentUser;
      if (currentUser != null) {
        // Tải thông tin người dùng từ Firestore
        DocumentSnapshot userDoc = await _firestore
            .collection('users')
            .doc(currentUser.uid)
            .get();

        if (userDoc.exists && userDoc.data() != null) {
          Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;
          
          setState(() {
            userName = userData['name'] ?? userName;
            userEmail = currentUser.email ?? userEmail;
            userPhone = userData['phone'] ?? userPhone;
            userAddress = userData['address'] ?? userAddress;
            userGender = userData['gender'] ?? userGender;
            
            // Tải cài đặt thông báo
            if (userData.containsKey('notificationPreferences')) {
              Map<String, dynamic> prefs = userData['notificationPreferences'];
              receivePromotionalNotifications = prefs['promotional'] ?? true;
              receiveOrderUpdates = prefs['orderSuccess'] ?? true;
              receivePersonalizedNotifications = prefs['personalized'] ?? true;
            }
          });
        }
      }
    } catch (e) {
      print("Lỗi khi tải thông tin người dùng: $e");
      _showErrorSnackBar("Không thể tải thông tin người dùng");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _updateUserData(String field, dynamic value) async {
    setState(() {
      _isSaving = true;
    });
    
    try {
      User? currentUser = _auth.currentUser;
      if (currentUser != null) {
        await _firestore.collection('users').doc(currentUser.uid).set({
          field: value,
          'lastUpdated': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));
        
        _showSuccessSnackBar('Thông tin đã được cập nhật');
      }
    } catch (e) {
      print("Lỗi khi cập nhật: $e");
      _showErrorSnackBar('Không thể cập nhật thông tin');
    } finally {
      setState(() {
        _isSaving = false;
      });
    }
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Row(
        children: [
          const Icon(Icons.check_circle, color: Colors.white),
          const SizedBox(width: 8),
          Text(message),
        ],
      ),
      backgroundColor: Colors.green,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    ));
  }
  
  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Row(
        children: [
          const Icon(Icons.error, color: Colors.white),
          const SizedBox(width: 8),
          Text(message),
        ],
      ),
      backgroundColor: Colors.red,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    ));
  }

  String obfuscate(String text) {
    if (text.length <= 2) return text; // Nếu quá ngắn thì không ẩn
    return "${text[0]}${'*' * (text.length - 2)}${text[text.length - 1]}";
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Thông tin cá nhân",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          if (_isSaving)
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: SizedBox(
                height: 16,
                width: 16,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              ),
            ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadUserData,
            tooltip: 'Làm mới thông tin',
          ),
        ],
      ),
      body: isLoading 
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Đang tải thông tin...'),
                ],
              ),
            )
          : CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildProfileHeader(context),
                      TabBar(
                        controller: _tabController,
                        indicatorColor: AppColors.primary,
                        labelColor: AppColors.primary,
                        unselectedLabelColor: Colors.grey,
                        tabs: const [
                          Tab(text: 'Thông tin cá nhân'),
                          Tab(text: 'Tùy chọn thông báo'),
                        ],
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height - 300, // Chiều cao ước tính
                        child: TabBarView(
                          controller: _tabController,
                          children: [
                            SingleChildScrollView(
                              padding: const EdgeInsets.all(16.0),
                              child: _buildPersonalInfoSection(),
                            ),
                            SingleChildScrollView(
                              padding: const EdgeInsets.all(16.0),
                              child: _buildNotificationPreferencesSection(),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: AppColors.primary,
                    elevation: 0,
                    side: BorderSide(color: AppColors.primary),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: const Text("Quay lại"),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    _loadUserData(); // Làm mới dữ liệu
                    _showSuccessSnackBar('Đã làm mới thông tin');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: const Text("Làm mới"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primary, AppColors.primary.withOpacity(0.7)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Column(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 3),
                ),
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: const AssetImage("assets/images/avatar.jpg"),
                  backgroundColor: Colors.grey[300],
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.camera_alt, color: Colors.black87),
                    onPressed: () {
                      _showImageSourceDialog();
                    },
                    iconSize: 20,
                    padding: const EdgeInsets.all(8),
                    constraints: const BoxConstraints(),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            userName,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            userEmail,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.white,
              fontWeight: FontWeight.w300,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildStatCard('0', 'Đơn hàng'),
              _buildStatDivider(),
              _buildStatCard('0', 'Khuyến mãi'),
              _buildStatDivider(),
              _buildStatCard('0', 'Đánh giá'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatDivider() {
    return Container(
      height: 30,
      width: 1,
      color: Colors.white.withOpacity(0.5),
      margin: const EdgeInsets.symmetric(horizontal: 16),
    );
  }

  Widget _buildStatCard(String value, String title) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        Text(
          title,
          style: TextStyle(
            fontSize: 12,
            color: Colors.white.withOpacity(0.8),
          ),
        ),
      ],
    );
  }

  Widget _buildPersonalInfoSection() {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: Colors.grey.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.person,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(width: 16),
                const Text(
                  "Thông tin cá nhân",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.edit, size: 20),
                  onPressed: () => _showFullEditDialog(),
                  tooltip: 'Sửa tất cả',
                ),
              ],
            ),
            const SizedBox(height: 24),
            
            _buildUserInfoCard(
              icon: Icons.person,
              title: "Họ và tên",
              value: userName,
              onEdit: () {
                _showEditDialog("Họ và tên", userName, (newValue) {
                  setState(() => userName = newValue);
                  _updateUserData('name', newValue);
                });
              },
            ),
            
            _buildUserInfoCard(
              icon: Icons.phone_android,
              title: "Số điện thoại",
              value: userPhone,
              onEdit: () {
                _showEditDialog("Số điện thoại", userPhone, (newValue) {
                  setState(() => userPhone = newValue);
                  _updateUserData('phone', newValue);
                }, validator: _validatePhoneNumber);
              },
            ),
            
            _buildUserInfoCard(
              icon: Icons.location_on,
              title: "Địa chỉ",
              value: userAddress,
              onEdit: () {
                _showEditDialog("Địa chỉ", userAddress, (newValue) {
                  setState(() => userAddress = newValue);
                  _updateUserData('address', newValue);
                });
              },
            ),
            
            _buildUserInfoCard(
              icon: Icons.wc,
              title: "Giới tính",
              value: userGender,
              onEdit: () {
                _showGenderSelection();
              },
            ),
            
            _buildUserInfoCard(
              icon: Icons.email,
              title: "Email",
              value: userEmail,
              isEditable: false,
            ),
            
            _buildUserInfoCard(
              icon: Icons.lock,
              title: "Mật khẩu",
              value: isPasswordHidden ? "********" : userPassword,
              onEdit: () {
                setState(() {
                  isPasswordHidden = !isPasswordHidden;
                });
              },
              editIcon: isPasswordHidden ? Icons.visibility : Icons.visibility_off,
            ),
            
            const SizedBox(height: 16),
            
            OutlinedButton(
              onPressed: () {
                // Chức năng đổi mật khẩu
                _showChangePasswordDialog();
              },
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: AppColors.primary),
                foregroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.lock_reset, color: AppColors.primary),
                  const SizedBox(width: 8),
                  const Text("Đổi mật khẩu"),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserInfoCard({
    required IconData icon,
    required String title,
    required String value,
    VoidCallback? onEdit,
    bool isEditable = true,
    IconData? editIcon,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.grey[600], size: 22),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          if (isEditable && onEdit != null)
            IconButton(
              icon: Icon(
                editIcon ?? Icons.edit,
                color: AppColors.primary,
                size: 20,
              ),
              onPressed: onEdit,
            ),
        ],
      ),
    );
  }

  Widget _buildNotificationPreferencesSection() {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: Colors.grey.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.notifications,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(width: 16),
                const Text(
                  "Tùy chọn thông báo",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            
            _buildNotificationPreferenceCard(
              icon: Icons.local_shipping,
              title: "Thông báo cập nhật đơn hàng",
              description: "Nhận thông báo về trạng thái đơn hàng, giao hàng và thanh toán",
              value: receiveOrderUpdates,
              onChanged: (value) async {
                setState(() {
                  receiveOrderUpdates = value;
                });
                
                try {
                  await _notificationService.updateNotificationPreference(
                    NotificationType.orderSuccess, value);
                  await _notificationService.updateNotificationPreference(
                    NotificationType.orderArrived, value);
                  await _notificationService.updateNotificationPreference(
                    NotificationType.paymentConfirmed, value);
                  await _notificationService.updateNotificationPreference(
                    NotificationType.orderCanceled, value);
                } catch (e) {
                  print("Lỗi khi cập nhật cài đặt thông báo: $e");
                }
              },
            ),
            
            _buildNotificationPreferenceCard(
              icon: Icons.discount,
              title: "Thông báo khuyến mãi",
              description: "Nhận thông báo về các ưu đãi, giảm giá và sự kiện đặc biệt",
              value: receivePromotionalNotifications,
              onChanged: (value) async {
                setState(() {
                  receivePromotionalNotifications = value;
                });
                
                try {
                  await _notificationService.updateNotificationPreference(
                    NotificationType.promotional, value);
                } catch (e) {
                  print("Lỗi khi cập nhật cài đặt thông báo: $e");
                }
              },
            ),
            
            _buildNotificationPreferenceCard(
              icon: Icons.person_outline,
              title: "Thông báo cá nhân hóa",
              description: "Nhận thông báo và đề xuất dựa trên sở thích và hoạt động của bạn",
              value: receivePersonalizedNotifications,
              onChanged: (value) async {
                setState(() {
                  receivePersonalizedNotifications = value;
                });
                
                try {
                  await _notificationService.updateNotificationPreference(
                    NotificationType.personalized, value);
                } catch (e) {
                  print("Lỗi khi cập nhật cài đặt thông báo: $e");
                }
              },
            ),
            
            Container(
              margin: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.blue.withOpacity(0.3),
                ),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.info_outline,
                    color: Colors.blue,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Thông báo cá nhân hóa",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "Thông báo cá nhân hóa sẽ được gửi dựa trên lịch sử mua hàng và sở thích của bạn, giúp bạn không bỏ lỡ các sản phẩm phù hợp.",
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.blue.shade700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationPreferenceCard({
    required IconData icon,
    required String title,
    required String description,
    required bool value,
    required Function(bool) onChanged,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.grey[600], size: 22),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            activeColor: AppColors.primary,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }

  void _showEditDialog(
    String title,
    String currentValue,
    Function(String) onSave, {
    String? Function(String?)? validator,
  }) {
    final TextEditingController controller = TextEditingController(text: currentValue);
    final formKey = GlobalKey<FormState>();
    
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            "Cập nhật $title",
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          content: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: controller,
                  decoration: InputDecoration(
                    labelText: title,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    prefixIcon: title == "Số điện thoại"
                        ? const Icon(Icons.phone)
                        : title == "Địa chỉ"
                            ? const Icon(Icons.home)
                            : const Icon(Icons.person),
                  ),
                  validator: validator ?? (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Vui lòng nhập $title';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                "Hủy",
                style: TextStyle(color: Colors.grey),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  onSave(controller.text);
                  Navigator.pop(context);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text("Cập nhật"),
            ),
          ],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        );
      },
    );
  }

  String? _validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Vui lòng nhập số điện thoại';
    }
    
    final RegExp phoneRegex = RegExp(r'^[0-9]{10,11}$');
    if (!phoneRegex.hasMatch(value.replaceAll(RegExp(r'\s+'), ''))) {
      return 'Số điện thoại không hợp lệ';
    }
    
    return null;
  }

  void _showGenderSelection() {
    showDialog(
      context: context,
      builder: (context) {
        String selectedGender = userGender;
        
        return AlertDialog(
          title: const Text(
            "Chọn giới tính",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          content: StatefulBuilder(
            builder: (context, setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildGenderOption(
                    "Nam",
                    Icons.male,
                    selectedGender == "Nam",
                    () {
                      setState(() => selectedGender = "Nam");
                    },
                  ),
                  const SizedBox(height: 8),
                  _buildGenderOption(
                    "Nữ",
                    Icons.female,
                    selectedGender == "Nữ",
                    () {
                      setState(() => selectedGender = "Nữ");
                    },
                  ),
                  const SizedBox(height: 8),
                  _buildGenderOption(
                    "Khác",
                    Icons.transgender,
                    selectedGender == "Khác",
                    () {
                      setState(() => selectedGender = "Khác");
                    },
                  ),
                ],
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                "Hủy",
                style: TextStyle(color: Colors.grey),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                if (selectedGender != userGender) {
                  setState(() => userGender = selectedGender);
                  _updateUserData('gender', selectedGender);
                }
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text("Cập nhật"),
            ),
          ],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        );
      },
    );
  }

  Widget _buildGenderOption(String gender, IconData icon, bool isSelected, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary.withOpacity(0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? AppColors.primary : Colors.grey.withOpacity(0.3),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected ? AppColors.primary : Colors.grey,
            ),
            const SizedBox(width: 16),
            Text(
              gender,
              style: TextStyle(
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? AppColors.primary : null,
              ),
            ),
            const Spacer(),
            if (isSelected)
              Icon(
                Icons.check_circle,
                color: AppColors.primary,
              ),
          ],
        ),
      ),
    );
  }

  void _showFullEditDialog() {
    final TextEditingController nameController = TextEditingController(text: userName);
    final TextEditingController phoneController = TextEditingController(text: userPhone);
    final TextEditingController addressController = TextEditingController(text: userAddress);
    final formKey = GlobalKey<FormState>();
    String selectedGender = userGender;
    
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            "Chỉnh sửa thông tin",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          content: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: nameController,
                    decoration: InputDecoration(
                      labelText: 'Họ và tên',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      prefixIcon: const Icon(Icons.person),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Vui lòng nhập họ và tên';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: phoneController,
                    decoration: InputDecoration(
                      labelText: 'Số điện thoại',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      prefixIcon: const Icon(Icons.phone_android),
                    ),
                    validator: _validatePhoneNumber,
                    keyboardType: TextInputType.phone,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: addressController,
                    decoration: InputDecoration(
                      labelText: 'Địa chỉ',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      prefixIcon: const Icon(Icons.location_on),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Vui lòng nhập địa chỉ';
                      }
                      return null;
                    },
                    maxLines: 2,
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: selectedGender,
                    decoration: InputDecoration(
                      labelText: 'Giới tính',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      prefixIcon: const Icon(Icons.wc),
                    ),
                    items: const [
                      DropdownMenuItem(value: 'Nam', child: Text('Nam')),
                      DropdownMenuItem(value: 'Nữ', child: Text('Nữ')),
                      DropdownMenuItem(value: 'Khác', child: Text('Khác')),
                    ],
                    onChanged: (value) {
                      if (value != null) {
                        selectedGender = value;
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                "Hủy",
                style: TextStyle(color: Colors.grey),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                if (formKey.currentState!.validate()) {
                  Navigator.pop(context);
                  
                  setState(() {
                    _isSaving = true;
                  });
                  
                  // Cập nhật tất cả các trường thông tin
                  try {
                    User? currentUser = _auth.currentUser;
                    if (currentUser != null) {
                      await _firestore.collection('users').doc(currentUser.uid).set({
                        'name': nameController.text,
                        'phone': phoneController.text,
                        'address': addressController.text,
                        'gender': selectedGender,
                        'lastUpdated': FieldValue.serverTimestamp(),
                      }, SetOptions(merge: true));
                      
                      setState(() {
                        userName = nameController.text;
                        userPhone = phoneController.text;
                        userAddress = addressController.text;
                        userGender = selectedGender;
                      });
                      
                      _showSuccessSnackBar('Thông tin đã được cập nhật');
                    }
                  } catch (e) {
                    print("Lỗi khi cập nhật thông tin: $e");
                    _showErrorSnackBar('Không thể cập nhật thông tin');
                  } finally {
                    setState(() {
                      _isSaving = false;
                    });
                  }
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text("Lưu thay đổi"),
            ),
          ],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        );
      },
    );
  }

  void _showChangePasswordDialog() {
    final TextEditingController currentPasswordController = TextEditingController();
    final TextEditingController newPasswordController = TextEditingController();
    final TextEditingController confirmPasswordController = TextEditingController();
    final formKey = GlobalKey<FormState>();
    bool showPassword = false;
    
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text(
                "Đổi mật khẩu",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              content: Form(
                key: formKey,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        controller: currentPasswordController,
                        obscureText: !showPassword,
                        decoration: InputDecoration(
                          labelText: 'Mật khẩu hiện tại',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          prefixIcon: const Icon(Icons.lock),
                          suffixIcon: IconButton(
                            icon: Icon(
                              showPassword ? Icons.visibility_off : Icons.visibility,
                            ),
                            onPressed: () {
                              setState(() {
                                showPassword = !showPassword;
                              });
                            },
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Vui lòng nhập mật khẩu hiện tại';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: newPasswordController,
                        obscureText: !showPassword,
                        decoration: InputDecoration(
                          labelText: 'Mật khẩu mới',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          prefixIcon: const Icon(Icons.lock_open),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Vui lòng nhập mật khẩu mới';
                          }
                          if (value.length < 6) {
                            return 'Mật khẩu phải có ít nhất 6 ký tự';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: confirmPasswordController,
                        obscureText: !showPassword,
                        decoration: InputDecoration(
                          labelText: 'Xác nhận mật khẩu mới',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          prefixIcon: const Icon(Icons.lock_outline),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Vui lòng xác nhận mật khẩu mới';
                          }
                          if (value != newPasswordController.text) {
                            return 'Xác nhận mật khẩu không khớp';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    "Hủy",
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (formKey.currentState!.validate()) {
                      Navigator.pop(context);
                      
                      setState(() {
                        _isSaving = true;
                      });
                      
                      try {
                        User? user = _auth.currentUser;
                        
                        if (user != null && user.email != null) {
                          // Xác thực người dùng với mật khẩu hiện tại
                          AuthCredential credential = EmailAuthProvider.credential(
                            email: user.email!,
                            password: currentPasswordController.text,
                          );
                          
                          await user.reauthenticateWithCredential(credential);
                          
                          // Đổi mật khẩu
                          await user.updatePassword(newPasswordController.text);
                          
                          _showSuccessSnackBar('Mật khẩu đã được cập nhật');
                        }
                      } catch (e) {
                        print("Lỗi khi đổi mật khẩu: $e");
                        
                        String errorMessage = 'Không thể đổi mật khẩu';
                        if (e is FirebaseAuthException) {
                          if (e.code == 'wrong-password') {
                            errorMessage = 'Mật khẩu hiện tại không đúng';
                          } else if (e.code == 'weak-password') {
                            errorMessage = 'Mật khẩu mới quá yếu';
                          }
                        }
                        
                        _showErrorSnackBar(errorMessage);
                      } finally {
                        setState(() {
                          _isSaving = false;
                        });
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text("Đổi mật khẩu"),
                ),
              ],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            );
          },
        );
      },
    );
  }

  void _showImageSourceDialog() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                margin: const EdgeInsets.only(top: 16, bottom: 8),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const ListTile(
                title: Text(
                  'Chọn ảnh đại diện',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
              const Divider(),
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.camera_alt,
                    color: AppColors.primary,
                  ),
                ),
                title: const Text('Chụp ảnh'),
                onTap: () {
                  Navigator.pop(context);
                  _showInfoSnackBar('Chức năng đang được phát triển');
                },
              ),
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.photo_library,
                    color: AppColors.primary,
                  ),
                ),
                title: const Text('Chọn từ thư viện'),
                onTap: () {
                  Navigator.pop(context);
                  _showInfoSnackBar('Chức năng đang được phát triển');
                },
              ),
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.delete,
                    color: Colors.white,
                  ),
                ),
                title: const Text('Xóa ảnh đại diện'),
                onTap: () {
                  Navigator.pop(context);
                  _showInfoSnackBar('Chức năng đang được phát triển');
                },
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  void _showInfoSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Row(
        children: [
          const Icon(Icons.info, color: Colors.white),
          const SizedBox(width: 8),
          Text(message),
        ],
      ),
      backgroundColor: Colors.blue,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    ));
  }
}
