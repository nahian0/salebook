import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/auth_controller.dart';

class CompanyCheckPage extends StatefulWidget {
  const CompanyCheckPage({Key? key}) : super(key: key);

  @override
  State<CompanyCheckPage> createState() => _CompanyCheckPageState();
}

class _CompanyCheckPageState extends State<CompanyCheckPage> {
  bool _hasChecked = false;

  @override
  void initState() {
    super.initState();
    _initializeAuth();
  }

  Future<void> _initializeAuth() async {
    if (_hasChecked) return; // Prevent multiple calls
    _hasChecked = true;

    // Initialize controller only once
    final controller = Get.put(AuthController(), permanent: true);

    // Wait a bit for the UI to render
    await Future.delayed(const Duration(milliseconds: 500));

    // Check login status
    await controller.checkLoginStatus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF6F1),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // App Icon/Logo
            Container(
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(32),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF6C63FF).withOpacity(0.2),
                    blurRadius: 24,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: const Icon(
                Icons.business_center_rounded,
                size: 80,
                color: Color(0xFF6C63FF),
              ),
            ),
            const SizedBox(height: 40),

            // Loading Indicator
            const SizedBox(
              width: 48,
              height: 48,
              child: CircularProgressIndicator(
                strokeWidth: 3.5,
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF6C63FF)),
              ),
            ),
            const SizedBox(height: 24),

            // Loading Text
            Text(
              'লোড হচ্ছে...',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.grey.shade700,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'অনুগ্রহ করে অপেক্ষা করুন',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}