// lib/features/purchase/presentation/bindings/purchase_binding.dart

import 'package:get/get.dart';
import 'package:dio/dio.dart';

import '../../../purchase/data/repositories/purchase_repository.dart';
import '../../data/repositories/purchase_entry_repository.dart';
import '../controller/purchase_entry_controller.dart';

class PurchaseEntryBinding extends Bindings {
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
    Get.lazyPut<PurchaseEntryRepository>(
          () => PurchaseEntryRepository(dio: dio),
    );

    // Controller
    Get.lazyPut<PurchaseEntryController>(
          () => PurchaseEntryController(),
    );
  }
}