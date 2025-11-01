import 'dart:convert';
import 'package:buid_app/Core/Model/cart_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CartProvider with ChangeNotifier {
  List<CartModel> _carts = [];
  List<CartModel> get carts => _carts;
  set carts(List<CartModel> carts) {
    _carts = carts;
    notifyListeners();
  }

  // ===== Thêm sản phẩm vào giỏ =====
  void addToCart(Map<String, dynamic> grocery) {
    if (productExist(grocery)) {
      int index = _carts.indexWhere(
        (element) => element.grocery['id'] == grocery['id'],
      );
      _carts[index].quantity++;
    } else {
      _carts.add(CartModel(grocery: grocery, quantity: 1));
    }
    notifyListeners();
  }

  // ===== Tăng số lượng =====
  void addQuantity(Map<String, dynamic> grocery) {
    int index = _carts.indexWhere(
      (element) => element.grocery['id'] == grocery['id'],
    );
    if (index != -1) {
      _carts[index].quantity++;
      notifyListeners();
    }
  }

  // ===== Giảm số lượng =====
  void reduceQuantity(Map<String, dynamic> grocery) {
    int index = _carts.indexWhere(
      (element) => element.grocery['id'] == grocery['id'],
    );
    if (index != -1) {
      if (_carts[index].quantity > 1) {
        _carts[index].quantity--;
      } else {
        _carts.removeAt(index);
      }
      notifyListeners();
    }
  }

  // ===== Kiểm tra sản phẩm đã có chưa =====
  bool productExist(Map<String, dynamic> grocery) {
    return _carts.indexWhere(
          (element) => element.grocery['id'] == grocery['id'],
        ) !=
        -1;
  }

  // ===== Xóa sản phẩm khỏi giỏ =====
  void removeFromCart(Map<String, dynamic> grocery) {
    int index = _carts.indexWhere(
      (element) => element.grocery['id'] == grocery['id'],
    );
    if (index != -1) {
      _carts.removeAt(index);
      notifyListeners();
    }
  }

  // ===== Tính tổng tiền =====
  double get totalPrice {
    double total = 0.0;
    for (var cart in _carts) {
      final price =
          (cart.grocery["productPrices"] != null &&
              cart.grocery["productPrices"].isNotEmpty)
          ? double.tryParse(
                  cart.grocery["productPrices"][0]["price"].toString(),
                ) ??
                0
          : double.tryParse(cart.grocery["price"]?.toString() ?? "0") ?? 0;
      total += price * cart.quantity;
    }
    return total;
  }

  // ===== Xóa toàn bộ giỏ hàng =====
  void clearCart() {
    _carts.clear();
    notifyListeners();
  }

  // ===== GỬI LÊN SERVER: TẠO BUILD + ORDER =====
  Future<void> checkout({
    required int userId,
    required BuildContext context,
  }) async {
    if (_carts.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Giỏ hàng của bạn đang trống"),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    try {
      // ===== 1️⃣ Gửi danh sách sản phẩm tạo build =====
      final buildUrl = Uri.parse("http://10.0.2.2:5162/api/build");
      final buildResponse = await http.post(
        buildUrl,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "userId": userId,
          "products": _carts
              .map(
                (c) => {"productId": c.grocery["id"], "quantity": c.quantity},
              )
              .toList(),
        }),
      );

      if (buildResponse.statusCode != 200 && buildResponse.statusCode != 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "Không thể tạo Build (HTTP ${buildResponse.statusCode})",
            ),
            backgroundColor: Colors.redAccent,
          ),
        );
        return;
      }

      final buildData = jsonDecode(buildResponse.body);
      final int buildId = buildData["id"];

      // ===== 2️⃣ Gửi tạo Order dựa theo buildId =====
      final orderUrl = Uri.parse("http://10.0.2.2:5162/api/order");
      final orderResponse = await http.post(
        orderUrl,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "userId": userId,
          "buildId": buildId,
          "status": "PENDING",
          "totalPrice": totalPrice,
          "paymentMethod": "QR_CODE",
          "phone": "",
          "address": "",
        }),
      );

      // if (orderResponse.statusCode == 200 || orderResponse.statusCode == 201) {
      //   clearCart();
      //   ScaffoldMessenger.of(context).showSnackBar(
      //     const SnackBar(
      //       content: Text("Thanh toán thành công! Build và Order đã được lưu."),
      //       backgroundColor: Colors.green,
      //     ),
      //   );
      // } else {
      //   ScaffoldMessenger.of(context).showSnackBar(
      //     SnackBar(
      //       content: Text(
      //         "Tạo đơn hàng thất bại (HTTP ${orderResponse.statusCode})",
      //       ),
      //       backgroundColor: Colors.redAccent,
      //     ),
      //   );
      // }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Lỗi khi gửi đơn hàng: $e"),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }
}
