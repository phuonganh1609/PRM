import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:buid_app/ondingboard/theme/theme.dart' as theme;

class Categories extends StatefulWidget {
  const Categories({super.key});

  @override
  State<Categories> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<Categories> {
  List<dynamic> categories = [];
  bool isLoading = true;
  String? errorMessage;

  // 🔹 URL backend API (dùng 10.0.2.2 thay vì localhost)
  final String apiUrl = "http://10.0.2.2:5162/api/category";

  @override
  void initState() {
    super.initState();
    fetchCategories();
  }

  Future<void> fetchCategories() async {
    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (!mounted) return; //  tránh lỗi setState sau dispose

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
      if (!mounted) return; //  kiểm tra trước khi setState
      setState(() {
        errorMessage = "Không thể kết nối đến server: $e";
        isLoading = false;
      });
    }
  }

  // Gán icon tạm dựa theo tên
  IconData _getCategoryIcon(String name) {
    final lower = name.toLowerCase();
    if (lower.contains('cpu')) return Icons.memory;
    if (lower.contains('gpu')) return Icons.graphic_eq;
    if (lower.contains('ram')) return Icons.sd_storage;
    if (lower.contains('storage')) return Icons.storage;
    if (lower.contains('main') || lower.contains('board'))
      return Icons.developer_board;
    if (lower.contains('case')) return Icons.computer;
    if (lower.contains('monitor')) return Icons.monitor;
    if (lower.contains('keyboard')) return Icons.keyboard;
    if (lower.contains('mouse')) return Icons.mouse;
    if (lower.contains('headset') || lower.contains('headphone'))
      return Icons.headphones;
    return Icons.category;
  }

  @override
  void dispose() {
    //  chuẩn bị nếu sau này cần cancel request hay timer
    super.dispose();
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
            : ScrollbarTheme(
                data: ScrollbarThemeData(
                  thumbColor: MaterialStateProperty.all(
                    theme.AppColors.primaryGradient.colors.first,
                  ),
                  trackColor: MaterialStateProperty.all(
                    theme.AppColors.primaryGradient.colors.last.withOpacity(
                      0.3,
                    ),
                  ),
                  trackBorderColor: MaterialStateProperty.all(
                    Colors.transparent,
                  ),
                  thickness: MaterialStateProperty.all(6),
                  radius: const Radius.circular(10),
                ),
                child: Scrollbar(
                  thumbVisibility: true,
                  child: GridView.builder(
                    padding: const EdgeInsets.all(16),
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
                      return Container(
                        decoration: BoxDecoration(
                          color: theme.AppColors.cardBackground,
                          borderRadius: BorderRadius.circular(16),
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
                                fontSize: 20,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
      ),
    );
  }
}
