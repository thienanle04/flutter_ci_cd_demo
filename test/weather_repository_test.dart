import 'package:flutter_ci_cd_demo/data/datasources/weather_remote_data_source.dart';
import 'package:flutter_ci_cd_demo/data/models/weather_model.dart';
import 'package:flutter_ci_cd_demo/data/repositories/weather_repository_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

final class _MockRemoteDataSource extends Mock
    implements WeatherRemoteDataSource {}

void main() {
  test('WeatherRepositoryImpl maps WeatherModel to WeatherEntity', () async {
    final remote = _MockRemoteDataSource();
    final repo = WeatherRepositoryImpl(remoteDataSource: remote);

    when(() => remote.getCurrentByCity('London')).thenAnswer(
      (_) async => const WeatherModel(
        cityName: 'London',
        temperatureC: 12.3,
        humidityPercent: 66,
        description: 'overcast clouds',
      ),
    );

    final result = await repo.getCurrentWeatherByCity('London');

    expect(result.cityName, 'London');
    expect(result.temperatureC, 12.3);
    expect(result.humidityPercent, 66);
    expect(result.description, 'overcast clouds');
    verify(() => remote.getCurrentByCity('London')).called(1);
  });
}
