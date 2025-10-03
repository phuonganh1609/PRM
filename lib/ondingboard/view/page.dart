import 'package:flutter/material.dart';
import 'package:buid_app/ondingboard/component/buildPC.dart';
import 'package:buid_app/ondingboard/component/categories.dart';
import 'package:buid_app/ondingboard/theme/theme.dart' as theme;
import 'package:buid_app/ondingboard/component/sale_list_screen.dart';
import 'package:buid_app/ondingboard/component/signin_method_screen.dart';
import 'package:buid_app/ondingboard/component/logged_in_screen.dart';

// Trang chính của ứng dụng
// class HomePage extends StatefulWidget {
//   const HomePage({super.key});

//   @override
//   // Widget build(BuildContext context) {
//   //   return Scaffold(
//   //     appBar: AppBar(
//   //       backgroundColor: theme.AppColors.primaryGradient.colors.first,
//   //       title: const Text(
//   //         "Build Your PC",
//   //         style: TextStyle(
//   //           color: theme.AppColors.textSecondary,
//   //           fontWeight: FontWeight.bold,
//   //         ),
//   //       ),
//   //       centerTitle: true,
//   //     ),
//   //     body: Container(
//   //       // Gradient background
//   //       decoration: const BoxDecoration(
//   //         gradient: theme.AppColors.primaryGradient,
//   //       ),
//   //       child: Center(
//   //         child: Column(
//   //           mainAxisAlignment: MainAxisAlignment.center,
//   //           children: [
//   //             ElevatedButton(
//   //               style: ElevatedButton.styleFrom(
//   //                 backgroundColor: Colors.white,
//   //                 shape: RoundedRectangleBorder(
//   //                   borderRadius: BorderRadius.circular(30),
//   //                 ),
//   //                 padding: const EdgeInsets.symmetric(
//   //                   vertical: 15,
//   //                   horizontal: 40,
//   //                 ),
//   //               ),
//   //               onPressed: () {
//   //                 Navigator.push(
//   //                   context,
//   //                   MaterialPageRoute(
//   //                     builder: (context) => const SelectBuildPage(),
//   //                   ),
//   //                 );
//   //               },
//   //               child: const Icon(
//   //                 Icons.computer, // icon hợp lý hơn
//   //                 color: Colors.black,
//   //                 size: 30,
//   //               ),
//   //             ),
//   //             const SizedBox(height: 20),
//   //             ElevatedButton(
//   //               style: ElevatedButton.styleFrom(
//   //                 backgroundColor: Colors.white,
//   //                 shape: RoundedRectangleBorder(
//   //                   borderRadius: BorderRadius.circular(30),
//   //                 ),
//   //                 padding: const EdgeInsets.symmetric(
//   //                   vertical: 15,
//   //                   horizontal: 40,
//   //                 ),
//   //               ),
//   //               onPressed: () {
//   //                 Navigator.push(
//   //                   context,
//   //                   MaterialPageRoute(builder: (context) => Categories()),
//   //                 );
//   //               },
//   //               child: Icon(
//   //                 Icons.category, // icon hợp lý hơn
//   //                 color: Colors.black,
//   //                 size: 30,
//   //               ),
//   //             ),
//   //             const SizedBox(height: 20),
//   //             ElevatedButton(
//   //               style: ElevatedButton.styleFrom(
//   //                 backgroundColor: Colors.white,
//   //                 shape: RoundedRectangleBorder(
//   //                   borderRadius: BorderRadius.circular(30),
//   //                 ),
//   //                 padding: const EdgeInsets.symmetric(
//   //                   vertical: 15,
//   //                   horizontal: 40,
//   //                 ),
//   //               ),
//   //               onPressed: () {
//   //                 Navigator.push(
//   //                   context,
//   //                   MaterialPageRoute(builder: (context) => Categories()),
//   //                 );
//   //               },
//   //               child: Icon(
//   //                 Icons.add_box_rounded, // package hợp lý hơn
//   //                 color: Colors.black,
//   //                 size: 30,
//   //               ),
//   //             ),
//   //             const SizedBox(height: 20),
//   //             ElevatedButton(
//   //               style: ElevatedButton.styleFrom(
//   //                 backgroundColor: Colors.white,
//   //                 shape: RoundedRectangleBorder(
//   //                   borderRadius: BorderRadius.circular(30),
//   //                 ),
//   //                 padding: const EdgeInsets.symmetric(
//   //                   vertical: 15,
//   //                   horizontal: 40,
//   //                 ),
//   //               ),
//   //               onPressed: () {
//   //                 Navigator.push(
//   //                   context,
//   //                   MaterialPageRoute(builder: (context) => Categories()),
//   //                 );
//   //               },
//   //               child: Icon(
//   //                 Icons.person, // icon hợp lý hơn
//   //                 color: Colors.black,
//   //                 size: 30,
//   //               ),
//   //             ),
//   //           ],
//   //         ),
//   //       ),
//   //     ),
//   // );
//   // }
//   @override
//   State<HomePage> createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomePage> {
//  int _currentIndex = 0;
//   bool _isLoggedIn = false; // Giả sử chưa login

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: _currentIndex == 0
//           ? SelectBuildPage() ? Categories() ? SaleListScreen()
//           : (_isLoggedIn ? LoggedInScreen() : _buildProfilePlaceholder()),
//       bottomNavigationBar: BottomNavigationBar(
//         currentIndex: _currentIndex,
//         onTap: (index) {
//           setState(() {
//             _currentIndex = index;
//           });
//         },
//         items: const [
//           BottomNavigationBarItem(
//             icon: Icon(Icons.computer),
//             label: 'Build PC',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.category),
//             label: 'Categories',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.shopping_cart),
//             label: 'Sales',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.person),
//             label: 'Profile',
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildProfilePlaceholder() {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Profile'),
//         backgroundColor: Colors.white,
//         foregroundColor: Colors.black,
//         elevation: 0,
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(
//               Icons.person_outline,
//               size: 80,
//               color: Colors.grey[400],
//             ),
//             const SizedBox(height: 20),
//             Text(
//               'You are not logged in',
//               style: TextStyle(
//                 fontSize: 18,
//                 color: Colors.grey[600],
//               ),
//             ),
//             const SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) => SignInMethodScreen()),
//                 );
//               },
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.blue,
//                 foregroundColor: Colors.white,
//                 padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
//               ),
//               child: const Text('Sign In'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomePage> {
  int _currentIndex = 0;
  bool _isLoggedIn = false; // Giả sử chưa login

  @override
  Widget build(BuildContext context) {
    // Danh sách các trang tương ứng với từng tab
    final List<Widget> pages = [
      const SelectBuildPage(), // Build PC
      Categories(), // Categories
      const SaleListScreen(), // Sales
      _isLoggedIn
          ? const LoggedInScreen()
          : _buildProfilePlaceholder(), // Profile
    ];

    return Scaffold(
      body: pages[_currentIndex], // chọn page theo index
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          gradient: theme.AppColors.primaryGradient, // gradient bạn định nghĩa
        ),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.transparent, // để gradient hiện ra
          elevation: 0,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.white70,
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
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
                    builder: (context) => const SignInMethodScreen(),
                  ),
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
              child: const Text('Sign In'),
            ),
          ],
        ),
      ),
    );
  }
}
