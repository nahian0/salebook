import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static const String _companyIdKey = 'company_id';
  static const String _companyNameKey = 'company_name';
  static const String _isLoggedInKey = 'is_logged_in';

  static Future<SharedPreferences> _getPrefs() async {
    return await SharedPreferences.getInstance();
  }

  // Save company information
  static Future<bool> saveCompanyInfo({
    required int companyId,
    required String companyName,
  }) async {
    try {
      final prefs = await _getPrefs();
      await prefs.setInt(_companyIdKey, companyId);
      await prefs.setString(_companyNameKey, companyName);
      await prefs.setBool(_isLoggedInKey, true);
      return true;
    } catch (e) {
      return false;
    }
  }

  // Check if user is logged in (company exists)
  static Future<bool> isLoggedIn() async {
    try {
      final prefs = await _getPrefs();
      return prefs.getBool(_isLoggedInKey) ?? false;
    } catch (e) {
      return false;
    }
  }

  // Get company ID
  static Future<int?> getCompanyId() async {
    try {
      final prefs = await _getPrefs();
      return prefs.getInt(_companyIdKey);
    } catch (e) {
      return null;
    }
  }

  // Get company name
  static Future<String?> getCompanyName() async {
    try {
      final prefs = await _getPrefs();
      return prefs.getString(_companyNameKey);
    } catch (e) {
      return null;
    }
  }

  // Clear all data (logout)
  static Future<bool> clearCompanyInfo() async {
    try {
      final prefs = await _getPrefs();
      await prefs.remove(_companyIdKey);
      await prefs.remove(_companyNameKey);
      await prefs.setBool(_isLoggedInKey, false);
      return true;
    } catch (e) {
      return false;
    }
  }

  // Clear all SharedPreferences
  static Future<bool> clearAll() async {
    try {
      final prefs = await _getPrefs();
      await prefs.clear();
      return true;
    } catch (e) {
      return false;
    }
  }
}