import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

void showUnitSelectionDialog(
    BuildContext context,
    String currentUnit,
    Function(String) onUnitSelected,
    ) {
  final List<Map<String, dynamic>> units = [
    {'name': 'Piece', 'icon': Icons.inventory_2_outlined},
    {'name': 'Kilogram (kg)', 'icon': Icons.scale_outlined},
    {'name': 'Gram (g)', 'icon': Icons.scale_outlined},
    {'name': 'Liter (L)', 'icon': Icons.water_drop_outlined},
    {'name': 'Milliliter (ml)', 'icon': Icons.water_drop_outlined},
    {'name': 'Meter (m)', 'icon': Icons.straighten},
    {'name': 'Centimeter (cm)', 'icon': Icons.straighten},
    {'name': 'Box', 'icon': Icons.inventory_outlined},
    {'name': 'Dozen', 'icon': Icons.filter_1_outlined},
    {'name': 'Pack', 'icon': Icons.inventory_outlined},
  ];

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Text(
          'Select Unit',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: units.length,
            itemBuilder: (context, index) {
              final unit = units[index];
              final isSelected = currentUnit == unit['name'];

              return ListTile(
                leading: Icon(
                  unit['icon'] as IconData,
                  color: isSelected ? AppColors.primary : AppColors.textSecondary,
                ),
                title: Text(
                  unit['name'] as String,
                  style: TextStyle(
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                    color: isSelected ? AppColors.primary : AppColors.textPrimary,
                  ),
                ),
                trailing: isSelected
                    ? Icon(Icons.check_circle, color: AppColors.primary)
                    : null,
                onTap: () {
                  onUnitSelected(unit['name'] as String);
                  Navigator.pop(context);
                },
              );
            },
          ),
        ),
      );
    },
  );
}