import 'package:flutter/material.dart';
import '../data/company_repository.dart';
import '../../../core/services/storage_service.dart';

class CompanyCheckPage extends StatefulWidget {
  const CompanyCheckPage({Key? key}) : super(key: key);

  @override
  State<CompanyCheckPage> createState() => _CompanyCheckPageState();
}

class _CompanyCheckPageState extends State<CompanyCheckPage> {
  final CompanyRepository _repository = CompanyRepository();

  @override
  void initState() {
    super.initState();
    _checkCompany();
  }

  Future<void> _checkCompany() async {
    try {
      // First check SharedPreferences
      final isLoggedIn = await StorageService.isLoggedIn();

      if (isLoggedIn) {
        // Already logged in, go to home
        if (mounted) {
          Navigator.pushReplacementNamed(context, '/home');
        }
        return;
      }

      // If not in SharedPreferences, check API
      final response = await _repository.getCompanies();

      if (response.data.isNotEmpty) {
        // Company exists, data saved in repository, navigate to home
        if (mounted) {
          Navigator.pushReplacementNamed(context, '/home');
        }
      } else {
        // No company, navigate to create company
        if (mounted) {
          Navigator.pushReplacementNamed(context, '/create-company');
        }
      }
    } catch (e) {
      // On error, show create company page
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/create-company');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Loading...'),
          ],
        ),
      ),
    );
  }
}