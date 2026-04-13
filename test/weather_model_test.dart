import 'package:flutter_ci_cd_demo/data/models/weather_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('fromOpenWeatherJson maps minimal valid payload', () {
    final model = WeatherModel.fromOpenWeatherJson(<String, Object?>{
      'name': 'Berlin',
      'main': <String, Object?>{'temp': 5.5, 'humidity': 70},
      'weather': <Object?>[
        <String, Object?>{'description': 'light rain'},
      ],
    });

    expect(model.cityName, 'Berlin');
    expect(model.temperatureC, 5.5);
    expect(model.humidityPercent, 70);
    expect(model.description, 'light rain');
  });

  test(
    'fromOpenWeatherJson uses N/A description when weather list missing',
    () {
      final model = WeatherModel.fromOpenWeatherJson(<String, Object?>{
        'name': 'Oslo',
        'main': <String, Object?>{'temp': 0.0, 'humidity': 80},
      });

      expect(model.description, 'N/A');
    },
  );

  test('fromOpenWeatherJson throws when city name missing', () {
    expect(
      () => WeatherModel.fromOpenWeatherJson(<String, Object?>{
        'main': <String, Object?>{'temp': 1.0, 'humidity': 1},
      }),
      throwsFormatException,
    );
  });

  test('fromOpenWeatherJson throws when main block missing', () {
    expect(
      () => WeatherModel.fromOpenWeatherJson(<String, Object?>{'name': 'X'}),
      throwsFormatException,
    );
  });

  test('fromOpenWeatherJson throws when temp or humidity missing', () {
    expect(
      () => WeatherModel.fromOpenWeatherJson(<String, Object?>{
        'name': 'X',
        'main': <String, Object?>{'temp': 1.0},
      }),
      throwsFormatException,
    );
    expect(
      () => WeatherModel.fromOpenWeatherJson(<String, Object?>{
        'name': 'X',
        'main': <String, Object?>{'humidity': 1},
      }),
      throwsFormatException,
    );
  });
}
