import 'package:flutter/material.dart';

import '../../../domain/entity/weather_entity.dart';

final class WeatherCard extends StatelessWidget {
  const WeatherCard({super.key, required this.weather});

  final WeatherEntity weather;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(weather.cityName, style: theme.textTheme.headlineSmall),
            const SizedBox(height: 8),
            Text('Temp: ${weather.temperatureC.toStringAsFixed(1)} °C'),
            Text('Humidity: ${weather.humidityPercent}%'),
            Text('Conditions: ${weather.description}'),
          ],
        ),
      ),
    );
  }
}
