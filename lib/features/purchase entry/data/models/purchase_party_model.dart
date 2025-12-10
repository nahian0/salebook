// lib/features/purchase/data/models/purchase_party_model.dart

class PurchasePartyModel {
  final int id;
  final int companyId;
  final String name;
  final String description;
  final String mobileNo;
  final String nid;
  final String address;
  final bool isActive;
  final bool isDelete;
  final String createdAt;
  final String updatedAt;
  final String createdBy;
  final String updatedBy;

  PurchasePartyModel({
    required this.id,
    required this.companyId,
    required this.name,
    required this.description,
    required this.mobileNo,
    required this.nid,
    required this.address,
    required this.isActive,
    required this.isDelete,
    required this.createdAt,
    required this.updatedAt,
    required this.createdBy,
    required this.updatedBy,
  });

  factory PurchasePartyModel.fromJson(Map<String, dynamic> json) {
    return PurchasePartyModel(
      id: json['id'] ?? 0,
      companyId: json['companyId'] ?? 0,
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      mobileNo: json['mobileNo'] ?? '',
      nid: json['nid'] ?? '',
      address: json['address'] ?? '',
      isActive: json['isActive'] ?? true,
      isDelete: json['isDelete'] ?? false,
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
      createdBy: json['createdBy'] ?? '',
      updatedBy: json['updatedBy'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'companyId': companyId,
      'name': name,
      'description': description,
      'mobileNo': mobileNo,
      'nid': nid,
      'address': address,
      'isActive': isActive,
      'isDelete': isDelete,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'createdBy': createdBy,
      'updatedBy': updatedBy,
    };
  }
}

class PurchasePartyResponse {
  final List<PurchasePartyModel> data;
  final String message;
  final int status;

  PurchasePartyResponse({
    required this.data,
    required this.message,
    required this.status,
  });

  factory PurchasePartyResponse.fromJson(Map<String, dynamic> json) {
    return PurchasePartyResponse(
      data: (json['data'] as List?)
          ?.map((item) => PurchasePartyModel.fromJson(item))
          .toList() ??
          [],
      message: json['message'] ?? '',
      status: json['status'] ?? 0,
    );
  }
}

class CreatePurchasePartyRequest {
  final String name;
  final String createdAt;
  final String updatedAt;
  final String createdBy;
  final String updatedBy;

  CreatePurchasePartyRequest({
    required this.name,
    required this.createdAt,
    required this.updatedAt,
    required this.createdBy,
    required this.updatedBy,
  });

  Map<String, dynamic> toJson() {
    return {
      'isActive': true,
      'isDelete': false,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'createdBy': createdBy,
      'updatedBy': updatedBy,
      'id': 0,
      'companyId': 0,
      'name': name,
      'description': 'string',
      'mobileNo': 'string',
      'nid': 'string',
      'address': 'string',
    };
  }
}