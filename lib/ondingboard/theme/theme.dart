import 'package:flutter/material.dart';

class AppColors {
  // Gradient chính
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF1E3A8A), // xanh đậm (rgb(30, 58, 138))
      Color(0xFF000000), // đen
    ],
  );

  // Các màu khác
  static const Color secondary = Color.fromARGB(255, 0, 255, 170); // xanh lá
  static const Color background = Color(0xFFF3F4F6); // xám nhạt
  static const Color cardBackground = Color.fromARGB(255, 30, 59, 138);
  static const Color textPrimary = Color(0xFF000000); // đen
  static const Color textSecondary = Color(0xFFFFFFFF); // trắng
  static const Color textThird = Color.fromARGB(255, 223, 203, 203); // xám đậm
  static const Color google = Color.fromARGB(
    255,
    255,
    1,
    1,
  ); // đỏ đặc trưng Google
  static const Color apple = Color(0xFF000000); // đen đặc trưng Apple
  static const Color icon = Color(0xFFFFFFFF);
}
