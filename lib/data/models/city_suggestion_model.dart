import '../../domain/entity/city_suggestion.dart';
import '../../utils/english_country_name.dart';

final class CitySuggestionModel {
  const CitySuggestionModel({
    required this.name,
    this.state,
    required this.countryCode,
    required this.countryName,
    required this.latitude,
    required this.longitude,
  });

  final String name;
  final String? state;
  final String countryCode;
  final String countryName;
  final double latitude;
  final double longitude;

  CitySuggestion toEntity() => CitySuggestion(
    name: name,
    state: state,
    countryCode: countryCode,
    countryName: countryName,
    latitude: latitude,
    longitude: longitude,
  );

  static CitySuggestionModel fromGeoJson(Map<String, Object?> json) {
    final name = (json['name'] as String?)?.trim();
    final country = (json['country'] as String?)?.trim();
    final lat = (json['lat'] as num?)?.toDouble();
    final lon = (json['lon'] as num?)?.toDouble();
    final stateRaw = (json['state'] as String?)?.trim();

    if (name == null || name.isEmpty) {
      throw const FormatException('Missing geocoding name');
    }
    if (country == null || country.isEmpty) {
      throw const FormatException('Missing geocoding country');
    }
    if (lat == null || lon == null) {
      throw const FormatException('Missing geocoding coordinates');
    }

    return CitySuggestionModel(
      name: name,
      state: (stateRaw != null && stateRaw.isNotEmpty) ? stateRaw : null,
      countryCode: country,
      countryName: englishCountryNameFromAlpha2(country),
      latitude: lat,
      longitude: lon,
    );
  }
}
