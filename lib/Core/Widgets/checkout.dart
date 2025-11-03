import 'dart:convert';
import 'package:buid_app/Core/Model/cart_model.dart';
import 'package:buid_app/Core/Provider/cart_provider.dart';
import 'package:buid_app/Core/Provider/user_provider.dart';
import 'package:buid_app/Core/Theme/theme.dart' as themes;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class CheckOutScreen extends StatefulWidget {
  final List<CartModel> cart;
  final int userId;
  const CheckOutScreen({super.key, required this.cart, required this.userId});

  @override
  State<CheckOutScreen> createState() => _CheckOutScreenState();
}

class _CheckOutScreenState extends State<CheckOutScreen> {
  bool isLoading = false;
  String? errorMessage;
  List<Map<String, dynamic>> products = [];

  @override
  void initState() {
    super.initState();
    fetchProducts();
    _loadUserData();
  }

  // ===== Lấy thông tin user từ Provider =====
  Future<void> _loadUserData() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    if (userProvider.user == null) {
      await userProvider.fetchUserById(widget.userId);
    }
  }

  // ===== Lấy thông tin sản phẩm =====
  Future<void> fetchProducts() async {
    setState(() => isLoading = true);
    try {
      List<Map<String, dynamic>> temp = [];
      for (var cart in widget.cart) {
        final id = cart.grocery["id"];
        final url = "http://10.0.2.2:5162/api/product/$id";
        final response = await http.get(Uri.parse(url));
        if (response.statusCode == 200) {
          temp.add(jsonDecode(response.body));
        }
      }
      setState(() {
        products = temp;
      });
    } catch (e) {
      setState(() => errorMessage = "Lỗi tải sản phẩm: $e");
    } finally {
      setState(() => isLoading = false);
    }
  }

  String formatPrice(num price) {
    final formatter = NumberFormat('#,###', 'vi_VN');
    return "${formatter.format(price)} đ";
  }

  // ===== Giả lập thanh toán =====
  Future<void> _confirmPayment(
    BuildContext context,
    CartProvider cartProvider,
  ) async {
    setState(() => isLoading = true);

    try {
      // 🕒 Giả lập quá trình thanh toán
      await Future.delayed(const Duration(seconds: 2));

      cartProvider.clearCart();

      if (!mounted) return;

      // 🎉 Hiển thị hộp thoại "Thanh toán thành công"
      await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          backgroundColor: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.check_circle,
                  color: themes.AppColors.cardBackground,
                  size: 60,
                ),
                const SizedBox(height: 16),
                const Text(
                  "Complete Payment!",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                const Text(
                  "Thank you for your purchase\nYour order is being processed.",
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.black54,
                    height: 1.4,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    minimumSize: const Size(120, 44),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 3,
                  ),
                  onPressed: () {
                    Navigator.pop(context); // Đóng dialog
                    Navigator.pop(context); // Quay lại giỏ hàng
                  },
                  child: const Text(
                    "Complete",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Lỗi thanh toán: $e"),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  double getProductPrice(dynamic priceData) {
    if (priceData == null) return 0.0;
    if (priceData is num) return priceData.toDouble();
    if (priceData is List && priceData.isNotEmpty) {
      final first = priceData.first;
      if (first is Map && first["price"] != null) {
        return (first["price"] as num).toDouble();
      }
    }
    return 0.0;
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    final userProvider = Provider.of<UserProvider>(context);
    final total = cartProvider.totalPrice;

    final user =
        userProvider.user ?? {"email": "—", "phone": "—", "address": "—"};

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Payment Checkout",
          style: const TextStyle(
            color: themes.AppColors.textSecondary,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: themes.AppColors.primaryGradient.colors.first,
      ),
      backgroundColor: Colors.grey[100],
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildUserInfo(user),
                  const SizedBox(height: 20),

                  // === Danh sách sản phẩm ===
                  if (products.isNotEmpty)
                    ...products.map((p) {
                      final price = getProductPrice(p["productPrices"]);
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: _buildProductInfo(p, price),
                      );
                    }).toList()
                  else if (errorMessage != null)
                    Text(
                      errorMessage!,
                      style: const TextStyle(color: Colors.red),
                    )
                  else
                    const Center(child: Text("Đang tải sản phẩm...")),

                  const SizedBox(height: 20),
                  _buildTotalRow(total),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          themes.AppColors.primaryGradient.colors.first,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () => _confirmPayment(context, cartProvider),
                    child: const Text(
                      "Confirm Payment",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildUserInfo(Map<String, dynamic>? user) => Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      boxShadow: const [
        BoxShadow(color: Colors.black12, blurRadius: 6, spreadRadius: 1),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Information Customer",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        _infoRow("Email:", user?["email"] ?? "—"),
        _infoRow("Phone:", user?["phone"] ?? "—"),
        _infoRow("Address:", user?["address"] ?? "—"),
      ],
    ),
  );

  Widget _infoRow(String title, String value) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 4),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: TextStyle(color: Colors.grey[700]),
          ),
        ),
      ],
    ),
  );

  Widget _buildProductInfo(Map<String, dynamic> product, double price) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 6, spreadRadius: 1),
        ],
      ),
      child: Row(
        children: [
          (product["imageUrl1"] != null &&
                  (product["imageUrl1"] as String).isNotEmpty)
              ? Image.network(
                  product["imageUrl1"],
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                )
              : Container(
                  width: 80,
                  height: 80,
                  color: Colors.grey[200],
                  child: const Icon(Icons.image_not_supported),
                ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product["name"] ?? "Không có tên",
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  formatPrice(price), // ✅ format tiền ở đây
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTotalRow(double total) => Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      boxShadow: const [
        BoxShadow(color: Colors.black12, blurRadius: 6, spreadRadius: 1),
      ],
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          "Total:",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        Text(
          formatPrice(total), // ✅ format tổng tiền
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.red,
          ),
        ),
      ],
    ),
  );
}
