import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:buid_app/ondingboard/theme/theme.dart' as theme;
import 'package:http/http.dart' as http;

class SaleFilterScreen extends StatefulWidget {
  const SaleFilterScreen({super.key});

  @override
  State<SaleFilterScreen> createState() => _SaleFilterScreenState();
}

class _SaleFilterScreenState extends State<SaleFilterScreen> {
  List<dynamic> categories = [];
  bool isLoading = true;
  String? errorMessage;
  int? selectedCategoryId;

  final String apiUrl = "http://10.0.2.2:5162/api/category";

  @override
  void initState() {
    super.initState();
    fetchCategories();
  }

  Future<void> fetchCategories() async {
    try {
      final response = await http.get(Uri.parse(apiUrl));

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
      setState(() {
        errorMessage = "Không thể kết nối đến server: $e";
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.AppColors.primaryGradient.colors.first,
        title: const Text(
          'Sale Filter',
          style: TextStyle(
            color: theme.AppColors.textSecondary,
            fontWeight: FontWeight.bold,
          ),
        ),
        elevation: 1,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: theme.AppColors.primaryGradient,
        ),
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : errorMessage != null
            ? Center(
                child: Text(
                  errorMessage!,
                  style: const TextStyle(color: Colors.redAccent, fontSize: 16),
                ),
              )
            : Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const Text(
                      "Select a Category:",
                      style: TextStyle(
                        color: theme.AppColors.textSecondary,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Danh sách các danh mục
                    Expanded(
                      child: ListView.separated(
                        itemCount: categories.length,
                        separatorBuilder: (_, __) => const Divider(),
                        itemBuilder: (context, index) {
                          final category = categories[index];
                          final id = category["id"];
                          final name = category["name"] ?? "Unnamed";

                          return ListTile(
                            title: Text(
                              name,
                              style: const TextStyle(
                                fontSize: 16,
                                color: theme.AppColors.textSecondary,
                              ),
                            ),
                            trailing: Radio<int>(
                              value: id,
                              groupValue: selectedCategoryId,
                              //chinh mau radio
                              activeColor: theme.AppColors.background,
                              onChanged: (value) {
                                setState(() {
                                  selectedCategoryId = value;
                                });
                              },
                            ),
                            onTap: () {
                              setState(() {
                                selectedCategoryId = id;
                              });
                            },
                          );
                        },
                      ),
                    ),

                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: selectedCategoryId == null
                          ? null
                          : () {
                              // Trả categoryId về màn trước
                              Navigator.pop(context, selectedCategoryId);
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: selectedCategoryId == null
                            ? Colors.grey[300] // Màu khi chưa chọn
                            : theme.AppColors.background, // Màu khi đã chọn
                        foregroundColor: selectedCategoryId == null
                            ? Colors.grey[600] // Màu chữ khi chưa chọn
                            : theme
                                  .AppColors
                                  .textPrimary, // Màu chữ khi đã chọn
                        padding: const EdgeInsets.symmetric(
                          vertical: 16,
                          horizontal: 20,
                        ),
                        minimumSize: const Size(double.infinity, 48),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: selectedCategoryId == null ? 0 : 2,
                      ),
                      child: Text(
                        selectedCategoryId == null
                            ? "Select a category"
                            : "Have $selectedCategoryId",
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
