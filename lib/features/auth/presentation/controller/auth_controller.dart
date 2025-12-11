// lib/features/auth/presentation/controllers/auth_controller.dart

import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:device_info_plus/device_info_plus.dart';
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

  @override
  void onInit() {
    super.onInit();
    _initializeDeviceId();
  }

  /// Initialize and get device ID
  Future<void> _initializeDeviceId() async {
    try {
      String id = '';
      if (Platform.isAndroid) {
        AndroidDeviceInfo androidInfo = await _deviceInfo.androidInfo;
        id = androidInfo.id;

        if (id.isEmpty) {
          id = '${androidInfo.model}_${androidInfo.device}_${androidInfo.brand}';
        }
      } else if (Platform.isIOS) {
        IosDeviceInfo iosInfo = await _deviceInfo.iosInfo;
        id = iosInfo.identifierForVendor ?? '';
      }

      if (id.isEmpty) {
        id = 'device_${DateTime.now().millisecondsSinceEpoch}';
      }

      deviceId.value = id;
      print('📱 Device ID: $id');
    } catch (e) {
      print('❌ Error getting device ID: $e');
      deviceId.value = 'device_${DateTime.now().millisecondsSinceEpoch}';
    }
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
      await Future.delayed(const Duration(milliseconds: 1000));

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

    if (deviceId.value.isEmpty || deviceId.value == 'unknown') {
      await _initializeDeviceId();
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

      if (deviceId.value.isEmpty || deviceId.value == 'unknown') {
        await _initializeDeviceId();
      }

      print('📤 Requesting verification code for device registration');

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

    if (deviceId.value.isEmpty || deviceId.value == 'unknown') {
      await _initializeDeviceId();
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
        // Company already exists - show dialog to login
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