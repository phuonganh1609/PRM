import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:buid_app/ondingboard/theme/theme.dart' as theme;

//note đánh dấu code được thêm
// Xóa import không cần thiết: import 'package:buid_app/ondingboard/component/profile_screen.dart';
//kết thúc phần code được thêm

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _identifierCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();

  final String baseUrl = 'http://10.0.2.2:5162/api/user';
  bool _isLoading = false;

  Future<void> _handleLogin() async {
    if (_identifierCtrl.text.isEmpty || _passwordCtrl.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng nhập đầy đủ thông tin!')),
      );
      return;
    }

    setState(() => _isLoading = true);

    final uri = Uri.parse('$baseUrl/login');
    final body = jsonEncode({
      "identifier": _identifierCtrl.text,
      "password": _passwordCtrl.text,
    });

    try {
      final response = await http.post(
        uri,
        headers: {"Content-Type": "application/json"},
        body: body,
      );

      final data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        final user = data['user'];
        final token = data['token'];

        print('Login success, token: $token');

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Đăng nhập thành công!')),
        );
        //note đánh dấu code được thêm
        Navigator.pop(context, user); // Pop và trả về dữ liệu user
        //kết thúc phần code được thêm
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Lỗi: ${data["message"] ?? "Thông tin đăng nhập không đúng"}'),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi kết nối: $e')),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Login to BuildCores',
          style: TextStyle(
            color: theme.AppColors.textSecondary,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: theme.AppColors.primaryGradient.colors.first,
        elevation: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: theme.AppColors.primaryGradient,
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildTextField("Email or Phone", _identifierCtrl),
            _buildTextField("Password", _passwordCtrl, obscureText: true),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isLoading ? null : _handleLogin,
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.AppColors.background,
              ),
              child: _isLoading
                  ? const CircularProgressIndicator(
                      color: theme.AppColors.background,
                    )
                  : const Text('Login'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller, {
    bool obscureText = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
        ),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(
            color: Colors.white70,
            fontSize: 15,
          ),
          enabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white54, width: 1),
          ),
          focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white, width: 1.5),
          ),
        ),
      ),
    );
  }
}