// lib/features/sales/presentation/pages/add_sales_entry_screen.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../widgets/product_form.dart';
import '../widgets/product_list.dart';
import '../widgets/voice_button_section.dart';
import '../widgets/customer_section.dart';
import '../../../../core/theme/app_colors.dart';
import '../controller/sales_entry_controller.dart';

class AddSalesEntryScreen extends StatelessWidget {
  const AddSalesEntryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SalesEntryController());

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Get.back(),
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

                      // Customer Section
                      CustomerSection(controller: controller),

                      const SizedBox(height: 16),

                      // Products List
                      Obx(() {
                        if (controller.products.isEmpty) {
                          return const SizedBox.shrink();
                        }
                        return Column(
                          children: [
                            ProductsList(controller: controller),
                            const SizedBox(height: 16),
                          ],
                        );
                      }),

                      // Product Form
                      Obx(() {
                        if (controller.selectedCustomer.value == null) {
                          return const SizedBox.shrink();
                        }
                        return ProductForm(controller: controller);
                      }),

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
            child: VoiceButtonSection(controller: controller),
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
          onPressed: controller.saveSalesEntry,
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
        );
      }),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}