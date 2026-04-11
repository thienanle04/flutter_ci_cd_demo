import '../entity/city_suggestion.dart';
import '../entity/weather_entity.dart';

abstract interface class WeatherRepository {
  Future<WeatherEntity> getCurrentWeatherByCity(String cityName);

  Future<WeatherEntity> getCurrentWeatherByCoordinates(
    double latitude,
    double longitude, {
    String? displayCityName,
  });

  Future<List<CitySuggestion>> searchCitySuggestions(String query);
}
