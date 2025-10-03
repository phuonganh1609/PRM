import 'package:flutter/material.dart';
import 'package:buid_app/ondingboard/theme/theme.dart' as theme;

class Categories extends StatelessWidget {
  final categories = [
    {"title": "Case", "icon": Icons.computer},
    {"title": "CPU", "icon": Icons.memory},
    {"title": "Motherboard", "icon": Icons.developer_board},
    {"title": "GPU", "icon": Icons.graphic_eq},
    {"title": "RAM", "icon": Icons.sd_storage},
    {"title": "CPU Cooler", "icon": Icons.ac_unit},
    {"title": "Storage", "icon": Icons.storage},
    {"title": "Power Supply", "icon": Icons.power},
    {"title": "Case Fane", "icon": Icons.mode_fan_off_outlined},
    {"title": "Monitor", "icon": Icons.monitor},
    {"title": "Mouse", "icon": Icons.mouse},
    {"title": "Speaker", "icon": Icons.speaker},
    {"title": "Headphone", "icon": Icons.headphones},
    {"title": "Keyboard", "icon": Icons.keyboard},
    {"title": "Thermal Compound", "icon": Icons.colorize},
    {"title": "Operating System", "icon": Icons.face},
    {"title": "Sound Card", "icon": Icons.multitrack_audio_outlined},
    {"title": "Netword Card", "icon": Icons.network_wifi},
    {"title": "Microphone", "icon": Icons.mic},
    {"title": "VR Headset", "icon": Icons.vrpano},
    {"title": "Capture Card", "icon": Icons.download},
    {"title": "Webcam", "icon": Icons.camera_outlined},
  ];
  Categories({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: theme.AppColors.primaryGradient.colors.first,
      appBar: AppBar(
        backgroundColor: theme.AppColors.primaryGradient.colors.first,
        title: const Text(
          "Part Categories",
          style: TextStyle(
            color: theme.AppColors.textSecondary,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: theme.AppColors.primaryGradient,
        ),
        child: ScrollbarTheme(
          data: ScrollbarThemeData(
            thumbColor: MaterialStateProperty.all(
              theme.AppColors.primaryGradient.colors.first, // xanh đậm đầu
            ),
            trackColor: MaterialStateProperty.all(
              theme.AppColors.primaryGradient.colors.last.withOpacity(
                0.3,
              ), // xanh nhạt cuối
            ),
            trackBorderColor: MaterialStateProperty.all(Colors.transparent),
            thickness: MaterialStateProperty.all(6),
            radius: const Radius.circular(10),
          ),
          child: Scrollbar(
            thumbVisibility: true,
            child: GridView.count(
              crossAxisCount: 2,
              padding: const EdgeInsets.all(16),
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              children: categories.map((cat) {
                return Container(
                  decoration: BoxDecoration(
                    color: theme.AppColors.cardBackground,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        cat["icon"] as IconData,
                        size: 40,
                        color: theme.AppColors.icon,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        cat["title"] as String,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }
}
