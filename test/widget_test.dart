// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_ci_cd_demo/presentation/weather/notifiers/weather_state.dart';
import 'package:flutter_ci_cd_demo/presentation/weather/pages/weather_page.dart';
import 'package:flutter_ci_cd_demo/presentation/weather/stores/i_weather_store.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'fake_weather_store.dart';

void main() {
  testWidgets('App boots and shows WeatherPage', (WidgetTester tester) async {
    dotenv.testLoad(fileInput: '');
    final store = FakeWeatherStore()..setStateForTest(const WeatherInitial());

    await tester.pumpWidget(
      Provider<IWeatherStore>.value(
        value: store,
        child: const MaterialApp(home: WeatherPage()),
      ),
    );
    expect(find.text('Weather (CI/CD Demo)'), findsOneWidget);
  });
}
