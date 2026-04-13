import 'package:flutter_ci_cd_demo/domain/entity/weather_entity.dart';
import 'package:flutter_ci_cd_demo/domain/repository/weather_repository.dart';
import 'package:flutter_ci_cd_demo/domain/usecases/get_current_weather_by_coordinates.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

final class _MockRepository extends Mock implements WeatherRepository {}

void main() {
  late _MockRepository repository;
  late GetCurrentWeatherByCoordinates useCase;

  setUp(() {
    repository = _MockRepository();
    useCase = GetCurrentWeatherByCoordinates(repository);
  });

  test('throws when latitude or longitude is not finite', () async {
    await expectLater(() => useCase.call(double.nan, 0), throwsArgumentError);
    await expectLater(
      () => useCase.call(0, double.infinity),
      throwsArgumentError,
    );
    verifyNever(() => repository.getCurrentWeatherByCoordinates(any(), any()));
  });

  test('forwards displayCityName to repository', () async {
    const entity = WeatherEntity(
      cityName: 'Paris',
      temperatureC: 20,
      humidityPercent: 40,
      description: 'clear',
    );
    when(
      () => repository.getCurrentWeatherByCoordinates(
        48.85,
        2.35,
        displayCityName: 'Paris, France',
      ),
    ).thenAnswer((_) async => entity);

    final result = await useCase.call(
      48.85,
      2.35,
      displayCityName: 'Paris, France',
    );

    expect(result, entity);
    verify(
      () => repository.getCurrentWeatherByCoordinates(
        48.85,
        2.35,
        displayCityName: 'Paris, France',
      ),
    ).called(1);
  });
}
