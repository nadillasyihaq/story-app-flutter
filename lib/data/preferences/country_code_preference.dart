import 'package:shared_preferences/shared_preferences.dart';

class CountryCodePreferences {
  final String countryCodeKey = "COUNTRY_CODE";

  Future<String> get getCurrentLocaleCountryCode async {
    final prefereces = await SharedPreferences.getInstance();
    return prefereces.getString(countryCodeKey) ?? "id";
  }

  void saveCurrentLocaleCountryCode(String code) async {
    final preferences = await SharedPreferences.getInstance();
    preferences.setString(countryCodeKey, code);
  }
}
