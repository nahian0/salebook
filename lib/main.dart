// lib/main.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salebook/routes/app_routes.dart';

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
      getPages: AppRoutes.routes,
    );
  }
}