import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:buid_app/Core/Theme/theme.dart' as theme;

class Categories extends StatefulWidget {
  const Categories({super.key});

  @override
  State<Categories> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<Categories> {
  List<dynamic> categories = [];
  List<dynamic> products = [];
  bool isLoading = true;
  String? errorMessage;
  int? selectedCategoryId;

  final String categoryUrl = "http://10.0.2.2:5162/api/category";

  @override
  void initState() {
    super.initState();
    fetchCategories();
  }

  Future<void> fetchCategories() async {
    try {
      final response = await http.get(Uri.parse(categoryUrl));

      if (!mounted) return;

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        setState(() {
          categories = data;
          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage = "Lỗi khi tải danh mục (HTTP ${response.statusCode})";
          isLoading = false;
        });
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        errorMessage = "Không thể kết nối đến server: $e";
        isLoading = false;
      });
    }
  }

  Future<void> fetchProductsByCategory(int categoryId) async {
    final url = "http://10.0.2.2:5162/api/category/$categoryId/products";
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        setState(() {
          products = data['products'] ?? [];
          errorMessage = null;
        });
      } else {
        setState(() {
          errorMessage = "Lỗi tải sản phẩm (HTTP ${response.statusCode})";
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = "Không thể kết nối tới server: $e";
      });
    }
  }

  IconData _getCategoryIcon(String name) {
    final lower = name.toLowerCase();
    if (lower.contains('cpu')) return Icons.memory;
    if (lower.contains('gpu')) return Icons.graphic_eq;
    if (lower.contains('ram')) return Icons.sd_storage;
    if (lower.contains('storage')) return Icons.storage;
    if (lower.contains('main') || lower.contains('board')) {
      return Icons.developer_board;
    }
    if (lower.contains('case')) return Icons.computer;
    if (lower.contains('monitor')) return Icons.monitor;
    if (lower.contains('keyboard')) return Icons.keyboard;
    if (lower.contains('mouse')) return Icons.mouse;
    if (lower.contains('headset') || lower.contains('headphone')) {
      return Icons.headphones;
    }
    return Icons.category;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: theme.AppColors.primaryGradient.colors.first,
      appBar: AppBar(
        backgroundColor: theme.AppColors.primaryGradient.colors.first,
        title: const Text(
          "Part Categories",
          style: TextStyle(
            color: theme.AppColors.textSecondary,
            fontWeight: FontWeight.bold,
          ),
        ),
        elevation: 1,
        centerTitle: true,
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
            : SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 20,
                    ), // Nếu chưa chọn category → Hiển thị toàn bộ danh mục
                    if (selectedCategoryId == null)
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 12,
                              mainAxisSpacing: 12,
                            ),
                        itemCount: categories.length,
                        itemBuilder: (context, index) {
                          final cat = categories[index];
                          final name = cat["name"] ?? "Unnamed";
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedCategoryId = cat["id"];
                              });
                              fetchProductsByCategory(cat["id"]);
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: theme.AppColors.cardBackground,
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.3),
                                    blurRadius: 6,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    _getCategoryIcon(name),
                                    size: 40,
                                    color: theme.AppColors.icon,
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    name,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),

                    // Nếu đã chọn category → Hiển thị sản phẩm
                    if (selectedCategoryId != null) ...[
                      const SizedBox(height: 20),
                      products.isEmpty
                          ? const Text(
                              "No products found",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            )
                          : GridView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    crossAxisSpacing: 10,
                                    mainAxisSpacing: 10,
                                    childAspectRatio: 0.8,
                                  ),
                              itemCount: products.length,
                              itemBuilder: (context, index) {
                                final p = products[index];
                                return Container(
                                  decoration: BoxDecoration(
                                    color: theme.AppColors.cardBackground,
                                    borderRadius: BorderRadius.circular(12),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.2),
                                        blurRadius: 4,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      if (p["imageUrl1"] != null &&
                                          p["imageUrl1"].toString().isNotEmpty)
                                        Image.network(
                                          p["imageUrl1"],
                                          height: 80,
                                        ),
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
                                        (p["productPrices"]?.isNotEmpty ??
                                                false)
                                            ? "${p["productPrices"][0]["price"]} đ"
                                            : "—",
                                        style: const TextStyle(
                                          color: theme.AppColors.price,
                                          fontWeight: FontWeight.bold,
                                          shadows: [
                                            Shadow(
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
                    ],
                  ],
                ),
              ),
      ),
    );
  }
}
