import 'package:flutter/material.dart';
import 'package:salebook/features/home/presentation/Ui/home_screen.dart';
import 'features/createCompany/presentation/company_check_page.dart';
import 'features/createCompany/presentation/create_company_page.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Your App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const CompanyCheckPage(),
        '/home': (context) => const HomeScreen(),
        '/create-company': (context) => const CreateCompanyPage(),
      },
    );
  }
}