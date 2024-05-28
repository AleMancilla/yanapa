import 'package:shared_preferences/shared_preferences.dart';

class UserPreferences {
  static final UserPreferences _instancia = UserPreferences._internal();

  factory UserPreferences() {
    return _instancia;
  }

  UserPreferences._internal();

  late SharedPreferences _prefs;

  initPreferences() async {
    _prefs = await SharedPreferences.getInstance();
  }

  set userPermisionGeolocation(bool? status) =>
      _prefs.setBool('prefs_userPermisionGeolocation', status!);
  bool? get userPermisionGeolocation =>
      _prefs.getBool('prefs_userPermisionGeolocation');

  set userCheckOnBoarding(bool? status) =>
      _prefs.setBool('prefs_userCheckOnBoarding', status!);
  bool? get userCheckOnBoarding => _prefs.getBool('prefs_userCheckOnBoarding');
}
