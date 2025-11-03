import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:buid_app/Core/Provider/user_provider.dart';
import 'package:buid_app/Core/Theme/theme.dart' as theme;

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final identifierCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();
  bool isLoading = false;

  Future<void> _handleLogin() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    setState(() => isLoading = true);

    final result = await userProvider.login(
      identifierCtrl.text.trim(),
      passwordCtrl.text.trim(),
    );

    setState(() => isLoading = false);

    if (result != null) {
      Navigator.pop(context, result); // 🔙 Trả user về màn hình trước
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Sai thông tin đăng nhập")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Đăng nhập",
          style: const TextStyle(
            color: theme.AppColors.textSecondary,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: theme.AppColors.primaryGradient.colors.first,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            TextField(
              controller: identifierCtrl,
              decoration: const InputDecoration(labelText: "Email hoặc SĐT"),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: passwordCtrl,
              obscureText: true,
              decoration: const InputDecoration(labelText: "Mật khẩu"),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: isLoading ? null : _handleLogin,
              child: isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text("Login"),
            ),
          ],
        ),
      ),
    );
  }
}
