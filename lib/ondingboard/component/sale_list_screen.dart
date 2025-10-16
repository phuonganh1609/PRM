import 'dart:convert';
import 'package:flutter/material.dart';
import 'sale_filter_screen.dart';
import 'package:http/http.dart' as http;
import 'package:buid_app/ondingboard/theme/theme.dart' as theme;

class SaleListScreen extends StatefulWidget {
  final int? categoryId; // có thể null (nếu chưa filter)

  const SaleListScreen({super.key, this.categoryId});

  @override
  State<SaleListScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<SaleListScreen> {
  List<dynamic> products = [];
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    if (widget.categoryId != null) {
      fetchProductsByCategory(widget.categoryId!);
    } else {
      fetchAllProducts();
    }
  }

  // 🔹 Lấy toàn bộ sản phẩm
  Future<void> fetchAllProducts() async {
    const url = "http://10.0.2.2:5162/api/product";
    await _fetchAndSet(url, isCategory: false);
  }

  // 🔹 Lấy sản phẩm theo danh mục
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
          if (isCategory) {
            // Trường hợp /api/category/{id}/products trả về 1 object
            products = data["products"] ?? [];
          } else {
            // Trường hợp /api/product trả về list
            products = List.from(data);
          }
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
          IconButton(
            icon: const Icon(Icons.filter_list),
            color: theme.AppColors.background,
            onPressed: () async {
              // Chờ chọn danh mục từ SaleFilterScreen
              final selectedCategoryId = await Navigator.push<int>(
                context,
                MaterialPageRoute(
                  builder: (context) => const SaleFilterScreen(),
                ),
              );

              // Nếu người dùng chọn danh mục => load lại sản phẩm
              if (selectedCategoryId != null) {
                setState(() {
                  isLoading = true;
                });
                await fetchProductsByCategory(selectedCategoryId);
              }
            },
          ),
        ],
        elevation: 0,
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
                  childAspectRatio: 0.75,
                ),
                itemCount: products.length,
                itemBuilder: (context, index) {
                  final p = products[index];
                  return Container(
                    decoration: BoxDecoration(
                      color: theme.AppColors.cardBackground,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (p["imageUrl1"] != null &&
                            p["imageUrl1"].toString().isNotEmpty)
                          Image.network(p["imageUrl1"], height: 80),
                        const SizedBox(height: 10),
                        Text(
                          p["name"] ?? "Unnamed",
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 5),
                        Text(
                          (p["productPrices"]?.isNotEmpty ?? false)
                              ? "${p["productPrices"][0]["price"]} đ"
                              : "—",
                          style: const TextStyle(
                            color: theme.AppColors.price,
                            fontWeight: FontWeight.bold,
                            shadows: [
                              Shadow(
                                // thêm bóng nhẹ để nổi bật trên nền gradient
                                offset: Offset(1, 1),
                                blurRadius: 2,
                                color: Colors.black26,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
      ),
    );
  }
}
