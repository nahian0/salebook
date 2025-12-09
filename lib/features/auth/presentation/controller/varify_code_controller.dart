// lib/features/auth/presentation/controllers/verify_code_controller.dart

import 'dart:async';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../../../routes/app_routes.dart';
import '../../data/repositories/company_repository.dart';
import '../../../../core/utils/dialog_utils.dart';

class VerifyCodeController extends GetxController {
  final CompanyRepository _repository = CompanyRepository();

  // Observable states
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  // Timer states
  final RxInt remainingSeconds = 60.obs;
  final RxBool canResend = false.obs;
  Timer? _countdownTimer;

  // Text editing controllers for code input
  late final List<TextEditingController> codeControllers;
  late final List<FocusNode> focusNodes;

  // Arguments from navigation
  String phone = '';
  String deviceId = '';
  int companyId = 0;
  String companyName = '';
  String verificationCode = ''; // The actual code sent by server

  @override
  void onInit() {
    super.onInit();
    _initializeArguments();
    _initializeControllers();
    _startCountdown(); // Start countdown when page loads
  }

  /// Initialize arguments from Get.arguments
  void _initializeArguments() {
    final args = Get.arguments as Map<String, dynamic>?;
    phone = args?['phone'] ?? '';
    deviceId = args?['deviceId'] ?? '';
    companyId = args?['companyId'] ?? 0;
    companyName = args?['companyName'] ?? '';
    verificationCode = args?['verificationCode'] ?? '';

    print('📱 VerifyCodeController initialized with:');
    print('   Phone: $phone');
    print('   DeviceId: $deviceId');
    print('   CompanyId: $companyId');
    print('   CompanyName: $companyName');
    print('   VerificationCode: $verificationCode');
  }

  /// Initialize text controllers and focus nodes
  void _initializeControllers() {
    codeControllers = List.generate(4, (index) => TextEditingController());
    focusNodes = List.generate(4, (index) => FocusNode());

    // Auto-focus first field
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (focusNodes.isNotEmpty) {
        focusNodes[0].requestFocus();
      }
    });
  }

  /// Start countdown timer
  void _startCountdown() {
    remainingSeconds.value = 60;
    canResend.value = false;

    _countdownTimer?.cancel();
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (remainingSeconds.value > 0) {
        remainingSeconds.value--;
      } else {
        canResend.value = true;
        timer.cancel();
      }
    });
  }

  /// Get formatted time string
  String get formattedTime {
    final minutes = remainingSeconds.value ~/ 60;
    final seconds = remainingSeconds.value % 60;
    return '${minutes.toString().padLeft(1, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  /// Get the complete verification code
  String getCode() {
    return codeControllers.map((c) => c.text).join();
  }

  /// Check if code is complete
  bool isCodeComplete() {
    return getCode().length == 4;
  }

  /// Handle code input change
  void onCodeChanged(int index, String value, BuildContext context) {
    if (value.isNotEmpty && index < 3) {
      // Move to next field
      focusNodes[index + 1].requestFocus();
    } else if (value.isEmpty && index > 0) {
      // Move to previous field on backspace
      focusNodes[index - 1].requestFocus();
    }

    // Unfocus keyboard when all 4 digits are entered
    if (index == 3 && value.isNotEmpty && isCodeComplete()) {
      FocusScope.of(context).unfocus();
    }
  }

  /// Verify code and update device
  Future<void> verifyCode() async {
    final code = getCode();

    print('🔍 verifyCode called');
    print('   Code entered: $code');
    print('   Expected code: $verificationCode');
    print('   Code length: ${code.length}');
    print('   Phone: $phone');
    print('   DeviceId: $deviceId');
    print('   CompanyId: $companyId');

    // Validate code length
    if (code.length != 4) {
      print('❌ Code validation failed - length is ${code.length}');
      _showError('অনুগ্রহ করে ৪ ডিজিটের কোড লিখুন');
      return;
    }

    // Validate required data
    if (phone.isEmpty || deviceId.isEmpty || companyId == 0) {
      print('❌ Missing required data');
      _showError('প্রয়োজনীয় তথ্য পাওয়া যায়নি');
      return;
    }

    // Validate verification code
    if (verificationCode.isEmpty) {
      print('❌ Verification code not received from server');
      _showError('যাচাইকরণ কোড পাওয়া যায়নি। অনুগ্রহ করে পুনরায় চেষ্টা করুন।');
      return;
    }

    // Check if entered code matches the server code
    if (code != verificationCode) {
      print('❌ Code mismatch - entered: $code, expected: $verificationCode');
      _showError('ভুল কোড লিখেছেন। অনুগ্রহ করে সঠিক কোড লিখুন।');

      // Clear the code inputs
      clearCode();
      return;
    }

    if (isLoading.value) {
      print('⚠️ Already verifying...');
      return;
    }

    try {
      isLoading.value = true;
      errorMessage.value = '';

      print('✅ Code validation passed - codes match!');
      print('📤 Updating device in database');
      print('📦 CompanyId: $companyId, Code: $code');

      final success = await _repository.updateCompanyDevice(
        companyId: companyId,
        phoneNo: phone,
        deviceId: deviceId,
        verificationCode: code,
      );

      if (success) {
        _showSuccess('ডিভাইস সফলভাবে নিবন্ধিত হয়েছে!');
        await Future.delayed(const Duration(milliseconds: 500));

        print('📍 Navigating to home...');
        Get.offAllNamed(AppRoutes.home);
      } else {
        _showError('ডিভাইস নিবন্ধন ব্যর্থ হয়েছে। অনুগ্রহ করে পুনরায় চেষ্টা করুন।');
      }
    } catch (e) {
      print('❌ Error during verification: $e');
      _showError('ত্রুটি: ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }

  /// Resend verification code
  Future<void> resendCode() async {
    if (!canResend.value) {
      _showError('অনুগ্রহ করে $formattedTime অপেক্ষা করুন');
      return;
    }

    if (phone.isEmpty || deviceId.isEmpty) {
      _showError('ফোন নম্বর বা ডিভাইস আইডি পাওয়া যায়নি');
      return;
    }

    if (isLoading.value) {
      print('⚠️ Already processing...');
      return;
    }

    try {
      DialogUtils.showLoadingDialog(message: 'কোড পুনরায় পাঠানো হচ্ছে...');

      print('🔄 Resending verification code...');
      print('   Phone: $phone');
      print('   DeviceId: $deviceId');

      final result = await _repository.sendVerificationCode(
        phoneNo: phone,
        deviceId: deviceId,
      );

      DialogUtils.dismissDialog();

      if (result != null) {
        // Update the verification code with the new one
        verificationCode = result.verificationCode ?? '';

        print('✅ New verification code received: $verificationCode');

        _showSuccess('নতুন কোড পাঠানো হয়েছে!');

        // Clear existing code inputs
        for (var controller in codeControllers) {
          controller.clear();
        }

        // Focus on first field
        if (focusNodes.isNotEmpty) {
          focusNodes[0].requestFocus();
        }

        // Restart countdown
        _startCountdown();
      } else {
        _showError('কোড পাঠাতে ব্যর্থ হয়েছে');
      }
    } catch (e) {
      DialogUtils.dismissDialog();
      print('❌ Error resending code: $e');
      _showError('ত্রুটি: ${e.toString()}');
    }
  }

  /// Clear all code inputs
  void clearCode() {
    for (var controller in codeControllers) {
      controller.clear();
    }
    if (focusNodes.isNotEmpty) {
      focusNodes[0].requestFocus();
    }
  }

  /// Handle back button press
  void handleBackPress() {
    isLoading.value = false;
    _countdownTimer?.cancel();
    Get.back();
  }

  // UI Feedback methods
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
    // Cancel timer
    _countdownTimer?.cancel();

    // Clean up controllers and focus nodes
    for (var controller in codeControllers) {
      controller.dispose();
    }
    for (var node in focusNodes) {
      node.dispose();
    }
    super.onClose();
  }
}