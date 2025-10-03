import 'package:flutter/material.dart';
import 'package:buid_app/ondingboard/theme/theme.dart' as theme;

class LoggedInScreen extends StatelessWidget {
  const LoggedInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Profile',
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
            // User ID
            Center(
              child: Text(
                'wz8xhzf5xq6178',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),

            SizedBox(height: 32),

            // Region info
            _buildInfoRow('Region', 'United States'),

            SizedBox(height: 16),

            // Username info
            _buildInfoRow('Username', 'wz8xhzf5xq6178'),

            SizedBox(height: 32),

            // Action buttons
            _buildActionButton('Delete Account', Colors.red),
            _buildActionButton('Sign Out', Colors.blue),
            _buildActionButton('Review App', Colors.grey),

            Spacer(),

            // Footer
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(onPressed: () {}, child: Text('Contact Us')),
                TextButton(
                  onPressed: () {},
                  child: Text('Affiliate Disclosure'),
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
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        Text(value, style: TextStyle(fontSize: 16, color: Colors.grey[600])),
      ],
    );
  }

  Widget _buildActionButton(String text, Color color) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: 12),
      child: ElevatedButton(
        onPressed: () {
          if (text == 'Sign Out') {
            // Xử lý đăng xuất
            // Trong thực tế, bạn sẽ clear token và quay về màn hình chưa login
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          padding: EdgeInsets.symmetric(vertical: 16),
        ),
        child: Text(text),
      ),
    );
  }
}
