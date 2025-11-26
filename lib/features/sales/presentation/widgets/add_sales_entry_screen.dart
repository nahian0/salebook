import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/services/speech_services.dart';
import '../../../../core/text parser/voice_parser_product_updated.dart';
import '../../../../core/theme/app_colors.dart';

class AddSalesEntryScreen extends StatefulWidget {
  const AddSalesEntryScreen({super.key});

  @override
  State<AddSalesEntryScreen> createState() => _AddSalesEntryScreenState();
}

class _AddSalesEntryScreenState extends State<AddSalesEntryScreen> with TickerProviderStateMixin {
  // Customer selection
  String? _selectedCustomer;
  final List<String> _customerList = [];
  final TextEditingController _customerSearchController = TextEditingController();

  // Product form controllers
  final TextEditingController _productController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _paidController = TextEditingController();
  String _selectedUnit = 'লিটার';

  // Product list
  final List<Map<String, dynamic>> _products = [];
  double _totalAmount = 0.0;

  // Unified Speech Service
  final HybridSpeechService _speechService = HybridSpeechService();
  bool _isListening = false;
  String _currentLocaleId = 'bn-BD';
  SpeechProvider? _activeSpeechProvider;

  // Animation controllers
  late AnimationController _pulseController;
  late AnimationController _waveController;
  late Animation<double> _scaleAnimation;

  final List<String> _units = [
    'কেজি',
    'গ্রাম',
    'লিটার',
    'পিস',
    'ডজন',
    'প্যাক',
    'বক্স',
  ];

  @override
  void initState() {
    super.initState();
    _initSpeech();
    _initAnimations();
    _paidController.addListener(() {
      setState(() {});
    });
  }

  void _initAnimations() {
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _waveController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  Future<void> _initSpeech() async {
    final initialized = await _speechService.initialize();
    if (mounted) {
      if (!initialized) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('স্পিচ রিকগনিশন উপলব্ধ নেই'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  Future<void> _toggleVoiceInput() async {
    if (_isListening) {
      await _stopListening();
    } else {
      await _startListening();
    }
  }

  Future<void> _startListening() async {
    if (_speechService.isListening) return;

    setState(() => _isListening = true);
    _pulseController.repeat(reverse: true);
    _waveController.repeat();

    String lastRecognizedText = '';
    bool hasCustomer = _selectedCustomer != null && _selectedCustomer!.isNotEmpty;

    await _speechService.startListening(
      languageCode: _currentLocaleId,
      onResult: (text) {
        if (text.isNotEmpty) {
          lastRecognizedText = text;
          _activeSpeechProvider = _speechService.currentProvider;
        }
      },
      onError: (error) {
        _handleListeningStop(lastRecognizedText, hasCustomer);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('স্পিচ এরর: $error'),
              backgroundColor: AppColors.error,
            ),
          );
        }
      },
    );

    // Auto-stop after 5 seconds of listening
    Future.delayed(const Duration(seconds: 5), () async {
      if (_isListening) {
        await _stopListening();
        _handleListeningStop(lastRecognizedText, hasCustomer);
      }
    });
  }

  Future<void> _stopListening() async {
    await _speechService.stopListening();
    setState(() => _isListening = false);
    _pulseController.stop();
    _pulseController.reset();
    _waveController.stop();
    _waveController.reset();
  }

  void _handleListeningStop(String recognizedText, bool hadCustomer) {
    if (recognizedText.isEmpty) return;

    if (!hadCustomer) {
      // Process as customer name
      setState(() {
        _customerSearchController.text = recognizedText;
        if (!_customerList.contains(recognizedText)) {
          _customerList.add(recognizedText);
        }
        _selectedCustomer = recognizedText;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('গ্রাহক যোগ হয়েছে: $recognizedText'),
          backgroundColor: AppColors.success,
          duration: const Duration(seconds: 2),
        ),
      );
    } else {
      // Process as product input
      final parsedData = VoiceParserProductUpdated.parseFullProductInput(recognizedText);

      setState(() {
        if (parsedData['productName']?.isNotEmpty ?? false) {
          String productName = parsedData['productName']!;
          productName = _cleanProductName(productName);
          _productController.text = productName;

          String detectedUnit = parsedData['unit'] ?? 'লিটার';
          if (_units.contains(detectedUnit)) {
            _selectedUnit = detectedUnit;
          }
        }

        if (parsedData['quantity']?.isNotEmpty ?? false) {
          _quantityController.text = parsedData['quantity']!;
        }

        if (parsedData['price']?.isNotEmpty ?? false) {
          _priceController.text = parsedData['price']!;
        }
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('পণ্যের তথ্য যোগ হয়েছে'),
          backgroundColor: AppColors.success,
          duration: const Duration(seconds: 2),
        ),
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

  void _addProduct() {
    final product = _productController.text.trim();
    final quantity = double.tryParse(_quantityController.text) ?? 0;
    final price = double.tryParse(_priceController.text) ?? 0;

    if (product.isEmpty || quantity <= 0 || price <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('সব ফিল্ড সঠিকভাবে পূরণ করুন'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    setState(() {
      _products.add({
        'productName': product,
        'quantity': quantity,
        'unit': _selectedUnit,
        'price': price,
        'total': quantity * price,
      });
      _calculateTotal();

      _productController.clear();
      _quantityController.clear();
      _priceController.clear();
      _selectedUnit = 'লিটার';
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$product যোগ হয়েছে'),
        backgroundColor: AppColors.success,
        duration: const Duration(seconds: 1),
      ),
    );
  }

  void _calculateTotal() {
    _totalAmount = _products.fold(0.0, (sum, item) => sum + (item['total'] as double));
  }

  void _deleteProduct(int index) {
    setState(() {
      _products.removeAt(index);
      _calculateTotal();
    });
  }

  double _getPaidAmount() {
    return double.tryParse(_paidController.text) ?? 0;
  }

  double _getDueAmount() {
    return _totalAmount - _getPaidAmount();
  }

  void _saveSalesEntry() {
    if (_selectedCustomer == null || _products.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('অন্তত একটি পণ্য যোগ করুন'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    Navigator.pop(context, {
      'customerName': _selectedCustomer,
      'products': _products,
      'totalAmount': _totalAmount,
      'paidAmount': _getPaidAmount(),
      'dueAmount': _getDueAmount(),
      'timestamp': DateTime.now(),
    });
  }

  String _getListeningPrompt() {
    if (_selectedCustomer == null || _selectedCustomer!.isEmpty) {
      return 'গ্রাহকের নাম বলুন...';
    } else {
      return 'পণ্যের তথ্য বলুন...';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'নতুন প্রোডাক্ট',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: AppColors.appBarBackground,
        elevation: 0,
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.only(bottom: 180),
                  child: Column(
                    children: [
                      const SizedBox(height: 16),

                      // Customer Input
                      _buildCustomerSection(),

                      const SizedBox(height: 16),

                      // Products List (moved before product form)
                      if (_products.isNotEmpty)
                        _buildProductsList(),

                      if (_products.isNotEmpty)
                        const SizedBox(height: 16),

                      // Product Input Form
                      if (_selectedCustomer != null && _selectedCustomer!.isNotEmpty)
                        _buildProductForm(),

                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
            ],
          ),

          // Bottom Voice Button and Status
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: _buildBottomVoiceSection(),
          ),
        ],
      ),
      floatingActionButton: _products.isNotEmpty && !_isListening
          ? FloatingActionButton.extended(
        onPressed: _saveSalesEntry,
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.check, color: Colors.white),
        label: const Text(
          'নিশ্চিত',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Widget _buildCustomerSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'গ্রাহকের নাম',
                style: TextStyle(
                  fontSize: 13,
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              if (_selectedCustomer != null && _selectedCustomer!.isNotEmpty)
                TextButton.icon(
                  onPressed: () {
                    setState(() {
                      _selectedCustomer = null;
                      _customerSearchController.clear();
                    });
                  },
                  icon: const Icon(Icons.edit, size: 16, color: AppColors.primary),
                  label: const Text(
                    'পরিবর্তন',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            height: 48,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.borderLight),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _selectedCustomer,
                hint: const Text(
                  'নাম লিখুন বা ভয়েস বাটন চাপুন',
                  style: TextStyle(fontSize: 14, color: AppColors.textTertiary),
                ),
                isExpanded: true,
                items: _customerList.map((customer) {
                  return DropdownMenuItem(
                    value: customer,
                    child: Text(
                      customer,
                      style: const TextStyle(fontSize: 14, color: AppColors.textPrimary),
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() => _selectedCustomer = value);
                },
                icon: const Icon(Icons.arrow_drop_down, color: AppColors.textSecondary),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductForm() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'পণ্যের তথ্য',
            style: TextStyle(
              fontSize: 13,
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 12),

          // Product Name
          TextField(
            controller: _productController,
            decoration: InputDecoration(
              labelText: 'প্রোডাক্টের নাম',
              labelStyle: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
              hintText: 'যেমন: দুধ',
              hintStyle: const TextStyle(fontSize: 13, color: AppColors.textTertiary),
              filled: true,
              fillColor: AppColors.background,
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: AppColors.borderLight),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: AppColors.borderLight),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: AppColors.primary, width: 2),
              ),
            ),
            style: const TextStyle(fontSize: 14),
          ),
          const SizedBox(height: 12),

          // Quantity and Unit Row
          Row(
            children: [
              Expanded(
                flex: 2,
                child: TextField(
                  controller: _quantityController,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  decoration: InputDecoration(
                    labelText: 'পরিমাণ',
                    labelStyle: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
                    filled: true,
                    fillColor: AppColors.background,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: AppColors.borderLight),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: AppColors.borderLight),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: AppColors.primary, width: 2),
                    ),
                  ),
                  style: const TextStyle(fontSize: 14),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 2,
                child: Container(
                  height: 48,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.borderLight),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: _selectedUnit,
                      isExpanded: true,
                      items: _units.map((unit) {
                        return DropdownMenuItem(
                          value: unit,
                          child: Text(
                            unit,
                            style: const TextStyle(fontSize: 13, color: AppColors.textPrimary),
                          ),
                        );
                      }).toList(),
                      onChanged: (value) => setState(() => _selectedUnit = value!),
                      icon: const Icon(Icons.arrow_drop_down, color: AppColors.textSecondary, size: 20),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Price
          TextField(
            controller: _priceController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(
              labelText: 'প্রতি ইউনিট মূল্য (৳)',
              labelStyle: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
              filled: true,
              fillColor: AppColors.background,
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: AppColors.borderLight),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: AppColors.borderLight),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: AppColors.primary, width: 2),
              ),
            ),
            style: const TextStyle(fontSize: 14),
          ),
          const SizedBox(height: 16),

          // Add Button
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: _addProduct,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 0,
              ),
              child: const Text(
                'যোগ করুন',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomVoiceSection() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Listening Status
            if (_isListening)
              Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Column(
                  children: [
                    _buildWaveAnimation(),
                    const SizedBox(height: 8),
                    Text(
                      _getListeningPrompt(),
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),

            // Voice Button
            Padding(
              padding: const EdgeInsets.all(20),
              child: GestureDetector(
                onTap: _toggleVoiceInput,
                child: AnimatedBuilder(
                  animation: _scaleAnimation,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _isListening ? _scaleAnimation.value : 1.0,
                      child: Container(
                        width: 72,
                        height: 72,
                        decoration: BoxDecoration(
                          color: _isListening ? AppColors.error : AppColors.primary,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: (_isListening ? AppColors.error : AppColors.primary).withOpacity(0.3),
                              blurRadius: 20,
                              spreadRadius: _isListening ? 8 : 4,
                            ),
                          ],
                        ),
                        child: Icon(
                          _isListening ? Icons.stop_rounded : Icons.mic_rounded,
                          color: Colors.white,
                          size: 36,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),

            // Hint Text
            if (!_isListening)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Text(
                  _selectedCustomer == null || _selectedCustomer!.isEmpty
                      ? 'গ্রাহকের নাম বলতে চাপুন'
                      : 'পণ্য যোগ করতে চাপুন',
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildWaveAnimation() {
    return SizedBox(
      width: 80,
      height: 40,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(5, (index) {
          return AnimatedBuilder(
            animation: _waveController,
            builder: (context, child) {
              final double value = (_waveController.value + (index * 0.15)) % 1.0;
              final double height = 8 + (24 * (0.5 + 0.5 * (value < 0.5 ? value * 2 : (1 - value) * 2)));
              return Container(
                width: 4,
                height: height,
                margin: const EdgeInsets.symmetric(horizontal: 3),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(4),
                ),
              );
            },
          );
        }),
      ),
    );
  }

  Widget _buildProductsList() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              'প্রোডাক্ট (${_products.length})',
              style: const TextStyle(
                fontSize: 13,
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _products.length,
            separatorBuilder: (context, index) => Divider(
              height: 1,
              color: AppColors.borderLight,
              indent: 16,
              endIndent: 16,
            ),
            itemBuilder: (context, index) {
              final product = _products[index];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: AppColors.primaryLight,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: Text(
                          '${index + 1}',
                          style: const TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            product['productName'],
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${product['quantity']} ${product['unit']} × ৳${product['price'].toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '৳${product['total'].toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 6),
                        GestureDetector(
                          onTap: () => _deleteProduct(index),
                          child: const Icon(
                            Icons.delete_outline,
                            color: AppColors.error,
                            size: 20,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _customerSearchController.dispose();
    _productController.dispose();
    _quantityController.dispose();
    _priceController.dispose();
    _paidController.dispose();
    _speechService.dispose();
    _pulseController.dispose();
    _waveController.dispose();
    super.dispose();
  }
}