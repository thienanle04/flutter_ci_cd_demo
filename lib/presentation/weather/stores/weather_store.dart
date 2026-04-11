import 'package:mobx/mobx.dart';

import '../../../domain/entity/city_suggestion.dart';
import '../../../domain/usecases/get_current_weather_by_city.dart';
import '../../../domain/usecases/get_current_weather_by_coordinates.dart';
import '../../../domain/usecases/search_city_suggestions.dart';
import '../notifiers/weather_state.dart';
import 'i_weather_store.dart';

part 'weather_store.g.dart';

// ignore: library_private_types_in_public_api
class WeatherStore = _WeatherStore with _$WeatherStore;

abstract class _WeatherStore with Store implements IWeatherStore {
  _WeatherStore(
    this._getCurrentWeatherByCity,
    this._getCurrentWeatherByCoordinates,
    this._searchCitySuggestions,
  );

  final GetCurrentWeatherByCity _getCurrentWeatherByCity;
  final GetCurrentWeatherByCoordinates _getCurrentWeatherByCoordinates;
  final SearchCitySuggestions _searchCitySuggestions;

  @override
  @observable
  WeatherState state = const WeatherInitial();

  @override
  @observable
  ObservableList<CitySuggestion> citySuggestions =
      ObservableList<CitySuggestion>();

  @override
  @observable
  bool citySuggestionsLoading = false;

  @override
  @action
  void clearCitySuggestions() {
    citySuggestions.clear();
    citySuggestionsLoading = false;
  }

  @override
  @action
  Future<void> searchCitySuggestions(String query) async {
    final trimmed = query.trim();
    if (trimmed.length < 2) {
      clearCitySuggestions();
      return;
    }

    citySuggestionsLoading = true;

    try {
      final results = await _searchCitySuggestions(trimmed);
      citySuggestions
        ..clear()
        ..addAll(results);
    } catch (_) {
      citySuggestions.clear();
    }

    citySuggestionsLoading = false;
  }

  @override
  @action
  Future<void> fetchByCity(String cityName) async {
    clearCitySuggestions();
    state = const WeatherLoading();

    try {
      final weather = await _getCurrentWeatherByCity(cityName);
      state = WeatherSuccess(weather);
    } catch (e) {
      state = WeatherError(e.toString());
    }
  }

  @override
  @action
  Future<void> fetchByCoordinates(
    double latitude,
    double longitude, {
    String? displayCityName,
  }) async {
    clearCitySuggestions();
    state = const WeatherLoading();

    try {
      final weather = await _getCurrentWeatherByCoordinates(
        latitude,
        longitude,
        displayCityName: displayCityName,
      );
      state = WeatherSuccess(weather);
    } catch (e) {
      state = WeatherError(e.toString());
    }
  }
}
