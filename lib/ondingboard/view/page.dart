import 'package:flutter/material.dart';
import 'package:buid_app/ondingboard/component/buildPC.dart';
import 'package:buid_app/ondingboard/component/categories.dart';
import 'package:buid_app/ondingboard/theme/theme.dart' as theme;
import 'package:buid_app/ondingboard/component/sale_list_screen.dart';
import 'package:buid_app/ondingboard/component/signin_method_screen.dart';
import 'package:buid_app/ondingboard/component/profile_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomePage> {
  int _currentIndex = 0;
  bool _isLoggedIn = false;

  // Tạo userData mẫu (sau này có thể load từ SharedPreferences)
  Map<String, dynamic> userData = {
    "id": 1,
    "fullname": "Demo User",
    "email": "demo@example.com",
    "phone": "0123456789",
    "address": "Ho Chi Minh City",
    "role": "User",
  };

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      const SelectBuildPage(),
      Categories(),
      const SaleListScreen(), //
      _isLoggedIn
          ? LoggedInScreen(user: userData) //  truyền đúng param
          : _buildProfilePlaceholder(),
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
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const SignInMethodScreen(),
                  ), //chuyen den login, chua thay doi duong dan
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
