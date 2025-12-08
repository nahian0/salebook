// lib/core/routes/app_routes.dart

import 'package:get/get.dart';
import '../../features/auth/presentation/ui/login_page.dart';
import '../../features/auth/presentation/ui/company_check_page.dart';
import '../../features/auth/presentation/ui/create_company_page.dart';
import '../../features/auth/presentation/ui/verify_code_page.dart';
import '../../features/home/presentation/Ui/home_screen.dart';
import '../../features/sales/presentation/bindings/sales_binding.dart';
import '../features/sales/presentation/ui/sales_screen.dart';

class AppRoutes {
  // Route names
  static const String initial = '/';
  static const String login = '/login';
  static const String createCompany = '/create-company';
  static const String verifyCode = '/verify-code';
  static const String home = '/home';
  static const String sales = '/sales';

  // All routes
  static List<GetPage> routes = [
    GetPage(
      name: initial,
      page: () => const CompanyCheckPage(),
      transition: Transition.fade,
    ),
    GetPage(
      name: login,
      page: () => const LoginPage(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: createCompany,
      page: () => const CreateCompanyPage(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: verifyCode,
      page: () => const VerifyCodePage(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: home,
      page: () => const HomeScreen(),
      transition: Transition.fadeIn,
    ),
    // Sales Route with Binding
    GetPage(
      name: sales,
      page: () => const SalesScreen(),
      binding: SalesBinding(), // Automatically injects dependencies
      transition: Transition.rightToLeft,
    ),
  ];
}