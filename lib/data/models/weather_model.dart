import '../../domain/entity/weather_entity.dart';

final class WeatherModel {
  const WeatherModel({
    required this.cityName,
    required this.temperatureC,
    required this.humidityPercent,
    required this.description,
  });

  final String cityName;
  final double temperatureC;
  final int humidityPercent;
  final String description;

  WeatherEntity toEntity() => WeatherEntity(
    cityName: cityName,
    temperatureC: temperatureC,
    humidityPercent: humidityPercent,
    description: description,
  );

  static WeatherModel fromOpenWeatherJson(Map<String, Object?> json) {
    final name = (json['name'] as String?)?.trim();
    final main = json['main'];
    final weather = json['weather'];

    if (name == null || name.isEmpty) {
      throw const FormatException('Missing city name');
    }
    if (main is! Map) {
      throw const FormatException('Missing main weather fields');
    }

    final temp = (main['temp'] as num?)?.toDouble();
    final humidity = (main['humidity'] as num?)?.toInt();
    if (temp == null || humidity == null) {
      throw const FormatException('Missing temperature/humidity');
    }

    String description = 'N/A';
    if (weather is List && weather.isNotEmpty) {
      final first = weather.first;
      if (first is Map) {
        description = (first['description'] as String?)?.trim() ?? description;
      }
    }

    return WeatherModel(
      cityName: name,
      temperatureC: temp,
      humidityPercent: humidity,
      description: description,
    );
  }
}
