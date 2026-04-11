import '../../../domain/entity/city_suggestion.dart';
import '../notifiers/weather_state.dart';

abstract class IWeatherStore {
  WeatherState get state;
  List<CitySuggestion> get citySuggestions;
  bool get citySuggestionsLoading;

  Future<void> fetchByCity(String cityName);
  Future<void> fetchByCoordinates(
    double latitude,
    double longitude, {
    String? displayCityName,
  });
  Future<void> searchCitySuggestions(String query);
  void clearCitySuggestions();
}
