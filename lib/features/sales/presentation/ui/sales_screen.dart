import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:permission_handler/permission_handler.dart';
import '../../../../core/theme/app_colors.dart';
import '../widgets/add_sales_dialog.dart';
import '../widgets/sales_header_card.dart';

class SalesScreen extends StatefulWidget {
  const SalesScreen({super.key});

  @override
  State<SalesScreen> createState() => _SalesScreenState();
}

class _SalesScreenState extends State<SalesScreen> {
  final List<Map<String, dynamic>> _salesEntries = [];
  double _totalSalesAmount = 0.0;

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
        print('Available locales: ${_locales.map((l) => l.localeId).toList()}');
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

  void _addSalesEntry(String customerName, String productName, double quantity,
      String unit, double totalPrice) {
    setState(() {
      _salesEntries.add({
        'customerName': customerName,
        'productName': productName,
        'quantity': quantity,
        'unit': unit,
        'totalPrice': totalPrice,
        'timestamp': DateTime.now(),
      });
      _totalSalesAmount += totalPrice;
    });
  }

  void _showAddSalesDialog() {
    showDialog(
      context: context,
      builder: (context) => AddSalesDialog(
        speech: _speech,
        speechAvailable: _speechAvailable,
        localeId: _currentLocaleId,
        onRequestPermission: _requestMicrophonePermission,
        onAddSales: (customerName, productName, quantity, unit, totalPrice) {
          _addSalesEntry(customerName, productName, quantity, unit, totalPrice);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Sale added: ৳${totalPrice.toStringAsFixed(2)}'),
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
          '• Tap + button to add sales entry\n'
              '• Toggle voice mode with mic icon\n'
              '• Say complete sales info in Bangla\n'
              '• Example: "নাহিয়ান চাল ১০ কেজি ১০০ টাকা"\n'
              '• Format: [Customer] [Product] [Quantity] [Unit] [Price]\n'
              '• App will automatically extract all fields',
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

  void _deleteSalesEntry(int index) {
    setState(() {
      _totalSalesAmount -= _salesEntries[index]['totalPrice'] as double;
      _salesEntries.removeAt(index);
    });
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
          'Sales Entry',
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
          SalesHeaderCard(totalSalesAmount: _totalSalesAmount),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Sales Today (${_salesEntries.length})',
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
            child: _salesEntries.isEmpty
                ? const EmptySalesView()
                : ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: _salesEntries.length,
              itemBuilder: (context, index) {
                return SalesListItem(
                  salesEntry: _salesEntries[index],
                  onDelete: () => _deleteSalesEntry(index),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddSalesDialog,
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text('Add Sale'),
      ),
    );
  }

  @override
  void dispose() {
    _speech.stop();
    super.dispose();
  }
}