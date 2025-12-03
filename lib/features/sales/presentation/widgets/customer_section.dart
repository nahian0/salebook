import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../core/theme/app_colors.dart';
import '../controller/sales_entry_controller.dart';

class CustomerSection extends StatelessWidget {
  final SalesEntryController controller;

  const CustomerSection({
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'গ্রাহকের নাম',
                style: TextStyle(
                  fontSize: 13,
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Obx(() {
                // MUST access the observable first
                final customer = controller.selectedCustomer.value;
                if (customer == null || customer.isEmpty) {
                  return const SizedBox.shrink();
                }
                return TextButton.icon(
                  onPressed: controller.clearCustomer,
                  icon: const Icon(Icons.edit, size: 16, color: AppColors.primary),
                  label: const Text(
                    'পরিবর্তন',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                );
              }),
            ],
          ),
          const SizedBox(height: 12),
          Obx(() {
            // Access observables at the start
            final selectedCustomer = controller.selectedCustomer.value;
            final customerList = controller.customerList.toList();

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
                  value: selectedCustomer,
                  hint: const Text(
                    'নাম লিখুন বা ভয়েস বাটন চাপুন',
                    style: TextStyle(fontSize: 14, color: AppColors.textTertiary),
                  ),
                  isExpanded: true,
                  items: customerList.map((customer) {
                    return DropdownMenuItem(
                      value: customer,
                      child: Text(
                        customer,
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    controller.selectedCustomer.value = value;
                  },
                  icon: const Icon(
                    Icons.arrow_drop_down,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}