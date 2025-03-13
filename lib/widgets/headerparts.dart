import 'package:flutter/material.dart';
import 'package:shop_ban_dong_ho/models/Cart.dart';
import 'package:shop_ban_dong_ho/models/CartItem.dart';
import '../screens/Giohang.dart'; // Import your Cart screen here

class HeaderParts extends StatefulWidget {
  const HeaderParts({super.key});

  @override
  State<HeaderParts> createState() => _HeaderPartsState();
}

int indexCategory = 0;

Cart myCart = Cart(); // Định nghĩa giỏ hàng
List<CartItem> danhSachGioHang = []; // Khởi tạo danh sách giỏ hàng



class _HeaderPartsState extends State<HeaderParts> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        topHeader(),
        const SizedBox(height: 10),
        title(),
        const SizedBox(height: 10),
        searchBar(),
        const SizedBox(height: 10),
        categorySelection(),
      ],
    );
  }

  Padding categorySelection() {
    List list = ["All"];
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
      child: SizedBox(
        height: 35,
        child: ListView.builder(
          itemCount: list.length,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                setState(() {
                  indexCategory = index;
                });
              },
              child: Container(
                alignment: Alignment.center,
                child: Padding(
                  padding: const EdgeInsets.only(left: 15, right: 10),
                  child: Text(
                    list[index],
                    style: TextStyle(
                      fontSize: 20,
                      color:
                          indexCategory == index
                              ? Colors.blueAccent
                              : Colors.black45,
                      fontWeight:
                          indexCategory == index ? FontWeight.bold : null,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Container searchBar() {
    return Container(
      height: 55,
      margin: const EdgeInsets.symmetric(horizontal: 15),
      padding: const EdgeInsets.only(right: 5),
      decoration: BoxDecoration(
        color: Colors.green[50],
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          const Expanded(
            child: TextField(
              decoration: InputDecoration(
                border: InputBorder.none,
                prefixIcon: Icon(Icons.search, color: Colors.blueAccent),
                hintText: "Search food",
                hintStyle: TextStyle(color: Colors.black26),
              ),
            ),
          ),
          Material(
            color: Colors.blueAccent,
            borderRadius: BorderRadius.circular(10),
            child: InkWell(
              onTap: () {},
              borderRadius: BorderRadius.circular(10),
              child: Container(
                height: 40,
                width: 40,
                alignment: Alignment.center,
                child: const Icon(
                  Icons.insert_emoticon_sharp,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Padding title() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Hi Nabin",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.blueAccent,
              fontSize: 18,
            ),
          ),
          Text(
            "Tìm kiếm đồng hồ",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black,
              fontSize: 34,
            ),
          ),
        ],
      ),
    );
  }

  Padding topHeader() {
    return Padding(
      padding: const EdgeInsets.only(left: 15, right: 15, top: 30),
      child: Row(
        children: [
          // For menu
          Material(
            color: Colors.black12,
            borderRadius: BorderRadius.circular(10),
            child: InkWell(
              onTap: () {},
              borderRadius: BorderRadius.circular(10),
              child: Container(
                height: 40,
                width: 40,
                alignment: Alignment.center,
                child: const Icon(Icons.menu_open_rounded, color: Colors.black),
              ),
            ),
          ),
          const Spacer(),
          // For location
          const Icon(Icons.location_on, color: Colors.blueAccent, size: 18),
          const Text(
            "SKT Nepal",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black38,
            ),
          ),
          const Spacer(),
          // Cart Button
          Material(
            color: Colors.blueAccent,
            borderRadius: BorderRadius.circular(10),
            child: InkWell(
              onTap: () {
                // Navigate to Cart screen
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => GioHang(gioHang: myCart,danhSachSanPham: danhSachGioHang,),
                  ), // Replace with your Cart screen
                );
              },
              borderRadius: BorderRadius.circular(10),
              child: Container(
                height: 40,
                width: 40,
                alignment: Alignment.center,
                child: const Icon(Icons.shopping_cart, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
