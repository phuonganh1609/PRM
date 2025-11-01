import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:buid_app/Core/Provider/cart_provider.dart';
import 'package:buid_app/Core/Widgets/cart_items.dart';
import 'package:buid_app/Core/Theme/theme.dart' as themes;

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    final cartItems = cartProvider.carts;

    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F6),
      appBar: AppBar(
        title: const Text(
          "My Cart",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: themes.AppColors.primaryGradient.colors.first,
        foregroundColor: Colors.white,
        elevation: 0,
      ),

      // Nội dung chính
      body: cartItems.isEmpty
          ? const Center(
              child: Text(
                "Empty Cart!",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.only(bottom: 100),
              itemCount: cartItems.length,
              itemBuilder: (context, index) {
                return CartItems(cart: cartItems[index]);
              },
            ),

      // Thanh tổng thanh toán
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(color: Colors.black12, blurRadius: 4, spreadRadius: 1),
          ],
        ),
        child: SafeArea(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Tổng tiền
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      "Total price:",
                      style: TextStyle(
                        fontSize: 14,
                        color: themes.AppColors.textPrimary,
                      ),
                    ),
                    Text(
                      "${cartProvider.totalPrice.toStringAsFixed(0)} đ",
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: themes.AppColors.price,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 10),

              // Nút thanh toán
              SizedBox(
                width: 150,
                height: 45,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        themes.AppColors.primaryGradient.colors.first,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: cartItems.isEmpty
                      ? null
                      : () {
                          //  Gửi API thanh toán hoặc điều hướng tới màn hình Checkout
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("PAID!"),
                              backgroundColor: Colors.green,
                            ),
                          );
                        },
                  child: const Text(
                    "Pay Now",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
