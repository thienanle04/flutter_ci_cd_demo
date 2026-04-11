import 'package:sealed_countries/sealed_countries.dart';

/// English common name for an ISO 3166-1 alpha-2 code, or [code] if unknown.
String englishCountryNameFromAlpha2(String code) {
  final trimmed = code.trim().toUpperCase();
  if (trimmed.length != 2) return code.trim();
  final country = WorldCountry.maybeFromCodeShort(trimmed);
  return country?.name.common ?? trimmed;
}
