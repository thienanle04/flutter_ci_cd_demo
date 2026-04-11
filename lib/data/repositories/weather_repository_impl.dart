import '../../domain/entity/city_suggestion.dart';
import '../../domain/entity/weather_entity.dart';
import '../../domain/repository/weather_repository.dart';
import '../datasources/weather_remote_data_source.dart';

final class WeatherRepositoryImpl implements WeatherRepository {
  const WeatherRepositoryImpl({
    required WeatherRemoteDataSource remoteDataSource,
  }) : _remoteDataSource = remoteDataSource;

  final WeatherRemoteDataSource _remoteDataSource;

  @override
  Future<WeatherEntity> getCurrentWeatherByCity(String cityName) async {
    final model = await _remoteDataSource.getCurrentByCity(cityName);
    return model.toEntity();
  }

  @override
  Future<WeatherEntity> getCurrentWeatherByCoordinates(
    double latitude,
    double longitude, {
    String? displayCityName,
  }) async {
    final model = await _remoteDataSource.getCurrentByCoordinates(
      latitude,
      longitude,
    );
    final entity = model.toEntity();
    final label = displayCityName?.trim();
    if (label != null && label.isNotEmpty) {
      return WeatherEntity(
        cityName: label,
        temperatureC: entity.temperatureC,
        humidityPercent: entity.humidityPercent,
        description: entity.description,
      );
    }
    return entity;
  }

  @override
  Future<List<CitySuggestion>> searchCitySuggestions(String query) async {
    final models = await _remoteDataSource.searchCitySuggestions(query);
    return models.map((m) => m.toEntity()).toList();
  }
}
