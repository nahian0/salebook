// lib/features/purchase/data/models/purchase_model.dart

class PurchaseModel {
  final int id;
  final int companyId;
  final int purchasePartyId;
  final String purchasePartyName;
  final String purNo;
  final DateTime purchaseDate;
  final double totalAmount;
  final String? remarks;
  final String? serialNo;
  final List<PurchaseDetailModel> purPurchaseDetails;
  final bool isActive;
  final bool isDelete;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final String createdBy;
  final String? updatedBy;

  PurchaseModel({
    required this.id,
    required this.companyId,
    required this.purchasePartyId,
    required this.purchasePartyName,
    required this.purNo,
    required this.purchaseDate,
    required this.totalAmount,
    this.remarks,
    this.serialNo,
    required this.purPurchaseDetails,
    required this.isActive,
    required this.isDelete,
    required this.createdAt,
    this.updatedAt,
    required this.createdBy,
    this.updatedBy,
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
      remarks: json['remarks'],
      serialNo: json['serialNo'],
      purPurchaseDetails: json['purPurchaseDetails'] != null
          ? (json['purPurchaseDetails'] as List)
          .map((e) => PurchaseDetailModel.fromJson(e))
          .toList()
          : [],
      isActive: json['isActive'] ?? true,
      isDelete: json['isDelete'] ?? false,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : null,
      createdBy: json['createdBy'] ?? 'System',
      updatedBy: json['updatedBy'],
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
      'purPurchaseDetails': purPurchaseDetails.map((e) => e.toJson()).toList(),
      'isActive': isActive,
      'isDelete': isDelete,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'createdBy': createdBy,
      'updatedBy': updatedBy,
    };
  }
}

class PurchaseDetailModel {
  final int id;
  final int purchaseMasterId;
  final String productDescription;
  final double amount;
  final String? remarks;
  final bool isActive;
  final bool isDelete;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final String createdBy;
  final String? updatedBy;

  PurchaseDetailModel({
    required this.id,
    required this.purchaseMasterId,
    required this.productDescription,
    required this.amount,
    this.remarks,
    required this.isActive,
    required this.isDelete,
    required this.createdAt,
    this.updatedAt,
    required this.createdBy,
    this.updatedBy,
  });

  factory PurchaseDetailModel.fromJson(Map<String, dynamic> json) {
    return PurchaseDetailModel(
      id: json['id'] ?? 0,
      purchaseMasterId: json['purchaseMasterId'] ?? 0,
      productDescription: json['productDescription'] ?? '',
      amount: (json['amount'] ?? 0).toDouble(),
      remarks: json['remarks'],
      isActive: json['isActive'] ?? true,
      isDelete: json['isDelete'] ?? false,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : null,
      createdBy: json['createdBy'] ?? 'System',
      updatedBy: json['updatedBy'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'purchaseMasterId': purchaseMasterId,
      'productDescription': productDescription,
      'amount': amount,
      'remarks': remarks,
      'isActive': isActive,
      'isDelete': isDelete,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'createdBy': createdBy,
      'updatedBy': updatedBy,
    };
  }
}