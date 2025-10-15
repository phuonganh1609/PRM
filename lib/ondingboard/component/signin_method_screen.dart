import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'logged_in_screen.dart';

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

  final String baseUrl =
      'http://10.0.2.2:5162/api/user'; //  đổi sang port backend thật

  bool _isLoading = false;

  Future<void> _handleRegister() async {
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
        final token = data['token'];
        print(' Token: $token');
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Đăng ký thành công!')));

        // Chuyển sang màn hình Profile
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const LoggedInScreen()),
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
      ).showSnackBar(SnackBar(content: Text(' Lỗi kết nối: $e')));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign in to BuildCores'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: SingleChildScrollView(
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
              child: _isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text('Sign In'),
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
      padding: const EdgeInsets.only(bottom: 16),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }
}
