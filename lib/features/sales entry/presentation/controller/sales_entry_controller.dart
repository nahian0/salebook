import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/services/speech_services.dart';
import '../../../../core/services/storage_service.dart';
import '../../../../core/text parser/voice_parser_product_updated.dart';
import '../../data/models/party_model.dart';
import '../../data/repositories/sales_entry_repository.dart';

class SalesEntryController extends GetxController with GetTickerProviderStateMixin {
  // Controllers
  final customerSearchController = TextEditingController();
  final productController = TextEditingController();
  final quantityController = TextEditingController();
  final priceController = TextEditingController();
  final paidController = TextEditingController();

  // Observable state
  final selectedCustomer = Rxn<PartyModel>();
  final customerList = <PartyModel>[].obs;
  final selectedUnit = 'লিটার'.obs;
  final products = <Map<String, dynamic>>[].obs;
  final totalAmount = 0.0.obs;
  final isListening = false.obs;
  final isLoadingParties = false.obs;
  final isSaving = false.obs;
  final isCreatingParty = false.obs;
  final isTypingCustomer = false.obs;

  // Repository - Now using single repository
  final SalesEntryRepository _repository = SalesEntryRepository();

  // Speech service
  final HybridSpeechService _speechService = HybridSpeechService();
  final currentLocaleId = 'bn-BD';

  // Animation controllers
  late AnimationController pulseController;
  late AnimationController waveController;
  late Animation<double> scaleAnimation;

  final units = [
    'কেজি',
    'গ্রাম',
    'লিটার',
    'পিস',
    'ডজন',
    'প্যাক',
    'বক্স',
  ];

  // Company and user IDs - loaded from storage
  int? companyId;
  int? userId;

  @override
  void onInit() {
    super.onInit();
    _initializeController();
    _initSpeech();
    _initAnimations();
    paidController.addListener(() => update());
  }

  Future<void> _initializeController() async {
    // Load company ID and user ID from storage
    companyId = await StorageService.getCompanyId();

    if (companyId == null) {
      Get.snackbar(
        'ত্রুটি',
        'কোম্পানি তথ্য পাওয়া যায়নি',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    // Load parties after getting company ID
    await _loadParties();
  }

  void _initAnimations() {
    pulseController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    waveController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    scaleAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: pulseController, curve: Curves.easeInOut),
    );
  }

  Future<void> _initSpeech() async {
    final initialized = await _speechService.initialize();
    if (!initialized) {
      Get.snackbar(
        'ত্রুটি',
        'স্পিচ রিকগনিশন উপলব্ধ নেই',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> _loadParties() async {
    try {
      isLoadingParties.value = true;
      final response = await _repository.getAllParties();
      customerList.value = response.data;
    } catch (e) {
      Get.snackbar(
        'ত্রুটি',
        'পার্টি লোড করতে সমস্যা হয়েছে: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoadingParties.value = false;
    }
  }

  // Start typing mode for new customer
  void startTypingCustomer() {
    isTypingCustomer.value = true;
    customerSearchController.clear();
  }

  // Cancel typing mode
  void cancelTypingCustomer() {
    isTypingCustomer.value = false;
    customerSearchController.clear();
  }

  // Save typed customer
  Future<void> saveTypedCustomer() async {
    final name = customerSearchController.text.trim();
    if (name.isEmpty) {
      Get.snackbar(
        'ত্রুটি',
        'গ্রাহকের নাম লিখুন',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    // Check if customer already exists
    final existingParty = customerList.firstWhereOrNull(
          (party) => party.name.toLowerCase() == name.toLowerCase(),
    );

    if (existingParty != null) {
      selectedCustomer.value = existingParty;
      isTypingCustomer.value = false;
      customerSearchController.clear();
      Get.snackbar(
        'সফল',
        'গ্রাহক নির্বাচিত: ${existingParty.name}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );
      return;
    }

    // Create new customer
    await createNewParty(name);
    isTypingCustomer.value = false;
    customerSearchController.clear();
  }

  Future<void> createNewParty(String partyName) async {
    try {
      isCreatingParty.value = true;
      final newParty = await _repository.createParty(partyName);

      if (newParty != null) {
        await _loadParties();
        selectedCustomer.value = customerList.firstWhere(
              (party) => party.name == partyName,
          orElse: () => newParty,
        );

        Get.snackbar(
          'সফল',
          'নতুন পার্টি যোগ হয়েছে: $partyName',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: const Duration(seconds: 2),
        );
      }
    } catch (e) {
      Get.snackbar(
        'ত্রুটি',
        'পার্টি তৈরি করতে সমস্যা হয়েছে: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isCreatingParty.value = false;
    }
  }

  Future<void> toggleVoiceInput() async {
    if (isListening.value) {
      await _stopListening();
    } else {
      await _startListening();
    }
  }

  Future<void> _startListening() async {
    if (_speechService.isListening) return;

    isListening.value = true;
    pulseController.repeat(reverse: true);
    waveController.repeat();

    String lastRecognizedText = '';

    await _speechService.startListening(
      languageCode: currentLocaleId,
      onResult: (text) {
        if (text.isNotEmpty) {
          lastRecognizedText = text;
        }
      },
      onError: (error) {
        _handleListeningStop(lastRecognizedText);
        Get.snackbar(
          'ত্রুটি',
          'স্পিচ এরর: $error',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      },
    );

    Future.delayed(const Duration(seconds: 5), () async {
      if (isListening.value) {
        await _stopListening();
        _handleListeningStop(lastRecognizedText);
      }
    });
  }

  Future<void> _stopListening() async {
    await _speechService.stopListening();
    isListening.value = false;
    pulseController.stop();
    pulseController.reset();
    waveController.stop();
    waveController.reset();
  }

  void _handleListeningStop(String recognizedText) async {
    if (recognizedText.isEmpty) return;

    // If user is typing customer name, fill the text field
    if (isTypingCustomer.value) {
      customerSearchController.text = recognizedText;
      Get.snackbar(
        'সফল',
        'গ্রাহকের নাম যোগ হয়েছে',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );
      return;
    }

    // Try to parse as product input first
    final parsedData = VoiceParserProductUpdated.parseFullProductInput(recognizedText);

    if (parsedData['productName']?.isNotEmpty ?? false) {
      // It's a product entry
      String productName = _cleanProductName(parsedData['productName']!);
      productController.text = productName;

      String detectedUnit = parsedData['unit'] ?? 'লিটার';
      if (units.contains(detectedUnit)) {
        selectedUnit.value = detectedUnit;
      }

      if (parsedData['quantity']?.isNotEmpty ?? false) {
        quantityController.text = parsedData['quantity']!;
      }

      if (parsedData['price']?.isNotEmpty ?? false) {
        priceController.text = parsedData['price']!;
      }

      Get.snackbar(
        'সফল',
        'পণ্যের তথ্য যোগ হয়েছে',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );
    } else {
      // Treat as customer name
      final existingParty = customerList.firstWhereOrNull(
            (party) => party.name.toLowerCase() == recognizedText.toLowerCase(),
      );

      if (existingParty != null) {
        selectedCustomer.value = existingParty;
        Get.snackbar(
          'সফল',
          'গ্রাহক নির্বাচিত: ${existingParty.name}',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: const Duration(seconds: 2),
        );
      } else {
        // Ask if user wants to create new customer
        Get.defaultDialog(
          title: 'নতুন গ্রাহক?',
          middleText: 'গ্রাহক "$recognizedText" তৈরি করতে চান?',
          textConfirm: 'হ্যাঁ',
          textCancel: 'না',
          confirmTextColor: Colors.white,
          onConfirm: () async {
            Get.back();
            await createNewParty(recognizedText);
          },
          onCancel: () {},
        );
      }
    }
  }

  String _cleanProductName(String productName) {
    String cleaned = productName.trim();
    cleaned = cleaned.replaceAll(RegExp(r'\s*\d+\.?\d*\s*$'), '');

    final unitWords = ['kg', 'kilo', 'liter', 'litre', 'gram', 'piece', 'dozen', 'pack', 'box'];
    for (var unit in unitWords) {
      cleaned = cleaned.replaceAll(RegExp(r'\s*\b' + unit + r'\b\s*', caseSensitive: false), '');
    }

    final banglaUnits = ['কেজি', 'কিলো', 'লিটার', 'গ্রাম', 'টা', 'টি', 'ডজন'];
    for (var unit in banglaUnits) {
      cleaned = cleaned.replaceAll(RegExp(r'\s*' + unit + r'\s*', unicode: true), '');
    }

    return cleaned.trim();
  }

  void addProduct() {
    final product = productController.text.trim();
    final quantity = double.tryParse(quantityController.text) ?? 0;
    final price = double.tryParse(priceController.text) ?? 0;

    if (product.isEmpty || quantity <= 0 || price <= 0) {
      Get.snackbar(
        'ত্রুটি',
        'সব ফিল্ড সঠিকভাবে পূরণ করুন',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    products.add({
      'productName': product,
      'quantity': quantity,
      'unit': selectedUnit.value,
      'price': price,
      'total': quantity * price,
    });

    _calculateTotal();

    productController.clear();
    quantityController.clear();
    priceController.clear();
    selectedUnit.value = 'লিটার';

    Get.snackbar(
      'সফল',
      '$product যোগ হয়েছে',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green,
      colorText: Colors.white,
      duration: const Duration(seconds: 1),
    );
  }

  void _calculateTotal() {
    totalAmount.value = products.fold(0.0, (sum, item) => sum + (item['total'] as double));
  }

  void deleteProduct(int index) {
    products.removeAt(index);
    _calculateTotal();
  }

  double getPaidAmount() {
    return double.tryParse(paidController.text) ?? 0;
  }

  double getDueAmount() {
    return totalAmount.value - getPaidAmount();
  }

  void clearCustomer() {
    selectedCustomer.value = null;
    customerSearchController.clear();
    isTypingCustomer.value = false;
  }

  String _generateSaleNo() {
    final now = DateTime.now();
    return 'SAL${now.year}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}${now.hour.toString().padLeft(2, '0')}${now.minute.toString().padLeft(2, '0')}${now.second.toString().padLeft(2, '0')}';
  }

  Future<void> saveSalesEntry() async {
    if (products.isEmpty) {
      Get.snackbar(
        'ত্রুটি',
        'অন্তত একটি পণ্য যোগ করুন',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    // Check if company ID is available
    if (companyId == null) {
      Get.snackbar(
        'ত্রুটি',
        'কোম্পানি তথ্য পাওয়া যায়নি',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    try {
      isSaving.value = true;

      // Prepare sales details
      final salesDetails = products.map((product) {
        return {
          'productDescription': '${product['productName']} - ${product['quantity']} ${product['unit']} @ ${product['price']}',
          'amount': product['total'],
          'remarks': '',
        };
      }).toList();

      // Use party ID 0 if no customer selected
      final partyId = selectedCustomer.value?.id ?? 0;
      final partyName = selectedCustomer.value?.name ?? 'Walk-in Customer';

      // Call API with companyId from storage
      final result = await _repository.createSale(
        companyId: companyId!,
        salePartyId: partyId,
        salePartyName: partyName,
        saleNo: _generateSaleNo(),
        saleDate: DateTime.now(),
        totalAmount: totalAmount.value,
        depositAmount: getPaidAmount(),
        salesDetails: salesDetails,
        remarks: '',
      );

      // Hide loading immediately after API call
      isSaving.value = false;

      if (result['success'] == true) {
        // Prepare result data
        final resultData = {
          'success': true,
          'customerId': partyId,
          'customerName': partyName,
          'products': products.toList(),
          'totalAmount': totalAmount.value,
          'paidAmount': getPaidAmount(),
          'dueAmount': getDueAmount(),
          'timestamp': DateTime.now(),
        };

        // Show success message and navigate back
        Get.back(result: resultData);

        // Show snackbar after navigation
        Get.snackbar(
          'সফল',
          'বিক্রয় সংরক্ষিত হয়েছে',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: const Duration(seconds: 2),
        );
      } else {
        Get.snackbar(
          'ত্রুটি',
          'বিক্রয় সংরক্ষণ ব্যর্থ হয়েছে',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      isSaving.value = false;

      Get.snackbar(
        'ত্রুটি',
        'বিক্রয় সংরক্ষণে সমস্যা হয়েছে: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
    }
  }

  String getListeningPrompt() {
    if (isTypingCustomer.value) {
      return 'গ্রাহকের নাম বলুন...';
    }
    return 'গ্রাহক বা পণ্যের তথ্য বলুন...';
  }

  String getVoiceHintText() {
    if (isTypingCustomer.value) {
      return 'গ্রাহকের নাম বলতে চাপুন';
    }
    return 'গ্রাহক বা পণ্য যোগ করতে চাপুন';
  }

  @override
  void onClose() {
    customerSearchController.dispose();
    productController.dispose();
    quantityController.dispose();
    priceController.dispose();
    paidController.dispose();
    _speechService.dispose();
    pulseController.dispose();
    waveController.dispose();
    super.onClose();
  }
}