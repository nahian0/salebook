import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../controller/auth_controller.dart';

class VerifyCodePage extends StatefulWidget {
  const VerifyCodePage({Key? key}) : super(key: key);

  @override
  State<VerifyCodePage> createState() => _VerifyCodePageState();
}

class _VerifyCodePageState extends State<VerifyCodePage> {
  late final List<TextEditingController> codeControllers;
  late final List<FocusNode> focusNodes;

  // Store arguments in state to prevent rebuilds
  late final String phone;
  late final String deviceId;
  late final int companyId;
  late final String companyName;

  @override
  void initState() {
    super.initState();

    // Get arguments once and store them
    final args = Get.arguments as Map<String, dynamic>?;
    phone = args?['phone'] ?? '';
    deviceId = args?['deviceId'] ?? '';
    companyId = args?['companyId'] ?? 0;
    companyName = args?['companyName'] ?? '';

    // Debug print
    print('📱 VerifyCodePage initialized with:');
    print('   Phone: $phone');
    print('   DeviceId: $deviceId');
    print('   CompanyId: $companyId');
    print('   CompanyName: $companyName');

    // Initialize controllers and focus nodes
    codeControllers = List.generate(4, (index) => TextEditingController());
    focusNodes = List.generate(4, (index) => FocusNode());

    // Auto-focus first field
    WidgetsBinding.instance.addPostFrameCallback((_) {
      focusNodes[0].requestFocus();
    });
  }

  @override
  void dispose() {
    // Clean up controllers and focus nodes
    for (var controller in codeControllers) {
      controller.dispose();
    }
    for (var node in focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  void _handleVerification(AuthController controller, String phone, String deviceId, int companyId) {
    final code = codeControllers.map((c) => c.text).join();

    print('🔍 _handleVerification called');
    print('   Code entered: $code');
    print('   Code length: ${code.length}');
    print('   Phone: $phone');
    print('   DeviceId: $deviceId');
    print('   CompanyId: $companyId');

    if (code.length != 4) {
      print('❌ Code validation failed - length is ${code.length}');
      Get.snackbar(
        'ত্রুটি',
        'অনুগ্রহ করে ৪ ডিজিটের কোড লিখুন',
        backgroundColor: const Color(0xFFE74C3C),
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        borderRadius: 12,
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 2),
      );
      return;
    }

    print('✅ Code validation passed - calling verifyAndUpdateDevice');

    controller.verifyAndUpdateDevice(
      companyId: companyId,
      phoneNo: phone,
      deviceId: deviceId,
      verificationCode: code,
    );
  }

  @override
  Widget build(BuildContext context) {
    final AuthController controller = Get.find<AuthController>();

    return WillPopScope(
      onWillPop: () async {
        // Clear loading state when going back
        controller.isLoading.value = false;
        return true;
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFFAF6F1),
        appBar: AppBar(
          elevation: 0,
          backgroundColor: const Color(0xFFE8DCC8),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () {
              controller.isLoading.value = false;
              Get.back();
            },
          ),
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.verified_user,
                  color: Color(0xFF6C63FF),
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'কোড যাচাইকরণ',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 20),

                // Icon
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: const Color(0xFF6C63FF).withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.sms_outlined,
                    color: Color(0xFF6C63FF),
                    size: 64,
                  ),
                ),
                const SizedBox(height: 24),

                // Title
                const Text(
                  'যাচাইকরণ কোড লিখুন',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),

                // Company Name
                if (companyName.isNotEmpty) ...[
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF6C63FF).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      companyName,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF6C63FF),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],

                // Description
                Text(
                  'আপনার ফোন নম্বরে একটি ৪ ডিজিটের কোড পাঠানো হয়েছে',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  phone,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 40),

                // Code Input Fields
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    4,
                        (index) => Container(
                      width: 60,
                      height: 70,
                      margin: const EdgeInsets.symmetric(horizontal: 6),
                      child: TextFormField(
                        controller: codeControllers[index],
                        focusNode: focusNodes[index],
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.number,
                        maxLength: 1,
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                        decoration: InputDecoration(
                          counterText: '',
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: Colors.grey.shade300,
                              width: 2,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: Colors.grey.shade300,
                              width: 2,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                              color: Color(0xFF6C63FF),
                              width: 2.5,
                            ),
                          ),
                          contentPadding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        onChanged: (value) {
                          if (value.isNotEmpty && index < 3) {
                            // Move to next field
                            focusNodes[index + 1].requestFocus();
                          } else if (value.isEmpty && index > 0) {
                            // Move to previous field on backspace
                            focusNodes[index - 1].requestFocus();
                          }

                          // Just unfocus keyboard when done, don't auto-submit
                          if (index == 3 && value.isNotEmpty) {
                            final code = codeControllers.map((c) => c.text).join();
                            if (code.length == 4) {
                              FocusScope.of(context).unfocus();
                            }
                          }
                        },
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 40),

                // Verify Button
                Obx(() => SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: controller.isLoading.value
                        ? null
                        : () {
                      print('🔘 Verify button pressed!');
                      print('   Loading state: ${controller.isLoading.value}');
                      _handleVerification(controller, phone, deviceId, companyId);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF6C63FF),
                      disabledBackgroundColor: const Color(0xFF6C63FF).withOpacity(0.6),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 0,
                    ),
                    child: controller.isLoading.value
                        ? const SizedBox(
                      height: 24,
                      width: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                        : const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.check_circle_outline,
                          color: Colors.white,
                          size: 22,
                        ),
                        SizedBox(width: 8),
                        Text(
                          'যাচাই করুন',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                )),
                const SizedBox(height: 20),

                // Resend Code Button
                Obx(() => TextButton(
                  onPressed: controller.isLoading.value
                      ? null
                      : () {
                    print('🔄 Resending verification code...');
                    controller.resendVerificationCode(phone, deviceId);
                  },
                  child: Text(
                    'কোড পুনরায় পাঠান',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: controller.isLoading.value ? Colors.grey.shade400 : Colors.grey.shade700,
                    ),
                  ),
                )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}