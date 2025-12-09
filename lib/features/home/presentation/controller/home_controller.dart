// lib/features/home/presentation/controllers/home_controller.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/services/storage_service.dart';
import '../../../../routes/app_routes.dart';

class HomeController extends GetxController {
  final RxString userName = ''.obs;
  final RxInt userId = 0.obs;
  final RxBool isLoading = true.obs;
  final RxString greeting = ''.obs;

  @override
  void onInit() {
    super.onInit();
    _setGreeting();
    loadUserInfo();
  }

  void _setGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      greeting.value = 'সুপ্রভাত';
    } else if (hour < 17) {
      greeting.value = 'শুভ অপরাহ্ন';
    } else {
      greeting.value = 'শুভ সন্ধ্যা';
    }
  }

  Future<void> loadUserInfo() async {
    try {
      isLoading.value = true;
      final name = await StorageService.getCompanyName();
      final id = await StorageService.getCompanyId();

      userName.value = name ?? 'ব্যবহারকারী';
      userId.value = id ?? 0;
    } catch (e) {
      Get.snackbar(
        'ত্রুটি',
        'ব্যবহারকারীর তথ্য লোড করতে ব্যর্থ',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logout() async {
    final confirmed = await Get.dialog<bool>(
      barrierDismissible: false,
      AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFFE74C3C).withOpacity(0.15),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.logout,
                color: Color(0xFFE74C3C),
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            const Text(
              'লগআউট',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        content: const Text(
          'আপনি কি নিশ্চিত যে আপনি লগআউট করতে চান?',
          style: TextStyle(fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text(
              'বাতিল',
              style: TextStyle(
                color: Colors.grey,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () => Get.back(result: true),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFE74C3C),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              'লগআউট',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      Get.dialog(
        const Center(child: CircularProgressIndicator()),
        barrierDismissible: false,
      );

      await StorageService.clearAll();
      Get.back(); // Close loading dialog
      Get.offAllNamed(AppRoutes.initial);
    }
  }

  void navigateToSales() {
    Get.toNamed(AppRoutes.sales);
  }

  void navigateToPurchase() {
    Get.snackbar(
      'শীঘ্রই আসছে',
      'ক্রয় বৈশিষ্ট্য শীঘ্রই যোগ করা হবে',
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}