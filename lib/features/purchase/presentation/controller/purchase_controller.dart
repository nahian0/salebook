import 'package:get/get.dart';
import '../../../../core/services/storage_service.dart';
import '../../data/models/purchase_model.dart';
import '../../data/repositories/purchase_repository.dart';

class PurchaseController extends GetxController {
  final PurchaseRepository purchaseRepository;

  PurchaseController({required this.purchaseRepository});

  // Observable variables
  final RxList<PurchaseModel> purchaseList = <PurchaseModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final RxDouble totalPurchaseAmount = 0.0.obs;

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

    // Fetch purchase list
    await fetchPurchaseList();
  }

  // Fetch purchase list from API
  Future<void> fetchPurchaseList() async {
    if (companyId == null) {
      errorMessage.value = 'কোম্পানি তথ্য পাওয়া যায়নি';
      return;
    }

    try {
      isLoading.value = true;
      errorMessage.value = '';

      final purchases = await purchaseRepository.getPurchaseList(
        companyId: companyId!,
        purId: 0,
      );

      purchaseList.value = purchases;
      calculateTotalPurchases();
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

  // Calculate total purchase amount
  void calculateTotalPurchases() {
    totalPurchaseAmount.value = purchaseList.fold(
      0.0,
          (sum, purchase) => sum + purchase.totalAmount,
    );
  }

  // Refresh purchase list
  Future<void> refreshPurchaseList() async {
    await fetchPurchaseList();
  }

  // Delete purchase entry (local only - add API call if needed)
  void deletePurchaseEntry(int purchaseId) {
    // Remove from local list
    purchaseList.removeWhere((purchase) => purchase.id == purchaseId);
    calculateTotalPurchases();

    Get.snackbar(
      'সফল',
      'ক্রয় মুছে ফেলা হয়েছে',
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 2),
    );
  }

  // Get purchase by ID
  PurchaseModel? getPurchaseById(int id) {
    try {
      return purchaseList.firstWhere((purchase) => purchase.id == id);
    } catch (e) {
      return null;
    }
  }

  // Add new purchase to list (after creating from add screen)
  void addPurchaseToList(PurchaseModel purchase) {
    purchaseList.insert(0, purchase); // Add to beginning
    calculateTotalPurchases();
  }

  @override
  void onClose() {
    // Clean up if needed
    super.onClose();
  }
}