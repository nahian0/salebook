// lib/features/sales/presentation/widgets/product_form.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../core/theme/app_colors.dart';
import '../controller/sales_entry_controller.dart';

class ProductForm extends StatelessWidget {
  final SalesEntryController controller;

  const ProductForm({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'পণ্যের তথ্য',
            style: TextStyle(
              fontSize: 13,
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 12),

          // Product Name
          TextField(
            controller: controller.productController,
            decoration: InputDecoration(
              labelText: 'প্রোডাক্টের নাম',
              labelStyle: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
              hintText: 'যেমন: দুধ',
              hintStyle: const TextStyle(fontSize: 13, color: AppColors.textTertiary),
              filled: true,
              fillColor: AppColors.background,
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: AppColors.borderLight),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: AppColors.borderLight),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: AppColors.primary, width: 2),
              ),
            ),
            style: const TextStyle(fontSize: 14),
          ),
          const SizedBox(height: 12),

          // Quantity and Unit Row
          Row(
            children: [
              Expanded(
                flex: 2,
                child: TextField(
                  controller: controller.quantityController,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  decoration: InputDecoration(
                    labelText: 'পরিমাণ',
                    labelStyle: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
                    filled: true,
                    fillColor: AppColors.background,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: AppColors.borderLight),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: AppColors.borderLight),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: AppColors.primary, width: 2),
                    ),
                  ),
                  style: const TextStyle(fontSize: 14),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 2,
                child: Obx(() {
                  final selectedUnit = controller.selectedUnit.value;
                  final units = controller.units;

                  // CRITICAL FIX: Ensure the selected unit is valid
                  // If the current selected unit is not in the list, use the first unit
                  final validSelectedUnit = units.contains(selectedUnit)
                      ? selectedUnit
                      : units.first;

                  // If we had to fallback, update the controller
                  if (validSelectedUnit != selectedUnit) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      controller.selectedUnit.value = validSelectedUnit;
                    });
                  }

                  return Container(
                    height: 48,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: AppColors.background,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppColors.borderLight),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: validSelectedUnit,
                        isExpanded: true,
                        items: units.map((unit) {
                          return DropdownMenuItem(
                            value: unit,
                            child: Text(
                              unit,
                              style: const TextStyle(
                                fontSize: 13,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          );
                        }).toList(),
                        onChanged: (value) {
                          if (value != null) {
                            controller.selectedUnit.value = value;
                          }
                        },
                        icon: const Icon(
                          Icons.arrow_drop_down,
                          color: AppColors.textSecondary,
                          size: 20,
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Total Price (changed from unit price)
          TextField(
            controller: controller.priceController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(
              labelText: 'মোট মূল্য (৳)',
              labelStyle: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
              hintText: 'যেমন: ৫০০',
              hintStyle: const TextStyle(fontSize: 13, color: AppColors.textTertiary),
              filled: true,
              fillColor: AppColors.background,
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: AppColors.borderLight),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: AppColors.borderLight),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: AppColors.primary, width: 2),
              ),
            ),
            style: const TextStyle(fontSize: 14),
          ),
          const SizedBox(height: 16),

          // Add Button
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: controller.addProduct,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 0,
              ),
              child: const Text(
                'যোগ করুন',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}