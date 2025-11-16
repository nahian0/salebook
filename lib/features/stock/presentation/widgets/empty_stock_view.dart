import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class EmptyStockView extends StatelessWidget {
  const EmptyStockView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.inventory_2_outlined,
            size: 80,
            color: AppColors.textTertiary,
          ),
          const SizedBox(height: 16),
          Text(
            'No products yet',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Tap the + button to add your first product',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textTertiary,
            ),
          ),
        ],
      ),
    );
  }
}