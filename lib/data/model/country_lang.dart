
import 'package:json_annotation/json_annotation.dart';

part 'country_lang.g.dart';

@JsonSerializable()
class CountryLang {
  final String flag;
  final String country;
  final String countryCode;

  CountryLang({
    required this.flag,
    required this.country,
    required this.countryCode,
  });

  factory CountryLang.fromJson(Map<String, dynamic> json) => _$CountryLangFromJson(json);

  Map<String, dynamic> toJson() => _$CountryLangToJson(this);
}