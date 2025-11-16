import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class ProductListItem extends StatelessWidget {
  final Map<String, dynamic> product;
  final VoidCallback onMorePressed;

  const ProductListItem({
    super.key,
    required this.product,
    required this.onMorePressed,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: AppColors.borderLight),
      ),
      elevation: 0,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 8,
        ),
        leading: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.getLightColor(AppColors.stockColor),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            Icons.inventory_2_rounded,
            color: AppColors.stockColor,
          ),
        ),
        title: Text(
          product['name'],
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
        subtitle: Text(
          'Unit: ${product['unit']}',
          style: TextStyle(
            color: AppColors.textSecondary,
            fontSize: 14,
          ),
        ),
        trailing: IconButton(
          icon: Icon(
            Icons.more_vert,
            color: AppColors.textSecondary,
          ),
          onPressed: onMorePressed,
        ),
      ),
    );
  }
}