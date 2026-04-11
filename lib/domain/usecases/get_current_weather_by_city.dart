import '../entity/weather_entity.dart';
import '../repository/weather_repository.dart';

final class GetCurrentWeatherByCity {
  const GetCurrentWeatherByCity(this._repository);

  final WeatherRepository _repository;

  Future<WeatherEntity> call(String cityName) async {
    final normalized = cityName.trim();
    if (normalized.isEmpty) {
      throw ArgumentError.value(
        cityName,
        'cityName',
        'City name cannot be empty',
      );
    }
    return _repository.getCurrentWeatherByCity(normalized);
  }
}
