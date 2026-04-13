import 'package:flutter_ci_cd_demo/domain/entity/city_suggestion.dart';
import 'package:flutter_ci_cd_demo/domain/entity/weather_entity.dart';
import 'package:flutter_ci_cd_demo/domain/repository/weather_repository.dart';
import 'package:flutter_ci_cd_demo/domain/usecases/get_current_weather_by_city.dart';
import 'package:flutter_ci_cd_demo/domain/usecases/get_current_weather_by_coordinates.dart';
import 'package:flutter_ci_cd_demo/domain/usecases/search_city_suggestions.dart';
import 'package:flutter_ci_cd_demo/presentation/weather/notifiers/weather_state.dart';
import 'package:flutter_ci_cd_demo/presentation/weather/stores/weather_store.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

final class _MockRepository extends Mock implements WeatherRepository {}

void main() {
  late _MockRepository repository;
  late WeatherStore store;

  setUp(() {
    repository = _MockRepository();
    store = WeatherStore(
      GetCurrentWeatherByCity(repository),
      GetCurrentWeatherByCoordinates(repository),
      SearchCitySuggestions(repository),
    );
  });

  test('fetchByCity sets loading then success', () async {
    const weather = WeatherEntity(
      cityName: 'Rome',
      temperatureC: 18,
      humidityPercent: 55,
      description: 'sunny',
    );
    when(
      () => repository.getCurrentWeatherByCity('Rome'),
    ).thenAnswer((_) async => weather);

    final future = store.fetchByCity('Rome');
    expect(store.state, const WeatherLoading());
    await future;

    expect(store.state, isA<WeatherSuccess>());
    expect((store.state as WeatherSuccess).weather, weather);
    verify(() => repository.getCurrentWeatherByCity('Rome')).called(1);
  });

  test('fetchByCity sets error when repository throws', () async {
    when(
      () => repository.getCurrentWeatherByCity(any()),
    ).thenThrow(Exception('network'));

    await store.fetchByCity('Nowhere');

    expect(store.state, isA<WeatherError>());
    final WeatherError err = store.state as WeatherError;
    expect(err.message, contains('Exception'));
  });

  test('searchCitySuggestions clears when query is too short', () async {
    const suggestion = CitySuggestion(
      name: 'Lyon',
      state: null,
      countryCode: 'FR',
      countryName: 'France',
      latitude: 45.76,
      longitude: 4.83,
    );
    when(
      () => repository.searchCitySuggestions('Ly'),
    ).thenAnswer((_) async => <CitySuggestion>[suggestion]);

    await store.searchCitySuggestions('Ly');
    expect(store.citySuggestions, hasLength(1));

    await store.searchCitySuggestions('L');
    expect(store.citySuggestions, isEmpty);
    expect(store.citySuggestionsLoading, isFalse);
  });

  test('searchCitySuggestions clears list on error', () async {
    when(
      () => repository.searchCitySuggestions('Bad'),
    ).thenThrow(Exception('fail'));

    await store.searchCitySuggestions('Bad');

    expect(store.citySuggestions, isEmpty);
    expect(store.citySuggestionsLoading, isFalse);
  });
}
