import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:story_app_flutter/data/preferences/country_code_preference.dart';

class LocalizationProvider extends ChangeNotifier {
  final CountryCodePreferences ccPrefs;

  LocalizationProvider({required this.ccPrefs}) {
    _getCurrentLocale();
  }

  Locale _locale = const Locale('id');
  Locale get locale => _locale;

  void _getCurrentLocale() async {
    final countryCode = await ccPrefs.getCurrentLocaleCountryCode;
    _locale = Locale(countryCode);
    notifyListeners();
  }

  void setLocale(String countryCode) async {
    ccPrefs.saveCurrentLocaleCountryCode(countryCode);
    _getCurrentLocale();
  }
}
