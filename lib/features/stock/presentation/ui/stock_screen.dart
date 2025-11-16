import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:permission_handler/permission_handler.dart';
import '../../../../core/theme/app_colors.dart';
import '../widgets/add_product_dialog.dart';
import '../widgets/empty_stock_view.dart';
import '../widgets/product_list_item.dart';
import '../widgets/stock_header_card.dart';

class StockScreen extends StatefulWidget {
  const StockScreen({super.key});

  @override
  State<StockScreen> createState() => _StockScreenState();
}

class _StockScreenState extends State<StockScreen> {
  final List<Map<String, dynamic>> _products = [];
  double _totalStockPrice = 0.0;

  // Speech to text
  late stt.SpeechToText _speech;
  bool _speechAvailable = false;
  List<stt.LocaleName> _locales = [];
  String _currentLocaleId = 'bn-BD'; // Default to Bangla (Bangladesh)

  @override
  void initState() {
    super.initState();
    _initSpeech();
  }

  Future<void> _initSpeech() async {
    _speech = stt.SpeechToText();
    _speechAvailable = await _speech.initialize(
      onError: (error) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Speech recognition error: ${error.errorMsg}'),
              backgroundColor: AppColors.error,
            ),
          );
        }
      },
    );

    // Get available locales
    if (_speechAvailable) {
      _locales = await _speech.locales();

      // Filter to only Bangla and English locales
      var filteredLocales = _locales.where((locale) {
        return locale.localeId.startsWith('bn') ||
            locale.localeId.startsWith('en');
      }).toList();

      if (filteredLocales.isEmpty) {
        // Fallback if neither Bangla nor English is available
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Bangla or English language not available'),
              backgroundColor: AppColors.error,
            ),
          );
        }
        return;
      }

      _locales = filteredLocales;

      if (mounted) {
        print('Available locales (Bangla/English only): ${_locales.map((l) => l.localeId).toList()}');
        print('Selected locale: $_currentLocaleId');
      }
    }

    setState(() {});
  }

  Future<void> _requestMicrophonePermission() async {
    var status = await Permission.microphone.status;
    if (!status.isGranted) {
      status = await Permission.microphone.request();
      if (!status.isGranted && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Microphone permission is required for voice input'),
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

  void _addProduct(String name, String unit) {
    setState(() {
      _products.add({
        'name': name,
        'unit': unit,
        'quantity': 0,
        'price': 0.0,
      });
    });
  }

  void _showAddProductDialog() {
    showDialog(
      context: context,
      builder: (context) => AddProductDialog(
        speech: _speech,
        speechAvailable: _speechAvailable,
        localeId: _currentLocaleId,
        onRequestPermission: _requestMicrophonePermission,
        onAddProduct: (name, unit) {
          _addProduct(name, unit);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('$name added successfully'),
              behavior: SnackBarBehavior.floating,
              backgroundColor: AppColors.success,
            ),
          );
        },
      ),
    );
  }

  void _showHelpDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Text('Help'),
        content: const Text(
          '• Tap + button to add products\n'
              '• Toggle voice mode with mic icon\n'
              '• Tap "Start Speaking" and say product name in Bangla\n'
              '• Examples: "চাল ১০ কেজি", "মুরগি ৫ পিস"\n'
              '• App will automatically detect unit from your speech',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Got it'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Stock',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        backgroundColor: AppColors.surface,
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline),
            onPressed: _showHelpDialog,
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: Column(
        children: [
          StockHeaderCard(totalStockPrice: _totalStockPrice),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Products (${_products.length})',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: _products.isEmpty
                ? const EmptyStockView()
                : ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: _products.length,
              itemBuilder: (context, index) {
                return ProductListItem(
                  product: _products[index],
                  onMorePressed: () {
                    // Show options
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddProductDialog,
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text('Add Product'),
      ),
    );
  }

  @override
  void dispose() {
    _speech.stop();
    super.dispose();
  }
}