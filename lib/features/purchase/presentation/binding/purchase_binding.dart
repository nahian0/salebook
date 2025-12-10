// lib/features/purchase/presentation/bindings/purchase_binding.dart

import 'package:get/get.dart';
import 'package:dio/dio.dart';
import '../../data/repositories/purchase_repository.dart';
import '../controller/purchase_controller.dart';

class PurchaseBinding extends Bindings {
  @override
  void dependencies() {
    // Dio instance with configuration
    final dio = Dio(
      BaseOptions(
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    // Add interceptors for logging (optional)
    dio.interceptors.add(
      LogInterceptor(
        request: true,
        requestHeader: true,
        requestBody: true,
        responseHeader: true,
        responseBody: true,
        error: true,
      ),
    );

    // Repository
    Get.lazyPut<PurchaseRepository>(
          () => PurchaseRepository(dio: dio),
    );

    // Controller
    Get.lazyPut<PurchaseController>(
          () => PurchaseController(
        purchaseRepository: Get.find<PurchaseRepository>(),
      ),
    );
  }
}