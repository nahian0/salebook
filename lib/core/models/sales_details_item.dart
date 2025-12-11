/// Model class for sales detail items
class SalesDetailItem {
  final String description;
  final String? remarks;
  final double amount;

  SalesDetailItem({
    required this.description,
    this.remarks,
    required this.amount,
  });
}