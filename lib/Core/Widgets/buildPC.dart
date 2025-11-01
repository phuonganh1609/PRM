import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:buid_app/Core/Theme/theme.dart' as theme;
import 'package:http/http.dart' as http;

class BuildPC extends StatefulWidget {
  const BuildPC({super.key});

  @override
  State<BuildPC> createState() => _BuildPCState();
}

class _BuildPCState extends State<BuildPC> {
  List<dynamic> builds = [];
  bool isLoading = true;
  String? errorMessage;

  final String apiBaseUrl = "http://10.0.2.2:5162/api/build";
  final int userId =
      1; //  sau này bạn có thể lấy từ SharedPreferences hoặc token login

  @override
  void initState() {
    super.initState();
    fetchBuildsByUser(userId);
  }

  /// Lấy danh sách build của user
  Future<void> fetchBuildsByUser(int userId) async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final response = await http.get(Uri.parse("$apiBaseUrl/user/$userId"));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          builds = data;
          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage = "Lỗi khi tải dữ liệu (HTTP ${response.statusCode})";
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

  /// Tạo build mới
  Future<void> createBuild(String buildName) async {
    final url = Uri.parse(apiBaseUrl);
    final body = jsonEncode({
      "userId": userId,
      "name": buildName,
      "totalPrice": 0,
      "items": [],
    });

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: body,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Tạo build mới thành công!")),
        );
        fetchBuildsByUser(userId);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(" Lỗi tạo build (HTTP ${response.statusCode})"),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Lỗi kết nối: $e")));
    }
  }

  ///  Hiển thị dialog nhập tên build
  void _showCreateBuildDialog() {
    final TextEditingController nameController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Tạo Build Mới"),
        content: TextField(
          controller: nameController,
          decoration: const InputDecoration(hintText: "Nhập tên build của bạn"),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Hủy"),
          ),
          ElevatedButton(
            onPressed: () {
              final name = nameController.text.trim();
              if (name.isNotEmpty) {
                Navigator.pop(context);
                createBuild(name);
              }
            },
            child: const Text("Tạo"),
          ),
        ],
      ),
    );
  }

  /// Xóa build
  Future<void> deleteBuild(int id) async {
    try {
      final response = await http.delete(Uri.parse("$apiBaseUrl/$id"));
      if (response.statusCode == 200 || response.statusCode == 204) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Đã xóa build thành công")),
        );
        fetchBuildsByUser(userId);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(" Lỗi khi xóa build (HTTP ${response.statusCode})"),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Không thể kết nối tới server: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.AppColors.primaryGradient.colors.first,
        title: const Text(
          "Select Build",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: theme.AppColors.primaryGradient,
        ),
        child: Column(
          children: [
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                padding: const EdgeInsets.symmetric(
                  vertical: 15,
                  horizontal: 40,
                ),
              ),
              onPressed: _showCreateBuildDialog,
              child: const Text(
                "+ Create New Build",
                style: TextStyle(color: Colors.black, fontSize: 16),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : errorMessage != null
                  ? Center(
                      child: Text(
                        errorMessage!,
                        style: const TextStyle(color: Colors.red),
                      ),
                    )
                  : ListView.builder(
                      itemCount: builds.length,
                      itemBuilder: (context, index) {
                        final build = builds[index];
                        final id = build['id'] ?? 0;
                        final name = build['name'] ?? 'No Name';
                        final price = build['totalPrice'] ?? 0;
                        final createdAt = build['createdAt'] ?? '';

                        return _buildCard(
                          id: id,
                          name: name,
                          price: price,
                          createdAt: createdAt,
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCard({
    required int id,
    required String name,
    required dynamic price,
    required String createdAt,
  }) {
    return Card(
      color: Colors.grey[900],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsets.all(12),
      child: ListTile(
        title: Text(
          name,
          style: const TextStyle(color: Colors.white, fontSize: 18),
        ),
        subtitle: Text(
          "💰 Tổng: $price  |  🕒 $createdAt",
          style: const TextStyle(color: Colors.white70, fontSize: 13),
        ),
        trailing: IconButton(
          icon: const Icon(Icons.delete, color: Colors.redAccent),
          onPressed: () => deleteBuild(id),
        ),
      ),
    );
  }
}
