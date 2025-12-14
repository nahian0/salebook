// lib/features/sales/presentation/screens/sales_screen.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/models/sales_details_item.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/dialog_utils.dart';
import '../../data/models/sales_model.dart';
import '../controller/sales_controller.dart';
import '../../../sales entry/presentation/ui/add_sales_entry_screen.dart';

class SalesScreen extends StatelessWidget {
  const SalesScreen({super.key});

  SalesController get controller => Get.find<SalesController>();

  void _navigateToAddSalesEntry(BuildContext context) async {
    final result = await Get.to(() => const AddSalesEntryScreen());
    print('Returned from AddSalesEntry with result: $result');
    await controller.refreshSalesList();
    if (result != null && result['success'] == true) {
      print('Sale was successful, list refreshed');
    }
  }

  void _deleteSalesEntry(int saleId) {
    DialogUtils.showDeleteConfirmDialog(
      title: 'বিক্রয় মুছুন',
      message: 'আপনি কি এই বিক্রয় এন্ট্রি মুছতে চান?',
      onConfirm: () => controller.deleteSalesEntry(saleId),
    );
  }

  void _viewSalesDetails(SalesModel sale) {
    final items = sale.salSalesDetails.map((detail) {
      return SalesDetailItem(
        description: detail.productDescription,
        remarks: detail.remarks,
        amount: detail.amount,
      );
    }).toList();

    DialogUtils.showSalesDetailsDialog(
      saleNo: sale.saleNo,
      partyName: sale.salePartyName,
      items: items,
      totalAmount: sale.totalAmount,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SafeArea(
        child: Column(
          children: [
            // Minimal Header
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, size: 22),
                    onPressed: () => Navigator.pop(context),
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.white,
                      padding: const EdgeInsets.all(8),
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                      'বিক্রয়',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.5,
                      ),
                    ),
                  ),
                  Obx(() => !controller.isLoading.value
                      ? IconButton(
                    icon: const Icon(Icons.refresh, size: 20),
                    onPressed: controller.refreshSalesList,
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.white,
                      padding: const EdgeInsets.all(8),
                    ),
                  )
                      : const SizedBox(width: 40)),
                  const SizedBox(width: 4),
                  IconButton(
                    icon: const Icon(Icons.help_outline, size: 20),
                    onPressed: DialogUtils.showHelpDialog,
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.white,
                      padding: const EdgeInsets.all(8),
                    ),
                  ),
                ],
              ),
            ),

            // Compact Stats
            Obx(() => Container(
              margin: const EdgeInsets.all(12),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '৳${controller.totalSalesAmount.value.toStringAsFixed(0)}',
                        style: const TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(height: 2),
                      const Text(
                        'মোট বিক্রয়',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.receipt,
                            color: Colors.white, size: 14),
                        const SizedBox(width: 4),
                        Text(
                          '${controller.salesList.length}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )),

            // List
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(
                    child: CircularProgressIndicator(strokeWidth: 2.5),
                  );
                }

                if (controller.errorMessage.value.isNotEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.cloud_off, size: 48,
                            color: Colors.grey[400]),
                        const SizedBox(height: 12),
                        Text(
                          controller.errorMessage.value,
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                        const SizedBox(height: 16),
                        TextButton(
                          onPressed: controller.refreshSalesList,
                          child: const Text('পুনরায় চেষ্টা করুন'),
                        ),
                      ],
                    ),
                  );
                }

                if (controller.salesList.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.inbox, size: 56,
                            color: Colors.grey[300]),
                        const SizedBox(height: 12),
                        Text(
                          'কোনো বিক্রয় নেই',
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.fromLTRB(12, 0, 12, 80),
                  itemCount: controller.salesList.length,
                  itemBuilder: (context, index) {
                    final sale = controller.salesList[index];

                    return Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.grey[200]!,
                        ),
                      ),
                      child: InkWell(
                        onTap: () => _viewSalesDetails(sale),
                        borderRadius: BorderRadius.circular(12),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Row(
                            children: [
                              Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: AppColors.primaryLight,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Icon(
                                  Icons.person,
                                  color: AppColors.primary,
                                  size: 20,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      sale.salePartyName,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      '${sale.salSalesDetails.length} পণ্য • ${sale.saleNo}',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey[600],
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 8),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    '৳${sale.totalAmount.toStringAsFixed(0)}',
                                    style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  InkWell(
                                    onTap: () => _deleteSalesEntry(sale.id),
                                    child: Icon(
                                      Icons.delete_outline,
                                      color: Colors.red[400],
                                      size: 18,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _navigateToAddSalesEntry(context),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 4,
        icon: const Icon(Icons.add, size: 28),
        label: const Text(
          'নতুন বিক্রয়',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }
}