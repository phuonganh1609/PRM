import 'package:flutter/material.dart';
import 'package:buid_app/ondingboard/theme/theme.dart' as theme;
import 'package:buid_app/ondingboard/component/buildPC.dart';

class LoggedInScreen extends StatelessWidget {
  final Map<String, dynamic> user;

  const LoggedInScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          user['fullname'] ?? 'Profile',
          style: TextStyle(
            color: theme.AppColors.textSecondary,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: theme.AppColors.primaryGradient.colors.first,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Username (fullname/email)
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

            const SizedBox(height: 32),

            // Nút hành động
            _buildActionButton(context, 'Delete Account', Colors.red),
            _buildActionButton(context, 'Sign Out', Colors.blue),
            _buildActionButton(context, 'Review App', Colors.grey),

            const Spacer(),

            // Footer
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(onPressed: () {}, child: const Text('Contact Us')),
                TextButton(
                  onPressed: () {},
                  child: const Text('Affiliate Disclosure'),
                ),
              ],
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

  Widget _buildActionButton(BuildContext context, String text, Color color) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      child: ElevatedButton(
        onPressed: () {
          if (text == 'Sign Out') {
            // ⚡ Đăng xuất -> quay lại màn hình login
            Navigator.pop(context);
          } else if (text == 'Review App') {
            // ⚡ Quay về màn hình chính buildCore.dart
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const SelectBuildPage()),
            );
          } else if (text == 'Delete Account') {
            // ⚡ TODO: Gọi API xoá tài khoản nếu muốn
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
        child: Text(text),
      ),
    );
  }
}
