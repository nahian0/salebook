// lib/features/purchase/data/models/purchase_model.dart

class PurchaseModel {
  final int id;
  final int companyId;
  final int purchasePartyId;
  final String purchasePartyName;
  final String purNo;
  final DateTime purchaseDate;
  final double totalAmount;
  final String remarks;
  final int serialNo;
  final List<PurchaseDetail> purPurchaseDetails;

  PurchaseModel({
    required this.id,
    required this.companyId,
    required this.purchasePartyId,
    required this.purchasePartyName,
    required this.purNo,
    required this.purchaseDate,
    required this.totalAmount,
    required this.remarks,
    required this.serialNo,
    required this.purPurchaseDetails,
  });

  factory PurchaseModel.fromJson(Map<String, dynamic> json) {
    return PurchaseModel(
      id: json['id'] ?? 0,
      companyId: json['companyId'] ?? 0,
      purchasePartyId: json['purchasePartyId'] ?? 0,
      purchasePartyName: json['purchasePartyName'] ?? '',
      purNo: json['purNo'] ?? '',
      purchaseDate: json['purchaseDate'] != null
          ? DateTime.parse(json['purchaseDate'])
          : DateTime.now(),
      totalAmount: (json['totalAmount'] ?? 0).toDouble(),
      remarks: json['remarks'] ?? '',
      serialNo: json['serialNo'] ?? 0,
      purPurchaseDetails: (json['purPurchaseDetails'] as List?)
          ?.map((item) => PurchaseDetail.fromJson(item))
          .toList() ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'companyId': companyId,
      'purchasePartyId': purchasePartyId,
      'purchasePartyName': purchasePartyName,
      'purNo': purNo,
      'purchaseDate': purchaseDate.toIso8601String(),
      'totalAmount': totalAmount,
      'remarks': remarks,
      'serialNo': serialNo,
      'purPurchaseDetails': purPurchaseDetails.map((detail) => detail.toJson()).toList(),
    };
  }
}

class PurchaseDetail {
  final int id;
  final int purchaseMasterId;
  final String productDescription;
  final double amount;
  final String remarks;

  PurchaseDetail({
    required this.id,
    required this.purchaseMasterId,
    required this.productDescription,
    required this.amount,
    required this.remarks,
  });

  factory PurchaseDetail.fromJson(Map<String, dynamic> json) {
    return PurchaseDetail(
      id: json['id'] ?? 0,
      purchaseMasterId: json['purchaseMasterId'] ?? 0,
      productDescription: json['productDescription'] ?? '',
      amount: (json['amount'] ?? 0).toDouble(),
      remarks: json['remarks'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'purchaseMasterId': purchaseMasterId,
      'productDescription': productDescription,
      'amount': amount,
      'remarks': remarks,
    };
  }
}