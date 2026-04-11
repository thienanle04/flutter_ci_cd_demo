import 'package:flutter/material.dart';
import 'package:flutter_ci_cd_demo/domain/entity/weather_entity.dart';
import 'package:flutter_ci_cd_demo/presentation/weather/notifiers/weather_state.dart';
import 'package:flutter_ci_cd_demo/presentation/weather/pages/weather_page.dart';
import 'package:flutter_ci_cd_demo/presentation/weather/stores/i_weather_store.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'fake_weather_store.dart';

void main() {
  setUpAll(() {
    // Initialize dotenv for widgets that read AppEnv (even if empty).
    dotenv.testLoad(fileInput: '');
  });

  testWidgets('WeatherPage renders success state', (WidgetTester tester) async {
    final store = FakeWeatherStore();
    store.setStateForTest(
      const WeatherSuccess(
        WeatherEntity(
          cityName: 'Paris',
          temperatureC: 21.0,
          humidityPercent: 50,
          description: 'clear sky',
        ),
      ),
    );

    await tester.pumpWidget(
      Provider<IWeatherStore>.value(
        value: store,
        child: const MaterialApp(home: WeatherPage()),
      ),
    );

    expect(find.text('Paris'), findsOneWidget);
    expect(find.textContaining('Temp:'), findsOneWidget);
    expect(find.textContaining('Humidity:'), findsOneWidget);
    expect(find.textContaining('Conditions:'), findsOneWidget);
  });
}
