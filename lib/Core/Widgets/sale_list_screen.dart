import 'dart:convert';
import 'package:buid_app/Core/Provider/cart_provider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:buid_app/Core/Theme/theme.dart' as theme;
import 'package:buid_app/Core/Widgets/cart_screen.dart';
import 'sale_filter_screen.dart';
import 'login_screen.dart';
import 'package:provider/provider.dart';
import 'package:buid_app/Core/Widgets/cart_icon.dart';

class SaleListScreen extends StatefulWidget {
  final int? categoryId;
  final int? userId;
  final Map<String, dynamic> grocery;

  const SaleListScreen({
    super.key,
    this.categoryId,
    this.userId,
    required this.grocery,
  });

  @override
  State<SaleListScreen> createState() => _SaleListScreenState();
}

class _SaleListScreenState extends State<SaleListScreen> {
  List<dynamic> products = [];
  bool isLoading = true;
  String? errorMessage;
  int? currentUserId;

  @override
  void initState() {
    super.initState();
    currentUserId = widget.userId;
    if (widget.categoryId != null) {
      fetchProductsByCategory(widget.categoryId!);
    } else {
      fetchAllProducts();
    }
  }

  Future<void> fetchAllProducts() async {
    const url = "http://10.0.2.2:5162/api/product";
    await _fetchAndSet(url, isCategory: false);
  }

  Future<void> fetchProductsByCategory(int categoryId) async {
    final url = "http://10.0.2.2:5162/api/category/$categoryId/products";
    await _fetchAndSet(url, isCategory: true);
  }

  Future<void> _fetchAndSet(String url, {required bool isCategory}) async {
    try {
      final response = await http.get(Uri.parse(url));
      if (!mounted) return;

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          products = isCategory ? (data["products"] ?? []) : List.from(data);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.AppColors.primaryGradient.colors.first,
        title: Text(
          widget.categoryId == null
              ? 'Sales List'
              : 'Danh mục #${widget.categoryId}',
          style: const TextStyle(
            color: theme.AppColors.textSecondary,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          // Nút lọc
          IconButton(
            icon: const Icon(Icons.filter_list),
            color: theme.AppColors.background,
            onPressed: () async {
              final selectedCategoryId = await Navigator.push<int>(
                context,
                MaterialPageRoute(
                  builder: (context) => const SaleFilterScreen(),
                ),
              );

              if (selectedCategoryId != null) {
                setState(() => isLoading = true);
                await fetchProductsByCategory(selectedCategoryId);
              }
            },
          ),
          // Nút giỏ hàng
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const CartScreen()),
              );
            },
            child: const Padding(
              padding: EdgeInsets.only(right: 16),
              child: CartIcon(),
            ),
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: theme.AppColors.primaryGradient,
        ),
        child: isLoading
            ? const Center(
                child: CircularProgressIndicator(color: Colors.white),
              )
            : errorMessage != null
            ? Center(
                child: Text(
                  errorMessage!,
                  style: const TextStyle(color: Colors.redAccent, fontSize: 16),
                  textAlign: TextAlign.center,
                ),
              )
            : GridView.builder(
                padding: const EdgeInsets.all(16),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 0.68, //  cân bằng chiều cao item
                ),
                itemCount: products.length,
                itemBuilder: (context, index) {
                  final p = products[index];
                  final price = (p["productPrices"]?.isNotEmpty ?? false)
                      ? "${p["productPrices"][0]["price"]} đ"
                      : "—";

                  return Container(
                    decoration: BoxDecoration(
                      color: theme.AppColors.icon,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 4,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Hình ảnh
                          Flexible(
                            flex: 4,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child:
                                  (p["imageUrl1"] != null &&
                                      p["imageUrl1"].toString().isNotEmpty)
                                  ? Image.network(
                                      p["imageUrl1"],
                                      fit: BoxFit.cover,
                                      width: double.infinity,
                                      errorBuilder: (ctx, err, stack) =>
                                          const Icon(
                                            Icons.image_not_supported,
                                            size: 60,
                                            color: Colors.grey,
                                          ),
                                    )
                                  : const Icon(
                                      Icons.image,
                                      size: 60,
                                      color: Colors.grey,
                                    ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          // Tên sản phẩm
                          Flexible(
                            flex: 2,
                            child: Text(
                              p["name"] ?? "Unnamed",
                              style: const TextStyle(
                                color: theme.AppColors.textPrimary,
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                            ),
                          ),
                          const SizedBox(height: 4),
                          // Giá
                          Text(
                            price,
                            style: const TextStyle(
                              color: theme.AppColors.price,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const Spacer(),
                          // Nút Order
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  theme.AppColors.primaryGradient.colors.last,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              padding: const EdgeInsets.symmetric(
                                vertical: 8,
                                horizontal: 20,
                              ),
                            ),
                            onPressed: () async {
                              // Nếu chưa đăng nhập → chuyển sang LoginScreen
                              if (currentUserId == null) {
                                final result = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const LoginScreen(),
                                  ),
                                );

                                // Sau khi đăng nhập quay lại, kiểm tra kết quả
                                if (result != null &&
                                    result.containsKey('id')) {
                                  setState(() {
                                    currentUserId = result['id'];
                                  });

                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text("Đăng nhập thành công!"),
                                      backgroundColor: Colors.green,
                                    ),
                                  );
                                }

                                return; // Thoát khỏi hàm để không chạy tiếp phần mua hàng
                              }

                              // Nếu đã đăng nhập → tiến hành thêm vào giỏ và checkout
                              final cartProvider = Provider.of<CartProvider>(
                                context,
                                listen: false,
                              );

                              cartProvider.addToCart(p);

                              await cartProvider.checkout(
                                userId: currentUserId!,
                                context: context,
                              );
                            },
                            child: const Text(
                              "Order",
                              style: TextStyle(
                                color: theme.AppColors.textSecondary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
