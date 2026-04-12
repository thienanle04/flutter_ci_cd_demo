import 'package:flutter_ci_cd_demo/domain/entity/weather_entity.dart';
import 'package:flutter_ci_cd_demo/domain/repository/weather_repository.dart';
import 'package:flutter_ci_cd_demo/domain/usecases/get_current_weather_by_city.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

final class _MockRepository extends Mock implements WeatherRepository {}

void main() {
  late _MockRepository repository;
  late GetCurrentWeatherByCity useCase;

  setUp(() {
    repository = _MockRepository();
    useCase = GetCurrentWeatherByCity(repository);
  });

  test('throws when city name is empty or whitespace', () async {
    await expectLater(() => useCase.call(''), throwsArgumentError);
    await expectLater(() => useCase.call('   '), throwsArgumentError);
    verifyNever(() => repository.getCurrentWeatherByCity(any()));
  });

  test('calls repository with trimmed city name', () async {
    const entity = WeatherEntity(
      cityName: 'London',
      temperatureC: 10,
      humidityPercent: 50,
      description: 'clouds',
    );
    when(
      () => repository.getCurrentWeatherByCity('London'),
    ).thenAnswer((_) async => entity);

    final result = await useCase.call('  London  ');

    expect(result, entity);
    verify(() => repository.getCurrentWeatherByCity('London')).called(1);
  });
}
