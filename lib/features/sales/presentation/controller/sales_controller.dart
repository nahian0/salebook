// lib/features/sales/presentation/controllers/sales_controller.dart

import 'package:get/get.dart';
import '../../../../core/services/storage_service.dart';
import '../../data/models/sales_model.dart';
import '../../data/repository/sales_repository.dart';

class SalesController extends GetxController {
  final SalesRepository salesRepository;

  SalesController({required this.salesRepository});

  // Observable variables
  final RxList<SalesModel> salesList = <SalesModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final RxDouble totalSalesAmount = 0.0.obs;

  // Company ID - loaded from storage
  int? companyId;

  @override
  void onInit() {
    super.onInit();
    _initializeController();
  }

  Future<void> _initializeController() async {
    // Load company ID from storage
    companyId = await StorageService.getCompanyId();

    if (companyId == null) {
      errorMessage.value = 'কোম্পানি তথ্য পাওয়া যায়নি';
      return;
    }

    // Fetch sales list
    await fetchSalesList();
  }

  // Fetch sales list from API
  Future<void> fetchSalesList() async {
    if (companyId == null) {
      errorMessage.value = 'কোম্পানি তথ্য পাওয়া যায়নি';
      return;
    }

    try {
      isLoading.value = true;
      errorMessage.value = '';

      final sales = await salesRepository.getSalesList(
        companyId: companyId!,
        salId: 0,
      );

      salesList.value = sales;
      calculateTotalSales();
    } catch (e) {
      errorMessage.value = e.toString();
      Get.snackbar(
        'ত্রুটি',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 3),
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Calculate total sales amount
  void calculateTotalSales() {
    totalSalesAmount.value = salesList.fold(
      0.0,
          (sum, sale) => sum + sale.totalAmount,
    );
  }

  // Refresh sales list
  Future<void> refreshSalesList() async {
    await fetchSalesList();
  }

  // Delete sales entry (local only - add API call if needed)
  void deleteSalesEntry(int saleId) {
    // Remove from local list
    salesList.removeWhere((sale) => sale.id == saleId);
    calculateTotalSales();

    Get.snackbar(
      'সফল',
      'বিক্রয় মুছে ফেলা হয়েছে',
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 2),
    );
  }

  // Get sale by ID
  SalesModel? getSaleById(int id) {
    try {
      return salesList.firstWhere((sale) => sale.id == id);
    } catch (e) {
      return null;
    }
  }

  // Add new sale to list (after creating from add screen)
  void addSaleToList(SalesModel sale) {
    salesList.insert(0, sale); // Add to beginning
    calculateTotalSales();
  }

  @override
  void onClose() {
    // Clean up if needed
    super.onClose();
  }
}