// lib/features/sales/presentation/bindings/sales_binding.dart

import 'package:get/get.dart';
import 'package:dio/dio.dart';
import '../../data/repository/sales_repository.dart';
import '../controller/sales_controller.dart';

class SalesBinding extends Bindings {
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
    Get.lazyPut<SalesRepository>(
          () => SalesRepository(dio: dio),
    );

    // Controller
    Get.lazyPut<SalesController>(
          () => SalesController(
        salesRepository: Get.find<SalesRepository>(),
      ),
    );
  }
}