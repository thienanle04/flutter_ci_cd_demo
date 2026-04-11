import '../../../domain/entity/weather_entity.dart';

sealed class WeatherState {
  const WeatherState();
}

final class WeatherInitial extends WeatherState {
  const WeatherInitial();
}

final class WeatherLoading extends WeatherState {
  const WeatherLoading();
}

final class WeatherSuccess extends WeatherState {
  const WeatherSuccess(this.weather);
  final WeatherEntity weather;
}

final class WeatherError extends WeatherState {
  const WeatherError(this.message);
  final String message;
}
