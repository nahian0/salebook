// lib/features/sales/presentation/widgets/payment_summary_section.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/theme/app_colors.dart';
import '../controller/sales_entry_controller.dart';

class PaymentSummarySection extends StatelessWidget {
  final SalesEntryController controller;

  const PaymentSummarySection({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      // Only show when there are products
      if (controller.products.isEmpty) {
        return const SizedBox.shrink();
      }

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
              'পেমেন্টের তথ্য',
              style: TextStyle(
                fontSize: 13,
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 12),

            // Total Amount Display
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.05),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: AppColors.primary.withOpacity(0.2),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'মোট বিক্রয়:',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  Text(
                    '৳${controller.totalAmount.value.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // Deposit Amount Input with Focus Node
            TextField(
              controller: controller.depositController,
              focusNode: controller.depositFocusNode, // ADDED: Focus node for voice navigation
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
                labelText: 'জমা পরিমাণ (৳)',
                labelStyle: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
                hintText: 'যেমন: ৫০০ অথবা ভয়েসে "জমা ৫০০" বলুন',
                hintStyle: const TextStyle(fontSize: 12, color: AppColors.textTertiary),
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
                prefixIcon: const Icon(Icons.account_balance_wallet, size: 20, color: AppColors.textSecondary),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear, size: 18),
                  onPressed: () {
                    controller.depositController.clear();
                    controller.update();
                  },
                ),
              ),
              style: const TextStyle(fontSize: 14),
              onChanged: (value) {
                controller.update();
              },
            ),
            const SizedBox(height: 8),

            // Voice Input Hint
            Row(
              children: [
                const Icon(Icons.mic, size: 14, color: AppColors.primary),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    'টিপস: ভয়েস বাটন চেপে "জমা ৫০০" বললে স্বয়ংক্রিয়ভাবে যোগ হবে',
                    style: TextStyle(
                      fontSize: 11,
                      color: AppColors.primary.withOpacity(0.8),
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Due Amount Display
            GetBuilder<SalesEntryController>(
              builder: (ctrl) {
                final depositAmount = double.tryParse(ctrl.depositController.text) ?? 0;
                final dueAmount = ctrl.totalAmount.value - depositAmount;

                return Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: dueAmount > 0
                        ? AppColors.error.withOpacity(0.05)
                        : Colors.green.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: dueAmount > 0
                          ? AppColors.error.withOpacity(0.2)
                          : Colors.green.withOpacity(0.2),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'বাকি:',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      Text(
                        '৳${dueAmount.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: dueAmount > 0 ? AppColors.error : Colors.green,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      );
    });
  }
}