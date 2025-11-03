import 'package:buid_app/Core/Provider/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final bool isLoggedIn = userProvider.isLoggedIn;
    final int? userId = userProvider.userId;

    final List<Widget> pages = [
      const BuildPC(),
      const Categories(),
      SaleListScreen(userId: userId, grocery: const {}),

      // ✅ Hiển thị Profile hoặc placeholder tuỳ trạng thái
      isLoggedIn
          ? ProfileScreen(userData: userProvider.user!)
          : _buildProfilePlaceholder(context, userProvider),
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
          onTap: (index) => setState(() => _currentIndex = index),
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

  // Hiển thị khi chưa đăng nhập
  Widget _buildProfilePlaceholder(
    BuildContext context,
    UserProvider userProvider,
  ) {
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

            // 🔹 Nút Login
            ElevatedButton(
              onPressed: () async {
                final result = await Navigator.push<Map<String, dynamic>>(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                );

                if (result != null) {
                  userProvider.setUser(result);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Đăng nhập thành công!"),
                      backgroundColor: Colors.green,
                    ),
                  );
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

            // 🔹 Nút Sign up
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
