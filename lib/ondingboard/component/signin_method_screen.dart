import 'package:flutter/material.dart';
import 'logged_in_screen.dart';
import 'package:buid_app/ondingboard/theme/theme.dart' as theme;

class SignInMethodScreen extends StatelessWidget {
  const SignInMethodScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Sign in to BuildCores',
          style: TextStyle(
            color: theme.AppColors.textSecondary,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: theme.AppColors.primaryGradient.colors.first,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 40),

            // Google Sign In Button
            _buildSocialButton(
              text: 'Continue with Google',
              icon: Icons.g_mobiledata, // icon đặc trưng Google
              color: theme.AppColors.google,
              textColor: theme.AppColors.textSecondary,
              borderColor: Colors.grey.shade300,
              logoColor: theme.AppColors.icon,
              onPressed: () {
                _handleLogin(context);
              },
            ),

            SizedBox(height: 16),

            // Apple Sign In Button
            _buildSocialButton(
              text: 'Tiếp tục với Apple',
              icon: Icons.apple,
              color: theme.AppColors.apple,
              textColor: theme.AppColors.textSecondary,
              logoColor: theme.AppColors.icon,
              onPressed: () {
                _handleLogin(context);
              },
            ),

            SizedBox(height: 24),

            Divider(),

            SizedBox(height: 24),

            // Email Sign In Button
            ElevatedButton(
              onPressed: () {
                _handleLogin(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                foregroundColor: Colors.blue,
                elevation: 0,
                side: BorderSide(color: Colors.blue),
                padding: EdgeInsets.symmetric(vertical: 16),
              ),
              child: Text(
                'Continue with email',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSocialButton({
    required String text,
    required IconData icon,
    required Color color,
    required Color textColor,
    required VoidCallback onPressed,
    Color? borderColor,
    Color? logoColor,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: textColor,
        padding: EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: borderColor != null
              ? BorderSide(color: borderColor)
              : BorderSide.none,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: logoColor ?? textColor, size: 22),
          SizedBox(width: 12),
          Text(
            text,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }

  void _handleLogin(BuildContext context) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => LoggedInScreen()),
      (route) => false,
    );
  }
}
