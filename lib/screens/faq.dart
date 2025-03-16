import 'package:flutter/material.dart';
import 'package:shop_ban_dong_ho/utils/app_colors.dart';

class HelpCenterScreen extends StatelessWidget {
  final List<Map<String, String>> faqList = [
    {
      "question": "Chính sách bảo hành đồng hồ?",
      "answer": "Bảo hành 12 tháng kể từ ngày mua.",
    },
    {
      "question": "Thời gian giao hàng là bao lâu?",
      "answer": "Từ 2-5 ngày tùy khu vực.",
    },
    {
      "question": "Làm sao để trở thành đối tác bán hàng?",
      "answer": "Liên hệ qua email để đăng ký.",
    },
    {
      "question": "Tôi có thể đổi trả đồng hồ không?",
      "answer": "Được đổi trong 7 ngày nếu lỗi do nhà sản xuất.",
    },
    {
      "question": "Thanh toán có những phương thức nào?",
      "answer": "Chấp nhận chuyển khoản và COD.",
    },
  ];

  HelpCenterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Trung tâm trợ giúp",
          style: TextStyle(color: AppColors.textPrimary),
        ),
        backgroundColor: AppColors.primary,
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
      ),
      body: Container(
        color: AppColors.background,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Câu hỏi thường gặp",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children:
                        faqList.map((faq) {
                          return Card(
                            color: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: ExpansionTile(
                              title: Text(
                                faq['question']!,
                                style: const TextStyle(
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    faq['answer']!,
                                    style: const TextStyle(
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                "Liên hệ với chúng tôi",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              ListTile(
                leading: const Icon(Icons.chat, color: AppColors.primary),
                title: const Text(
                  "Chat ngay",
                  style: TextStyle(color: AppColors.textPrimary),
                ),
                subtitle: const Text(
                  "Nhắn tin với chúng tôi",
                  style: TextStyle(color: AppColors.textSecondary),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.email, color: AppColors.primary),
                title: const Text(
                  "Gửi Email",
                  style: TextStyle(color: AppColors.textPrimary),
                ),
                subtitle: const Text(
                  "Gửi câu hỏi hoặc vấn đề của bạn",
                  style: TextStyle(color: AppColors.textSecondary),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.phone, color: AppColors.primary),
                title: const Text(
                  "Dịch vụ khách hàng",
                  style: TextStyle(color: AppColors.textPrimary),
                ),
                subtitle: const Text(
                  "1800806",
                  style: TextStyle(color: AppColors.textSecondary),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
