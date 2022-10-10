import 'package:shared_preferences/shared_preferences.dart';

class HelperFunction {
  static String userLoggedInKey = "LOGGEDINKEY";
  static String userNameKey = "USERNAMEKEY";
  static String userEmailKey = "USEREMAIlKEY";

// saving the data sf
  static Future<bool> saveUserLoggedInStatus(bool isUserLoggedIn) async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return await sf.setBool(userLoggedInKey, isUserLoggedIn);
  }

  static Future<bool> saveUsernameSF(String username) async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return await sf.setString(userNameKey, username);
  }

  static Future<bool> saveUserEmailSF(String useremail) async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return await sf.setString(userEmailKey, useremail);
  }

//Getting the data From sf
  static Future<bool?> getUserLoggedInStatud() async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return sf.getBool(userLoggedInKey);
  }
}
