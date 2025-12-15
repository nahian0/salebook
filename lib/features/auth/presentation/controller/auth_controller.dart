// lib/features/auth/presentation/controllers/auth_controller.dart

import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import 'dart:io';
import '../../../../routes/app_routes.dart';
import '../../data/repositories/company_repository.dart';
import '../../../../core/utils/dialog_utils.dart';

class AuthController extends GetxController {
  final CompanyRepository _repository = CompanyRepository();
  final DeviceInfoPlugin _deviceInfo = DeviceInfoPlugin();

  // Observable states
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final RxBool isLoggedIn = false.obs;
  final RxString deviceId = ''.obs;

  static const String _deviceIdKey = 'unique_device_id';

  @override
  void onInit() {
    super.onInit();
    _initializeDeviceId();
  }

  /// Initialize and get device ID using multiple fallback methods
  Future<void> _initializeDeviceId() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // Check if we already have a stored device ID
      String? storedId = prefs.getString(_deviceIdKey);

      if (storedId != null && storedId.isNotEmpty) {
        deviceId.value = storedId;
        print('📱 Using stored Device ID: $storedId');
        return;
      }

      // Generate new device ID using multiple sources
      String id = await _generateDeviceId();

      // Store the generated ID for future use
      await prefs.setString(_deviceIdKey, id);
      deviceId.value = id;
      print('📱 Generated new Device ID: $id');
    } catch (e) {
      print('❌ Error getting device ID: $e');
      // Generate a fallback UUID if everything fails
      final fallbackId = const Uuid().v4();
      deviceId.value = fallbackId;

      try {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(_deviceIdKey, fallbackId);
      } catch (_) {}
    }
  }

  /// Generate device ID using device information
  Future<String> _generateDeviceId() async {
    try {
      if (Platform.isAndroid) {
        AndroidDeviceInfo androidInfo = await _deviceInfo.androidInfo;

        // Use androidId (most reliable for Android)
        String androidId = androidInfo.id; // This is actually androidId, not the deprecated id

        // Create a unique identifier combining multiple factors
        String combined = '${androidInfo.model}_${androidInfo.device}_$androidId';

        print('🤖 Android Device Info:');
        print('   Model: ${androidInfo.model}');
        print('   Device: ${androidInfo.device}');
        print('   Android ID: $androidId');
        print('   Combined: $combined');

        return _generateHashFromString(combined);

      } else if (Platform.isIOS) {
        IosDeviceInfo iosInfo = await _deviceInfo.iosInfo;

        // Use identifierForVendor
        String? iosId = iosInfo.identifierForVendor;

        if (iosId != null && iosId.isNotEmpty) {
          print('🍎 iOS Device ID: $iosId');
          return iosId;
        }

        // Fallback for iOS
        String combined = '${iosInfo.name}_${iosInfo.model}_${iosInfo.systemVersion}';
        print('🍎 iOS Fallback ID: $combined');
        return _generateHashFromString(combined);
      }
    } catch (e) {
      print('❌ Error in _generateDeviceId: $e');
    }

    // Ultimate fallback - generate UUID
    return const Uuid().v4();
  }

  /// Generate a consistent hash from string (simple version)
  String _generateHashFromString(String input) {
    int hash = 0;
    for (int i = 0; i < input.length; i++) {
      hash = ((hash << 5) - hash) + input.codeUnitAt(i);
      hash = hash & hash; // Convert to 32-bit integer
    }
    return 'dev_${hash.abs()}_${const Uuid().v4().substring(0, 8)}';
  }

  /// Check if user is already logged in
  Future<void> checkLoginStatus() async {
    print('🔍 Checking login status...');

    final currentRoute = Get.currentRoute;
    if (currentRoute == AppRoutes.verifyCode) {
      print('⚠️ On verify code page, skipping login check');
      return;
    }

    if (isLoading.value) {
      print('⚠️ Already checking, skipping...');
      return;
    }

    try {
      isLoading.value = true;

      // Ensure device ID is initialized
      if (deviceId.value.isEmpty) {
        await _initializeDeviceId();
      }

      await Future.delayed(const Duration(milliseconds: 500));

      final loggedIn = await _repository.isUserLoggedIn();
      isLoggedIn.value = loggedIn;

      print('✅ Login status: $loggedIn');

      if (loggedIn) {
        print('📍 Navigating to home...');
        Get.offAllNamed(AppRoutes.home);
      } else {
        print('📍 Navigating to login...');
        Get.offAllNamed(AppRoutes.login);
      }
    } catch (e) {
      print('❌ Error checking status: $e');
      errorMessage.value = 'ত্রুটি: $e';
      Get.offAllNamed(AppRoutes.login);
    } finally {
      isLoading.value = false;
    }
  }

  /// Login with phone number and device ID verification
  Future<void> loginWithPhone(String phone) async {
    if (phone.isEmpty) {
      _showError('অনুগ্রহ করে ফোন নম্বর লিখুন');
      return;
    }

    if (phone.length < 11) {
      _showError('সঠিক ফোন নম্বর লিখুন');
      return;
    }

    // Ensure device ID is properly initialized
    if (deviceId.value.isEmpty) {
      await _initializeDeviceId();
    }

    // Double check device ID is valid
    if (deviceId.value.isEmpty) {
      _showError('ডিভাইস আইডি পাওয়া যায়নি। অ্যাপ পুনরায় চালু করুন।');
      return;
    }

    try {
      isLoading.value = true;
      errorMessage.value = '';

      print('📤 Logging in with phone: $phone and deviceId: ${deviceId.value}');

      final result = await _repository.loginWithPhone(
        phoneNo: phone,
        deviceId: deviceId.value,
      );

      if (result.success) {
        isLoggedIn.value = true;
        _showSuccess('সফলভাবে লগইন হয়েছে!');
        await Future.delayed(const Duration(milliseconds: 500));
        Get.offAllNamed(AppRoutes.home);
      } else if (result.isDifferentDevice) {
        DialogUtils.showDifferentDeviceDialog(
          phone: phone,
          message: result.message,
          companyData: result.companyData,
          onRegisterTap: () => _handleDeviceRegistration(phone),
        );
      } else {
        _showError('ফোন নম্বর দিয়ে কোনো ইউজার পাওয়া যায়নি');
      }
    } catch (e) {
      _showError('ত্রুটি: ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }

  /// Handle device registration - Send verification code
  Future<void> _handleDeviceRegistration(String phone) async {
    try {
      DialogUtils.showLoadingDialog(message: 'কোড পাঠানো হচ্ছে...');

      if (deviceId.value.isEmpty) {
        await _initializeDeviceId();
      }

      print('📤 Requesting verification code for device registration');
      print('📱 Using Device ID: ${deviceId.value}');

      final result = await _repository.sendVerificationCode(
        phoneNo: phone,
        deviceId: deviceId.value,
      );

      DialogUtils.dismissDialog();

      if (result != null) {
        _showSuccess('যাচাইকরণ কোড পাঠানো হয়েছে!');

        await Future.delayed(const Duration(milliseconds: 500));

        print('📍 Navigating to verify-code page...');
        Get.toNamed(AppRoutes.verifyCode, arguments: {
          'phone': phone,
          'deviceId': deviceId.value,
          'companyId': result.companyId,
          'verificationCode': result.verificationCode
        });
      } else {
        _showError('কোড পাঠাতে ব্যর্থ হয়েছে');
      }
    } catch (e) {
      DialogUtils.dismissDialog();
      _showError('ত্রুটি: ${e.toString()}');
    }
  }

  /// Create new company/user with device ID
  Future<void> createCompany({
    required String name,
    required String phone,
    String? desc,
  }) async {
    if (name.isEmpty) {
      _showError('অনুগ্রহ করে ইউজার নাম লিখুন');
      return;
    }

    if (phone.isEmpty) {
      _showError('অনুগ্রহ করে ফোন নম্বর লিখুন');
      return;
    }

    if (phone.length < 11) {
      _showError('সঠিক ফোন নম্বর লিখুন');
      return;
    }

    // Ensure device ID is properly initialized
    if (deviceId.value.isEmpty) {
      await _initializeDeviceId();
    }

    if (deviceId.value.isEmpty) {
      _showError('ডিভাইস আইডি পাওয়া যায়নি। অ্যাপ পুনরায় চালু করুন।');
      return;
    }

    try {
      isLoading.value = true;
      errorMessage.value = '';

      print('📤 Creating company with device ID: ${deviceId.value}');

      final result = await _repository.createCompany(
        name: name,
        phoneNo: phone,
        description: desc ?? '',
        deviceId: deviceId.value,
      );

      if (result.success) {
        isLoggedIn.value = true;
        _showSuccess(result.message);
        await Future.delayed(const Duration(milliseconds: 500));
        Get.offAllNamed(AppRoutes.home);
      } else if (result.alreadyExists) {
        String? companyName;
        if (result.companyData != null && result.companyData!['name'] != null) {
          companyName = result.companyData!['name'];
        }

        DialogUtils.showCompanyExistsDialog(
          phone: phone,
          companyName: companyName,
          companyData: result.companyData,
          onGoToLogin: goToLogin,
        );
      } else {
        _showError(result.message);
      }
    } catch (e) {
      final errorMsg = e.toString();
      if (errorMsg.contains('exists') || errorMsg.contains('Exists')) {
        _showError('এই নম্বরটি ইতিমধ্যে নিবন্ধিত আছে। অনুগ্রহ করে লগইন করুন।');
      } else {
        _showError('ত্রুটি: $errorMsg');
      }
    } finally {
      isLoading.value = false;
    }
  }

  /// Logout user
  Future<void> logout() async {
    try {
      isLoading.value = true;
      await _repository.logout();
      isLoggedIn.value = false;
      Get.offAllNamed(AppRoutes.login);
      _showSuccess('সফলভাবে লগআউট হয়েছে');
    } catch (e) {
      _showError('লগআউট ব্যর্থ: ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }

  /// Manual method to refresh device ID (for debugging)
  Future<void> refreshDeviceId() async {
    print('🔄 Refreshing device ID...');
    await _initializeDeviceId();
    _showSuccess('ডিভাইস আইডি রিফ্রেশ করা হয়েছে: ${deviceId.value}');
  }

  void goToCreateCompany() => Get.toNamed(AppRoutes.createCompany);
  void goToLogin() => Get.offAllNamed(AppRoutes.login);

  void _showSuccess(String message) {
    Get.snackbar(
      'সফল',
      message,
      backgroundColor: const Color(0xFF4CAF50),
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
      borderRadius: 12,
      margin: const EdgeInsets.all(16),
      duration: const Duration(seconds: 2),
      icon: const Icon(Icons.check_circle, color: Colors.white),
    );
  }

  void _showError(String message) {
    errorMessage.value = message;
    Get.snackbar(
      'ত্রুটি',
      message,
      backgroundColor: const Color(0xFFE74C3C),
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
      borderRadius: 12,
      margin: const EdgeInsets.all(16),
      duration: const Duration(seconds: 3),
      icon: const Icon(Icons.error, color: Colors.white),
    );
  }

  @override
  void onClose() {
    super.onClose();
  }
}