// lib/features/purchase/presentation/widgets/supplier_section.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/dialog_utils.dart';
import '../controller/purchase_entry_controller.dart';

class SupplierSection extends StatelessWidget {
  final PurchaseEntryController controller;

  const SupplierSection({
    super.key,
    required this.controller,
  });

  Future<void> _showSupplierDialog(BuildContext context) async {
    final result = await DialogUtils.showSupplierSelectionDialog(
      context: context,
      title: 'সরবরাহকারী নির্বাচন করুন',
      items: controller.supplierList.toList(),
      itemLabel: (supplier) => supplier.name,
      selectedItem: controller.selectedSupplier.value,
      searchHint: 'সরবরাহকারীর নাম খুঁজুন...',
      emptyMessage: 'কোন সরবরাহকারী পাওয়া যায়নি',
      showNoneOption: true,
      noneOptionLabel: 'কোন সরবরাহকারী নেই',
    );

    if (result == null) {
      controller.clearSupplier();
    } else {
      controller.selectedSupplier.value = result;
    }
  }

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
                'সরবরাহকারীর নাম (ঐচ্ছিক)',
                style: TextStyle(
                  fontSize: 13,
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Obx(() {
                final supplier = controller.selectedSupplier.value;
                final isTypingSupplier = controller.isTypingSupplier.value;

                if (isTypingSupplier) {
                  return Row(
                    children: [
                      TextButton.icon(
                        onPressed: controller.cancelTypingSupplier,
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
                          onPressed: isCreating ? null : controller.saveTypedSupplier,
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

                if (supplier == null) {
                  return TextButton.icon(
                    onPressed: controller.startTypingSupplier,
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
                  onPressed: controller.clearSupplier,
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
            final selectedSupplier = controller.selectedSupplier.value;
            final isLoading = controller.isLoadingParties.value;
            final isTypingSupplier = controller.isTypingSupplier.value;

            // Show text field when typing new supplier
            if (isTypingSupplier) {
              return TextField(
                controller: controller.supplierSearchController,
                autofocus: true,
                decoration: InputDecoration(
                  labelText: 'নতুন সরবরাহকারীর নাম লিখুন',
                  labelStyle: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
                  hintText: 'যেমন: আব্দুল্লাহ এন্টারপ্রাইজ',
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
                  prefixIcon: const Icon(Icons.business, color: AppColors.primary),
                ),
                style: const TextStyle(fontSize: 14),
                textCapitalization: TextCapitalization.words,
                onSubmitted: (value) {
                  if (value.trim().isNotEmpty) {
                    controller.saveTypedSupplier();
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

            // Supplier selection button
            return InkWell(
              onTap: () => _showSupplierDialog(context),
              borderRadius: BorderRadius.circular(8),
              child: Container(
                height: 48,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.borderLight),
                ),
                child: Row(
                  children: [
                    Icon(
                      selectedSupplier != null ? Icons.business : Icons.business_outlined,
                      color: AppColors.textSecondary,
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        selectedSupplier?.name ?? 'সরবরাহকারী নির্বাচন করুন (ঐচ্ছিক)',
                        style: TextStyle(
                          fontSize: 14,
                          color: selectedSupplier != null
                              ? AppColors.textPrimary
                              : AppColors.textTertiary,
                        ),
                      ),
                    ),
                    const Icon(
                      Icons.arrow_drop_down,
                      color: AppColors.textSecondary,
                    ),
                  ],
                ),
              ),
            );
          }),
          const SizedBox(height: 8),
          Obx(() {
            final isTypingSupplier = controller.isTypingSupplier.value;
            if (isTypingSupplier) {
              return const Text(
                'টিপস: নাম টাইপ করে "সংরক্ষণ" চাপুন',
                style: TextStyle(
                  fontSize: 11,
                  color: AppColors.primary,
                  fontStyle: FontStyle.italic,
                ),
              );
            }
            return const Text(
              'টিপস: ভয়েস বাটন দিয়ে সরবরাহকারীর নাম বলতে পারবেন বা "নতুন যোগ করুন" চাপুন',
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