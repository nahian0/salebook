// lib/core/models/purchase_details_item.dart

class PurchaseDetailItem {
  final String description;
  final String? remarks;
  final double amount;

  PurchaseDetailItem({
    required this.description,
    this.remarks,
    required this.amount,
  });
}