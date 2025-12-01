class CompanyModel {
  final int id;
  final String name;
  final String phoneNo;
  final String description;
  final bool isActive;
  final bool isDelete;
  final String createdAt;
  final String updatedAt;
  final String createdBy;
  final String updatedBy;

  CompanyModel({
    required this.id,
    required this.name,
    required this.phoneNo,
    required this.description,
    required this.isActive,
    required this.isDelete,
    required this.createdAt,
    required this.updatedAt,
    required this.createdBy,
    required this.updatedBy,
  });

  factory CompanyModel.fromJson(Map<String, dynamic> json) {
    return CompanyModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      phoneNo: json['phoneNo'] ?? '',
      description: json['description'] ?? '',
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
      'name': name,
      'phoneNo': phoneNo,
      'description': description,
      'isActive': isActive,
      'isDelete': isDelete ? 1 : 0,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'createdBy': createdBy,
      'updatedBy': updatedBy,
    };
  }
}

class CompanyResponse {
  final List<CompanyModel> data;
  final String message;
  final int status;

  CompanyResponse({
    required this.data,
    required this.message,
    required this.status,
  });

  factory CompanyResponse.fromJson(Map<String, dynamic> json) {
    return CompanyResponse(
      data: (json['data'] as List<dynamic>?)
          ?.map((item) => CompanyModel.fromJson(item))
          .toList() ??
          [],
      message: json['message'] ?? '',
      status: json['status'] ?? 0,
    );
  }
}