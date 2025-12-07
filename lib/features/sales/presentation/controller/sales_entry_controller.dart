import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/services/speech_services.dart';
import '../../../../core/text parser/voice_parser_product_updated.dart';
import '../../data/model/party_model.dart';
import '../../data/repository/party_repository.dart';

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

  // Repository
  final PartyRepository _partyRepository = PartyRepository();

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

  @override
  void onInit() {
    super.onInit();
    _initSpeech();
    _initAnimations();
    _loadParties();
    paidController.addListener(() => update());
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
      final response = await _partyRepository.getAllParties();
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

  Future<void> createNewParty(String partyName) async {
    try {
      isLoadingParties.value = true;
      final newParty = await _partyRepository.createParty(partyName);

      if (newParty != null) {
        // Reload parties to get the updated list
        await _loadParties();

        // Select the newly created party
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
      isLoadingParties.value = false;
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
    bool hasCustomer = selectedCustomer.value != null;

    await _speechService.startListening(
      languageCode: currentLocaleId,
      onResult: (text) {
        if (text.isNotEmpty) {
          lastRecognizedText = text;
        }
      },
      onError: (error) {
        _handleListeningStop(lastRecognizedText, hasCustomer);
        Get.snackbar(
          'ত্রুটি',
          'স্পিচ এরর: $error',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      },
    );

    // Auto-stop after 5 seconds
    Future.delayed(const Duration(seconds: 5), () async {
      if (isListening.value) {
        await _stopListening();
        _handleListeningStop(lastRecognizedText, hasCustomer);
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

  void _handleListeningStop(String recognizedText, bool hadCustomer) async {
    if (recognizedText.isEmpty) return;

    if (!hadCustomer) {
      // Process as customer name - check if exists or create new
      customerSearchController.text = recognizedText;

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
        // Create new party
        await createNewParty(recognizedText);
      }
    } else {
      // Process as product input
      final parsedData = VoiceParserProductUpdated.parseFullProductInput(recognizedText);

      if (parsedData['productName']?.isNotEmpty ?? false) {
        String productName = _cleanProductName(parsedData['productName']!);
        productController.text = productName;

        String detectedUnit = parsedData['unit'] ?? 'লিটার';
        if (units.contains(detectedUnit)) {
          selectedUnit.value = detectedUnit;
        }
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

    // Clear form
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
  }

  void saveSalesEntry() {
    if (selectedCustomer.value == null || products.isEmpty) {
      Get.snackbar(
        'ত্রুটি',
        'অন্তত একটি পণ্য যোগ করুন',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    Get.back(result: {
      'customerId': selectedCustomer.value!.id,
      'customerName': selectedCustomer.value!.name,
      'products': products.toList(),
      'totalAmount': totalAmount.value,
      'paidAmount': getPaidAmount(),
      'dueAmount': getDueAmount(),
      'timestamp': DateTime.now(),
    });
  }

  String getListeningPrompt() {
    if (selectedCustomer.value == null) {
      return 'গ্রাহকের নাম বলুন...';
    } else {
      return 'পণ্যের তথ্য বলুন...';
    }
  }

  String getVoiceHintText() {
    if (selectedCustomer.value == null) {
      return 'গ্রাহকের নাম বলতে চাপুন';
    } else {
      return 'পণ্য যোগ করতে চাপুন';
    }
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