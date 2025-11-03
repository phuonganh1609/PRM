import 'dart:convert';
import 'package:buid_app/Core/Theme/theme.dart' as themes;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:buid_app/Core/Provider/cart_provider.dart';
import 'package:buid_app/Core/Model/cart_model.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart'; //  Thêm để format giá tiền

class CartItems extends StatefulWidget {
  final CartModel cart;
  const CartItems({super.key, required this.cart});

  @override
  State<CartItems> createState() => _CartItemsState();
}

class _CartItemsState extends State<CartItems> {
  bool isLoading = true;
  String? errorMessage;
  Map<String, dynamic>? product;

  final _currencyFormatter = NumberFormat.currency(
    locale: 'vi_VN',
    symbol: '₫',
  );

  @override
  void initState() {
    super.initState();
    fetchProduct();
  }

  Future<void> fetchProduct() async {
    final id = widget.cart.grocery["id"];
    if (id == null) {
      setState(() {
        errorMessage = "Không tìm thấy ID sản phẩm";
        isLoading = false;
      });
      return;
    }

    final url = "http://10.0.2.2:5162/api/product/$id";
    print("📡 Fetching product from: $url");

    try {
      final response = await http.get(Uri.parse(url));
      if (!mounted) return;

      if (response.statusCode == 200) {
        setState(() {
          product = jsonDecode(response.body);
          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage = "Lỗi tải dữ liệu (HTTP ${response.statusCode})";
          isLoading = false;
        });
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        errorMessage = "Không thể kết nối tới server: $e";
        isLoading = false;
      });
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

    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (errorMessage != null) {
      return Center(child: Text(errorMessage!));
    }

    if (product == null) {
      return const Center(child: Text("Không tìm thấy sản phẩm."));
    }

    final double price = getProductPrice(product!["productPrices"]);
    final double subtotal = price * widget.cart.quantity;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 5, spreadRadius: 1),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // --- Ảnh + Thông tin sản phẩm ---
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child:
                    (product!["imageUrl1"] != null &&
                        (product!["imageUrl1"] as String).isNotEmpty)
                    ? Image.network(
                        product!["imageUrl1"],
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover,
                      )
                    : Container(
                        width: 80,
                        height: 80,
                        color: Colors.grey[200],
                        child: const Icon(Icons.image_not_supported, size: 36),
                      ),
              ),
              const SizedBox(width: 12),

              // --- Tên và giá sản phẩm ---
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product!["name"] ?? "Không có tên",
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _currencyFormatter.format(price),
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.redAccent,
                          ),
                        ),

                        // --- Nút tăng giảm ---
                        Row(
                          children: [
                            _qtyButton(
                              icon: Icons.remove_circle_outline,
                              onTap: () => cartProvider.reduceQuantity(
                                widget.cart.grocery,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                              ),
                              child: Text(
                                "${widget.cart.quantity}",
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            _qtyButton(
                              icon: Icons.add_circle_outline,
                              onTap: () =>
                                  cartProvider.addToCart(widget.cart.grocery),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),
          Divider(color: Colors.grey[300]),

          // --- Thành tiền ---
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Thành tiền:",
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              ),
              Text(
                _currencyFormatter.format(subtotal),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: themes.AppColors.price,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _qtyButton({required IconData icon, required VoidCallback onTap}) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: Icon(icon, size: 22, color: Colors.grey[700]),
      ),
    );
  }
}
