/// A place returned from geocoding, used for autocomplete and precise weather lookup.
final class CitySuggestion {
  const CitySuggestion({
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

  /// English display name for [countryCode] (e.g. "United States").
  final String countryName;
  final double latitude;
  final double longitude;

  /// e.g. `Portland, Oregon, United States` or `London, United Kingdom`.
  String get displayLabel {
    final region = state?.trim();
    final country = countryName.trim();
    if (region != null && region.isNotEmpty) {
      return '$name, $region, $country';
    }
    return '$name, $country';
  }
}
