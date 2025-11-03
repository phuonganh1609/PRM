import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:buid_app/Core/Provider/user_provider.dart';
import 'login_screen.dart';
import 'package:buid_app/Core/Theme/theme.dart' as theme;

class ProfileScreen extends StatelessWidget {
  final Map<String, dynamic> userData;

  const ProfileScreen({super.key, required this.userData});

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final user = userProvider.user ?? userData;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Profile',
          style: const TextStyle(
            color: theme.AppColors.textSecondary,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: theme.AppColors.primaryGradient.colors.first,
      ),

      body: userProvider.isLoggedIn
          ? Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      user['fullname'] ?? user['email'] ?? 'Unknown User',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Thông tin user
                  _buildInfoRow('Email', user['email'] ?? '—'),
                  const SizedBox(height: 16),
                  _buildInfoRow('Phone', user['phone'] ?? '—'),
                  const SizedBox(height: 16),
                  _buildInfoRow('Address', user['address'] ?? '—'),
                  const SizedBox(height: 16),
                  _buildInfoRow('Role', user['role'] ?? 'User'),

                  const SizedBox(height: 40),
                  //  Nút đăng xuất
                  ElevatedButton.icon(
                    onPressed: () {
                      userProvider.logout();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Đã đăng xuất thành công"),
                        ),
                      );
                    },
                    icon: const Icon(Icons.logout),
                    label: const Text("Đăng xuất"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                ],
              ),
            )
          //  Nếu chưa login, hiển thị giao diện đăng nhập
          : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.person_outline,
                    size: 100,
                    color: Colors.grey,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "Bạn chưa đăng nhập",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () async {
                      final result = await Navigator.push<Map<String, dynamic>>(
                        context,
                        MaterialPageRoute(builder: (_) => const LoginScreen()),
                      );
                      if (result != null) {
                        userProvider.setUser(result);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Đăng nhập thành công!"),
                            backgroundColor: Colors.green,
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: const Text("Đăng nhập / Đăng ký"),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        Text(value, style: TextStyle(fontSize: 16, color: Colors.grey[600])),
      ],
    );
  }
}
