import 'package:mobile/utils/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesHelper {
  static const _uid = '_uid';
  static const _email = '_email';
  static const _shopId = '_shopId';

  static void setUserId(String userId) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString(_uid, userId);
    } catch (e) {
      logger.e(e);
    }
  }

  static void setEmail(String email) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString(_email, email);
    } catch (e) {
      logger.e(e);
    }
  }

  static void setShopId(String shopId) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString(_shopId, shopId);
    } catch (e) {
      logger.e(e);
    }
  }

  static Future<String?> getUserId() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      return prefs.getString(_uid);
    } catch (e) {
      return "";
    }
  }

  static Future<String?> getEmail() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      return prefs.getString(_email);
    } catch (e) {
      return "";
    }
  }

  static Future<String?> getShopId() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      return prefs.getString(_shopId);
    } catch (e) {
      return "";
    }
  }

  static Future<void> removeUserIdAndEmail() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.remove(_email);
      await prefs.remove(_uid);
      await prefs.remove(_shopId);
    } catch (e) {
      logger.e(e);
    }
  }
}
