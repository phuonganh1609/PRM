import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:buid_app/Core/Theme/theme.dart' as theme;
import 'package:buid_app/Core/Widgets/login_screen.dart';

class SignInMethodScreen extends StatefulWidget {
  const SignInMethodScreen({super.key});

  @override
  State<SignInMethodScreen> createState() => _SignInMethodScreenState();
}

class _SignInMethodScreenState extends State<SignInMethodScreen> {
  final _fullnameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _addressCtrl = TextEditingController();
  final _dobCtrl = TextEditingController();

  final String baseUrl = 'http://10.0.2.2:5162/api/user';
  bool _isLoading = false;
  Future<void> _handleRegister() async {
    // Kiểm tra có ô nào bị bỏ trống không
    if (_fullnameCtrl.text.isEmpty ||
        _emailCtrl.text.isEmpty ||
        _passwordCtrl.text.isEmpty ||
        _phoneCtrl.text.isEmpty ||
        _addressCtrl.text.isEmpty ||
        _dobCtrl.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng nhập đầy đủ thông tin!')),
      );
      return; // Dừng lại, không gửi request
    }

    setState(() => _isLoading = true);

    final uri = Uri.parse('$baseUrl/register');
    final body = jsonEncode({
      "fullname": _fullnameCtrl.text,
      "email": _emailCtrl.text,
      "password": _passwordCtrl.text,
      "phone": _phoneCtrl.text,
      "dob": _dobCtrl.text,
      "address": _addressCtrl.text,
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

        print('Register success, token: $token');

        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Đăng ký thành công!')));

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => LoginScreen()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Lỗi: ${data["message"] ?? "Không xác định"}'),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Lỗi kết nối: $e')));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Sign in to BuildCores',
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
            _buildTextField("Full Name", _fullnameCtrl),
            _buildTextField("Email", _emailCtrl),
            _buildTextField("Password", _passwordCtrl, obscureText: true),
            _buildTextField("Phone", _phoneCtrl),
            _buildTextField("Address", _addressCtrl),
            _buildTextField("Dob (yyyy-MM-dd)", _dobCtrl),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isLoading ? null : _handleRegister,
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.AppColors.background,
              ),
              child: _isLoading
                  ? const CircularProgressIndicator(
                      color: theme.AppColors.background,
                    )
                  : const Text('Sign Up'),
            ),
            //thêm chữ or
            const SizedBox(height: 20),
            const Center(
              child: Text('or', style: TextStyle(color: Colors.white70)),
            ),
            //nhớ sửa lại đoạn này
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isLoading ? null : _handleRegister,
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
          color: Colors.white, // chữ trắng
          fontSize: 16,
        ),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(
            color: Colors.white70, // nhãn hơi mờ
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
