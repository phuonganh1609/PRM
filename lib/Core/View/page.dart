import 'package:flutter/material.dart';
import 'package:buid_app/Core/Widgets/buildPC.dart';
import 'package:buid_app/Core/Widgets/categories.dart';
import 'package:buid_app/Core/Widgets/sale_list_screen.dart';
import 'package:buid_app/Core/Widgets/profile_screen.dart';
import 'package:buid_app/Core/Widgets/login_screen.dart';
import 'package:buid_app/Core/Widgets/signin_method_screen.dart';
import 'package:buid_app/Core/Theme/theme.dart' as theme;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomePage> {
  int _currentIndex = 0;

  // ✅ Thêm biến lưu trạng thái đăng nhập
  bool _isLoggedIn = false;
  Map<String, dynamic> userData = {};

  void _onLoginSuccess(Map<String, dynamic> user) {
    setState(() {
      _isLoggedIn = true;
      userData = user;
    });
  }

  @override
  Widget build(BuildContext context) {
    //  Nếu chưa đăng nhập, gán userId = null
    final int? userId = _isLoggedIn ? userData['id'] : null;

    final List<Widget> pages = [
      const BuildPC(),
      const Categories(),
      // ✅ Truyền userId vào SaleListScreen
      SaleListScreen(userId: userId, grocery: {}),
      //  Nếu đã đăng nhập thì hiển thị profile, ngược lại là placeholder
      _isLoggedIn ? ProfileScreen(user: userData) : _buildProfilePlaceholder(),
    ];

    return Scaffold(
      body: pages[_currentIndex],
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          gradient: theme.AppColors.primaryGradient,
        ),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.transparent,
          elevation: 0,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.white70,
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() => _currentIndex = index);
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.computer),
              label: 'Build PC',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.category),
              label: 'Categories',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart),
              label: 'Sales',
            ),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          ],
        ),
      ),
    );
  }

  Widget _buildProfilePlaceholder() {
    return Container(
      decoration: const BoxDecoration(
        gradient: theme.AppColors.primaryGradient,
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.person_outline, size: 80, color: theme.AppColors.icon),
            const SizedBox(height: 16),
            Text(
              'You are not logged in',
              style: TextStyle(
                color: theme.AppColors.textSecondary,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final result = await Navigator.push<Map<String, dynamic>>(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                );

                if (result != null) {
                  _onLoginSuccess(result);
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
              child: const Text('Login'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const SignInMethodScreen()),
                );
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
              child: const Text('Sign Up'),
            ),
          ],
        ),
      ),
    );
  }
}
