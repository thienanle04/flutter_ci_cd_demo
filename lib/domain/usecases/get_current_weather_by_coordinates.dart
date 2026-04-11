import '../entity/weather_entity.dart';
import '../repository/weather_repository.dart';

final class GetCurrentWeatherByCoordinates {
  const GetCurrentWeatherByCoordinates(this._repository);

  final WeatherRepository _repository;

  Future<WeatherEntity> call(
    double latitude,
    double longitude, {
    String? displayCityName,
  }) async {
    if (!latitude.isFinite || !longitude.isFinite) {
      throw ArgumentError('Latitude and longitude must be finite numbers');
    }
    return _repository.getCurrentWeatherByCoordinates(
      latitude,
      longitude,
      displayCityName: displayCityName,
    );
  }
}
