import 'package:flutter_ci_cd_demo/domain/entity/city_suggestion.dart';
import 'package:flutter_ci_cd_demo/presentation/weather/notifiers/weather_state.dart';
import 'package:flutter_ci_cd_demo/presentation/weather/stores/i_weather_store.dart';
import 'package:mobx/mobx.dart';

final class FakeWeatherStore implements IWeatherStore {
  FakeWeatherStore() {
    _state = Observable(const WeatherInitial());
    _citySuggestions = ObservableList<CitySuggestion>();
    _citySuggestionsLoading = Observable(false);
  }

  late final Observable<WeatherState> _state;
  late final ObservableList<CitySuggestion> _citySuggestions;
  late final Observable<bool> _citySuggestionsLoading;

  @override
  WeatherState get state => _state.value;

  @override
  List<CitySuggestion> get citySuggestions => _citySuggestions;

  @override
  bool get citySuggestionsLoading => _citySuggestionsLoading.value;

  void setStateForTest(WeatherState value) {
    runInAction(() => _state.value = value);
  }

  @override
  void clearCitySuggestions() {
    runInAction(() {
      _citySuggestions.clear();
      _citySuggestionsLoading.value = false;
    });
  }

  @override
  Future<void> fetchByCity(String cityName) async {}

  @override
  Future<void> fetchByCoordinates(
    double latitude,
    double longitude, {
    String? displayCityName,
  }) async {}

  @override
  Future<void> searchCitySuggestions(String query) async {}
}
