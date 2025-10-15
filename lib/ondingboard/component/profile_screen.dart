import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
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
        onPressed: () async {
          if (text == 'Sign Out') {
            Navigator.pop(context);
          } else if (text == 'Review App') {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const SelectBuildPage()),
            );
          } else if (text == 'Delete Account') {
            await _deleteAccount(context);
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

  Future<void> _deleteAccount(BuildContext context) async {
    final int? id = user['userId'] ?? user['id'];
    if (id == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('User ID not found')));
      return;
    }

    final String url = 'http://10.0.2.2:5162/api/user/$id';

    // Hiển thị dialog xác nhận
    final bool? confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Confirm Delete'),
        content: const Text('Are you sure you want to delete your account?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirm != true) return; // Nếu bấm Cancel thì thôi

    try {
      final response = await http.delete(Uri.parse(url));

      if (response.statusCode == 200 || response.statusCode == 204) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Account deleted successfully')),
        );
        Navigator.pop(context); // Quay lại màn hình login
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to delete account: ${response.statusCode}'),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error deleting account: $e')));
    }
  }
}
