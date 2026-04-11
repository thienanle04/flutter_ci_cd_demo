import 'package:equatable/equatable.dart';

final class WeatherEntity extends Equatable {
  const WeatherEntity({
    required this.cityName,
    required this.temperatureC,
    required this.humidityPercent,
    required this.description,
  });

  final String cityName;
  final double temperatureC;
  final int humidityPercent;
  final String description;

  @override
  List<Object?> get props => <Object?>[
    cityName,
    temperatureC,
    humidityPercent,
    description,
  ];
}
