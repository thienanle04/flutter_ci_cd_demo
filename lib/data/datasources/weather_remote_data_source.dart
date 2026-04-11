import '../models/city_suggestion_model.dart';
import '../models/weather_model.dart';
import '../services/open_weather_service.dart';

abstract interface class WeatherRemoteDataSource {
  Future<WeatherModel> getCurrentByCity(String cityName);

  Future<WeatherModel> getCurrentByCoordinates(
    double latitude,
    double longitude,
  );

  Future<List<CitySuggestionModel>> searchCitySuggestions(String query);
}

final class OpenWeatherRemoteDataSource implements WeatherRemoteDataSource {
  const OpenWeatherRemoteDataSource({required OpenWeatherService service})
    : _service = service;

  final OpenWeatherService _service;

  @override
  Future<WeatherModel> getCurrentByCity(String cityName) async {
    final json = await _service.fetchCurrentByCity(cityName);
    return WeatherModel.fromOpenWeatherJson(json);
  }

  @override
  Future<WeatherModel> getCurrentByCoordinates(
    double latitude,
    double longitude,
  ) async {
    final json = await _service.fetchCurrentByLatLon(latitude, longitude);
    return WeatherModel.fromOpenWeatherJson(json);
  }

  @override
  Future<List<CitySuggestionModel>> searchCitySuggestions(String query) async {
    final raw = await _service.fetchGeoSuggestions(query);
    return raw.map(CitySuggestionModel.fromGeoJson).toList();
  }
}
