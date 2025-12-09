// lib/features/sales/presentation/widgets/customer_section.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/theme/app_colors.dart';
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
                'গ্রাহকের নাম (ঐচ্ছিক)',
                style: TextStyle(
                  fontSize: 13,
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Obx(() {
                final customer = controller.selectedCustomer.value;
                final isTypingCustomer = controller.isTypingCustomer.value;

                if (isTypingCustomer) {
                  return Row(
                    children: [
                      TextButton.icon(
                        onPressed: controller.cancelTypingCustomer,
                        icon: const Icon(Icons.close, size: 16, color: AppColors.error),
                        label: const Text(
                          'বাতিল',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.error,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Obx(() {
                        final isCreating = controller.isCreatingParty.value;
                        return TextButton.icon(
                          onPressed: isCreating ? null : controller.saveTypedCustomer,
                          icon: isCreating
                              ? const SizedBox(
                            width: 14,
                            height: 14,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                              : const Icon(Icons.check, size: 16, color: AppColors.success),
                          label: Text(
                            'সংরক্ষণ',
                            style: TextStyle(
                              fontSize: 12,
                              color: isCreating ? AppColors.textTertiary : AppColors.success,
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
                  );
                }

                if (customer == null) {
                  return TextButton.icon(
                    onPressed: controller.startTypingCustomer,
                    icon: const Icon(Icons.add, size: 16, color: AppColors.primary),
                    label: const Text(
                      'নতুন যোগ করুন',
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
                }
                return TextButton.icon(
                  onPressed: controller.clearCustomer,
                  icon: const Icon(Icons.close, size: 16, color: AppColors.error),
                  label: const Text(
                    'সরান',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.error,
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
            final selectedCustomer = controller.selectedCustomer.value;
            final isLoading = controller.isLoadingParties.value;
            final isTypingCustomer = controller.isTypingCustomer.value;
            final customerList = controller.customerList.toList();

            // Show text field when typing new customer
            if (isTypingCustomer) {
              return TextField(
                controller: controller.customerSearchController,
                autofocus: true,
                decoration: InputDecoration(
                  labelText: 'নতুন গ্রাহকের নাম লিখুন',
                  labelStyle: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
                  hintText: 'যেমন: মোঃ রহিম',
                  hintStyle: const TextStyle(fontSize: 13, color: AppColors.textTertiary),
                  filled: true,
                  fillColor: AppColors.background,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: AppColors.primary, width: 2),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: AppColors.primary, width: 2),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: AppColors.primary, width: 2),
                  ),
                  prefixIcon: const Icon(Icons.person_add, color: AppColors.primary),
                ),
                style: const TextStyle(fontSize: 14),
                textCapitalization: TextCapitalization.words,
                onSubmitted: (value) {
                  if (value.trim().isNotEmpty) {
                    controller.saveTypedCustomer();
                  }
                },
              );
            }

            if (isLoading) {
              return Container(
                height: 48,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.borderLight),
                ),
                child: const Center(
                  child: SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                ),
              );
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
                child: DropdownButton<int?>(
                  value: selectedCustomer?.id,
                  hint: const Text(
                    'গ্রাহক নির্বাচন করুন (ঐচ্ছিক)',
                    style: TextStyle(fontSize: 14, color: AppColors.textTertiary),
                  ),
                  isExpanded: true,
                  items: [
                    const DropdownMenuItem<int?>(
                      value: null,
                      child: Text(
                        'কোন গ্রাহক নেই',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.textSecondary,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                    ...customerList.map((customer) {
                      return DropdownMenuItem(
                        value: customer.id,
                        child: Text(
                          customer.name,
                          style: const TextStyle(
                            fontSize: 14,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      );
                    }),
                  ],
                  onChanged: (value) {
                    if (value == null) {
                      controller.clearCustomer();
                    } else {
                      final selected = customerList.firstWhereOrNull(
                            (customer) => customer.id == value,
                      );
                      if (selected != null) {
                        controller.selectedCustomer.value = selected;
                      }
                    }
                  },
                  icon: const Icon(
                    Icons.arrow_drop_down,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            );
          }),
          const SizedBox(height: 8),
          Obx(() {
            final isTypingCustomer = controller.isTypingCustomer.value;
            if (isTypingCustomer) {
              return Text(
                'টিপস: নাম টাইপ করে "সংরক্ষণ" চাপুন',
                style: TextStyle(
                  fontSize: 11,
                  color: AppColors.primary,
                  fontStyle: FontStyle.italic,
                ),
              );
            }
            return Text(
              'টিপস: ভয়েস বাটন দিয়ে গ্রাহকের নাম বলতে পারবেন বা "নতুন যোগ করুন" চাপুন',
              style: TextStyle(
                fontSize: 11,
                color: AppColors.textTertiary,
                fontStyle: FontStyle.italic,
              ),
            );
          }),
        ],
      ),
    );
  }
}