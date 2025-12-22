// lib/features/sales/presentation/controller/sales_entry_controller.dart

import 'dart:async';
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
  final depositController = TextEditingController(); // NEW: Deposit controller

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

  // Repository
  final SalesEntryRepository _repository = SalesEntryRepository();

  // Speech service
  final HybridSpeechService _speechService = HybridSpeechService();
  final currentLocaleId = 'bn-BD';

  // Animation controllers
  late AnimationController pulseController;
  late AnimationController waveController;
  late Animation<double> scaleAnimation;

  // Timer for auto-stop voice input
  Timer? _autoStopTimer;

  final units = [
    // Weight units
    'কেজি',
    'গ্রাম',
    'টন',
    'কুইন্টাল',
    'মণ',
    'সের',
    'ছটাক',
    'পাউন্ড',

    // Volume units
    'লিটার',
    'মিলিলিটার',

    // Count units
    'পিস',
    'ডজন',
    'জোড়া',
    'সেট',

    // Container units
    'প্যাক',
    'বক্স',
    'বোতল',
    'ক্যান',
    'ব্যাগ',
    'বান্ডিল',
    'কার্টন',
    'জার',
    'বস্তা',
    'বালতি',
    'ড্রাম',
    'রোল',
    'শীট',

    // Measurement units
    'গজ',
    'ফুট',
    'ইঞ্চি',
    'মিটার',
    'সেন্টিমিটার',
    'বর্গফুট',
    'বর্গমিটার',

    // Kitchen units
    'কাপ',
    'চামচ',
    'টেবিল চামচ',
    'গ্লাস',
    'প্লেট',
  ];

  // Static unit lists for cleaning product names (initialized once)
  static final List<String> _englishUnitWords = [
    // Weight
    'kg', 'kgs', 'kilogram', 'kilograms', 'kilo', 'kilos',
    'gram', 'grams', 'g', 'gm', 'gms',
    'ton', 'tons', 'tonne', 'tonnes', 'mt',
    'quintal', 'quintals',
    'pound', 'pounds', 'lb', 'lbs',

    // Volume
    'liter', 'liters', 'litre', 'litres', 'l',
    'milliliter', 'milliliters', 'millilitre', 'millilitres', 'ml',

    // Count
    'piece', 'pieces', 'pcs', 'pc',
    'dozen', 'doz',
    'pair', 'pairs',
    'set', 'sets',

    // Container
    'pack', 'packs', 'packet', 'packets', 'package', 'packages',
    'box', 'boxes',
    'bottle', 'bottles', 'btl',
    'can', 'cans', 'tin', 'tins',
    'bag', 'bags', 'sack', 'sacks',
    'bundle', 'bundles', 'bunch', 'bunches',
    'carton', 'cartons',
    'jar', 'jars',
    'bucket', 'buckets', 'pail', 'pails',
    'drum', 'drums', 'barrel', 'barrels',
    'roll', 'rolls',
    'sheet', 'sheets',

    // Measurement
    'yard', 'yards', 'yd', 'yds',
    'foot', 'feet', 'ft',
    'inch', 'inches', 'in',
    'meter', 'meters', 'metre', 'metres', 'm',
    'centimeter', 'centimeters', 'centimetre', 'centimetres', 'cm',
    'square', 'sqft', 'sqm',

    // Kitchen
    'cup', 'cups',
    'spoon', 'spoons', 'teaspoon', 'teaspoons', 'tsp',
    'tablespoon', 'tablespoons', 'tbsp',
    'glass', 'glasses',
    'plate', 'plates',
  ];

  static final List<String> _banglaUnitWords = [
    // Weight
    'কেজি', 'কিলোগ্রাম', 'কিলো', 'কেজিএম',
    'গ্রাম', 'টন', 'মেট্রিক টন',
    'কুইন্টাল', 'মণ', 'মন', 'সের', 'ছটাক', 'পাউন্ড',

    // Volume
    'লিটার', 'মিলিলিটার', 'এমএল',

    // Count
    'পিস', 'টা', 'টি', 'খানা', 'খান',
    'ডজন', 'জোড়া', 'সেট',

    // Container
    'প্যাক', 'প্যাকেট', 'প্যাকেজ',
    'বক্স', 'বাক্স',
    'বোতল', 'ক্যান',
    'ব্যাগ', 'থলে',
    'বান্ডিল', 'বান্ডেল', 'আঁটি',
    'কার্টন', 'জার', 'বস্তা',
    'বালতি', 'ড্রাম', 'রোল', 'শীট',

    // Measurement
    'গজ', 'ফুট', 'ইঞ্চি',
    'মিটার', 'সেন্টিমিটার', 'সেমি',
    'বর্গফুট', 'স্কয়ার ফিট',
    'বর্গমিটার', 'স্কয়ার মিটার',

    // Kitchen
    'কাপ', 'চামচ', 'চা চামচ',
    'টেবিল চামচ', 'টেবিল-চামচ',
    'গ্লাস', 'প্লেট',
  ];

  // Regex patterns (compiled once for performance)
  static late final RegExp _trailingNumberPattern;
  static late final RegExp _englishUnitPattern;
  static late final RegExp _banglaUnitPattern;
  static bool _regexInitialized = false;

  // Static unit mapping for normalization (created once)
  static const Map<String, String> _unitMapping = {
    // Weight - Bangla
    'কিলোগ্রাম': 'কেজি',
    'কিলো': 'কেজি',
    'কেজিএম': 'কেজি',
    'মেট্রিক টন': 'টন',
    'মন': 'মণ',

    // Weight - English
    'kg': 'কেজি',
    'kgs': 'কেজি',
    'kilogram': 'কেজি',
    'kilograms': 'কেজি',
    'kilo': 'কেজি',
    'kilos': 'কেজি',
    'gram': 'গ্রাম',
    'grams': 'গ্রাম',
    'g': 'গ্রাম',
    'gm': 'গ্রাম',
    'gms': 'গ্রাম',
    'ton': 'টন',
    'tons': 'টন',
    'tonne': 'টন',
    'tonnes': 'টন',
    'mt': 'টন',
    'quintal': 'কুইন্টাল',
    'quintals': 'কুইন্টাল',
    'mon': 'মণ',
    'maund': 'মণ',
    'ser': 'সের',
    'seer': 'সের',
    'chhatak': 'ছটাক',
    'chattak': 'ছটাক',
    'pound': 'পাউন্ড',
    'pounds': 'পাউন্ড',
    'lb': 'পাউন্ড',
    'lbs': 'পাউন্ড',

    // Volume - Bangla
    'এমএল': 'মিলিলিটার',

    // Volume - English
    'liter': 'লিটার',
    'liters': 'লিটার',
    'litre': 'লিটার',
    'litres': 'লিটার',
    'l': 'লিটার',
    'milliliter': 'মিলিলিটার',
    'milliliters': 'মিলিলিটার',
    'millilitre': 'মিলিলিটার',
    'millilitres': 'মিলিলিটার',
    'ml': 'মিলিলিটার',

    // Count - Bangla
    'টা': 'পিস',
    'টি': 'পিস',
    'খানা': 'পিস',
    'খান': 'পিস',

    // Count - English
    'piece': 'পিস',
    'pieces': 'পিস',
    'pcs': 'পিস',
    'pc': 'পিস',
    'dozen': 'ডজন',
    'doz': 'ডজন',
    'pair': 'জোড়া',
    'pairs': 'জোড়া',
    'set': 'সেট',
    'sets': 'সেট',

    // Container - Bangla
    'প্যাকেট': 'প্যাক',
    'প্যাকেজ': 'প্যাক',
    'বাক্স': 'বক্স',
    'থলে': 'ব্যাগ',
    'বান্ডেল': 'বান্ডিল',
    'আঁটি': 'বান্ডিল',

    // Container - English
    'pack': 'প্যাক',
    'packs': 'প্যাক',
    'packet': 'প্যাক',
    'packets': 'প্যাক',
    'package': 'প্যাক',
    'packages': 'প্যাক',
    'box': 'বক্স',
    'boxes': 'বক্স',
    'bottle': 'বোতল',
    'bottles': 'বোতল',
    'btl': 'বোতল',
    'can': 'ক্যান',
    'cans': 'ক্যান',
    'tin': 'ক্যান',
    'tins': 'ক্যান',
    'bag': 'ব্যাগ',
    'bags': 'ব্যাগ',
    'sack': 'ব্যাগ',
    'sacks': 'ব্যাগ',
    'bundle': 'বান্ডিল',
    'bundles': 'বান্ডিল',
    'bunch': 'বান্ডিল',
    'bunches': 'বান্ডিল',
    'carton': 'কার্টন',
    'cartons': 'কার্টন',
    'jar': 'জার',
    'jars': 'জার',
    'bosta': 'বস্তা',
    'bucket': 'বালতি',
    'buckets': 'বালতি',
    'pail': 'বালতি',
    'pails': 'বালতি',
    'drum': 'ড্রাম',
    'drums': 'ড্রাম',
    'barrel': 'ড্রাম',
    'barrels': 'ড্রাম',
    'roll': 'রোল',
    'rolls': 'রোল',
    'sheet': 'শীট',
    'sheets': 'শীট',

    // Measurement - Bangla
    'স্কয়ার ফিট': 'বর্গফুট',
    'স্কয়ার মিটার': 'বর্গমিটার',
    'সেমি': 'সেন্টিমিটার',

    // Measurement - English
    'yard': 'গজ',
    'yards': 'গজ',
    'yd': 'গজ',
    'yds': 'গজ',
    'foot': 'ফুট',
    'feet': 'ফুট',
    'ft': 'ফুট',
    'inch': 'ইঞ্চি',
    'inches': 'ইঞ্চি',
    'in': 'ইঞ্চি',
    'meter': 'মিটার',
    'meters': 'মিটার',
    'metre': 'মিটার',
    'metres': 'মিটার',
    'm': 'মিটার',
    'centimeter': 'সেন্টিমিটার',
    'centimeters': 'সেন্টিমিটার',
    'centimetre': 'সেন্টিমিটার',
    'centimetres': 'সেন্টিমিটার',
    'cm': 'সেন্টিমিটার',
    'square foot': 'বর্গফুট',
    'square feet': 'বর্গফুট',
    'sqft': 'বর্গফুট',
    'sq ft': 'বর্গফুট',
    'square meter': 'বর্গমিটার',
    'square metre': 'বর্গমিটার',
    'sqm': 'বর্গমিটার',
    'sq m': 'বর্গমিটার',

    // Kitchen - Bangla
    'চা চামচ': 'চামচ',
    'টেবিল-চামচ': 'টেবিল চামচ',

    // Kitchen - English
    'cup': 'কাপ',
    'cups': 'কাপ',
    'spoon': 'চামচ',
    'spoons': 'চামচ',
    'teaspoon': 'চামচ',
    'teaspoons': 'চামচ',
    'tsp': 'চামচ',
    'tablespoon': 'টেবিল চামচ',
    'tablespoons': 'টেবিল চামচ',
    'tbsp': 'টেবিল চামচ',
    'glass': 'গ্লাস',
    'glasses': 'গ্লাস',
    'plate': 'প্লেট',
    'plates': 'প্লেট',
  };

  // Company and user IDs - loaded from storage
  int? companyId;
  int? userId;

  @override
  void onInit() {
    super.onInit();
    _initializeRegexPatterns();
    _initializeController();
    _initSpeech();
    _initAnimations();
    _onPaidChanged(); // Store reference
    paidController.addListener(_onPaidChanged);
  }

  // Listener callback for proper cleanup
  void _onPaidChanged() => update();

  void _initializeRegexPatterns() {
    if (_regexInitialized) return;

    // Pattern to remove trailing numbers
    _trailingNumberPattern = RegExp(r'\s*\d+\.?\d*\s*$');

    // Create word boundary pattern for English units
    final englishPattern = _englishUnitWords
        .map((unit) => RegExp.escape(unit))
        .join('|');
    _englishUnitPattern = RegExp(
      r'\b(' + englishPattern + r')\b',
      caseSensitive: false,
    );

    // Create pattern for Bangla units
    final banglaPattern = _banglaUnitWords
        .map((unit) => RegExp.escape(unit))
        .join('|');
    _banglaUnitPattern = RegExp(
      r'\s*(' + banglaPattern + r')\s*',
      unicode: true,
    );

    _regexInitialized = true;
  }

  Future<void> _initializeController() async {
    try {
      // Load company ID from storage
      companyId = await StorageService.getCompanyId();

      if (companyId == null) {
        _showErrorSnackbar('কোম্পানি তথ্য পাওয়া যায়নি');
        Get.back(); // Exit immediately
        return;
      }

      // Load parties after getting company ID
      await _loadParties();
    } catch (e) {
      debugPrint('Initialization error: $e');
      _showErrorSnackbar('প্রাথমিক সেটআপে সমস্যা হয়েছে');
    }
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
      _showErrorSnackbar('স্পিচ রিকগনিশন উপলব্ধ নেই');
    }
  }

  Future<void> _loadParties() async {
    try {
      isLoadingParties.value = true;
      final response = await _repository.getAllParties();
      customerList.value = response.data;
    } catch (e) {
      debugPrint('Failed to load parties: $e');
      _showErrorSnackbar('পার্টি লোড করতে সমস্যা হয়েছে। অনুগ্রহ করে আবার চেষ্টা করুন।');
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
      _showErrorSnackbar('গ্রাহকের নাম লিখুন');
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
      _showSuccessSnackbar('গ্রাহক নির্বাচিত: ${existingParty.name}');
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

        _showSuccessSnackbar('নতুন পার্টি যোগ হয়েছে: $partyName');
      }
    } catch (e) {
      debugPrint('Failed to create party: $e');
      _showErrorSnackbar('পার্টি তৈরি করতে সমস্যা হয়েছে। অনুগ্রহ করে আবার চেষ্টা করুন।');
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
        _showErrorSnackbar('স্পিচ এরর: $error');
      },
    );

    // Use timer with proper cleanup
    _autoStopTimer?.cancel();
    _autoStopTimer = Timer(const Duration(seconds: 5), () async {
      if (isListening.value) {
        await _stopListening();
        _handleListeningStop(lastRecognizedText);
      }
    });
  }

  Future<void> _stopListening() async {
    _autoStopTimer?.cancel();
    await _speechService.stopListening();
    isListening.value = false;
    pulseController.stop();
    pulseController.reset();
    waveController.stop();
    waveController.reset();
  }

  void _handleListeningStop(String recognizedText) async {
    if (recognizedText.isEmpty) return;

    print('=== VOICE INPUT DEBUG ===');
    print('Recognized text: $recognizedText');

    // If user is typing customer name, fill the text field
    if (isTypingCustomer.value) {
      customerSearchController.text = recognizedText;
      _showSuccessSnackbar('গ্রাহকের নাম যোগ হয়েছে');
      return;
    }

    // Try to parse as product input first
    final parsedData = VoiceParserProductUpdated.parseFullProductInput(recognizedText);

    print('Parsed product name: ${parsedData['productName']}');
    print('Parsed quantity: ${parsedData['quantity']}');
    print('Parsed unit: ${parsedData['unit']}');
    print('Parsed price: ${parsedData['price']}');

    if (parsedData['productName']?.isNotEmpty ?? false) {
      // It's a product entry
      String productName = _cleanProductName(parsedData['productName']!);
      productController.text = productName;

      // Set quantity
      if (parsedData['quantity']?.isNotEmpty ?? false) {
        quantityController.text = parsedData['quantity']!;
      }

      // Set price
      if (parsedData['price']?.isNotEmpty ?? false) {
        priceController.text = parsedData['price']!;
      }

      // Set unit with proper validation
      String detectedUnit = parsedData['unit'] ?? 'লিটার';
      print('Detected unit before normalization: $detectedUnit');

      String finalUnit = _normalizeUnit(detectedUnit);
      print('Final unit after normalization: $finalUnit');

      if (units.contains(finalUnit)) {
        selectedUnit.value = finalUnit;
        print('✓ Unit successfully set to: ${selectedUnit.value}');
      } else {
        print('⚠ Warning: Unit "$finalUnit" not in list, keeping current: ${selectedUnit.value}');
      }

      // Force UI refresh
      update();

      _showSuccessSnackbar('পণ্যের তথ্য যোগ হয়েছে\n$productName - ${selectedUnit.value}');
    } else {
      // Treat as customer name
      final existingParty = customerList.firstWhereOrNull(
            (party) => party.name.toLowerCase() == recognizedText.toLowerCase(),
      );

      if (existingParty != null) {
        selectedCustomer.value = existingParty;
        _showSuccessSnackbar('গ্রাহক নির্বাচিত: ${existingParty.name}');
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

  /// Normalize unit variations to match the units list
  String _normalizeUnit(String unit) {
    print('Normalizing unit: $unit');

    // Remove whitespace
    String cleaned = unit.trim();

    // If already in the list, return as is
    if (units.contains(cleaned)) {
      print('Unit already in list: $cleaned');
      return cleaned;
    }

    String lowerUnit = cleaned.toLowerCase();

    // Check direct mapping (English - case insensitive)
    if (_unitMapping.containsKey(lowerUnit)) {
      print('Found mapping: $lowerUnit -> ${_unitMapping[lowerUnit]}');
      return _unitMapping[lowerUnit]!;
    }

    // Check Bangla direct match (case-sensitive for Bangla)
    if (_unitMapping.containsKey(cleaned)) {
      print('Found Bangla mapping: $cleaned -> ${_unitMapping[cleaned]}');
      return _unitMapping[cleaned]!;
    }

    // Default fallback
    print('No mapping found, using default: লিটার');
    return 'লিটার';
  }

  /// Clean product name by removing units and numbers
  String _cleanProductName(String productName) {
    if (productName.isEmpty) return '';

    String cleaned = productName.trim();

    // Step 1: Remove trailing numbers
    cleaned = cleaned.replaceAll(_trailingNumberPattern, '');

    // Step 2: Remove English units (case-insensitive, whole words only)
    cleaned = cleaned.replaceAll(_englishUnitPattern, '');

    // Step 3: Remove Bangla units
    cleaned = cleaned.replaceAll(_banglaUnitPattern, ' ');

    // Step 4: Clean up extra whitespace
    cleaned = cleaned.replaceAll(RegExp(r'\s+'), ' ');

    // Step 5: Final trim
    cleaned = cleaned.trim();

    // Return cleaned name, or original if cleaning resulted in empty string
    return cleaned.isEmpty ? productName.trim() : cleaned;
  }

  void addProduct() {
    final product = productController.text.trim();
    final quantity = double.tryParse(quantityController.text) ?? 0;
    final totalPrice = double.tryParse(priceController.text) ?? 0;

    if (product.isEmpty || quantity <= 0 || totalPrice <= 0) {
      _showErrorSnackbar('সব ফিল্ড সঠিকভাবে পূরণ করুন');
      return;
    }

    products.add({
      'productName': product,
      'quantity': quantity,
      'unit': selectedUnit.value,
      'total': totalPrice,
    });

    _calculateTotal();

    productController.clear();
    quantityController.clear();
    priceController.clear();
    selectedUnit.value = 'লিটার';

    _showSuccessSnackbar('$product যোগ হয়েছে', duration: const Duration(seconds: 1));
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

  // NEW: Get deposit amount from deposit controller
  double getDepositAmount() {
    return double.tryParse(depositController.text) ?? 0;
  }

  // UPDATED: Calculate due amount using deposit
  double getDueAmount() {
    return totalAmount.value - getDepositAmount();
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

  // UPDATED: Save sales entry with deposit amount
  Future<void> saveSalesEntry() async {
    if (products.isEmpty) {
      _showErrorSnackbar('অন্তত একটি পণ্য যোগ করুন');
      return;
    }

    // Check if company ID is available
    if (companyId == null) {
      _showErrorSnackbar('কোম্পানি তথ্য পাওয়া যায়নি');
      return;
    }

    try {
      isSaving.value = true;

      // Prepare sales details
      final salesDetails = products.map((product) {
        return {
          'productDescription': '${product['productName']} - ${product['quantity']} ${product['unit']}',
          'amount': product['total'],
          'remarks': '',
        };
      }).toList();

      // Use party ID 0 if no customer selected
      final partyId = selectedCustomer.value?.id ?? 0;
      final partyName = selectedCustomer.value?.name ?? 'Walk-in Customer';

      // Call API with companyId from storage and deposit amount
      final result = await _repository.createSale(
        companyId: companyId!,
        salePartyId: partyId,
        salePartyName: partyName,
        saleNo: _generateSaleNo(),
        saleDate: DateTime.now(),
        totalAmount: totalAmount.value,
        depositAmount: getDepositAmount(), // UPDATED: Use deposit from controller
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
          'paidAmount': getDepositAmount(), // UPDATED: Use deposit amount
          'dueAmount': getDueAmount(),
          'timestamp': DateTime.now(),
        };

        // Show success message and navigate back
        Get.back(result: resultData);

        // Show snackbar after navigation
        _showSuccessSnackbar('বিক্রয় সংরক্ষিত হয়েছে');
      } else {
        // Show retry dialog
        final retry = await Get.dialog<bool>(
          AlertDialog(
            title: const Text('সংরক্ষণ ব্যর্থ'),
            content: const Text('বিক্রয় সংরক্ষণ করা যায়নি। আবার চেষ্টা করবেন?'),
            actions: [
              TextButton(
                onPressed: () => Get.back(result: false),
                child: const Text('না'),
              ),
              ElevatedButton(
                onPressed: () => Get.back(result: true),
                child: const Text('হ্যাঁ'),
              ),
            ],
          ),
        );

        if (retry == true) {
          await saveSalesEntry(); // Retry
        }
      }
    } catch (e) {
      isSaving.value = false;
      debugPrint('Failed to save sales: $e');
      _showErrorSnackbar('বিক্রয় সংরক্ষণে সমস্যা হয়েছে। অনুগ্রহ করে আবার চেষ্টা করুন।');
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

  // Helper methods for snackbars
  void _showSuccessSnackbar(String message, {Duration? duration}) {
    Get.snackbar(
      'সফল',
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green,
      colorText: Colors.white,
      duration: duration ?? const Duration(seconds: 2),
    );
  }

  void _showErrorSnackbar(String message) {
    Get.snackbar(
      'ত্রুটি',
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red,
      colorText: Colors.white,
    );
  }

  @override
  void onClose() {
    // Properly cleanup listeners
    paidController.removeListener(_onPaidChanged);

    // Dispose controllers
    customerSearchController.dispose();
    productController.dispose();
    quantityController.dispose();
    priceController.dispose();
    paidController.dispose();
    depositController.dispose(); // ADDED: Dispose deposit controller

    // Dispose services and timers
    _speechService.dispose();
    _autoStopTimer?.cancel();

    // Dispose animations
    pulseController.dispose();
    waveController.dispose();

    super.onClose();
  }
}