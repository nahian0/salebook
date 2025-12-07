import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salebook/features/home/presentation/Ui/home_screen.dart';
import '../features/auth/presentation/ui/company_check_page.dart';
import '../features/auth/presentation/ui/create_company_page.dart';
import '../features/auth/presentation/ui/login_page.dart';
import '../features/auth/presentation/ui/verify_code_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'SaleBook',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        primaryColor: const Color(0xFF6C63FF),
        scaffoldBackgroundColor: const Color(0xFFFAF6F1),
        fontFamily: 'Roboto',
      ),
      initialRoute: '/',
      getPages: [
        GetPage(
          name: '/',
          page: () => const CompanyCheckPage(),
          transition: Transition.fade,
        ),
        GetPage(
          name: '/login',
          page: () => const LoginPage(),
          transition: Transition.rightToLeft,
        ),
        GetPage(
          name: '/create-company',
          page: () => const CreateCompanyPage(),
          transition: Transition.rightToLeft,
        ),
        // ADD THIS ROUTE
        GetPage(
          name: '/verify-code',
          page: () => const VerifyCodePage(),
          transition: Transition.rightToLeft,
        ),
        GetPage(
          name: '/home',
          page: () => const HomeScreen(),
          transition: Transition.fadeIn,
        ),
      ],
    );
  }
}