import 'package:story_app_flutter/data/model/country_lang.dart';

class Localization {
  static CountryLang getLocale(String code) {
    switch (code) {
      case 'en':
        return CountryLang(
            flag: "🇺🇸", country: "(Eng) America", countryCode: 'en');
      case 'de':
        return CountryLang(flag: "🇩🇪", country: "Germany", countryCode: 'de');
      case 'id':
      default:
        return CountryLang(
            flag: "🇮🇩", country: "Indonesia", countryCode: "id");
    }
  }
}
