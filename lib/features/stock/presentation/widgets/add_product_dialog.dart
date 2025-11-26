import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import '../../../../core/text parser/voice_parser_product_updated.dart';
import '../../../../core/theme/app_colors.dart';

class AddProductDialog extends StatefulWidget {
  final stt.SpeechToText speech;
  final bool speechAvailable;
  final String localeId;
  final Future<void> Function() onRequestPermission;
  final void Function(String name, String unit) onAddProduct;

  const AddProductDialog({
    super.key,
    required this.speech,
    required this.speechAvailable,
    required this.localeId,
    required this.onRequestPermission,
    required this.onAddProduct,
  });

  @override
  State<AddProductDialog> createState() => _AddProductDialogState();
}

class _AddProductDialogState extends State<AddProductDialog> {
  final TextEditingController _nameController = TextEditingController();
  final FocusNode _nameFocusNode = FocusNode();
  String _selectedUnit = 'Piece';
  bool _isListening = false;
  String _voiceTranscript = '';
  bool _autoDetectUnit = true;

  List<String> _productSuggestions = [];
  bool _showSuggestions = false;

  @override
  void initState() {
    super.initState();
    // Listen to text changes for auto-detecting unit and showing suggestions
    _nameController.addListener(_onNameChanged);
  }

  void _onNameChanged() {
    final text = _nameController.text.trim();

    if (text.isNotEmpty) {
      // Get product suggestions
      final suggestions = VoiceParserProductUpdated.getProductSuggestions(text);
      setState(() {
        _productSuggestions = suggestions.take(5).toList();
        _showSuggestions = suggestions.isNotEmpty;
      });

      // Auto-detect unit from database or text
      if (_autoDetectUnit) {
        final parsed = VoiceParserProductUpdated.parseVoiceInput(text);
        final detectedName = parsed['name']!;
        final detectedUnit = parsed['unit']!;

        // If we have a detected name, get its default unit
        String finalUnit = VoiceParserProductUpdated.getDefaultUnit(detectedName);

        // If unit was explicitly mentioned in text, use that instead
        if (detectedUnit != 'Piece' || text.toLowerCase().contains(RegExp(r'\b(piece|pieces|pcs|pc|ta|টা|টি|khana|খানা)\b'))) {
          finalUnit = detectedUnit;
        }

        setState(() {
          _selectedUnit = finalUnit;
        });
      }
    } else {
      setState(() {
        _productSuggestions = [];
        _showSuggestions = false;
        if (_autoDetectUnit) {
          _selectedUnit = 'Piece';
        }
      });
    }
  }

  void _selectSuggestion(String product) {
    setState(() {
      _nameController.text = product;
      _showSuggestions = false;

      // Get default unit for this product from database
      if (_autoDetectUnit) {
        _selectedUnit = VoiceParserProductUpdated.getDefaultUnit(product);
      }
    });
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
            final parsed = VoiceParserProductUpdated.parseVoiceInput(result.recognizedWords);
            _nameController.text = parsed['name']!;
            if (_autoDetectUnit) {
              _selectedUnit = parsed['unit']!;
            }
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

  void _showUnitPicker() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Select Unit',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: VoiceParserProductUpdated.getSupportedUnits().length,
                itemBuilder: (context, index) {
                  final unit = VoiceParserProductUpdated.getSupportedUnits()[index];
                  final isSelected = unit == _selectedUnit;

                  return ListTile(
                    leading: Icon(
                      _getUnitIcon(unit),
                      color: isSelected ? AppColors.primary : AppColors.textSecondary,
                    ),
                    title: Text(
                      unit,
                      style: TextStyle(
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                        color: isSelected ? AppColors.primary : AppColors.textPrimary,
                      ),
                    ),
                    trailing: isSelected
                        ? Icon(Icons.check_circle, color: AppColors.primary)
                        : null,
                    onTap: () {
                      setState(() {
                        _selectedUnit = unit;
                        _autoDetectUnit = false;
                      });
                      Navigator.pop(context);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getUnitIcon(String unit) {
    if (unit.contains('kg') || unit.contains('Gram')) return Icons.scale;
    if (unit.contains('Liter') || unit.contains('ml')) return Icons.water_drop;
    if (unit.contains('Meter') || unit.contains('cm')) return Icons.straighten;
    if (unit == 'Box') return Icons.inventory_2;
    if (unit == 'Dozen') return Icons.grid_3x3;
    if (unit == 'Pack') return Icons.shopping_bag;
    return Icons.category;
  }

  void _handleAdd() {
    String finalName = _nameController.text.trim();

    if (finalName.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please enter a product name'),
          behavior: SnackBarBehavior.floating,
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    if (_isListening) {
      widget.speech.stop();
    }

    widget.onAddProduct(finalName, _selectedUnit);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 500),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.getLightColor(AppColors.primary),
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(24),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.add_shopping_cart,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Expanded(
                    child: Text(
                      'Add New Product',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      if (_isListening) widget.speech.stop();
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ),

            // Content
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Voice Input Section
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: _isListening
                            ? AppColors.getLightColor(AppColors.primary)
                            : Colors.grey[100],
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: _isListening
                              ? AppColors.primary
                              : Colors.grey[300]!,
                          width: 2,
                        ),
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.mic,
                                color: _isListening
                                    ? AppColors.primary
                                    : AppColors.textSecondary,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  _isListening
                                      ? 'Speak now in Bangla or English...'
                                      : 'Use voice input',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: _isListening
                                        ? AppColors.primary
                                        : AppColors.textSecondary,
                                  ),
                                ),
                              ),
                              ElevatedButton.icon(
                                onPressed: widget.speechAvailable
                                    ? _toggleListening
                                    : null,
                                icon: Icon(
                                  _isListening ? Icons.stop : Icons.mic,
                                  size: 18,
                                ),
                                label: Text(_isListening ? 'Stop' : 'Start'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: _isListening
                                      ? AppColors.error
                                      : AppColors.primary,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 8,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          if (_voiceTranscript.isNotEmpty && _isListening) ...[
                            const SizedBox(height: 12),
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                _voiceTranscript,
                                style: TextStyle(
                                  fontSize: 13,
                                  color: AppColors.textSecondary,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Divider with "OR"
                    Row(
                      children: [
                        Expanded(child: Divider(color: Colors.grey[300])),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            'OR TYPE MANUALLY',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ),
                        Expanded(child: Divider(color: Colors.grey[300])),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // Product Name Input
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Product Name',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextField(
                          controller: _nameController,
                          focusNode: _nameFocusNode,
                          decoration: InputDecoration(
                            hintText: 'e.g., চাল, মুরগি, তেল',
                            prefixIcon: Icon(
                              Icons.shopping_basket,
                              color: AppColors.textSecondary,
                            ),
                            suffixIcon: _nameController.text.isNotEmpty
                                ? IconButton(
                              icon: const Icon(Icons.clear, size: 20),
                              onPressed: () {
                                _nameController.clear();
                                _selectedUnit = 'Piece';
                                _autoDetectUnit = true;
                              },
                            )
                                : null,
                            filled: true,
                            fillColor: Colors.grey[50],
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
                              borderSide: BorderSide(
                                color: AppColors.primary,
                                width: 2,
                              ),
                            ),
                          ),
                        ),
                        // Product Suggestions
                        if (_showSuggestions && _productSuggestions.isNotEmpty)
                          Container(
                            margin: const EdgeInsets.only(top: 8),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.grey[300]!),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Column(
                              children: _productSuggestions.map((product) {
                                return InkWell(
                                  onTap: () => _selectSuggestion(product),
                                  borderRadius: BorderRadius.circular(12),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 12,
                                    ),
                                    decoration: BoxDecoration(
                                      border: Border(
                                        bottom: BorderSide(
                                          color: Colors.grey[200]!,
                                          width: 1,
                                        ),
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.history,
                                          size: 18,
                                          color: AppColors.textSecondary,
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: Text(
                                            product,
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: AppColors.textPrimary,
                                            ),
                                          ),
                                        ),
                                        Icon(
                                          Icons.north_west,
                                          size: 16,
                                          color: AppColors.textSecondary,
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // Unit Selection
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Unit',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            Row(
                              children: [
                                Icon(
                                  _autoDetectUnit
                                      ? Icons.auto_awesome
                                      : Icons.edit,
                                  size: 14,
                                  color: _autoDetectUnit
                                      ? AppColors.primary
                                      : AppColors.textSecondary,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  _autoDetectUnit ? 'Auto-detect' : 'Manual',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: _autoDetectUnit
                                        ? AppColors.primary
                                        : AppColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        InkWell(
                          onTap: () {
                            _autoDetectUnit = false;
                            _showUnitPicker();
                          },
                          borderRadius: BorderRadius.circular(12),
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.grey[50],
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.grey[300]!),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  _getUnitIcon(_selectedUnit),
                                  color: AppColors.primary,
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    _selectedUnit,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                ),
                                Icon(
                                  Icons.arrow_drop_down,
                                  color: AppColors.textSecondary,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // Help Text
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.blue[50],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.lightbulb_outline,
                            size: 20,
                            color: Colors.blue[700],
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'Tip: Say "চাল ৫ কেজি" or type "Rice 5 kg" - we\'ll detect the unit automatically!',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.blue[700],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Actions
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: const BorderRadius.vertical(
                  bottom: Radius.circular(24),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        if (_isListening) widget.speech.stop();
                        Navigator.pop(context);
                      },
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        side: BorderSide(color: Colors.grey[300]!),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        'Cancel',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton(
                      onPressed: _handleAdd,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.add, size: 20),
                          SizedBox(width: 8),
                          Text(
                            'Add Product',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.removeListener(_onNameChanged);
    _nameController.dispose();
    _nameFocusNode.dispose();
    if (_isListening) {
      widget.speech.stop();
    }
    super.dispose();
  }
}