// lib/features/purchase/presentation/pages/add_purchase_entry_screen.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../widgets/purchase_product_form.dart';
import '../widgets/purchase_product_list.dart';
import '../widgets/purchase_voice_button_section.dart';
import '../widgets/supplier_section.dart';
import '../../../../core/theme/app_colors.dart';
import '../controller/purchase_entry_controller.dart';

class AddPurchaseEntryScreen extends StatelessWidget {
  const AddPurchaseEntryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(PurchaseEntryController());

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          'নতুন ক্রয়',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: AppColors.appBarBackground,
        elevation: 0,
        actions: [
          Obx(() {
            final totalAmount = controller.totalAmount.value;
            if (totalAmount == 0) return const SizedBox.shrink();

            return Center(
              child: Padding(
                padding: const EdgeInsets.only(right: 16),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '৳${totalAmount.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ),
            );
          }),
        ],
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

                      // Supplier Section (Optional)
                      SupplierSection(controller: controller),

                      const SizedBox(height: 16),

                      // Products List
                      Obx(() {
                        if (controller.products.isEmpty) {
                          return const SizedBox.shrink();
                        }
                        return Column(
                          children: [
                            PurchaseProductsList(controller: controller),
                            const SizedBox(height: 16),
                          ],
                        );
                      }),

                      // Product Form (Always visible)
                      PurchaseProductForm(controller: controller),

                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
            ],
          ),

          // Bottom Voice Section
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: PurchaseVoiceButtonSection(controller: controller),
          ),

          // Loading overlay
          Obx(() {
            if (!controller.isSaving.value) {
              return const SizedBox.shrink();
            }
            return Container(
              color: Colors.black.withOpacity(0.5),
              child: const Center(
                child: Card(
                  child: Padding(
                    padding: EdgeInsets.all(24.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(height: 16),
                        Text(
                          'সংরক্ষণ করা হচ্ছে...',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }),
        ],
      ),
      floatingActionButton: Obx(() {
        if (controller.products.isEmpty ||
            controller.isListening.value ||
            controller.isSaving.value) {
          return const SizedBox.shrink();
        }
        return FloatingActionButton.extended(
          onPressed: controller.savePurchaseEntry,
          backgroundColor: AppColors.primary,
          icon: const Icon(Icons.check, color: Colors.white),
          label: const Text(
            'সংরক্ষণ করুন',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        );
      }),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}