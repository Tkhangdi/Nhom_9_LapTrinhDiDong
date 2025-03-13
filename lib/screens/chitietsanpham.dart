import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_ban_dong_ho/models/Cart.dart';
import 'package:shop_ban_dong_ho/models/CartItem.dart';

class ChiTietSanPham extends StatefulWidget {
  final CartItem dh;
  final Cart gioHang; // Thêm giỏ hàng vào
  const ChiTietSanPham({super.key, required this.dh, required this.gioHang});

  @override
  State<ChiTietSanPham> createState() => _ChiTietSanPhamState();
}

class _ChiTietSanPhamState extends State<ChiTietSanPham> {
  int _selectedColorIndex = 0;
  bool _isFavorite = false; // Thêm biến để lưu trạng thái yêu thích
  List<Color> colors = [
    Colors.purple,
    Colors.yellow,
    Colors.green,
    Colors.white,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          SizedBox(height: 20),
          _buildHeader(),
          Expanded(
            child: ListView(
              children: [_buildProductImage(), _buildProductDetails()],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.pop(context),
          ),
          Row(
            children: [
              Icon(Icons.star, color: Colors.amber),
              Text("4.5", style: TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProductImage() {
    return Center(
      child:
          widget.dh.hinhAnh.startsWith('http')
              ? Image.network(
                widget.dh.hinhAnh,
                height: 250,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(
                    Icons.broken_image,
                    size: 50,
                    color: Colors.red,
                  );
                },
              )
              : Image.asset(
                widget.dh.hinhAnh,
                height: 250,
                fit: BoxFit.contain,
              ),
    );
  }

  Widget _buildProductDetails() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(35),
          topRight: Radius.circular(35),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.dh.ten,
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    _isFavorite = !_isFavorite;
                  });
                },
                child: Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.orange,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    _isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: _isFavorite ? Colors.red : Colors.white,
                    size: 28,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          Text(
            '\ ${widget.dh.gia} VNĐ',
            style: TextStyle(
              fontSize: 22,
              color: Colors.orange,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 15),
          Row(
            children: [
              ..._buildColorOptions(),
              Spacer(),
              _buildQuantitySelector(),
            ],
          ),
          SizedBox(height: 20),
          Text(
            widget.dh.moTa,
            style: TextStyle(fontSize: 16, color: Colors.grey[600]),
          ),
          SizedBox(height: 25),
          _buildBottomButtons(),
        ],
      ),
    );
  }

  List<Widget> _buildColorOptions() {
    return List.generate(colors.length, (index) {
      return GestureDetector(
        onTap: () {
          setState(() {
            _selectedColorIndex = index;
          });
        },
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 5),
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: colors[index],
            border: Border.all(
              color:
                  _selectedColorIndex == index
                      ? Colors.orange
                      : Colors.transparent,
              width: 3,
            ),
          ),
        ),
      );
    });
  }

  Widget _buildQuantitySelector() {
    return Row(
      children: [
        _buildCounterButton(Icons.remove, () {
          setState(() {
            if (widget.dh.soLuong > 1) {
              widget.dh.soLuong -= 1;
            }
          });
        }),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Text(
            widget.dh.soLuong.toString(),
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        _buildCounterButton(Icons.add, () {
          setState(() {
            widget.dh.soLuong += 1;
          });
        }),
      ],
    );
  }

  Widget _buildCounterButton(IconData icon, VoidCallback onPressed) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.grey),
      ),
      child: IconButton(icon: Icon(icon, size: 18), onPressed: onPressed),
    );
  }

  Widget _buildBottomButtons() {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
            onPressed: () {
              Provider.of<Cart>(
                context,
                listen: false,
              ).addItem(widget.dh); // Gọi hàm khi bấm nút
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("Đã thêm ${widget.dh.ten} vào giỏ hàng"),
                  duration: Duration(seconds: 1),
                  backgroundColor: Colors.green,
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Text(
                "Thêm vào giỏ hàng",
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
