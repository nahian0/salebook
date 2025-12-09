// lib/features/sales/data/models/sales_model.dart

class SalesModel {
  final int id;
  final int companyId;
  final int salePartyId;
  final String salePartyName;
  final String saleNo;
  final DateTime saleDate;
  final double totalAmount;
  final String? remarks;
  final double depositAmount;
  final String? serialNo;
  final List<SalesDetailModel> salSalesDetails;
  final bool isActive;
  final bool isDelete;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final String createdBy;
  final String? updatedBy;

  SalesModel({
    required this.id,
    required this.companyId,
    required this.salePartyId,
    required this.salePartyName,
    required this.saleNo,
    required this.saleDate,
    required this.totalAmount,
    this.remarks,
    required this.depositAmount,
    this.serialNo,
    required this.salSalesDetails,
    required this.isActive,
    required this.isDelete,
    required this.createdAt,
    this.updatedAt,
    required this.createdBy,
    this.updatedBy,
  });

  factory SalesModel.fromJson(Map<String, dynamic> json) {
    return SalesModel(
      id: json['id'] ?? 0,
      companyId: json['companyId'] ?? 0,
      salePartyId: json['salePartyId'] ?? 0,
      salePartyName: json['salePartyName'] ?? '',
      saleNo: json['saleNo'] ?? '',
      saleDate: json['saleDate'] != null
          ? DateTime.parse(json['saleDate'])
          : DateTime.now(),
      totalAmount: (json['totalAmount'] ?? 0).toDouble(),
      remarks: json['remarks'],
      depositAmount: (json['depositAmount'] ?? 0).toDouble(),
      serialNo: json['serialNo'],
      salSalesDetails: json['salSalesDetails'] != null
          ? (json['salSalesDetails'] as List)
          .map((e) => SalesDetailModel.fromJson(e))
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
      'salePartyId': salePartyId,
      'salePartyName': salePartyName,
      'saleNo': saleNo,
      'saleDate': saleDate.toIso8601String(),
      'totalAmount': totalAmount,
      'remarks': remarks,
      'depositAmount': depositAmount,
      'serialNo': serialNo,
      'salSalesDetails': salSalesDetails.map((e) => e.toJson()).toList(),
      'isActive': isActive,
      'isDelete': isDelete,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'createdBy': createdBy,
      'updatedBy': updatedBy,
    };
  }
}

class SalesDetailModel {
  final int id;
  final int salesMasterId;
  final String productDescription;
  final double amount;
  final String? remarks;
  final bool isActive;
  final bool isDelete;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final String createdBy;
  final String? updatedBy;

  SalesDetailModel({
    required this.id,
    required this.salesMasterId,
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

  factory SalesDetailModel.fromJson(Map<String, dynamic> json) {
    return SalesDetailModel(
      id: json['id'] ?? 0,
      salesMasterId: json['salesMasterId'] ?? 0,
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
      'salesMasterId': salesMasterId,
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