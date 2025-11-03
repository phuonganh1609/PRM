import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:buid_app/Core/View/page.dart';
import 'package:buid_app/Core/Provider/cart_provider.dart';
import 'package:buid_app/Core/Provider/user_provider.dart'; // Thêm dòng này

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => CartProvider(),
        ), // Provider cho giỏ hàng
        // Provider cho user
        ChangeNotifierProvider(create: (_) => UserProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: const HomePage(),
      ),
    );
  }
}
