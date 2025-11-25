import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:permission_handler/permission_handler.dart';
import '../../../../core/text parser/voice_parser_product.dart';
import '../../../../core/theme/app_colors.dart';

class AddSalesEntryScreen extends StatefulWidget {
  const AddSalesEntryScreen({super.key});

  @override
  State<AddSalesEntryScreen> createState() => _AddSalesEntryScreenState();
}

class _AddSalesEntryScreenState extends State<AddSalesEntryScreen> {
  // Customer selection
  String? _selectedCustomer;
  final List<String> _customerList = [];
  final TextEditingController _customerSearchController = TextEditingController();

  // Product form controllers
  final TextEditingController _productController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _paidController = TextEditingController();
  String _selectedUnit = 'Kilogram (kg)';

  // Product list
  final List<Map<String, dynamic>> _products = [];
  double _totalAmount = 0.0;

  // Speech to text
  late stt.SpeechToText _speech;
  bool _speechAvailable = false;
  bool _isListeningForCustomer = false;
  bool _isListeningForProduct = false;
  String _currentLocaleId = 'bn-BD';

  final List<String> _units = [
    'Kilogram (kg)',
    'Gram (g)',
    'Liter (L)',
    'Piece',
    'Dozen',
    'Pack',
    'Box',
  ];

  @override
  void initState() {
    super.initState();
    _initSpeech();
    _paidController.addListener(() {
      setState(() {});
    });
  }

  Future<void> _initSpeech() async {
    _speech = stt.SpeechToText();
    _speechAvailable = await _speech.initialize(
      onError: (error) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Speech error: ${error.errorMsg}'),
              backgroundColor: AppColors.error,
            ),
          );
        }
      },
    );
    setState(() {});
  }

  Future<void> _requestMicrophonePermission() async {
    var status = await Permission.microphone.status;
    if (!status.isGranted) {
      status = await Permission.microphone.request();
      if (!status.isGranted && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Microphone permission required'),
            backgroundColor: AppColors.error,
            action: SnackBarAction(
              label: 'Settings',
              textColor: Colors.white,
              onPressed: () => openAppSettings(),
            ),
          ),
        );
      }
    }
  }

  Future<void> _startListeningForCustomer() async {
    await _requestMicrophonePermission();

    if (!_speechAvailable) return;

    setState(() => _isListeningForCustomer = true);

    await _speech.listen(
      onResult: (result) {
        if (result.recognizedWords.isNotEmpty) {
          setState(() {
            _customerSearchController.text = result.recognizedWords;

            // Add to list if not exists
            if (!_customerList.contains(result.recognizedWords)) {
              _customerList.add(result.recognizedWords);
            }
            _selectedCustomer = result.recognizedWords;
          });
        }
      },
      localeId: _currentLocaleId,
      listenMode: stt.ListenMode.confirmation,
      cancelOnError: true,
      partialResults: true,
    );
  }

  Future<void> _stopListeningForCustomer() async {
    await _speech.stop();
    setState(() => _isListeningForCustomer = false);
  }

  Future<void> _toggleListeningForProduct() async {
    if (_isListeningForProduct) {
      await _speech.stop();
      setState(() => _isListeningForProduct = false);
    } else {
      if (_selectedCustomer == null || _selectedCustomer!.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please select a customer first'),
            backgroundColor: AppColors.error,
          ),
        );
        return;
      }

      await _requestMicrophonePermission();
      setState(() => _isListeningForProduct = true);

      await _speech.listen(
        onResult: (result) {
          if (result.recognizedWords.isNotEmpty) {
            // Use VoiceParserProduct to parse the input
            final parsedData = VoiceParserProduct.parseFullProductInput(result.recognizedWords);

            setState(() {
              // ONLY set product name - nothing else
              if (parsedData['productName']?.isNotEmpty ?? false) {
                String productName = parsedData['productName']!;
                // Remove any numbers, units, or extra text
                productName = _cleanProductName(productName);
                _productController.text = productName;

                // Auto-select unit based on product
                String detectedUnit = parsedData['unit'] ?? 'Kilogram (kg)';
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
          }
        },
        localeId: _currentLocaleId,
        listenMode: stt.ListenMode.confirmation,
        cancelOnError: true,
        partialResults: true,
      );
    }
  }

  // Clean product name to remove any numbers, units, or unwanted text
  String _cleanProductName(String productName) {
    String cleaned = productName.trim();

    // Remove any trailing numbers
    cleaned = cleaned.replaceAll(RegExp(r'\s*\d+\.?\d*\s*$'), '');

    // Remove common unit words that might slip through
    final unitWords = ['kg', 'kilo', 'liter', 'litre', 'gram', 'piece', 'dozen', 'pack', 'box'];
    for (var unit in unitWords) {
      cleaned = cleaned.replaceAll(RegExp(r'\s*\b' + unit + r'\b\s*', caseSensitive: false), '');
    }

    // Remove Bangla unit words
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
          content: Text('Please fill all fields correctly'),
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

      // Reset form
      _productController.clear();
      _quantityController.clear();
      _priceController.clear();
      _selectedUnit = 'Kilogram (kg)';
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$product added successfully'),
        backgroundColor: AppColors.success,
        duration: const Duration(seconds: 2),
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
          content: Text('Please add at least one product'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    // Return the sales data to previous screen
    Navigator.pop(context, {
      'customerName': _selectedCustomer,
      'products': _products,
      'totalAmount': _totalAmount,
      'paidAmount': _getPaidAmount(),
      'dueAmount': _getDueAmount(),
      'timestamp': DateTime.now(),
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('New Sales Entry', style: TextStyle(fontWeight: FontWeight.w600)),
        backgroundColor: AppColors.surface,
        actions: [
          if (_products.isNotEmpty)
            TextButton.icon(
              onPressed: _saveSalesEntry,
              icon: const Icon(Icons.check, color: AppColors.success),
              label: const Text('Save', style: TextStyle(color: AppColors.success, fontWeight: FontWeight.bold)),
            ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Customer Selection Section
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surface,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.person, color: AppColors.primary, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        'Customer Name',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                            color: Colors.grey[50],
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.grey[300]!),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: _selectedCustomer,
                              hint: const Text('Select or speak customer name', style: TextStyle(fontSize: 13)),
                              isExpanded: true,
                              items: _customerList.map((customer) {
                                return DropdownMenuItem(
                                  value: customer,
                                  child: Text(customer, style: const TextStyle(fontSize: 13)),
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() => _selectedCustomer = value);
                              },
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Container(
                        decoration: BoxDecoration(
                          color: _isListeningForCustomer ? AppColors.error : AppColors.primary,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: IconButton(
                          onPressed: _speechAvailable
                              ? (_isListeningForCustomer ? _stopListeningForCustomer : _startListeningForCustomer)
                              : null,
                          icon: Icon(
                            _isListeningForCustomer ? Icons.stop : Icons.mic,
                            color: Colors.white,
                            size: 20,
                          ),
                          iconSize: 20,
                          padding: const EdgeInsets.all(8),
                          constraints: const BoxConstraints(),
                        ),
                      ),
                    ],
                  ),
                  if (_isListeningForCustomer)
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(
                        '🎤 Listening for customer name...',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.primary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                ],
              ),
            ),

            // Add Product Form (Compact)
            if (_selectedCustomer != null && _selectedCustomer!.isNotEmpty)
              Container(
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.add_shopping_cart, color: AppColors.primary, size: 18),
                        const SizedBox(width: 8),
                        Text(
                          'Add Product',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const Spacer(),
                        Container(
                          decoration: BoxDecoration(
                            color: _isListeningForProduct ? AppColors.error : AppColors.primary,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: IconButton(
                            onPressed: _speechAvailable ? _toggleListeningForProduct : null,
                            icon: Icon(
                              _isListeningForProduct ? Icons.stop : Icons.mic,
                              color: Colors.white,
                              size: 18,
                            ),
                            iconSize: 18,
                            padding: const EdgeInsets.all(6),
                            constraints: const BoxConstraints(),
                          ),
                        ),
                      ],
                    ),
                    if (_isListeningForProduct)
                      Padding(
                        padding: const EdgeInsets.only(top: 8, bottom: 8),
                        child: Text(
                          '🎤 Listening for product details...',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.primary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _productController,
                      decoration: InputDecoration(
                        labelText: 'Product Name',
                        labelStyle: const TextStyle(fontSize: 12),
                        hintText: 'চাল / Rice',
                        hintStyle: const TextStyle(fontSize: 12),
                        prefixIcon: const Icon(Icons.shopping_basket_outlined, size: 18),
                        contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                        filled: true,
                        fillColor: Colors.grey[50],
                      ),
                      style: const TextStyle(fontSize: 13),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _quantityController,
                            keyboardType: const TextInputType.numberWithOptions(decimal: true),
                            decoration: InputDecoration(
                              labelText: 'Qty',
                              labelStyle: const TextStyle(fontSize: 12),
                              prefixIcon: const Icon(Icons.scale_outlined, size: 18),
                              contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                              filled: true,
                              fillColor: Colors.grey[50],
                            ),
                            style: const TextStyle(fontSize: 13),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            decoration: BoxDecoration(
                              color: Colors.grey[50],
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Colors.grey[300]!),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                value: _selectedUnit,
                                isExpanded: true,
                                items: _units.map((unit) {
                                  return DropdownMenuItem(
                                    value: unit,
                                    child: Text(unit, style: const TextStyle(fontSize: 11)),
                                  );
                                }).toList(),
                                onChanged: (value) => setState(() => _selectedUnit = value!),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _priceController,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      decoration: InputDecoration(
                        labelText: 'Unit Price (৳)',
                        labelStyle: const TextStyle(fontSize: 12),
                        prefixIcon: const Icon(Icons.currency_exchange, size: 18),
                        contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                        filled: true,
                        fillColor: Colors.grey[50],
                      ),
                      style: const TextStyle(fontSize: 13),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: _addProduct,
                        icon: const Icon(Icons.add, size: 18),
                        label: const Text('Add', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

            // Products List
            if (_products.isNotEmpty)
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: List.generate(_products.length, (index) {
                    final product = _products[index];
                    return Column(
                      children: [
                        _FullWidthProductItem(
                          product: product,
                          onDelete: () => _deleteProduct(index),
                        ),
                        if (index < _products.length - 1)
                          Divider(
                            color: Colors.grey[300],
                            height: 0,
                            thickness: 1,
                          ),
                      ],
                    );
                  }),
                ),
              ),

            // Paid Section
            if (_products.isNotEmpty)
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: TextField(
                  controller: _paidController,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  decoration: InputDecoration(
                    labelText: 'Paid (৳)',
                    labelStyle: const TextStyle(fontSize: 12),
                    hintText: '0',
                    prefixIcon: const Icon(Icons.payments, size: 18),
                    contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    filled: true,
                    fillColor: Colors.grey[50],
                  ),
                  style: const TextStyle(fontSize: 13),
                ),
              ),

            // Total and Due Section
            if (_products.isNotEmpty)
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // Total Amount
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Total',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          Text(
                            '৳${_totalAmount.toStringAsFixed(2)}',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Divider(
                      color: Colors.grey[300],
                      height: 0,
                      thickness: 1,
                    ),
                    // Due Amount
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Due',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: _getDueAmount() > 0 ? AppColors.error : AppColors.success,
                            ),
                          ),
                          Text(
                            '৳${_getDueAmount().toStringAsFixed(2)}',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: _getDueAmount() > 0 ? AppColors.error : AppColors.success,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

            const SizedBox(height: 16),
          ],
        ),
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
    _speech.stop();
    super.dispose();
  }
}

// Full Width Product Item Widget
class _FullWidthProductItem extends StatelessWidget {
  final Map<String, dynamic> product;
  final VoidCallback onDelete;

  const _FullWidthProductItem({
    required this.product,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.getLightColor(AppColors.primary),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(Icons.shopping_bag_outlined, color: AppColors.primary, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product['productName'],
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${product['quantity']} ${product['unit']} × ৳${product['price'].toStringAsFixed(2)}',
                  style: TextStyle(
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
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 4),
              GestureDetector(
                onTap: onDelete,
                child: Icon(Icons.delete_outline, color: AppColors.error, size: 18),
              ),
            ],
          ),
        ],
      ),
    );
  }
}