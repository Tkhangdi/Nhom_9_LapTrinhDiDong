import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class BoLocSanPham extends StatelessWidget {
  final Function(String brand, RangeValues gia) onFilter;

  const BoLocSanPham({super.key, required this.onFilter});

  @override
  Widget build(BuildContext context) {
    String selectedBrand = '';
    RangeValues gia = const RangeValues(0, 50);

    return FutureBuilder<List<String>>(
      future: layThuongHieuTuDatabase(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final brandList = snapshot.data!;

        return StatefulBuilder(
          builder: (context, setState) {
            return Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text("Bộ lọc sản phẩm",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 20),

                  // Dropdown thương hiệu
                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration(labelText: 'Thương hiệu'),
                    value: selectedBrand.isEmpty ? brandList.first : selectedBrand,
                    items: brandList.map((brand) {
                      return DropdownMenuItem(value: brand, child: Text(brand));
                    }).toList(),
                    onChanged: (value) => setState(() => selectedBrand = value ?? ''),
                  ),

                  const SizedBox(height: 20),
                  Text("Khoảng giá (triệu): ${gia.start.toInt()} - ${gia.end.toInt()}"),
                  RangeSlider(
                    min: 0,
                    max: 50,
                    divisions: 10,
                    values: gia,
                    onChanged: (value) => setState(() => gia = value),
                  ),

                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      onFilter(selectedBrand, gia);
                      Navigator.pop(context);
                    },
                    child: const Text("Áp dụng"),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}


  Future<List<String>> layThuongHieuTuDatabase() async {
    final snapshot =
        await FirebaseFirestore.instance.collection('SanPham').get();

    final all = snapshot.docs
    .map((doc) => doc['thuongHieu']?.toString().trim())
    .whereType<String>() // loại bỏ null và cast về List<String>
    .where((value) => value.isNotEmpty)
    .toSet()
    .toList();

    all.sort(); // Sắp xếp theo A-Z
    all.insert(0, 'Tất cả'); // Thêm lựa chọn mặc định
    return all;
  }













