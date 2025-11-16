import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class ManualInputSection extends StatelessWidget {
  final TextEditingController nameController;
  final String selectedUnit;
  final VoidCallback onShowUnitPicker;

  const ManualInputSection({
    super.key,
    required this.nameController,
    required this.selectedUnit,
    required this.onShowUnitPicker,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: nameController,
          decoration: const InputDecoration(
            labelText: 'Product Name',
            hintText: 'Enter product name',
            prefixIcon: Icon(Icons.inventory_2_outlined),
          ),
          textCapitalization: TextCapitalization.words,
          autofocus: true,
        ),
        const SizedBox(height: 20),
        Text(
          'Unit',
          style: TextStyle(
            fontSize: 12,
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: onShowUnitPicker,
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
            decoration: BoxDecoration(
              color: AppColors.surfaceVariant,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.borderLight),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.straighten,
                      color: AppColors.primary,
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      selectedUnit,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                Icon(
                  Icons.arrow_drop_down,
                  color: AppColors.textSecondary,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}