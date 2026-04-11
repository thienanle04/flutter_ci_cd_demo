import 'package:dio/dio.dart';

final class OpenWeatherService {
  const OpenWeatherService(this._dio);

  final Dio _dio;

  static const String _geoDirectUrl =
      'https://api.openweathermap.org/geo/1.0/direct';

  Future<Map<String, Object?>> fetchCurrentByCity(String cityName) async {
    final response = await _dio.get<Object?>(
      '/weather',
      queryParameters: <String, Object?>{'q': cityName},
    );

    return _parseObjectResponse(response.data);
  }

  Future<Map<String, Object?>> fetchCurrentByLatLon(
    double latitude,
    double longitude,
  ) async {
    final response = await _dio.get<Object?>(
      '/weather',
      queryParameters: <String, Object?>{
        'lat': latitude,
        'lon': longitude,
      },
    );

    return _parseObjectResponse(response.data);
  }

  Future<List<Map<String, Object?>>> fetchGeoSuggestions(
    String query, {
    int limit = 5,
  }) async {
    final trimmed = query.trim();
    if (trimmed.isEmpty) return <Map<String, Object?>>[];

    final response = await _dio.get<Object?>(
      _geoDirectUrl,
      queryParameters: <String, Object?>{'q': trimmed, 'limit': limit},
    );

    final data = response.data;
    if (data is! List) {
      throw const FormatException('Unexpected geocoding response');
    }

    final out = <Map<String, Object?>>[];
    for (final item in data) {
      if (item is Map<String, Object?>) {
        out.add(item);
      } else if (item is Map) {
        out.add(item.map((k, v) => MapEntry(k.toString(), v)));
      }
    }
    return out;
  }

  Map<String, Object?> _parseObjectResponse(Object? data) {
    if (data is Map<String, Object?>) return data;
    if (data is Map) {
      return data.map((key, value) => MapEntry(key.toString(), value));
    }
    throw const FormatException('Unexpected API response');
  }
}
