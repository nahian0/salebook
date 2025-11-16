import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import '../../../../core/text parser/voice_parser_sales.dart';
import '../../../../core/theme/app_colors.dart';

class AddSalesDialog extends StatefulWidget {
  final stt.SpeechToText speech;
  final bool speechAvailable;
  final String localeId;
  final Future<void> Function() onRequestPermission;
  final void Function(String customerName, String productName, double quantity,
      String unit, double totalPrice) onAddSales;

  const AddSalesDialog({
    super.key,
    required this.speech,
    required this.speechAvailable,
    required this.localeId,
    required this.onRequestPermission,
    required this.onAddSales,
  });

  @override
  State<AddSalesDialog> createState() => _AddSalesDialogState();
}

class _AddSalesDialogState extends State<AddSalesDialog> {
  final TextEditingController _customerController = TextEditingController();
  final TextEditingController _productController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();

  String _selectedUnit = 'Kilogram (kg)';
  bool _isListening = false;
  String _voiceTranscript = '';

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
  }

  Future<void> _toggleListening() async {
    if (_isListening) {
      await _stopListening();
    } else {
      await _startListening();
    }
  }

  Future<void> _startListening() async {
    await widget.onRequestPermission();

    if (!widget.speechAvailable) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Speech recognition not available'),
            backgroundColor: AppColors.error,
          ),
        );
      }
      return;
    }

    setState(() {
      _isListening = true;
      _voiceTranscript = 'Listening...';
    });

    await widget.speech.listen(
      onResult: (result) {
        setState(() {
          _voiceTranscript = result.recognizedWords;

          if (result.recognizedWords.isNotEmpty) {
            final parsed = VoiceParserSales.parseSalesInput(result.recognizedWords);

            _customerController.text = parsed['customerName'];
            _productController.text = parsed['productName'];
            _quantityController.text = parsed['quantity'].toString();
            _selectedUnit = parsed['unit'];
            _priceController.text = parsed['totalPrice'].toString();
          }
        });
      },
      localeId: widget.localeId,
      listenMode: stt.ListenMode.confirmation,
      cancelOnError: true,
      partialResults: true,
    );
  }

  Future<void> _stopListening() async {
    await widget.speech.stop();
    setState(() {
      _isListening = false;
      if (_voiceTranscript == 'Listening...') {
        _voiceTranscript = '';
      }
    });
  }

  void _handleAdd() {
    String customerName = _customerController.text.trim();
    String productName = _productController.text.trim();
    String quantityStr = _quantityController.text.trim();
    String priceStr = _priceController.text.trim();

    if (customerName.isEmpty) {
      _showError('Please enter customer name');
      return;
    }

    if (productName.isEmpty) {
      _showError('Please enter product name');
      return;
    }

    double quantity = double.tryParse(quantityStr) ?? 0;
    if (quantity <= 0) {
      _showError('Please enter valid quantity');
      return;
    }

    double totalPrice = double.tryParse(priceStr) ?? 0;
    if (totalPrice <= 0) {
      _showError('Please enter valid price');
      return;
    }

    if (_isListening) {
      widget.speech.stop();
    }

    widget.onAddSales(customerName, productName, quantity, _selectedUnit, totalPrice);
    Navigator.pop(context);
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.error,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Dialog(
      insetPadding: const EdgeInsets.all(16),
      backgroundColor: Colors.transparent,
      child: Container(
        width: size.width,
        height: size.height * 0.9,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.point_of_sale, color: Colors.white, size: 28),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                      'Add Sales Entry',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white),
                    onPressed: () {
                      if (_isListening) widget.speech.stop();
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ),

            // Form Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Customer Name
                    _buildTextField(
                      controller: _customerController,
                      label: 'Customer Name',
                      hint: 'Enter Name',
                      icon: Icons.person_outline,
                    ),

                    const SizedBox(height: 20),

                    // Product Name
                    _buildTextField(
                      controller: _productController,
                      label: 'Product Name',
                      hint: 'চাল / Rice',
                      icon: Icons.shopping_basket_outlined,
                    ),

                    const SizedBox(height: 20),

                    // Quantity and Unit
                    Row(
                      children: [
                        Expanded(
                          child: _buildTextField(
                            controller: _quantityController,
                            label: 'Quantity',
                            hint: 'Enter Quantity',
                            icon: Icons.scale_outlined,
                            keyboardType: const TextInputType.numberWithOptions(decimal: true),
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Unit',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 16),
                                height: 56,
                                decoration: BoxDecoration(
                                  color: Colors.grey[50],
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: Colors.grey[300]!),
                                ),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton<String>(
                                    value: _selectedUnit,
                                    isExpanded: true,
                                    items: _units.map((unit) {
                                      return DropdownMenuItem(
                                        value: unit,
                                        child: Text(unit, style: const TextStyle(fontSize: 15)),
                                      );
                                    }).toList(),
                                    onChanged: (value) {
                                      if (value != null) {
                                        setState(() => _selectedUnit = value);
                                      }
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // Total Price
                    _buildTextField(
                      controller: _priceController,
                      label: 'Total Price (৳)',
                      hint: 'Enter Price',
                      icon: Icons.currency_exchange_outlined,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // Add Button
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton.icon(
                        onPressed: _handleAdd,
                        icon: const Icon(Icons.check_circle_outline, size: 24),
                        label: const Text(
                          'Add Sale',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.success,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Voice Input Section (Bottom)
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: _isListening
                    ? AppColors.getLightColor(AppColors.primary)
                    : Colors.grey[100],
                border: Border(
                  top: BorderSide(color: Colors.grey[300]!, width: 1),
                ),
              ),
              child: Column(
                children: [
                  if (_voiceTranscript.isNotEmpty && _isListening)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.primary, width: 2),
                      ),
                      child: Text(
                        _voiceTranscript,
                        style: TextStyle(
                          fontSize: 15,
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: _isListening ? AppColors.primary : Colors.grey[300],
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          _isListening ? Icons.mic : Icons.mic_off,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _isListening ? 'Listening...' : 'Voice Input',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: _isListening ? AppColors.primary : AppColors.textPrimary,
                              ),
                            ),
                            Text(
                              _isListening
                                  ? 'Speak now in Bangla or English'
                                  : 'Say: "নাহিয়ান চাল ১০ কেজি ১০০ টাকা"',
                              style: TextStyle(
                                fontSize: 13,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      SizedBox(
                        height: 56,
                        child: ElevatedButton.icon(
                          onPressed: widget.speechAvailable ? _toggleListening : null,
                          icon: Icon(_isListening ? Icons.stop : Icons.mic, size: 22),
                          label: Text(
                            _isListening ? 'Stop' : 'Start',
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _isListening ? AppColors.error : AppColors.primary,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 24),
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          inputFormatters: inputFormatters,
          style: const TextStyle(fontSize: 16),
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(icon, color: AppColors.textSecondary, size: 22),
            filled: true,
            fillColor: Colors.grey[50],
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColors.primary, width: 2),
            ),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _customerController.dispose();
    _productController.dispose();
    _quantityController.dispose();
    _priceController.dispose();
    if (_isListening) {
      widget.speech.stop();
    }
    super.dispose();
  }
}